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
@Table(name = "countries")
@NamedQueries({
    @NamedQuery(name = "Countries.findAll", query = "SELECT c FROM Countries c"),
    @NamedQuery(name = "Countries.findById", query = "SELECT c FROM Countries c WHERE c.id = :id"),
    @NamedQuery(name = "Countries.findByName", query = "SELECT c FROM Countries c WHERE c.name = :name"),
    @NamedQuery(name = "Countries.findByCode", query = "SELECT c FROM Countries c WHERE c.code = :code")})
public class Countries implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "name")
    private String name;
    @Size(max = 10)
    @Column(name = "code")
    private String code;
     @OneToMany(mappedBy = "nationality")
    private Collection<Applicantsbiodata> applicantsbiodataCollection;
    @OneToMany(mappedBy = "country")
    private Collection<Applicants> applicantsCollection;
    @OneToMany(mappedBy = "country")
    private Collection<Universities> universitiesCollection;
    @OneToMany(mappedBy = "countryId")
    private Collection<Transcriptapplication> transcriptapplicationCollection;
    @OneToMany(mappedBy = "nationalityId")
    private Collection<Admissions> admissionsCollection;
    @OneToMany(mappedBy = "nationalityId")
    private Collection<Utmeapplicants> utmeapplicantsCollection;
    @OneToMany(mappedBy = "nationality")
    private Collection<Students> studentsCollection;
    @OneToMany(mappedBy = "countryId")
    private Collection<States> statesCollection;
    @OneToMany(mappedBy = "nationalityId")
    private Collection<Staff> staffCollection;

    public Countries() {
    }

    public Countries(Integer id) {
        this.id = id;
    }

    public Countries(Integer id, String name) {
        this.id = id;
        this.name = name;
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

    public Collection<Transcriptapplication> getTranscriptapplicationCollection() {
        return transcriptapplicationCollection;
    }

    public void setTranscriptapplicationCollection(Collection<Transcriptapplication> transcriptapplicationCollection) {
        this.transcriptapplicationCollection = transcriptapplicationCollection;
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

    public Collection<States> getStatesCollection() {
        return statesCollection;
    }

    public void setStatesCollection(Collection<States> statesCollection) {
        this.statesCollection = statesCollection;
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
        if (!(object instanceof Countries)) {
            return false;
        }
        Countries other = (Countries) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Countries[ id=" + id + " ]";
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
