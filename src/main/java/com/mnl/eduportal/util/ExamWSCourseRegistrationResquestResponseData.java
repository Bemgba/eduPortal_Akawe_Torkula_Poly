/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author nguuma-ayua
 */
public class ExamWSCourseRegistrationResquestResponseData {

    private String matno;
    private String courseCode;
    private Integer CreditUnit;
    private String courseTitle;
    private String sessions;
    private String semester;
    private String level;
    private String status;

    public ExamWSCourseRegistrationResquestResponseData() {
    }

    public ExamWSCourseRegistrationResquestResponseData(String matno, String courseCode, Integer CreditUnit, String courseTitle, String sessions, String semester, String level, String status) {
        this.matno = matno;
        this.courseCode = courseCode;
        this.CreditUnit = CreditUnit;
        this.courseTitle = courseTitle;
        this.sessions = sessions;
        this.semester = semester;
        this.level = level;
        this.status = status;
    }

    /**
     * @return the matno
     */
    public String getMatno() {
        return matno;
    }

    /**
     * @param matno the matno to set
     */
    public void setMatno(String matno) {
        this.matno = matno;
    }

    /**
     * @return the courseCode
     */
    public String getCourseCode() {
        return courseCode;
    }

    /**
     * @param courseCode the courseCode to set
     */
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    /**
     * @return the CreditUnit
     */
    public Integer getCreditUnit() {
        return CreditUnit;
    }

    /**
     * @param CreditUnit the CreditUnit to set
     */
    public void setCreditUnit(Integer CreditUnit) {
        this.CreditUnit = CreditUnit;
    }

    /**
     * @return the courseTitle
     */
    public String getCourseTitle() {
        return courseTitle;
    }

    /**
     * @param courseTitle the courseTitle to set
     */
    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
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
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

}
