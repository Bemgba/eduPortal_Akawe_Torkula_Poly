/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util.apis;

/**
 *
 * @author nguuma-ayua
 */
public class sendPaymentRequest {
    private String refno;

    public sendPaymentRequest(String refno) {
        this.refno = refno;
    }

    public sendPaymentRequest() {
    }

    /**
     * @return the refno
     */
    public String getRefno() {
        return refno;
    }

    /**
     * @param refno the refno to set
     */
    public void setRefno(String refno) {
        this.refno = refno;
    }
    
}
