/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.apis;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.mnl.eduportal.entities.Feesgroup;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.apis.PaymentRequests;
import com.mnl.eduportal.util.apis.PaymentResponse;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author eaglescan
 */
@WebServlet(name = "StudentPayment", urlPatterns = {"/BSUidcard/StudentPayment"})
public class StudentPayment extends HttpServlet {

    @Inject
    private MainSession sess;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         
       response.setContentType("application/json");
        Gson gson = new Gson();
        try {
            StringBuilder sb = new StringBuilder();
            String s;
            while ((s = request.getReader().readLine()) != null) {
                sb.append(s);
            }
            PaymentRequests req = null;
            PaymentResponse rp = null;
            try {
                req = (PaymentRequests) gson.fromJson(sb.toString(), PaymentRequests.class);
            } catch (JsonSyntaxException j) {
            }
            if (req != null) {
                String regno = req.getRegno().toLowerCase();
                String session = req.getSessions();
                String semester = req.getSemester();
                
                // validate reg no
                Students std = sess.getStudentsById(regno);
                if (std != null) {
                    
                    String paytype ="";
                    Feesgroup fg = sess.getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if(fg  != null){
                        paytype = fg.getId();
                    }
                    List<Payments> pays = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), paytype, session, semester);
                    if(!pays.isEmpty()){
                        String paid = "Success";
                        rp = new PaymentResponse(paid);
                    }else{
                        String paid = "Not Paid";
                        rp = new PaymentResponse(paid);
                    }
                   
                }

            } else {

            }
            response.getOutputStream().print(gson.toJson(rp));
        } catch (IOException k) {
            //k.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}