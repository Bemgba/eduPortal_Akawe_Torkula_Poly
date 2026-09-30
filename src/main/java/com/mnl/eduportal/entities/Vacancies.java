/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author BDIC
 */
@Entity
@Table(name = "vacancies")
@NamedQueries({
    @NamedQuery(name = "Vacancies.findAll", query = "SELECT v FROM Vacancies v"),
    @NamedQuery(name = "Vacancies.findById", query = "SELECT v FROM Vacancies v WHERE v.id = :id"),
    @NamedQuery(name = "Vacancies.findByEmploymentType", query = "SELECT v FROM Vacancies v WHERE v.employmentType = :employmentType"),
    @NamedQuery(name = "Vacancies.findBySalaryGrade", query = "SELECT v FROM Vacancies v WHERE v.salaryGrade = :salaryGrade"),
    @NamedQuery(name = "Vacancies.findByResponsibilities", query = "SELECT v FROM Vacancies v WHERE v.responsibilities = :responsibilities"),
    @NamedQuery(name = "Vacancies.findByRequirements", query = "SELECT v FROM Vacancies v WHERE v.requirements = :requirements"),
    @NamedQuery(name = "Vacancies.findByStatus", query = "SELECT v FROM Vacancies v WHERE v.status = :status")})
public class Vacancies implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "id")
    private String id;
    @Basic(optional = false)
    @Column(name = "employment_type")
    private String employmentType;
    @Basic(optional = false)
    @Column(name = "salary_grade")
    private String salaryGrade;
    @Basic(optional = false)
    @Column(name = "responsibilities")
    private String responsibilities;
    @Column(name = "requirements")
    private String requirements;
    @Column(name = "status")
    private String status;
    @JoinColumn(name = "dept_id", referencedColumnName = "code")
    @ManyToOne
    private Departments deptId;
    @JoinColumn(name = "position_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Positions positionId;
    
    @jakarta.persistence.Column(name = "dead_line")
    @Temporal(TemporalType.TIMESTAMP)
    private Date deadLine;
    
    public Vacancies() {
    }

    public Vacancies(String id) {
        this.id = id;
    }

    public Vacancies(String id, String employmentType, String salaryGrade, String responsibilities) {
        this.id = id;
        this.employmentType = employmentType;
        this.salaryGrade = salaryGrade;
        this.responsibilities = responsibilities;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getEmploymentType() {
        return employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }

    public String getSalaryGrade() {
        return salaryGrade;
    }

    public void setSalaryGrade(String salaryGrade) {
        this.salaryGrade = salaryGrade;
    }

    public String getResponsibilities() {
        return responsibilities;
    }

    public void setResponsibilities(String responsibilities) {
        this.responsibilities = responsibilities;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Departments getDeptId() {
        return deptId;
    }

    public void setDeptId(Departments deptId) {
        this.deptId = deptId;
    }

    public Positions getPositionId() {
        return positionId;
    }

    public void setPositionId(Positions positionId) {
        this.positionId = positionId;
    }
    
    public Date getDeadLine() {
        return deadLine;
    }

    public void setDeadLine(Date deadLine) {
        this.deadLine = deadLine;
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
        if (!(object instanceof Vacancies)) {
            return false;
        }
        Vacancies other = (Vacancies) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.eduportal.Vacancies[ id=" + id + " ]";
    }
    
}