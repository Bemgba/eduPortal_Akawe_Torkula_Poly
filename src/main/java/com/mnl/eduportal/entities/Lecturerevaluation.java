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
@Table(name = "lecturerevaluation")
@NamedQueries({
    @NamedQuery(name = "Lecturerevaluation.findAll", query = "SELECT l FROM Lecturerevaluation l"),
    @NamedQuery(name = "Lecturerevaluation.findById", query = "SELECT l FROM Lecturerevaluation l WHERE l.id = :id"),
    @NamedQuery(name = "Lecturerevaluation.findByGeneralComment", query = "SELECT l FROM Lecturerevaluation l WHERE l.generalComment = :generalComment"),
    @NamedQuery(name = "Lecturerevaluation.findByDateEvaluated", query = "SELECT l FROM Lecturerevaluation l WHERE l.dateEvaluated = :dateEvaluated"),
    @NamedQuery(name = "Lecturerevaluation.findByTotalScore", query = "SELECT l FROM Lecturerevaluation l WHERE l.totalScore = :totalScore")})
public class Lecturerevaluation implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "general_comment")
    private String generalComment;
    @Column(name = "date_evaluated")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateEvaluated;
    @Column(name = "total_score")
    private Integer totalScore;
    @JoinColumn(name = "semester_course_allocation_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Semestercoursesallocation semesterCourseAllocationId;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "lecturerEvaluationId")
    private Collection<Lecturerevaluationitems> lecturerevaluationitemsCollection;

    public Lecturerevaluation() {
    }

    public Lecturerevaluation(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGeneralComment() {
        return generalComment;
    }

    public void setGeneralComment(String generalComment) {
        this.generalComment = generalComment;
    }

    public Date getDateEvaluated() {
        return dateEvaluated;
    }

    public void setDateEvaluated(Date dateEvaluated) {
        this.dateEvaluated = dateEvaluated;
    }

    public Integer getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Integer totalScore) {
        this.totalScore = totalScore;
    }

    public Semestercoursesallocation getSemesterCourseAllocationId() {
        return semesterCourseAllocationId;
    }

    public void setSemesterCourseAllocationId(Semestercoursesallocation semesterCourseAllocationId) {
        this.semesterCourseAllocationId = semesterCourseAllocationId;
    }

    public Students getStudentId() {
        return studentId;
    }

    public void setStudentId(Students studentId) {
        this.studentId = studentId;
    }

    public Collection<Lecturerevaluationitems> getLecturerevaluationitemsCollection() {
        return lecturerevaluationitemsCollection;
    }

    public void setLecturerevaluationitemsCollection(Collection<Lecturerevaluationitems> lecturerevaluationitemsCollection) {
        this.lecturerevaluationitemsCollection = lecturerevaluationitemsCollection;
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
        if (!(object instanceof Lecturerevaluation)) {
            return false;
        }
        Lecturerevaluation other = (Lecturerevaluation) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Lecturerevaluation[ id=" + id + " ]";
    }
    
}
