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
@Table(name = "programmes")
@NamedQueries({
    @NamedQuery(name = "Programmes.findAll", query = "SELECT p FROM Programmes p"),
    @NamedQuery(name = "Programmes.findById", query = "SELECT p FROM Programmes p WHERE p.id = :id"),
    @NamedQuery(name = "Programmes.findByName", query = "SELECT p FROM Programmes p WHERE p.name = :name"),
    @NamedQuery(name = "Programmes.findByCode", query = "SELECT p FROM Programmes p WHERE p.code = :code"),
    @NamedQuery(name = "Programmes.findByDescription", query = "SELECT p FROM Programmes p WHERE p.description = :description")})
public class Programmes implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Size(max = 200)
    @Column(name = "name")
    private String name;
    @Size(max = 20)
    @Column(name = "code")
    private String code;
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "programmeId", fetch = FetchType.LAZY)
    private Collection<Applicants> applicantsCollection;
    @OneToMany(mappedBy = "programmeId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Gradesetup> gradesetupCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "programmeId", fetch = FetchType.LAZY)
    private Collection<Admissions> admissionsCollection;
    @OneToMany(mappedBy = "programmeId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Utmeapplicants> utmeapplicantsCollection;
    @OneToMany(mappedBy = "programmeId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Payments> paymentsCollection;
    
    @OneToMany(mappedBy = "programmeId")
    private Collection<Semestercourses> semestercoursesCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "programmeId", fetch = FetchType.LAZY)
    private Collection<Sessionmanager> sessionmanagerCollection;
    @OneToMany(mappedBy = "programmeId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Schoolprogrammes> schoolprogrammesCollection;
    @OneToMany(mappedBy = "programmeId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Userprogrammes> userprogrammesCollection;

    public Programmes() {
    }

    public Programmes(Integer id) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Collection<Applicants> getApplicantsCollection() {
        return applicantsCollection;
    }

    public void setApplicantsCollection(Collection<Applicants> applicantsCollection) {
        this.applicantsCollection = applicantsCollection;
    }



    public Collection<Gradesetup> getGradesetupCollection() {
        return gradesetupCollection;
    }

    public void setGradesetupCollection(Collection<Gradesetup> gradesetupCollection) {
        this.gradesetupCollection = gradesetupCollection;
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

    public Collection<Payments> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payments> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }

  

    public Collection<Semestercourses> getSemestercoursesCollection() {
        return semestercoursesCollection;
    }

    public void setSemestercoursesCollection(Collection<Semestercourses> semestercoursesCollection) {
        this.semestercoursesCollection = semestercoursesCollection;
    }

    public Collection<Sessionmanager> getSessionmanagerCollection() {
        return sessionmanagerCollection;
    }

    public void setSessionmanagerCollection(Collection<Sessionmanager> sessionmanagerCollection) {
        this.sessionmanagerCollection = sessionmanagerCollection;
    }

    public Collection<Schoolprogrammes> getSchoolprogrammesCollection() {
        return schoolprogrammesCollection;
    }

    public void setSchoolprogrammesCollection(Collection<Schoolprogrammes> schoolprogrammesCollection) {
        this.schoolprogrammesCollection = schoolprogrammesCollection;
    }

    public Collection<Userprogrammes> getUserprogrammesCollection() {
        return userprogrammesCollection;
    }

    public void setUserprogrammesCollection(Collection<Userprogrammes> userprogrammesCollection) {
        this.userprogrammesCollection = userprogrammesCollection;
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
        if (!(object instanceof Programmes)) {
            return false;
        }
        Programmes other = (Programmes) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Programmes[ id=" + id + " ]";
    }
    
}
