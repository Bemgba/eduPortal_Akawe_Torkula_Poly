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
@Table(name = "lecturerevaluationitems")
@NamedQueries({
    @NamedQuery(name = "Lecturerevaluationitems.findAll", query = "SELECT l FROM Lecturerevaluationitems l"),
    @NamedQuery(name = "Lecturerevaluationitems.findById", query = "SELECT l FROM Lecturerevaluationitems l WHERE l.id = :id"),
    @NamedQuery(name = "Lecturerevaluationitems.findByScore", query = "SELECT l FROM Lecturerevaluationitems l WHERE l.score = :score")})
public class Lecturerevaluationitems implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Column(name = "score")
    private Integer score;
    @JoinColumn(name = "lecturer_evaluation_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Lecturerevaluation lecturerEvaluationId;
    @JoinColumn(name = "lecturer_evaluation_questions_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Lecturerevaluationquestions lecturerEvaluationQuestionsId;

    public Lecturerevaluationitems() {
    }

    public Lecturerevaluationitems(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Lecturerevaluation getLecturerEvaluationId() {
        return lecturerEvaluationId;
    }

    public void setLecturerEvaluationId(Lecturerevaluation lecturerEvaluationId) {
        this.lecturerEvaluationId = lecturerEvaluationId;
    }

    public Lecturerevaluationquestions getLecturerEvaluationQuestionsId() {
        return lecturerEvaluationQuestionsId;
    }

    public void setLecturerEvaluationQuestionsId(Lecturerevaluationquestions lecturerEvaluationQuestionsId) {
        this.lecturerEvaluationQuestionsId = lecturerEvaluationQuestionsId;
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
        if (!(object instanceof Lecturerevaluationitems)) {
            return false;
        }
        Lecturerevaluationitems other = (Lecturerevaluationitems) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Lecturerevaluationitems[ id=" + id + " ]";
    }
    
}
