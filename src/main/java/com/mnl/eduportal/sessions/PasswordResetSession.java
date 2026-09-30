package com.mnl.eduportal.sessions;

import com.mnl.eduportal.entities.PasswordResetToken;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.util.EmailService;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Session Bean for handling password reset functionality
 * Uses separate PasswordResetToken table to avoid modifying Users table
 * 
 * @author eduportal
 */
@Stateless
public class PasswordResetSession {
    
    private static final Logger logger = Logger.getLogger(PasswordResetSession.class.getName());
    private static final int TOKEN_EXPIRY_MINUTES = 30;
    
    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;
    
    @EJB
    private MainSession mainSession;
    
    private Settings settings = new Settings();
    
    /**
     * Initiates password reset process by generating token and sending email
     * 
     * @param email User's email address
     * @return Success message or error details
     */
    @Transactional
    public String initiatePasswordReset(String email) {
        try {
            // Validate email format
            if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
                return "Invalid email address format";
            }
            
            // Find user by email and ensure account is active
            Users user = findActiveUserByEmail(email.trim().toLowerCase());
            if (user == null) {
                // Don't reveal if email exists for security
                return "If an account with this email exists, you will receive a password reset link";
            }
            
            // Generate secure reset token
            String resetToken = generateSecureToken();
            Date expiryTime = calculateExpiryTime();
            
            // Clear any existing tokens for this user
            clearExistingTokens(user.getId());
            
            // Create new password reset token and persist it
            PasswordResetToken tokenEntity = new PasswordResetToken(user.getId(), resetToken, expiryTime);
            em.persist(tokenEntity);
            em.flush(); // Ensure token is persisted immediately
            
            logger.log(Level.INFO, "Password reset token created for user: {0}, token expires at: {1}", 
                      new Object[]{user.getUsername(), expiryTime});
            
            // Send reset email
            boolean emailSent = sendResetEmail(email, resetToken, user.getUsername());
            
            if (emailSent) {
                logger.log(Level.INFO, "Password reset email sent to: {0}", email);
                return "Password reset link has been sent to your email address";
            } else {
                // Remove token if email failed
                em.remove(tokenEntity);
                em.flush();
                return "Failed to send reset email. Please try again later";
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initiating password reset for email: " + email, e);
            return "An error occurred. Please try again later";
        }
    }
    
    /**
     * Validates reset token and returns associated user
     * 
     * @param token Reset token from email link
     * @return User if token is valid, null otherwise
     */
    public Users validateResetToken(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return null;
            }
            
            TypedQuery<PasswordResetToken> query = em.createNamedQuery("PasswordResetToken.findByToken", PasswordResetToken.class);
            query.setParameter("token", token.trim());
            
            PasswordResetToken tokenEntity = query.getSingleResult();
            
            // Check if token has expired
            if (tokenEntity.getExpiryTime().before(new Date())) {
                // Token expired, remove it
                em.remove(tokenEntity);
                return null;
            }
            
            // Check if token has been used
            if (tokenEntity.getUsed()) {
                return null;
            }
            
            // Get the user
            Users user = em.find(Users.class, tokenEntity.getUserId());
            
            // Check if account is still active
            if (user == null || !"ACTIVE".equals(user.getStatus())) {
                return null;
            }
            
