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
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "departments")
@NamedQueries({
    @NamedQuery(name = "Departments.findAll", query = "SELECT d FROM Departments d"),
    @NamedQuery(name = "Departments.findById", query = "SELECT d FROM Departments d WHERE d.id = :id"),
    @NamedQuery(name = "Departments.findByName", query = "SELECT d FROM Departments d WHERE d.name = :name"),
    @NamedQuery(name = "Departments.findByCode", query = "SELECT d FROM Departments d WHERE d.code = :code"),
    @NamedQuery(name = "Departments.findByDateAdded", query = "SELECT d FROM Departments d WHERE d.dateAdded = :dateAdded")})
public class Departments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 100)
    @Column(name = "name")
    private String name;
    @Size(max = 50)
    @Column(name = "code")
    private String code;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @OneToMany(mappedBy = "departmentId")
    private Collection<Userdepartments> userdepartmentsCollection;
    @OneToMany(mappedBy = "departmentId")
    private Collection<Units> unitsCollection;
    @JoinColumn(name = "faculty_id", referencedColumnName = "id")
    @ManyToOne
    private FacultiesDirectorates facultyId;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @ManyToOne
    private Users headId;
    @OneToMany(mappedBy = "departmentId")
    private Collection<Staff> staffCollection;

    public Departments() {
    }

    public Departments(String id) {
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Collection<Userdepartments> getUserdepartmentsCollection() {
        return userdepartmentsCollection;
    }

    public void setUserdepartmentsCollection(Collection<Userdepartments> userdepartmentsCollection) {
        this.userdepartmentsCollection = userdepartmentsCollection;
    }

    public Collection<Units> getUnitsCollection() {
        return unitsCollection;
    }

    public void setUnitsCollection(Collection<Units> unitsCollection) {
        this.unitsCollection = unitsCollection;
    }

    public FacultiesDirectorates getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(FacultiesDirectorates facultyId) {
        this.facultyId = facultyId;
    }

    public Users getHeadId() {
        return headId;
    }

    public void setHeadId(Users headId) {
        this.headId = headId;
    }

    public Collection<Staff> getStaffCollection() {
        return staffCollection;
    }

    public void setStaffCollection(Collection<Staff> staffCollection) {
        this.staffCollection = staffCollection;
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
        if (!(object instanceof Departments)) {
            return false;
        }
        Departments other = (Departments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Departments[ id=" + id + " ]";
    }
    
}
