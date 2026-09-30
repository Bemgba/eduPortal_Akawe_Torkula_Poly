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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "studentssocialmedia")
@NamedQueries({
    @NamedQuery(name = "Studentssocialmedia.findAll", query = "SELECT s FROM Studentssocialmedia s"),
    @NamedQuery(name = "Studentssocialmedia.findById", query = "SELECT s FROM Studentssocialmedia s WHERE s.id = :id"),
    @NamedQuery(name = "Studentssocialmedia.findByFacebook", query = "SELECT s FROM Studentssocialmedia s WHERE s.facebook = :facebook"),
    @NamedQuery(name = "Studentssocialmedia.findByTwitter", query = "SELECT s FROM Studentssocialmedia s WHERE s.twitter = :twitter"),
    @NamedQuery(name = "Studentssocialmedia.findByLinkln", query = "SELECT s FROM Studentssocialmedia s WHERE s.linkln = :linkln")})
public class Studentssocialmedia implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 100)
    @Column(name = "facebook")
    private String facebook;
    @Size(max = 100)
    @Column(name = "twitter")
    private String twitter;
    @Size(max = 100)
    @Column(name = "linkln")
    private String linkln;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Students students;

    public Studentssocialmedia() {
    }

    public Studentssocialmedia(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFacebook() {
        return facebook;
    }

    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }

    public String getTwitter() {
        return twitter;
    }

    public void setTwitter(String twitter) {
        this.twitter = twitter;
    }

    public String getLinkln() {
        return linkln;
    }

    public void setLinkln(String linkln) {
        this.linkln = linkln;
    }

    public Students getStudents() {
        return students;
    }

    public void setStudents(Students students) {
        this.students = students;
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
        if (!(object instanceof Studentssocialmedia)) {
            return false;
        }
        Studentssocialmedia other = (Studentssocialmedia) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Studentssocialmedia[ id=" + id + " ]";
    }
    
}
