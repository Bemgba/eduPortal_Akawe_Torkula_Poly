/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util.apis;

/**
 *
 * @author nguuma-ayua
 */
public class PaymentRequestRequest {
    private String id;
    private double total;
    private String regno;
    private String sessions;
    private String semester;
    private String fullName;
    private String phoneNo;
    private String email;
    private String feesGroupId;
    private String schoolId;
    private String course;
    private String level;

    public PaymentRequestRequest() {
    }

    public PaymentRequestRequest(String id, double total, String regno, String sessions, String semester, String fullName, String phoneNo, String email, String feesGroupId, String schoolId, String course, String level) {
        this.id = id;
        this.total = total;
        this.regno = regno;
        this.sessions = sessions;
        this.semester = semester;
        this.fullName = fullName;
        this.phoneNo = phoneNo;
        this.email = email;
        this.feesGroupId = feesGroupId;
        this.schoolId = schoolId;
        this.course=course;
        this.level=level;
    }

    /**
     * @return the id
     */
    public String getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }

    /**
     * @return the total
     */
    public double getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(double total) {
        this.total = total;
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
     * @return the fullName
     */
    public String getFullName() {
        return fullName;
    }

    /**
     * @param fullName the fullName to set
     */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    /**
     * @return the phoneNo
     */
    public String getPhoneNo() {
        return phoneNo;
    }

    /**
     * @param phoneNo the phoneNo to set
     */
    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the feesGroupId
     */
    public String getFeesGroupId() {
        return feesGroupId;
    }

    /**
     * @param feesGroupId the feesGroupId to set
     */
    public void setFeesGroupId(String feesGroupId) {
        this.feesGroupId = feesGroupId;
    }

    /**
     * @return the schoolId
     */
    public String getSchoolId() {
        return schoolId;
    }

    /**
     * @param schoolId the schoolId to set
     */
    public void setSchoolId(String schoolId) {
        this.schoolId = schoolId;
    }

    /**
     * @return the course
     */
    public String getCourse() {
        return course;
    }

    /**
     * @param course the course to set
     */
    public void setCourse(String course) {
        this.course = course;
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
    
    
}
