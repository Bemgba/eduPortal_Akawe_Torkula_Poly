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
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author nguuma-ayua
 */
@Entity
@Table(name = "summerschoolapplication")
@NamedQueries({
    @NamedQuery(name = "Summerschoolapplication.findAll", query = "SELECT s FROM Summerschoolapplication s"),
    @NamedQuery(name = "Summerschoolapplication.findById", query = "SELECT s FROM Summerschoolapplication s WHERE s.id = :id"),
    @NamedQuery(name = "Summerschoolapplication.findByDateApplied", query = "SELECT s FROM Summerschoolapplication s WHERE s.dateApplied = :dateApplied"),
    @NamedQuery(name = "Summerschoolapplication.findByApplicationStatus", query = "SELECT s FROM Summerschoolapplication s WHERE s.applicationStatus = :applicationStatus"),
    @NamedQuery(name = "Summerschoolapplication.findByRegistrationStatus", query = "SELECT s FROM Summerschoolapplication s WHERE s.registrationStatus = :registrationStatus"),
    @NamedQuery(name = "Summerschoolapplication.findByDateRegistered", query = "SELECT s FROM Summerschoolapplication s WHERE s.dateRegistered = :dateRegistered")})
public class Summerschoolapplication implements Serializable {

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
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "application_status")
    private String applicationStatus;
    @Size(max = 20)
    @Column(name = "registration_status")
    private String registrationStatus;
    @Column(name = "date_registered")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateRegistered;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "applicationId")
    private List<Summerschoolregistration> summerschoolregistrationList;
    @JoinColumn(name = "students_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Students studentsId;
    @JoinColumn(name = "summer_school_status_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Summerschoolstatus summerSchoolStatusId;

    public Summerschoolapplication() {
    }

    public Summerschoolapplication(String id) {
        this.id = id;
    }

    public Summerschoolapplication(String id, String applicationStatus) {
        this.id = id;
        this.applicationStatus = applicationStatus;
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

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
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

    public List<Summerschoolregistration> getSummerschoolregistrationList() {
        return summerschoolregistrationList;
    }

    public void setSummerschoolregistrationList(List<Summerschoolregistration> summerschoolregistrationList) {
        this.summerschoolregistrationList = summerschoolregistrationList;
    }

    public Students getStudentsId() {
        return studentsId;
    }

    public void setStudentsId(Students studentsId) {
        this.studentsId = studentsId;
    }

    public Summerschoolstatus getSummerSchoolStatusId() {
        return summerSchoolStatusId;
    }

    public void setSummerSchoolStatusId(Summerschoolstatus summerSchoolStatusId) {
        this.summerSchoolStatusId = summerSchoolStatusId;
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
        if (!(object instanceof Summerschoolapplication)) {
            return false;
        }
        Summerschoolapplication other = (Summerschoolapplication) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.postgresentity.entities.Summerschoolapplication[ id=" + id + " ]";
    }
    
}
