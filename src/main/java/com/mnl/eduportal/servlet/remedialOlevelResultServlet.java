/*
 * Remedial O-Level Result Servlet
 */
package com.mnl.eduportal.servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import com.mnl.eduportal.entities.Olevelresults;
import com.mnl.eduportal.entities.Olevelresultsitems;
import com.mnl.eduportal.entities.Olevelgrades;
import com.mnl.eduportal.entities.Olevelsubjects;

/**
 * Handles retrieval and saving of O-Level results.
 * @author BDIC
 */
@WebServlet("/OlevelResultServlet")
public class remedialOlevelResultServlet extends HttpServlet {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("JakartaDS");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager em = emf.createEntityManager();
        try {
            // Fetch grades (order by score ascending, then id for consistency)
            List<Olevelgrades> grades = em.createQuery(
                    "SELECT g FROM Olevelgrades g ORDER BY g.score ASC, g.id ASC",
                    Olevelgrades.class
            ).getResultList();

            // Fetch active subjects
            List<Olevelsubjects> subjects = em.createQuery(
                    "SELECT s FROM Olevelsubjects s WHERE s.status = :status ORDER BY s.name ASC",
                    Olevelsubjects.class
            )
            .setParameter("status", "ACTIVE")
            .getResultList();
            // Put them in request scope for JSP
            request.setAttribute("grades", grades);
            request.setAttribute("subjects", subjects);

            // Forward to JSP form page (ensure file exists in webapp folder)
            request.getRequestDispatcher("/remedialOlevelForm.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();

        try {
            tx.begin();

            //Parent result
            Olevelresults result = new Olevelresults();
            result.setId(UUID.randomUUID().toString());
            result.setName(request.getParameter("name"));
            result.setResultType(request.getParameter("resultType"));
            result.setRegistrationNo(request.getParameter("registrationNo"));
            result.setUserId(request.getParameter("userId"));
            result.setExamDate(request.getParameter("examDate"));
            result.setSitting(request.getParameter("sitting"));
            result.setDateAdded(new Date());
            result.setVerificationStatus("Pending");

            em.persist(result);

            // Children (loop over submitted subjects)
            int i = 0;
            while (request.getParameter("subject[" + i + "]") != null) {
                String subjId = request.getParameter("subject[" + i + "]");
                String gradeId = request.getParameter("grade[" + i + "]");

                if (subjId != null && gradeId != null) {
                    Olevelsubjects subjEntity = em.find(Olevelsubjects.class, subjId);
                    Olevelgrades gradeEntity = em.find(Olevelgrades.class, gradeId);

                    Olevelresultsitems item = new Olevelresultsitems();
                    item.setId(UUID.randomUUID().toString());

                    // Save subject name string instead of full entity
                    if (subjEntity != null) {
                        item.setSubject(subjEntity.getName());
                    } else {
                        item.setSubject(subjId); // fallback if not found
                    }

                    item.setGrade(gradeEntity);
                    item.setOlevelResultsId(result);
                    item.setDateAdded(new Date());
                    item.setVerificationStatus("Pending");

                    em.persist(item);
                }
                i++;
            }

            tx.commit();
            response.sendRedirect("success.jsp");

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new ServletException("Error saving O-Level result", e);
        } finally {
            em.close();
        }
    }
}
