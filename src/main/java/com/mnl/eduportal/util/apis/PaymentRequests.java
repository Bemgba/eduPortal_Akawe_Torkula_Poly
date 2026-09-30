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
public class PaymentRequests {
    private String regno;
    private String sessions;
    private String semester;

     public PaymentRequests() {
    }
    public PaymentRequests(String regno, String sessions, String semester) {
        this.regno = regno;
        this.sessions = sessions;
        this.semester = semester;
    }

    public String getRegno() {
        return regno;
    }

    public void setRegno(String regno) {
        this.regno = regno;
    }

    public String getSessions() {
        return sessions;
    }

    public void setSessions(String sessions) {
        this.sessions = sessions;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }
    
}
