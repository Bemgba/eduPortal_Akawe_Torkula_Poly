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
@Table(name = "paymentreference")
@NamedQueries({
    @NamedQuery(name = "Paymentreference.findAll", query = "SELECT p FROM Paymentreference p"),
    @NamedQuery(name = "Paymentreference.findById", query = "SELECT p FROM Paymentreference p WHERE p.id = :id"),
    @NamedQuery(name = "Paymentreference.findByAmount", query = "SELECT p FROM Paymentreference p WHERE p.amount = :amount"),
    @NamedQuery(name = "Paymentreference.findByPayerId", query = "SELECT p FROM Paymentreference p WHERE p.payerId = :payerId"),
    @NamedQuery(name = "Paymentreference.findByDateGenerated", query = "SELECT p FROM Paymentreference p WHERE p.dateGenerated = :dateGenerated"),
    @NamedQuery(name = "Paymentreference.findByPaidStatus", query = "SELECT p FROM Paymentreference p WHERE p.paidStatus = :paidStatus"),
    @NamedQuery(name = "Paymentreference.findByDatePaid", query = "SELECT p FROM Paymentreference p WHERE p.datePaid = :datePaid"),
    @NamedQuery(name = "Paymentreference.findBySession", query = "SELECT p FROM Paymentreference p WHERE p.session = :session"),
    @NamedQuery(name = "Paymentreference.findBySemester", query = "SELECT p FROM Paymentreference p WHERE p.semester = :semester"),
    @NamedQuery(name = "Paymentreference.findByPaymentRef", query = "SELECT p FROM Paymentreference p WHERE p.paymentRef = :paymentRef"),
    @NamedQuery(name = "Paymentreference.findByBankCode", query = "SELECT p FROM Paymentreference p WHERE p.bankCode = :bankCode"),
    @NamedQuery(name = "Paymentreference.findByBankName", query = "SELECT p FROM Paymentreference p WHERE p.bankName = :bankName"),
    @NamedQuery(name = "Paymentreference.findByChannelName", query = "SELECT p FROM Paymentreference p WHERE p.channelName = :channelName"),
    @NamedQuery(name = "Paymentreference.findByPayerName", query = "SELECT p FROM Paymentreference p WHERE p.payerName = :payerName"),
    @NamedQuery(name = "Paymentreference.findByPhoneNo", query = "SELECT p FROM Paymentreference p WHERE p.phoneNo = :phoneNo"),
    @NamedQuery(name = "Paymentreference.findByEmailAddress", query = "SELECT p FROM Paymentreference p WHERE p.emailAddress = :emailAddress"),
    @NamedQuery(name = "Paymentreference.findByResponseText", query = "SELECT p FROM Paymentreference p WHERE p.responseText = :responseText")})
