/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class GeneratePaymentResponse {
    private String txref;
    private PaymentResponse payresp;

    public GeneratePaymentResponse(String txref, PaymentResponse payresp) {
        this.txref = txref;
        this.payresp = payresp;
    }

    /**
     * @return the txref
     */
    public String getTxref() {
        return txref;
    }

    /**
     * @param txref the txref to set
     */
    public void setTxref(String txref) {
        this.txref = txref;
    }

    /**
     * @return the payresp
     */
    public PaymentResponse getPayresp() {
        return payresp;
    }

    /**
     * @param payresp the payresp to set
     */
    public void setPayresp(PaymentResponse payresp) {
        this.payresp = payresp;
    }
    
    
}
