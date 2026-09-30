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
import com.mnl.eduportal.entities.FacultiesDirectorates;
import com.mnl.eduportal.dto.FacultiesDirectoratesDTO;
import com.mnl.eduportal.Exceptions.ErrorResponse;
import javax.persistence.PersistenceContext;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author BDIC
 */
@WebServlet("/api/faculties3")
public class FacultiesServlet extends HttpServlet {
       @PersistenceContext(unitName = "JakartaDS")
    private EntityManager em;
    
     private static EntityManagerFactory emf;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try (EntityManager em = emf.createEntityManager()) {
            List<FacultiesDirectorates> list = em.createNamedQuery("FacultiesDirectorates.findAll", FacultiesDirectorates.class)
                                                .getResultList();

            if (list.isEmpty()) {
                JsonUtil.writeJson(resp, HttpServletResponse.SC_NOT_FOUND, new ErrorResponse("No faculties found"));
                return;
            }

            List<FacultiesDirectoratesDTO> dtoList = list.stream()
                .map(f -> new FacultiesDirectoratesDTO(f.getId(), f.getName(), f.getCode()))
                .toList();

            JsonUtil.writeJson(resp, HttpServletResponse.SC_OK, dtoList);
        }
    }
}

