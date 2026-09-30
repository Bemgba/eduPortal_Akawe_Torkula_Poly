/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Olevelresults;
import com.mnl.eduportal.entities.Olevelresultsitems;
import com.mnl.eduportal.entities.Olevelsubjects;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.reports.UploadReport;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

/**
 *
 * @author eaglescan
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 20, // 20MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class UploadUTMEOLevel extends HttpServlet {
    
    @Inject
    private MainSession sess;
    private ExecutorService executor = Executors.newFixedThreadPool(4); // Thread pool for async tasks

    static final Settings settings = new Settings();
    private static final String UPLOAD_DIRECTORY = settings.documentroot+"/passports";

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
        Part filePart = request.getPart("list3"); // Get uploaded file
        String userId = request.getParameter("id");
        if (userId != null && userId.trim().length() > 0) {
            userId = settings.decryptText(userId);
            Users user = sess.getUsers(userId);
            if (user == null) {
                userId = null;
            }
        }
        
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Save the file temporarily
        Path tempFile = Files.createTempFile("upload_", "_" + fileName);
        //Path tempFile = Files.createTempFile(UPLOAD_DIRECTORY + "/tmps", fileName);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, tempFile, StandardCopyOption.REPLACE_EXISTING);
        }

        // Asynchronous file processing
        executor.submit(() -> {
            try {
                processExcelFile(tempFile.toFile());
            } catch (Exception e) {
            } finally {
                tempFile.toFile().delete(); // Clean up temporary file
            }
        });
        String msg = "File uploaded successfully. Processing will continue in the background.";
        response.sendRedirect("/app_de_adm_upload?msg=" + msg);
    }
    
    private void processExcelFile(File file) {
        try (InputStream fis = new FileInputStream(file)) {
            String userId = null;
            List<UploadReport> al = new ArrayList();
            try {

                //FileItemFactory factory = new DiskFileItemFactory();
                // Create a new file upload handler
                //ServletFileUpload upload = new ServletFileUpload(factory);
                String msg;
                try {
                    
                    Workbook w;
                    try {
                        w = Workbook.getWorkbook(fis);
                        Sheet sheet = w.getSheet(0);
                        for (int row = 1; row < sheet.getRows(); row++) {
                            try {
                                UploadReport det = new UploadReport();
                                String remarks;
                                String id = sheet.getCell(0, row).getContents();
                                if(id.equalsIgnoreCase("202440202794ef")){
                                }
                                String subj = sheet.getCell(1, row).getContents();
                                String grade = sheet.getCell(2, row).getContents();
                                String series = sheet.getCell(3, row).getContents();
                                String examyear = sheet.getCell(4, row).getContents();
                                String examtype = sheet.getCell(5, row).getContents();
                                String examnumber = sheet.getCell(6, row).getContents();
                                
                                id = id.trim();
                                try {
                                    id = id.toLowerCase();
                                    id = id.trim();
                                    subj = subj.trim();
                                } catch (Exception j) {
                                }
                                
                                Applicants appx = sess.getApplicantsById(id);
                                if (appx != null) {
                                    
                                    Olevelsubjects ols = sess.getOlevelsubjects(subj);
                                    if (ols == null) {
                                        try {
                                            ols = new Olevelsubjects(settings.generateId("s", 6));
                                            ols.setName(subj);
                                            ols.setStatus("ACTIVE");
                                            sess.newEntry(ols);
                                        } catch (Exception k) {
                                        }
                                    }
                                    
                                    Olevelresults olr = sess.getOlevelresults(id);
                                    if (olr == null) {
                                        String sittings = "0";
                                        if (grade.equalsIgnoreCase("A/R")) {
                                            sittings = "0";
                                        } else {
                                            sittings = "1";
                                        }
                                        if (examtype != null) {
                                            if (examtype.contains("/")
                                                    || examtype.contains("&")
                                                    || examtype.contains("and")) {
                                                sittings = "2";
                                            }
                                        }
                                        try {
                                            olr = new Olevelresults(id);
                                            olr.setDateAdded(settings.getCurrentDateTime());
                                            olr.setExamDate(examyear);
                                            olr.setName(series);
                                            olr.setRegistrationNo(examnumber);
                                            olr.setResultType(examtype);
                                            olr.setSitting(sittings);
                                            olr.setUserId(userId);
                                            olr.setVerificationStatus("PENDING");
                                            sess.newEntry(olr);
                                        } catch (Exception k) {
                                        }
                                    } else {
                                        String sit = olr.getSitting();
                                        String regno = olr.getRegistrationNo();
                                        if (!regno.equalsIgnoreCase(examnumber)) {
                                            
                                            if (sit.equalsIgnoreCase("1")) {
                                                olr.setSitting("2");
                                            }
                                        }
                                        if (sit.equalsIgnoreCase("0") && !grade.equalsIgnoreCase("A/R")) {
                                            olr.setSitting("2");
                                        }
                                        sess.updateRecord(olr);
                                    }
                                    
                                    Olevelresultsitems olrv = sess.getOlevelresultsitem(id, subj);
                                    if (olrv != null) {
                                        olrv.setGrade(sess.getOlevelgrades(grade));
                                        olrv.setDateAdded(settings.getCurrentDateTime());
                                        sess.updateRecord(olrv);
                                        remarks = "Records updated";
                                    } else {
                                        
                                        String id3 = settings.generateId("r", 7);
                                        olrv = new Olevelresultsitems(id3);
                                        olrv.setDateAdded(settings.getCurrentDateTime());
                                        olrv.setGrade(sess.getOlevelgrades(grade));
                                        olrv.setOlevelResultsId(olr);
                                        olrv.setSubject(subj);
                                        olrv.setVerificationStatus("PENDING");
                                        olrv.setOlevelResultsId(olr);
                                        sess.newOlevelItem(olrv);
                                        remarks = "New record added";
                                    }
                                    
                                } else {
                                    remarks = "UTME number " + id.toUpperCase() + " does not exist";
                                }
                                
                                det.setId(id + " " + subj + " " + grade);
                                det.setDetails(remarks);
                                
                                al.add(det);
                            } catch (Exception j) {
                            }
                        }
                        /**
                         * try { WritableWorkbook wworkbook =
                         * Workbook.createWorkbook(response.getOutputStream());
                         * WritableSheet wsheet =
                         * wworkbook.createSheet("UploadReport", 0);
                         *
                         * // Create a row and put some cells in it. Rows are 0
                         * based. wsheet.addCell(new Label(0, 0, "SNO"));
                         * wsheet.addCell(new Label(1, 0, "DETAILS"));
                         * wsheet.addCell(new Label(2, 0, "REMARKS")); int i =
                         * 1; for (UploadReport dd : al) { wsheet.addCell(new
                         * Label(0, i, i + "")); wsheet.addCell(new Label(1, i,
                         * dd.getId())); wsheet.addCell(new Label(2, i,
                         * dd.getDetails())); i++; } wworkbook.write();
                         * wworkbook.close(); } catch (IOException |
                         * WriteException js) { }
                         *
                         *
                         */
                    } catch (BiffException e) {
                    }
                    
                } catch (Exception fx) {
                }
            } catch (Exception js) {
            }
        } catch (Exception e) {
        }
    }
    
    @Override
    public void destroy() {
        executor.shutdown();
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
