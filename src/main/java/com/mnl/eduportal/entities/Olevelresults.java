/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "olevelresults")
@NamedQueries({
    @NamedQuery(name = "Olevelresults.findAll", query = "SELECT o FROM Olevelresults o"),
    @NamedQuery(name = "Olevelresults.findById", query = "SELECT o FROM Olevelresults o WHERE o.id = :id"),
    @NamedQuery(name = "Olevelresults.findByName", query = "SELECT o FROM Olevelresults o WHERE o.name = :name"),
    @NamedQuery(name = "Olevelresults.findByResultType", query = "SELECT o FROM Olevelresults o WHERE o.resultType = :resultType"),
    @NamedQuery(name = "Olevelresults.findByRegistrationNo", query = "SELECT o FROM Olevelresults o WHERE o.registrationNo = :registrationNo"),
    @NamedQuery(name = "Olevelresults.findByUserId", query = "SELECT o FROM Olevelresults o WHERE o.userId = :userId"),
    @NamedQuery(name = "Olevelresults.findByExamDate", query = "SELECT o FROM Olevelresults o WHERE o.examDate = :examDate"),
    @NamedQuery(name = "Olevelresults.findByDateAdded", query = "SELECT o FROM Olevelresults o WHERE o.dateAdded = :dateAdded"),
    @NamedQuery(name = "Olevelresults.findBySitting", query = "SELECT o FROM Olevelresults o WHERE o.sitting = :sitting"),
    @NamedQuery(name = "Olevelresults.findByVerificationStatus", query = "SELECT o FROM Olevelresults o WHERE o.verificationStatus = :verificationStatus")})
public class Olevelresults implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "name")
    private String name;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "result_type")
    private String resultType;
    @Size(max = 50)
    @Column(name = "registration_no")
    private String registrationNo;
    @Size(max = 50)
    @Column(name = "user_id")
    private String userId;
    @Size(max = 50)
    @Column(name = "exam_date")
    private String examDate;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 20)
    @Column(name = "sitting")
    private String sitting;
    @Size(max = 50)
    @Column(name = "verification_status")
    private String verificationStatus;
    @OneToMany(cascade = CascadeType.ALL,mappedBy = "olevelResultsId")
    private Collection<Olevelresultsitems> olevelresultsitemsCollection;

    public Olevelresults() {
    }

    public Olevelresults(String id) {
        this.id = id;
    }

    public Olevelresults(String id, String name, String resultType) {
        this.id = id;
        this.name = name;
        this.resultType = resultType;
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

    public String getResultType() {
        return resultType;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getExamDate() {
        return examDate;
    }

    public void setExamDate(String examDate) {
        this.examDate = examDate;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getSitting() {
        return sitting;
    }

    public void setSitting(String sitting) {
        this.sitting = sitting;
    }

    public String getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(String verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public Collection<Olevelresultsitems> getOlevelresultsitemsCollection() {
        return olevelresultsitemsCollection;
    }

    public void setOlevelresultsitemsCollection(Collection<Olevelresultsitems> olevelresultsitemsCollection) {
        this.olevelresultsitemsCollection = olevelresultsitemsCollection;
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
        if (!(object instanceof Olevelresults)) {
            return false;
        }
        Olevelresults other = (Olevelresults) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Olevelresults[ id=" + id + " ]";
    }
    
}
