/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util.apis;

/**
 *
 * @author nguuma-ayua
 */
public class sendPaymentResponse {
    private String paymentRef;
    private boolean status;

    public sendPaymentResponse(String paymentRef, boolean status) {
        this.paymentRef = paymentRef;
        this.status = status;
    }

    public sendPaymentResponse() {
    }

    /**
     * @return the paymentRef
     */
    public String getPaymentRef() {
        return paymentRef;
    }

    /**
     * @param paymentRef the paymentRef to set
     */
    public void setPaymentRef(String paymentRef) {
        this.paymentRef = paymentRef;
    }

    /**
     * @return the status
     */
    public boolean isStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(boolean status) {
        this.status = status;
    }
    
}
