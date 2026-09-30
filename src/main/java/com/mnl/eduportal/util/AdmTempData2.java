/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class AdmTempData2 {

    private String subj;
    private String grade;
    private int score;

    public AdmTempData2() {
    }

    public AdmTempData2(String subj, String grade, int score) {
        this.subj = subj;
        this.grade = grade;
        this.score = score;
    }

    /**
     * @return the subj
     */
    public String getSubj() {
        return subj;
    }

    /**
     * @param subj the subj to set
     */
    public void setSubj(String subj) {
        this.subj = subj;
    }

    /**
     * @return the grade
     */
    public String getGrade() {
        return grade;
    }

    /**
     * @param grade the grade to set
     */
    public void setGrade(String grade) {
        this.grade = grade;
    }

    /**
     * @return the score
     */
    public int getScore() {
        return score;
    }

    /**
     * @param score the score to set
     */
    public void setScore(int score) {
        this.score = score;
    }

}
