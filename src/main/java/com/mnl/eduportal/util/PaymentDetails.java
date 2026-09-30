/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author nguuma-ayua
 */
public class PaymentDetails {
    private String feesgroup;
    private double amount;
    private String sessions;
    private String semester;
    private double realamt;

    public PaymentDetails() {
    }

    public PaymentDetails(String feesgroup, double amount, String sessions, String semester, double realamt) {
        this.feesgroup = feesgroup;
        this.amount = amount;
        this.sessions = sessions;
        this.semester = semester;
        this.realamt =realamt;
    }

    /**
     * @return the feesgroup
     */
    public String getFeesgroup() {
        return feesgroup;
    }

    /**
     * @param feesgroup the feesgroup to set
     */
    public void setFeesgroup(String feesgroup) {
        this.feesgroup = feesgroup;
    }

    /**
     * @return the amount
     */
    public double getAmount() {
        return amount;
    }

    /**
     * @param amount the amount to set
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }

    /**
     * @return the sessions
     */
    public String getSessions() {
        return sessions;
    }

    /**
     * @param sessions the sessions to set
     */
    public void setSessions(String sessions) {
        this.sessions = sessions;
    }

    /**
     * @return the semester
     */
    public String getSemester() {
        return semester;
    }

    /**
     * @param semester the semester to set
     */
    public void setSemester(String semester) {
        this.semester = semester;
    }

    /**
     * @return the realamt
     */
    public double getRealamt() {
        return realamt;
    }

    /**
     * @param realamt the realamt to set
     */
    public void setRealamt(double realamt) {
        this.realamt = realamt;
    }
    
}
