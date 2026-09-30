package com.mnl.eduportal.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Email sending utility for ATPOLY Portal
 * Production-ready email service with hardcoded production credentials
 * No dependency on external configuration files
 * 
 * @author eduportal
 */
public class EmailService {
    
    private static final Logger logger = Logger.getLogger(EmailService.class.getName());
    
    // Production email configuration for ATPOLY - hardcoded for reliability
    private final EmailSettings emailSettings;
    
    public EmailService() {
        // Initialize with production credentials
        this.emailSettings = new EmailSettings(
            "mail.benuestate.gov.ng",    // host
            "465",                        // port
            "lands@benuestate.gov.ng",   // username
            "adminlands%%"               // password
        );
    }
    
    /**
     * Sends email using production SMTP settings
     * Follows the same pattern as existing MailClient.sendNow() method
     * 
     * @param to Recipient email address
     * @param subject Email subject
     * @param body Email body content
     * @param isHtml Whether the body is HTML formatted
     * @return "Yes" if email sent successfully, "No" otherwise (matching MailClient pattern)
     */
    public String sendEmail(String to, String subject, String body, boolean isHtml) {
        String result = "No";
        
        try {
            Properties props = System.getProperties();
            props.put("mail.smtp.host", emailSettings.getHost());
            props.put("mail.smtp.port", emailSettings.getPort());
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.socketFactory.port", emailSettings.getPort());
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
            props.put("mail.smtp.user", emailSettings.getEmailusername());
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(emailSettings.getEmailusername(), emailSettings.getPassword());
                }
            });
            
            MimeMessage message = new MimeMessage(session);
            message.setSubject(subject);
            message.setFrom(new InternetAddress(emailSettings.getEmailusername(), "Akawe Torkula Polytechnic Portal"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            
            if (isHtml) {
                message.setContent(body, "text/html; charset=utf-8");
            } else {
                message.setText(body, "UTF-8");
            }
            
            Transport.send(message);
            logger.log(Level.INFO, "Email sent successfully to: {0}", to);
            result = "Yes";
            
        } catch (MessagingException | UnsupportedEncodingException e) {
            logger.log(Level.SEVERE, "Failed to send email to: " + to + " - " + e.getMessage(), e);
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }
    
    /**
     * Sends password reset email with professional template
     * Returns boolean for easier integration with PasswordResetSession
     * 
     * @param email Recipient email
     * @param resetToken Reset token
     * @param username User's username
     * @param baseUrl Application base URL
     * @return true if sent successfully
     */
    public boolean sendPasswordResetEmail(String email, String resetToken, String username, String baseUrl) {
        String subject = "Password Reset - ATPOLY Portal";
        String resetUrl = baseUrl + "/reset-password.jsp?token=" + resetToken;
        
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("<!DOCTYPE html>");
        emailBody.append("<html lang='en'>");
        emailBody.append("<head>");
        emailBody.append("<meta charset='UTF-8'>");
        emailBody.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        emailBody.append("<title>Password Reset - ATPOLY Portal</title>");
        emailBody.append("<style>");
        emailBody.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }");
        emailBody.append(".container { max-width: 600px; margin: 0 auto; padding: 20px; }");
        emailBody.append(".header { background-color: #f8f9fa; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }");
        emailBody.append(".content { background-color: white; padding: 30px; border: 1px solid #dee2e6; }");
        emailBody.append(".footer { background-color: #f8f9fa; padding: 20px; text-align: center; border-radius: 0 0 8px 8px; border-top: 1px solid #dee2e6; }");
        emailBody.append(".btn { display: inline-block; background-color: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }");
        emailBody.append(".btn:hover { background-color: #0056b3; }");
        emailBody.append(".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }");
        emailBody.append(".warning-text { color: #856404; margin: 0; font-size: 14px; }");
        emailBody.append("</style>");
        emailBody.append("</head>");
        emailBody.append("<body>");
        
        emailBody.append("<div class='container'>");
        emailBody.append("<div class='header'>");
        emailBody.append("<img src='").append(baseUrl).append("/assets/img/Akawe.png' ");
        emailBody.append("style='height: 60px; width: auto;' alt='ATPOLY Logo'/>");
        emailBody.append("<h2 style='color: #333; margin: 20px 0;'>Password Reset Request</h2>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='content'>");
        emailBody.append("<p>Hello <strong>").append(username).append("</strong>,</p>");
        emailBody.append("<p>We received a request to reset your password for your ATPOLY Portal account. ");
        emailBody.append("If you made this request, click the button below to reset your password:</p>");
        
        emailBody.append("<div style='text-align: center;'>");
        emailBody.append("<a href='").append(resetUrl).append("' class='btn'>Reset Password</a>");
        emailBody.append("</div>");
        
        emailBody.append("<p style='color: #666; font-size: 14px;'>");
        emailBody.append("If the button doesn't work, copy and paste this link into your browser:<br>");
        emailBody.append("<a href='").append(resetUrl).append("' style='color: #007bff; word-break: break-all;'>");
        emailBody.append(resetUrl).append("</a>");
        emailBody.append("</p>");
        
        emailBody.append("<div class='warning'>");
        emailBody.append("<p class='warning-text'>");
        emailBody.append("<strong>Security Notice:</strong> This link will expire in 30 minutes. ");
        emailBody.append("If you didn't request this password reset, please ignore this email. ");
        emailBody.append("Your password will remain unchanged.");
        emailBody.append("</p>");
        emailBody.append("</div>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='footer'>");
        emailBody.append("<p style='color: #6c757d; font-size: 12px; margin: 0;'>");
        emailBody.append("This email was sent from Akawe Torkula Polytechnic Portal<br>");
        emailBody.append("If you have questions, please contact our support team.");
        emailBody.append("</p>");
        emailBody.append("</div>");
        emailBody.append("</div>");
        
        emailBody.append("</body>");
        emailBody.append("</html>");
        
        String result = sendEmail(email, subject, emailBody.toString(), true);
        return "Yes".equals(result);
    }
    
    /**
     * Sends email verification email to user
     * 
     * @param email User's email address
     * @param verificationToken Verification token
     * @param username User's username
     * @param baseUrl Application base URL
     * @return true if sent successfully
     */
    public boolean sendVerificationEmail(String email, String verificationToken, String username, String baseUrl) {
        String subject = "Email Verification - ATPOLY Portal";
        String verificationUrl = baseUrl + "/verify-email.jsp?token=" + verificationToken;
        
        StringBuilder emailBody = new StringBuilder();
        emailBody.append("<!DOCTYPE html>");
        emailBody.append("<html lang='en'>");
        emailBody.append("<head>");
        emailBody.append("<meta charset='UTF-8'>");
        emailBody.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        emailBody.append("<title>Email Verification - ATPOLY Portal</title>");
        emailBody.append("<style>");
        emailBody.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }");
        emailBody.append(".container { max-width: 600px; margin: 0 auto; padding: 20px; }");
        emailBody.append(".header { background-color: #f8f9fa; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }");
        emailBody.append(".content { background-color: white; padding: 30px; border: 1px solid #dee2e6; }");
        emailBody.append(".footer { background-color: #f8f9fa; padding: 20px; text-align: center; border-radius: 0 0 8px 8px; border-top: 1px solid #dee2e6; }");
        emailBody.append(".btn { display: inline-block; background-color: #28a745; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; margin: 20px 0; }");
        emailBody.append(".btn:hover { background-color: #218838; }");
        emailBody.append(".warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; }");
        emailBody.append(".warning-text { color: #856404; margin: 0; font-size: 14px; }");
        emailBody.append("</style>");
        emailBody.append("</head>");
        emailBody.append("<body>");
        
        emailBody.append("<div class='container'>");
        emailBody.append("<div class='header'>");
        emailBody.append("<img src='").append(baseUrl).append("/assets/img/Akawe.png' ");
        emailBody.append("style='height: 60px; width: auto;' alt='ATPOLY Logo'/>");
        emailBody.append("<h2 style='color: #333; margin: 20px 0;'>Email Verification Required</h2>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='content'>");
        emailBody.append("<p>Hello <strong>").append(username).append("</strong>,</p>");
        emailBody.append("<p>Welcome to ATPOLY Portal! To complete your account setup and ensure the security of your account, ");
        emailBody.append("please verify your email address by clicking the button below:</p>");
        
        emailBody.append("<div style='text-align: center;'>");
        emailBody.append("<a href='").append(verificationUrl).append("' class='btn'>Verify Email Address</a>");
        emailBody.append("</div>");
        
        emailBody.append("<p style='color: #666; font-size: 14px;'>");
        emailBody.append("If the button doesn't work, copy and paste this link into your browser:<br>");
        emailBody.append("<a href='").append(verificationUrl).append("' style='color: #007bff; word-break: break-all;'>");
        emailBody.append(verificationUrl).append("</a>");
        emailBody.append("</p>");
        
        emailBody.append("<div class='warning'>");
        emailBody.append("<p class='warning-text'>");
        emailBody.append("<strong>Important:</strong> This verification link will expire in 24 hours. ");
        emailBody.append("You must verify your email address before you can log in to your account.");
        emailBody.append("</p>");
        emailBody.append("</div>");
        
        emailBody.append("<p>If you didn't create an account with ATPOLY Portal, please ignore this email.</p>");
        emailBody.append("</div>");
        
        emailBody.append("<div class='footer'>");
        emailBody.append("<p style='margin: 0; color: #666; font-size: 12px;'>");
        emailBody.append("This is an automated message from ATPOLY Portal. Please do not reply to this email.");
        emailBody.append("</p>");
        emailBody.append("<p style='margin: 5px 0 0 0; color: #666; font-size: 12px;'>");
        emailBody.append("© 2024 Akawe Torkula Polytechnic. All rights reserved.");
        emailBody.append("</p>");
        emailBody.append("</div>");
        
        emailBody.append("</div>");
        emailBody.append("</body>");
        emailBody.append("</html>");
        
        String result = sendEmail(email, subject, emailBody.toString(), true);
        return "Yes".equals(result);
    }
    
    /**
     * Get the current email settings
     * @return EmailSettings object with current configuration
     */
    public EmailSettings getEmailSettings() {
        return emailSettings;
    }
}