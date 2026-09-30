/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Admissions;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.AdmissionUploadReport;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

/**
 *
 * @author nguuma-ayua
 */
@MultipartConfig
public class UploadPGAdmissionlist extends HttpServlet {

    @Inject
    private MainSession sess;
    Settings settings = new Settings();

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
        Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");

        String courseId = request.getParameter("courses");
        if (courseId == null || courseId.isEmpty()) {
            response.getWriter().println("Error: Please select a course.");
            return;
        }

        Part filePart = request.getPart("uploadfile");

        String filename = "AdmissionUploadReport_" + courseId + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);

        String fileName = filePart.getSubmittedFileName();
        InputStream fileContent = filePart.getInputStream();

        List<AdmissionUploadReport> report = new ArrayList();
        Workbook w;
        try {
            w = Workbook.getWorkbook(fileContent);
            Sheet sheet = w.getSheet(0);
            String error = "No";
            for (int row = 1; row < sheet.getRows(); row++) {
                try {
                    AdmissionUploadReport det = new AdmissionUploadReport();
                    String remarks;
                    String sno = sheet.getCell(0, row).getContents();
                    String appno = sheet.getCell(1, row).getContents();
                    String moe = "POST GRADUATE";
                    String meritstatus = "MERIT";
                    det.setRegno(appno);

                    if (appno != null) {
                        appno = appno.trim().toLowerCase();
                        Applicants app = sess.getApplicantsById(appno);
                        if (app != null) {
                            if (app.getSession().equalsIgnoreCase(sessmanx.getName())) {
                                Courses cos = sess.getCourses(courseId);
                                if (cos != null) {
                                    Admissions adm = new Admissions(appno);
                                    adm.setAdmissionStatus("PENDING");
                                    adm.setAdmissionStatusComment("");
                                    adm.setDateAdded(settings.getCurrentDateTime());
                                    adm.setCourseId(cos);
                                    adm.setDateOfBirth(app.getDateOfBirth());
                                    adm.setGender(app.getGender());
                                    adm.setLgaId(app.getLga());
                                    adm.setMaritalStatus(app.getMaritalStatus());
                                    adm.setMeritType(meritstatus);
                                    adm.setModeOfEntry(moe);
                                    adm.setNationalityId(app.getCountry());
                                    adm.setOthernames(app.getOthernames());
                                    adm.setProgrammeId(app.getProgrammeId());
                                    adm.setRegistrationNo(app.getId());
                                    adm.setReligion("");
                                    adm.setSchoolId(app.getSchoolId());
                                    adm.setSession(sessmanx.getName());
                                    adm.setStateOfOriginId(app.getStateOfOrigin());
                                    adm.setSurname(app.getSurname());
                                    sess.addUpdateAdmission(adm);
                                    det.setCourseadm(cos.getName());
                                    det.setRemarks("SUCCESS");
                                    det.setAdmcriteria(meritstatus);
                                    sess.changeApplicantStatus(appno,"ADMITTED");
                                }

                            } else {
                                det.setAdmcriteria("");
                                det.setCourseadm("");
                                det.setRemarks("Applicant not in current session");
                            }
                            det.setCourse(app.getCourse1().getName());
                            det.setFullname(app.getSurname() + " " + app.getOthernames());
                        }
                    } else {
                        det.setCourse("");
                        det.setAdmcriteria("");
                        det.setCourseadm("");
                        det.setRemarks("Application records does not exist");
                    }
                    
                    report.add(det);

                } catch (Exception l) {
                }
            }
        } catch (Exception k) {
        }

        try {
            WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
            WritableSheet wsheet = wworkbook.createSheet("UploadReport", 0);

            // Create a row and put some cells in it. Rows are 0 based.
            wsheet.addCell(new Label(0, 0, "SNO"));
            wsheet.addCell(new Label(1, 0, "JAMB NO"));
            wsheet.addCell(new Label(2, 0, "FULLNAME"));
            wsheet.addCell(new Label(3, 0, "COURSE APPLIED"));
            wsheet.addCell(new Label(4, 0, "COURSE ADMITTED"));
            wsheet.addCell(new Label(5, 0, "CRITERIA"));
            wsheet.addCell(new Label(6, 0, "REMARKS"));
            int i = 1;
            for (AdmissionUploadReport dd : report) {
                wsheet.addCell(new Label(0, i, i + ""));
                wsheet.addCell(new Label(1, i, dd.getRegno().toUpperCase()));
                wsheet.addCell(new Label(2, i, dd.getFullname()));
                wsheet.addCell(new Label(3, i, dd.getCourse()));
                wsheet.addCell(new Label(4, i, dd.getCourseadm()));
                wsheet.addCell(new Label(5, i, dd.getAdmcriteria()));
                wsheet.addCell(new Label(6, i, dd.getRemarks()));
                i++;
            }
            wworkbook.write();
            wworkbook.close();
        } catch (IOException | WriteException js) {
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
