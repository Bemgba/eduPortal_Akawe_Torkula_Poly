/*
 * CREDO Payment Notification Response Model
 * Replaces PaymentNotification.java for CREDO responses
 */
package com.mnl.eduportal.util;

/**
 * CREDO Payment Response Model
 * @author eaglescan
 */
public class CredoPaymentNotification {
    
    private boolean status;
    private String message;
    private CredoPaymentData data;
    
    // Getters and Setters
    public boolean isStatus() {
        return status;
    }
    
    public void setStatus(boolean status) {
        this.status = status;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public CredoPaymentData getData() {
        return data;
    }
    
    public void setData(CredoPaymentData data) {
        this.data = data;
    }
    
    // Inner class for payment data
    public static class CredoPaymentData {
        private String reference;
        private double amount;
        private String status;
        private String gateway_response;
        private String paid_at;
        private String created_at;
        private String channel;
        private String currency;
        private String ip_address;
        private CredoCustomer customer;
        private CredoAuthorization authorization;
        
        // Getters and Setters
        public String getReference() {
            return reference;
        }
        
        public void setReference(String reference) {
            this.reference = reference;
        }
        
        public double getAmount() {
            return amount;
        }
        
        public void setAmount(double amount) {
            this.amount = amount;
        }
        
        public String getStatus() {
            return status;
        }
        
        public void setStatus(String status) {
            this.status = status;
        }
        
        public String getGateway_response() {
            return gateway_response;
        }
        
        public void setGateway_response(String gateway_response) {
            this.gateway_response = gateway_response;
        }
        
        public String getPaid_at() {
            return paid_at;
        }
        
        public void setPaid_at(String paid_at) {
            this.paid_at = paid_at;
        }
        
        public String getCreated_at() {
            return created_at;
        }
        
        public void setCreated_at(String created_at) {
            this.created_at = created_at;
        }
        
        public String getChannel() {
            return channel;
        }
        
        public void setChannel(String channel) {
            this.channel = channel;
        }
        
        public String getCurrency() {
            return currency;
        }
        
        public void setCurrency(String currency) {
            this.currency = currency;
        }
        
        public String getIp_address() {
            return ip_address;
        }
        
        public void setIp_address(String ip_address) {
            this.ip_address = ip_address;
        }
        
        public CredoCustomer getCustomer() {
            return customer;
        }
        
        public void setCustomer(CredoCustomer customer) {
            this.customer = customer;
        }
        
        public CredoAuthorization getAuthorization() {
            return authorization;
        }
        
        public void setAuthorization(CredoAuthorization authorization) {
            this.authorization = authorization;
        }
    }
    
    public static class CredoCustomer {
        private String email;
        private String phone;
        
        public String getEmail() {
            return email;
        }
        
        public void setEmail(String email) {
            this.email = email;
        }
        
        public String getPhone() {
            return phone;
        }
        
        public void setPhone(String phone) {
            this.phone = phone;
        }
    }
    
    public static class CredoAuthorization {
        private String authorization_code;
        private String bin;
        private String last4;
        private String exp_month;
        private String exp_year;
        private String channel;
        private String card_type;
        private String bank;
        private String country_code;
        private String brand;
        
        // Getters and Setters
        public String getAuthorization_code() {
            return authorization_code;
        }
        
        public void setAuthorization_code(String authorization_code) {
            this.authorization_code = authorization_code;
        }
        
        public String getBin() {
            return bin;
        }
        
        public void setBin(String bin) {
            this.bin = bin;
        }
        
        public String getLast4() {
            return last4;
        }
        
        public void setLast4(String last4) {
            this.last4 = last4;
        }
        
        public String getExp_month() {
            return exp_month;
        }
        
        public void setExp_month(String exp_month) {
            this.exp_month = exp_month;
        }
        
        public String getExp_year() {
            return exp_year;
        }
        
        public void setExp_year(String exp_year) {
            this.exp_year = exp_year;
        }
        
        public String getChannel() {
            return channel;
        }
        
        public void setChannel(String channel) {
            this.channel = channel;
        }
        
        public String getCard_type() {
            return card_type;
        }
        
        public void setCard_type(String card_type) {
            this.card_type = card_type;
        }
        
        public String getBank() {
            return bank;
        }
        
        public void setBank(String bank) {
            this.bank = bank;
        }
        
        public String getCountry_code() {
            return country_code;
        }
        
        public void setCountry_code(String country_code) {
            this.country_code = country_code;
        }
        
        public String getBrand() {
            return brand;
        }
        
        public void setBrand(String brand) {
            this.brand = brand;
        }
    }
}