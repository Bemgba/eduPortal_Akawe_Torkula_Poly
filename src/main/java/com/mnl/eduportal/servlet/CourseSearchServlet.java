/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.servlet;
import java.io.IOException;
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
import java.util.ArrayList;
import java.util.List;
import javax.persistence.PersistenceUnit;

/**
 *
 * @author BDIC
 */
@WebServlet("/api/courses/search3")
public class CourseSearchServlet extends HttpServlet {
    @PersistenceUnit(unitName = "JakartaDS")
    private EntityManagerFactory emf;

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
    String letter = req.getParameter("letter");
    if (letter == null || letter.isEmpty()) {
        safeWriteJson(resp, HttpServletResponse.SC_BAD_REQUEST, new ErrorResponse("letter is required"));
        return;
    }

    try (EntityManager em = emf.createEntityManager()) {
        List<Courses> list = em.createQuery(
                "SELECT c FROM Courses c WHERE UPPER(c.name) LIKE :prefix", Courses.class)
            .setParameter("prefix", letter.toUpperCase() + "%")
            .getResultList();

        if (list.isEmpty()) {
            safeWriteJson(resp, HttpServletResponse.SC_NOT_FOUND, 
                new ErrorResponse("No courses found starting with: " + letter));
            return;
        }

        List<CoursesDTO> dtoList = list.stream()
            .map(c -> new CoursesDTO(c.getId(), c.getName(), c.getCode(), c.getDepartmentId().getId()))
            .toList();

        safeWriteJson(resp, HttpServletResponse.SC_OK, dtoList);

    } catch (Exception e) {
        // If any other unexpected error occurs
        safeWriteJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
            new ErrorResponse("Unexpected error: " + e.getMessage()));
    }
}

/**
 * Utility method to safely write JSON without letting IOException propagate.
 */
private void safeWriteJson(HttpServletResponse resp, int status, Object body) {
    try {
        JsonUtil.writeJson(resp, status, body);
    } catch (IOException e) {
        // Last resort logging - don’t rethrow
        e.printStackTrace();
    }
}

}

