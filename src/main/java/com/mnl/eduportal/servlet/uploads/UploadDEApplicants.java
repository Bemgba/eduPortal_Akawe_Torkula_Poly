/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Countries;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Lgas;
import com.mnl.eduportal.entities.Roles;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.States;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.reports.UploadReport;
import jakarta.fileupload.FileItem;
import jakarta.fileupload.FileUploadException;
import jakarta.fileupload.disk.DiskFileItemFactory;
import jakarta.fileupload.servlet.ServletFileUpload;
import jakarta.inject.Inject;
import java.util.Iterator;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
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
 * @author eaglescan
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class UploadDEApplicants extends HttpServlet {

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
        String userId = request.getParameter("id");
        if (userId != null && userId.trim().length() > 0) {
            userId = settings.decryptText(userId);
            Users user = sess.getUsers(userId);
            if (user == null) {
                userId = null;
            }
        }
        Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
        if (sessmanx != null) {
        }
        String filename = "UploadReport_" + "DE_Applicants" + "_" + sessmanx.getName().replaceAll("/", "_") + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);

        List<UploadReport> al = new ArrayList();
        try {
            int maxFileSize = 10 * 1024 * 1024;
            int maxMemSize = 10 * 1024 * 1024;
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(maxMemSize);

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(maxFileSize);

            //FileItemFactory factory = new DiskFileItemFactory();
            // Create a new file upload handler
            //ServletFileUpload upload = new ServletFileUpload(factory);
            String msg = "";
            try {
                List items = upload.parseRequest(request);
                Iterator iter = items.iterator();
                // int s = items.size();
                while (iter.hasNext()) {
                    FileItem item = (FileItem) iter.next();
                    if (!item.isFormField()) {
                        Workbook w;
                        try {
                            w = Workbook.getWorkbook(item.getInputStream());
                            Sheet sheet = w.getSheet(0);
                            String error = "No";
                            for (int row = 1; row < sheet.getRows(); row++) {
                                try {
                                    UploadReport det = new UploadReport();
                                    String remarks;
                                    String id = sheet.getCell(0, row).getContents();
                                    String name = sheet.getCell(1, row).getContents();
                                    String gender = sheet.getCell(2, row).getContents();
                                    String state = sheet.getCell(3, row).getContents();
                                    String course = sheet.getCell(4, row).getContents();
                                    String lga = sheet.getCell(6, row).getContents();
                                    id = id.trim();
                                    try {
                                        id = id.toLowerCase();
                                    } catch (Exception j) {
                                    }

                                    String surname = "";
                                    String othernames = "";
                                    try {
                                        String[] namex = name.split(" ");
                                        surname = namex[0];
                                        if (namex.length == 2) {
                                            othernames = (namex[1]).trim();
                                        } else {
                                            othernames = (namex[1] + " " + namex[2]).trim();
                                        }

                                    } catch (Exception d) {
                                    }

                                    try {
                                        if (gender.trim().equalsIgnoreCase("F")) {
                                            gender = "Female";
                                        } else {
                                            gender = "Male";
                                        }
                                    } catch (Exception k) {
                                    }

                                    Countries countryId = null;
                                    States stateId = null;
                                    Lgas lgaId = null;
                                    try {
                                        countryId = sess.getCountries("Nigeria");
                                    } catch (Exception k) {
                                    }
                                    try {
                                        stateId = sess.getStates(state, "Nigeria");
                                    } catch (Exception k) {
                                    }
                                    try {
                                        lgaId = sess.getLgas(lga, state);
                                    } catch (Exception k) {
                                    }

                                   
                                    Courses bsucourse = null;
                                    try {
                                        bsucourse = sess.getCoursesjambmapping(course.trim()).getCourses();
                                    } catch (Exception k) {
                                    }


                                    Applicants appx = sess.getApplicantsById(id);
                                    if (appx != null) {
                                        remarks = "Record already added";
                                    } else {
                                        if (bsucourse == null) {
                                            remarks = "No matching course found on the portal";
                                        } else {
                                           
                                                appx = new Applicants(id);
                                                appx.setApplicationType("DE");
                                                appx.setCountry(countryId);
                                                appx.setCourse1(bsucourse);
                                                appx.setDateCompleted(settings.getCurrentDateTime());
                                                appx.setDateInitiated(settings.getCurrentDateTime());
                                                appx.setGender(gender);
                                                appx.setLga(lgaId);
                                                appx.setOthernames(othernames);
                                                appx.setProgrammeId(bsucourse.getSchoolProgrammeId().getProgrammeId());
                                                appx.setSchoolId(bsucourse.getSchoolProgrammeId().getSchoolId());
                                                appx.setSession(sessmanx.getName());
                                                appx.setStateOfOrigin(stateId);
                                                appx.setStatus("PENDING");
                                                appx.setSurname(surname);

                                                sess.newEntry(appx);

                                                Users user = new Users(id);
                                                user.setPassword(id);
                                                user.setUsername(id);
                                                Roles ro = sess.getRoles(1063);
                                                user.setDefaultRole(ro);
                                                sess.newEntry(user);
                                                remarks = "Success";
                                            
                                        }
                                    }

                                    det.setId(id);
                                    det.setDetails(remarks);

                                    al.add(det);
                                } catch (Exception j) {
                                }
                            }

                            try {
                                WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
                                WritableSheet wsheet = wworkbook.createSheet("UploadReport", 0);

                                // Create a row and put some cells in it. Rows are 0 based.
                                wsheet.addCell(new Label(0, 0, "SNO"));
                                wsheet.addCell(new Label(1, 0, "REG_NO"));
                                wsheet.addCell(new Label(2, 0, "REMARKS"));
                                int i = 1;
                                for (UploadReport dd : al) {
                                    wsheet.addCell(new Label(0, i, i + ""));
                                    wsheet.addCell(new Label(1, i, dd.getId()));
                                    wsheet.addCell(new Label(2, i, dd.getDetails()));
                                    i++;
                                }
                                wworkbook.write();
                                wworkbook.close();
                            } catch (IOException | WriteException js) {
                            }
                        } catch (BiffException e) {
                        }
                    }
                }
            } catch (IOException | IndexOutOfBoundsException | FileUploadException fx) {
            }
        } catch (Exception js) {
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
