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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author nguuma-ayua
 */
@Entity
@Table(name = "summerschoolregistration")
@NamedQueries({
    @NamedQuery(name = "Summerschoolregistration.findAll", query = "SELECT s FROM Summerschoolregistration s"),
    @NamedQuery(name = "Summerschoolregistration.findById", query = "SELECT s FROM Summerschoolregistration s WHERE s.id = :id")})
public class Summerschoolregistration implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @JoinColumn(name = "semester_course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Semestercourses semesterCourseId;
    @JoinColumn(name = "application_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Summerschoolapplication applicationId;

    public Summerschoolregistration() {
    }

    public Summerschoolregistration(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Semestercourses getSemesterCourseId() {
        return semesterCourseId;
    }

    public void setSemesterCourseId(Semestercourses semesterCourseId) {
        this.semesterCourseId = semesterCourseId;
    }

    public Summerschoolapplication getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Summerschoolapplication applicationId) {
        this.applicationId = applicationId;
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
        if (!(object instanceof Summerschoolregistration)) {
            return false;
        }
        Summerschoolregistration other = (Summerschoolregistration) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.postgresentity.entities.Summerschoolregistration[ id=" + id + " ]";
    }
    
}
