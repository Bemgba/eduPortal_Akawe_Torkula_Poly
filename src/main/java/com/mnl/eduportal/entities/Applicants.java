/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
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
@Table(name = "applicants")
@NamedQueries({
    @NamedQuery(name = "Applicants.findAll", query = "SELECT a FROM Applicants a"),
    @NamedQuery(name = "Applicants.findById", query = "SELECT a FROM Applicants a WHERE a.id = :id"),
    @NamedQuery(name = "Applicants.findByApplicationType", query = "SELECT a FROM Applicants a WHERE a.applicationType = :applicationType"),
    @NamedQuery(name = "Applicants.findBySurname", query = "SELECT a FROM Applicants a WHERE a.surname = :surname"),
    @NamedQuery(name = "Applicants.findByOthernames", query = "SELECT a FROM Applicants a WHERE a.othernames = :othernames"),
    @NamedQuery(name = "Applicants.findByDateOfBirth", query = "SELECT a FROM Applicants a WHERE a.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Applicants.findByEmailAddress", query = "SELECT a FROM Applicants a WHERE a.emailAddress = :emailAddress"),
    @NamedQuery(name = "Applicants.findByPhoneNo", query = "SELECT a FROM Applicants a WHERE a.phoneNo = :phoneNo"),
    @NamedQuery(name = "Applicants.findByContactAddress", query = "SELECT a FROM Applicants a WHERE a.contactAddress = :contactAddress"),
    @NamedQuery(name = "Applicants.findByHomeTown", query = "SELECT a FROM Applicants a WHERE a.homeTown = :homeTown"),
    @NamedQuery(name = "Applicants.findByDateInitiated", query = "SELECT a FROM Applicants a WHERE a.dateInitiated = :dateInitiated"),
    @NamedQuery(name = "Applicants.findByDateCompleted", query = "SELECT a FROM Applicants a WHERE a.dateCompleted = :dateCompleted"),
    @NamedQuery(name = "Applicants.findByStatus", query = "SELECT a FROM Applicants a WHERE a.status = :status"),
    @NamedQuery(name = "Applicants.findByGuardianName", query = "SELECT a FROM Applicants a WHERE a.guardianName = :guardianName"),
    @NamedQuery(name = "Applicants.findBySponsorPhone", query = "SELECT a FROM Applicants a WHERE a.sponsorPhone = :sponsorPhone"),
    @NamedQuery(name = "Applicants.findByGuardianAddress", query = "SELECT a FROM Applicants a WHERE a.guardianAddress = :guardianAddress"),
    @NamedQuery(name = "Applicants.findByMaritalStatus", query = "SELECT a FROM Applicants a WHERE a.maritalStatus = :maritalStatus"),
    @NamedQuery(name = "Applicants.findByGender", query = "SELECT a FROM Applicants a WHERE a.gender = :gender"),
    @NamedQuery(name = "Applicants.findByQualification", query = "SELECT a FROM Applicants a WHERE a.qualification = :qualification"),
    @NamedQuery(name = "Applicants.findBySession", query = "SELECT a FROM Applicants a WHERE a.session = :session")})
