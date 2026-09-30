/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class PaymentNotification_backUp {
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

    public PaymentNotification_backUp() {
    }

    public PaymentNotification_backUp(double Amount, String CardNumber, String MerchantReference, String PaymentReference, String RetrievalReferenceNumber, String[] SplitAccounts, String TransactionDate, String ResponseCode, String ResponseDescription, String AccountNumber) {
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
    
}
