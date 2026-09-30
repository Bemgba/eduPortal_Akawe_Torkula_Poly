/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class PaymentreferenceDetail {
        private String payref;
    private String refdescription;

    public PaymentreferenceDetail() {
    }

    public PaymentreferenceDetail(String payref, String refdescription) {
        this.payref = payref;
        this.refdescription = refdescription;
    }

    /**
     * @return the payref
     */
    public String getPayref() {
        return payref;
    }

    /**
     * @param payref the payref to set
     */
    public void setPayref(String payref) {
        this.payref = payref;
    }

    /**
     * @return the refdescription
     */
    public String getRefdescription() {
        return refdescription;
    }

    /**
     * @param refdescription the refdescription to set
     */
    public void setRefdescription(String refdescription) {
        this.refdescription = refdescription;
    }
    
    
    
}
