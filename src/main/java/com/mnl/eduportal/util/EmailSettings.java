package com.mnl.eduportal.util;

/**
 * Email configuration settings for the educational portal
 * Used to configure SMTP settings for sending emails
 * 
 * @author eduportal
 */
public class EmailSettings {
    private String host;
    private String port;
    private String emailusername;
    private String password;

    public EmailSettings() {
    }

    public EmailSettings(String host, String port, String emailusername, String password) {
        this.host = host;
        this.port = port;
        this.emailusername = emailusername;
        this.password = password;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getEmailusername() {
        return emailusername;
    }

    public void setEmailusername(String emailusername) {
        this.emailusername = emailusername;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}