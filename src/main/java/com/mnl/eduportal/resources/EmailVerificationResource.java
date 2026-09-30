package com.mnl.eduportal.resources;

import com.mnl.eduportal.dto.ApiResponse;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.EmailVerificationSession;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * REST Resource for email verification functionality
 * Handles verification email resending and verification status checks
 * 
 * @author eduportal
 */
@Path("/email-verification")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EmailVerificationResource {
    
    private static final Logger logger = Logger.getLogger(EmailVerificationResource.class.getName());
    
    @EJB
    private EmailVerificationSession emailVerificationSession;
    
    @EJB
    private MainSession mainSession;
    
    private Settings settings = new Settings();
    
    /**
     * Resends verification email to user via GET request
     * GET /apis/email-verification/resend/{email}
     */
    @GET
    @Path("/resend/{email}")
    public Response resendVerificationEmailGet(@PathParam("email") String email) {
        try {
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Email address is required")
                    .build();
            }
            
            // Find user by email
            Users user = mainSession.getUsersByEmail(email.trim().toLowerCase());
            if (user == null) {
                // Don't reveal if email exists for security - redirect back with message
                try {
                    return Response.temporaryRedirect(
                        java.net.URI.create(settings.baseurl + "/?message=" + java.net.URLEncoder.encode("If an account with this email exists, a verification email will be sent", "UTF-8"))
                    ).build();
                } catch (UnsupportedEncodingException ex) {
                    return Response.temporaryRedirect(
                        java.net.URI.create(settings.baseurl + "/?message=Request processed")
                    ).build();
                }
            }
            
            // Check if already verified
            if (user.isEmailVerified()) {
                try {
                    return Response.temporaryRedirect(
                        java.net.URI.create(settings.baseurl + "/?message=" + java.net.URLEncoder.encode("Email address is already verified", "UTF-8"))
                    ).build();
                } catch (UnsupportedEncodingException ex) {
                    return Response.temporaryRedirect(
                        java.net.URI.create(settings.baseurl + "/?message=Email already verified")
                    ).build();
                }
            }
            
            String result = emailVerificationSession.sendVerificationEmail(user.getId());
            
            String message = result.contains("sent") ? 
                "Verification email has been sent. Please check your inbox." : 
                "Failed to send verification email. Please try again.";
                
            try {
                return Response.temporaryRedirect(
                    java.net.URI.create(settings.baseurl + "/?message=" + java.net.URLEncoder.encode(message, "UTF-8"))
                ).build();
            } catch (UnsupportedEncodingException ex) {
                return Response.temporaryRedirect(
                    java.net.URI.create(settings.baseurl + "/?message=Verification email sent")
                ).build();
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resending verification email", e);
            try {
                return Response.temporaryRedirect(
                    java.net.URI.create(settings.baseurl + "/?message=" + java.net.URLEncoder.encode("An error occurred. Please try again later.", "UTF-8"))
                ).build();
            } catch (UnsupportedEncodingException ex) {
                return Response.temporaryRedirect(
                    java.net.URI.create(settings.baseurl + "/?message=An error occurred")
                ).build();
            }
        }
    }
    
    /**
     * Resends verification email to user
     * POST /apis/email-verification/resend
     */
    @POST
    @Path("/resend")
    public Response resendVerificationEmail(Map<String, String> request) {
        try {
            String email = request.get("email");
            
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Email address is required"))
                    .build();
            }
            
            // Find user by email
            Users user = mainSession.getUsersByEmail(email.trim().toLowerCase());
            if (user == null) {
                // Don't reveal if email exists for security
                Map<String, Object> data = new HashMap<>();
                data.put("success", true);
                data.put("message", "If an account with this email exists, a verification email will be sent");
                return Response.ok(ApiResponse.success(data, "Request processed")).build();
            }
            
            // Check if already verified
            if (user.isEmailVerified()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Email address is already verified"))
                    .build();
            }
            
            String result = emailVerificationSession.sendVerificationEmail(user.getId());
            
            Map<String, Object> data = new HashMap<>();
            data.put("success", result.contains("sent"));
            data.put("message", result);
            
            return Response.ok(ApiResponse.success(data, result)).build();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resending verification email", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred. Please try again later"))
                .build();
        }
    }
    
    /**
     * Checks verification status of an email
     * GET /apis/email-verification/status/{email}
     */
    @GET
    @Path("/status/{email}")
    public Response checkVerificationStatus(@PathParam("email") String email) {
        try {
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Email address is required"))
                    .build();
            }
            
            Users user = mainSession.getUsersByEmail(email.trim().toLowerCase());
            
            Map<String, Object> data = new HashMap<>();
            if (user != null) {
                data.put("exists", true);
                data.put("verified", user.isEmailVerified());
                data.put("verifiedAt", user.getEmailVerifiedAt());
                data.put("username", user.getUsername());
            } else {
                data.put("exists", false);
                data.put("verified", false);
            }
            
            return Response.ok(ApiResponse.success(data, "Status retrieved")).build();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error checking verification status for email: " + email, e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while checking status"))
                .build();
        }
    }
    
    /**
     * Validates verification token (for AJAX calls)
     * GET /apis/email-verification/validate/{token}
     */
    @GET
    @Path("/validate/{token}")
    public Response validateVerificationToken(@PathParam("token") String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Verification token is required"))
                    .build();
            }
            
            EmailVerificationSession.VerificationResult result = emailVerificationSession.validateVerificationToken(token);
            
            Map<String, Object> data = new HashMap<>();
            data.put("valid", result.isValid());
            data.put("status", result.getStatus());
            data.put("message", result.getMessage());
            
            if (result.getUser() != null) {
                data.put("username", result.getUser().getUsername());
                data.put("email", result.getUser().getEmail());
            }
            
            if (result.isValid()) {
                return Response.ok(ApiResponse.success(data, "Token is valid")).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ApiResponse<>(400, result.getMessage(), data))
                    .build();
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error validating verification token: " + token, e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while validating token"))
                .build();
        }
    }
    
    /**
     * Verifies email using token (for AJAX calls)
     * POST /apis/email-verification/verify
     */
    @POST
    @Path("/verify")
    public Response verifyEmail(Map<String, String> request) {
        try {
            String token = request.get("token");
            
            if (token == null || token.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Verification token is required"))
                    .build();
            }
            
            String result = emailVerificationSession.verifyEmail(token);
            
            Map<String, Object> data = new HashMap<>();
            data.put("success", result.contains("successfully"));
            data.put("message", result);
            
            if (result.contains("successfully")) {
                return Response.ok(ApiResponse.success(data, result)).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, result))
                    .build();
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error verifying email", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while verifying email"))
                .build();
        }
    }
}