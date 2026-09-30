/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.downloads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Olevelresults;
import com.mnl.eduportal.entities.Olevelresultsitems;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
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
 * @author eaglescan
 */
@WebServlet(name = "DownloadUTMEList", urlPatterns = {"/DownloadUTMEList"})
public class DownloadUTMEList extends HttpServlet {

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
        List<Applicants> appl = new ArrayList();
        String idx = request.getParameter("id");
        if (idx != null && idx.length() > 0) {
            idx = settings.decryptText(idx);
            appl = sess.getApplicantsByTypeSessionStatus(idx, "ALL", "UTME");
        }
        if (idx != null && appl != null && !appl.isEmpty()) {
            String filename = ("UTMEApplicans" + idx.replaceAll("/", "_")) + ".xls";
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
                WritableSheet wsheet0 = wworkbook.createSheet("statistics", 0);
                WritableSheet wsheet1 = wworkbook.createSheet("utme_list", 1);
                int m0 = 0;
                int m1 = 0;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, "BENUE STATE UNIVERSITY P.M.B. 102119 MAKURDI, BENUE STATE", cellFormat));
                m0++;
                wsheet1.mergeCells(0, m1, 22, m1);
                wsheet1.addCell(new Label(0, m1, "BENUE STATE UNIVERSITY P.M.B. 102119 MAKURDI, BENUE STATE", cellFormat));
                m1++;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, idx + " UTME STATISTICS ", cellFormat2));
                m0++;
                wsheet1.mergeCells(0, m1, 22, m1);
                wsheet1.addCell(new Label(0, m1, idx + " UTME LIST", cellFormat2));
                m1++;

                

                // Create a row and put some cells in it. Rows are 0 based.
                wsheet1.addCell(new Label(0, m1, "SNO", cellFormat2));
                wsheet1.addCell(new Label(1, m1, "FACULTY", cellFormat2));
                wsheet1.addCell(new Label(2, m1, "DEPARTMENT", cellFormat2));
                wsheet1.addCell(new Label(3, m1, "COURSE", cellFormat2));
                wsheet1.addCell(new Label(4, m1, "REG_NO", cellFormat2));
                wsheet1.addCell(new Label(5, m1, "SURNAME", cellFormat2));
                wsheet1.addCell(new Label(6, m1, "OTHER NAMES", cellFormat2));
                wsheet1.addCell(new Label(7, m1, "DATE OF BIRTH", cellFormat2));
                wsheet1.addCell(new Label(8, m1, "GENDER", cellFormat2));
                wsheet1.addCell(new Label(9, m1, "STATE", cellFormat2));
                wsheet1.addCell(new Label(10, m1, "LGA", cellFormat2));
                wsheet1.addCell(new Label(11, m1, "PHONE NO", cellFormat2));
                wsheet1.addCell(new Label(12, m1, "EMAIL ADD", cellFormat2));
                wsheet1.addCell(new Label(13, m1, "ENG", cellFormat2));
                wsheet1.addCell(new Label(14, m1, "SUBJ2", cellFormat2));
                wsheet1.addCell(new Label(15, m1, "SUBJ2 SCORE", cellFormat2));
                wsheet1.addCell(new Label(16, m1, "SUBJ3", cellFormat2));
                wsheet1.addCell(new Label(17, m1, "SUBJ3 SCORE", cellFormat2));
                wsheet1.addCell(new Label(18, m1, "SUBJ4", cellFormat2));
                wsheet1.addCell(new Label(19, m1, "SUBJ4 SCORE", cellFormat2));
                wsheet1.addCell(new Label(20, m1, "JAMB SCORE", cellFormat2));
                wsheet1.addCell(new Label(21, m1, "POST UTME SCORE", cellFormat2));
                wsheet1.addCell(new Label(22, m1, "STATUS", cellFormat2));
                wsheet1.addCell(new Label(23, m1, "O-LEVEL SUBJECTS", cellFormat2));
                m1++;

                int k = 1;
                for (Applicants det : appl) {
                    wsheet1.addCell(new Label(0, m1, k + "", cellFormat2));
                    wsheet1.addCell(new Label(1, m1, det.getCourse1().getDepartmentId().getFacultyId().getName(), cellFormat2));
                    wsheet1.addCell(new Label(2, m1, det.getCourse1().getDepartmentId().getName(), cellFormat2));
                    wsheet1.addCell(new Label(3, m1, det.getCourse1().getName(), cellFormat2));
                    wsheet1.addCell(new Label(4, m1, det.getId().toUpperCase(), cellFormat2));
                    wsheet1.addCell(new Label(5, m1, det.getSurname(), cellFormat2));
                    wsheet1.addCell(new Label(6, m1, det.getOthernames(), cellFormat2));
                    wsheet1.addCell(new Label(7, m1, det.getDateOfBirth(), cellFormat2));
                    wsheet1.addCell(new Label(8, m1, det.getGender(), cellFormat2));
                    String state = "";
                    String lga = "";
                    try {
                        det.getStateOfOrigin().getName();
                        lga = det.getLga().getName();
                    } catch (Exception k2) {
                    }
                    wsheet1.addCell(new Label(9, m1, state, cellFormat2));
                    wsheet1.addCell(new Label(10, m1, lga, cellFormat2));
                    wsheet1.addCell(new Label(11, m1, det.getPhoneNo(), cellFormat2));
                    wsheet1.addCell(new Label(12, m1, det.getEmailAddress(), cellFormat2));

                    Applicantsutme utme = det.getApplicantsutme();
                    if (utme != null) {
                        wsheet1.addCell(new jxl.write.Number(13, m1, utme.getEngScore(), cellFormat2));
                        wsheet1.addCell(new Label(14, m1, utme.getSubj2(), cellFormat2));
                        wsheet1.addCell(new jxl.write.Number(15, m1, utme.getSubj2Score(), cellFormat2));
                        wsheet1.addCell(new Label(16, m1, utme.getSubj3(), cellFormat2));
                        wsheet1.addCell(new jxl.write.Number(17, m1, utme.getSubj3Score(), cellFormat2));
                        wsheet1.addCell(new Label(18, m1, utme.getSubj4(), cellFormat2));
                        wsheet1.addCell(new jxl.write.Number(19, m1, utme.getSubj4Score(), cellFormat2));
                        wsheet1.addCell(new jxl.write.Number(20, m1, utme.getTotalUtme(), cellFormat2));
                        // FIXED: Add null check for postUtme
                        Integer postUtme = utme.getPostUtme();
                        wsheet1.addCell(new jxl.write.Number(21, m1, postUtme != null ? postUtme : 0, cellFormat2));

                    }
                    wsheet1.addCell(new Label(22, m1, det.getStatus(), cellFormat2));
                    String olevel = "";
                    Olevelresults olr = sess.getOlevelresults(det.getId());
                    if (olr != null) {
                        olevel = olr.getResultType() + "= ";
                        List<Olevelresultsitems> olri = sess.getOlevelresultsItems(olr.getId());
                        for (Olevelresultsitems items : olri) {
                            //for (Olevelresultsitems items : olr.getOlevelresultsitemsCollection()) {
                            String olrid = items.getSubject() + ":(" + items.getGrade().getId() + "), ";
                            olevel += olrid;
                        }
                    }
                    wsheet1.addCell(new Label(23, m1, olevel, cellFormat2));

                    k++;

                }
