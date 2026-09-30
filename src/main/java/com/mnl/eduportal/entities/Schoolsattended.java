/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "schoolsattended")
@NamedQueries({
    @NamedQuery(name = "Schoolsattended.findAll", query = "SELECT s FROM Schoolsattended s"),
    @NamedQuery(name = "Schoolsattended.findById", query = "SELECT s FROM Schoolsattended s WHERE s.id = :id"),
    @NamedQuery(name = "Schoolsattended.findByName", query = "SELECT s FROM Schoolsattended s WHERE s.name = :name"),
    @NamedQuery(name = "Schoolsattended.findByStartDate", query = "SELECT s FROM Schoolsattended s WHERE s.startDate = :startDate"),
    @NamedQuery(name = "Schoolsattended.findByEndDate", query = "SELECT s FROM Schoolsattended s WHERE s.endDate = :endDate"),
    @NamedQuery(name = "Schoolsattended.findByYearOfAward", query = "SELECT s FROM Schoolsattended s WHERE s.yearOfAward = :yearOfAward"),
    @NamedQuery(name = "Schoolsattended.findByQualification", query = "SELECT s FROM Schoolsattended s WHERE s.qualification = :qualification"),
    @NamedQuery(name = "Schoolsattended.findByRegNo", query = "SELECT s FROM Schoolsattended s WHERE s.regNo = :regNo")})
public class Schoolsattended implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "name")
    private String name;
    @Column(name = "start_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;
    @Column(name = "end_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;
    @Column(name = "year_of_award")
    private Integer yearOfAward;
    @Size(max = 100)
    @Column(name = "qualification")
    private String qualification;
    @Size(max = 50)
    @Column(name = "reg_no")
    private String regNo;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "app_id")
    private String appId;

    public Schoolsattended() {
    }

    public Schoolsattended(String id) {
        this.id = id;
    }

    public Schoolsattended(String id, String name, String regNo) {
        this.id = id;
        this.name = name;
        this.regNo = regNo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Integer getYearOfAward() {
        return yearOfAward;
    }

    public void setYearOfAward(Integer yearOfAward) {
        this.yearOfAward = yearOfAward;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getRegNo() {
        return regNo;
    }

    public void setRegNo(String regNo) {
        this.regNo = regNo;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Schoolsattended)) {
            return false;
        }
        Schoolsattended other = (Schoolsattended) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Schoolsattended[ id=" + id + " ]";
    }

    /**
     * @return the appId
     */
    public String getAppId() {
        return appId;
    }

    /**
     * @param appId the appId to set
     */
    public void setAppId(String appId) {
        this.appId = appId;
    }
    
}
