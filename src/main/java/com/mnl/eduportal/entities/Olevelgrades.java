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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "olevelgrades")
@NamedQueries({
    @NamedQuery(name = "Olevelgrades.findAll", query = "SELECT o FROM Olevelgrades o"),
    @NamedQuery(name = "Olevelgrades.findById", query = "SELECT o FROM Olevelgrades o WHERE o.id = :id"),
    @NamedQuery(name = "Olevelgrades.findByScore", query = "SELECT o FROM Olevelgrades o WHERE o.score = :score")})
public class Olevelgrades implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 3)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Column(name = "score")
    private int score;
    @OneToMany(mappedBy = "grade")
    private Collection<Olevelresultsitems> olevelresultsitemsCollection;

    public Olevelgrades() {
    }

    public Olevelgrades(String id) {
        this.id = id;
    }

    public Olevelgrades(String id, int score) {
        this.id = id;
        this.score = score;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public Collection<Olevelresultsitems> getOlevelresultsitemsCollection() {
        return olevelresultsitemsCollection;
    }

    public void setOlevelresultsitemsCollection(Collection<Olevelresultsitems> olevelresultsitemsCollection) {
        this.olevelresultsitemsCollection = olevelresultsitemsCollection;
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
    if (!(object instanceof Olevelgrades)) {
            return false;
        }
        Olevelgrades other = (Olevelgrades) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

//@Override
//public String toString() {
//    return "com.mnl.eduportal.entities.Olevelsubjects[ id=" + id + " ]";
//}
@Override
public String toString() {
    return "com.mnl.eduportal.entities.Olevelgrades[ id=" + id + " ]";
}

    
}
