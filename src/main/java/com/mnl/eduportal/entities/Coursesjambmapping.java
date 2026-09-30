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
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "coursesjambmapping")
@NamedQueries({
    @NamedQuery(name = "Coursesjambmapping.findAll", query = "SELECT c FROM Coursesjambmapping c"),
    @NamedQuery(name = "Coursesjambmapping.findById", query = "SELECT c FROM Coursesjambmapping c WHERE c.id = :id"),
    @NamedQuery(name = "Coursesjambmapping.findByJamdName", query = "SELECT c FROM Coursesjambmapping c WHERE c.jamdName = :jamdName")})
public class Coursesjambmapping implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "jamd_name")
    private String jamdName;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Courses courses;
    @JoinColumn(name = "school_programmes_id", referencedColumnName = "id")
    @ManyToOne
    private Schoolprogrammes schoolProgrammesId;

    public Coursesjambmapping() {
    }

    public Coursesjambmapping(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getJamdName() {
        return jamdName;
    }

    public void setJamdName(String jamdName) {
        this.jamdName = jamdName;
    }

    public Courses getCourses() {
        return courses;
    }

    public void setCourses(Courses courses) {
        this.courses = courses;
    }

    public Schoolprogrammes getSchoolProgrammesId() {
        return schoolProgrammesId;
    }

    public void setSchoolProgrammesId(Schoolprogrammes schoolProgrammesId) {
        this.schoolProgrammesId = schoolProgrammesId;
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
        if (!(object instanceof Coursesjambmapping)) {
            return false;
        }
        Coursesjambmapping other = (Coursesjambmapping) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.bsutest.Coursesjambmapping[ id=" + id + " ]";
    }
    
}
