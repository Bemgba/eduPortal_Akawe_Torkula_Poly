/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author nguuma-ayua
 */
public class AdmissionUploadReport {
    private String regno;
    private String fullname;
    private String course;
    private String courseadm;
    private String admcriteria;
    private String remarks;

    public AdmissionUploadReport() {
    }

    public AdmissionUploadReport(String regno, String fullname, String course, String courseadm,String admcriteria, String remarks) {
        this.regno = regno;
        this.fullname = fullname;
        this.course = course;
        this.courseadm = courseadm;
        this.admcriteria = admcriteria;
        this.remarks = remarks;
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
     * @return the fullname
     */
    public String getFullname() {
        return fullname;
    }

    /**
     * @param fullname the fullname to set
     */
    public void setFullname(String fullname) {
        this.fullname = fullname;
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
     * @return the remarks
     */
    public String getRemarks() {
        return remarks;
    }

    /**
     * @param remarks the remarks to set
     */
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    /**
     * @return the courseadm
     */
    public String getCourseadm() {
        return courseadm;
    }

    /**
     * @param courseadm the courseadm to set
     */
    public void setCourseadm(String courseadm) {
        this.courseadm = courseadm;
    }

    /**
     * @return the admcriteria
     */
    public String getAdmcriteria() {
        return admcriteria;
    }

    /**
     * @param admcriteria the admcriteria to set
     */
    public void setAdmcriteria(String admcriteria) {
        this.admcriteria = admcriteria;
    }
    
}
