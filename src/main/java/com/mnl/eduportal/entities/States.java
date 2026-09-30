/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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
@Table(name = "states")
@NamedQueries({
    @NamedQuery(name = "States.findAll", query = "SELECT s FROM States s"),
    @NamedQuery(name = "States.findById", query = "SELECT s FROM States s WHERE s.id = :id"),
    @NamedQuery(name = "States.findByName", query = "SELECT s FROM States s WHERE s.name = :name"),
    @NamedQuery(name = "States.findByCode", query = "SELECT s FROM States s WHERE s.code = :code")})
public class States implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Size(max = 2147483647)
    @Column(name = "name")
    private String name;
    @Size(max = 2147483647)
    @Column(name = "code")
    private String code;
    @OneToMany(mappedBy = "stateOfOrigin", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Applicants> applicantsCollection;
    @OneToMany(mappedBy = "state")
    private Collection<Universities> universitiesCollection;
    @OneToMany(mappedBy = "stateOfOriginId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Admissions> admissionsCollection;
    @OneToMany(mappedBy = "stateOfOriginId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Utmeapplicants> utmeapplicantsCollection;
    @OneToMany(mappedBy = "stateOfOrigin", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Students> studentsCollection;
    @OneToMany(mappedBy = "state", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Applicantsbiodata> applicantsbiodataCollection;
    @JoinColumn(name = "country_id", referencedColumnName = "id")
    @ManyToOne
    private Countries countryId;
    @OneToMany(mappedBy = "stateId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Lgas> lgasCollection;
    @OneToMany(mappedBy = "stateOfOriginId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Staff> staffCollection;

    public States() {
    }

    public States(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
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

    public Collection<Applicants> getApplicantsCollection() {
        return applicantsCollection;
    }

    public void setApplicantsCollection(Collection<Applicants> applicantsCollection) {
        this.applicantsCollection = applicantsCollection;
    }

    public Collection<Universities> getUniversitiesCollection() {
        return universitiesCollection;
    }

    public void setUniversitiesCollection(Collection<Universities> universitiesCollection) {
        this.universitiesCollection = universitiesCollection;
    }

    public Collection<Admissions> getAdmissionsCollection() {
        return admissionsCollection;
    }

    public void setAdmissionsCollection(Collection<Admissions> admissionsCollection) {
        this.admissionsCollection = admissionsCollection;
    }

    public Collection<Utmeapplicants> getUtmeapplicantsCollection() {
        return utmeapplicantsCollection;
    }

    public void setUtmeapplicantsCollection(Collection<Utmeapplicants> utmeapplicantsCollection) {
        this.utmeapplicantsCollection = utmeapplicantsCollection;
    }

    public Collection<Students> getStudentsCollection() {
        return studentsCollection;
    }

    public void setStudentsCollection(Collection<Students> studentsCollection) {
        this.studentsCollection = studentsCollection;
    }

    public Countries getCountryId() {
        return countryId;
    }

    public void setCountryId(Countries countryId) {
        this.countryId = countryId;
    }

    public Collection<Lgas> getLgasCollection() {
        return lgasCollection;
    }

    public void setLgasCollection(Collection<Lgas> lgasCollection) {
        this.lgasCollection = lgasCollection;
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
        if (!(object instanceof States)) {
            return false;
        }
        States other = (States) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.States[ id=" + id + " ]";
    }

    /**
     * @return the applicantsbiodataCollection
     */
    public Collection<Applicantsbiodata> getApplicantsbiodataCollection() {
        return applicantsbiodataCollection;
    }

    /**
     * @param applicantsbiodataCollection the applicantsbiodataCollection to set
     */
    public void setApplicantsbiodataCollection(Collection<Applicantsbiodata> applicantsbiodataCollection) {
        this.applicantsbiodataCollection = applicantsbiodataCollection;
    }
    
}
