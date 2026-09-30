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
@Table(name = "semesterregistrationcourses")
@NamedQueries({
    @NamedQuery(name = "Semesterregistrationcourses.findAll", query = "SELECT s FROM Semesterregistrationcourses s"),
    @NamedQuery(name = "Semesterregistrationcourses.findById", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.id = :id"),
    @NamedQuery(name = "Semesterregistrationcourses.findByLevel", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.level = :level"),
    @NamedQuery(name = "Semesterregistrationcourses.findByCreditUnit", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.creditUnit = :creditUnit"),
    @NamedQuery(name = "Semesterregistrationcourses.findByPerca", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.perca = :perca"),
    @NamedQuery(name = "Semesterregistrationcourses.findByPerexam", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.perexam = :perexam"),
    @NamedQuery(name = "Semesterregistrationcourses.findByCourseStatus", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.courseStatus = :courseStatus"),
    @NamedQuery(name = "Semesterregistrationcourses.findBySemester", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.semester = :semester"),
    @NamedQuery(name = "Semesterregistrationcourses.findByCourseType", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.courseType = :courseType"),
    @NamedQuery(name = "Semesterregistrationcourses.findByPerPractical", query = "SELECT s FROM Semesterregistrationcourses s WHERE s.perPractical = :perPractical")})
public class Semesterregistrationcourses implements Serializable {

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
    @Column(name = "level")
    private String level;
    @Column(name = "credit_unit")
    private Integer creditUnit;
    @Column(name = "perca")
    private Integer perca;
    @Column(name = "perexam")
    private Integer perexam;
    @Size(max = 20)
    @Column(name = "course_status")
    private String courseStatus;
    @Size(max = 10)
    @Column(name = "semester")
    private String semester;
    @Size(max = 20)
    @Column(name = "course_type")
    private String courseType;
    @Column(name = "per_practical")
    private Integer perPractical;
    @Size(max = 50)
    @Column(name = "course_category")
    private String courseCategory;
    @OneToMany(mappedBy = "semesterRegistrationCourseId")
    private Collection<Semesterregistrationpreriquisites> semesterregistrationpreriquisitesCollection;
    @OneToMany(mappedBy = "semesterCourseId")
    private Collection<Semesterregistrationpreriquisites> semesterregistrationpreriquisitesCollection1;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @JoinColumn(name = "semester_course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Semestercourses semesterCourseId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "semesterRegistrationCourseId")
    private Collection<Semesterregistration> semesterregistrationCollection;

    public Semesterregistrationcourses() {
    }

    public Semesterregistrationcourses(String id) {
        this.id = id;
    }

    public Semesterregistrationcourses(String id, String level) {
        this.id = id;
        this.level = level;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Integer getCreditUnit() {
        return creditUnit;
    }

    public void setCreditUnit(Integer creditUnit) {
        this.creditUnit = creditUnit;
    }

    public Integer getPerca() {
        return perca;
    }

    public void setPerca(Integer perca) {
        this.perca = perca;
    }

    public Integer getPerexam() {
        return perexam;
    }

    public void setPerexam(Integer perexam) {
        this.perexam = perexam;
    }

    public String getCourseStatus() {
        return courseStatus;
    }

    public void setCourseStatus(String courseStatus) {
        this.courseStatus = courseStatus;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getCourseType() {
        return courseType;
    }

    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }

    public Integer getPerPractical() {
        return perPractical;
    }

    public void setPerPractical(Integer perPractical) {
        this.perPractical = perPractical;
    }

    public Collection<Semesterregistrationpreriquisites> getSemesterregistrationpreriquisitesCollection() {
        return semesterregistrationpreriquisitesCollection;
    }

    public void setSemesterregistrationpreriquisitesCollection(Collection<Semesterregistrationpreriquisites> semesterregistrationpreriquisitesCollection) {
        this.semesterregistrationpreriquisitesCollection = semesterregistrationpreriquisitesCollection;
    }

    public Collection<Semesterregistrationpreriquisites> getSemesterregistrationpreriquisitesCollection1() {
        return semesterregistrationpreriquisitesCollection1;
    }

    public void setSemesterregistrationpreriquisitesCollection1(Collection<Semesterregistrationpreriquisites> semesterregistrationpreriquisitesCollection1) {
        this.semesterregistrationpreriquisitesCollection1 = semesterregistrationpreriquisitesCollection1;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Semestercourses getSemesterCourseId() {
        return semesterCourseId;
    }

    public void setSemesterCourseId(Semestercourses semesterCourseId) {
        this.semesterCourseId = semesterCourseId;
    }

    public Collection<Semesterregistration> getSemesterregistrationCollection() {
        return semesterregistrationCollection;
    }

    public void setSemesterregistrationCollection(Collection<Semesterregistration> semesterregistrationCollection) {
        this.semesterregistrationCollection = semesterregistrationCollection;
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
        if (!(object instanceof Semesterregistrationcourses)) {
            return false;
        }
        Semesterregistrationcourses other = (Semesterregistrationcourses) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semesterregistrationcourses[ id=" + id + " ]";
    }

    /**
     * @return the courseCategory
     */
    public String getCourseCategory() {
        return courseCategory;
    }

    /**
     * @param courseCategory the courseCategory to set
     */
    public void setCourseCategory(String courseCategory) {
        this.courseCategory = courseCategory;
    }
    
}
