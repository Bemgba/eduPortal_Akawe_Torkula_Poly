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
@Table(name = "olevelsubjects")
@NamedQueries({
    @NamedQuery(name = "Olevelsubjects.findAll", query = "SELECT o FROM Olevelsubjects o"),
    @NamedQuery(name = "Olevelsubjects.findById", query = "SELECT o FROM Olevelsubjects o WHERE o.id = :id"),
    @NamedQuery(name = "Olevelsubjects.findByName", query = "SELECT o FROM Olevelsubjects o WHERE o.name = :name"),
    @NamedQuery(name = "Olevelsubjects.findByStatus", query = "SELECT o FROM Olevelsubjects o WHERE o.status = :status")})
public class Olevelsubjects implements Serializable {

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
    @Size(max = 20)
    @Column(name = "status")
    private String status;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "olevelSubject")
    private Collection<Admissiontemplateolevel> admissiontemplateolevelCollection;

    public Olevelsubjects() {
    }

    public Olevelsubjects(String id) {
        this.id = id;
    }

    public Olevelsubjects(String id, String name) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    public Collection<Admissiontemplateolevel> getAdmissiontemplateolevelCollection() {
        return admissiontemplateolevelCollection;
    }

    public void setAdmissiontemplateolevelCollection(Collection<Admissiontemplateolevel> admissiontemplateolevelCollection) {
        this.admissiontemplateolevelCollection = admissiontemplateolevelCollection;
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
        if (!(object instanceof Olevelsubjects)) {
            return false;
        }
        Olevelsubjects other = (Olevelsubjects) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Olevelsubjects[ id=" + id + " ]";
    }

}
