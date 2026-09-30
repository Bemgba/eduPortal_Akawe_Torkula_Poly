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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "userprogrammes")
@NamedQueries({
    @NamedQuery(name = "Userprogrammes.findAll", query = "SELECT u FROM Userprogrammes u"),
    @NamedQuery(name = "Userprogrammes.findById", query = "SELECT u FROM Userprogrammes u WHERE u.id = :id"),
    @NamedQuery(name = "Userprogrammes.findByDateAdded", query = "SELECT u FROM Userprogrammes u WHERE u.dateAdded = :dateAdded")})
public class Userprogrammes implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 2147483647)
    @Column(name = "date_added")
    private String dateAdded;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne
    private Programmes programmeId;
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @ManyToOne
    private Users userId;

    public Userprogrammes() {
    }

    public Userprogrammes(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(String dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
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
        if (!(object instanceof Userprogrammes)) {
            return false;
        }
        Userprogrammes other = (Userprogrammes) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Userprogrammes[ id=" + id + " ]";
    }
    
}
