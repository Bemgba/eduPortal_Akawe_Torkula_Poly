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
@Table(name = "utmeapplicants")
@NamedQueries({
    @NamedQuery(name = "Utmeapplicants.findAll", query = "SELECT u FROM Utmeapplicants u"),
    @NamedQuery(name = "Utmeapplicants.findByRegistrationNo", query = "SELECT u FROM Utmeapplicants u WHERE u.registrationNo = :registrationNo"),
    @NamedQuery(name = "Utmeapplicants.findBySession", query = "SELECT u FROM Utmeapplicants u WHERE u.session = :session"),
    @NamedQuery(name = "Utmeapplicants.findBySurname", query = "SELECT u FROM Utmeapplicants u WHERE u.surname = :surname"),
    @NamedQuery(name = "Utmeapplicants.findByOthernames", query = "SELECT u FROM Utmeapplicants u WHERE u.othernames = :othernames"),
    @NamedQuery(name = "Utmeapplicants.findByMaritalStatus", query = "SELECT u FROM Utmeapplicants u WHERE u.maritalStatus = :maritalStatus"),
    @NamedQuery(name = "Utmeapplicants.findByGender", query = "SELECT u FROM Utmeapplicants u WHERE u.gender = :gender"),
    @NamedQuery(name = "Utmeapplicants.findByDateOfBirth", query = "SELECT u FROM Utmeapplicants u WHERE u.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Utmeapplicants.findByPhoneNo", query = "SELECT u FROM Utmeapplicants u WHERE u.phoneNo = :phoneNo"),
    @NamedQuery(name = "Utmeapplicants.findByEngScore", query = "SELECT u FROM Utmeapplicants u WHERE u.engScore = :engScore"),
    @NamedQuery(name = "Utmeapplicants.findBySubj2", query = "SELECT u FROM Utmeapplicants u WHERE u.subj2 = :subj2"),
    @NamedQuery(name = "Utmeapplicants.findBySubj2Score", query = "SELECT u FROM Utmeapplicants u WHERE u.subj2Score = :subj2Score"),
    @NamedQuery(name = "Utmeapplicants.findBySubj3", query = "SELECT u FROM Utmeapplicants u WHERE u.subj3 = :subj3"),
    @NamedQuery(name = "Utmeapplicants.findBySubj3Score", query = "SELECT u FROM Utmeapplicants u WHERE u.subj3Score = :subj3Score"),
    @NamedQuery(name = "Utmeapplicants.findBySubj4", query = "SELECT u FROM Utmeapplicants u WHERE u.subj4 = :subj4"),
    @NamedQuery(name = "Utmeapplicants.findBySubj4Score", query = "SELECT u FROM Utmeapplicants u WHERE u.subj4Score = :subj4Score"),
    @NamedQuery(name = "Utmeapplicants.findByUtmeScore", query = "SELECT u FROM Utmeapplicants u WHERE u.utmeScore = :utmeScore"),
    @NamedQuery(name = "Utmeapplicants.findByPostUtmeScore", query = "SELECT u FROM Utmeapplicants u WHERE u.postUtmeScore = :postUtmeScore"),
    @NamedQuery(name = "Utmeapplicants.findByAdmissionCriteria", query = "SELECT u FROM Utmeapplicants u WHERE u.admissionCriteria = :admissionCriteria"),
    @NamedQuery(name = "Utmeapplicants.findByAdmissionStatus", query = "SELECT u FROM Utmeapplicants u WHERE u.admissionStatus = :admissionStatus"),
    @NamedQuery(name = "Utmeapplicants.findByBatchId", query = "SELECT u FROM Utmeapplicants u WHERE u.batchId = :batchId")})
