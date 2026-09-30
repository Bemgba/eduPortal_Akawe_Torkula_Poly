/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author nguuma-ayua
 */
public class ExamWSCourseRegistrationResquestRequest {

    private String matno;
    private String programmeCode;
    private String sessions;
    private String level;

    public ExamWSCourseRegistrationResquestRequest() {
    }

    public ExamWSCourseRegistrationResquestRequest(String matno, String programmeCode, String sessions, String level) {
        this.matno = matno;
        this.programmeCode = programmeCode;
        this.sessions = sessions;
        this.level = level;
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
     * @return the programmeCode
     */
    public String getProgrammeCode() {
        return programmeCode;
    }

    /**
     * @param programmeCode the programmeCode to set
     */
    public void setProgrammeCode(String programmeCode) {
        this.programmeCode = programmeCode;
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
