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
@Table(name = "applicantsreferees")
@NamedQueries({
    @NamedQuery(name = "Applicantsreferees.findAll", query = "SELECT a FROM Applicantsreferees a"),
    @NamedQuery(name = "Applicantsreferees.findById", query = "SELECT a FROM Applicantsreferees a WHERE a.id = :id"),
    @NamedQuery(name = "Applicantsreferees.findByApplicantsId", query = "SELECT a FROM Applicantsreferees a WHERE a.applicantsId = :applicantsId"),
    @NamedQuery(name = "Applicantsreferees.findByName", query = "SELECT a FROM Applicantsreferees a WHERE a.name = :name"),
    @NamedQuery(name = "Applicantsreferees.findByPhoneNo", query = "SELECT a FROM Applicantsreferees a WHERE a.phoneNo = :phoneNo"),
    @NamedQuery(name = "Applicantsreferees.findByEmailAddress", query = "SELECT a FROM Applicantsreferees a WHERE a.emailAddress = :emailAddress"),
    @NamedQuery(name = "Applicantsreferees.findByContactAddress", query = "SELECT a FROM Applicantsreferees a WHERE a.contactAddress = :contactAddress"),
    @NamedQuery(name = "Applicantsreferees.findByRank", query = "SELECT a FROM Applicantsreferees a WHERE a.rank = :rank"),
    @NamedQuery(name = "Applicantsreferees.findByAttachmentUrl", query = "SELECT a FROM Applicantsreferees a WHERE a.attachmentUrl = :attachmentUrl"),
    @NamedQuery(name = "Applicantsreferees.findByNote", query = "SELECT a FROM Applicantsreferees a WHERE a.note = :note"),
    @NamedQuery(name = "Applicantsreferees.findByDateCommented", query = "SELECT a FROM Applicantsreferees a WHERE a.dateCommented = :dateCommented")})
public class Applicantsreferees implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 150)
    @Column(name = "name")
    private String name;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Size(max = 100)
    @Column(name = "email_address")
    private String emailAddress;
    @Size(max = 200)
    @Column(name = "contact_address")
    private String contactAddress;
    @Size(max = 100)
    @Column(name = "rank")
    private String rank;
    @Size(max = 150)
    @Column(name = "attachment_url")
    private String attachmentUrl;
    @Size(max = 2147483647)
    @Column(name = "note")
    private String note;
    @Column(name = "date_commented")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCommented;
    @JoinColumn(name = "applicants_id", referencedColumnName = "id")
    @ManyToOne
    private Applicants applicantsId;

    public Applicantsreferees() {
    }

    public Applicantsreferees(String id) {
        this.id = id;
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

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getContactAddress() {
        return contactAddress;
    }

    public void setContactAddress(String contactAddress) {
        this.contactAddress = contactAddress;
    }

    public String getRank() {
        return rank;
    }

    public void setRank(String rank) {
        this.rank = rank;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getDateCommented() {
        return dateCommented;
    }

    public void setDateCommented(Date dateCommented) {
        this.dateCommented = dateCommented;
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
        if (!(object instanceof Applicantsreferees)) {
            return false;
        }
        Applicantsreferees other = (Applicantsreferees) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.bsutest.Applicantsreferees[ id=" + id + " ]";
    }

    /**
     * @return the applicantsId
     */
    public Applicants getApplicantsId() {
        return applicantsId;
    }

    /**
     * @param applicantsId the applicantsId to set
     */
    public void setApplicantsId(Applicants applicantsId) {
        this.applicantsId = applicantsId;
    }
    
}
