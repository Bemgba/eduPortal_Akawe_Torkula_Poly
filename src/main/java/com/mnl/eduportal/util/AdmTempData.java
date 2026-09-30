/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class AdmTempData {
    private String subj;
    private int score;

    public AdmTempData(String subj, int score) {
        this.subj = subj;
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
