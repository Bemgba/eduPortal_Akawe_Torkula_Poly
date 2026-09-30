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
 * @author eaglescan
 */
@Entity
@Table(name = "semesterregistrationpreriquisites")
@NamedQueries({
    @NamedQuery(name = "Semesterregistrationpreriquisites.findAll", query = "SELECT s FROM Semesterregistrationpreriquisites s"),
    @NamedQuery(name = "Semesterregistrationpreriquisites.findById", query = "SELECT s FROM Semesterregistrationpreriquisites s WHERE s.id = :id")})
public class Semesterregistrationpreriquisites implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @JoinColumn(name = "semester_registration_course_id", referencedColumnName = "id")
    @ManyToOne
    private Semesterregistrationcourses semesterRegistrationCourseId;
    @JoinColumn(name = "semester_course_id", referencedColumnName = "id")
    @ManyToOne
    private Semesterregistrationcourses semesterCourseId;

    public Semesterregistrationpreriquisites() {
    }

    public Semesterregistrationpreriquisites(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Semesterregistrationcourses getSemesterRegistrationCourseId() {
        return semesterRegistrationCourseId;
    }

    public void setSemesterRegistrationCourseId(Semesterregistrationcourses semesterRegistrationCourseId) {
        this.semesterRegistrationCourseId = semesterRegistrationCourseId;
    }

    public Semesterregistrationcourses getSemesterCourseId() {
        return semesterCourseId;
    }

    public void setSemesterCourseId(Semesterregistrationcourses semesterCourseId) {
        this.semesterCourseId = semesterCourseId;
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
        if (!(object instanceof Semesterregistrationpreriquisites)) {
            return false;
        }
        Semesterregistrationpreriquisites other = (Semesterregistrationpreriquisites) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semesterregistrationpreriquisites[ id=" + id + " ]";
    }
    
}
