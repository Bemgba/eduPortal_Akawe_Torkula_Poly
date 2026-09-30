/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet.apis;

/**
 *
 * @author BDIC
 */

import com.mnl.eduportal.dto.ApiResponse;
import com.mnl.eduportal.dto.CoursesDTO;
import com.mnl.eduportal.entities.Courses;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Path("/courses")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class AllCoursesResource {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    @GET
    @Path("/all")
    public Response getAllCourses() {
        try {
            // Fetch all courses
            List<Courses> courses = em.createQuery(
                    "SELECT c FROM Courses c", Courses.class)
                    .getResultList();

            if (courses.isEmpty()) {
                ApiResponse<Object> notFoundResponse =
                        new ApiResponse<>(404, "No courses found", null);
                return Response.status(Response.Status.NOT_FOUND).entity(notFoundResponse).build();
            }

            // Map entities -> DTOs
            List<CoursesDTO> dtoList = courses.stream()
                    .map(c -> new CoursesDTO(
                            c.getId(),
                            c.getName(),
                            c.getCode(),
                            c.getDepartmentId() != null ? c.getDepartmentId().getId() : null
                    ))
                    .collect(Collectors.toList());

            ApiResponse<List<CoursesDTO>> successResponse =
                    new ApiResponse<>(200, "Courses retrieved successfully", dtoList);

            return Response.ok(successResponse).build();

        } catch (Exception e) {
            ApiResponse<Object> errorResponse =
                    new ApiResponse<>(500, "An error occurred: " + e.getMessage(), null);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(errorResponse).build();
        }
    }
}

