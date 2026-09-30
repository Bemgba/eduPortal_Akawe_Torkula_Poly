/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet.apis;

/**
 *
 * @author BDIC
 */
import com.mnl.eduportal.dto.CoursesDTO;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.Exceptions.ErrorResponse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Path("/courses")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class CourseSearchResource {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    /**
     * GET /api/courses/search?query=abc
     * Search courses by any occurrence of the string in the course name
     */
    @GET
    @Path("/search")
    public Response searchCourses(@QueryParam("query") String query) {
        if (query == null || query.isEmpty()) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity(new ErrorResponse("query parameter is required"))
                    .build();
        }

        // Use %query% for partial match anywhere in the name
        List<Courses> courses = em.createQuery(
                "SELECT c FROM Courses c WHERE UPPER(c.name) LIKE :pattern", Courses.class)
                .setParameter("pattern", "%" + query.toUpperCase() + "%")
                .getResultList();

        if (courses.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("No courses found containing: " + query))
                    .build();
        }

        List<CoursesDTO> dtoList = courses.stream()
                .map(c -> new CoursesDTO(
                        c.getId(),
                        c.getName(),
                        c.getCode(),
                        c.getDepartmentId() != null ? c.getDepartmentId().getId() : null))
                .collect(Collectors.toList());

        return Response.ok(dtoList).build();
    }
}


