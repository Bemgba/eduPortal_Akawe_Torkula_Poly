package com.mnl.eduportal.sessions;

import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.util.EmailService;
import com.mnl.eduportal.util.Settings;
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
 * Session Bean for handling email verification functionality
 * Manages verification tokens and email verification process
 * 
 * @author eduportal
 */
@Stateless
public class EmailVerificationSession {
    
    private static final Logger logger = Logger.getLogger(EmailVerificationSession.class.getName());
    private static final int VERIFICATION_TOKEN_EXPIRY_HOURS = 24; // 24 hours for verification
    
    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;
    
    private Settings settings = new Settings();
    
    /**
     * Sends verification email to user
     * 
     * @param userId User ID
     * @return Success message or error details
     */
    @Transactional
    public String sendVerificationEmail(String userId) {
        try {
            Users user = em.find(Users.class, userId);
            if (user == null) {
                return "User not found";
            }
            
            if (user.isEmailVerified()) {
                return "Email is already verified";
            }
            
            // Generate verification token
            String verificationToken = generateVerificationToken();
            Date expiryTime = calculateExpiryTime();
            
            // Update user with verification token
            user.setVerificationToken(verificationToken);
            user.setVerificationTokenExpiration(expiryTime);
            user.setLastVerificationSentAt(new Date());
            user.setUpdatedAt(new Date());
            
            em.merge(user);
            em.flush();
            
            logger.log(Level.INFO, "Verification token created for user: {0}, expires at: {1}", 
                      new Object[]{user.getUsername(), expiryTime});
            
            // Send verification email
            boolean emailSent = sendVerificationEmailToUser(user.getEmail(), verificationToken, user.getUsername());
            
            if (emailSent) {
                logger.log(Level.INFO, "Verification email sent to: {0}", user.getEmail());
                return "Verification email has been sent to your email address";
            } else {
                // Clear token if email failed
                user.setVerificationToken(null);
                user.setVerificationTokenExpiration(null);
                em.merge(user);
                em.flush();
                return "Failed to send verification email. Please try again later";
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending verification email for user: " + userId, e);
            return "An error occurred. Please try again later";
        }
    }
    
    /**
     * Validates verification token with detailed error information
     * 
     * @param token Verification token from email link
     * @return VerificationResult with user and specific error details
     */
    public VerificationResult validateVerificationToken(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return new VerificationResult(null, "MISSING_TOKEN", "No verification token provided");
            }
            
            TypedQuery<Users> query = em.createNamedQuery("Users.findByVerificationToken", Users.class);
            query.setParameter("verificationToken", token.trim());
            
            Users user;
            try {
                user = query.getSingleResult();
            } catch (NoResultException e) {
                return new VerificationResult(null, "INVALID_TOKEN", "Invalid verification token");
            }
            
            // Check if already verified
            if (user.isEmailVerified()) {
                return new VerificationResult(user, "ALREADY_VERIFIED", "Email is already verified");
            }
            
            // Check if token has expired
            if (user.isVerificationTokenExpired()) {
                return new VerificationResult(user, "EXPIRED_TOKEN", "Verification token has expired");
            }
            
            // Check if account is deleted
            if (user.isDeleted()) {
                return new VerificationResult(user, "DELETED_USER", "User account has been deleted");
            }
            
            return new VerificationResult(user, "VALID", "Token is valid");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error validating verification token: " + token, e);
            return new VerificationResult(null, "SYSTEM_ERROR", "System error occurred during validation");
        }
    }
    
    /**
     * Verifies user email using valid token
     * 
     * @param token Verification token
     * @return Success or error message
     */
    @Transactional
    public String verifyEmail(String token) {
        try {
            VerificationResult result = validateVerificationToken(token);
            
            if (!result.isValid()) {
                return result.getMessage();
            }
            
            Users user = result.getUser();
            
            // Mark email as verified
            user.setEmailVerifiedAt(new Date());
            user.setVerificationToken(null); // Clear the token
            user.setVerificationTokenExpiration(null);
            user.setUpdatedAt(new Date());
            
            // Ensure user status is ACTIVE
            if (!"ACTIVE".equals(user.getStatus())) {
                user.setStatus("ACTIVE");
            }
            
            em.merge(user);
            em.flush();
            
            logger.log(Level.INFO, "Email verified successfully for user: {0} (email: {1})", 
                      new Object[]{user.getUsername(), user.getEmail()});
            
            return "Email has been verified successfully";
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error verifying email for token: " + token, e);
            return "An error occurred while verifying email. Please try again";
        }
    }
    
    /**
     * Checks if user can login (email verified and account not locked)
     * 
     * @param user User entity
     * @return LoginEligibilityResult with status and message
     */
    public LoginEligibilityResult checkLoginEligibility(Users user) {
        if (user == null) {
            return new LoginEligibilityResult(false, "USER_NOT_FOUND", "User not found");
        }
        
        if (user.isDeleted()) {
            return new LoginEligibilityResult(false, "DELETED_USER", "Account has been deleted");
        }
        
        if (!"ACTIVE".equals(user.getStatus())) {
            return new LoginEligibilityResult(false, "INACTIVE_USER", "Account is not active");
        }
        
        if (!user.isEmailVerified()) {
            return new LoginEligibilityResult(false, "EMAIL_NOT_VERIFIED", "Email not verified");
        }
        
        if (user.isAccountLocked()) {
            return new LoginEligibilityResult(false, "ACCOUNT_LOCKED", "Account is temporarily locked");
        }
        
        return new LoginEligibilityResult(true, "ELIGIBLE", "User can login");
    }
    
    /**
     * Records failed login attempt and locks account if necessary
     * 
     * @param userId User ID
     * @return Updated failed attempts count
     */
    @Transactional
    public int recordFailedLoginAttempt(String userId) {
        try {
            Users user = em.find(Users.class, userId);
            if (user != null) {
                int attempts = (user.getFailedLoginAttempts() != null ? user.getFailedLoginAttempts() : 0) + 1;
                user.setFailedLoginAttempts(attempts);
                
                // Lock account after 5 failed attempts for 30 minutes
                if (attempts >= 5) {
                    Calendar lockUntil = Calendar.getInstance();
                    lockUntil.add(Calendar.MINUTE, 30);
                    user.setLockedUntil(lockUntil.getTime());
                    logger.log(Level.WARNING, "Account locked for user: {0} after {1} failed attempts", 
                              new Object[]{user.getUsername(), attempts});
                }
                
                user.setUpdatedAt(new Date());
                em.merge(user);
                em.flush();
                
                return attempts;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error recording failed login attempt for user: " + userId, e);
        }
        return 0;
    }
    
    /**
     * Resets failed login attempts on successful login
     * 
     * @param userId User ID
     */
    @Transactional
    public void resetFailedLoginAttempts(String userId) {
        try {
            Users user = em.find(Users.class, userId);
            if (user != null) {
                user.setFailedLoginAttempts(0);
                user.setLockedUntil(null);
                user.setLastLoginAt(new Date());
                user.setUpdatedAt(new Date());
                em.merge(user);
                em.flush();
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error resetting failed login attempts for user: " + userId, e);
        }
    }
    
    /**
     * Generates cryptographically secure verification token
     */
    private String generateVerificationToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }
    
    /**
     * Calculates token expiry time (24 hours from now)
     */
    private Date calculateExpiryTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR, VERIFICATION_TOKEN_EXPIRY_HOURS);
        return calendar.getTime();
    }
    
    /**
     * Sends verification email to user
     */
    private boolean sendVerificationEmailToUser(String email, String token, String username) {
        try {
            EmailService emailService = new EmailService();
            return emailService.sendVerificationEmail(email, token, username, settings.baseurl);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending verification email to: " + email, e);
            return false;
        }
    }
    
    /**
     * Inner class to hold verification results
     */
    public static class VerificationResult {
        private final Users user;
        private final String status;
        private final String message;
        
        public VerificationResult(Users user, String status, String message) {
            this.user = user;
            this.status = status;
            this.message = message;
        }
        
        public Users getUser() { return user; }
        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public boolean isValid() { return "VALID".equals(status); }
        public boolean isExpired() { return "EXPIRED_TOKEN".equals(status); }
        public boolean isAlreadyVerified() { return "ALREADY_VERIFIED".equals(status); }
        public boolean isInvalid() { return "INVALID_TOKEN".equals(status); }
        public boolean isMissing() { return "MISSING_TOKEN".equals(status); }
    }
    
    /**
     * Inner class to hold login eligibility results
     */
    public static class LoginEligibilityResult {
        private final boolean eligible;
        private final String status;
        private final String message;
        
        public LoginEligibilityResult(boolean eligible, String status, String message) {
            this.eligible = eligible;
            this.status = status;
            this.message = message;
        }
        
        public boolean isEligible() { return eligible; }
        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public boolean isEmailNotVerified() { return "EMAIL_NOT_VERIFIED".equals(status); }
        public boolean isAccountLocked() { return "ACCOUNT_LOCKED".equals(status); }
    }
}