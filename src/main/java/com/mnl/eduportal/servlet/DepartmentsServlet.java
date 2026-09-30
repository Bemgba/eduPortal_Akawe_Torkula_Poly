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
import com.mnl.eduportal.entities.Departments;
import com.mnl.eduportal.dto.DepartmentsDTO;
import com.mnl.eduportal.Exceptions.ErrorResponse;
import java.util.ArrayList;
import javax.persistence.PersistenceUnit;
import java.util.List;
import java.io.IOException;

/**
 *
 * @author BDIC
 */
@WebServlet("/api/departments")
public class DepartmentsServlet extends HttpServlet {
    @PersistenceUnit(unitName = "JakartaDS")
    private EntityManagerFactory emf;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try (EntityManager em = emf.createEntityManager()) {
            List<Departments> list = em.createNamedQuery("Departments.findAll", Departments.class)
                                       .getResultList();

            if (list.isEmpty()) {
                JsonUtil.writeJson(resp, HttpServletResponse.SC_NOT_FOUND, new ErrorResponse("No departments found"));
                return;
            }

            List<DepartmentsDTO> dtoList = list.stream()
                .map(d -> new DepartmentsDTO(d.getId(), d.getName(), d.getCode(), d.getFacultyId().getId()))
                .toList();

            JsonUtil.writeJson(resp, HttpServletResponse.SC_OK, dtoList);
        }
    }
}

