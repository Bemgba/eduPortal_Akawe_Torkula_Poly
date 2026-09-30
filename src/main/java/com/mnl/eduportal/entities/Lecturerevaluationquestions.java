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
@Table(name = "lecturerevaluationquestions")
@NamedQueries({
    @NamedQuery(name = "Lecturerevaluationquestions.findAll", query = "SELECT l FROM Lecturerevaluationquestions l"),
    @NamedQuery(name = "Lecturerevaluationquestions.findById", query = "SELECT l FROM Lecturerevaluationquestions l WHERE l.id = :id"),
    @NamedQuery(name = "Lecturerevaluationquestions.findByQuestion", query = "SELECT l FROM Lecturerevaluationquestions l WHERE l.question = :question"),
    @NamedQuery(name = "Lecturerevaluationquestions.findByPassRating", query = "SELECT l FROM Lecturerevaluationquestions l WHERE l.passRating = :passRating")})
public class Lecturerevaluationquestions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 2147483647)
    @Column(name = "question")
    private String question;
    @Column(name = "pass_rating")
    private Integer passRating;
    @JoinColumn(name = "lecturer_evaluation_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Lecturerevaluationquestiongroup lecturerEvaluationId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "lecturerEvaluationQuestionsId")
    private Collection<Lecturerevaluationitems> lecturerevaluationitemsCollection;

    public Lecturerevaluationquestions() {
    }

    public Lecturerevaluationquestions(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public Integer getPassRating() {
        return passRating;
    }

    public void setPassRating(Integer passRating) {
        this.passRating = passRating;
    }

    public Lecturerevaluationquestiongroup getLecturerEvaluationId() {
        return lecturerEvaluationId;
    }

    public void setLecturerEvaluationId(Lecturerevaluationquestiongroup lecturerEvaluationId) {
        this.lecturerEvaluationId = lecturerEvaluationId;
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
        if (!(object instanceof Lecturerevaluationquestions)) {
            return false;
        }
        Lecturerevaluationquestions other = (Lecturerevaluationquestions) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Lecturerevaluationquestions[ id=" + id + " ]";
    }
    
}
