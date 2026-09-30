/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class PaymentNotification {

    private double Amount;
    private String CardNumber;
    private String MerchantReference;
    private String PaymentReference;
    private String RetrievalReferenceNumber;
    private String[] SplitAccounts;
    private String TransactionDate;
    private String ResponseCode;
    private String ResponseDescription;
    private String AccountNumber;

    // Add CREDO-specific fields:
    private boolean status; // CREDO uses boolean status
    private String message; // CREDO message field
    private String reference; // CREDO reference field
    private String gateway_response; // CREDO gateway response

// Update success check method:
    public boolean isSuccessful() {
        return status == true && "success".equals(gateway_response);
    }

    public PaymentNotification() {
    }

  

    // CREDO constructor with both Interswitch and CREDO fields
    public PaymentNotification(double Amount, String CardNumber, String MerchantReference, String PaymentReference, 
                             String RetrievalReferenceNumber, String[] SplitAccounts, String TransactionDate, 
                             String ResponseCode, String ResponseDescription, String AccountNumber,
                             boolean status, String message, String reference, String gateway_response) {
        // Initialize Interswitch fields
        this.Amount = Amount;
        this.CardNumber = CardNumber;
        this.MerchantReference = MerchantReference;
        this.PaymentReference = PaymentReference;
        this.RetrievalReferenceNumber = RetrievalReferenceNumber;
        this.SplitAccounts = SplitAccounts;
        this.TransactionDate = TransactionDate;
        this.ResponseCode = ResponseCode;
        this.ResponseDescription = ResponseDescription;
        this.AccountNumber = AccountNumber;
        
        // Initialize CREDO fields
        this.status = status;
        this.message = message;
        this.reference = reference;
        this.gateway_response = gateway_response;
    }

 

    /**
     * @return the Amount
     */
    public double getAmount() {
        return Amount;
    }

    /**
     * @param Amount the Amount to set
     */
    public void setAmount(double Amount) {
        this.Amount = Amount;
    }

    /**
     * @return the CardNumber
     */
    public String getCardNumber() {
        return CardNumber;
    }

    /**
     * @param CardNumber the CardNumber to set
     */
    public void setCardNumber(String CardNumber) {
        this.CardNumber = CardNumber;
    }

    /**
     * @return the MerchantReference
     */
    public String getMerchantReference() {
        return MerchantReference;
    }

    /**
     * @param MerchantReference the MerchantReference to set
     */
    public void setMerchantReference(String MerchantReference) {
        this.MerchantReference = MerchantReference;
    }

    /**
     * @return the PaymentReference
     */
    public String getPaymentReference() {
        return PaymentReference;
    }

    /**
     * @param PaymentReference the PaymentReference to set
     */
    public void setPaymentReference(String PaymentReference) {
        this.PaymentReference = PaymentReference;
    }

    /**
     * @return the RetrievalReferenceNumber
     */
    public String getRetrievalReferenceNumber() {
        return RetrievalReferenceNumber;
    }

    /**
     * @param RetrievalReferenceNumber the RetrievalReferenceNumber to set
     */
    public void setRetrievalReferenceNumber(String RetrievalReferenceNumber) {
        this.RetrievalReferenceNumber = RetrievalReferenceNumber;
    }

    /**
     * @return the SplitAccounts
     */
    public String[] getSplitAccounts() {
        return SplitAccounts;
    }

    /**
     * @param SplitAccounts the SplitAccounts to set
     */
    public void setSplitAccounts(String[] SplitAccounts) {
        this.SplitAccounts = SplitAccounts;
    }

    /**
     * @return the TransactionDate
     */
    public String getTransactionDate() {
        return TransactionDate;
    }

    /**
     * @param TransactionDate the TransactionDate to set
     */
    public void setTransactionDate(String TransactionDate) {
        this.TransactionDate = TransactionDate;
    }

    /**
     * @return the ResponseCode
     */
    public String getResponseCode() {
        return ResponseCode;
    }

    /**
     * @param ResponseCode the ResponseCode to set
     */
    public void setResponseCode(String ResponseCode) {
        this.ResponseCode = ResponseCode;
    }

    /**
     * @return the ResponseDescription
     */
    public String getResponseDescription() {
        return ResponseDescription;
    }

    /**
     * @param ResponseDescription the ResponseDescription to set
     */
    public void setResponseDescription(String ResponseDescription) {
        this.ResponseDescription = ResponseDescription;
    }

    /**
     * @return the AccountNumber
     */
    public String getAccountNumber() {
        return AccountNumber;
    }

    /**
     * @param AccountNumber the AccountNumber to set
     */
    public void setAccountNumber(String AccountNumber) {
        this.AccountNumber = AccountNumber;
    }

    // CREDO-specific getters and setters 
    /**
     * @return the CREDO status
     */
    public boolean isStatus() {
        return status;
    }

    /**
     * @param status the CREDO status to set
     */
    public void setStatus(boolean status) {
        this.status = status;
    }

    /**
     * @return the CREDO message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message the CREDO message to set
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * @return the CREDO reference
     */
    public String getReference() {
        return reference;
    }

    /**
     * @param reference the CREDO reference to set
     */
    public void setReference(String reference) {
        this.reference = reference;
    }

    /**
     * @return the CREDO gateway_response
     */
    public String getGateway_response() {
        return gateway_response;
    }

    /**
     * @param gateway_response the CREDO gateway_response to set
     */
    public void setGateway_response(String gateway_response) {
        this.gateway_response = gateway_response;
    }

}
