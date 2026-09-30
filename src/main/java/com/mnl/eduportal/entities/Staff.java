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
@Table(name = "staff")
@NamedQueries({
    @NamedQuery(name = "Staff.findAll", query = "SELECT s FROM Staff s"),
    @NamedQuery(name = "Staff.findById", query = "SELECT s FROM Staff s WHERE s.id = :id"),
    @NamedQuery(name = "Staff.findByStaffNo", query = "SELECT s FROM Staff s WHERE s.staffNo = :staffNo"),
    @NamedQuery(name = "Staff.findByTitle", query = "SELECT s FROM Staff s WHERE s.title = :title"),
    @NamedQuery(name = "Staff.findBySurname", query = "SELECT s FROM Staff s WHERE s.surname = :surname"),
    @NamedQuery(name = "Staff.findByOthernames", query = "SELECT s FROM Staff s WHERE s.othernames = :othernames"),
    @NamedQuery(name = "Staff.findByGender", query = "SELECT s FROM Staff s WHERE s.gender = :gender"),
    @NamedQuery(name = "Staff.findByDateOfBirth", query = "SELECT s FROM Staff s WHERE s.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Staff.findByMaritalStatus", query = "SELECT s FROM Staff s WHERE s.maritalStatus = :maritalStatus"),
    @NamedQuery(name = "Staff.findByMaidenName", query = "SELECT s FROM Staff s WHERE s.maidenName = :maidenName"),
    @NamedQuery(name = "Staff.findByDofAppointment", query = "SELECT s FROM Staff s WHERE s.dofAppointment = :dofAppointment"),
    @NamedQuery(name = "Staff.findByDoConfirmation", query = "SELECT s FROM Staff s WHERE s.doConfirmation = :doConfirmation"),
    @NamedQuery(name = "Staff.findByDolPromotion", query = "SELECT s FROM Staff s WHERE s.dolPromotion = :dolPromotion"),
    @NamedQuery(name = "Staff.findByServiceStatus", query = "SELECT s FROM Staff s WHERE s.serviceStatus = :serviceStatus"),
    @NamedQuery(name = "Staff.findByServiceStatusComment", query = "SELECT s FROM Staff s WHERE s.serviceStatusComment = :serviceStatusComment"),
    @NamedQuery(name = "Staff.findByCurrentQualification", query = "SELECT s FROM Staff s WHERE s.currentQualification = :currentQualification"),
    @NamedQuery(name = "Staff.findByAreaOfStudy", query = "SELECT s FROM Staff s WHERE s.areaOfStudy = :areaOfStudy"),
    @NamedQuery(name = "Staff.findByDateAdded", query = "SELECT s FROM Staff s WHERE s.dateAdded = :dateAdded"),
    @NamedQuery(name = "Staff.findByDateExited", query = "SELECT s FROM Staff s WHERE s.dateExited = :dateExited"),
    @NamedQuery(name = "Staff.findByPhoneNo", query = "SELECT s FROM Staff s WHERE s.phoneNo = :phoneNo"),
    @NamedQuery(name = "Staff.findByPersonalEmailAddress", query = "SELECT s FROM Staff s WHERE s.personalEmailAddress = :personalEmailAddress"),
    @NamedQuery(name = "Staff.findByOfficialEmailAddress", query = "SELECT s FROM Staff s WHERE s.officialEmailAddress = :officialEmailAddress")})
