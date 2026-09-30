/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.reports.UploadReport;
import jakarta.fileupload.FileItem;
import jakarta.fileupload.disk.DiskFileItemFactory;
import jakarta.fileupload.servlet.ServletFileUpload;
import jakarta.inject.Inject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import jxl.Workbook;
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
@WebServlet(name = "UploadUTMEPassports", urlPatterns = {"/UploadUTMEPassports"})
public class UploadUTMEPassports extends HttpServlet {

    

    @Inject
    private MainSession sess;

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UploadUTMEPassports</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UploadUTMEPassports at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
            
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
        String filename = "UploadReport_" + "Passport_Upload_Report" + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);

        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                List<UploadReport> al = new ArrayList();
                // Get the upload directory
                String uploadPath = UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Parse the request
                ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
                List<FileItem> formItems = upload.parseRequest(request);

                // Process each uploaded file
                for (FileItem item : formItems) {
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        String id = "";
                        try {
                            id = fileName.toLowerCase();
                        } catch (Exception d) {
                        }
                        byte[] image = item.get();
                        UploadReport data = new UploadReport();

                        String msg = "";
                        if (image != null && fileName.contains(".jpg")) {
                            if (id.contains("_face")) {
                                id = id.replace("_face", "");
                                id = id.replaceAll(" ", "");

                            }
                            data.setId(id.toUpperCase());
                            String idx = id.substring(0, id.indexOf("."));

                            Applicants app = sess.getApplicants(idx);
                            if (app != null) {
                                Passports passp = sess.getPassports(idx);
                                if (passp != null) {
                                    msg = "Passport updated";
                                } else {
                                    msg = "New passport uploaded";
                                }
                                String filePath = uploadPath + File.separator + id;
                                File storeFile = new File(filePath);
                                item.write(storeFile); // Save file to disk

                                sess.savePassport(idx, "passports/" + id);
                            } else {
                                msg = "Pasport can not be uploaded. No applicant found matching " + idx.toUpperCase();
                            }

                            data.setDetails(msg);
                            al.add(data);
                            //item.delete();
                        } else {
                            msg = "No registration Number or specified image format";
                        }

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

            } catch (Exception ex) {
            }
        } else {
        }
        response.sendRedirect("/app_adm_upload");

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
