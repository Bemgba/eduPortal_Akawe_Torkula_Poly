/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class StudentStatisticsDTO {
    private String facultyName;
    private String level;
    private int totalStudents;
    private int registeredStudents;
    private int paidStudents;
    private int notRegisteredStudents;
    private int notPaidStudents;
    private double totalAmountPaid;
    private double registeredPercentage;
    private double notRegisteredPercentage;
    private double paidPercentage;
    private double notPaidPercentage;

    public StudentStatisticsDTO() {
    }

    public StudentStatisticsDTO(String facultyName, String level, int totalStudents, int registeredStudents, int paidStudents, int notRegisteredStudents, int notPaidStudents, double totalAmountPaid, double registeredPercentage, double notRegisteredPercentage, double paidPercentage, double notPaidPercentage) {
        this.facultyName = facultyName;
        this.level = level;
        this.totalStudents = totalStudents;
        this.registeredStudents = registeredStudents;
        this.paidStudents = paidStudents;
        this.notRegisteredStudents = notRegisteredStudents;
        this.notPaidStudents = notPaidStudents;
        this.totalAmountPaid = totalAmountPaid;
        this.registeredPercentage = registeredPercentage;
        this.notRegisteredPercentage = notRegisteredPercentage;
        this.paidPercentage = paidPercentage;
        this.notPaidPercentage = notPaidPercentage;
    }

    /**
     * @return the facultyName
     */
    public String getFacultyName() {
        return facultyName;
    }

    /**
     * @param facultyName the facultyName to set
     */
    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    /**
     * @return the level
     */
    public String getLevel() {
        return level;
    }

    /**
     * @param level the level to set
     */
    public void setLevel(String level) {
        this.level = level;
    }

    /**
     * @return the totalStudents
     */
    public int getTotalStudents() {
        return totalStudents;
    }

    /**
     * @param totalStudents the totalStudents to set
     */
    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    /**
     * @return the registeredStudents
     */
    public int getRegisteredStudents() {
        return registeredStudents;
    }

    /**
     * @param registeredStudents the registeredStudents to set
     */
    public void setRegisteredStudents(int registeredStudents) {
        this.registeredStudents = registeredStudents;
    }

    /**
     * @return the paidStudents
     */
    public int getPaidStudents() {
        return paidStudents;
    }

    /**
     * @param paidStudents the paidStudents to set
     */
    public void setPaidStudents(int paidStudents) {
        this.paidStudents = paidStudents;
    }

    /**
     * @return the notRegisteredStudents
     */
    public int getNotRegisteredStudents() {
        return notRegisteredStudents;
    }

    /**
     * @param notRegisteredStudents the notRegisteredStudents to set
     */
    public void setNotRegisteredStudents(int notRegisteredStudents) {
        this.notRegisteredStudents = notRegisteredStudents;
    }

    /**
     * @return the notPaidStudents
     */
    public int getNotPaidStudents() {
        return notPaidStudents;
    }

    /**
     * @param notPaidStudents the notPaidStudents to set
     */
    public void setNotPaidStudents(int notPaidStudents) {
        this.notPaidStudents = notPaidStudents;
    }

    /**
     * @return the totalAmountPaid
     */
    public double getTotalAmountPaid() {
        return totalAmountPaid;
    }

    /**
     * @param totalAmountPaid the totalAmountPaid to set
     */
    public void setTotalAmountPaid(double totalAmountPaid) {
        this.totalAmountPaid = totalAmountPaid;
    }

    /**
     * @return the registeredPercentage
     */
    public double getRegisteredPercentage() {
        return registeredPercentage;
    }

    /**
     * @param registeredPercentage the registeredPercentage to set
     */
    public void setRegisteredPercentage(double registeredPercentage) {
        this.registeredPercentage = registeredPercentage;
    }

    /**
     * @return the notRegisteredPercentage
     */
    public double getNotRegisteredPercentage() {
        return notRegisteredPercentage;
    }

    /**
     * @param notRegisteredPercentage the notRegisteredPercentage to set
     */
    public void setNotRegisteredPercentage(double notRegisteredPercentage) {
        this.notRegisteredPercentage = notRegisteredPercentage;
    }

    /**
     * @return the paidPercentage
     */
    public double getPaidPercentage() {
        return paidPercentage;
    }

    /**
     * @param paidPercentage the paidPercentage to set
     */
    public void setPaidPercentage(double paidPercentage) {
        this.paidPercentage = paidPercentage;
    }

    /**
     * @return the notPaidPercentage
     */
    public double getNotPaidPercentage() {
        return notPaidPercentage;
    }

    /**
     * @param notPaidPercentage the notPaidPercentage to set
     */
    public void setNotPaidPercentage(double notPaidPercentage) {
        this.notPaidPercentage = notPaidPercentage;
    }
    
}
