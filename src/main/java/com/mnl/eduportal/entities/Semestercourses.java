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
import java.util.List;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "semestercourses")
@NamedQueries({
    @NamedQuery(name = "Semestercourses.findAll", query = "SELECT s FROM Semestercourses s"),
    @NamedQuery(name = "Semestercourses.findById", query = "SELECT s FROM Semestercourses s WHERE s.id = :id"),
    @NamedQuery(name = "Semestercourses.findByName", query = "SELECT s FROM Semestercourses s WHERE s.name = :name"),
    @NamedQuery(name = "Semestercourses.findByCode", query = "SELECT s FROM Semestercourses s WHERE s.code = :code"),
    @NamedQuery(name = "Semestercourses.findBySemester", query = "SELECT s FROM Semestercourses s WHERE s.semester = :semester"),
    @NamedQuery(name = "Semestercourses.findByDefaultLevel", query = "SELECT s FROM Semestercourses s WHERE s.defaultLevel = :defaultLevel"),
    @NamedQuery(name = "Semestercourses.findByCreditUnit", query = "SELECT s FROM Semestercourses s WHERE s.creditUnit = :creditUnit"),
    @NamedQuery(name = "Semestercourses.findByStatus", query = "SELECT s FROM Semestercourses s WHERE s.status = :status"),
    @NamedQuery(name = "Semestercourses.findByNote", query = "SELECT s FROM Semestercourses s WHERE s.note = :note")})
public class Semestercourses implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "name")
    private String name;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 15)
    @Column(name = "code")
    private String code;
    @Size(max = 10)
    @Column(name = "semester")
    private String semester;
    @Size(max = 10)
    @Column(name = "default_level")
    private String defaultLevel;
    @Column(name = "credit_unit")
    private Integer creditUnit;
    @Size(max = 10)
    @Column(name = "status")
    private String status;
    @Size(max = 200)
    @Column(name = "note")
    private String note;
    
    @Size(max = 10)
    @Column(name = "semestercourse_category")
    private String semestercourseCategory;
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "semesterCourseId", fetch = FetchType.LAZY)
    private Collection<Semesterregistrationcourses> semesterregistrationcoursesCollection;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "semesterCourseId", fetch = FetchType.LAZY)
    private Collection<Semestercoursesallocation> semestercoursesallocationCollection;

    public Semestercourses() {
    }

    public Semestercourses(String id) {
        this.id = id;
    }

    public Semestercourses(String id, String name, String code) {
        this.id = id;
        this.name = name;
        this.code = code;
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

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getDefaultLevel() {
        return defaultLevel;
    }

    public void setDefaultLevel(String defaultLevel) {
        this.defaultLevel = defaultLevel;
    }

    public Integer getCreditUnit() {
        return creditUnit;
    }

    public void setCreditUnit(Integer creditUnit) {
        this.creditUnit = creditUnit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Collection<Semesterregistrationcourses> getSemesterregistrationcoursesCollection() {
        return semesterregistrationcoursesCollection;
    }

    public void setSemesterregistrationcoursesCollection(Collection<Semesterregistrationcourses> semesterregistrationcoursesCollection) {
        this.semesterregistrationcoursesCollection = semesterregistrationcoursesCollection;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
    }

    public Collection<Semestercoursesallocation> getSemestercoursesallocationCollection() {
        return semestercoursesallocationCollection;
    }

    public void setSemestercoursesallocationCollection(Collection<Semestercoursesallocation> semestercoursesallocationCollection) {
        this.semestercoursesallocationCollection = semestercoursesallocationCollection;
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
        if (!(object instanceof Semestercourses)) {
            return false;
        }
        Semestercourses other = (Semestercourses) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semestercourses[ id=" + id + " ]";
    }

    /**
     * @return the semestercourseCategory
     */
    public String getSemestercourseCategory() {
        return semestercourseCategory;
    }

    /**
     * @param semestercourseCategory the semestercourseCategory to set
     */
    public void setSemestercourseCategory(String semestercourseCategory) {
        this.semestercourseCategory = semestercourseCategory;
    }
    
}
