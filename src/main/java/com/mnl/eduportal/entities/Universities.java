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
@Table(name = "universities")
@NamedQueries({
    @NamedQuery(name = "Universities.findAll", query = "SELECT u FROM Universities u"),
    @NamedQuery(name = "Universities.findById", query = "SELECT u FROM Universities u WHERE u.id = :id"),
    @NamedQuery(name = "Universities.findByName", query = "SELECT u FROM Universities u WHERE u.name = :name"),
    @NamedQuery(name = "Universities.findByUniversityType", query = "SELECT u FROM Universities u WHERE u.universityType = :universityType")})
public class Universities implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "name")
    private String name;
    @Size(max = 50)
    @Column(name = "university_type")
    private String universityType;
    @OneToMany(mappedBy = "uniFrom")
    private Collection<Studentuniversitytransfer> studentuniversitytransferCollection;
    @OneToMany(mappedBy = "uniTo")
    private Collection<Studentuniversitytransfer> studentuniversitytransferCollection1;
    @JoinColumn(name = "country", referencedColumnName = "id")
    @ManyToOne
    private Countries country;
    @JoinColumn(name = "state", referencedColumnName = "id")
    @ManyToOne
    private States state;

    public Universities() {
    }

    public Universities(String id) {
        this.id = id;
    }

    public Universities(String id, String name) {
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

    public String getUniversityType() {
        return universityType;
    }

    public void setUniversityType(String universityType) {
        this.universityType = universityType;
    }

    public Collection<Studentuniversitytransfer> getStudentuniversitytransferCollection() {
        return studentuniversitytransferCollection;
    }

    public void setStudentuniversitytransferCollection(Collection<Studentuniversitytransfer> studentuniversitytransferCollection) {
        this.studentuniversitytransferCollection = studentuniversitytransferCollection;
    }

    public Collection<Studentuniversitytransfer> getStudentuniversitytransferCollection1() {
        return studentuniversitytransferCollection1;
    }

    public void setStudentuniversitytransferCollection1(Collection<Studentuniversitytransfer> studentuniversitytransferCollection1) {
        this.studentuniversitytransferCollection1 = studentuniversitytransferCollection1;
    }

    public Countries getCountry() {
        return country;
    }

    public void setCountry(Countries country) {
        this.country = country;
    }

    public States getState() {
        return state;
    }

    public void setState(States state) {
        this.state = state;
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
        if (!(object instanceof Universities)) {
            return false;
        }
        Universities other = (Universities) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Universities[ id=" + id + " ]";
    }
    
}
