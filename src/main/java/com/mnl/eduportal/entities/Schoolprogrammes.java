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
@Table(name = "schoolprogrammes")
@NamedQueries({
    @NamedQuery(name = "Schoolprogrammes.findAll", query = "SELECT s FROM Schoolprogrammes s"),
    @NamedQuery(name = "Schoolprogrammes.findById", query = "SELECT s FROM Schoolprogrammes s WHERE s.id = :id"),
    @NamedQuery(name = "Schoolprogrammes.findBySemestersPerSession", query = "SELECT s FROM Schoolprogrammes s WHERE s.semestersPerSession = :semestersPerSession")})
public class Schoolprogrammes implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @Column(name = "semesters_per_session")
    private Integer semestersPerSession;
    @JoinColumn(name = "head_title", referencedColumnName = "id")
    @ManyToOne
    private Positions headTitle;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne
    private Schools schoolId;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @ManyToOne
    private Users headId;
    @OneToMany(mappedBy = "schoolProgrammesId")
    private Collection<Coursesjambmapping> coursesjambmappingCollection;

    public Schoolprogrammes() {
    }

    public Schoolprogrammes(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getSemestersPerSession() {
        return semestersPerSession;
    }

    public void setSemestersPerSession(Integer semestersPerSession) {
        this.semestersPerSession = semestersPerSession;
    }

    public Positions getHeadTitle() {
        return headTitle;
    }

    public void setHeadTitle(Positions headTitle) {
        this.headTitle = headTitle;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
    }

    public Users getHeadId() {
        return headId;
    }

    public void setHeadId(Users headId) {
        this.headId = headId;
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
        if (!(object instanceof Schoolprogrammes)) {
            return false;
        }
        Schoolprogrammes other = (Schoolprogrammes) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Schoolprogrammes[ id=" + id + " ]";
    }
    
     public Collection<Coursesjambmapping> getCoursesjambmappingCollection() {
        return coursesjambmappingCollection;
    }

    public void setCoursesjambmappingCollection(Collection<Coursesjambmapping> coursesjambmappingCollection) {
        this.coursesjambmappingCollection = coursesjambmappingCollection;
    }
    
}
