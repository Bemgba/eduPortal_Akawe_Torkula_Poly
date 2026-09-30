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
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "gradesetup")
@NamedQueries({
    @NamedQuery(name = "Gradesetup.findAll", query = "SELECT g FROM Gradesetup g"),
    @NamedQuery(name = "Gradesetup.findById", query = "SELECT g FROM Gradesetup g WHERE g.id = :id"),
    @NamedQuery(name = "Gradesetup.findByClassOfDegree", query = "SELECT g FROM Gradesetup g WHERE g.classOfDegree = :classOfDegree"),
    @NamedQuery(name = "Gradesetup.findByGrade", query = "SELECT g FROM Gradesetup g WHERE g.grade = :grade"),
    @NamedQuery(name = "Gradesetup.findByRemarks", query = "SELECT g FROM Gradesetup g WHERE g.remarks = :remarks"),
    @NamedQuery(name = "Gradesetup.findByScoreFrom", query = "SELECT g FROM Gradesetup g WHERE g.scoreFrom = :scoreFrom"),
    @NamedQuery(name = "Gradesetup.findByScoreTo", query = "SELECT g FROM Gradesetup g WHERE g.scoreTo = :scoreTo"),
    @NamedQuery(name = "Gradesetup.findBySessionFrom", query = "SELECT g FROM Gradesetup g WHERE g.sessionFrom = :sessionFrom"),
    @NamedQuery(name = "Gradesetup.findBySessionTo", query = "SELECT g FROM Gradesetup g WHERE g.sessionTo = :sessionTo"),
    @NamedQuery(name = "Gradesetup.findByWeight", query = "SELECT g FROM Gradesetup g WHERE g.weight = :weight")})
public class Gradesetup implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "class_of_degree")
    private String classOfDegree;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "grade")
    private String grade;
    @Size(max = 100)
    @Column(name = "remarks")
    private String remarks;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "score_from")
    private Double scoreFrom;
    @Column(name = "score_to")
    private Double scoreTo;
    @Size(max = 10)
    @Column(name = "session_from")
    private String sessionFrom;
    @Size(max = 10)
    @Column(name = "session_to")
    private String sessionTo;
    @Column(name = "weight")
    private Integer weight;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;

    public Gradesetup() {
    }

    public Gradesetup(String id) {
        this.id = id;
    }

    public Gradesetup(String id, String classOfDegree, String grade) {
        this.id = id;
        this.classOfDegree = classOfDegree;
        this.grade = grade;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClassOfDegree() {
        return classOfDegree;
    }

    public void setClassOfDegree(String classOfDegree) {
        this.classOfDegree = classOfDegree;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Double getScoreFrom() {
        return scoreFrom;
    }

    public void setScoreFrom(Double scoreFrom) {
        this.scoreFrom = scoreFrom;
    }

    public Double getScoreTo() {
        return scoreTo;
    }

    public void setScoreTo(Double scoreTo) {
        this.scoreTo = scoreTo;
    }

    public String getSessionFrom() {
        return sessionFrom;
    }

    public void setSessionFrom(String sessionFrom) {
        this.sessionFrom = sessionFrom;
    }

    public String getSessionTo() {
        return sessionTo;
    }

    public void setSessionTo(String sessionTo) {
        this.sessionTo = sessionTo;
    }

    public Integer getWeight() {
        return weight;
    }

    public void setWeight(Integer weight) {
        this.weight = weight;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
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
        if (!(object instanceof Gradesetup)) {
            return false;
        }
        Gradesetup other = (Gradesetup) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Gradesetup[ id=" + id + " ]";
    }
    
}
