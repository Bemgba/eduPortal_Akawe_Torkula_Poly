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
@Table(name = "studentuniversitytransfer")
@NamedQueries({
    @NamedQuery(name = "Studentuniversitytransfer.findAll", query = "SELECT s FROM Studentuniversitytransfer s"),
    @NamedQuery(name = "Studentuniversitytransfer.findById", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.id = :id"),
    @NamedQuery(name = "Studentuniversitytransfer.findByRegistrationNo", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.registrationNo = :registrationNo"),
    @NamedQuery(name = "Studentuniversitytransfer.findBySession", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.session = :session"),
    @NamedQuery(name = "Studentuniversitytransfer.findByLevel", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.level = :level"),
    @NamedQuery(name = "Studentuniversitytransfer.findByDateCreated", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.dateCreated = :dateCreated"),
    @NamedQuery(name = "Studentuniversitytransfer.findByNote", query = "SELECT s FROM Studentuniversitytransfer s WHERE s.note = :note")})
public class Studentuniversitytransfer implements Serializable {

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
    @Column(name = "registration_no")
    private String registrationNo;
    @Size(max = 10)
    @Column(name = "session")
    private String session;
    @Size(max = 10)
    @Column(name = "level")
    private String level;
    @Column(name = "date_created")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCreated;
    @Size(max = 2147483647)
    @Column(name = "note")
    private String note;
    @JoinColumn(name = "course_from", referencedColumnName = "id")
    @ManyToOne
    private Courses courseFrom;
    @JoinColumn(name = "course_to", referencedColumnName = "id")
    @ManyToOne
    private Courses courseTo;
    @JoinColumn(name = "uni_from", referencedColumnName = "id")
    @ManyToOne
    private Universities uniFrom;
    @JoinColumn(name = "uni_to", referencedColumnName = "id")
    @ManyToOne
    private Universities uniTo;

    public Studentuniversitytransfer() {
    }

    public Studentuniversitytransfer(String id) {
        this.id = id;
    }

    public Studentuniversitytransfer(String id, String registrationNo) {
        this.id = id;
        this.registrationNo = registrationNo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Courses getCourseFrom() {
        return courseFrom;
    }

    public void setCourseFrom(Courses courseFrom) {
        this.courseFrom = courseFrom;
    }

    public Courses getCourseTo() {
        return courseTo;
    }

    public void setCourseTo(Courses courseTo) {
        this.courseTo = courseTo;
    }

    public Universities getUniFrom() {
        return uniFrom;
    }

    public void setUniFrom(Universities uniFrom) {
        this.uniFrom = uniFrom;
    }

    public Universities getUniTo() {
        return uniTo;
    }

    public void setUniTo(Universities uniTo) {
        this.uniTo = uniTo;
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
        if (!(object instanceof Studentuniversitytransfer)) {
            return false;
        }
        Studentuniversitytransfer other = (Studentuniversitytransfer) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Studentuniversitytransfer[ id=" + id + " ]";
    }
    
}
