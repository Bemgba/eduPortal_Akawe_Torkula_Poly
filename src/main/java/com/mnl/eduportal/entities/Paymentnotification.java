/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.entities;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 *
 * @author eaglescan
 */
@Entity
@Table(name = "paymentnotification")
@NamedQueries({
    @NamedQuery(name = "Paymentnotification.findAll", query = "SELECT p FROM Paymentnotification p"),
    @NamedQuery(name = "Paymentnotification.findById", query = "SELECT p FROM Paymentnotification p WHERE p.id = :id"),
    @NamedQuery(name = "Paymentnotification.findByPaymentLogId", query = "SELECT p FROM Paymentnotification p WHERE p.paymentLogId = :paymentLogId"),
    @NamedQuery(name = "Paymentnotification.findByProductGroupCode", query = "SELECT p FROM Paymentnotification p WHERE p.productGroupCode = :productGroupCode"),
    @NamedQuery(name = "Paymentnotification.findByCustReference", query = "SELECT p FROM Paymentnotification p WHERE p.custReference = :custReference"),
    @NamedQuery(name = "Paymentnotification.findByAlternateCustReference", query = "SELECT p FROM Paymentnotification p WHERE p.alternateCustReference = :alternateCustReference"),
    @NamedQuery(name = "Paymentnotification.findByAmount", query = "SELECT p FROM Paymentnotification p WHERE p.amount = :amount"),
    @NamedQuery(name = "Paymentnotification.findByPaymentStatus", query = "SELECT p FROM Paymentnotification p WHERE p.paymentStatus = :paymentStatus"),
    @NamedQuery(name = "Paymentnotification.findByPaymentMethod", query = "SELECT p FROM Paymentnotification p WHERE p.paymentMethod = :paymentMethod"),
    @NamedQuery(name = "Paymentnotification.findByPaymentReference", query = "SELECT p FROM Paymentnotification p WHERE p.paymentReference = :paymentReference"),
    @NamedQuery(name = "Paymentnotification.findByChannelName", query = "SELECT p FROM Paymentnotification p WHERE p.channelName = :channelName"),
    @NamedQuery(name = "Paymentnotification.findByLocation", query = "SELECT p FROM Paymentnotification p WHERE p.location = :location"),
    @NamedQuery(name = "Paymentnotification.findByIsReversal", query = "SELECT p FROM Paymentnotification p WHERE p.isReversal = :isReversal"),
    @NamedQuery(name = "Paymentnotification.findByPaymentDate", query = "SELECT p FROM Paymentnotification p WHERE p.paymentDate = :paymentDate"),
    @NamedQuery(name = "Paymentnotification.findByInstitutionId", query = "SELECT p FROM Paymentnotification p WHERE p.institutionId = :institutionId"),
    @NamedQuery(name = "Paymentnotification.findByInstitutionName", query = "SELECT p FROM Paymentnotification p WHERE p.institutionName = :institutionName"),
    @NamedQuery(name = "Paymentnotification.findByBranchName", query = "SELECT p FROM Paymentnotification p WHERE p.branchName = :branchName"),
    @NamedQuery(name = "Paymentnotification.findByCustomerName", query = "SELECT p FROM Paymentnotification p WHERE p.customerName = :customerName"),
    @NamedQuery(name = "Paymentnotification.findByOtherCustomerInfo", query = "SELECT p FROM Paymentnotification p WHERE p.otherCustomerInfo = :otherCustomerInfo"),
    @NamedQuery(name = "Paymentnotification.findByReceiptNo", query = "SELECT p FROM Paymentnotification p WHERE p.receiptNo = :receiptNo"),
    @NamedQuery(name = "Paymentnotification.findByCollectionAccount", query = "SELECT p FROM Paymentnotification p WHERE p.collectionAccount = :collectionAccount"),
    @NamedQuery(name = "Paymentnotification.findByThirdPartyCode", query = "SELECT p FROM Paymentnotification p WHERE p.thirdPartyCode = :thirdPartyCode"),
    @NamedQuery(name = "Paymentnotification.findByItemName", query = "SELECT p FROM Paymentnotification p WHERE p.itemName = :itemName"),
    @NamedQuery(name = "Paymentnotification.findByItemCode", query = "SELECT p FROM Paymentnotification p WHERE p.itemCode = :itemCode"),
    @NamedQuery(name = "Paymentnotification.findByItemAmount", query = "SELECT p FROM Paymentnotification p WHERE p.itemAmount = :itemAmount"),
    @NamedQuery(name = "Paymentnotification.findByLeadBankCode", query = "SELECT p FROM Paymentnotification p WHERE p.leadBankCode = :leadBankCode"),
    @NamedQuery(name = "Paymentnotification.findByLeadBankCbnCode", query = "SELECT p FROM Paymentnotification p WHERE p.leadBankCbnCode = :leadBankCbnCode"),
    @NamedQuery(name = "Paymentnotification.findByLeadBankName", query = "SELECT p FROM Paymentnotification p WHERE p.leadBankName = :leadBankName"),
    @NamedQuery(name = "Paymentnotification.findByBankCode", query = "SELECT p FROM Paymentnotification p WHERE p.bankCode = :bankCode"),
    @NamedQuery(name = "Paymentnotification.findByCustomerPhoneNumber", query = "SELECT p FROM Paymentnotification p WHERE p.customerPhoneNumber = :customerPhoneNumber"),
    @NamedQuery(name = "Paymentnotification.findByDepositorName", query = "SELECT p FROM Paymentnotification p WHERE p.depositorName = :depositorName"),
    @NamedQuery(name = "Paymentnotification.findByDepositSlipNumber", query = "SELECT p FROM Paymentnotification p WHERE p.depositSlipNumber = :depositSlipNumber"),
    @NamedQuery(name = "Paymentnotification.findByPaymentCurrency", query = "SELECT p FROM Paymentnotification p WHERE p.paymentCurrency = :paymentCurrency"),
    @NamedQuery(name = "Paymentnotification.findByPaymentStatusMsg", query = "SELECT p FROM Paymentnotification p WHERE p.paymentStatusMsg = :paymentStatusMsg"),
    @NamedQuery(name = "Paymentnotification.findByInHouseStatus", query = "SELECT p FROM Paymentnotification p WHERE p.inHouseStatus = :inHouseStatus"),
    @NamedQuery(name = "Paymentnotification.findBySettlementDate", query = "SELECT p FROM Paymentnotification p WHERE p.settlementDate = :settlementDate")})
