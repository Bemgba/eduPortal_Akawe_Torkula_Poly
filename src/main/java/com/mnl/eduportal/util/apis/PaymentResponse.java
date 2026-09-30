/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mnl.eduportal.util.apis;

/**
 *
 * @author mosesali
 */
public class PaymentResponse {
    private String status;
 public PaymentResponse() {
    }
    public PaymentResponse(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
}
