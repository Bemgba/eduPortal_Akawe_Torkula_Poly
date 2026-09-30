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
 * @author nguuma-ayua
 */
@Entity
@Table(name = "hostelapplication")
@NamedQueries({
    @NamedQuery(name = "Hostelapplication.findAll", query = "SELECT h FROM Hostelapplication h"),
    @NamedQuery(name = "Hostelapplication.findById", query = "SELECT h FROM Hostelapplication h WHERE h.id = :id"),
    @NamedQuery(name = "Hostelapplication.findBySessions", query = "SELECT h FROM Hostelapplication h WHERE h.sessions = :sessions"),
    @NamedQuery(name = "Hostelapplication.findByDateStarted", query = "SELECT h FROM Hostelapplication h WHERE h.dateStarted = :dateStarted"),
    @NamedQuery(name = "Hostelapplication.findByDateAllocated", query = "SELECT h FROM Hostelapplication h WHERE h.dateAllocated = :dateAllocated"),
    @NamedQuery(name = "Hostelapplication.findByApplicationStatus", query = "SELECT h FROM Hostelapplication h WHERE h.applicationStatus = :applicationStatus")})
public class Hostelapplication implements Serializable {

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
    @Column(name = "sessions")
    private String sessions;
    @Column(name = "date_started")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateStarted;
    @Column(name = "date_allocated")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAllocated;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "application_status")
    private String applicationStatus;
    @JoinColumn(name = "hostel_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Hostels hostelId;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;

    public Hostelapplication() {
    }

    public Hostelapplication(String id) {
        this.id = id;
    }

    public Hostelapplication(String id, String sessions, String applicationStatus) {
        this.id = id;
        this.sessions = sessions;
        this.applicationStatus = applicationStatus;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSessions() {
        return sessions;
    }

    public void setSessions(String sessions) {
        this.sessions = sessions;
    }

    public Date getDateStarted() {
        return dateStarted;
    }

    public void setDateStarted(Date dateStarted) {
        this.dateStarted = dateStarted;
    }

    public Date getDateAllocated() {
        return dateAllocated;
    }

    public void setDateAllocated(Date dateAllocated) {
        this.dateAllocated = dateAllocated;
    }

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public Hostels getHostelId() {
        return hostelId;
    }

    public void setHostelId(Hostels hostelId) {
        this.hostelId = hostelId;
    }

    public Students getStudentId() {
        return studentId;
    }

    public void setStudentId(Students studentId) {
        this.studentId = studentId;
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
        if (!(object instanceof Hostelapplication)) {
            return false;
        }
        Hostelapplication other = (Hostelapplication) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.testebj.entities.Hostelapplication[ id=" + id + " ]";
    }
    
}
