/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet.apis;
/**
 *
 * @author BDIC
 */
import com.mnl.eduportal.dto.DepartmentsDTO;
import com.mnl.eduportal.dto.FacultiesDirectoratesDTO;
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.entities.FacultiesDirectorates;
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

@Path("/faculties")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class FacultiesResource {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    /**
     * GET /api/faculties/{facultyId}/departments
     * Returns all departments belonging to a given faculty.
     */
    @GET
    @Path("/{facultyId}/departments")
    public Response getDepartmentsByFaculty(@PathParam("facultyId") String facultyId) {
        // Load the faculty first
        FacultiesDirectorates faculty = em.find(FacultiesDirectorates.class, facultyId);
        if (faculty == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("Faculty with ID " + facultyId + " not found"))
                    .build();
        }

        // Use the mapped collection to fetch departments
        List<DepartmentsDTO> dtoList = faculty.getDepartmentsCollection().stream()
                .map(d -> new DepartmentsDTO(
                        d.getId(),
                        d.getName(),
                        d.getCode(),
                        faculty.getId()   // facultyId comes from parent
                ))
                .collect(Collectors.toList());

        if (dtoList.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("No departments found for faculty ID: " + facultyId))
                    .build();
        }

        return Response.ok(dtoList).build();
    }

    /**
     * Optional: GET /api/faculties
     * Returns all faculties (without departments).
     */
    @GET
    public Response getFaculties() {
        List<FacultiesDirectorates> list = em.createNamedQuery("FacultiesDirectorates.findAll", FacultiesDirectorates.class)
                .getResultList();

        if (list.isEmpty()) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity(new ErrorResponse("No faculties found"))
                    .build();
        }

        List<FacultiesDirectoratesDTO> dtoList = list.stream()
                .map(f -> new FacultiesDirectoratesDTO(f.getId(), f.getName(), f.getCode()))
                .collect(Collectors.toList());

        return Response.ok(dtoList).build();
    }
}

