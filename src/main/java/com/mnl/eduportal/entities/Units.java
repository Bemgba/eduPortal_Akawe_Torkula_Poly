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
@Table(name = "units")
@NamedQueries({
    @NamedQuery(name = "Units.findAll", query = "SELECT u FROM Units u"),
    @NamedQuery(name = "Units.findById", query = "SELECT u FROM Units u WHERE u.id = :id"),
    @NamedQuery(name = "Units.findByName", query = "SELECT u FROM Units u WHERE u.name = :name")})
public class Units implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "name")
    private String name;
    @JoinColumn(name = "department_id", referencedColumnName = "id")
    @ManyToOne
    private Departments departmentId;
    @JoinColumn(name = "head_title", referencedColumnName = "id")
    @ManyToOne
    private Positions headTitle;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @ManyToOne
    private Users headId;
    @OneToMany(mappedBy = "unitId")
    private Collection<Staff> staffCollection;
    @OneToMany(mappedBy = "unitsId")
    private Collection<Userunits> userunitsCollection;

    public Units() {
    }

    public Units(String id) {
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

    public Departments getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Departments departmentId) {
        this.departmentId = departmentId;
    }

    public Positions getHeadTitle() {
        return headTitle;
    }

    public void setHeadTitle(Positions headTitle) {
        this.headTitle = headTitle;
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

    public Collection<Userunits> getUserunitsCollection() {
        return userunitsCollection;
    }

    public void setUserunitsCollection(Collection<Userunits> userunitsCollection) {
        this.userunitsCollection = userunitsCollection;
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
        if (!(object instanceof Units)) {
            return false;
        }
        Units other = (Units) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Units[ id=" + id + " ]";
    }
    
}
