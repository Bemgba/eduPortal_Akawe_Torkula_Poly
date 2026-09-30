/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author nguuma-ayua
 */
@Entity
@Table(name = "summerschoolstatus")
@NamedQueries({
    @NamedQuery(name = "Summerschoolstatus.findAll", query = "SELECT s FROM Summerschoolstatus s"),
    @NamedQuery(name = "Summerschoolstatus.findById", query = "SELECT s FROM Summerschoolstatus s WHERE s.id = :id"),
    @NamedQuery(name = "Summerschoolstatus.findBySessionStarted", query = "SELECT s FROM Summerschoolstatus s WHERE s.sessionStarted = :sessionStarted"),
    @NamedQuery(name = "Summerschoolstatus.findByDateOpened", query = "SELECT s FROM Summerschoolstatus s WHERE s.dateOpened = :dateOpened"),
    @NamedQuery(name = "Summerschoolstatus.findByApplicationStatus", query = "SELECT s FROM Summerschoolstatus s WHERE s.applicationStatus = :applicationStatus"),
    @NamedQuery(name = "Summerschoolstatus.findByStatusComment", query = "SELECT s FROM Summerschoolstatus s WHERE s.statusComment = :statusComment")})
public class Summerschoolstatus implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session_started")
    private String sessionStarted;
    @Column(name = "date_opened")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOpened;
    @Size(max = 20)
    @Column(name = "application_status")
    private String applicationStatus;
    @Size(max = 2147483647)
    @Column(name = "status_comment")
    private String statusComment;
    @JoinColumn(name = "school_programme_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schoolprogrammes schoolProgrammeId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "summerSchoolStatusId")
    private List<Summerschoolapplication> summerschoolapplicationList;

    public Summerschoolstatus() {
    }

    public Summerschoolstatus(String id) {
        this.id = id;
    }

    public Summerschoolstatus(String id, String sessionStarted) {
        this.id = id;
        this.sessionStarted = sessionStarted;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSessionStarted() {
        return sessionStarted;
    }

    public void setSessionStarted(String sessionStarted) {
        this.sessionStarted = sessionStarted;
    }

    public Date getDateOpened() {
        return dateOpened;
    }

    public void setDateOpened(Date dateOpened) {
        this.dateOpened = dateOpened;
    }

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public String getStatusComment() {
        return statusComment;
    }

    public void setStatusComment(String statusComment) {
        this.statusComment = statusComment;
    }

    public List<Summerschoolapplication> getSummerschoolapplicationList() {
        return summerschoolapplicationList;
    }

    public void setSummerschoolapplicationList(List<Summerschoolapplication> summerschoolapplicationList) {
        this.summerschoolapplicationList = summerschoolapplicationList;
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
        if (!(object instanceof Summerschoolstatus)) {
            return false;
        }
        Summerschoolstatus other = (Summerschoolstatus) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.postgresentity.entities.Summerschoolstatus[ id=" + id + " ]";
    }

    /**
     * @return the schoolProgrammeId
     */
    public Schoolprogrammes getSchoolProgrammeId() {
        return schoolProgrammeId;
    }

    /**
     * @param schoolProgrammeId the schoolProgrammeId to set
     */
    public void setSchoolProgrammeId(Schoolprogrammes schoolProgrammeId) {
        this.schoolProgrammeId = schoolProgrammeId;
    }
    
}
