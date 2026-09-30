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
@Table(name = "pages")
@NamedQueries({
    @NamedQuery(name = "Pages.findAll", query = "SELECT p FROM Pages p"),
    @NamedQuery(name = "Pages.findById", query = "SELECT p FROM Pages p WHERE p.id = :id"),
    @NamedQuery(name = "Pages.findByName", query = "SELECT p FROM Pages p WHERE p.name = :name"),
    @NamedQuery(name = "Pages.findByDescription", query = "SELECT p FROM Pages p WHERE p.description = :description"),
    @NamedQuery(name = "Pages.findByStatus", query = "SELECT p FROM Pages p WHERE p.status = :status"),
    @NamedQuery(name = "Pages.findByComment", query = "SELECT p FROM Pages p WHERE p.comment = :comment"),
    @NamedQuery(name = "Pages.findByRoles", query = "SELECT p FROM Pages p WHERE p.roles = :roles"),
    @NamedQuery(name = "Pages.findByAlias", query = "SELECT p FROM Pages p WHERE p.alias = :alias")})
public class Pages implements Serializable {

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
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @Size(max = 50)
    @Column(name = "status")
    private String status;
    @Size(max = 200)
    @Column(name = "comment")
    private String comment;
    @Size(max = 200)
    @Column(name = "roles")
    private String roles;
    @Size(max = 50)
    @Column(name = "alias")
    private String alias;
    @JoinColumn(name = "manu_id", referencedColumnName = "id")
    @ManyToOne
    private Menus manuId;
    @OneToMany(mappedBy = "defaulthome")
    private Collection<Roles> rolesCollection;

    public Pages() {
    }

    public Pages(String id) {
        this.id = id;
    }

    public Pages(String id, String name) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getRoles() {
        return roles;
    }

    public void setRoles(String roles) {
        this.roles = roles;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public Menus getManuId() {
        return manuId;
    }

    public void setManuId(Menus manuId) {
        this.manuId = manuId;
    }

    public Collection<Roles> getRolesCollection() {
        return rolesCollection;
    }

    public void setRolesCollection(Collection<Roles> rolesCollection) {
        this.rolesCollection = rolesCollection;
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
        if (!(object instanceof Pages)) {
            return false;
        }
        Pages other = (Pages) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Pages[ id=" + id + " ]";
    }
    
}