//listnonrec;
//merit;
              long size = appl.size();
                long pendingapp = appl.stream().filter(oltype -> oltype.getStatus().equalsIgnoreCase("PENDING"))
                        .count();
                long registered = size - pendingapp;
                long indigene = appl.stream().filter(oltype -> oltype.getStateOfOrigin().getId() == settings.indigeneStateCode)
                        .count();
                long nonindigene = size - indigene;
                
                
                wsheet0.addCell(new Label(0, m0, "TOTAL APPLICATS", cellFormat2));
                wsheet0.addCell(new Label(1, m0, size + "", cellFormat2));
                m0++;

                wsheet0.addCell(new Label(0, m0, "REGISTERED APPLICATS", cellFormat2));
                wsheet0.addCell(new Label(1, m0, registered+"", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "NOT REGISTERED APPLICANTS", cellFormat2));
                wsheet0.addCell(new Label(1, m0, pendingapp + "", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "TOTAL INDIGENE", cellFormat2));
                wsheet0.addCell(new Label(1, m0, indigene + "", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "TOTAL NON_INDIGENE", cellFormat2));
                wsheet0.addCell(new Label(1, m0, nonindigene + "", cellFormat3));
                
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

    public static void downloadImage(String imageUrl, String savePath) throws Exception {
        URL url = new URL(imageUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.connect();

        if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
            try (InputStream inputStream = connection.getInputStream(); FileOutputStream outputStream = new FileOutputStream(savePath)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } else {
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
