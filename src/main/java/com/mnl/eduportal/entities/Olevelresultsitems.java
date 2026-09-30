/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
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
@Table(name = "olevelresultsitems")
@NamedQueries({
    @NamedQuery(name = "Olevelresultsitems.findAll", query = "SELECT o FROM Olevelresultsitems o"),
    @NamedQuery(name = "Olevelresultsitems.findById", query = "SELECT o FROM Olevelresultsitems o WHERE o.id = :id"),
    @NamedQuery(name = "Olevelresultsitems.findBySubject", query = "SELECT o FROM Olevelresultsitems o WHERE o.subject = :subject"),
    @NamedQuery(name = "Olevelresultsitems.findByDateAdded", query = "SELECT o FROM Olevelresultsitems o WHERE o.dateAdded = :dateAdded"),
    @NamedQuery(name = "Olevelresultsitems.findByVerificationStatus", query = "SELECT o FROM Olevelresultsitems o WHERE o.verificationStatus = :verificationStatus"),
    @NamedQuery(name = "Olevelresultsitems.findByDateVerified", query = "SELECT o FROM Olevelresultsitems o WHERE o.dateVerified = :dateVerified")})
public class Olevelresultsitems implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "subject")
    private String subject;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 50)
    @Column(name = "verification_status")
    private String verificationStatus;
    @Column(name = "date_verified")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateVerified;
    @JoinColumn(name = "grade", referencedColumnName = "id")
    @ManyToOne
    private Olevelgrades grade;
    @JoinColumn(name = "olevel_results_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Olevelresults olevelResultsId;

    public Olevelresultsitems() {
    }

    public Olevelresultsitems(String id) {
        this.id = id;
    }

   public Olevelresultsitems(String id, String subject) {
        this.id = id;
        this.subject = subject;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(String verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public Date getDateVerified() {
        return dateVerified;
    }

    public void setDateVerified(Date dateVerified) {
        this.dateVerified = dateVerified;
    }

    public Olevelgrades getGrade() {
        return grade;
    }

    public void setGrade(Olevelgrades grade) {
        this.grade = grade;
    }

    public Olevelresults getOlevelResultsId() {
        return olevelResultsId;
    }

    public void setOlevelResultsId(Olevelresults olevelResultsId) {
        this.olevelResultsId = olevelResultsId;
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
        if (!(object instanceof Olevelresultsitems)) {
            return false;
        }
        Olevelresultsitems other = (Olevelresultsitems) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.bdic.benueexco.admissiontemplate.Olevelresultsitems[ id=" + id + " ]";
    }
    
}
