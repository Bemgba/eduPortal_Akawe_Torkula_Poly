/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class MaxLevelStudentDTO {
   private String studentId;
private String courseId;
    private String maxLevel;
    private int sessionsOnMaxLevel;
    private String latestSession;

    public MaxLevelStudentDTO() {
    }

   public MaxLevelStudentDTO(String studentId, String courseId, String maxLevel, Long sessionsOnMaxLevel, String latestSession) {
    this.studentId = studentId;
    this.courseId = courseId;
    this.maxLevel = maxLevel;
    this.sessionsOnMaxLevel = sessionsOnMaxLevel.intValue();
    this.latestSession = latestSession;
}

    /**
     * @return the studentId
     */
    public String getStudentId() {
        return studentId;
    }

    /**
     * @param studentId the studentId to set
     */
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

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
     * @return the maxLevel
     */
    public String getMaxLevel() {
        return maxLevel;
    }

    /**
     * @param maxLevel the maxLevel to set
     */
    public void setMaxLevel(String maxLevel) {
        this.maxLevel = maxLevel;
    }

    /**
     * @return the sessionsOnMaxLevel
     */
    public int getSessionsOnMaxLevel() {
        return sessionsOnMaxLevel;
    }

    /**
     * @param sessionsOnMaxLevel the sessionsOnMaxLevel to set
     */
    public void setSessionsOnMaxLevel(int sessionsOnMaxLevel) {
        this.sessionsOnMaxLevel = sessionsOnMaxLevel;
    }

    /**
     * @return the latestSession
     */
    public String getLatestSession() {
        return latestSession;
    }

    /**
     * @param latestSession the latestSession to set
     */
    public void setLatestSession(String latestSession) {
        this.latestSession = latestSession;
    }
    
    
}
