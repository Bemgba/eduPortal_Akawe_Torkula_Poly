package com.mnl.eduportal.resources;
import com.mnl.eduportal.dto.ApiResponse;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import jakarta.ejb.EJB;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * REST Resource for updating user email addresses
 * Specifically for users uploaded without email (e.g., JAMB applicants)
 * 
 * @author Bemgba
 */
@Path("/user-email")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserEmailUpdateResource {
    private static final Logger logger = Logger.getLogger(UserEmailUpdateResource.class.getName());
    @EJB
    private MainSession mainSession;
    /**
     * Updates user email address by username
     * POST /apis/user-email/update
     *
     * Request body: { "username": "user123", "email": "user@example.com" }
     */   
    @POST
    @Path("/update")
    public Response updateUserEmail(Map<String, String> requestData) {
        try {
            String username = requestData.get("username");
            String email = requestData.get("email");
            
            // Validate input
            if (username == null || username.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Username is required"))
                    .build();
            }
            
            if (email == null || email.trim().isEmpty()) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Email address is required"))
                    .build();
            }
            
            // Validate email format
            if (!isValidEmail(email.trim())) {
                return Response.status(Response.Status.BAD_REQUEST)
                    .entity(ApiResponse.error(400, "Invalid email format"))
                    .build();
            }
            
            // Find user by username
            Users user = mainSession.getUsersByUsername(username.trim().toLowerCase());
            if (user == null) {
                return Response.status(Response.Status.NOT_FOUND)
                    .entity(ApiResponse.error(404, "User not found"))
                    .build();
            }
            
            // Check if email is already in use by another user
            Users existingUser = mainSession.getUsersByEmail(email.trim().toLowerCase());
            if (existingUser != null && !existingUser.getId().equals(user.getId())) {
                return Response.status(Response.Status.CONFLICT)
                    .entity(ApiResponse.error(409, "Email address is already in use by another account"))
                    .build();
            }
            
            // Update user email using direct JPQL update
            int rowsUpdated = mainSession.updateUserEmailDirect(user.getId(), email.trim().toLowerCase());
            
            if (rowsUpdated == 0) {
                logger.log(Level.WARNING, "No rows updated for user: {0}", username);
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error(500, "Failed to update email address"))
                    .build();
            }
            
            logger.log(Level.INFO, "Email updated successfully for user: {0} (rows updated: {1})", new Object[]{username, rowsUpdated});
            
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("message", "Email address updated successfully. Please login again.");
            
            return Response.ok(ApiResponse.success(responseData, "Email address updated successfully")).build();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating user email", e);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                .entity(ApiResponse.error(500, "An error occurred while updating email address"))
                .build();
        }
    }
    
    /**
     * Validates email format
     */
    private boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }
}
