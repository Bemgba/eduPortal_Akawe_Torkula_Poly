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
public class StudentRequests {
    private String regno;

     public StudentRequests() {
    }
    public StudentRequests(String regno) {
        this.regno = regno;
    }

    /**
     * @return the regno
     */
    public String getRegno() {
        return regno;
    }

    /**
     * @param regno the regno to set
     */
    public void setRegno(String regno) {
        this.regno = regno;
    }
    
}
