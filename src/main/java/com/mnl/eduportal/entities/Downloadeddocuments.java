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
@Table(name = "downloadeddocuments")
@NamedQueries({
    @NamedQuery(name = "Downloadeddocuments.findAll", query = "SELECT d FROM Downloadeddocuments d"),
    @NamedQuery(name = "Downloadeddocuments.findById", query = "SELECT d FROM Downloadeddocuments d WHERE d.id = :id"),
    @NamedQuery(name = "Downloadeddocuments.findByName", query = "SELECT d FROM Downloadeddocuments d WHERE d.name = :name"),
    @NamedQuery(name = "Downloadeddocuments.findByDateLastDownloaded", query = "SELECT d FROM Downloadeddocuments d WHERE d.dateLastDownloaded = :dateLastDownloaded"),
    @NamedQuery(name = "Downloadeddocuments.findByTimesDownloaded", query = "SELECT d FROM Downloadeddocuments d WHERE d.timesDownloaded = :timesDownloaded"),
    @NamedQuery(name = "Downloadeddocuments.findByDocumentType", query = "SELECT d FROM Downloadeddocuments d WHERE d.documentType = :documentType"),
    @NamedQuery(name = "Downloadeddocuments.findByUserId", query = "SELECT d FROM Downloadeddocuments d WHERE d.userId = :userId"),
    @NamedQuery(name = "Downloadeddocuments.findBySession", query = "SELECT d FROM Downloadeddocuments d WHERE d.session = :session"),
    @NamedQuery(name = "Downloadeddocuments.findBySemester", query = "SELECT d FROM Downloadeddocuments d WHERE d.semester = :semester")})
public class Downloadeddocuments implements Serializable {

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
    @Column(name = "name")
    private String name;
    @Column(name = "date_last_downloaded")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateLastDownloaded;
    @Column(name = "times_downloaded")
    private Integer timesDownloaded;
    @Size(max = 100)
    @Column(name = "document_type")
    private String documentType;
    @Size(max = 50)
    @Column(name = "user_id")
    private String userId;
    @Size(max = 10)
    @Column(name = "session")
    private String session;
    @Size(max = 10)
    @Column(name = "semester")
    private String semester;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schools schoolId;

    public Downloadeddocuments() {
    }

    public Downloadeddocuments(String id) {
        this.id = id;
    }

    public Downloadeddocuments(String id, String name) {
        this.id = id;
        this.name = name;
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

    public Date getDateLastDownloaded() {
        return dateLastDownloaded;
    }

    public void setDateLastDownloaded(Date dateLastDownloaded) {
        this.dateLastDownloaded = dateLastDownloaded;
    }

    public Integer getTimesDownloaded() {
        return timesDownloaded;
    }

    public void setTimesDownloaded(Integer timesDownloaded) {
        this.timesDownloaded = timesDownloaded;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
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
        if (!(object instanceof Downloadeddocuments)) {
            return false;
        }
        Downloadeddocuments other = (Downloadeddocuments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Downloadeddocuments[ id=" + id + " ]";
    }
    
}
