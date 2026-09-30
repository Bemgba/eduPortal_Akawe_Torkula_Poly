/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.downloads;

import com.mnl.eduportal.entities.Admissions;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Olevelresults;
import com.mnl.eduportal.entities.Olevelresultsitems;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.write.Alignment;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

/**
 *
 * @author nguuma-ayua
 */
public class DownloadadmissionlistPG extends HttpServlet {

    @Inject
    private MainSession sess;
    Settings settings = new Settings();
    NumberFormat formatter = new NumberFormat("###,###,###,###,###,###,###,###.00");

    DecimalFormat df = new DecimalFormat("0.00");

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
        List<Admissions> appl = new ArrayList();
        String idx = request.getParameter("id");
        if (idx != null && idx.length() > 0) {
            idx = settings.decryptText(idx);
            appl = sess.getAdmissionsByCourseStatus("ALL", idx, "ALL", "ALL","S002",1002);
            appl.addAll(sess.getAdmissionsByCourseStatus("ALL", idx, "ALL", "ALL","S002",1004));
            appl.addAll(sess.getAdmissionsByCourseStatus("ALL", idx, "ALL", "ALL","S002",1005));
        }
        if (idx != null && appl != null && !appl.isEmpty()) {
            String filename = ("AdmissionList" + idx.replaceAll("/", "_")) + ".xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment; filename=" + filename);

            try {

                WorkbookSettings wbSettings = new WorkbookSettings();
                wbSettings.setRationalization(false);
                WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream(), wbSettings);
                WritableCellFormat cellFormat = new WritableCellFormat();
                cellFormat.setAlignment(Alignment.CENTRE); // Center align the text
                cellFormat.setWrap(true);
                WritableCellFormat cellFormat2 = new WritableCellFormat();
                cellFormat2.setBorder(Border.ALL, BorderLineStyle.THIN); // Apply thin borders to all sides

                WritableCellFormat cellFormat3 = new WritableCellFormat();
                cellFormat3.setAlignment(Alignment.RIGHT); // Set text alignment to right
                cellFormat3.setBorder(Border.ALL, BorderLineStyle.THIN);
                // WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
                WritableSheet wsheet0 = wworkbook.createSheet("admission_list", 0);
                int m0 = 0;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                m0++;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, idx + " ADMISION LIST ", cellFormat2));
                m0++;

                // Create a row and put some cells in it. Rows are 0 based.
                wsheet0.addCell(new Label(0, m0, "SNO", cellFormat2));
                wsheet0.addCell(new Label(1, m0, "FACULTY", cellFormat2));
                wsheet0.addCell(new Label(2, m0, "DEPARTMENT", cellFormat2));
                wsheet0.addCell(new Label(3, m0, "COURSE", cellFormat2));
                wsheet0.addCell(new Label(4, m0, "REG_NO", cellFormat2));
                wsheet0.addCell(new Label(5, m0, "SURNAME", cellFormat2));
                wsheet0.addCell(new Label(6, m0, "OTHER NAMES", cellFormat2));
                wsheet0.addCell(new Label(7, m0, "DATE OF BIRTH", cellFormat2));
                wsheet0.addCell(new Label(8, m0, "GENDER", cellFormat2));
                wsheet0.addCell(new Label(9, m0, "STATE", cellFormat2));
                wsheet0.addCell(new Label(10, m0, "LGA", cellFormat2));
                wsheet0.addCell(new Label(11, m0, "MOE", cellFormat2));
                wsheet0.addCell(new Label(12, m0, "MERIT TYPE", cellFormat2));
                wsheet0.addCell(new Label(13, m0, "STATUS", cellFormat2));
                m0++;

                int k = 1;
                for (Admissions det : appl) {
                    wsheet0.addCell(new Label(0, m0, k + "", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, det.getCourseId().getDepartmentId().getFacultyId().getName(), cellFormat2));
                    wsheet0.addCell(new Label(2, m0, det.getCourseId().getDepartmentId().getName(), cellFormat2));
                    wsheet0.addCell(new Label(3, m0, det.getCourseId().getName(), cellFormat2));
                    wsheet0.addCell(new Label(4, m0, det.getId().toUpperCase(), cellFormat2));
                    wsheet0.addCell(new Label(5, m0, det.getSurname(), cellFormat2));
                    wsheet0.addCell(new Label(6, m0, det.getOthernames(), cellFormat2));
                    wsheet0.addCell(new Label(7, m0, det.getDateOfBirth(), cellFormat2));
                    wsheet0.addCell(new Label(8, m0, det.getGender(), cellFormat2));
                    String state = "";
                    String lga = "";
                    try {
                        det.getStateOfOriginId().getName();
                        lga = det.getLgaId().getName();
                    } catch (Exception k2) {
                    }
                    wsheet0.addCell(new Label(9, m0, state, cellFormat2));
                    wsheet0.addCell(new Label(10, m0, lga, cellFormat2));
                    wsheet0.addCell(new Label(11, m0, det.getModeOfEntry(), cellFormat2));
                    wsheet0.addCell(new Label(12, m0, det.getMeritType(), cellFormat2));
                    wsheet0.addCell(new Label(13, m0, det.getAdmissionStatus(), cellFormat2));
                    k++;
                    m0 ++;

                }
//listnonrec;
//merit;

                /////////////////////////////////////////////
                try {
                    wworkbook.write();
                    wworkbook.close();
                } catch (Exception u) {
                }

            } catch (IOException | WriteException jn) {
            }
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
