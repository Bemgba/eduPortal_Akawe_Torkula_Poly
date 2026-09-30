/*
 * CREDO Payment Verification Response Class
 * Matches CREDO's actual API response format
 */
package com.mnl.eduportal.util;

/**
 * CREDO-specific payment verification response class
 * Designed to match CREDO's actual API response structure
 * @author BEMGBA
 */
public class CredoVerificationResponse {
    
    private int status;           // CREDO sends status as number (200, 400, etc.)
    private String message;       // CREDO message
    private CredoData data;       // CREDO data object
    private int execTime;         // CREDO execution time
    private Object error;         // CREDO error object (can be array or object)
    
    // Inner class for CREDO data structure
    public static class CredoData {
        private String reference;
        private String credoReference;
        private String status;        // Payment status (success, failed, etc.)
        private double amount;
        private double fee;
        private double debitAmount;
        private String currency;
        private String gateway_response;
        private String channel;
        private String createdAt;
        private String updatedAt;
        
        // Getters and setters for data fields
        public String getReference() { return reference; }
        public void setReference(String reference) { this.reference = reference; }
        
        public String getCredoReference() { return credoReference; }
        public void setCredoReference(String credoReference) { this.credoReference = credoReference; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        
        public double getAmount() { return amount; }
        public void setAmount(double amount) { this.amount = amount; }
        
        public double getFee() { return fee; }
        public void setFee(double fee) { this.fee = fee; }
        
        public double getDebitAmount() { return debitAmount; }
        public void setDebitAmount(double debitAmount) { this.debitAmount = debitAmount; }
        
        public String getCurrency() { return currency; }
        public void setCurrency(String currency) { this.currency = currency; }
        
        public String getGateway_response() { return gateway_response; }
        public void setGateway_response(String gateway_response) { this.gateway_response = gateway_response; }
        
        public String getChannel() { return channel; }
        public void setChannel(String channel) { this.channel = channel; }
        
        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
        
        public String getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(String updatedAt) { this.updatedAt = updatedAt; }
    }
    
    // Default constructor
    public CredoVerificationResponse() {
    }
    
    // Main getters and setters
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public CredoData getData() { return data; }
    public void setData(CredoData data) { this.data = data; }
    
    public int getExecTime() { return execTime; }
    public void setExecTime(int execTime) { this.execTime = execTime; }
    
    public Object getError() { return error; }
    public void setError(Object error) { this.error = error; }
    
    // Utility methods for payment verification
    public boolean isSuccessful() {
        // CREDO success conditions:
        // 1. HTTP status 200 AND
        // 2. Payment status is "success" OR status is "0" (successful) OR status is 0 (number)
        if (status == 200 && data != null) {
            String paymentStatus = data.getStatus();
            // Check for various success indicators
            return "success".equalsIgnoreCase(paymentStatus) || 
                   "0".equals(paymentStatus) || 
                   "successful".equalsIgnoreCase(paymentStatus) ||
                   "completed".equalsIgnoreCase(paymentStatus) ||
                   "paid".equalsIgnoreCase(paymentStatus);
        }
        // Also check if status is 200 and message indicates success
        if (status == 200 && message != null) {
            return message.toLowerCase().contains("success") || 
                   message.toLowerCase().contains("successful") ||
                   message.toLowerCase().contains("completed");
        }
        return false;
    }
    
    public String getPaymentReference() {
        return data != null ? data.getReference() : null;
    }
    
    public String getCredoReference() {
        return data != null ? data.getCredoReference() : null;
    }
    
    public double getPaymentAmount() {
        return data != null ? data.getAmount() : 0.0;
    }
    
    public String getPaymentStatus() {
        return data != null ? data.getStatus() : "unknown";
    }
    
    public String getResponseDescription() {
        if (data != null && data.getGateway_response() != null) {
            return data.getGateway_response();
        }
        return message != null ? message : "No description available";
    }
    
    public String getResponseCode() {
        return String.valueOf(status);
    }
}