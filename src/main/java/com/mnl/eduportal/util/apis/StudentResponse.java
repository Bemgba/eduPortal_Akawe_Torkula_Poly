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
public class StudentResponse {

    private String surname;
    private String othernames;
    private String phone;
    private String email;
    private String programmeid;
    private String courseofstudy;
    private String department;
    private String sessionadmitted;

    public StudentResponse() {
    }

    public StudentResponse(String surname, String othernames, String phone, String email,
            String programmeid, String courseofstudy, String department, String sessionadmitted) {
        this.surname = surname;
        this.othernames = othernames;
        this.phone = phone;
        this.email = email;
        this.programmeid = programmeid;
        this.courseofstudy = courseofstudy;
        this.department = department;
        this.sessionadmitted = sessionadmitted;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getOthernames() {
        return othernames;
    }

    public void setOthernames(String othernames) {
        this.othernames = othernames;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getProgrammeid() {
        return programmeid;
    }

    public void setProgrammeid(String programmeid) {
        this.programmeid = programmeid;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getSessionadmitted() {
        return sessionadmitted;
    }

    public void setSessionadmitted(String sessionadmitted) {
        this.sessionadmitted = sessionadmitted;
    }

    /**
     * @return the courseofstudy
     */
    public String getCourseofstudy() {
        return courseofstudy;
    }

    /**
     * @param courseofstudy the courseofstudy to set
     */
    public void setCourseofstudy(String courseofstudy) {
        this.courseofstudy = courseofstudy;
    }
}
