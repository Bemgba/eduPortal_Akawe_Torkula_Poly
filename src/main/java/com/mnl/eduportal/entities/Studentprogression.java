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
@Table(name = "studentprogression")
@NamedQueries({
    @NamedQuery(name = "Studentprogression.findAll", query = "SELECT s FROM Studentprogression s"),
    @NamedQuery(name = "Studentprogression.findById", query = "SELECT s FROM Studentprogression s WHERE s.id = :id"),
    @NamedQuery(name = "Studentprogression.findBySessionAdded", query = "SELECT s FROM Studentprogression s WHERE s.sessionAdded = :sessionAdded"),
    @NamedQuery(name = "Studentprogression.findByLevelAdded", query = "SELECT s FROM Studentprogression s WHERE s.levelAdded = :levelAdded"),
    @NamedQuery(name = "Studentprogression.findByDateAdded", query = "SELECT s FROM Studentprogression s WHERE s.dateAdded = :dateAdded"),
    @NamedQuery(name = "Studentprogression.findBySemesterAdded", query = "SELECT s FROM Studentprogression s WHERE s.semesterAdded = :semesterAdded"),
    @NamedQuery(name = "Studentprogression.findByStatus", query = "SELECT s FROM Studentprogression s WHERE s.status = :status"),
    @NamedQuery(name = "Studentprogression.findByRegistrationStatus", query = "SELECT s FROM Studentprogression s WHERE s.registrationStatus = :registrationStatus"),
    @NamedQuery(name = "Studentprogression.findByDateRegistered", query = "SELECT s FROM Studentprogression s WHERE s.dateRegistered = :dateRegistered")})
public class Studentprogression implements Serializable {

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
    @Column(name = "session_added")
    private String sessionAdded;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 5)
    @Column(name = "level_added")
    private String levelAdded;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "semester_added")
    private String semesterAdded;
    @Size(max = 100)
    @Column(name = "status")
    private String status;
    @Size(max = 50)
    @Column(name = "registration_status")
    private String registrationStatus;
    @Column(name = "date_registered")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateRegistered;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @JoinColumn(name = "students_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentsId;

    public Studentprogression() {
    }

    public Studentprogression(String id) {
        this.id = id;
    }

    public Studentprogression(String id, String sessionAdded, String levelAdded, String semesterAdded) {
        this.id = id;
        this.sessionAdded = sessionAdded;
        this.levelAdded = levelAdded;
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

    public String getLevelAdded() {
        return levelAdded;
    }

    public void setLevelAdded(String levelAdded) {
        this.levelAdded = levelAdded;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getSemesterAdded() {
        return semesterAdded;
    }

    public void setSemesterAdded(String semesterAdded) {
        this.semesterAdded = semesterAdded;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(String registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    public Date getDateRegistered() {
        return dateRegistered;
    }

    public void setDateRegistered(Date dateRegistered) {
        this.dateRegistered = dateRegistered;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Students getStudentsId() {
        return studentsId;
    }

    public void setStudentsId(Students studentsId) {
        this.studentsId = studentsId;
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
        if (!(object instanceof Studentprogression)) {
            return false;
        }
        Studentprogression other = (Studentprogression) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Studentprogression[ id=" + id + " ]";
    }
    
}
