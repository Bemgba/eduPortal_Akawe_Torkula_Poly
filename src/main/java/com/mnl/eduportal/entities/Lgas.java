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
@Table(name = "lgas")
@NamedQueries({
    @NamedQuery(name = "Lgas.findAll", query = "SELECT l FROM Lgas l"),
    @NamedQuery(name = "Lgas.findById", query = "SELECT l FROM Lgas l WHERE l.id = :id"),
    @NamedQuery(name = "Lgas.findByName", query = "SELECT l FROM Lgas l WHERE l.name = :name")})
public class Lgas implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Size(max = 2147483647)
    @Column(name = "name")
    private String name;
    @OneToMany(mappedBy = "lga")
    private Collection<Applicants> applicantsCollection;
    @OneToMany(mappedBy = "lgaId")
    private Collection<Admissions> admissionsCollection;
    @OneToMany(mappedBy = "lgaId")
    private Collection<Utmeapplicants> utmeapplicantsCollection;
    @OneToMany(mappedBy = "lga")
    private Collection<Students> studentsCollection;
    @OneToMany(mappedBy = "lga")
    private Collection<Applicantsbiodata> applicantsbiodataCollection;
    @JoinColumn(name = "state_id", referencedColumnName = "id")
    @ManyToOne
    private States stateId;
    @OneToMany(mappedBy = "lgaId")
    private Collection<Staff> staffCollection;

    public Lgas() {
    }

    public Lgas(Integer id) {
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

    public Collection<Applicants> getApplicantsCollection() {
        return applicantsCollection;
    }

    public void setApplicantsCollection(Collection<Applicants> applicantsCollection) {
        this.applicantsCollection = applicantsCollection;
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

    public States getStateId() {
        return stateId;
    }

    public void setStateId(States stateId) {
        this.stateId = stateId;
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
        if (!(object instanceof Lgas)) {
            return false;
        }
        Lgas other = (Lgas) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Lgas[ id=" + id + " ]";
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
