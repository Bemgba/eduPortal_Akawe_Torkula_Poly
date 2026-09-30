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
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "semestercoursesallocation")
@NamedQueries({
    @NamedQuery(name = "Semestercoursesallocation.findAll", query = "SELECT s FROM Semestercoursesallocation s"),
    @NamedQuery(name = "Semestercoursesallocation.findById", query = "SELECT s FROM Semestercoursesallocation s WHERE s.id = :id"),
    @NamedQuery(name = "Semestercoursesallocation.findByDateAdded", query = "SELECT s FROM Semestercoursesallocation s WHERE s.dateAdded = :dateAdded"),
    @NamedQuery(name = "Semestercoursesallocation.findByAddedBy", query = "SELECT s FROM Semestercoursesallocation s WHERE s.addedBy = :addedBy"),
    @NamedQuery(name = "Semestercoursesallocation.findByComment", query = "SELECT s FROM Semestercoursesallocation s WHERE s.comment = :comment")})
public class Semestercoursesallocation implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 50)
    @Column(name = "added_by")
    private String addedBy;
    @Size(max = 200)
    @Column(name = "comment")
    private String comment;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "semesterCourseAllocationId")
    private Collection<Lecturerevaluation> lecturerevaluationCollection;
    @JoinColumn(name = "semester_course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Semestercourses semesterCourseId;
    @JoinColumn(name = "session_manager_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Sessionmanager sessionManagerId;
    @JoinColumn(name = "staff_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Staff staffId;

    public Semestercoursesallocation() {
    }

    public Semestercoursesallocation(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getAddedBy() {
        return addedBy;
    }

    public void setAddedBy(String addedBy) {
        this.addedBy = addedBy;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Collection<Lecturerevaluation> getLecturerevaluationCollection() {
        return lecturerevaluationCollection;
    }

    public void setLecturerevaluationCollection(Collection<Lecturerevaluation> lecturerevaluationCollection) {
        this.lecturerevaluationCollection = lecturerevaluationCollection;
    }

    public Semestercourses getSemesterCourseId() {
        return semesterCourseId;
    }

    public void setSemesterCourseId(Semestercourses semesterCourseId) {
        this.semesterCourseId = semesterCourseId;
    }

    public Sessionmanager getSessionManagerId() {
        return sessionManagerId;
    }

    public void setSessionManagerId(Sessionmanager sessionManagerId) {
        this.sessionManagerId = sessionManagerId;
    }

    public Staff getStaffId() {
        return staffId;
    }

    public void setStaffId(Staff staffId) {
        this.staffId = staffId;
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
        if (!(object instanceof Semestercoursesallocation)) {
            return false;
        }
        Semestercoursesallocation other = (Semestercoursesallocation) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semestercoursesallocation[ id=" + id + " ]";
    }
    
}