            return user;
            
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error validating reset token: " + token, e);
            return null;
        }
    }
    
    /**
     * Validates reset token with detailed error information
     * 
     * @param token Reset token from email link
     * @return TokenValidationResult with user and specific error details
     */
    public TokenValidationResult validateResetTokenDetailed(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return new TokenValidationResult(null, "MISSING_TOKEN", "No reset token provided");
            }
            
            TypedQuery<PasswordResetToken> query = em.createNamedQuery("PasswordResetToken.findByToken", PasswordResetToken.class);
            query.setParameter("token", token.trim());
            
            PasswordResetToken tokenEntity;
            try {
                tokenEntity = query.getSingleResult();
            } catch (NoResultException e) {
                return new TokenValidationResult(null, "INVALID_TOKEN", "Invalid reset token");
            }
            
            // Check if token has expired
            if (tokenEntity.getExpiryTime().before(new Date())) {
                // Token expired, remove it
                em.remove(tokenEntity);
                em.flush();
                return new TokenValidationResult(null, "EXPIRED_TOKEN", "Reset token has expired");
            }
            
            // Check if token has been used
            if (tokenEntity.getUsed()) {
                return new TokenValidationResult(null, "USED_TOKEN", "Reset token has already been used");
            }
            
            // Get the user
            Users user = em.find(Users.class, tokenEntity.getUserId());
            
            // Check if account is still active
            if (user == null) {
                return new TokenValidationResult(null, "USER_NOT_FOUND", "User account not found");
            }
            
            if (!"ACTIVE".equals(user.getStatus())) {
                return new TokenValidationResult(null, "INACTIVE_USER", "User account is not active");
            }
            
            return new TokenValidationResult(user, "VALID", "Token is valid");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error validating reset token: " + token, e);
            return new TokenValidationResult(null, "SYSTEM_ERROR", "System error occurred during validation");
        }
    }
    
    /**
     * Inner class to hold token validation results
     */
    public static class TokenValidationResult {
        private final Users user;
        private final String status;
        private final String message;
        
        public TokenValidationResult(Users user, String status, String message) {
            this.user = user;
            this.status = status;
            this.message = message;
        }
        
        public Users getUser() { return user; }
        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public boolean isValid() { return "VALID".equals(status); }
        public boolean isExpired() { return "EXPIRED_TOKEN".equals(status); }
        public boolean isUsed() { return "USED_TOKEN".equals(status); }
        public boolean isInvalid() { return "INVALID_TOKEN".equals(status); }
        public boolean isMissing() { return "MISSING_TOKEN".equals(status); }
    }
    
    /**
     * Resets user password and marks token as used
     * Uses the existing MainSession.updatePassword() method
     * 
     * @param token Reset token
     * @param newPassword New password
     * @return Success or error message
     */
    @Transactional
    public String resetPassword(String token, String newPassword) {
        try {
            // Validate inputs
            if (token == null || token.trim().isEmpty()) {
                return "Invalid reset token";
            }
            
            if (newPassword == null || newPassword.length() < 6) {
                return "Password must be at least 6 characters long";
            }
            
            // Find and validate token
            TypedQuery<PasswordResetToken> query = em.createNamedQuery("PasswordResetToken.findByToken", PasswordResetToken.class);
            query.setParameter("token", token.trim());
            
            PasswordResetToken tokenEntity;
            try {
                tokenEntity = query.getSingleResult();
                logger.log(Level.INFO, "Found password reset token for user: {0}", tokenEntity.getUserId());
            } catch (NoResultException e) {
                logger.log(Level.WARNING, "Password reset token not found: {0}", token);
                return "Invalid or expired reset token";
            }
            
            // Check if token has expired
            if (tokenEntity.getExpiryTime().before(new Date())) {
                logger.log(Level.INFO, "Password reset token expired for user: {0}", tokenEntity.getUserId());
                em.remove(tokenEntity);
                em.flush();
                return "Reset token has expired";
            }
            
            // Check if token has been used
            if (tokenEntity.getUsed()) {
                logger.log(Level.WARNING, "Password reset token already used for user: {0}", tokenEntity.getUserId());
                return "Reset token has already been used";
            }
            
            // Get the user to verify account is still active
            Users user = em.find(Users.class, tokenEntity.getUserId());
            if (user == null || !"ACTIVE".equals(user.getStatus())) {
                logger.log(Level.WARNING, "Invalid user account for password reset: {0}", tokenEntity.getUserId());
                return "Invalid user account";
            }
            
            // Save the new password as raw text (no encryption)
            String rawPassword = newPassword;
            
            // Use the existing MainSession.updatePassword() method with raw password
            mainSession.updatePassword(user.getId(), rawPassword);
            
            logger.log(Level.INFO, "Password reset with raw text for user: {0}", user.getUsername());
            
            // Mark token as used
            tokenEntity.setUsed(true);
            em.merge(tokenEntity);
            em.flush();
            
            logger.log(Level.INFO, "Password reset successful for user: {0} (email: {1})", 
                      new Object[]{user.getUsername(), user.getEmail()});
            return "Password has been reset successfully";
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resetting password for token: " + token, e);
            return "An error occurred while resetting password. Please try again";
        }
    }
    
    /**
     * Finds active user by email using basic query
     */
    private Users findActiveUserByEmail(String email) {
        try {
            TypedQuery<Users> query = em.createQuery(
                "SELECT u FROM Users u WHERE u.email = :email AND (u.status = :status OR u.status IS NULL)", 
                Users.class);
            query.setParameter("email", email);
            query.setParameter("status", "ACTIVE");
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
    
    /**
     * Clears any existing tokens for a user
     */
    @Transactional
    private void clearExistingTokens(String userId) {
        try {
            TypedQuery<PasswordResetToken> query = em.createNamedQuery("PasswordResetToken.findByUserId", PasswordResetToken.class);
            query.setParameter("userId", userId);
            
            for (PasswordResetToken token : query.getResultList()) {
                em.remove(token);
            }
            em.flush(); // Ensure tokens are removed immediately
            logger.log(Level.INFO, "Cleared existing password reset tokens for user: {0}", userId);
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error clearing existing tokens for user: " + userId, e);
        }
    }
    
    /**
     * Generates cryptographically secure reset token
     */
    private String generateSecureToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }
    
    /**
     * Calculates token expiry time (30 minutes from now)
     */
    private Date calculateExpiryTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, TOKEN_EXPIRY_MINUTES);
        return calendar.getTime();
    }
    
    /**
     * Sends password reset email to user using production email service
     */
    private boolean sendResetEmail(String email, String token, String username) {
        try {
            EmailService emailService = new EmailService();
            return emailService.sendPasswordResetEmail(email, token, username, settings.baseurl);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending reset email to: " + email, e);
            return false;
        }
    }
    
    /**
     * Basic email validation
     */
    private boolean isValidEmail(String email) {
        return email != null && 
               email.contains("@") && 
               email.contains(".") && 
               email.length() > 5 &&
               !email.startsWith("@") &&
               !email.endsWith("@");
    }
}