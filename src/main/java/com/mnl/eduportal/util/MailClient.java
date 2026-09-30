package com.mnl.eduportal.util;

import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.activation.FileDataSource;
import jakarta.mail.Authenticator;
import jakarta.mail.BodyPart;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import java.util.*;

/**
 * Mail client utility for sending emails in the educational portal
 * Supports both plain text and HTML emails with optional attachments
 * Uses hardcoded production credentials - no properties file dependency
 * 
 * @author eduportal
 */
public class MailClient {

    private String senderemail = "lands@benuestate.gov.ng";
    private String senderpassword = "adminlands%%";
    private String attachment;
    private String toemail;
    private String subject;
    private String message;
    private boolean isHtml = false;

    public MailClient() {
        // Default constructor for backward compatibility
    }

    public MailClient(String senderemail, String senderpassword, String toemail, String subject, String message) {
        this.senderemail = senderemail;
        this.senderpassword = senderpassword;
        this.toemail = toemail;
        this.subject = subject;
        this.message = message;
    }

    public MailClient(String toemail, String subject, String message) {
        this.toemail = toemail;
        this.subject = subject;
        this.message = message;
    }

    public MailClient(String toemail, String subject, String message, String attachment) {
        this.toemail = toemail;
        this.subject = subject;
        this.message = message;
        this.attachment = attachment;
    }

    public MailClient(String toemail, String subject, String message, boolean isHtml) {
        this.toemail = toemail;
        this.subject = subject;
        this.message = message;
        this.isHtml = isHtml;
    }

    public String sendNow() {
        String result = "No";
        
        // Use hardcoded production credentials - no properties file needed
        String d_host = "mail.benuestate.gov.ng";
        String d_ports = "465";
        senderemail = "lands@benuestate.gov.ng";
        senderpassword = "adminlands%%";
        
        Properties props = System.getProperties();
        props.put("mail.smtp.host", d_host);
        props.put("mail.smtp.port", d_ports);
        props.put("mail.smtp.auth", "true");
        
        // Configure SSL for port 465
        if ("465".equals(d_ports)) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.socketFactory.port", d_ports);
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.socketFactory.fallback", "true");
        }
        
        props.put("mail.smtp.user", senderemail);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderemail, senderpassword);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setSubject(subject);
            msg.setFrom(new InternetAddress(senderemail, "Akawe Torkula Polytechnic"));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(toemail));

            if (attachment != null && !attachment.isEmpty()) {
                // Create multipart message with attachment
                Multipart multipart = new MimeMultipart();
                
                // Message body part
                BodyPart messageBodyPart = new MimeBodyPart();
                if (isHtml) {
                    messageBodyPart.setContent(message, "text/html; charset=utf-8");
                } else {
                    messageBodyPart.setText(message);
                }
                multipart.addBodyPart(messageBodyPart);

                // Attachment part
                messageBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(attachment);
                messageBodyPart.setDataHandler(new DataHandler(source));
                String[] filena = attachment.split("/");
                String filen = filena[filena.length - 1];
                messageBodyPart.setFileName(filen);
                multipart.addBodyPart(messageBodyPart);

                msg.setContent(multipart);
            } else {
                // Simple message without attachment
                if (isHtml) {
                    msg.setContent(message, "text/html; charset=utf-8");
                } else {
                    msg.setText(message);
                }
            }

            Transport.send(msg);
            result = "Yes";
        } catch (Exception e) {
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }
    
    /**
     * Legacy method for backward compatibility with existing code
     * Sends email with attachment using the old method signature
     * 
     * @param email Recipient email
     * @param cc CC email (not used in current implementation)
     * @param bcc BCC email (not used in current implementation)
     * @param subject Email subject
     * @param message Email message
     * @param label Email label (not used in current implementation)
     * @return "Yes" if successful, "No" if failed
     */
    public String sendEmailWithAttachment(String email, String cc, String bcc, String subject, String message, String label) {
        this.toemail = email;
        this.subject = subject;
        this.message = message;
        this.isHtml = true; // Assume HTML for legacy compatibility
        
        return sendNow();
    }
}