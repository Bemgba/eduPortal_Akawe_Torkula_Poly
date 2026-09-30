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
@Table(name = "semesterregistrationsummary")
@NamedQueries({
    @NamedQuery(name = "Semesterregistrationsummary.findAll", query = "SELECT s FROM Semesterregistrationsummary s"),
    @NamedQuery(name = "Semesterregistrationsummary.findById", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.id = :id"),
    @NamedQuery(name = "Semesterregistrationsummary.findBySession", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.session = :session"),
    @NamedQuery(name = "Semesterregistrationsummary.findBySemester", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.semester = :semester"),
    @NamedQuery(name = "Semesterregistrationsummary.findByTotalCoursesRegistered", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.totalCoursesRegistered = :totalCoursesRegistered"),
    @NamedQuery(name = "Semesterregistrationsummary.findByGpa", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.gpa = :gpa"),
    @NamedQuery(name = "Semesterregistrationsummary.findByTcue", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.tcue = :tcue"),
    @NamedQuery(name = "Semesterregistrationsummary.findByTcur", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.tcur = :tcur"),
    @NamedQuery(name = "Semesterregistrationsummary.findByRemarks", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.remarks = :remarks"),
    @NamedQuery(name = "Semesterregistrationsummary.findByResultStatus", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.resultStatus = :resultStatus"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel1", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel1 = :approvalLevel1"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel1Date", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel1Date = :approvalLevel1Date"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel2", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel2 = :approvalLevel2"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel2Date", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel2Date = :approvalLevel2Date"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel3", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel3 = :approvalLevel3"),
    @NamedQuery(name = "Semesterregistrationsummary.findByApprovalLevel3Date", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.approvalLevel3Date = :approvalLevel3Date"),
    @NamedQuery(name = "Semesterregistrationsummary.findByNote", query = "SELECT s FROM Semesterregistrationsummary s WHERE s.note = :note")})
public class Semesterregistrationsummary implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session")
    private String session;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "semester")
    private String semester;
    @Column(name = "total_courses_registered")
    private Integer totalCoursesRegistered;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "gpa")
    private Double gpa;
    @Column(name = "tcue")
    private Double tcue;
    @Column(name = "tcur")
    private Double tcur;
    @Size(max = 200)
    @Column(name = "remarks")
    private String remarks;
    @Size(max = 200)
    @Column(name = "result_status")
    private String resultStatus;
    @Size(max = 50)
    @Column(name = "approval_level_1")
    private String approvalLevel1;
    @Column(name = "approval_level_1_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date approvalLevel1Date;
    @Size(max = 50)
    @Column(name = "approval_level_2")
    private String approvalLevel2;
    @Column(name = "approval_level_2_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date approvalLevel2Date;
    @Size(max = 50)
    @Column(name = "approval_level_3")
    private String approvalLevel3;
    @Column(name = "approval_level_3_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date approvalLevel3Date;
    @Size(max = 200)
    @Column(name = "note")
    private String note;
    @JoinColumn(name = "semesterregistration_id", referencedColumnName = "id")
    @ManyToOne(fetch = FetchType.LAZY)
    private Semesterregistration semesterregistrationId;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @JoinColumn(name = "approval_level_2_user", referencedColumnName = "head_id")
    @ManyToOne
    private FacultiesDirectorates approvalLevel2User;
    @JoinColumn(name = "approval_level_1_user", referencedColumnName = "id")
    @ManyToOne
    private Staff approvalLevel1User;
    @JoinColumn(name = "approval_level_3_user", referencedColumnName = "id")
    @ManyToOne
    private Staff approvalLevel3User;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;

    public Semesterregistrationsummary() {
    }

    public Semesterregistrationsummary(String id) {
        this.id = id;
    }

    public Semesterregistrationsummary(String id, String session, String semester) {
        this.id = id;
        this.session = session;
        this.semester = semester;
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

    public Integer getTotalCoursesRegistered() {
        return totalCoursesRegistered;
    }

    public void setTotalCoursesRegistered(Integer totalCoursesRegistered) {
        this.totalCoursesRegistered = totalCoursesRegistered;
    }

    public Double getGpa() {
        return gpa;
    }

    public void setGpa(Double gpa) {
        this.gpa = gpa;
    }

    public Double getTcue() {
        return tcue;
    }

    public void setTcue(Double tcue) {
        this.tcue = tcue;
    }

    public Double getTcur() {
        return tcur;
    }

    public void setTcur(Double tcur) {
        this.tcur = tcur;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getResultStatus() {
        return resultStatus;
    }

    public void setResultStatus(String resultStatus) {
        this.resultStatus = resultStatus;
    }

    public String getApprovalLevel1() {
        return approvalLevel1;
    }

    public void setApprovalLevel1(String approvalLevel1) {
        this.approvalLevel1 = approvalLevel1;
    }

    public Date getApprovalLevel1Date() {
        return approvalLevel1Date;
    }

    public void setApprovalLevel1Date(Date approvalLevel1Date) {
        this.approvalLevel1Date = approvalLevel1Date;
    }

    public String getApprovalLevel2() {
        return approvalLevel2;
    }

    public void setApprovalLevel2(String approvalLevel2) {
        this.approvalLevel2 = approvalLevel2;
    }

    public Date getApprovalLevel2Date() {
        return approvalLevel2Date;
    }

    public void setApprovalLevel2Date(Date approvalLevel2Date) {
        this.approvalLevel2Date = approvalLevel2Date;
    }

    public String getApprovalLevel3() {
        return approvalLevel3;
    }

    public void setApprovalLevel3(String approvalLevel3) {
        this.approvalLevel3 = approvalLevel3;
    }

    public Date getApprovalLevel3Date() {
        return approvalLevel3Date;
    }

    public void setApprovalLevel3Date(Date approvalLevel3Date) {
        this.approvalLevel3Date = approvalLevel3Date;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public FacultiesDirectorates getApprovalLevel2User() {
        return approvalLevel2User;
    }

    public void setApprovalLevel2User(FacultiesDirectorates approvalLevel2User) {
        this.approvalLevel2User = approvalLevel2User;
    }

    public Staff getApprovalLevel1User() {
        return approvalLevel1User;
    }

    public void setApprovalLevel1User(Staff approvalLevel1User) {
        this.approvalLevel1User = approvalLevel1User;
    }

    public Staff getApprovalLevel3User() {
        return approvalLevel3User;
    }

    public void setApprovalLevel3User(Staff approvalLevel3User) {
        this.approvalLevel3User = approvalLevel3User;
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
        if (!(object instanceof Semesterregistrationsummary)) {
            return false;
        }
        Semesterregistrationsummary other = (Semesterregistrationsummary) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Semesterregistrationsummary[ id=" + id + " ]";
    }

    /**
     * @return the semesterregistrationId
     */
    public Semesterregistration getSemesterregistrationId() {
        return semesterregistrationId;
    }

    /**
     * @param semesterregistrationId the semesterregistrationId to set
     */
    public void setSemesterregistrationId(Semesterregistration semesterregistrationId) {
        this.semesterregistrationId = semesterregistrationId;
    }

}
