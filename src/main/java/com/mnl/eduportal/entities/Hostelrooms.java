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
@Table(name = "hostelrooms")
@NamedQueries({
    @NamedQuery(name = "Hostelrooms.findAll", query = "SELECT h FROM Hostelrooms h"),
    @NamedQuery(name = "Hostelrooms.findById", query = "SELECT h FROM Hostelrooms h WHERE h.id = :id"),
    @NamedQuery(name = "Hostelrooms.findByRoomNo", query = "SELECT h FROM Hostelrooms h WHERE h.roomNo = :roomNo"),
    @NamedQuery(name = "Hostelrooms.findByMaxCapacity", query = "SELECT h FROM Hostelrooms h WHERE h.maxCapacity = :maxCapacity"),
    @NamedQuery(name = "Hostelrooms.findByOrderValue", query = "SELECT h FROM Hostelrooms h WHERE h.orderValue = :orderValue"),
    @NamedQuery(name = "Hostelrooms.findByRoomStatus", query = "SELECT h FROM Hostelrooms h WHERE h.roomStatus = :roomStatus")})
public class Hostelrooms implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 10)
    @Column(name = "room_no")
    private String roomNo;
    @Column(name = "max_capacity")
    private Integer maxCapacity;
    @Column(name = "order_value")
    private Integer orderValue;
    @Size(max = 50)
    @Column(name = "room_status")
    private String roomStatus;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "hostelRoomId")
    private Collection<Hostelallocation> hostelallocationCollection;
    @JoinColumn(name = "hostel_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Hostels hostelId;

    public Hostelrooms() {
    }

    public Hostelrooms(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public Integer getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(Integer maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public Integer getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(Integer orderValue) {
        this.orderValue = orderValue;
    }

    public String getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(String roomStatus) {
        this.roomStatus = roomStatus;
    }

    public Collection<Hostelallocation> getHostelallocationCollection() {
        return hostelallocationCollection;
    }

    public void setHostelallocationCollection(Collection<Hostelallocation> hostelallocationCollection) {
        this.hostelallocationCollection = hostelallocationCollection;
    }

    public Hostels getHostelId() {
        return hostelId;
    }

    public void setHostelId(Hostels hostelId) {
        this.hostelId = hostelId;
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
        if (!(object instanceof Hostelrooms)) {
            return false;
        }
        Hostelrooms other = (Hostelrooms) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Hostelrooms[ id=" + id + " ]";
    }
    
}
