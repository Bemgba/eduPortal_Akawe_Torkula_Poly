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
@Table(name = "deferments")
@NamedQueries({
    @NamedQuery(name = "Deferments.findAll", query = "SELECT d FROM Deferments d"),
    @NamedQuery(name = "Deferments.findById", query = "SELECT d FROM Deferments d WHERE d.id = :id"),
    @NamedQuery(name = "Deferments.findByLevelAt", query = "SELECT d FROM Deferments d WHERE d.levelAt = :levelAt"),
    @NamedQuery(name = "Deferments.findBySession", query = "SELECT d FROM Deferments d WHERE d.session = :session"),
    @NamedQuery(name = "Deferments.findBySemester", query = "SELECT d FROM Deferments d WHERE d.semester = :semester"),
    @NamedQuery(name = "Deferments.findByReason", query = "SELECT d FROM Deferments d WHERE d.reason = :reason"),
    @NamedQuery(name = "Deferments.findByDurationSemesters", query = "SELECT d FROM Deferments d WHERE d.durationSemesters = :durationSemesters"),
    @NamedQuery(name = "Deferments.findByApprovalStatus", query = "SELECT d FROM Deferments d WHERE d.approvalStatus = :approvalStatus"),
    @NamedQuery(name = "Deferments.findByDateApproved", query = "SELECT d FROM Deferments d WHERE d.dateApproved = :dateApproved"),
    @NamedQuery(name = "Deferments.findByDateApplied", query = "SELECT d FROM Deferments d WHERE d.dateApplied = :dateApplied"),
    @NamedQuery(name = "Deferments.findByExpectedResumptionSession", query = "SELECT d FROM Deferments d WHERE d.expectedResumptionSession = :expectedResumptionSession"),
    @NamedQuery(name = "Deferments.findByExpectedResumptionSemester", query = "SELECT d FROM Deferments d WHERE d.expectedResumptionSemester = :expectedResumptionSemester")})
public class Deferments implements Serializable {

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
    @Column(name = "level_at")
    private String levelAt;
    @Size(max = 10)
    @Column(name = "session")
    private String session;
    @Size(max = 10)
    @Column(name = "semester")
    private String semester;
    @Size(max = 200)
    @Column(name = "reason")
    private String reason;
    @Column(name = "duration_semesters")
    private Integer durationSemesters;
    @Size(max = 20)
    @Column(name = "approval_status")
    private String approvalStatus;
    @Column(name = "date_approved")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateApproved;
    @Column(name = "date_applied")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateApplied;
    @Size(max = 10)
    @Column(name = "expected_resumption_session")
    private String expectedResumptionSession;
    @Size(max = 10)
    @Column(name = "expected_resumption_semester")
    private String expectedResumptionSemester;
    @JoinColumn(name = "payment_id", referencedColumnName = "id")
    @ManyToOne
    private Payments paymentId;
    @JoinColumn(name = "approved_by", referencedColumnName = "id")
    @ManyToOne
    private Staff approvedBy;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;

    public Deferments() {
    }

    public Deferments(String id) {
        this.id = id;
    }

    public Deferments(String id, String levelAt) {
        this.id = id;
        this.levelAt = levelAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLevelAt() {
        return levelAt;
    }

    public void setLevelAt(String levelAt) {
        this.levelAt = levelAt;
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

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getDurationSemesters() {
        return durationSemesters;
    }

    public void setDurationSemesters(Integer durationSemesters) {
        this.durationSemesters = durationSemesters;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public Date getDateApproved() {
        return dateApproved;
    }

    public void setDateApproved(Date dateApproved) {
        this.dateApproved = dateApproved;
    }

    public Date getDateApplied() {
        return dateApplied;
    }

    public void setDateApplied(Date dateApplied) {
        this.dateApplied = dateApplied;
    }

    public String getExpectedResumptionSession() {
        return expectedResumptionSession;
    }

    public void setExpectedResumptionSession(String expectedResumptionSession) {
        this.expectedResumptionSession = expectedResumptionSession;
    }

    public String getExpectedResumptionSemester() {
        return expectedResumptionSemester;
    }

    public void setExpectedResumptionSemester(String expectedResumptionSemester) {
        this.expectedResumptionSemester = expectedResumptionSemester;
    }

    public Payments getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Payments paymentId) {
        this.paymentId = paymentId;
    }

    public Staff getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Staff approvedBy) {
        this.approvedBy = approvedBy;
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
        if (!(object instanceof Deferments)) {
            return false;
        }
        Deferments other = (Deferments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Deferments[ id=" + id + " ]";
    }
    
}