public class Applicants implements Serializable {

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
    @Column(name = "application_type")
    private String applicationType;
    @Size(max = 100)
    @Column(name = "surname")
    private String surname;
    @Size(max = 200)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 2147483647)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 100)
    @Column(name = "email_address")
    private String emailAddress;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Size(max = 200)
    @Column(name = "contact_address")
    private String contactAddress;
    @Size(max = 100)
    @Column(name = "home_town")
    private String homeTown;
    @Column(name = "date_initiated")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateInitiated;
    @Column(name = "date_completed")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCompleted;
    @Size(max = 50)
    @Column(name = "status")
    private String status;
    @Size(max = 200)
    @Column(name = "guardian_name")
    private String guardianName;

    @Size(max = 20)
    @Column(name = "sponsor_phone")
    private String sponsorPhone;

    @Size(max = 200)
    @Column(name = "guardian_address")
    private String guardianAddress;
    @Size(max = 50)
    @Column(name = "marital_status")
    private String maritalStatus;
    @Size(max = 20)
    @Column(name = "gender")
    private String gender;
    @Size(max = 100)
    @Column(name = "qualification")
    private String qualification;
    @Size(max = 13)
    @Column(name = "session")
    private String session;
    @JoinColumn(name = "country", referencedColumnName = "id")
    @ManyToOne
    private Countries country;
    @JoinColumn(name = "course_1", referencedColumnName = "id")
    @ManyToOne
    private Courses course1;
    @JoinColumn(name = "course_2", referencedColumnName = "id")
    @ManyToOne
    private Courses course2;
    @JoinColumn(name = "lga", referencedColumnName = "id")
    @ManyToOne
    private Lgas lga;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Programmes programmeId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schools schoolId;
    @JoinColumn(name = "state_of_origin", referencedColumnName = "id")
    @ManyToOne
    private States stateOfOrigin;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "applicants", fetch = FetchType.LAZY)
    private Applicantsutme applicantsutme;
    @OneToMany(mappedBy = "applicantsId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Applicantsreferees> applicantsrefereesCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "applicants", fetch = FetchType.LAZY)
    private Applicantsothers applicantsothers;

    public Applicants() {
    }

    public Applicants(String id) {
        this.id = id;
    }

    public Applicants(String id, String applicationType) {
        this.id = id;
        this.applicationType = applicationType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getApplicationType() {
        return applicationType;
    }

    public void setApplicationType(String applicationType) {
        this.applicationType = applicationType;
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

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getContactAddress() {
        return contactAddress;
    }

    public void setContactAddress(String contactAddress) {
        this.contactAddress = contactAddress;
    }

    public String getHomeTown() {
        return homeTown;
    }

    public void setHomeTown(String homeTown) {
        this.homeTown = homeTown;
    }

    public Date getDateInitiated() {
        return dateInitiated;
    }

    public void setDateInitiated(Date dateInitiated) {
        this.dateInitiated = dateInitiated;
    }

    public Date getDateCompleted() {
        return dateCompleted;
    }

    public void setDateCompleted(Date dateCompleted) {
        this.dateCompleted = dateCompleted;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getGuardianName() {
        return guardianName;
    }

    public void setGuardianName(String guardianName) {
        this.guardianName = guardianName;
    }

    public String getSponsorPhone() {
        return sponsorPhone;
    }

    public void setSponsorPhone(String sponsorPhone) {
        this.sponsorPhone=sponsorPhone;
               
    }

    public String getGuardianAddress() {
        return guardianAddress;
    }

    public void setGuardianAddress(String guardianAddress) {
        this.guardianAddress = guardianAddress;
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

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public Countries getCountry() {
        return country;
    }

    public void setCountry(Countries country) {
        this.country = country;
    }

    public Courses getCourse1() {
        return course1;
    }

    public void setCourse1(Courses course1) {
        this.course1 = course1;
    }

    public Courses getCourse2() {
        return course2;
    }

    public void setCourse2(Courses course2) {
        this.course2 = course2;
    }

    public Lgas getLga() {
        return lga;
    }

    public void setLga(Lgas lga) {
        this.lga = lga;
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

    public States getStateOfOrigin() {
        return stateOfOrigin;
    }

    public void setStateOfOrigin(States stateOfOrigin) {
        this.stateOfOrigin = stateOfOrigin;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    public Applicantsutme getApplicantsutme() {
        return applicantsutme;
    }

    public void setApplicantsutme(Applicantsutme applicantsutme) {
        this.applicantsutme = applicantsutme;
    }

    public Applicantsothers getApplicantsothers() {
        return applicantsothers;
    }

    public void setApplicantsothers(Applicantsothers applicantsothers) {
        this.applicantsothers = applicantsothers;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Applicants)) {
            return false;
        }
        Applicants other = (Applicants) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Applicants[ id=" + id + " ]";
    }

    /**
     * @return the applicantsrefereesCollection
     */
    public Collection<Applicantsreferees> getApplicantsrefereesCollection() {
        return applicantsrefereesCollection;
    }

    /**
     * @param applicantsrefereesCollection the applicantsrefereesCollection to
     * set
     */
    public void setApplicantsrefereesCollection(Collection<Applicantsreferees> applicantsrefereesCollection) {
        this.applicantsrefereesCollection = applicantsrefereesCollection;
    }

}
