package com.mnl.eduportal.resources;

import com.mnl.eduportal.dto.ApiResponse;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.PasswordResetSession;
import jakarta.ejb.EJB;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * REST Resource for password reset functionality
 * Handles forgot password requests and password reset operations
 * 
 * @author eduportal
 */
@Path("/password-reset")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PasswordResetResource {
    
    private static final Logger logger = Logger.getLogger(PasswordResetResource.class.getName());
    
    @EJB
    private PasswordResetSession passwordResetSession;
    
    /**
     * Initiates password reset process
     * POST /apis/password-reset/request
     */
    @POST
    @Path("/request")
    public Response requestPasswordReset(Map<String, String> request) {
        try {
            String email = request.get("email");
            
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Email address is required"))
                    .build();
            }
            
            String result = passwordResetSession.initiatePasswordReset(email.trim());
            
            // Always return success message for security (don't reveal if email exists)
            Map<String, Object> data = new HashMap<>();
            data.put("success", true);
            data.put("message", result);
            
            return Response.ok(ApiResponse.success(data, result)).build();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in password reset request", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred. Please try again later"))
                .build();
        }
    }
    
    /**
     * Validates reset token
     * GET /apis/password-reset/validate/{token}
     */
    @GET
    @Path("/validate/{token}")
    public Response validateToken(@PathParam("token") String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Reset token is required"))
                    .build();
            }
            
            Users user = passwordResetSession.validateResetToken(token);
            
            if (user != null) {
                Map<String, Object> data = new HashMap<>();
                data.put("valid", true);
                data.put("username", user.getUsername());
                data.put("success", true);
                return Response.ok(ApiResponse.success(data, "Token is valid")).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Invalid or expired reset token"))
                    .build();
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error validating reset token: " + token, e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while validating token"))
                .build();
        }
    }
    
    /**
     * Resets password using valid token
     * POST /apis/password-reset/reset
     */
    @POST
    @Path("/reset")
    public Response resetPassword(Map<String, String> request) {
        try {
            String token = request.get("token");
            String newPassword = request.get("password");
            String confirmPassword = request.get("confirmPassword");
            
            // Validate inputs
            if (token == null || token.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Reset token is required"))
                    .build();
            }
            
            if (newPassword == null || newPassword.length() < 6) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Password must be at least 6 characters long"))
                    .build();
            }
            
            if (!newPassword.equals(confirmPassword)) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Passwords do not match"))
                    .build();
            }
            
            String result = passwordResetSession.resetPassword(token, newPassword);
            
            if (result.contains("successfully")) {
                Map<String, Object> data = new HashMap<>();
                data.put("success", true);
                data.put("message", result);
                return Response.ok(ApiResponse.success(data, result)).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, result))
                    .build();
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resetting password", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while resetting password"))
                .build();
        }
    }
}