public class Utmeapplicants implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "registration_no")
    private String registrationNo;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session")
    private String session;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "surname")
    private String surname;
    @Size(max = 200)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 10)
    @Column(name = "marital_status")
    private String maritalStatus;
    @Size(max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 20)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Column(name = "eng_score")
    private Integer engScore;
    @Size(max = 50)
    @Column(name = "subj2")
    private String subj2;
    @Column(name = "subj2_score")
    private Integer subj2Score;
    @Size(max = 50)
    @Column(name = "subj3")
    private String subj3;
    @Column(name = "subj3_score")
    private Integer subj3Score;
    @Size(max = 50)
    @Column(name = "subj4")
    private String subj4;
    @Column(name = "subj4_score")
    private Integer subj4Score;
    @Column(name = "utme_score")
    private Integer utmeScore;
    @Column(name = "post_utme_score")
    private Integer postUtmeScore;
    @Size(max = 50)
    @Column(name = "admission_criteria")
    private String admissionCriteria;
    @Size(max = 50)
    @Column(name = "admission_status")
    private String admissionStatus;
    @Size(max = 50)
    @Column(name = "batch_id")
    private String batchId;
    @OneToMany(mappedBy = "utmeApplicantsId")
    private Collection<Admissions> admissionsCollection;
    @JoinColumn(name = "nationality_id", referencedColumnName = "id")
    @ManyToOne
    private Countries nationalityId;
    @JoinColumn(name = "course", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses course;
    @JoinColumn(name = "lga_id", referencedColumnName = "id")
    @ManyToOne
    private Lgas lgaId;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;
    @JoinColumn(name = "state_of_origin_id", referencedColumnName = "id")
    @ManyToOne
    private States stateOfOriginId;

    public Utmeapplicants() {
    }

    public Utmeapplicants(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public Utmeapplicants(String registrationNo, String session, String surname) {
        this.registrationNo = registrationNo;
        this.session = session;
        this.surname = surname;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getOthernames() {
        return othernames;
    }

    public void setOthernames(String othernames) {
        this.othernames = othernames;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
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

    public Integer getUtmeScore() {
        return utmeScore;
    }

    public void setUtmeScore(Integer utmeScore) {
        this.utmeScore = utmeScore;
    }

    public Integer getPostUtmeScore() {
        return postUtmeScore;
    }

    public void setPostUtmeScore(Integer postUtmeScore) {
        this.postUtmeScore = postUtmeScore;
    }

    public String getAdmissionCriteria() {
        return admissionCriteria;
    }

    public void setAdmissionCriteria(String admissionCriteria) {
        this.admissionCriteria = admissionCriteria;
    }

    public String getAdmissionStatus() {
        return admissionStatus;
    }

    public void setAdmissionStatus(String admissionStatus) {
        this.admissionStatus = admissionStatus;
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId;
    }

    public Collection<Admissions> getAdmissionsCollection() {
        return admissionsCollection;
    }

    public void setAdmissionsCollection(Collection<Admissions> admissionsCollection) {
        this.admissionsCollection = admissionsCollection;
    }

    public Countries getNationalityId() {
        return nationalityId;
    }

    public void setNationalityId(Countries nationalityId) {
        this.nationalityId = nationalityId;
    }

    public Courses getCourse() {
        return course;
    }

    public void setCourse(Courses course) {
        this.course = course;
    }

    public Lgas getLgaId() {
        return lgaId;
    }

    public void setLgaId(Lgas lgaId) {
        this.lgaId = lgaId;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
    }

    public States getStateOfOriginId() {
        return stateOfOriginId;
    }

    public void setStateOfOriginId(States stateOfOriginId) {
        this.stateOfOriginId = stateOfOriginId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (registrationNo != null ? registrationNo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Utmeapplicants)) {
            return false;
        }
        Utmeapplicants other = (Utmeapplicants) object;
        if ((this.registrationNo == null && other.registrationNo != null) || (this.registrationNo != null && !this.registrationNo.equals(other.registrationNo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Utmeapplicants[ registrationNo=" + registrationNo + " ]";
    }
    
}
