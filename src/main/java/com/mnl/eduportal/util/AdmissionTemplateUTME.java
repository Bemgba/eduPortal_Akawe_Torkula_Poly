/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class AdmissionTemplateUTME {
    private String id;
    private String surname;
    private String othernames;
    private String gender;
    private String state;
    private String lga;
    private AdmTempUTMEDet utme;
    private int sittings;
    private AdmTempOLDet olevel;
    private int sittingScore;
    private double olratio;
    private double utmearatio;
    private double putmeration;
    private double totalscore;

    public AdmissionTemplateUTME() {
    }

    public AdmissionTemplateUTME(String id, String surname, String othernames, String gender, String state, String lga, AdmTempUTMEDet utme, int sittings, AdmTempOLDet olevel, int sittingScore, double olratio, double utmearatio, double putmeration, double totalscore) {
        this.id = id;
        this.surname = surname;
        this.othernames = othernames;
        this.gender = gender;
        this.state = state;
        this.lga = lga;
        this.utme = utme;
        this.sittings = sittings;
        this.olevel = olevel;
        this.sittingScore = sittingScore;
        this.olratio = olratio;
        this.utmearatio = utmearatio;
        this.putmeration = putmeration;
        this.totalscore = totalscore;
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
     * @return the surname
     */
    public String getSurname() {
        return surname;
    }

    /**
     * @param surname the surname to set
     */
    public void setSurname(String surname) {
        this.surname = surname;
    }

    /**
     * @return the othernames
     */
    public String getOthernames() {
        return othernames;
    }

    /**
     * @param othernames the othernames to set
     */
    public void setOthernames(String othernames) {
        this.othernames = othernames;
    }

    /**
     * @return the gender
     */
    public String getGender() {
        return gender;
    }

    /**
     * @param gender the gender to set
     */
    public void setGender(String gender) {
        this.gender = gender;
    }

    /**
     * @return the state
     */
    public String getState() {
        return state;
    }

    /**
     * @param state the state to set
     */
    public void setState(String state) {
        this.state = state;
    }

    /**
     * @return the lga
     */
    public String getLga() {
        return lga;
    }

    /**
     * @param lga the lga to set
     */
    public void setLga(String lga) {
        this.lga = lga;
    }

    /**
     * @return the utme
     */
    public AdmTempUTMEDet getUtme() {
        return utme;
    }

    /**
     * @param utme the utme to set
     */
    public void setUtme(AdmTempUTMEDet utme) {
        this.utme = utme;
    }

    /**
     * @return the sittings
     */
    public int getSittings() {
        return sittings;
    }

    /**
     * @param sittings the sittings to set
     */
    public void setSittings(int sittings) {
        this.sittings = sittings;
    }

    /**
     * @return the olevel
     */
    public AdmTempOLDet getOlevel() {
        return olevel;
    }

    /**
     * @param olevel the olevel to set
     */
    public void setOlevel(AdmTempOLDet olevel) {
        this.olevel = olevel;
    }

    /**
     * @return the sittingScore
     */
    public int getSittingScore() {
        return sittingScore;
    }

    /**
     * @param sittingScore the sittingScore to set
     */
    public void setSittingScore(int sittingScore) {
        this.sittingScore = sittingScore;
    }

    /**
     * @return the olratio
     */
    public double getOlratio() {
        return olratio;
    }

    /**
     * @param olratio the olratio to set
     */
    public void setOlratio(double olratio) {
        this.olratio = olratio;
    }

    /**
     * @return the utmearatio
     */
    public double getUtmearatio() {
        return utmearatio;
    }

    /**
     * @param utmearatio the utmearatio to set
     */
    public void setUtmearatio(double utmearatio) {
        this.utmearatio = utmearatio;
    }

    /**
     * @return the putmeration
     */
    public double getPutmeration() {
        return putmeration;
    }

    /**
     * @param putmeration the putmeration to set
     */
    public void setPutmeration(double putmeration) {
        this.putmeration = putmeration;
    }

    /**
     * @return the totalscore
     */
    public double getTotalscore() {
        return totalscore;
    }

    /**
     * @param totalscore the totalscore to set
     */
    public void setTotalscore(double totalscore) {
        this.totalscore = totalscore;
    }
    
}
