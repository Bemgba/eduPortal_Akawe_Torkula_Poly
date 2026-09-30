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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
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
@Table(name = "studentsupplimentarybiodata")
@NamedQueries({
    @NamedQuery(name = "Studentsupplimentarybiodata.findAll", query = "SELECT s FROM Studentsupplimentarybiodata s"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findById", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.id = :id"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByParentAnnualIncome", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.parentAnnualIncome = :parentAnnualIncome"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByParentProfession", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.parentProfession = :parentProfession"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByPrimarySchoolFees", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.primarySchoolFees = :primarySchoolFees"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByPrimarySchoolName", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.primarySchoolName = :primarySchoolName"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findBySecondarySchoolFees", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.secondarySchoolFees = :secondarySchoolFees"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findBySecondarySchoolName", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.secondarySchoolName = :secondarySchoolName"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByParentName", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.parentName = :parentName"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByParentPhone", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.parentPhone = :parentPhone"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByOatFormAttested", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.oatFormAttested = :oatFormAttested"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByDateOathAttested", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.dateOathAttested = :dateOathAttested"),
    @NamedQuery(name = "Studentsupplimentarybiodata.findByDateCreated", query = "SELECT s FROM Studentsupplimentarybiodata s WHERE s.dateCreated = :dateCreated")})
public class Studentsupplimentarybiodata implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "parent_annual_income")
    private Double parentAnnualIncome;
    @Size(max = 100)
    @Column(name = "parent_profession")
    private String parentProfession;
    @Column(name = "primary_school_fees")
    private Double primarySchoolFees;
    @Size(max = 100)
    @Column(name = "primary_school_name")
    private String primarySchoolName;
    @Column(name = "secondary_school_fees")
    private Double secondarySchoolFees;
    @Size(max = 100)
    @Column(name = "secondary_school_name")
    private String secondarySchoolName;
    @Size(max = 150)
    @Column(name = "parent_name")
    private String parentName;
    @Size(max = 13)
    @Column(name = "parent_phone")
    private String parentPhone;
    @Size(max = 20)
    @Column(name = "oat_form_attested")
    private String oatFormAttested;
    @Column(name = "date_oath_attested")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOathAttested;
    @Column(name = "date_created")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateCreated;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Students students;

    public Studentsupplimentarybiodata() {
    }

    public Studentsupplimentarybiodata(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Double getParentAnnualIncome() {
        return parentAnnualIncome;
    }

    public void setParentAnnualIncome(Double parentAnnualIncome) {
        this.parentAnnualIncome = parentAnnualIncome;
    }

    public String getParentProfession() {
        return parentProfession;
    }

    public void setParentProfession(String parentProfession) {
        this.parentProfession = parentProfession;
    }

    public Double getPrimarySchoolFees() {
        return primarySchoolFees;
    }

    public void setPrimarySchoolFees(Double primarySchoolFees) {
        this.primarySchoolFees = primarySchoolFees;
    }

    public String getPrimarySchoolName() {
        return primarySchoolName;
    }

    public void setPrimarySchoolName(String primarySchoolName) {
        this.primarySchoolName = primarySchoolName;
    }

    public Double getSecondarySchoolFees() {
        return secondarySchoolFees;
    }

    public void setSecondarySchoolFees(Double secondarySchoolFees) {
        this.secondarySchoolFees = secondarySchoolFees;
    }

    public String getSecondarySchoolName() {
        return secondarySchoolName;
    }

    public void setSecondarySchoolName(String secondarySchoolName) {
        this.secondarySchoolName = secondarySchoolName;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getParentPhone() {
        return parentPhone;
    }

    public void setParentPhone(String parentPhone) {
        this.parentPhone = parentPhone;
    }

    public String getOatFormAttested() {
        return oatFormAttested;
    }

    public void setOatFormAttested(String oatFormAttested) {
        this.oatFormAttested = oatFormAttested;
    }

    public Date getDateOathAttested() {
        return dateOathAttested;
    }

    public void setDateOathAttested(Date dateOathAttested) {
        this.dateOathAttested = dateOathAttested;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Students getStudents() {
        return students;
    }

    public void setStudents(Students students) {
        this.students = students;
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
        if (!(object instanceof Studentsupplimentarybiodata)) {
            return false;
        }
        Studentsupplimentarybiodata other = (Studentsupplimentarybiodata) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Studentsupplimentarybiodata[ id=" + id + " ]";
    }
    
}
