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

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "utmesubjects")
@NamedQueries({
    @NamedQuery(name = "Utmesubjects.findAll", query = "SELECT u FROM Utmesubjects u"),
    @NamedQuery(name = "Utmesubjects.findById", query = "SELECT u FROM Utmesubjects u WHERE u.id = :id"),
    @NamedQuery(name = "Utmesubjects.findByName", query = "SELECT u FROM Utmesubjects u WHERE u.name = :name"),
    @NamedQuery(name = "Utmesubjects.findByAbbreviation", query = "SELECT u FROM Utmesubjects u WHERE u.abbreviation = :abbreviation"),
    @NamedQuery(name = "Utmesubjects.findByStatus", query = "SELECT u FROM Utmesubjects u WHERE u.status = :status")})
public class Utmesubjects implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "name")
    private String name;
    @Size(max = 50)
    @Column(name = "abbreviation")
    private String abbreviation;
    @Size(max = 50)
    @Column(name = "status")
    private String status;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "utmesubjects")
    private Collection<Admissiontemplateutme> admissiontemplateutmeCollection;

    public Utmesubjects() {
    }

    public Utmesubjects(String id) {
        this.id = id;
    }

    public Utmesubjects(String id, String name) {
        this.id = id;
        this.name = name;
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

    public String getAbbreviation() {
        return abbreviation;
    }

    public void setAbbreviation(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Collection<Admissiontemplateutme> getAdmissiontemplateutmeCollection() {
        return admissiontemplateutmeCollection;
    }

    public void setAdmissiontemplateutmeCollection(Collection<Admissiontemplateutme> admissiontemplateutmeCollection) {
        this.admissiontemplateutmeCollection = admissiontemplateutmeCollection;
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
        if (!(object instanceof Utmesubjects)) {
            return false;
        }
        Utmesubjects other = (Utmesubjects) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.bdic.benueexco.admissiontemplate.resources.Utmesubjects[ id=" + id + " ]";
    }
    
}
