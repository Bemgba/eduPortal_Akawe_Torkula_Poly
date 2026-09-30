
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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "applicantsutme")
@NamedQueries({
    @NamedQuery(name = "Applicantsutme.findAll", query = "SELECT a FROM Applicantsutme a"),
    @NamedQuery(name = "Applicantsutme.findById", query = "SELECT a FROM Applicantsutme a WHERE a.id = :id"),
    @NamedQuery(name = "Applicantsutme.findByEngScore", query = "SELECT a FROM Applicantsutme a WHERE a.engScore = :engScore"),
    @NamedQuery(name = "Applicantsutme.findBySubj2", query = "SELECT a FROM Applicantsutme a WHERE a.subj2 = :subj2"),
    @NamedQuery(name = "Applicantsutme.findByJambNo", query = "SELECT a FROM Applicantsutme a WHERE a.jambNo = :jambNo"),
    @NamedQuery(name = "Applicantsutme.findBySubj2Score", query = "SELECT a FROM Applicantsutme a WHERE a.subj2Score = :subj2Score"),
    @NamedQuery(name = "Applicantsutme.findBySubj3", query = "SELECT a FROM Applicantsutme a WHERE a.subj3 = :subj3"),
    @NamedQuery(name = "Applicantsutme.findBySubj3Score", query = "SELECT a FROM Applicantsutme a WHERE a.subj3Score = :subj3Score"),
    @NamedQuery(name = "Applicantsutme.findBySubj4", query = "SELECT a FROM Applicantsutme a WHERE a.subj4 = :subj4"),
    @NamedQuery(name = "Applicantsutme.findBySubj4Score", query = "SELECT a FROM Applicantsutme a WHERE a.subj4Score = :subj4Score"),
    @NamedQuery(name = "Applicantsutme.findByTotalUtme", query = "SELECT a FROM Applicantsutme a WHERE a.totalUtme = :totalUtme"),
    @NamedQuery(name = "Applicantsutme.findByPostUtme", query = "SELECT a FROM Applicantsutme a WHERE a.postUtme = :postUtme")})

public class Applicantsutme implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Column(name = "eng_score")
    private Integer engScore;
    @Size(max = 15)
    @Column(name = "jamb_no")
    private String jambNo;
    @Size(max = 150)
    @Column(name = "subj_2")
    private String subj2;
    @Column(name = "subj_2_score")
    private Integer subj2Score;
    @Size(max = 150)
    @Column(name = "subj_3")
    private String subj3;
    @Column(name = "subj_3_score")
    private Integer subj3Score;
    @Size(max = 150)
    @Column(name = "subj_4")
    private String subj4;
    @Column(name = "subj_4_score")
    private Integer subj4Score;
    @Column(name = "total_utme")
    private Integer totalUtme;
    @Column(name = "post_utme")
    private Integer postUtme;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Applicants applicants;

    public Applicantsutme() {

    }

    public Applicantsutme(String id) {

        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getEngScore() {
        return engScore;
    }

    public void setEngScore(Integer engScore) {
        this.engScore = engScore;
    }

    public String getSubj2() {
        return subj2;
    }

    public void setSubj2(String subj2) {
        this.subj2 = subj2;
    }

    public String getJambNo() {
        return jambNo;
    }

    public void setJambNo(String jambNo) {
        this.jambNo = jambNo;
    }

    public Integer getSubj2Score() {
        return subj2Score;
    }

    public void setSubj2Score(Integer subj2Score) {
        this.subj2Score = subj2Score;
    }

    public String getSubj3() {
        return subj3;
    }

    public void setSubj3(String subj3) {
        this.subj3 = subj3;
    }

    public Integer getSubj3Score() {
        return subj3Score;
    }

    public void setSubj3Score(Integer subj3Score) {
        this.subj3Score = subj3Score;
    }

    public String getSubj4() {
        return subj4;
    }

    public void setSubj4(String subj4) {
        this.subj4 = subj4;
    }

    public Integer getSubj4Score() {
        return subj4Score;
    }

    public void setSubj4Score(Integer subj4Score) {
        this.subj4Score = subj4Score;
    }

    public Integer getTotalUtme() {
        return totalUtme;
    }

    public void setTotalUtme(Integer totalUtme) {
        this.totalUtme = totalUtme;
    }

    public Integer getPostUtme() {
        return postUtme;
    }

    public void setPostUtme(Integer postUtme) {
        this.postUtme = postUtme;
    }

    public Applicants getApplicants() {
        return applicants;
    }

    public void setApplicants(Applicants applicants) {
        this.applicants = applicants;
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
        if (!(object instanceof Applicantsutme)) {
            return false;
        }
        Applicantsutme other = (Applicantsutme) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.bsutest.Applicantsutme[ id=" + id + " ]";
    }

}
