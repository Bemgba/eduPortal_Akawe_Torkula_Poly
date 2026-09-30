/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author eaglescan
 */
public class MeritAdmission {
    private AdmissionTemplateUTME utme;
    private String meritStatus;

    public MeritAdmission(AdmissionTemplateUTME utme, String meritStatus) {
        this.utme = utme;
        this.meritStatus = meritStatus;
    }

    /**
     * @return the utme
     */
    public AdmissionTemplateUTME getUtme() {
        return utme;
    }

    /**
     * @param utme the utme to set
     */
    public void setUtme(AdmissionTemplateUTME utme) {
        this.utme = utme;
    }

    /**
     * @return the meritStatus
     */
    public String getMeritStatus() {
        return meritStatus;
    }

    /**
     * @param meritStatus the meritStatus to set
     */
    public void setMeritStatus(String meritStatus) {
        this.meritStatus = meritStatus;
    }
    
}