public class Paymentnotification implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "id")
    private String id;
    @Size(max = 200)
    @Column(name = "payment_log_id")
    private String paymentLogId;
    @Size(max = 200)
    @Column(name = "product_group_code")
    private String productGroupCode;
    @Size(max = 200)
    @Column(name = "cust_reference")
    private String custReference;
    @Size(max = 200)
    @Column(name = "alternate_cust_reference")
    private String alternateCustReference;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "amount")
    private Double amount;
    @Size(max = 200)
    @Column(name = "payment_status")
    private String paymentStatus;
    @Size(max = 200)
    @Column(name = "payment_method")
    private String paymentMethod;
    @Size(max = 200)
    @Column(name = "payment_reference")
    private String paymentReference;
    @Size(max = 200)
    @Column(name = "channel_name")
    private String channelName;
    @Size(max = 200)
    @Column(name = "location")
    private String location;
    @Size(max = 200)
    @Column(name = "is_reversal")
    private String isReversal;
    @Size(max = 200)
    @Column(name = "payment_date")
    private String paymentDate;
    @Size(max = 200)
    @Column(name = "institution_id")
    private String institutionId;
    @Size(max = 200)
    @Column(name = "institution_name")
    private String institutionName;
    @Size(max = 200)
    @Column(name = "branch_name")
    private String branchName;
    @Size(max = 200)
    @Column(name = "customer_name")
    private String customerName;
    @Size(max = 200)
    @Column(name = "other_customer_info")
    private String otherCustomerInfo;
    @Size(max = 200)
    @Column(name = "receipt_no")
    private String receiptNo;
    @Size(max = 200)
    @Column(name = "collection_account")
    private String collectionAccount;
    @Size(max = 200)
    @Column(name = "third_party_code")
    private String thirdPartyCode;
    @Size(max = 200)
    @Column(name = "item_name")
    private String itemName;
    @Size(max = 200)
    @Column(name = "item_code")
    private String itemCode;
    @Size(max = 200)
    @Column(name = "item_amount")
    private String itemAmount;
    @Size(max = 200)
    @Column(name = "lead_bank_code")
    private String leadBankCode;
    @Size(max = 200)
    @Column(name = "lead_bank_cbn_code")
    private String leadBankCbnCode;
    @Size(max = 200)
    @Column(name = "lead_bank_name")
    private String leadBankName;
    @Size(max = 200)
    @Column(name = "bank_code")
    private String bankCode;
    @Size(max = 200)
    @Column(name = "customer_phone_number")
    private String customerPhoneNumber;
    @Size(max = 200)
    @Column(name = "depositor_name")
    private String depositorName;
    @Size(max = 200)
    @Column(name = "deposit_slip_number")
    private String depositSlipNumber;
    @Size(max = 200)
    @Column(name = "payment_currency")
    private String paymentCurrency;
    @Size(max = 200)
    @Column(name = "payment_status_msg")
    private String paymentStatusMsg;
    @Size(max = 200)
    @Column(name = "in_house_status")
    private String inHouseStatus;
    @Size(max = 200)
    @Column(name = "settlement_date")
    private String settlementDate;

    public Paymentnotification() {
    }

    public Paymentnotification(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPaymentLogId() {
        return paymentLogId;
    }

    public void setPaymentLogId(String paymentLogId) {
        this.paymentLogId = paymentLogId;
    }

    public String getProductGroupCode() {
        return productGroupCode;
    }

    public void setProductGroupCode(String productGroupCode) {
        this.productGroupCode = productGroupCode;
    }

    public String getCustReference() {
        return custReference;
    }

    public void setCustReference(String custReference) {
        this.custReference = custReference;
    }

    public String getAlternateCustReference() {
        return alternateCustReference;
    }

    public void setAlternateCustReference(String alternateCustReference) {
        this.alternateCustReference = alternateCustReference;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentReference() {
        return paymentReference;
    }

    public void setPaymentReference(String paymentReference) {
        this.paymentReference = paymentReference;
    }

    public String getChannelName() {
        return channelName;
    }

    public void setChannelName(String channelName) {
        this.channelName = channelName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getIsReversal() {
        return isReversal;
    }

    public void setIsReversal(String isReversal) {
        this.isReversal = isReversal;
    }

    public String getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(String paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getInstitutionId() {
        return institutionId;
    }

    public void setInstitutionId(String institutionId) {
        this.institutionId = institutionId;
    }

    public String getInstitutionName() {
        return institutionName;
    }

    public void setInstitutionName(String institutionName) {
        this.institutionName = institutionName;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getOtherCustomerInfo() {
        return otherCustomerInfo;
    }

    public void setOtherCustomerInfo(String otherCustomerInfo) {
        this.otherCustomerInfo = otherCustomerInfo;
    }

    public String getReceiptNo() {
        return receiptNo;
    }

    public void setReceiptNo(String receiptNo) {
        this.receiptNo = receiptNo;
    }

    public String getCollectionAccount() {
        return collectionAccount;
    }

    public void setCollectionAccount(String collectionAccount) {
        this.collectionAccount = collectionAccount;
    }

    public String getThirdPartyCode() {
        return thirdPartyCode;
    }

    public void setThirdPartyCode(String thirdPartyCode) {
        this.thirdPartyCode = thirdPartyCode;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getItemAmount() {
        return itemAmount;
    }

    public void setItemAmount(String itemAmount) {
        this.itemAmount = itemAmount;
    }

    public String getLeadBankCode() {
        return leadBankCode;
    }

    public void setLeadBankCode(String leadBankCode) {
        this.leadBankCode = leadBankCode;
    }

    public String getLeadBankCbnCode() {
        return leadBankCbnCode;
    }

    public void setLeadBankCbnCode(String leadBankCbnCode) {
        this.leadBankCbnCode = leadBankCbnCode;
    }

    public String getLeadBankName() {
        return leadBankName;
    }

    public void setLeadBankName(String leadBankName) {
        this.leadBankName = leadBankName;
    }

    public String getBankCode() {
        return bankCode;
    }

    public void setBankCode(String bankCode) {
        this.bankCode = bankCode;
    }

    public String getCustomerPhoneNumber() {
        return customerPhoneNumber;
    }

    public void setCustomerPhoneNumber(String customerPhoneNumber) {
        this.customerPhoneNumber = customerPhoneNumber;
    }

    public String getDepositorName() {
        return depositorName;
    }

    public void setDepositorName(String depositorName) {
        this.depositorName = depositorName;
    }

    public String getDepositSlipNumber() {
        return depositSlipNumber;
    }

    public void setDepositSlipNumber(String depositSlipNumber) {
        this.depositSlipNumber = depositSlipNumber;
    }

    public String getPaymentCurrency() {
        return paymentCurrency;
    }

    public void setPaymentCurrency(String paymentCurrency) {
        this.paymentCurrency = paymentCurrency;
    }

    public String getPaymentStatusMsg() {
        return paymentStatusMsg;
    }

    public void setPaymentStatusMsg(String paymentStatusMsg) {
        this.paymentStatusMsg = paymentStatusMsg;
    }

    public String getInHouseStatus() {
        return inHouseStatus;
    }

    public void setInHouseStatus(String inHouseStatus) {
        this.inHouseStatus = inHouseStatus;
    }

    public String getSettlementDate() {
        return settlementDate;
    }

    public void setSettlementDate(String settlementDate) {
        this.settlementDate = settlementDate;
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
        if (!(object instanceof Paymentnotification)) {
            return false;
        }
        Paymentnotification other = (Paymentnotification) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mnl.bsum.bsuportal.entities.Paymentnotification[ id=" + id + " ]";
    }
    
}
