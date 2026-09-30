/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "salaryscale")
@NamedQueries({
    @NamedQuery(name = "Salaryscale.findAll", query = "SELECT s FROM Salaryscale s"),
    @NamedQuery(name = "Salaryscale.findById", query = "SELECT s FROM Salaryscale s WHERE s.id = :id"),
    @NamedQuery(name = "Salaryscale.findByName", query = "SELECT s FROM Salaryscale s WHERE s.name = :name"),
    @NamedQuery(name = "Salaryscale.findByDescription", query = "SELECT s FROM Salaryscale s WHERE s.description = :description"),
    @NamedQuery(name = "Salaryscale.findByDateAdded", query = "SELECT s FROM Salaryscale s WHERE s.dateAdded = :dateAdded")})
public class Salaryscale implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "name")
    private String name;
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @OneToMany(mappedBy = "salaryScaleId")
    private Collection<Gradelevelsteps> gradelevelstepsCollection;

    public Salaryscale() {
    }

    public Salaryscale(String id) {
        this.id = id;
    }

    public Salaryscale(String id, String name) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public Collection<Gradelevelsteps> getGradelevelstepsCollection() {
        return gradelevelstepsCollection;
    }

    public void setGradelevelstepsCollection(Collection<Gradelevelsteps> gradelevelstepsCollection) {
        this.gradelevelstepsCollection = gradelevelstepsCollection;
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
        if (!(object instanceof Salaryscale)) {
            return false;
        }
        Salaryscale other = (Salaryscale) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Salaryscale[ id=" + id + " ]";
    }
    
}
