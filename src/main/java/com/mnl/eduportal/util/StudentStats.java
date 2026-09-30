/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class StudentStats {
    private String courseId;
    private String courseName;
    private String departmentName;
    private String level;
    private long totalStudents;
    private long indigeneStudents;
    private long nonIndigeneStudents;
    private long registeredStudents;
    private long notRegisteredStudents;
    private long paidStudents;
    private long paidIndigene;
    private long paidNonIndigene;
    private long notPaidStudents;
    private long notPaidIndigene;
    private long notPaidNonIndigene;

    public StudentStats(String courseId, String courseName, String departmentName, String level, long totalStudents,
                        long indigeneStudents, long nonIndigeneStudents, long registeredStudents, long notRegisteredStudents,
                        long paidStudents, long paidIndigene, long paidNonIndigene, long notPaidStudents, long notPaidIndigene, long notPaidNonIndigene) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.departmentName = departmentName;
        this.level = level;
        this.totalStudents = totalStudents;
        this.indigeneStudents = indigeneStudents;
        this.nonIndigeneStudents = nonIndigeneStudents;
        this.registeredStudents = registeredStudents;
        this.notRegisteredStudents = notRegisteredStudents;
        this.paidStudents = paidStudents;
        this.paidIndigene = paidIndigene;
        this.paidNonIndigene = paidNonIndigene;
        this.notPaidStudents = notPaidStudents;
        this.notPaidIndigene = notPaidIndigene;
        this.notPaidNonIndigene = notPaidNonIndigene;
    }

    // Getters and Setters

    /**
     * @return the courseId
     */
    public String getCourseId() {
        return courseId;
    }

    /**
     * @param courseId the courseId to set
     */
    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    /**
     * @return the courseName
     */
    public String getCourseName() {
        return courseName;
    }

    /**
     * @param courseName the courseName to set
     */
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    /**
     * @return the departmentName
     */
    public String getDepartmentName() {
        return departmentName;
    }

    /**
     * @param departmentName the departmentName to set
     */
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
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
    public long getTotalStudents() {
        return totalStudents;
    }

    /**
     * @param totalStudents the totalStudents to set
     */
    public void setTotalStudents(long totalStudents) {
        this.totalStudents = totalStudents;
    }

    /**
     * @return the indigeneStudents
     */
    public long getIndigeneStudents() {
        return indigeneStudents;
    }

    /**
     * @param indigeneStudents the indigeneStudents to set
     */
    public void setIndigeneStudents(long indigeneStudents) {
        this.indigeneStudents = indigeneStudents;
    }

    /**
     * @return the nonIndigeneStudents
     */
    public long getNonIndigeneStudents() {
        return nonIndigeneStudents;
    }

    /**
     * @param nonIndigeneStudents the nonIndigeneStudents to set
     */
    public void setNonIndigeneStudents(long nonIndigeneStudents) {
        this.nonIndigeneStudents = nonIndigeneStudents;
    }

    /**
     * @return the registeredStudents
     */
    public long getRegisteredStudents() {
        return registeredStudents;
    }

    /**
     * @param registeredStudents the registeredStudents to set
     */
    public void setRegisteredStudents(long registeredStudents) {
        this.registeredStudents = registeredStudents;
    }

    /**
     * @return the notRegisteredStudents
     */
    public long getNotRegisteredStudents() {
        return notRegisteredStudents;
    }

    /**
     * @param notRegisteredStudents the notRegisteredStudents to set
     */
    public void setNotRegisteredStudents(long notRegisteredStudents) {
        this.notRegisteredStudents = notRegisteredStudents;
    }

    /**
     * @return the paidStudents
     */
    public long getPaidStudents() {
        return paidStudents;
    }

    /**
     * @param paidStudents the paidStudents to set
     */
    public void setPaidStudents(long paidStudents) {
        this.paidStudents = paidStudents;
    }

    /**
     * @return the paidIndigene
     */
    public long getPaidIndigene() {
        return paidIndigene;
    }

    /**
     * @param paidIndigene the paidIndigene to set
     */
    public void setPaidIndigene(long paidIndigene) {
        this.paidIndigene = paidIndigene;
    }

    /**
     * @return the paidNonIndigene
     */
    public long getPaidNonIndigene() {
        return paidNonIndigene;
    }

    /**
     * @param paidNonIndigene the paidNonIndigene to set
     */
    public void setPaidNonIndigene(long paidNonIndigene) {
        this.paidNonIndigene = paidNonIndigene;
    }

    /**
     * @return the notPaidStudents
     */
    public long getNotPaidStudents() {
        return notPaidStudents;
    }

    /**
     * @param notPaidStudents the notPaidStudents to set
     */
    public void setNotPaidStudents(long notPaidStudents) {
        this.notPaidStudents = notPaidStudents;
    }

    /**
     * @return the notPaidIndigene
     */
    public long getNotPaidIndigene() {
        return notPaidIndigene;
    }

    /**
     * @param notPaidIndigene the notPaidIndigene to set
     */
    public void setNotPaidIndigene(long notPaidIndigene) {
        this.notPaidIndigene = notPaidIndigene;
    }

    /**
     * @return the notPaidNonIndigene
     */
    public long getNotPaidNonIndigene() {
        return notPaidNonIndigene;
    }

    /**
     * @param notPaidNonIndigene the notPaidNonIndigene to set
     */
    public void setNotPaidNonIndigene(long notPaidNonIndigene) {
        this.notPaidNonIndigene = notPaidNonIndigene;
    }
}
