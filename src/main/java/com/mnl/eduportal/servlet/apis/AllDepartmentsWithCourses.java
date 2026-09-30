/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet.apis;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.entities.Courses;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.ArrayList;
import com.mnl.eduportal.dto.DepartmentWithCoursesDTO;
import com.mnl.eduportal.dto.CoursesDTO;
import java.util.stream.Collectors;
/**
 *
 * @author BDIC
 */
@Path("/departments")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class AllDepartmentsWithCourses{

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    @GET
    @Path("/with-courses")
    public Response getAllDepartmentsWithCourses() {
        // Fetch all departments
        List<Departments> departments = em.createQuery(
                "SELECT d FROM Departments d", Departments.class)
                .getResultList();

        // Map to DTOs
        List<DepartmentWithCoursesDTO> dtoList = new ArrayList<>();
        for (Departments d : departments) {
            // fetch courses for this department
            List<CoursesDTO> courses = em.createQuery(
                    "SELECT c FROM Courses c WHERE c.departmentId.id = :did", Courses.class)
                    .setParameter("did", d.getId())
                    .getResultList()
                    .stream()
                    .map(c -> new CoursesDTO(c.getId(), c.getName(), c.getCode(), d.getId()))
                    .collect(Collectors.toList());

            dtoList.add(new DepartmentWithCoursesDTO(d.getId(), d.getName(), courses));
        }

        return Response.ok(dtoList).build();
    }
}

