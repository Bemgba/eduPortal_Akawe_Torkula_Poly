/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
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
@Table(name = "semesterregistration")
@NamedQueries({
    @NamedQuery(name = "Semesterregistration.findAll", query = "SELECT s FROM Semesterregistration s"),
    @NamedQuery(name = "Semesterregistration.findById", query = "SELECT s FROM Semesterregistration s WHERE s.id = :id"),
    @NamedQuery(name = "Semesterregistration.findBySession", query = "SELECT s FROM Semesterregistration s WHERE s.session = :session"),
    @NamedQuery(name = "Semesterregistration.findBySemester", query = "SELECT s FROM Semesterregistration s WHERE s.semester = :semester"),
    @NamedQuery(name = "Semesterregistration.findByLevel", query = "SELECT s FROM Semesterregistration s WHERE s.level = :level"),
    @NamedQuery(name = "Semesterregistration.findByCreditUnit", query = "SELECT s FROM Semesterregistration s WHERE s.creditUnit = :creditUnit"),
    @NamedQuery(name = "Semesterregistration.findByCa", query = "SELECT s FROM Semesterregistration s WHERE s.ca = :ca"),
    @NamedQuery(name = "Semesterregistration.findByExam", query = "SELECT s FROM Semesterregistration s WHERE s.exam = :exam"),
    @NamedQuery(name = "Semesterregistration.findByPractical", query = "SELECT s FROM Semesterregistration s WHERE s.practical = :practical"),
    @NamedQuery(name = "Semesterregistration.findByRegistrationStatus", query = "SELECT s FROM Semesterregistration s WHERE s.registrationStatus = :registrationStatus"),
    @NamedQuery(name = "Semesterregistration.findByDateRegistered", query = "SELECT s FROM Semesterregistration s WHERE s.dateRegistered = :dateRegistered"),
    @NamedQuery(name = "Semesterregistration.findByDareResultPosted", query = "SELECT s FROM Semesterregistration s WHERE s.dareResultPosted = :dareResultPosted"),
    @NamedQuery(name = "Semesterregistration.findByPassStatus", query = "SELECT s FROM Semesterregistration s WHERE s.passStatus = :passStatus")})
public class Semesterregistration implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 10)
    @Column(name = "session")
    private String session;
    @Size(max = 10)
    @Column(name = "semester")
    private String semester;
    @Size(max = 10)
    @Column(name = "level")
    private String level;
    @Column(name = "credit_unit")
    private Integer creditUnit;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "ca")
    private Double ca;
    @Column(name = "exam")
    private Double exam;
    @Column(name = "practical")
    private Double practical;
    @Size(max = 50)
    @Column(name = "registration_status")
    private String registrationStatus;
    @Column(name = "date_registered")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateRegistered;
    @Column(name = "dare_result_posted")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dareResultPosted;
    @Size(max = 50)
    @Column(name = "pass_status")
    private String passStatus;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(fetch = FetchType.LAZY)
    private Courses courseId;
    @JoinColumn(name = "semester_registration_course_id", referencedColumnName = "id")
    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    private Semesterregistrationcourses semesterRegistrationCourseId;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;
    @OneToMany(mappedBy = "semesterregistrationId", fetch = FetchType.LAZY)
    private Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection;

    public Semesterregistration() {
    }

    public Semesterregistration(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSession() {
        return session;
    }

    public void setSession(String session) {
        this.session = session;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Integer getCreditUnit() {
        return creditUnit;
    }

    public void setCreditUnit(Integer creditUnit) {
        this.creditUnit = creditUnit;
    }

    public Double getCa() {
        return ca;
    }

    public void setCa(Double ca) {
        this.ca = ca;
    }

    public Double getExam() {
        return exam;
    }

    public void setExam(Double exam) {
        this.exam = exam;
    }

    public Double getPractical() {
        return practical;
    }

    public void setPractical(Double practical) {
        this.practical = practical;
    }

    public String getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(String registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    public Date getDateRegistered() {
        return dateRegistered;
    }

    public void setDateRegistered(Date dateRegistered) {
        this.dateRegistered = dateRegistered;
    }

    public Date getDareResultPosted() {
        return dareResultPosted;
    }

    public void setDareResultPosted(Date dareResultPosted) {
        this.dareResultPosted = dareResultPosted;
    }

    public String getPassStatus() {
        return passStatus;
    }

    public void setPassStatus(String passStatus) {
        this.passStatus = passStatus;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Semesterregistrationcourses getSemesterRegistrationCourseId() {
        return semesterRegistrationCourseId;
    }

    public void setSemesterRegistrationCourseId(Semesterregistrationcourses semesterRegistrationCourseId) {
        this.semesterRegistrationCourseId = semesterRegistrationCourseId;
    }

    public Students getStudentId() {
        return studentId;
    }

    public void setStudentId(Students studentId) {
        this.studentId = studentId;
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
        if (!(object instanceof Semesterregistration)) {
            return false;
        }
        Semesterregistration other = (Semesterregistration) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semesterregistration[ id=" + id + " ]";
    }

    /**
     * @return the semesterregistrationsummaryCollection
     */
    public Collection<Semesterregistrationsummary> getSemesterregistrationsummaryCollection() {
        return semesterregistrationsummaryCollection;
    }

    /**
     * @param semesterregistrationsummaryCollection the
     * semesterregistrationsummaryCollection to set
     */
    public void setSemesterregistrationsummaryCollection(Collection<Semesterregistrationsummary> semesterregistrationsummaryCollection) {
        this.semesterregistrationsummaryCollection = semesterregistrationsummaryCollection;
    }

}
