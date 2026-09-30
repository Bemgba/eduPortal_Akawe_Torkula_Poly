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
@Table(name = "staffsalaryinfo")
@NamedQueries({
    @NamedQuery(name = "Staffsalaryinfo.findAll", query = "SELECT s FROM Staffsalaryinfo s"),
    @NamedQuery(name = "Staffsalaryinfo.findById", query = "SELECT s FROM Staffsalaryinfo s WHERE s.id = :id"),
    @NamedQuery(name = "Staffsalaryinfo.findBySalaryScaleId", query = "SELECT s FROM Staffsalaryinfo s WHERE s.salaryScaleId = :salaryScaleId"),
    @NamedQuery(name = "Staffsalaryinfo.findByGradeLevel", query = "SELECT s FROM Staffsalaryinfo s WHERE s.gradeLevel = :gradeLevel"),
    @NamedQuery(name = "Staffsalaryinfo.findByStep", query = "SELECT s FROM Staffsalaryinfo s WHERE s.step = :step"),
    @NamedQuery(name = "Staffsalaryinfo.findByBankId", query = "SELECT s FROM Staffsalaryinfo s WHERE s.bankId = :bankId"),
    @NamedQuery(name = "Staffsalaryinfo.findByAccountNo", query = "SELECT s FROM Staffsalaryinfo s WHERE s.accountNo = :accountNo"),
    @NamedQuery(name = "Staffsalaryinfo.findBySalaryStatus", query = "SELECT s FROM Staffsalaryinfo s WHERE s.salaryStatus = :salaryStatus"),
    @NamedQuery(name = "Staffsalaryinfo.findBySalaryStatusComment", query = "SELECT s FROM Staffsalaryinfo s WHERE s.salaryStatusComment = :salaryStatusComment"),
    @NamedQuery(name = "Staffsalaryinfo.findByDateOnboarded", query = "SELECT s FROM Staffsalaryinfo s WHERE s.dateOnboarded = :dateOnboarded"),
    @NamedQuery(name = "Staffsalaryinfo.findByDateExited", query = "SELECT s FROM Staffsalaryinfo s WHERE s.dateExited = :dateExited")})
public class Staffsalaryinfo implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 50)
    @Column(name = "salary_scale_id")
    private String salaryScaleId;
    @Size(max = 50)
    @Column(name = "grade_level")
    private String gradeLevel;
    @Column(name = "step")
    private Integer step;
    @Size(max = 50)
    @Column(name = "bank_id")
    private String bankId;
    @Size(max = 10)
    @Column(name = "account_no")
    private String accountNo;
    @Size(max = 20)
    @Column(name = "salary_status")
    private String salaryStatus;
    @Size(max = 200)
    @Column(name = "salary_status_comment")
    private String salaryStatusComment;
    @Column(name = "date_onboarded")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateOnboarded;
    @Column(name = "date_exited")
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateExited;
    @JoinColumn(name = "id", referencedColumnName = "id", insertable = false, updatable = false)
    @OneToOne(optional = false)
    private Staff staff;

    public Staffsalaryinfo() {
    }

    public Staffsalaryinfo(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSalaryScaleId() {
        return salaryScaleId;
    }

    public void setSalaryScaleId(String salaryScaleId) {
        this.salaryScaleId = salaryScaleId;
    }

    public String getGradeLevel() {
        return gradeLevel;
    }

    public void setGradeLevel(String gradeLevel) {
        this.gradeLevel = gradeLevel;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }

    public String getBankId() {
        return bankId;
    }

    public void setBankId(String bankId) {
        this.bankId = bankId;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public String getSalaryStatus() {
        return salaryStatus;
    }

    public void setSalaryStatus(String salaryStatus) {
        this.salaryStatus = salaryStatus;
    }

    public String getSalaryStatusComment() {
        return salaryStatusComment;
    }

    public void setSalaryStatusComment(String salaryStatusComment) {
        this.salaryStatusComment = salaryStatusComment;
    }

    public Date getDateOnboarded() {
        return dateOnboarded;
    }

    public void setDateOnboarded(Date dateOnboarded) {
        this.dateOnboarded = dateOnboarded;
    }

    public Date getDateExited() {
        return dateExited;
    }

    public void setDateExited(Date dateExited) {
        this.dateExited = dateExited;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
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
        if (!(object instanceof Staffsalaryinfo)) {
            return false;
        }
        Staffsalaryinfo other = (Staffsalaryinfo) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Staffsalaryinfo[ id=" + id + " ]";
    }
    
}
