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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "hostels")
@NamedQueries({
    @NamedQuery(name = "Hostels.findAll", query = "SELECT h FROM Hostels h"),
    @NamedQuery(name = "Hostels.findById", query = "SELECT h FROM Hostels h WHERE h.id = :id"),
    @NamedQuery(name = "Hostels.findByName", query = "SELECT h FROM Hostels h WHERE h.name = :name"),
    @NamedQuery(name = "Hostels.findByGender", query = "SELECT h FROM Hostels h WHERE h.gender = :gender"),
    @NamedQuery(name = "Hostels.findByLocation", query = "SELECT h FROM Hostels h WHERE h.location = :location"),
    @NamedQuery(name = "Hostels.findByNote", query = "SELECT h FROM Hostels h WHERE h.note = :note"),
    @NamedQuery(name = "Hostels.findByFee", query = "SELECT h FROM Hostels h WHERE h.fee = :fee")})
public class Hostels implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "name")
    private String name;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 200)
    @Column(name = "location")
    private String location;
    @Size(max = 2147483647)
    @Column(name = "note")
    private String note;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "fee")
    private Double fee;
    @Size(max = 50)
    @Column(name = "status")
    private String status;
     @Size(max = 50)
    @Column(name = "application_status")
    private String applicationStatus;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "hostelId")
    private Collection<Hostelrooms> hostelroomsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "hostelId")
    private List<Hostelapplication> hostelapplicationList;

    public Hostels() {
    }

    public Hostels(String id) {
        this.id = id;
    }

    public Hostels(String id, String name, String gender) {
        this.id = id;
        this.name = name;
        this.gender = gender;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Double getFee() {
        return fee;
    }

    public void setFee(Double fee) {
        this.fee = fee;
    }

    public Collection<Hostelrooms> getHostelroomsCollection() {
        return hostelroomsCollection;
    }

    public void setHostelroomsCollection(Collection<Hostelrooms> hostelroomsCollection) {
        this.hostelroomsCollection = hostelroomsCollection;
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
        if (!(object instanceof Hostels)) {
            return false;
        }
        Hostels other = (Hostels) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Hostels[ id=" + id + " ]";
    }

    /**
     * @return the hostelapplicationList
     */
    public List<Hostelapplication> getHostelapplicationList() {
        return hostelapplicationList;
    }

    /**
     * @param hostelapplicationList the hostelapplicationList to set
     */
    public void setHostelapplicationList(List<Hostelapplication> hostelapplicationList) {
        this.hostelapplicationList = hostelapplicationList;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the applicationStatus
     */
    public String getApplicationStatus() {
        return applicationStatus;
    }

    /**
     * @param applicationStatus the applicationStatus to set
     */
    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }
    
}
