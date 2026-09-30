/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util.apis;

/**
 *
 * @author nguuma-ayua
 */
public class PaymentRequestResponse {
    private String url;

    public PaymentRequestResponse(String url) {
        this.url = url;
    }

    public PaymentRequestResponse() {
    }

    /**
     * @return the url
     */
    public String getUrl() {
        return url;
    }

    /**
     * @param url the url to set
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
}
