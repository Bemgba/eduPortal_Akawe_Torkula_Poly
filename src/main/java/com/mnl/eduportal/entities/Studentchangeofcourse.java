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
@Table(name = "studentchangeofcourse")
@NamedQueries({
    @NamedQuery(name = "Studentchangeofcourse.findAll", query = "SELECT s FROM Studentchangeofcourse s"),
    @NamedQuery(name = "Studentchangeofcourse.findById", query = "SELECT s FROM Studentchangeofcourse s WHERE s.id = :id"),
    @NamedQuery(name = "Studentchangeofcourse.findByRegistrationNo", query = "SELECT s FROM Studentchangeofcourse s WHERE s.registrationNo = :registrationNo"),
    @NamedQuery(name = "Studentchangeofcourse.findBySession", query = "SELECT s FROM Studentchangeofcourse s WHERE s.session = :session"),
    @NamedQuery(name = "Studentchangeofcourse.findByLevelAt", query = "SELECT s FROM Studentchangeofcourse s WHERE s.levelAt = :levelAt"),
    @NamedQuery(name = "Studentchangeofcourse.findByCurrentLevel", query = "SELECT s FROM Studentchangeofcourse s WHERE s.currentLevel = :currentLevel"),
    @NamedQuery(name = "Studentchangeofcourse.findByDateCreated", query = "SELECT s FROM Studentchangeofcourse s WHERE s.dateCreated = :dateCreated")})
public class Studentchangeofcourse implements Serializable {

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
    @Column(name = "level_at")
    private String levelAt;
    @Size(max = 10)
    @Column(name = "current_level")
    private String currentLevel;
    @Column(name = "date_created")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCreated;
    @JoinColumn(name = "course_from", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseFrom;
    @JoinColumn(name = "course_to", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseTo;

    public Studentchangeofcourse() {
    }

    public Studentchangeofcourse(String id) {
        this.id = id;
    }

    public Studentchangeofcourse(String id, String registrationNo) {
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

    public String getLevelAt() {
        return levelAt;
    }

    public void setLevelAt(String levelAt) {
        this.levelAt = levelAt;
    }

    public String getCurrentLevel() {
        return currentLevel;
    }

    public void setCurrentLevel(String currentLevel) {
        this.currentLevel = currentLevel;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Studentchangeofcourse)) {
            return false;
        }
        Studentchangeofcourse other = (Studentchangeofcourse) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Studentchangeofcourse[ id=" + id + " ]";
    }
    
}
