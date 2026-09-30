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
@Table(name = "accounts")
@NamedQueries({
    @NamedQuery(name = "Accounts.findAll", query = "SELECT a FROM Accounts a"),
    @NamedQuery(name = "Accounts.findById", query = "SELECT a FROM Accounts a WHERE a.id = :id"),
    @NamedQuery(name = "Accounts.findByName", query = "SELECT a FROM Accounts a WHERE a.name = :name"),
    @NamedQuery(name = "Accounts.findByApiCode", query = "SELECT a FROM Accounts a WHERE a.apiCode = :apiCode"),
    @NamedQuery(name = "Accounts.findByBankName", query = "SELECT a FROM Accounts a WHERE a.bankName = :bankName"),
    @NamedQuery(name = "Accounts.findByAccountNo", query = "SELECT a FROM Accounts a WHERE a.accountNo = :accountNo"),
    @NamedQuery(name = "Accounts.findByDescription", query = "SELECT a FROM Accounts a WHERE a.description = :description")})
public class Accounts implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id")
    private Integer id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "name")
    private String name;
    @Size(max = 200)
    @Column(name = "api_code")
    private String apiCode;
    @Size(max = 150)
    @Column(name = "bank_name")
    private String bankName;
    @Size(max = 10)
    @Column(name = "account_no")
    private String accountNo;
    @Size(max = 200)
    @Column(name = "description")
    private String description;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "accountIt")
    private Collection<Feessetup> feessetupCollection;
    @JoinColumn(name = "school_id", referencedColumnName = "id")
    @ManyToOne
    private Schools schoolId;
    @OneToMany(mappedBy = "accountId")
    private Collection<Feesgroup> feesgroupCollection;

    public Accounts() {
    }

    public Accounts(Integer id) {
        this.id = id;
    }

    public Accounts(Integer id, String name) {
        this.id = id;
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getApiCode() {
        return apiCode;
    }

    public void setApiCode(String apiCode) {
        this.apiCode = apiCode;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Collection<Feessetup> getFeessetupCollection() {
        return feessetupCollection;
    }

    public void setFeessetupCollection(Collection<Feessetup> feessetupCollection) {
        this.feessetupCollection = feessetupCollection;
    }

    public Schools getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Schools schoolId) {
        this.schoolId = schoolId;
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
        if (!(object instanceof Accounts)) {
            return false;
        }
        Accounts other = (Accounts) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Accounts[ id=" + id + " ]";
    }
    
}
