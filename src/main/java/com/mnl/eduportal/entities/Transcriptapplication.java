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
@Table(name = "transcriptapplication")
@NamedQueries({
    @NamedQuery(name = "Transcriptapplication.findAll", query = "SELECT t FROM Transcriptapplication t"),
    @NamedQuery(name = "Transcriptapplication.findById", query = "SELECT t FROM Transcriptapplication t WHERE t.id = :id"),
    @NamedQuery(name = "Transcriptapplication.findByDateApplied", query = "SELECT t FROM Transcriptapplication t WHERE t.dateApplied = :dateApplied"),
    @NamedQuery(name = "Transcriptapplication.findByDateProcessed", query = "SELECT t FROM Transcriptapplication t WHERE t.dateProcessed = :dateProcessed"),
    @NamedQuery(name = "Transcriptapplication.findByAttachmentId", query = "SELECT t FROM Transcriptapplication t WHERE t.attachmentId = :attachmentId"),
    @NamedQuery(name = "Transcriptapplication.findByRequestingInstitution", query = "SELECT t FROM Transcriptapplication t WHERE t.requestingInstitution = :requestingInstitution"),
    @NamedQuery(name = "Transcriptapplication.findByAddress", query = "SELECT t FROM Transcriptapplication t WHERE t.address = :address"),
    @NamedQuery(name = "Transcriptapplication.findByDeliveryEmail", query = "SELECT t FROM Transcriptapplication t WHERE t.deliveryEmail = :deliveryEmail")})
public class Transcriptapplication implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Column(name = "date_applied")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateApplied;
    @Column(name = "date_processed")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateProcessed;
    @Size(max = 50)
    @Column(name = "attachment_id")
    private String attachmentId;
    @Size(max = 200)
    @Column(name = "requesting_institution")
    private String requestingInstitution;
    @Size(max = 200)
    @Column(name = "address")
    private String address;
    @Size(max = 100)
    @Column(name = "delivery_email")
    private String deliveryEmail;
    @JoinColumn(name = "country_id", referencedColumnName = "id")
    @ManyToOne
    private Countries countryId;
    @JoinColumn(name = "payment_id", referencedColumnName = "id")
    @ManyToOne
    private Payments paymentId;
    @JoinColumn(name = "processed_by", referencedColumnName = "id")
    @ManyToOne
    private Staff processedBy;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentId;

    public Transcriptapplication() {
    }

    public Transcriptapplication(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDateApplied() {
        return dateApplied;
    }

    public void setDateApplied(Date dateApplied) {
        this.dateApplied = dateApplied;
    }

    public Date getDateProcessed() {
        return dateProcessed;
    }

    public void setDateProcessed(Date dateProcessed) {
        this.dateProcessed = dateProcessed;
    }

    public String getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(String attachmentId) {
        this.attachmentId = attachmentId;
    }

    public String getRequestingInstitution() {
        return requestingInstitution;
    }

    public void setRequestingInstitution(String requestingInstitution) {
        this.requestingInstitution = requestingInstitution;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDeliveryEmail() {
        return deliveryEmail;
    }

    public void setDeliveryEmail(String deliveryEmail) {
        this.deliveryEmail = deliveryEmail;
    }

    public Countries getCountryId() {
        return countryId;
    }

    public void setCountryId(Countries countryId) {
        this.countryId = countryId;
    }

    public Payments getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Payments paymentId) {
        this.paymentId = paymentId;
    }

    public Staff getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Staff processedBy) {
        this.processedBy = processedBy;
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
        if (!(object instanceof Transcriptapplication)) {
            return false;
        }
        Transcriptapplication other = (Transcriptapplication) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Transcriptapplication[ id=" + id + " ]";
    }
    
}
