/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import com.mnl.eduportal.util.JsonUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.dto.CoursesDTO;
import com.mnl.eduportal.Exceptions.ErrorResponse;
import java.util.List;
import javax.persistence.PersistenceUnit;
import java.io.IOException;


/**
 *
 * @author BDIC
 */
@WebServlet("/api/departments/courses3")
public class CoursesByDepartmentServlet extends HttpServlet {
    @PersistenceUnit(unitName = "JakartaDS")
    private EntityManagerFactory emf;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String deptId = req.getParameter("departmentId");
        if (deptId == null || deptId.isEmpty()) {
            JsonUtil.writeJson(resp, HttpServletResponse.SC_BAD_REQUEST, new ErrorResponse("departmentId is required"));
            return;
        }

        try (EntityManager em = emf.createEntityManager()) {
            List<Courses> list = em.createQuery("SELECT c FROM Courses c WHERE c.departmentId.id = :did", Courses.class)
                                   .setParameter("did", deptId)
                                   .getResultList();

            if (list.isEmpty()) {
                JsonUtil.writeJson(resp, HttpServletResponse.SC_NOT_FOUND, new ErrorResponse("No courses found for departmentId: " + deptId));
                return;
            }

            List<CoursesDTO> dtoList = list.stream()
                .map(c -> new CoursesDTO(c.getId(), c.getName(), c.getCode(), c.getDepartmentId().getId()))
                .toList();

            JsonUtil.writeJson(resp, HttpServletResponse.SC_OK, dtoList);
        }
    }
}

