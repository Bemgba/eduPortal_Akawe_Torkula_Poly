/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.PostUTMEUploadDetails;
import com.mnl.eduportal.util.Settings;
import jakarta.fileupload.FileItem;
import jakarta.fileupload.FileUploadException;
import jakarta.fileupload.disk.DiskFileItemFactory;
import jakarta.fileupload.servlet.ServletFileUpload;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
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
        fileSizeThreshold = 1024 * 1024 * 20, // 20MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class UploadUTMEPostutme extends HttpServlet {

    @Inject
    private MainSession sess;
    private ExecutorService executor = Executors.newFixedThreadPool(4); // Thread pool for async tasks
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

        String filename = "PostUTMEUploadReport.xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);
        List<PostUTMEUploadDetails> al = new ArrayList();
        try {
            int maxFileSize = 2000 * 1024;
            int maxMemSize = 2000 * 1024;
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(maxMemSize);

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(maxFileSize);

            //FileItemFactory factory = new DiskFileItemFactory();
            // Create a new file upload handler
            //ServletFileUpload upload = new ServletFileUpload(factory);
            String msg = "";
            String sessiond = "";
            Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
            if (sessmanx != null) {
                sessiond = sessmanx.getName();
            }
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
                                    PostUTMEUploadDetails det = new PostUTMEUploadDetails();
                                    String remarks;
                                    String fullname = " ";
                                    String course = " ";
                                    String sno = sheet.getCell(0, row).getContents();
                                    String regno = sheet.getCell(1, row).getContents();
                                    String sscore = sheet.getCell(2, row).getContents();
                                    if (regno != null) {
                                        regno = regno.trim().toLowerCase();
                                    }
                                    det.setSno(sno);
                                    det.setRegno(regno);
                                    det.setScore(sscore);

                                    Applicantsutme utme = sess.getApplicantsutme(regno);
                                    Applicants app = sess.getApplicants(regno);

                                    if (utme != null && app != null) {
                                        fullname = app.getSurname() + " " + app.getOthernames();
                                        course = app.getCourse1().getName();
                                        if (app.getSession().equalsIgnoreCase(sessiond)) {

                                            int score = -1;
                                            try {
                                                sscore = sscore.trim();
                                                score = Integer.parseInt(sscore);
                                            } catch (Exception k) {
                                            }
                                            if (score < 0) {
                                                remarks = "Invalid Score: " + sscore;
                                            } else {
                                                if (score > 100) {
                                                    remarks = "Invalid Score: " + sscore;
                                                } else {
                                                    utme.setPostUtme(score);
                                                    sess.updateApplicantsUtmescore(regno, score);
                                                    remarks = "SUCCESS";
                                                }
                                            }
                                        } else {
                                            remarks = "JAMB Number: " + regno + " is in different session " + app.getSession();
                                        }

                                    } else {
                                        remarks = "JAMB Number: " + regno + " not found";
                                    }
                                    det.setFullname(fullname);
                                    det.setCourse(course);
                                    det.setRemarks(remarks);
                                    al.add(det);
                                } catch (Exception j) {
                                }
                            }

                            try {
                                WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
                                WritableSheet wsheet = wworkbook.createSheet("UploadReport", 0);

                                // Create a row and put some cells in it. Rows are 0 based.
                                wsheet.addCell(new Label(0, 0, "SNO"));
                                wsheet.addCell(new Label(1, 0, "REGNO"));
                                wsheet.addCell(new Label(2, 0, "FULLNAME"));
                                wsheet.addCell(new Label(3, 0, "COURSE"));
                                wsheet.addCell(new Label(4, 0, "SCORE"));
                                wsheet.addCell(new Label(5, 0, "REMARKS"));
                                int i = 1;
                                for (PostUTMEUploadDetails dd : al) {
                                    wsheet.addCell(new Label(0, i, dd.getSno()));
                                    wsheet.addCell(new Label(1, i, dd.getRegno()));
                                    wsheet.addCell(new Label(2, i, dd.getFullname()));
                                    wsheet.addCell(new Label(3, i, dd.getCourse()));
                                    wsheet.addCell(new Label(4, i, dd.getScore()));
                                    wsheet.addCell(new Label(5, i, dd.getRemarks()));
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