public class Staff implements Serializable {

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
    @Column(name = "staff_no")
    private String staffNo;
    @Size(max = 50)
    @Column(name = "title")
    private String title;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "surname")
    private String surname;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 50)
    @Column(name = "gender")
    private String gender;
    @Size(max = 20)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 20)
    @Column(name = "marital_status")
    private String maritalStatus;
    @Size(max = 100)
    @Column(name = "maiden_name")
    private String maidenName;
    @Column(name = "dof_appointment")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dofAppointment;
    @Column(name = "do_confirmation")
    @Temporal(TemporalType.TIMESTAMP)
    private Date doConfirmation;
    @Column(name = "dol_promotion")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dolPromotion;
    @Size(max = 50)
    @Column(name = "service_status")
    private String serviceStatus;
    @Size(max = 100)
    @Column(name = "service_status_comment")
    private String serviceStatusComment;
    @Size(max = 100)
    @Column(name = "current_qualification")
    private String currentQualification;
    @Size(max = 200)
    @Column(name = "area_of_study")
    private String areaOfStudy;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Column(name = "date_exited")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateExited;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Size(max = 100)
    @Column(name = "personal_email_address")
    private String personalEmailAddress;
    @Size(max = 100)
    @Column(name = "official_email_address")
    private String officialEmailAddress;
    @OneToMany(mappedBy = "processedBy")
    private Collection<Transcriptapplication> transcriptapplicationCollection;
    @OneToMany(mappedBy = "approvedBy")
    private Collection<Deferments> defermentsCollection;
    @JoinColumn(name = "nationality_id", referencedColumnName = "id")
    @ManyToOne
    private Countries nationalityId;
    @JoinColumn(name = "department_id", referencedColumnName = "id")
    @ManyToOne
    private Departments departmentId;
    @JoinColumn(name = "faculty_directorate_id", referencedColumnName = "id")
    @ManyToOne
    private FacultiesDirectorates facultyDirectorateId;
    @JoinColumn(name = "lga_id", referencedColumnName = "id")
    @ManyToOne
    private Lgas lgaId;
    @JoinColumn(name = "position_id", referencedColumnName = "id")
    @ManyToOne
    private Positions positionId;
    @JoinColumn(name = "state_of_origin_id", referencedColumnName = "id")
    @ManyToOne
    private States stateOfOriginId;
    @JoinColumn(name = "unit_id", referencedColumnName = "id")
    @ManyToOne
    private Units unitId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "staffId")
    private Collection<Semestercoursesallocation> semestercoursesallocationCollection;
    @OneToMany(mappedBy = "approvalLevel1User")
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection;
    @OneToMany(mappedBy = "approvalLevel3User")
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection1;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "staff")
    private Staffsalaryinfo staffsalaryinfo;

    public Staff() {
    }

    public Staff(String id) {
        this.id = id;
    }

    public Staff(String id, String staffNo, String surname, String othernames) {
        this.id = id;
        this.staffNo = staffNo;
        this.surname = surname;
        this.othernames = othernames;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStaffNo() {
        return staffNo;
    }

    public void setStaffNo(String staffNo) {
        this.staffNo = staffNo;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
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

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        this.maritalStatus = maritalStatus;
    }

    public String getMaidenName() {
        return maidenName;
    }

    public void setMaidenName(String maidenName) {
        this.maidenName = maidenName;
    }

    public Date getDofAppointment() {
        return dofAppointment;
    }

    public void setDofAppointment(Date dofAppointment) {
        this.dofAppointment = dofAppointment;
    }

    public Date getDoConfirmation() {
        return doConfirmation;
    }

    public void setDoConfirmation(Date doConfirmation) {
        this.doConfirmation = doConfirmation;
    }

    public Date getDolPromotion() {
        return dolPromotion;
    }

    public void setDolPromotion(Date dolPromotion) {
        this.dolPromotion = dolPromotion;
    }

    public String getServiceStatus() {
        return serviceStatus;
    }

    public void setServiceStatus(String serviceStatus) {
        this.serviceStatus = serviceStatus;
    }

    public String getServiceStatusComment() {
        return serviceStatusComment;
    }

    public void setServiceStatusComment(String serviceStatusComment) {
        this.serviceStatusComment = serviceStatusComment;
    }

    public String getCurrentQualification() {
        return currentQualification;
    }

    public void setCurrentQualification(String currentQualification) {
        this.currentQualification = currentQualification;
    }

    public String getAreaOfStudy() {
        return areaOfStudy;
    }

    public void setAreaOfStudy(String areaOfStudy) {
        this.areaOfStudy = areaOfStudy;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Date getDateExited() {
        return dateExited;
    }

    public void setDateExited(Date dateExited) {
        this.dateExited = dateExited;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getPersonalEmailAddress() {
        return personalEmailAddress;
    }

    public void setPersonalEmailAddress(String personalEmailAddress) {
        this.personalEmailAddress = personalEmailAddress;
    }

    public String getOfficialEmailAddress() {
        return officialEmailAddress;
    }

    public void setOfficialEmailAddress(String officialEmailAddress) {
        this.officialEmailAddress = officialEmailAddress;
    }

    public Collection<Transcriptapplication> getTranscriptapplicationCollection() {
        return transcriptapplicationCollection;
    }

    public void setTranscriptapplicationCollection(Collection<Transcriptapplication> transcriptapplicationCollection) {
        this.transcriptapplicationCollection = transcriptapplicationCollection;
    }

    public Collection<Deferments> getDefermentsCollection() {
        return defermentsCollection;
    }

    public void setDefermentsCollection(Collection<Deferments> defermentsCollection) {
        this.defermentsCollection = defermentsCollection;
    }

    public Countries getNationalityId() {
        return nationalityId;
    }

    public void setNationalityId(Countries nationalityId) {
        this.nationalityId = nationalityId;
    }

    public Departments getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Departments departmentId) {
        this.departmentId = departmentId;
    }

    public FacultiesDirectorates getFacultyDirectorateId() {
        return facultyDirectorateId;
    }

    public void setFacultyDirectorateId(FacultiesDirectorates facultyDirectorateId) {
        this.facultyDirectorateId = facultyDirectorateId;
    }

    public Lgas getLgaId() {
        return lgaId;
    }

    public void setLgaId(Lgas lgaId) {
        this.lgaId = lgaId;
    }

    public Positions getPositionId() {
        return positionId;
    }

    public void setPositionId(Positions positionId) {
        this.positionId = positionId;
    }

    public States getStateOfOriginId() {
        return stateOfOriginId;
    }

    public void setStateOfOriginId(States stateOfOriginId) {
        this.stateOfOriginId = stateOfOriginId;
    }

    public Units getUnitId() {
        return unitId;
    }

    public void setUnitId(Units unitId) {
        this.unitId = unitId;
    }

    public Collection<Semestercoursesallocation> getSemestercoursesallocationCollection() {
        return semestercoursesallocationCollection;
    }

    public void setSemestercoursesallocationCollection(Collection<Semestercoursesallocation> semestercoursesallocationCollection) {
        this.semestercoursesallocationCollection = semestercoursesallocationCollection;
    }

    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection() {
        return semesterregistrationsummaryCollection;
    }

    public void setSemesterregistrationsummaryCollection(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection) {
        this.semesterregistrationsummaryCollection = semesterregistrationsummaryCollection;
    }

    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection1() {
        return semesterregistrationsummaryCollection1;
    }

    public void setSemesterregistrationsummaryCollection1(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection1) {
        this.semesterregistrationsummaryCollection1 = semesterregistrationsummaryCollection1;
    }

    public Staffsalaryinfo getStaffsalaryinfo() {
        return staffsalaryinfo;
    }

    public void setStaffsalaryinfo(Staffsalaryinfo staffsalaryinfo) {
        this.staffsalaryinfo = staffsalaryinfo;
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
        if (!(object instanceof Staff)) {
            return false;
        }
        Staff other = (Staff) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Staff[ id=" + id + " ]";
    }
    
}
