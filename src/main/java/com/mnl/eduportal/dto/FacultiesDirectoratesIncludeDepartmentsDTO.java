/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.dto;

/**
 *
 * @author BDIC
 */

import java.util.List;

public class FacultiesDirectoratesIncludeDepartmentsDTO {
    private String id;
    private String name;
    private String code;
    private List<DepartmentsDTO> departments;

    public FacultiesDirectoratesIncludeDepartmentsDTO(String id, String name, String code, List<DepartmentsDTO> departments) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.departments = departments;
    }

    // renamed getters & setters
    public String getFacultyId() {
        return id;
    }

    public void setFacultyId(String id) {
        this.id = id;
    }

    public String getFacultyName() {
        return name;
    }

    public void setFacultyName(String name) {
        this.name = name;
    }

    public String getFacultyCode() {
        return code;
    }

    public void setFacultyCode(String code) {
        this.code = code;
    }

    public List<DepartmentsDTO> getDepartmentsIncluded() {
        return departments;
    }

    public void setDepartmentsIncluded(List<DepartmentsDTO> departments) {
        this.departments = departments;
    }
}

