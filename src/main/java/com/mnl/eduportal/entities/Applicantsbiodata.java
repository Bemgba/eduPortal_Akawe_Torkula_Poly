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
@Table(name = "applicantsbiodata")
@NamedQueries({
    @NamedQuery(name = "Applicantsbiodata.findAll", query = "SELECT a FROM Applicantsbiodata a"),
    @NamedQuery(name = "Applicantsbiodata.findById", query = "SELECT a FROM Applicantsbiodata a WHERE a.id = :id"),
    @NamedQuery(name = "Applicantsbiodata.findBySurname", query = "SELECT a FROM Applicantsbiodata a WHERE a.surname = :surname"),
    @NamedQuery(name = "Applicantsbiodata.findByOthernames", query = "SELECT a FROM Applicantsbiodata a WHERE a.othernames = :othernames"),
    @NamedQuery(name = "Applicantsbiodata.findByPhoneno", query = "SELECT a FROM Applicantsbiodata a WHERE a.phoneno = :phoneno"),
    @NamedQuery(name = "Applicantsbiodata.findByDateOfBirth", query = "SELECT a FROM Applicantsbiodata a WHERE a.dateOfBirth = :dateOfBirth"),
    @NamedQuery(name = "Applicantsbiodata.findByContactAddress", query = "SELECT a FROM Applicantsbiodata a WHERE a.contactAddress = :contactAddress"),
    @NamedQuery(name = "Applicantsbiodata.findByGender", query = "SELECT a FROM Applicantsbiodata a WHERE a.gender = :gender"),
    @NamedQuery(name = "Applicantsbiodata.findByHomeTown", query = "SELECT a FROM Applicantsbiodata a WHERE a.homeTown = :homeTown"),
    @NamedQuery(name = "Applicantsbiodata.findByDateAdded", query = "SELECT a FROM Applicantsbiodata a WHERE a.dateAdded = :dateAdded")})
public class Applicantsbiodata implements Serializable {

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
    @Column(name = "surname")
    private String surname;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "othernames")
    private String othernames;
    @Size(max = 13)
    @Column(name = "phoneno")
    private String phoneno;
    @Size(max = 13)
    @Column(name = "date_of_birth")
    private String dateOfBirth;
    @Size(max = 200)
    @Column(name = "contact_address")
    private String contactAddress;
    @Size(max = 10)
    @Column(name = "gender")
    private String gender;
    @Size(max = 200)
    @Column(name = "home_town")
    private String homeTown;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @JoinColumn(name = "nationality", referencedColumnName = "id")
    @ManyToOne
    private Countries nationality;
    @JoinColumn(name = "lga", referencedColumnName = "id")
    @ManyToOne
    private Lgas lga;
    @JoinColumn(name = "state", referencedColumnName = "id")
    @ManyToOne
    private States state;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Users users;

    public Applicantsbiodata() {
    }

    public Applicantsbiodata(String id) {
        this.id = id;
    }

    public Applicantsbiodata(String id, String surname, String othernames) {
        this.id = id;
        this.surname = surname;
        this.othernames = othernames;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getOthernames() {
        return othernames;
    }

    public void setOthernames(String othernames) {
        this.othernames = othernames;
    }

    public String getPhoneno() {
        return phoneno;
    }

    public void setPhoneno(String phoneno) {
        this.phoneno = phoneno;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getContactAddress() {
        return contactAddress;
    }

    public void setContactAddress(String contactAddress) {
        this.contactAddress = contactAddress;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getHomeTown() {
        return homeTown;
    }

    public void setHomeTown(String homeTown) {
        this.homeTown = homeTown;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Countries getNationality() {
        return nationality;
    }

    public void setNationality(Countries nationality) {
        this.nationality = nationality;
    }

    public Lgas getLga() {
        return lga;
    }

    public void setLga(Lgas lga) {
        this.lga = lga;
    }

    public States getState() {
        return state;
    }

    public void setState(States state) {
        this.state = state;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
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
        if (!(object instanceof Applicantsbiodata)) {
            return false;
        }
        Applicantsbiodata other = (Applicantsbiodata) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.chemicals.test.resources.Applicantsbiodata[ id=" + id + " ]";
    }
    
}
