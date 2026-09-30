package com.mnl.eduportal.servlet.apis;

import com.mnl.eduportal.dto.DepartmentsDTO;
import com.mnl.eduportal.dto.FacultiesDirectoratesIncludeDepartmentsDTO;
import com.mnl.eduportal.entities.FacultiesDirectorates;
import com.mnl.eduportal.dto.ApiResponse;
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

@Path("/faculties")
@Produces(MediaType.APPLICATION_JSON)
@Transactional
public class FacultiesIncludeDepartmentsResource {

    @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;

    @GET
    @Path("/with-departments")
    public Response getFacultiesWithDepartments() {
        try {
            // fetch all faculties
            List<FacultiesDirectorates> faculties = em.createQuery(
                    "SELECT f FROM FacultiesDirectorates f", FacultiesDirectorates.class)
                    .getResultList();

            if (faculties.isEmpty()) {
                ApiResponse<Object> notFoundResponse =
                        new ApiResponse<>(404, "No faculties found", null);
                return Response.status(Response.Status.NOT_FOUND).entity(notFoundResponse).build();
            }

            // map faculties + departments
            List<FacultiesDirectoratesIncludeDepartmentsDTO> dtoList = faculties.stream().map(faculty -> {
                List<DepartmentsDTO> depDtos = faculty.getDepartmentsCollection().stream()
                        .map(d -> new DepartmentsDTO(
                                d.getId(),
                                d.getName(),
                                d.getCode(),
                                d.getFacultyId().getId()))
                        .collect(Collectors.toList());

                return new FacultiesDirectoratesIncludeDepartmentsDTO(
                        faculty.getId(),
                        faculty.getName(),
                        faculty.getCode(),
                        depDtos
                );
            }).collect(Collectors.toList());

            ApiResponse<List<FacultiesDirectoratesIncludeDepartmentsDTO>> successResponse =
                    new ApiResponse<>(200, "Faculties with departments retrieved successfully", dtoList);

            return Response.ok(successResponse).build();

        } catch (Exception e) {
            ApiResponse<Object> errorResponse =
                    new ApiResponse<>(500, "An error occurred: " + e.getMessage(), null);
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(errorResponse).build();
        }
    }
}
