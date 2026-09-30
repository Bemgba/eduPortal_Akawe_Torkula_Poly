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

public class DepartmentWithCoursesDTO {
    private String id;
    private String name;
    private List<CoursesDTO> courses;

    public DepartmentWithCoursesDTO(String id, String name, List<CoursesDTO> courses) {
        this.id = id;
        this.name = name;
        this.courses = courses;
    }

    // Getter for id
    public String getId() {
        return id;
    }

    // Setter for id
    public void setId(String id) {
        this.id = id;
    }

    // Getter for name
    public String getName() {
        return name;
    }

    // Setter for name
    public void setName(String name) {
        this.name = name;
    }

    // Getter for courses
    public List<CoursesDTO> getCourses() {
        return courses;
    }

    // Setter for courses
    public void setCourses(List<CoursesDTO> courses) {
        this.courses = courses;
    }
}

