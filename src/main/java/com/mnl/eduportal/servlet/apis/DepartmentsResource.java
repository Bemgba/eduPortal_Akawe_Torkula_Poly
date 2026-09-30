package com.mnl.eduportal.servlet.apis;

import com.mnl.eduportal.dto.DepartmentsDTO;
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.Exceptions.ErrorResponse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

@Path("/departments")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class DepartmentsResource {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    /**
     * GET /api/departments/faculty/{facultyId}
     * Returns all departments that belong to a given faculty.
     */
    @GET
    @Path("/faculty/{facultyId}")
    public Response getDepartmentsByFaculty(@PathParam("facultyId") String facultyId) {
        List<Departments> list = em.createQuery(
                "SELECT d FROM Departments d WHERE d.facultyId.id = :facultyId",
                Departments.class)
                .setParameter("facultyId", facultyId)
                .getResultList();

        if (list.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                           .entity(new ErrorResponse("No departments found for faculty ID: " + facultyId))
                           .build();
        }

        List<DepartmentsDTO> dtoList = list.stream()
            .map(d -> new DepartmentsDTO(
                    d.getId(),
                    d.getName(),
                    d.getCode(),
                    d.getFacultyId().getId()))
            .collect(Collectors.toList());

        return Response.ok(dtoList).build();
    }
}
