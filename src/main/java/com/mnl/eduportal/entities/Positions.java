/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "positions")
@NamedQueries({
    @NamedQuery(name = "Positions.findAll", query = "SELECT p FROM Positions p"),
    @NamedQuery(name = "Positions.findById", query = "SELECT p FROM Positions p WHERE p.id = :id"),
    @NamedQuery(name = "Positions.findByName", query = "SELECT p FROM Positions p WHERE p.name = :name"),
    @NamedQuery(name = "Positions.findByAbbreviation", query = "SELECT p FROM Positions p WHERE p.abbreviation = :abbreviation"),
    @NamedQuery(name = "Positions.findByOrderValue", query = "SELECT p FROM Positions p WHERE p.orderValue = :orderValue")})
public class Positions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 150)
    @Column(name = "name")
    private String name;
    @Size(max = 50)
    @Column(name = "abbreviation")
    private String abbreviation;
    @Column(name = "order_value")
    private Integer orderValue;
    @OneToMany(mappedBy = "headTitle")
    private Collection<Courses> coursesCollection;
    @OneToMany(mappedBy = "headTitle")
    private Collection<Schools> schoolsCollection;
    @OneToMany(mappedBy = "headTitle")
    private Collection<Units> unitsCollection;
    @OneToMany(mappedBy = "headTitle")
    private Collection<FacultiesDirectorates> facultiesDirectoratesCollection;
    @OneToMany(mappedBy = "positionId")
    private Collection<Staff> staffCollection;
    @OneToMany(mappedBy = "headTitle")
    private Collection<Schoolprogrammes> schoolprogrammesCollection;

    public Positions() {
    }

    public Positions(String id) {
        this.id = id;
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

    public String getAbbreviation() {
        return abbreviation;
    }

    public void setAbbreviation(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    public Integer getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(Integer orderValue) {
        this.orderValue = orderValue;
    }

    public Collection<Courses> getCoursesCollection() {
        return coursesCollection;
    }

    public void setCoursesCollection(Collection<Courses> coursesCollection) {
        this.coursesCollection = coursesCollection;
    }

    public Collection<Schools> getSchoolsCollection() {
        return schoolsCollection;
    }

    public void setSchoolsCollection(Collection<Schools> schoolsCollection) {
        this.schoolsCollection = schoolsCollection;
    }

    public Collection<Units> getUnitsCollection() {
        return unitsCollection;
    }

    public void setUnitsCollection(Collection<Units> unitsCollection) {
        this.unitsCollection = unitsCollection;
    }

    public Collection<FacultiesDirectorates> getFacultiesDirectoratesCollection() {
        return facultiesDirectoratesCollection;
    }

    public void setFacultiesDirectoratesCollection(Collection<FacultiesDirectorates> facultiesDirectoratesCollection) {
        this.facultiesDirectoratesCollection = facultiesDirectoratesCollection;
    }

    public Collection<Staff> getStaffCollection() {
        return staffCollection;
    }

    public void setStaffCollection(Collection<Staff> staffCollection) {
        this.staffCollection = staffCollection;
    }

    public Collection<Schoolprogrammes> getSchoolprogrammesCollection() {
        return schoolprogrammesCollection;
    }

    public void setSchoolprogrammesCollection(Collection<Schoolprogrammes> schoolprogrammesCollection) {
        this.schoolprogrammesCollection = schoolprogrammesCollection;
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
        if (!(object instanceof Positions)) {
            return false;
        }
        Positions other = (Positions) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Positions[ id=" + id + " ]";
    }
    
}
