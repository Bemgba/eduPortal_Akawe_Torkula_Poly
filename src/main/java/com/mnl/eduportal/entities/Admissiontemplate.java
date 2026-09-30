/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
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
@Table(name = "admissiontemplate")
@NamedQueries({
    @NamedQuery(name = "Admissiontemplate.findAll", query = "SELECT a FROM Admissiontemplate a"),
    @NamedQuery(name = "Admissiontemplate.findById", query = "SELECT a FROM Admissiontemplate a WHERE a.id = :id"),
    @NamedQuery(name = "Admissiontemplate.findBySession", query = "SELECT a FROM Admissiontemplate a WHERE a.session = :session"),
    @NamedQuery(name = "Admissiontemplate.findByCompulsorySubjects", query = "SELECT a FROM Admissiontemplate a WHERE a.compulsorySubjects = :compulsorySubjects"),
    @NamedQuery(name = "Admissiontemplate.findByOtherSubjects", query = "SELECT a FROM Admissiontemplate a WHERE a.otherSubjects = :otherSubjects"),
    @NamedQuery(name = "Admissiontemplate.findByUtmePer", query = "SELECT a FROM Admissiontemplate a WHERE a.utmePer = :utmePer"),
    @NamedQuery(name = "Admissiontemplate.findByOlevelPer", query = "SELECT a FROM Admissiontemplate a WHERE a.olevelPer = :olevelPer"),
    @NamedQuery(name = "Admissiontemplate.findByAptitudePer", query = "SELECT a FROM Admissiontemplate a WHERE a.aptitudePer = :aptitudePer")})
public class Admissiontemplate implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session")
    private String session;
    
    @Column(name ="compulsory_subjects")
    private Integer compulsorySubjects;
    
    @Column(name = "other_subjects")
    private Integer otherSubjects;
    
    @Column(name = "compulsory_utme")
    private Integer compulsoryUtme;
    
    @Column(name = "other_utme")
    private Integer otherUtme;
    
    @Column(name = "utme_per")
    private Integer utmePer;
    @Column(name = "olevel_per")
    private Integer olevelPer;
    @Column(name = "aptitude_per")
    private Integer aptitudePer;
     @Column(name = "total_merit")
    private Integer totalMerit;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "national_merit")
    private Double nationalMerit;
    @Column(name = "state_merit")
    private Double stateMerit;
    @Column(name = "lga_merit")
    private Double lgaMerit;
    @JoinColumn(name = "course", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses course;
    @OneToMany(mappedBy = "admissionTemplate", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private Collection<Admissiontemplateolevel> admissiontemplateolevelCollection;
     @OneToMany(mappedBy = "admissionTemplate", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private Collection<Admissiontemplateutme> admissiontemplateutmeCollection;

    public Admissiontemplate() {
    }

    public Admissiontemplate(String id) {
        this.id = id;
    }

    public Admissiontemplate(String id, String session, Courses course) {
        this.id = id;
        this.session = session;
        this.course = course;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public Courses getCourse() {
        return course;
    }

    public void setCourse(Courses course) {
        this.course = course;
    }

    public Integer getCompulsorySubjects() {
        return compulsorySubjects;
    }

    public void setCompulsorySubjects(Integer compulsorySubjects) {
        this.compulsorySubjects = compulsorySubjects;
    }

    public Integer getOtherSubjects() {
        return otherSubjects;
    }

    public void setOtherSubjects(Integer otherSubjects) {
        this.otherSubjects = otherSubjects;
    }
    
     public Integer getCompulsoryUtme() {
        return compulsoryUtme;
    }

    public void setCompulsoryUtme(Integer compulsoryUtme) {
        this.compulsoryUtme = compulsoryUtme;
    }

    public Integer getOtherUtme() {
        return otherUtme;
    }

    public void setOtherUtme(Integer otherUtme) {
        this.otherUtme = otherUtme;
    }

    public Integer getUtmePer() {
        return utmePer;
    }

    public void setUtmePer(Integer utmePer) {
        this.utmePer = utmePer;
    }

    public Integer getOlevelPer() {
        return olevelPer;
    }

    public void setOlevelPer(Integer olevelPer) {
        this.olevelPer = olevelPer;
    }

    public Integer getAptitudePer() {
        return aptitudePer;
    }

    public void setAptitudePer(Integer aptitudePer) {
        this.aptitudePer = aptitudePer;
    }

     public Integer getTotalMerit() {
        return totalMerit;
    }

    public void setTotalMerit(Integer totalMerit) {
        this.totalMerit = totalMerit;
    }

    public Double getNationalMerit() {
        return nationalMerit;
    }

    public void setNationalMerit(Double nationalMerit) {
        this.nationalMerit = nationalMerit;
    }

    public Double getStateMerit() {
        return stateMerit;
    }

    public void setStateMerit(Double stateMerit) {
        this.stateMerit = stateMerit;
    }

    public Double getLgaMerit() {
        return lgaMerit;
    }

    public void setLgaMerit(Double lgaMerit) {
        this.lgaMerit = lgaMerit;
    }
    
    public Collection<Admissiontemplateolevel> getAdmissiontemplateolevelCollection() {
        return admissiontemplateolevelCollection;
    }

    public void setAdmissiontemplateolevelCollection(Collection<Admissiontemplateolevel> admissiontemplateolevelCollection) {
        this.admissiontemplateolevelCollection = admissiontemplateolevelCollection;
    }
    
     public Collection<Admissiontemplateutme> getAdmissiontemplateutmeCollection() {
        return admissiontemplateutmeCollection;
    }

    public void setAdmissiontemplateutmeCollection(Collection<Admissiontemplateutme> admissiontemplateutmeCollection) {
        this.admissiontemplateutmeCollection = admissiontemplateutmeCollection;
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
        if (!(object instanceof Admissiontemplate)) {
            return false;
        }
        Admissiontemplate other = (Admissiontemplate) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.bdic.benueexco.admissiontemplate.Admissiontemplate[ id=" + id + " ]";
    }
    
}
