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
@Table(name = "feessetup")
@NamedQueries({
    @NamedQuery(name = "Feessetup.findAll", query = "SELECT f FROM Feessetup f"),
    @NamedQuery(name = "Feessetup.findById", query = "SELECT f FROM Feessetup f WHERE f.id = :id"),
    @NamedQuery(name = "Feessetup.findBySessionAdded", query = "SELECT f FROM Feessetup f WHERE f.sessionAdded = :sessionAdded"),
    @NamedQuery(name = "Feessetup.findBySemesterAdded", query = "SELECT f FROM Feessetup f WHERE f.semesterAdded = :semesterAdded"),
    @NamedQuery(name = "Feessetup.findBySchoolScope", query = "SELECT f FROM Feessetup f WHERE f.schoolScope = :schoolScope"),
    @NamedQuery(name = "Feessetup.findByProgrammeScope", query = "SELECT f FROM Feessetup f WHERE f.programmeScope = :programmeScope"),
    @NamedQuery(name = "Feessetup.findByFacultyScope", query = "SELECT f FROM Feessetup f WHERE f.facultyScope = :facultyScope"),
    @NamedQuery(name = "Feessetup.findByDepartmentScope", query = "SELECT f FROM Feessetup f WHERE f.departmentScope = :departmentScope"),
    @NamedQuery(name = "Feessetup.findByCourseScope", query = "SELECT f FROM Feessetup f WHERE f.courseScope = :courseScope"),
    @NamedQuery(name = "Feessetup.findByLevelScope", query = "SELECT f FROM Feessetup f WHERE f.levelScope = :levelScope"),
    @NamedQuery(name = "Feessetup.findByIndigeneStatusScope", query = "SELECT f FROM Feessetup f WHERE f.indigeneStatusScope = :indigeneStatusScope"),
    @NamedQuery(name = "Feessetup.findByOnCampusScope", query = "SELECT f FROM Feessetup f WHERE f.onCampusScope = :onCampusScope"),
    @NamedQuery(name = "Feessetup.findByEffectiveFrom", query = "SELECT f FROM Feessetup f WHERE f.effectiveFrom = :effectiveFrom"),
    @NamedQuery(name = "Feessetup.findByAmount", query = "SELECT f FROM Feessetup f WHERE f.amount = :amount"),
    @NamedQuery(name = "Feessetup.findByDateAdded", query = "SELECT f FROM Feessetup f WHERE f.dateAdded = :dateAdded"),
    @NamedQuery(name = "Feessetup.findByStudentId", query = "SELECT f FROM Feessetup f WHERE f.studentId = :studentId")})
public class Feessetup implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "session_added")
    private String sessionAdded;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "semester_added")
    private String semesterAdded;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "school_scope")
    private String schoolScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "programme_scope")
    private String programmeScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "faculty_scope")
    private String facultyScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "department_scope")
    private String departmentScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "course_scope")
    private String courseScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "level_scope")
    private String levelScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "indigene_status_scope")
    private String indigeneStatusScope;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "on_campus_scope")
    private String onCampusScope;
    @Basic(optional = false)
    @NotNull
    @Column(name = "effective_from")
    @Temporal(TemporalType.TIMESTAMP)
    private Date effectiveFrom;
    @Basic(optional = false)
    @NotNull
    @Column(name = "amount")
    private double amount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "date_added")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateAdded;
    @Size(max = 50)
    @Column(name = "student_id")
    private String studentId;
    @JoinColumn(name = "account_it", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Accounts accountIt;
    @JoinColumn(name = "fees_group_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Feesgroup feesGroupId;
    @JoinColumn(name = "added_by", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Users addedBy;
    @JoinColumn(name = "item_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Feesitems feesItemsId;

    public Feessetup() {
    }

    public Feessetup(String id) {
        this.id = id;
    }

    public Feessetup(String id, String sessionAdded, String semesterAdded, String schoolScope, String programmeScope, String facultyScope, String departmentScope, String courseScope, String levelScope, String indigeneStatusScope, String onCampusScope, Date effectiveFrom, double amount, Date dateAdded) {
        this.id = id;
        this.sessionAdded = sessionAdded;
        this.semesterAdded = semesterAdded;
        this.schoolScope = schoolScope;
        this.programmeScope = programmeScope;
        this.facultyScope = facultyScope;
        this.departmentScope = departmentScope;
        this.courseScope = courseScope;
        this.levelScope = levelScope;
        this.indigeneStatusScope = indigeneStatusScope;
        this.onCampusScope = onCampusScope;
        this.effectiveFrom = effectiveFrom;
        this.amount = amount;
        this.dateAdded = dateAdded;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSessionAdded() {
        return sessionAdded;
    }

    public void setSessionAdded(String sessionAdded) {
        this.sessionAdded = sessionAdded;
    }

    public String getSemesterAdded() {
        return semesterAdded;
    }

    public void setSemesterAdded(String semesterAdded) {
        this.semesterAdded = semesterAdded;
    }

    public String getSchoolScope() {
        return schoolScope;
    }

    public void setSchoolScope(String schoolScope) {
        this.schoolScope = schoolScope;
    }

    public String getProgrammeScope() {
        return programmeScope;
    }

    public void setProgrammeScope(String programmeScope) {
        this.programmeScope = programmeScope;
    }

    public String getFacultyScope() {
        return facultyScope;
    }

    public void setFacultyScope(String facultyScope) {
        this.facultyScope = facultyScope;
    }

    public String getDepartmentScope() {
        return departmentScope;
    }

    public void setDepartmentScope(String departmentScope) {
        this.departmentScope = departmentScope;
    }

    public String getCourseScope() {
        return courseScope;
    }

    public void setCourseScope(String courseScope) {
        this.courseScope = courseScope;
    }

    public String getLevelScope() {
        return levelScope;
    }

    public void setLevelScope(String levelScope) {
        this.levelScope = levelScope;
    }

    public String getIndigeneStatusScope() {
        return indigeneStatusScope;
    }

    public void setIndigeneStatusScope(String indigeneStatusScope) {
        this.indigeneStatusScope = indigeneStatusScope;
    }

    public String getOnCampusScope() {
        return onCampusScope;
    }

    public void setOnCampusScope(String onCampusScope) {
        this.onCampusScope = onCampusScope;
    }

    public Date getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(Date effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Date dateAdded) {
        this.dateAdded = dateAdded;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public Accounts getAccountIt() {
        return accountIt;
    }

    public void setAccountIt(Accounts accountIt) {
        this.accountIt = accountIt;
    }

    public Feesgroup getFeesGroupId() {
        return feesGroupId;
    }

    public void setFeesGroupId(Feesgroup feesGroupId) {
        this.feesGroupId = feesGroupId;
    }
    
     public Feesitems getFeesItemsId() {
        return feesItemsId;
    }

    public void setFeesItemsId(Feesitems feesItemsId) {
        this.feesItemsId = feesItemsId;
    }

    public Users getAddedBy() {
        return addedBy;
    }

    public void setAddedBy(Users addedBy) {
        this.addedBy = addedBy;
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
        if (!(object instanceof Feessetup)) {
            return false;
        }
        Feessetup other = (Feessetup) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Feessetup[ id=" + id + " ]";
    }

}
