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
@Table(name = "payments")
@NamedQueries({
    @NamedQuery(name = "Payments.findAll", query = "SELECT p FROM Payments p"),
    @NamedQuery(name = "Payments.findById", query = "SELECT p FROM Payments p WHERE p.id = :id"),
    @NamedQuery(name = "Payments.findByAmount", query = "SELECT p FROM Payments p WHERE p.amount = :amount"),
    @NamedQuery(name = "Payments.findByDatePaid", query = "SELECT p FROM Payments p WHERE p.datePaid = :datePaid"),
    @NamedQuery(name = "Payments.findByPayerRegistrationNo", query = "SELECT p FROM Payments p WHERE p.payerRegistrationNo = :payerRegistrationNo"),
    @NamedQuery(name = "Payments.findByPayerFullname", query = "SELECT p FROM Payments p WHERE p.payerFullname = :payerFullname"),
    @NamedQuery(name = "Payments.findByLevel", query = "SELECT p FROM Payments p WHERE p.level = :level"),
    @NamedQuery(name = "Payments.findBySessionPaid", query = "SELECT p FROM Payments p WHERE p.sessionPaid = :sessionPaid"),
    @NamedQuery(name = "Payments.findBySemesterPaid", query = "SELECT p FROM Payments p WHERE p.semesterPaid = :semesterPaid")})
public class Payments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Column(name = "amount")
    private double amount;
    @Column(name = "date_paid")
    @Temporal(TemporalType.TIMESTAMP)
    private Date datePaid;
    @Size(max = 50)
    @Column(name = "payer_registration_no")
    private String payerRegistrationNo;
    @Size(max = 200)
    @Column(name = "payer_fullname")
    private String payerFullname;
    @Size(max = 20)
    @Column(name = "level")
    private String level;
    @Size(max = 10)
    @Column(name = "session_paid")
    private String sessionPaid;
    @Size(max = 10)
    @Column(name = "semester_paid")
    private String semesterPaid;
    @OneToMany(mappedBy = "paymentId")
    private Collection<Hostelallocation> hostelallocationCollection;
    @OneToMany(mappedBy = "paymentId")
    private Collection<Transcriptapplication> transcriptapplicationCollection;
    @JoinColumn(name = "bank_id", referencedColumnName = "id")
    @ManyToOne
    private Banks bankId;
    @JoinColumn(name = "course_id", referencedColumnName = "id")
    @ManyToOne
    private Courses courseId;
    @JoinColumn(name = "fees_group_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Feesgroup feesGroupId;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne
    private Schools schoolId;
    @Size(max = 50)
    @Column(name = "payer_id")
    private String payerId;

    @OneToMany(mappedBy = "paymentId")
    private Collection<Deferments> defermentsCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "payments")
    private Paymenttrash paymenttrash;

    public Payments() {
    }

    public Payments(String id, double amount, Date datePaid, String payerRegistrationNo, String payerFullname, String level, String sessionPaid,
            String semesterPaid, Collection<Hostelallocation> hostelallocationCollection,
            Collection<Transcriptapplication> transcriptapplicationCollection, Banks bankId, Courses courseId, Feesgroup feesGroupId,
            Programmes programmeId, Schools schoolId, String payerId, Collection<Deferments> defermentsCollection, Paymenttrash paymenttrash) {
        this.id = id;
        this.amount = amount;
        this.datePaid = datePaid;
        this.payerRegistrationNo = payerRegistrationNo;
        this.payerFullname = payerFullname;
        this.level = level;
        this.sessionPaid = sessionPaid;
        this.semesterPaid = semesterPaid;
        this.hostelallocationCollection = hostelallocationCollection;
        this.transcriptapplicationCollection = transcriptapplicationCollection;
        this.bankId = bankId;
        this.courseId = courseId;
        this.feesGroupId = feesGroupId;
        this.programmeId = programmeId;
        this.schoolId = schoolId;
        this.payerId = payerId;
        this.defermentsCollection = defermentsCollection;
        this.paymenttrash = paymenttrash;
    }


    public Payments(String id) {
        this.id = id;
    }

    public Payments(String id, double amount) {
        this.id = id;
        this.amount = amount;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDatePaid() {
        return datePaid;
    }

    public void setDatePaid(Date datePaid) {
        this.datePaid = datePaid;
    }

    public String getPayerRegistrationNo() {
        return payerRegistrationNo;
    }

    public void setPayerRegistrationNo(String payerRegistrationNo) {
        this.payerRegistrationNo = payerRegistrationNo;
    }

    public String getPayerFullname() {
        return payerFullname;
    }

    public void setPayerFullname(String payerFullname) {
        this.payerFullname = payerFullname;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getSessionPaid() {
        return sessionPaid;
    }

    public void setSessionPaid(String sessionPaid) {
        this.sessionPaid = sessionPaid;
    }

    public String getSemesterPaid() {
        return semesterPaid;
    }

    public void setSemesterPaid(String semesterPaid) {
        this.semesterPaid = semesterPaid;
    }

    public Collection<Hostelallocation> getHostelallocationCollection() {
        return hostelallocationCollection;
    }

    public void setHostelallocationCollection(Collection<Hostelallocation> hostelallocationCollection) {
        this.hostelallocationCollection = hostelallocationCollection;
    }

    public Collection<Transcriptapplication> getTranscriptapplicationCollection() {
        return transcriptapplicationCollection;
    }

    public void setTranscriptapplicationCollection(Collection<Transcriptapplication> transcriptapplicationCollection) {
        this.transcriptapplicationCollection = transcriptapplicationCollection;
    }

    public Banks getBankId() {
        return bankId;
    }

    public void setBankId(Banks bankId) {
        this.bankId = bankId;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Feesgroup getFeesGroupId() {
        return feesGroupId;
    }

    public void setFeesGroupId(Feesgroup feesGroupId) {
        this.feesGroupId = feesGroupId;
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

    public String getPayerId() {
        return payerId;
    }

    public void setPayerId(String payerId) {
        this.payerId = payerId;
    }

    public Collection<Deferments> getDefermentsCollection() {
        return defermentsCollection;
    }

    public void setDefermentsCollection(Collection<Deferments> defermentsCollection) {
        this.defermentsCollection = defermentsCollection;
    }

    public Paymenttrash getPaymenttrash() {
        return paymenttrash;
    }

    public void setPaymenttrash(Paymenttrash paymenttrash) {
        this.paymenttrash = paymenttrash;
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
        if (!(object instanceof Payments)) {
            return false;
        }
        Payments other = (Payments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Payments[ id=" + id + " ]";
    }

}
