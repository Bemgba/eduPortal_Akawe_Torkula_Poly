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
@Table(name = "uploadeddocuments")
@NamedQueries({
    @NamedQuery(name = "Uploadeddocuments.findAll", query = "SELECT u FROM Uploadeddocuments u"),
    @NamedQuery(name = "Uploadeddocuments.findById", query = "SELECT u FROM Uploadeddocuments u WHERE u.id = :id"),
    @NamedQuery(name = "Uploadeddocuments.findByName", query = "SELECT u FROM Uploadeddocuments u WHERE u.name = :name"),
    @NamedQuery(name = "Uploadeddocuments.findByUrl", query = "SELECT u FROM Uploadeddocuments u WHERE u.url = :url"),
    @NamedQuery(name = "Uploadeddocuments.findByGroupId", query = "SELECT u FROM Uploadeddocuments u WHERE u.groupId = :groupId"),
    @NamedQuery(name = "Uploadeddocuments.findByDateAdded", query = "SELECT u FROM Uploadeddocuments u WHERE u.dateAdded = :dateAdded"),
    @NamedQuery(name = "Uploadeddocuments.findByUploadedBy", query = "SELECT u FROM Uploadeddocuments u WHERE u.uploadedBy = :uploadedBy")})
public class Uploadeddocuments implements Serializable {

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
    @Size(max = 100)
    @Column(name = "url")
    private String url;
    @Size(max = 50)
    @Column(name = "group_id")
    private String groupId;
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 50)
    @Column(name = "uploaded_by")
    private String uploadedBy;

    public Uploadeddocuments() {
    }

    public Uploadeddocuments(String id) {
        this.id = id;
    }

    public Uploadeddocuments(String id, String name) {
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(String uploadedBy) {
        this.uploadedBy = uploadedBy;
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
        if (!(object instanceof Uploadeddocuments)) {
            return false;
        }
        Uploadeddocuments other = (Uploadeddocuments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Uploadeddocuments[ id=" + id + " ]";
    }
    
}
