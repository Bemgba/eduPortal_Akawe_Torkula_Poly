/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import java.util.List;

/**
 *
 * @author nguuma-ayua
 */
public class ExamWSCourseRegistrationResquestResponse {

    private Integer minCU;
    private Integer maxCU;
    private List<ExamWSCourseRegistrationResquestResponseData> courses;

    public ExamWSCourseRegistrationResquestResponse() {
    }

    public ExamWSCourseRegistrationResquestResponse(Integer minCU, Integer maxCU, List<ExamWSCourseRegistrationResquestResponseData> courses) {
        this.minCU = minCU;
        this.maxCU = maxCU;
        this.courses = courses;
    }

    /**
     * @return the minCU
     */
    public Integer getMinCU() {
        return minCU;
    }

    /**
     * @param minCU the minCU to set
     */
    public void setMinCU(Integer minCU) {
        this.minCU = minCU;
    }

    /**
     * @return the maxCU
     */
    public Integer getMaxCU() {
        return maxCU;
    }

    /**
     * @param maxCU the maxCU to set
     */
    public void setMaxCU(Integer maxCU) {
        this.maxCU = maxCU;
    }

    /**
     * @return the courses
     */
    public List<ExamWSCourseRegistrationResquestResponseData> getCourses() {
        return courses;
    }

    /**
     * @param courses the courses to set
     */
    public void setCourses(List<ExamWSCourseRegistrationResquestResponseData> courses) {
        this.courses = courses;
    }

}
