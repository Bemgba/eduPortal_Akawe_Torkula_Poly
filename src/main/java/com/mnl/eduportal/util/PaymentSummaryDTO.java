/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

/**
 *
 * @author nguuma-ayua
 */
public class PaymentSummaryDTO {
    private String itemId;
    private String itemName;
    private Double totalAmount;
    private Long regnoCount;
    
    public PaymentSummaryDTO(String itemId, String itemName, Double totalAmount, Long regnoCount) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.totalAmount = totalAmount;
        this.regnoCount = regnoCount;
    }

    /**
     * @return the payitem
   
    /**
     * @return the totalAmount
     */
    public Double getTotalAmount() {
        return totalAmount;
    }

    /**
     * @param totalAmount the totalAmount to set
     */
    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    /**
     * @return the regnoCount
     */
    public Long getRegnoCount() {
        return regnoCount;
    }

    /**
     * @param regnoCount the regnoCount to set
     */
    public void setRegnoCount(Long regnoCount) {
        this.regnoCount = regnoCount;
    }

    /**
     * @return the itemId
     */
    public String getItemId() {
        return itemId;
    }

    /**
     * @param itemId the itemId to set
     */
    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    /**
     * @return the itemName
     */
    public String getItemName() {
        return itemName;
    }

    /**
     * @param itemName the itemName to set
     */
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }
    
}
