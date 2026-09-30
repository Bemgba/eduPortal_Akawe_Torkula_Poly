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
@Table(name = "sessionmanager")
@NamedQueries({
    @NamedQuery(name = "Sessionmanager.findAll", query = "SELECT s FROM Sessionmanager s"),
    @NamedQuery(name = "Sessionmanager.findById", query = "SELECT s FROM Sessionmanager s WHERE s.id = :id"),
    @NamedQuery(name = "Sessionmanager.findByName", query = "SELECT s FROM Sessionmanager s WHERE s.name = :name"),
    @NamedQuery(name = "Sessionmanager.findByStartDate", query = "SELECT s FROM Sessionmanager s WHERE s.startDate = :startDate"),
    @NamedQuery(name = "Sessionmanager.findByEndDate", query = "SELECT s FROM Sessionmanager s WHERE s.endDate = :endDate"),
    @NamedQuery(name = "Sessionmanager.findBySemester", query = "SELECT s FROM Sessionmanager s WHERE s.semester = :semester"),
    @NamedQuery(name = "Sessionmanager.findByOperation", query = "SELECT s FROM Sessionmanager s WHERE s.operation = :operation"),
    @NamedQuery(name = "Sessionmanager.findByStatus", query = "SELECT s FROM Sessionmanager s WHERE s.status = :status"),
    @NamedQuery(name = "Sessionmanager.findByStatusComment", query = "SELECT s FROM Sessionmanager s WHERE s.statusComment = :statusComment")})
public class Sessionmanager implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "name")
    private String name;
    @Column(name = "start_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date startDate;
    @Column(name = "end_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date endDate;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "semester")
    private String semester;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "operation")
    private String operation;
    @Size(max = 20)
    @Column(name = "status")
    private String status;
    @Size(max = 200)
    @Column(name = "status_comment")
    private String statusComment;
    @JoinColumn(name = "programme_id", referencedColumnName = "id")
    @ManyToOne(optional = true)
    private Programmes programmeId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Schools schoolId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "sessionManagerId")
    private Collection<Semestercoursesallocation> semestercoursesallocationCollection;

    public Sessionmanager() {
    }

    public Sessionmanager(String id) {
        this.id = id;
    }

    public Sessionmanager(String id, String name, String semester, String operation) {
        this.id = id;
        this.name = name;
        this.semester = semester;
        this.operation = operation;
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

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusComment() {
        return statusComment;
    }

    public void setStatusComment(String statusComment) {
        this.statusComment = statusComment;
    }

    public Programmes getProgrammeId() {
        return programmeId;
    }

    public void setProgrammeId(Programmes programmeId) {
        this.programmeId = programmeId;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
    }

    public Collection<Semestercoursesallocation> getSemestercoursesallocationCollection() {
        return semestercoursesallocationCollection;
    }

    public void setSemestercoursesallocationCollection(Collection<Semestercoursesallocation> semestercoursesallocationCollection) {
        this.semestercoursesallocationCollection = semestercoursesallocationCollection;
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
        if (!(object instanceof Sessionmanager)) {
            return false;
        }
        Sessionmanager other = (Sessionmanager) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Sessionmanager[ id=" + id + " ]";
    }
    
}
