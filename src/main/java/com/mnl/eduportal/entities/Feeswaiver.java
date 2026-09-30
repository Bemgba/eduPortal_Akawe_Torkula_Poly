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
@Table(name = "feeswaiver")
@NamedQueries({
    @NamedQuery(name = "Feeswaiver.findAll", query = "SELECT f FROM Feeswaiver f"),
    @NamedQuery(name = "Feeswaiver.findById", query = "SELECT f FROM Feeswaiver f WHERE f.id = :id"),
    @NamedQuery(name = "Feeswaiver.findBySessionAdded", query = "SELECT f FROM Feeswaiver f WHERE f.sessionAdded = :sessionAdded"),
    @NamedQuery(name = "Feeswaiver.findBySemesterAdded", query = "SELECT f FROM Feeswaiver f WHERE f.semesterAdded = :semesterAdded"),
    @NamedQuery(name = "Feeswaiver.findByNote", query = "SELECT f FROM Feeswaiver f WHERE f.note = :note"),
    @NamedQuery(name = "Feeswaiver.findByDocUrl", query = "SELECT f FROM Feeswaiver f WHERE f.docUrl = :docUrl"),
    @NamedQuery(name = "Feeswaiver.findByDateAdded", query = "SELECT f FROM Feeswaiver f WHERE f.dateAdded = :dateAdded")})
public class Feeswaiver implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "session_added")
    private String sessionAdded;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "semester_added")
    private String semesterAdded;
    @Size(max = 200)
    @Column(name = "note")
    private String note;
    @Size(max = 200)
    @Column(name = "doc_url")
    private String docUrl;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;
    @JoinColumn(name = "added_by", referencedColumnName = "id")
    @ManyToOne
    private Users addedBy;

    public Feeswaiver() {
    }

    public Feeswaiver(String id) {
        this.id = id;
    }

    public Feeswaiver(String id, String sessionAdded, String semesterAdded) {
        this.id = id;
        this.sessionAdded = sessionAdded;
        this.semesterAdded = semesterAdded;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSessionAdded() {
        return sessionAdded;
    }

    public void setSessionAdded(String sessionAdded) {
        this.sessionAdded = sessionAdded;
    }

    public String getSemesterAdded() {
        return semesterAdded;
    }

    public void setSemesterAdded(String semesterAdded) {
        this.semesterAdded = semesterAdded;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getDocUrl() {
        return docUrl;
    }

    public void setDocUrl(String docUrl) {
        this.docUrl = docUrl;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Students getStudentId() {
        return studentId;
    }

    public void setStudentId(Students studentId) {
        this.studentId = studentId;
    }

    public Users getAddedBy() {
        return addedBy;
    }

    public void setAddedBy(Users addedBy) {
        this.addedBy = addedBy;
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
        if (!(object instanceof Feeswaiver)) {
            return false;
        }
        Feeswaiver other = (Feeswaiver) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.testebj.entities.Feeswaiver[ id=" + id + " ]";
    }
    
}
