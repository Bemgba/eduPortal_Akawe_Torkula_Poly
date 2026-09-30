/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.Exceptions;

/**
 *
 * @author BEMGBA
 */
// ErrorResponse.java
public class ErrorResponse {
    private boolean success;
    private String message;

    public ErrorResponse(String message) {
        this.success = false;
        this.message = message;
    }
    // getters
    
    // No-args constructor (needed for JSON serialization/deserialization)
    public ErrorResponse() {
        this.success = false;
    } 
    // Getter for success (no setter, because it's always false)
    public boolean isSuccess() {
        return success;
    }
    // Getter and Setter for message
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
}
