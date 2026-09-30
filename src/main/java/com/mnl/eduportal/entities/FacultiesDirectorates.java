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
import jakarta.persistence.OneToOne;
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
@Table(name = "faculties_directorates")
@NamedQueries({
    @NamedQuery(name = "FacultiesDirectorates.findAll", query = "SELECT f FROM FacultiesDirectorates f"),
    @NamedQuery(name = "FacultiesDirectorates.findById", query = "SELECT f FROM FacultiesDirectorates f WHERE f.id = :id"),
    @NamedQuery(name = "FacultiesDirectorates.findByName", query = "SELECT f FROM FacultiesDirectorates f WHERE f.name = :name"),
    @NamedQuery(name = "FacultiesDirectorates.findByCode", query = "SELECT f FROM FacultiesDirectorates f WHERE f.code = :code"),
    @NamedQuery(name = "FacultiesDirectorates.findByOrderValue", query = "SELECT f FROM FacultiesDirectorates f WHERE f.orderValue = :orderValue"),
    @NamedQuery(name = "FacultiesDirectorates.findByAcadAdmin", query = "SELECT f FROM FacultiesDirectorates f WHERE f.acadAdmin = :acadAdmin")})
public class FacultiesDirectorates implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @Size(max = 2147483647)
    @Column(name = "name")
    private String name;
    @Size(max = 2147483647)
    @Column(name = "code")
    private String code;
    @Column(name = "order_value")
    private Integer orderValue;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "acad_admin")
    private String acadAdmin;
    @OneToMany(mappedBy = "facultyId")
    private Collection<Userfaculties> userfacultiesCollection;
    @JoinColumn(name = "head_title", referencedColumnName = "id")
    @ManyToOne
    private Positions headTitle;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @OneToOne
    private Users headId;
    @OneToMany(mappedBy = "facultyId")
    private Collection<Departments> departmentsCollection;
    @OneToMany(mappedBy = "facultyDirectorateId")
    private Collection<Staff> staffCollection;
    @OneToMany(mappedBy = "approvalLevel2User")
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection;

    public FacultiesDirectorates() {
    }

    public FacultiesDirectorates(String id) {
        this.id = id;
    }

    public FacultiesDirectorates(String id, String acadAdmin) {
        this.id = id;
        this.acadAdmin = acadAdmin;
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

    public Integer getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(Integer orderValue) {
        this.orderValue = orderValue;
    }

    public String getAcadAdmin() {
        return acadAdmin;
    }

    public void setAcadAdmin(String acadAdmin) {
        this.acadAdmin = acadAdmin;
    }

    public Collection<Userfaculties> getUserfacultiesCollection() {
        return userfacultiesCollection;
    }

    public void setUserfacultiesCollection(Collection<Userfaculties> userfacultiesCollection) {
        this.userfacultiesCollection = userfacultiesCollection;
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

    public Collection<Departments> getDepartmentsCollection() {
        return departmentsCollection;
    }

    public void setDepartmentsCollection(Collection<Departments> departmentsCollection) {
        this.departmentsCollection = departmentsCollection;
    }

    public Collection<Staff> getStaffCollection() {
        return staffCollection;
    }

    public void setStaffCollection(Collection<Staff> staffCollection) {
        this.staffCollection = staffCollection;
    }

    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection() {
        return semesterregistrationsummaryCollection;
    }

    public void setSemesterregistrationsummaryCollection(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection) {
        this.semesterregistrationsummaryCollection = semesterregistrationsummaryCollection;
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
        if (!(object instanceof FacultiesDirectorates)) {
            return false;
        }
        FacultiesDirectorates other = (FacultiesDirectorates) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.FacultiesDirectorates[ id=" + id + " ]";
    }
    
}
