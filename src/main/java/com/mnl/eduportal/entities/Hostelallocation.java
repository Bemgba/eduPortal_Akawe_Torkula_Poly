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
@Table(name = "hostelallocation")
@NamedQueries({
    @NamedQuery(name = "Hostelallocation.findAll", query = "SELECT h FROM Hostelallocation h"),
    @NamedQuery(name = "Hostelallocation.findById", query = "SELECT h FROM Hostelallocation h WHERE h.id = :id"),
    @NamedQuery(name = "Hostelallocation.findBySession", query = "SELECT h FROM Hostelallocation h WHERE h.session = :session"),
    @NamedQuery(name = "Hostelallocation.findByStatus", query = "SELECT h FROM Hostelallocation h WHERE h.status = :status"),
    @NamedQuery(name = "Hostelallocation.findByDateAdded", query = "SELECT h FROM Hostelallocation h WHERE h.dateAdded = :dateAdded")})
public class Hostelallocation implements Serializable {

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
    @Size(max = 20)
    @Column(name = "status")
    private String status;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @JoinColumn(name = "hostel_room_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Hostelrooms hostelRoomId;
    @JoinColumn(name = "payment_id", referencedColumnName = "id")
    @ManyToOne
    private Payments paymentId;
    @JoinColumn(name = "student_id", referencedColumnName = "id")
    @ManyToOne
    private Students studentId;

    public Hostelallocation() {
    }

    public Hostelallocation(String id) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Hostelrooms getHostelRoomId() {
        return hostelRoomId;
    }

    public void setHostelRoomId(Hostelrooms hostelRoomId) {
        this.hostelRoomId = hostelRoomId;
    }

    public Payments getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Payments paymentId) {
        this.paymentId = paymentId;
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
        if (!(object instanceof Hostelallocation)) {
            return false;
        }
        Hostelallocation other = (Hostelallocation) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Hostelallocation[ id=" + id + " ]";
    }
    
}
