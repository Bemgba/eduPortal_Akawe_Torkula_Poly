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
@Table(name = "lecturerevaluationquestiongroup")
@NamedQueries({
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findAll", query = "SELECT l FROM Lecturerevaluationquestiongroup l"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findById", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.id = :id"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findByName", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.name = :name"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findByScaleMin", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.scaleMin = :scaleMin"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findByScaeMax", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.scaeMax = :scaeMax"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findByScaleSteps", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.scaleSteps = :scaleSteps"),
    @NamedQuery(name = "Lecturerevaluationquestiongroup.findByNote", query = "SELECT l FROM Lecturerevaluationquestiongroup l WHERE l.note = :note")})
public class Lecturerevaluationquestiongroup implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "name")
    private String name;
    @Column(name = "scale_min")
    private Integer scaleMin;
    @Column(name = "scae_max")
    private Integer scaeMax;
    @Column(name = "scale_steps")
    private Integer scaleSteps;
    @Size(max = 200)
    @Column(name = "note")
    private String note;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "lecturerEvaluationId")
    private Collection<Lecturerevaluationquestions> lecturerevaluationquestionsCollection;

    public Lecturerevaluationquestiongroup() {
    }

    public Lecturerevaluationquestiongroup(String id) {
        this.id = id;
    }

    public Lecturerevaluationquestiongroup(String id, String name) {
        this.id = id;
        this.name = name;
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

    public Integer getScaleMin() {
        return scaleMin;
    }

    public void setScaleMin(Integer scaleMin) {
        this.scaleMin = scaleMin;
    }

    public Integer getScaeMax() {
        return scaeMax;
    }

    public void setScaeMax(Integer scaeMax) {
        this.scaeMax = scaeMax;
    }

    public Integer getScaleSteps() {
        return scaleSteps;
    }

    public void setScaleSteps(Integer scaleSteps) {
        this.scaleSteps = scaleSteps;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Collection<Lecturerevaluationquestions> getLecturerevaluationquestionsCollection() {
        return lecturerevaluationquestionsCollection;
    }

    public void setLecturerevaluationquestionsCollection(Collection<Lecturerevaluationquestions> lecturerevaluationquestionsCollection) {
        this.lecturerevaluationquestionsCollection = lecturerevaluationquestionsCollection;
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
        if (!(object instanceof Lecturerevaluationquestiongroup)) {
            return false;
        }
        Lecturerevaluationquestiongroup other = (Lecturerevaluationquestiongroup) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Lecturerevaluationquestiongroup[ id=" + id + " ]";
    }
    
}
