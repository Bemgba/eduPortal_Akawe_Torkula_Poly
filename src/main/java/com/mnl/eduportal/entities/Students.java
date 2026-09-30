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
import java.util.List;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "students")
@NamedQueries({
    @NamedQuery(name = "Students.findAll", query = "SELECT s FROM Students s"),
    @NamedQuery(name = "Students.findById", query = "SELECT s FROM Students s WHERE s.id = :id"),
    @NamedQuery(name = "Students.findByRegistrationNo", query = "SELECT s FROM Students s WHERE s.registrationNo = :registrationNo"),
    @NamedQuery(name = "Students.findByMatricNo", query = "SELECT s FROM Students s WHERE s.matricNo = :matricNo"),
    @NamedQuery(name = "Students.findBySurname", query = "SELECT s FROM Students s WHERE s.surname = :surname"),
    @NamedQuery(name = "Students.findByOthernames", query = "SELECT s FROM Students s WHERE s.othernames = :othernames"),
    @NamedQuery(name = "Students.findByDateOfBirth", query = "SELECT s FROM Students s WHERE s.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Students.findByGender", query = "SELECT s FROM Students s WHERE s.gender = :gender"),
    @NamedQuery(name = "Students.findByModeOfEntry", query = "SELECT s FROM Students s WHERE s.modeOfEntry = :modeOfEntry"),
    @NamedQuery(name = "Students.findBySessionAdmitted", query = "SELECT s FROM Students s WHERE s.sessionAdmitted = :sessionAdmitted"),
    @NamedQuery(name = "Students.findByClassAdmitted", query = "SELECT s FROM Students s WHERE s.classAdmitted = :classAdmitted"),
    @NamedQuery(name = "Students.findByCurrentClass", query = "SELECT s FROM Students s WHERE s.currentClass = :currentClass"),
    @NamedQuery(name = "Students.findByPersonalEmail", query = "SELECT s FROM Students s WHERE s.personalEmail = :personalEmail"),
    @NamedQuery(name = "Students.findByUniversityEmail", query = "SELECT s FROM Students s WHERE s.universityEmail = :universityEmail"),
    @NamedQuery(name = "Students.findByPhoneNo", query = "SELECT s FROM Students s WHERE s.phoneNo = :phoneNo"),
    @NamedQuery(name = "Students.findByContactAddress", query = "SELECT s FROM Students s WHERE s.contactAddress = :contactAddress"),
    @NamedQuery(name = "Students.findBySessionExited", query = "SELECT s FROM Students s WHERE s.sessionExited = :sessionExited"),
    @NamedQuery(name = "Students.findByExitType", query = "SELECT s FROM Students s WHERE s.exitType = :exitType"),
    @NamedQuery(name = "Students.findByExitComment", query = "SELECT s FROM Students s WHERE s.exitComment = :exitComment"),
    @NamedQuery(name = "Students.findBySponsorshipType", query = "SELECT s FROM Students s WHERE s.sponsorshipType = :sponsorshipType"),
    @NamedQuery(name = "Students.findBySponsorshipName", query = "SELECT s FROM Students s WHERE s.sponsorshipName = :sponsorshipName"),
    @NamedQuery(name = "Students.findByHomeTown", query = "SELECT s FROM Students s WHERE s.homeTown = :homeTown"),
    @NamedQuery(name = "Students.findByMaritalStatus", query = "SELECT s FROM Students s WHERE s.maritalStatus = :maritalStatus"),
    @NamedQuery(name = "Students.findByReligion", query = "SELECT s FROM Students s WHERE s.religion = :religion"),
    @NamedQuery(name = "Students.findByDisability", query = "SELECT s FROM Students s WHERE s.disability = :disability"),
    @NamedQuery(name = "Students.findByExtraCurricularActivity", query = "SELECT s FROM Students s WHERE s.extraCurricularActivity = :extraCurricularActivity"),
    @NamedQuery(name = "Students.findByDateAdded", query = "SELECT s FROM Students s WHERE s.dateAdded = :dateAdded"),
    @NamedQuery(name = "Students.findByNokName", query = "SELECT s FROM Students s WHERE s.nokName = :nokName"),
    @NamedQuery(name = "Students.findByNokRelationship", query = "SELECT s FROM Students s WHERE s.nokRelationship = :nokRelationship"),
    @NamedQuery(name = "Students.findByNokAddress", query = "SELECT s FROM Students s WHERE s.nokAddress = :nokAddress"),
    @NamedQuery(name = "Students.findByNokPhoneNo", query = "SELECT s FROM Students s WHERE s.nokPhoneNo = :nokPhoneNo")})
