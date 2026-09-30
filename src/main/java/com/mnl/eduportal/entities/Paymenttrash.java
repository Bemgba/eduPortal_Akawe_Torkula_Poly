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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
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
@Table(name = "paymenttrash")
@NamedQueries({
    @NamedQuery(name = "Paymenttrash.findAll", query = "SELECT p FROM Paymenttrash p"),
    @NamedQuery(name = "Paymenttrash.findById", query = "SELECT p FROM Paymenttrash p WHERE p.id = :id"),
    @NamedQuery(name = "Paymenttrash.findByDateTrashed", query = "SELECT p FROM Paymenttrash p WHERE p.dateTrashed = :dateTrashed"),
    @NamedQuery(name = "Paymenttrash.findByTrashedBy", query = "SELECT p FROM Paymenttrash p WHERE p.trashedBy = :trashedBy"),
    @NamedQuery(name = "Paymenttrash.findByComment", query = "SELECT p FROM Paymenttrash p WHERE p.comment = :comment")})
public class Paymenttrash implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Column(name = "date_trashed")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateTrashed;
    @Size(max = 50)
    @Column(name = "trashed_by")
    private String trashedBy;
    @Size(max = 200)
    @Column(name = "comment")
    private String comment;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Payments payments;

    public Paymenttrash() {
    }

    public Paymenttrash(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDateTrashed() {
        return dateTrashed;
    }

    public void setDateTrashed(Date dateTrashed) {
        this.dateTrashed = dateTrashed;
    }

    public String getTrashedBy() {
        return trashedBy;
    }

    public void setTrashedBy(String trashedBy) {
        this.trashedBy = trashedBy;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Payments getPayments() {
        return payments;
    }

    public void setPayments(Payments payments) {
        this.payments = payments;
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
        if (!(object instanceof Paymenttrash)) {
            return false;
        }
        Paymenttrash other = (Paymenttrash) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Paymenttrash[ id=" + id + " ]";
    }
    
}