public class Paymentreference implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Column(name = "amount")
    private double amount;
    @Size(max = 50)
    @Column(name = "payer_id")
    private String payerId;
    @Column(name = "date_generated")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateGenerated;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "paid_status")
    private String paidStatus;
    @Column(name = "date_paid")
    @Temporal(TemporalType.TIMESTAMP)
    private Date datePaid;
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
    @Size(max = 50)
    @Column(name = "payment_ref")
    private String paymentRef;
    @Size(max = 50)
    @Column(name = "bank_code")
    private String bankCode;
    @Size(max = 150)
    @Column(name = "bank_name")
    private String bankName;
    @Size(max = 100)
    @Column(name = "channel_name")
    private String channelName;
    @Size(max = 100)
    @Column(name = "payer_name")
    private String payerName;
    @Size(max = 13)
    @Column(name = "phone_no")
    private String phoneNo;
    @Size(max = 50)
    @Column(name = "email_address")
    private String emailAddress;
    @Size(max = 2147483647)
    @Column(name = "response_text")
    private String responseText;
    @Size(max = 50)
    @Column(name = "payer_registration_no")
    private String payerRegistrationIo;
    @Size(max = 50)
    @Column(name = "bank_id")
    private String bankId;
    @Size(max = 50)
    @Column(name = "course_id")
    private String courseId;
    @Size(max = 50)
    @Column(name = "level")
    private String level;
    
    @JoinColumn(name = "fees_group_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Feesgroup feesGroupId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schools schoolId;

    public Paymentreference() {
    }

    public Paymentreference(String id, double amount, String payerId, Date dateGenerated, String paidStatus, Date datePaid, String session, 
            String semester, String paymentRef, String bankCode, String bankName, String channelName, String payerName, String phoneNo, 
            String emailAddress, String responseText, Feesgroup feesGroupId, Schools schoolId) {
        this.id = id;
        this.amount = amount;
        this.payerId = payerId;
        this.dateGenerated = dateGenerated;
        this.paidStatus = paidStatus;
        this.datePaid = datePaid;
        this.session = session;
        this.semester = semester;
        this.paymentRef = paymentRef;
        this.bankCode = bankCode;
        this.bankName = bankName;
        this.channelName = channelName;
        this.payerName = payerName;
        this.phoneNo = phoneNo;
        this.emailAddress = emailAddress;
        this.responseText = responseText;
        this.feesGroupId = feesGroupId;
        this.schoolId = schoolId;
    }

    public Paymentreference(String id) {
        this.id = id;
    }

    public Paymentreference(String id, double amount, String paidStatus, String session, String semester) {
        this.id = id;
        this.amount = amount;
        this.paidStatus = paidStatus;
        this.session = session;
        this.semester = semester;
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

    public String getPayerId() {
        return payerId;
    }

    public void setPayerId(String payerId) {
        this.payerId = payerId;
    }

    public Date getDateGenerated() {
        return dateGenerated;
    }

    public void setDateGenerated(Date dateGenerated) {
        this.dateGenerated = dateGenerated;
    }

    public String getPaidStatus() {
        return paidStatus;
    }

    public void setPaidStatus(String paidStatus) {
        this.paidStatus = paidStatus;
    }

    public Date getDatePaid() {
        return datePaid;
    }

    public void setDatePaid(Date datePaid) {
        this.datePaid = datePaid;
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

    public String getPaymentRef() {
        return paymentRef;
    }

    public void setPaymentRef(String paymentRef) {
        this.paymentRef = paymentRef;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getChannelName() {
        return channelName;
    }

    public void setChannelName(String channelName) {
        this.channelName = channelName;
    }

    public String getPayerName() {
        return payerName;
    }

    public void setPayerName(String payerName) {
        this.payerName = payerName;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getResponseText() {
        return responseText;
    }

    public void setResponseText(String responseText) {
        this.responseText = responseText;
    }

    public Feesgroup getFeesGroupId() {
        return feesGroupId;
    }

    public void setFeesGroupId(Feesgroup feesGroupId) {
        this.feesGroupId = feesGroupId;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
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
        if (!(object instanceof Paymentreference)) {
            return false;
        }
        Paymentreference other = (Paymentreference) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Paymentreference[ id=" + id + " ]";
    }

    /**
     * @return the payerRegistrationIo
     */
    public String getPayerRegistrationIo() {
        return payerRegistrationIo;
    }

    /**
     * @param payerRegistrationIo the payerRegistrationIo to set
     */
    public void setPayerRegistrationIo(String payerRegistrationIo) {
        this.payerRegistrationIo = payerRegistrationIo;
    }

    /**
     * @return the bankId
     */
    public String getBankId() {
        return bankId;
    }

    /**
     * @param bankId the bankId to set
     */
    public void setBankId(String bankId) {
        this.bankId = bankId;
    }

    /**
     * @return the courseId
     */
    public String getCourseId() {
        return courseId;
    }

    /**
     * @param courseId the courseId to set
     */
    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    /**
     * @return the level
     */
    public String getLevel() {
        return level;
    }

    /**
     * @param level the level to set
     */
    public void setLevel(String level) {
        this.level = level;
    }
    
}
