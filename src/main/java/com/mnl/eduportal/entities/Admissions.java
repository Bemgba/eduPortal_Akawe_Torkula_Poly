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
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "admissions")
@NamedQueries({
    @NamedQuery(name = "Admissions.findAll", query = "SELECT a FROM Admissions a"),
    @NamedQuery(name = "Admissions.findById", query = "SELECT a FROM Admissions a WHERE a.id = :id"),
    @NamedQuery(name = "Admissions.findByRegistrationNo", query = "SELECT a FROM Admissions a WHERE a.registrationNo = :registrationNo"),
    @NamedQuery(name = "Admissions.findBySurname", query = "SELECT a FROM Admissions a WHERE a.surname = :surname"),
    @NamedQuery(name = "Admissions.findByOthernames", query = "SELECT a FROM Admissions a WHERE a.othernames = :othernames"),
    @NamedQuery(name = "Admissions.findByGender", query = "SELECT a FROM Admissions a WHERE a.gender = :gender"),
    @NamedQuery(name = "Admissions.findByDateOfBirth", query = "SELECT a FROM Admissions a WHERE a.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Admissions.findBySession", query = "SELECT a FROM Admissions a WHERE a.session = :session"),
    @NamedQuery(name = "Admissions.findByAdmissionStatus", query = "SELECT a FROM Admissions a WHERE a.admissionStatus = :admissionStatus"),
    @NamedQuery(name = "Admissions.findByModeOfEntry", query = "SELECT a FROM Admissions a WHERE a.modeOfEntry = :modeOfEntry"),
    @NamedQuery(name = "Admissions.findByMaritalStatus", query = "SELECT a FROM Admissions a WHERE a.maritalStatus = :maritalStatus"),
    @NamedQuery(name = "Admissions.findByMeritType", query = "SELECT a FROM Admissions a WHERE a.meritType = :meritType"),
    @NamedQuery(name = "Admissions.findByReligion", query = "SELECT a FROM Admissions a WHERE a.religion = :religion"),
    @NamedQuery(name = "Admissions.findByDateAdded", query = "SELECT a FROM Admissions a WHERE a.dateAdded = :dateAdded"),
    @NamedQuery(name = "Admissions.findByAdmissionStatusComment", query = "SELECT a FROM Admissions a WHERE a.admissionStatusComment = :admissionStatusComment")})
public class Admissions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "registration_no")
    private String registrationNo;
    @Size(max = 100)
    @Column(name = "surname")
    private String surname;
    @Size(max = 150)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 10)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 10)
    @Column(name = "session")
    private String session;
    @Size(max = 20)
    @Column(name = "admission_status")
    private String admissionStatus;
    @Size(max = 20)
    @Column(name = "mode_of_entry")
    private String modeOfEntry;
    @Size(max = 20)
    @Column(name = "marital_status")
    private String maritalStatus;
    @Size(max = 20)
    @Column(name = "merit_type")
    private String meritType;
    @Size(max = 20)
    @Column(name = "religion")
    private String religion;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 200)
    @Column(name = "admission_status_comment")
    private String admissionStatusComment;
    @JoinColumn(name = "nationality_id", referencedColumnName = "id")
    @ManyToOne
    private Countries nationalityId;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne
    private Courses courseId;
    @JoinColumn(name = "lga_id", referencedColumnName = "id")
    @ManyToOne
    private Lgas lgaId;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Programmes programmeId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schools schoolId;
    @JoinColumn(name = "state_of_origin_id", referencedColumnName = "id")
    @ManyToOne
    private States stateOfOriginId;
    @JoinColumn(name = "utme_applicants_id", referencedColumnName = "registration_no")
    @ManyToOne
    private Utmeapplicants utmeApplicantsId;

    public Admissions() {
    }

    public Admissions(String id) {
        this.id = id;
    }

    public Admissions(String id, String registrationNo) {
        this.id = id;
        this.registrationNo = registrationNo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
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

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getAdmissionStatus() {
        return admissionStatus;
    }

    public void setAdmissionStatus(String admissionStatus) {
        this.admissionStatus = admissionStatus;
    }

    public String getModeOfEntry() {
        return modeOfEntry;
    }

    public void setModeOfEntry(String modeOfEntry) {
        this.modeOfEntry = modeOfEntry;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public String getMeritType() {
        return meritType;
    }

    public void setMeritType(String meritType) {
        this.meritType = meritType;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getAdmissionStatusComment() {
        return admissionStatusComment;
    }

    public void setAdmissionStatusComment(String admissionStatusComment) {
        this.admissionStatusComment = admissionStatusComment;
    }

    public Countries getNationalityId() {
        return nationalityId;
    }

    public void setNationalityId(Countries nationalityId) {
        this.nationalityId = nationalityId;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
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

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
    }

    public States getStateOfOriginId() {
        return stateOfOriginId;
    }

    public void setStateOfOriginId(States stateOfOriginId) {
        this.stateOfOriginId = stateOfOriginId;
    }

    public Utmeapplicants getUtmeApplicantsId() {
        return utmeApplicantsId;
    }

    public void setUtmeApplicantsId(Utmeapplicants utmeApplicantsId) {
        this.utmeApplicantsId = utmeApplicantsId;
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
        if (!(object instanceof Admissions)) {
            return false;
        }
        Admissions other = (Admissions) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Admissions[ id=" + id + " ]";
    }
    
}
