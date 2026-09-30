/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.dto;

/**
 *
 * @author BDIC
 */
//public class FacultiesDirectoratesDTO {
//    
//}
// FacultiesDirectoratesDTO.java
public class FacultiesDirectoratesDTO {
    private String id;
    private String name;
    private String code;

    public FacultiesDirectoratesDTO(String id, String name, String code) {
        this.id = id;
        this.name = name;
        this.code = code;
    }
    // getters & setters
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    // Getter and Setter for name
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // Getter and Setter for code
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}