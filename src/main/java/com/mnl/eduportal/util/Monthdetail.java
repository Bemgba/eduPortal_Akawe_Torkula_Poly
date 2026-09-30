/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mnl.eduportal.util;

/**
 *
 * @author doc
 */
public class Monthdetail {
    private String monthcode;
    private String monthname;
    public Monthdetail() {
    }

    public Monthdetail(String monthcode, String monthname) {
        this.monthcode = monthcode;
        this.monthname = monthname;
    }

    /**
     * @return the monthcode
     */
    public String getMonthcode() {
        return monthcode;
    }

    /**
     * @param monthcode the monthcode to set
     */
    public void setMonthcode(String monthcode) {
        this.monthcode = monthcode;
    }

    /**
     * @return the monthname
     */
    public String getMonthname() {
        return monthname;
    }

    /**
     * @param monthname the monthname to set
     */
    public void setMonthname(String monthname) {
        this.monthname = monthname;
    }
    
    
}
