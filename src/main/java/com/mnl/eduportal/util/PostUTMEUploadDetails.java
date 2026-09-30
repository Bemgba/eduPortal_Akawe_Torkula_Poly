/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class PostUTMEUploadDetails {
    private String sno;
    private String regno;
    private String fullname;
    private String course;
    private String score;
    private String remarks;

    public PostUTMEUploadDetails(String sno, String regno, String fullname, String course, String score, String remarks) {
        this.sno=sno;
        this.regno = regno;
        this.fullname = fullname;
        this.course = course;
        this.score = score;
        this.remarks = remarks;
    }

    public PostUTMEUploadDetails() {
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
     * @return the score
     */
    public String getScore() {
        return score;
    }

    /**
     * @param score the score to set
     */
    public void setScore(String score) {
        this.score = score;
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
     * @return the sno
     */
    public String getSno() {
        return sno;
    }

    /**
     * @param sno the sno to set
     */
    public void setSno(String sno) {
        this.sno = sno;
    }
    
    
}
