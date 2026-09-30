/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import com.mnl.eduportal.entities.Semesterregistrationcourses;
import java.util.List;

public class CourseUtils {

    public static int countByType(List<Semesterregistrationcourses> courses, String type) {
        return (int) courses.stream().filter(c -> c.getCourseType().equalsIgnoreCase(type)).count();
    }

    public static int sumCreditUnitsByType(List<Semesterregistrationcourses> courses, String type) {
        return courses.stream()
                .filter(c -> c.getCourseType().equalsIgnoreCase(type))
                .mapToInt(Semesterregistrationcourses::getCreditUnit)
                .sum();
    }
}
