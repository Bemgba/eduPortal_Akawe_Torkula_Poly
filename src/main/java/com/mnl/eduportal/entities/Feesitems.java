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
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "feesitems")
@NamedQueries({
    @NamedQuery(name = "Feesitems.findAll", query = "SELECT f FROM Feesitems f"),
    @NamedQuery(name = "Feesitems.findById", query = "SELECT f FROM Feesitems f WHERE f.id = :id"),
    @NamedQuery(name = "Feesitems.findByName", query = "SELECT f FROM Feesitems f WHERE f.name = :name"),
    @NamedQuery(name = "Feesitems.findByDetails", query = "SELECT f FROM Feesitems f WHERE f.details = :details")})
public class Feesitems implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "name")
    private String name;
    @Size(max = 200)
    @Column(name = "details")
    private String details;

    public Feesitems() {
    }

    public Feesitems(Integer id) {
        this.id = id;
    }

    public Feesitems(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
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
        if (!(object instanceof Feesitems)) {
            return false;
        }
        Feesitems other = (Feesitems) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Feesitems[ id=" + id + " ]";
    }
    
}
