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
@Table(name = "remotelogin")
@NamedQueries({
    @NamedQuery(name = "Remotelogin.findAll", query = "SELECT r FROM Remotelogin r"),
    @NamedQuery(name = "Remotelogin.findById", query = "SELECT r FROM Remotelogin r WHERE r.id = :id"),
    @NamedQuery(name = "Remotelogin.findByRemoteip", query = "SELECT r FROM Remotelogin r WHERE r.remoteip = :remoteip"),
    @NamedQuery(name = "Remotelogin.findByDateAccessed", query = "SELECT r FROM Remotelogin r WHERE r.dateAccessed = :dateAccessed"),
    @NamedQuery(name = "Remotelogin.findByRemarks", query = "SELECT r FROM Remotelogin r WHERE r.remarks = :remarks"),
    @NamedQuery(name = "Remotelogin.findByRemoteContext", query = "SELECT r FROM Remotelogin r WHERE r.remoteContext = :remoteContext"),
    @NamedQuery(name = "Remotelogin.findByRemoteMethod", query = "SELECT r FROM Remotelogin r WHERE r.remoteMethod = :remoteMethod"),
    @NamedQuery(name = "Remotelogin.findByPathInfo", query = "SELECT r FROM Remotelogin r WHERE r.pathInfo = :pathInfo"),
    @NamedQuery(name = "Remotelogin.findByRemoteProtocol", query = "SELECT r FROM Remotelogin r WHERE r.remoteProtocol = :remoteProtocol"),
    @NamedQuery(name = "Remotelogin.findByQueryString", query = "SELECT r FROM Remotelogin r WHERE r.queryString = :queryString"),
    @NamedQuery(name = "Remotelogin.findByRemoteHost", query = "SELECT r FROM Remotelogin r WHERE r.remoteHost = :remoteHost"),
    @NamedQuery(name = "Remotelogin.findByRemoteUser", query = "SELECT r FROM Remotelogin r WHERE r.remoteUser = :remoteUser"),
    @NamedQuery(name = "Remotelogin.findByMessageSent", query = "SELECT r FROM Remotelogin r WHERE r.messageSent = :messageSent")})
public class Remotelogin implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 50)
    @Column(name = "remoteip")
    private String remoteip;
    @Column(name = "date_accessed")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAccessed;
    @Size(max = 200)
    @Column(name = "remarks")
    private String remarks;
    @Size(max = 200)
    @Column(name = "remote_context")
    private String remoteContext;
    @Size(max = 200)
    @Column(name = "remote_method")
    private String remoteMethod;
    @Size(max = 200)
    @Column(name = "path_info")
    private String pathInfo;
    @Size(max = 200)
    @Column(name = "remote_protocol")
    private String remoteProtocol;
    @Size(max = 200)
    @Column(name = "query_string")
    private String queryString;
    @Size(max = 200)
    @Column(name = "remote_host")
    private String remoteHost;
    @Size(max = 200)
    @Column(name = "remote_user")
    private String remoteUser;
    @Size(max = 2147483647)
    @Column(name = "message_sent")
    private String messageSent;

    public Remotelogin() {
    }

    public Remotelogin(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRemoteip() {
        return remoteip;
    }

    public void setRemoteip(String remoteip) {
        this.remoteip = remoteip;
    }

    public Date getDateAccessed() {
        return dateAccessed;
    }

    public void setDateAccessed(Date dateAccessed) {
        this.dateAccessed = dateAccessed;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getRemoteContext() {
        return remoteContext;
    }

    public void setRemoteContext(String remoteContext) {
        this.remoteContext = remoteContext;
    }

    public String getRemoteMethod() {
        return remoteMethod;
    }

    public void setRemoteMethod(String remoteMethod) {
        this.remoteMethod = remoteMethod;
    }

    public String getPathInfo() {
        return pathInfo;
    }

    public void setPathInfo(String pathInfo) {
        this.pathInfo = pathInfo;
    }

    public String getRemoteProtocol() {
        return remoteProtocol;
    }

    public void setRemoteProtocol(String remoteProtocol) {
        this.remoteProtocol = remoteProtocol;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public String getRemoteHost() {
        return remoteHost;
    }

    public void setRemoteHost(String remoteHost) {
        this.remoteHost = remoteHost;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    public String getMessageSent() {
        return messageSent;
    }

    public void setMessageSent(String messageSent) {
        this.messageSent = messageSent;
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
        if (!(object instanceof Remotelogin)) {
            return false;
        }
        Remotelogin other = (Remotelogin) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Remotelogin[ id=" + id + " ]";
    }
    
}