public class Students implements Serializable {

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
    @Size(max = 50)
    @Column(name = "matric_no")
    private String matricNo;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "surname")
    private String surname;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 20)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 50)
    @Column(name = "mode_of_entry")
    private String modeOfEntry;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session_admitted")
    private String sessionAdmitted;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 5)
    @Column(name = "class_admitted")
    private String classAdmitted;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 5)
    @Column(name = "current_class")
    private String currentClass;
    @Size(max = 100)
    @Column(name = "personal_email")
    private String personalEmail;
    @Size(max = 100)
    @Column(name = "university_email")
    private String universityEmail;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Size(max = 200)
    @Column(name = "contact_address")
    private String contactAddress;
    @Size(max = 10)
    @Column(name = "session_exited")
    private String sessionExited;
    @Size(max = 100)
    @Column(name = "exit_type")
    private String exitType;
    @Size(max = 200)
    @Column(name = "exit_comment")
    private String exitComment;
    @Size(max = 100)
    @Column(name = "sponsorship_type")
    private String sponsorshipType;
    @Size(max = 200)
    @Column(name = "sponsorship_name")
    private String sponsorshipName;
    @Size(max = 100)
    @Column(name = "home_town")
    private String homeTown;
    @Size(max = 100)
    @Column(name = "marital_status")
    private String maritalStatus;
    @Size(max = 100)
    @Column(name = "religion")
    private String religion;
    @Size(max = 100)
    @Column(name = "disability")
    private String disability;
    @Size(max = 200)
    @Column(name = "extra_curricular_activity")
    private String extraCurricularActivity;
    @Basic(optional = false)
    @NotNull
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 200)
    @Column(name = "nok_name")
    private String nokName;
    @Size(max = 100)
    @Column(name = "nok_relationship")
    private String nokRelationship;
    @Size(max = 200)
    @Column(name = "nok_address")
    private String nokAddress;
    @Size(max = 13)
    @Column(name = "nok_phone_no")
    private String nokPhoneNo;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Hostelallocation> hostelallocationCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "students")
    private Studentssocialmedia studentssocialmedia;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "students")
    private Studentsupplimentarybiodata studentsupplimentarybiodata;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Transcriptapplication> transcriptapplicationCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Semesterregistration> semesterregistrationCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentsId", fetch=FetchType.EAGER)
    private Collection<Studentprogression> studentprogressionCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Lecturerevaluation> lecturerevaluationCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentsId")
    private List<Summerschoolapplication> summerschoolapplicationList;
    @OneToMany(mappedBy = "payerId")
    private Collection<Payments> paymentsCollection;
    @JoinColumn(name = "nationality", referencedColumnName = "id")
    @ManyToOne
    private Countries nationality;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @JoinColumn(name = "lga", referencedColumnName = "id")
    @ManyToOne
    private Lgas lga;
    
    @JoinColumn(name = "state_of_origin", referencedColumnName = "id")
    @ManyToOne
    private States stateOfOrigin;
    @JoinColumn(name = "added_by", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Users addedBy;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Deferments> defermentsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "studentId")
    private List<Hostelapplication> hostelapplicationList;
    public Students() {
    }

    public Students(String id) {
        this.id = id;
    }

    public Students(String id, String registrationNo, String surname, String othernames, String sessionAdmitted, String classAdmitted, String currentClass, Date dateAdded) {
        this.id = id;
        this.registrationNo = registrationNo;
        this.surname = surname;
        this.othernames = othernames;
        this.sessionAdmitted = sessionAdmitted;
        this.classAdmitted = classAdmitted;
        this.currentClass = currentClass;
        this.dateAdded = dateAdded;
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

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getModeOfEntry() {
        return modeOfEntry;
    }

    public void setModeOfEntry(String modeOfEntry) {
        this.modeOfEntry = modeOfEntry;
    }

    public String getSessionAdmitted() {
        return sessionAdmitted;
    }

    public void setSessionAdmitted(String sessionAdmitted) {
        this.sessionAdmitted = sessionAdmitted;
    }

    public String getClassAdmitted() {
        return classAdmitted;
    }

    public void setClassAdmitted(String classAdmitted) {
        this.classAdmitted = classAdmitted;
    }

    public String getCurrentClass() {
        return currentClass;
    }

    public void setCurrentClass(String currentClass) {
        this.currentClass = currentClass;
    }

    public String getPersonalEmail() {
        return personalEmail;
    }

    public void setPersonalEmail(String personalEmail) {
        this.personalEmail = personalEmail;
    }

    public String getUniversityEmail() {
        return universityEmail;
    }

    public void setUniversityEmail(String universityEmail) {
        this.universityEmail = universityEmail;
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

    public String getSessionExited() {
        return sessionExited;
    }

    public void setSessionExited(String sessionExited) {
        this.sessionExited = sessionExited;
    }

    public String getExitType() {
        return exitType;
    }

    public void setExitType(String exitType) {
        this.exitType = exitType;
    }

    public String getExitComment() {
        return exitComment;
    }

    public void setExitComment(String exitComment) {
        this.exitComment = exitComment;
    }

    public String getSponsorshipType() {
        return sponsorshipType;
    }

    public void setSponsorshipType(String sponsorshipType) {
        this.sponsorshipType = sponsorshipType;
    }

    public String getSponsorshipName() {
        return sponsorshipName;
    }

    public void setSponsorshipName(String sponsorshipName) {
        this.sponsorshipName = sponsorshipName;
    }

    public String getHomeTown() {
        return homeTown;
    }

    public void setHomeTown(String homeTown) {
        this.homeTown = homeTown;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

    public String getDisability() {
        return disability;
    }

    public void setDisability(String disability) {
        this.disability = disability;
    }

    public String getExtraCurricularActivity() {
        return extraCurricularActivity;
    }

    public void setExtraCurricularActivity(String extraCurricularActivity) {
        this.extraCurricularActivity = extraCurricularActivity;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getNokName() {
        return nokName;
    }

    public void setNokName(String nokName) {
        this.nokName = nokName;
    }

    public String getNokRelationship() {
        return nokRelationship;
    }

    public void setNokRelationship(String nokRelationship) {
        this.nokRelationship = nokRelationship;
    }

    public String getNokAddress() {
        return nokAddress;
    }

    public void setNokAddress(String nokAddress) {
        this.nokAddress = nokAddress;
    }

    public String getNokPhoneNo() {
        return nokPhoneNo;
    }

    public void setNokPhoneNo(String nokPhoneNo) {
        this.nokPhoneNo = nokPhoneNo;
    }

    public Collection<Hostelallocation> getHostelallocationCollection() {
        return hostelallocationCollection;
    }

    public void setHostelallocationCollection(Collection<Hostelallocation> hostelallocationCollection) {
        this.hostelallocationCollection = hostelallocationCollection;
    }

    public Studentssocialmedia getStudentssocialmedia() {
        return studentssocialmedia;
    }

    public void setStudentssocialmedia(Studentssocialmedia studentssocialmedia) {
        this.studentssocialmedia = studentssocialmedia;
    }

    public Studentsupplimentarybiodata getStudentsupplimentarybiodata() {
        return studentsupplimentarybiodata;
    }

    public void setStudentsupplimentarybiodata(Studentsupplimentarybiodata studentsupplimentarybiodata) {
        this.studentsupplimentarybiodata = studentsupplimentarybiodata;
    }

    public Collection<Transcriptapplication> getTranscriptapplicationCollection() {
        return transcriptapplicationCollection;
    }

    public void setTranscriptapplicationCollection(Collection<Transcriptapplication> transcriptapplicationCollection) {
        this.transcriptapplicationCollection = transcriptapplicationCollection;
    }

    public Collection<Semesterregistration> getSemesterregistrationCollection() {
        return semesterregistrationCollection;
    }

    public void setSemesterregistrationCollection(Collection<Semesterregistration> semesterregistrationCollection) {
        this.semesterregistrationCollection = semesterregistrationCollection;
    }

    public Collection<Studentprogression> getStudentprogressionCollection() {
        return studentprogressionCollection;
    }

    public void setStudentprogressionCollection(Collection<Studentprogression> studentprogressionCollection) {
        this.studentprogressionCollection = studentprogressionCollection;
    }

    public Collection<Lecturerevaluation> getLecturerevaluationCollection() {
        return lecturerevaluationCollection;
    }

    public void setLecturerevaluationCollection(Collection<Lecturerevaluation> lecturerevaluationCollection) {
        this.lecturerevaluationCollection = lecturerevaluationCollection;
    }

    public Collection<Payments> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payments> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }

    public Countries getNationality() {
        return nationality;
    }

    public void setNationality(Countries nationality) {
        this.nationality = nationality;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Lgas getLga() {
        return lga;
    }

    public void setLga(Lgas lga) {
        this.lga = lga;
    }


    public States getStateOfOrigin() {
        return stateOfOrigin;
    }

    public void setStateOfOrigin(States stateOfOrigin) {
        this.stateOfOrigin = stateOfOrigin;
    }

    public Users getAddedBy() {
        return addedBy;
    }

    public void setAddedBy(Users addedBy) {
        this.addedBy = addedBy;
    }

    public Collection<Deferments> getDefermentsCollection() {
        return defermentsCollection;
    }

    public void setDefermentsCollection(Collection<Deferments> defermentsCollection) {
        this.defermentsCollection = defermentsCollection;
    }

    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection() {
        return semesterregistrationsummaryCollection;
    }

    public void setSemesterregistrationsummaryCollection(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection) {
        this.semesterregistrationsummaryCollection = semesterregistrationsummaryCollection;
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
        if (!(object instanceof Students)) {
            return false;
        }
        Students other = (Students) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Students[ id=" + id + " ]";
    }

    /**
     * @return the summerschoolapplicationList
     */
    public List<Summerschoolapplication> getSummerschoolapplicationList() {
        return summerschoolapplicationList;
    }

    /**
     * @param summerschoolapplicationList the summerschoolapplicationList to set
     */
    public void setSummerschoolapplicationList(List<Summerschoolapplication> summerschoolapplicationList) {
        this.summerschoolapplicationList = summerschoolapplicationList;
    }

    /**
     * @return the hostelapplicationList
     */
    public List<Hostelapplication> getHostelapplicationList() {
        return hostelapplicationList;
    }

    /**
     * @param hostelapplicationList the hostelapplicationList to set
     */
    public void setHostelapplicationList(List<Hostelapplication> hostelapplicationList) {
        this.hostelapplicationList = hostelapplicationList;
    }
    
}
