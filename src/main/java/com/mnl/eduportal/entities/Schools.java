/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
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
@Table(name = "schools")
@NamedQueries({
    @NamedQuery(name = "Schools.findAll", query = "SELECT s FROM Schools s"),
    @NamedQuery(name = "Schools.findById", query = "SELECT s FROM Schools s WHERE s.id = :id"),
    @NamedQuery(name = "Schools.findByName", query = "SELECT s FROM Schools s WHERE s.name = :name"),
    @NamedQuery(name = "Schools.findByOrderValue", query = "SELECT s FROM Schools s WHERE s.orderValue = :orderValue"),
    @NamedQuery(name = "Schools.findByDescription", query = "SELECT s FROM Schools s WHERE s.description = :description"),
    @NamedQuery(name = "Schools.findByAbbreviation", query = "SELECT s FROM Schools s WHERE s.abbreviation = :abbreviation")})
public class Schools implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "name")
    private String name;
    @Column(name = "order_value")
    private Integer orderValue;
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @Size(max = 50)
    @Column(name = "abbreviation")
    private String abbreviation;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "schoolId", fetch = FetchType.LAZY)
    private Collection<Applicants> applicantsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "schoolId", fetch = FetchType.LAZY)
    private Collection<Paymentreference> paymentreferenceCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "schoolId", fetch = FetchType.LAZY)
    private Collection<Downloadeddocuments> downloadeddocumentsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "schoolId", fetch = FetchType.LAZY)
    private Collection<Admissions> admissionsCollection;
    @JoinColumn(name = "head_title", referencedColumnName = "id")
    @ManyToOne
    private Positions headTitle;
    @JoinColumn(name = "head_id", referencedColumnName = "id")
    @ManyToOne
    private Users headId;
    @OneToMany(mappedBy = "schoolId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Payments> paymentsCollection;
    @OneToMany(mappedBy = "schoolId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Userschools> userschoolsCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "schoolId", fetch = FetchType.LAZY)
    private Collection<Sessionmanager> sessionmanagerCollection;
    @OneToMany(mappedBy = "schoolId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Schoolprogrammes> schoolprogrammesCollection;
    @OneToMany(mappedBy = "schoolId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Accounts> accountsCollection;
    @OneToMany(mappedBy = "schoolId", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Collection<Feesgroup> feesgroupCollection;

    public Schools() {
    }

    public Schools(String id) {
        this.id = id;
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

    public Integer getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(Integer orderValue) {
        this.orderValue = orderValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public void setAbbreviation(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    public Collection<Applicants> getApplicantsCollection() {
        return applicantsCollection;
    }

    public void setApplicantsCollection(Collection<Applicants> applicantsCollection) {
        this.applicantsCollection = applicantsCollection;
    }

    public Collection<Paymentreference> getPaymentreferenceCollection() {
        return paymentreferenceCollection;
    }

    public void setPaymentreferenceCollection(Collection<Paymentreference> paymentreferenceCollection) {
        this.paymentreferenceCollection = paymentreferenceCollection;
    }

    public Collection<Downloadeddocuments> getDownloadeddocumentsCollection() {
        return downloadeddocumentsCollection;
    }

    public void setDownloadeddocumentsCollection(Collection<Downloadeddocuments> downloadeddocumentsCollection) {
        this.downloadeddocumentsCollection = downloadeddocumentsCollection;
    }

    public Collection<Admissions> getAdmissionsCollection() {
        return admissionsCollection;
    }

    public void setAdmissionsCollection(Collection<Admissions> admissionsCollection) {
        this.admissionsCollection = admissionsCollection;
    }

    public Positions getHeadTitle() {
        return headTitle;
    }

    public void setHeadTitle(Positions headTitle) {
        this.headTitle = headTitle;
    }

    public Users getHeadId() {
        return headId;
    }

    public void setHeadId(Users headId) {
        this.headId = headId;
    }

    public Collection<Payments> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payments> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }

    public Collection<Userschools> getUserschoolsCollection() {
        return userschoolsCollection;
    }

    public void setUserschoolsCollection(Collection<Userschools> userschoolsCollection) {
        this.userschoolsCollection = userschoolsCollection;
    }

    public Collection<Sessionmanager> getSessionmanagerCollection() {
        return sessionmanagerCollection;
    }

    public void setSessionmanagerCollection(Collection<Sessionmanager> sessionmanagerCollection) {
        this.sessionmanagerCollection = sessionmanagerCollection;
    }

    public Collection<Schoolprogrammes> getSchoolprogrammesCollection() {
        return schoolprogrammesCollection;
    }

    public void setSchoolprogrammesCollection(Collection<Schoolprogrammes> schoolprogrammesCollection) {
        this.schoolprogrammesCollection = schoolprogrammesCollection;
    }

    public Collection<Accounts> getAccountsCollection() {
        return accountsCollection;
    }

    public void setAccountsCollection(Collection<Accounts> accountsCollection) {
        this.accountsCollection = accountsCollection;
    }

    public Collection<Feesgroup> getFeesgroupCollection() {
        return feesgroupCollection;
    }

    public void setFeesgroupCollection(Collection<Feesgroup> feesgroupCollection) {
        this.feesgroupCollection = feesgroupCollection;
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
        if (!(object instanceof Schools)) {
            return false;
        }
        Schools other = (Schools) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Schools[ id=" + id + " ]";
    }
    
}
