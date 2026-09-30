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
@Table(name = "feesgroup")
@NamedQueries({
    @NamedQuery(name = "Feesgroup.findAll", query = "SELECT f FROM Feesgroup f"),
    @NamedQuery(name = "Feesgroup.findById", query = "SELECT f FROM Feesgroup f WHERE f.id = :id"),
    @NamedQuery(name = "Feesgroup.findByName", query = "SELECT f FROM Feesgroup f WHERE f.name = :name"),
    @NamedQuery(name = "Feesgroup.findByDescription", query = "SELECT f FROM Feesgroup f WHERE f.description = :description"),
    @NamedQuery(name = "Feesgroup.findBySessionSemester", query = "SELECT f FROM Feesgroup f WHERE f.sessionSemester = :sessionSemester"),
    @NamedQuery(name = "Feesgroup.findByRepeatPayment", query = "SELECT f FROM Feesgroup f WHERE f.repeatPayment = :repeatPayment")})
public class Feesgroup implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "id")
    private String id;
    @Size(max = 100)
    @Column(name = "name")
    private String name;
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @Size(max = 50)
    @Column(name = "session_semester")
    private String sessionSemester;
    @Size(max = 10)
    @Column(name = "repeat_payment")
    private String repeatPayment;
    @Size(max = 50)
    @Column(name = "category")
    private String category;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "feesGroupId")
    private Collection<Paymentreference> paymentreferenceCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "feesGroupId")
    private Collection<Feessetup> feessetupCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "feesGroupId")
    private Collection<Payments> paymentsCollection;
    @JoinColumn(name = "account_id", referencedColumnName = "id")
    @ManyToOne
    private Accounts accountId;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne
    private Schools schoolId;
    @Size(max = 200)
    @Column(name = "visibility")
    private String visibility;
    @Size(max = 200)
    @Column(name = "dependson")
    private String dependson;

    public Feesgroup() {
    }

    public Feesgroup(String id) {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSessionSemester() {
        return sessionSemester;
    }

    public void setSessionSemester(String sessionSemester) {
        this.sessionSemester = sessionSemester;
    }

    public String getRepeatPayment() {
        return repeatPayment;
    }

    public void setRepeatPayment(String repeatPayment) {
        this.repeatPayment = repeatPayment;
    }

    public Collection<Paymentreference> getPaymentreferenceCollection() {
        return paymentreferenceCollection;
    }

    public void setPaymentreferenceCollection(Collection<Paymentreference> paymentreferenceCollection) {
        this.paymentreferenceCollection = paymentreferenceCollection;
    }

    public Collection<Feessetup> getFeessetupCollection() {
        return feessetupCollection;
    }

    public void setFeessetupCollection(Collection<Feessetup> feessetupCollection) {
        this.feessetupCollection = feessetupCollection;
    }

    public Collection<Payments> getPaymentsCollection() {
        return paymentsCollection;
    }

    public void setPaymentsCollection(Collection<Payments> paymentsCollection) {
        this.paymentsCollection = paymentsCollection;
    }

    public Accounts getAccountId() {
        return accountId;
    }

    public void setAccountId(Accounts accountId) {
        this.accountId = accountId;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
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
        if (!(object instanceof Feesgroup)) {
            return false;
        }
        Feesgroup other = (Feesgroup) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Feesgroup[ id=" + id + " ]";
    }

    /**
     * @return the category
     */
    public String getCategory() {
        return category;
    }

    /**
     * @param category the category to set
     */
    public void setCategory(String category) {
        this.category = category;
    }

    /**
     * @return the visibility
     */
    public String getVisibility() {
        return visibility;
    }

    /**
     * @param visibility the visibility to set
     */
    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }

    /**
     * @return the dependson
     */
    public String getDependson() {
        return dependson;
    }

    /**
     * @param dependson the dependson to set
     */
    public void setDependson(String dependson) {
        this.dependson = dependson;
    }

}
