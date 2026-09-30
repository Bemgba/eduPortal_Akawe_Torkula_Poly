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
@Table(name = "userlogins")
@NamedQueries({
    @NamedQuery(name = "Userlogins.findAll", query = "SELECT u FROM Userlogins u"),
    @NamedQuery(name = "Userlogins.findById", query = "SELECT u FROM Userlogins u WHERE u.id = :id"),
    @NamedQuery(name = "Userlogins.findByDatelogin", query = "SELECT u FROM Userlogins u WHERE u.datelogin = :datelogin"),
    @NamedQuery(name = "Userlogins.findByIplogin", query = "SELECT u FROM Userlogins u WHERE u.iplogin = :iplogin"),
    @NamedQuery(name = "Userlogins.findByDevicelogin", query = "SELECT u FROM Userlogins u WHERE u.devicelogin = :devicelogin")})
public class Userlogins implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "id")
    private String id;
    @Column(name = "datelogin")
    @Temporal(TemporalType.TIMESTAMP)
    private Date datelogin;
    @Size(max = 50)
    @Column(name = "iplogin")
    private String iplogin;
    @Size(max = 200)
    @Column(name = "devicelogin")
    private String devicelogin;
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @ManyToOne
    private Users userId;

    public Userlogins() {
    }

    public Userlogins(String id, Date datelogin, String iplogin, String devicelogin, Users userId) {
        this.id = id;
        this.datelogin = datelogin;
        this.iplogin = iplogin;
        this.devicelogin = devicelogin;
        this.userId = userId;
    }

    public Userlogins(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDatelogin() {
        return datelogin;
    }

    public void setDatelogin(Date datelogin) {
        this.datelogin = datelogin;
    }

    public String getIplogin() {
        return iplogin;
    }

    public void setIplogin(String iplogin) {
        this.iplogin = iplogin;
    }

    public String getDevicelogin() {
        return devicelogin;
    }

    public void setDevicelogin(String devicelogin) {
        this.devicelogin = devicelogin;
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
        if (!(object instanceof Userlogins)) {
            return false;
        }
        Userlogins other = (Userlogins) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Userlogins[ id=" + id + " ]";
    }
    
}
