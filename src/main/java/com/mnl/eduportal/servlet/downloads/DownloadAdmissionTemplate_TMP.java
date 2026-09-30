/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.downloads;

import com.mnl.eduportal.entities.Admissiontemplate;
import com.mnl.eduportal.entities.Admissiontemplateolevel;
import com.mnl.eduportal.entities.Admissiontemplateutme;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.AdmTempOLDet;
import com.mnl.eduportal.util.AdmTempUTMEDet;
import com.mnl.eduportal.util.AdmissionTemplateUTME;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.write.Alignment;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.NumberFormat;
import jxl.write.WritableCellFormat;
import jxl.write.WritableImage;
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
public class DownloadAdmissionTemplate_TMP extends HttpServlet {

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
        Admissiontemplate admt = null;
        String idx = request.getParameter("idx");
        if (idx != null && idx.length() > 0) {
            idx = settings.decryptText(idx);
            admt = sess.getAdmissiontemplate(idx);
        }
        if (admt != null) {
            String filename = ("AdmissionTemplate_" + admt.getSession().replaceAll("/", "_") + "_" + admt.getCourse().getCode()).replaceAll("/", "_").replaceAll(" ", "") + ".xls";
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
                WritableSheet wsheet = wworkbook.createSheet("Recommended_Cases", 0);
                WritableSheet wsheet2 = wworkbook.createSheet("Non_Recommended_Cases", 1);
                int i = 0;
                int m = 0;

                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                i++;
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                i++;
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, " RECOMMENDED CASES", cellFormat2));
                i++;
                
                wsheet2.mergeCells(0, m, 38, m);
                wsheet2.addCell(new Label(0, m, "BENUE STATE UNIVERSITY P.M.B. 102119 MAKURDI, BENUE STATE", cellFormat));
                m++;
                wsheet2.mergeCells(0, m, 38, m);
                wsheet2.addCell(new Label(0, m, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                m++;
                wsheet2.mergeCells(0, m, 38, m);
                wsheet2.addCell(new Label(0, m, "NON RECOMMEMDED CASES", cellFormat2));
                m++;
                
                String utmereq = "";
                String olreq = "";
                try {
                    List<Admissiontemplateolevel> admtl = sess.getAdmissiontemplateolevel(admt.getId());
                    List<Admissiontemplateutme> admtlU = sess.getAdmissiontemplateutme(admt.getId());

                    List<Admissiontemplateolevel> listoc = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C"))
                            .collect(Collectors.toList());
                    List<Admissiontemplateolevel> listoo = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O"))
                            .collect(Collectors.toList());

                    List<Admissiontemplateutme> listocU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("C"))
                            .collect(Collectors.toList());
                    List<Admissiontemplateutme> listooU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("O"))
                            .collect(Collectors.toList());

                    for (Admissiontemplateutme ut : listocU) {
                        utmereq += ut.getUtmesubjects().getName() + ", ";
                    }
                    utmereq += " and any " + admt.getOtherUtme() + " of ";
                    for (Admissiontemplateutme ut : listooU) {
                        utmereq += ut.getUtmesubjects().getName() + ", ";
                    }

                    for (Admissiontemplateolevel ut : listoc) {
                        olreq += ut.getOlevelSubject().getName() + ", ";
                    }
                    olreq += " and any " + admt.getOtherSubjects() + " of ";
                    for (Admissiontemplateolevel ut : listoo) {
                        olreq += ut.getOlevelSubject().getName() + ", ";
                    }
                } catch (Exception k) {
                }
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, "UTME REQUIREMENT: " + utmereq, cellFormat2));
                i++;
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, "O-LEVEL REQUIREMENT: " + olreq, cellFormat2));
                i++;
                wsheet.mergeCells(0, i, 6, i);
                wsheet.mergeCells(7, i, 15, i);
                wsheet.mergeCells(16, i, 31, i);
                wsheet.mergeCells(32, i, 38, i);
                wsheet.addCell(new Label(0, i, "BIO DATA", cellFormat2));
                wsheet.addCell(new Label(7, i, "UTME SUBJECTS COMBINATION", cellFormat2));
                wsheet.addCell(new Label(16, i, "O-LEVEL SUBJECTS COMBINATION", cellFormat2));
                wsheet.addCell(new Label(32, i, "SUMMARY", cellFormat2));
                i++;
                // Create a row and put some cells in it. Rows are 0 based.

                wsheet.addCell(new Label(0, i, "SNO", cellFormat2));
                wsheet.addCell(new Label(1, i, "EG_NO", cellFormat2));
                wsheet.addCell(new Label(2, i, "SURNAME", cellFormat2));
                wsheet.addCell(new Label(3, i, "OTHER NAMES", cellFormat2));
                wsheet.addCell(new Label(4, i, "GENDER", cellFormat2));
                wsheet.addCell(new Label(5, i, "STATE", cellFormat2));
                wsheet.addCell(new Label(6, i, "LGA", cellFormat2));
                wsheet.addCell(new Label(7, i, "ENG", cellFormat2));
                wsheet.addCell(new Label(8, i, "SUBJ2", cellFormat2));
                wsheet.addCell(new Label(9, i, "SUBJ2 SCORE", cellFormat2));
                wsheet.addCell(new Label(10, i, "SUBJ3", cellFormat2));
                wsheet.addCell(new Label(11, i, "SUBJ3 SCORE", cellFormat2));
                wsheet.addCell(new Label(12, i, "SUBJ4", cellFormat2));
                wsheet.addCell(new Label(13, i, "SUBJ4 SCORE", cellFormat2));
                wsheet.addCell(new Label(14, i, "JAMB SCORE", cellFormat2));
                wsheet.addCell(new Label(15, i, "UTME MERIT SCORE", cellFormat2));
                wsheet.addCell(new Label(16, i, "SITINGS", cellFormat2));
                wsheet.addCell(new Label(17, i, "ENG GRADE", cellFormat2));
                wsheet.addCell(new Label(18, i, "ENG POINT", cellFormat2));
                wsheet.addCell(new Label(19, i, "MATHS GRADE", cellFormat2));
                wsheet.addCell(new Label(20, i, "MATHS POINT", cellFormat2));
                wsheet.addCell(new Label(21, i, "SUBJ3", cellFormat2));
                wsheet.addCell(new Label(22, i, "SUBJ3 GRADE", cellFormat2));
                wsheet.addCell(new Label(23, i, "SUBJ3 POINT", cellFormat2));
                wsheet.addCell(new Label(24, i, "SUBJ4", cellFormat2));
                wsheet.addCell(new Label(25, i, "SUBJ4 GRADE", cellFormat2));
                wsheet.addCell(new Label(26, i, "SUBJ4 POINT", cellFormat2));
                wsheet.addCell(new Label(27, i, "SUBJ5", cellFormat2));
                wsheet.addCell(new Label(28, i, "SUBJ5 GRADE", cellFormat2));
                wsheet.addCell(new Label(29, i, "SUBJ5 POINT", cellFormat2));
                wsheet.addCell(new Label(30, i, "OL TOTAL SCORE", cellFormat2));
                wsheet.addCell(new Label(31, i, "NO OF SITTINGS POINTS", cellFormat2));
                wsheet.addCell(new Label(32, i, "OL SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(33, i, "JAMB SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(34, i, "PUTME SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(35, i, "TOTAL SCORE", cellFormat2));
                wsheet.addCell(new Label(36, i, "GENERAL REMARKS", cellFormat2));
                wsheet.addCell(new Label(37, i, "UTME REMARKS", cellFormat2));
                wsheet.addCell(new Label(38, i, "OL REMARKS", cellFormat2));
                
                //////////////////
                //NONRECOMMEMDED
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, "UTME REQUIREMENT: " + utmereq, cellFormat2));
                i++;
                wsheet.mergeCells(0, i, 38, i);
                wsheet.addCell(new Label(0, i, "O-LEVEL REQUIREMENT: " + olreq, cellFormat2));
                i++;
                wsheet.mergeCells(0, i, 6, i);
                wsheet.mergeCells(7, i, 15, i);
                wsheet.mergeCells(16, i, 31, i);
                wsheet.mergeCells(32, i, 38, i);
                wsheet.addCell(new Label(0, i, "BIO DATA", cellFormat2));
                wsheet.addCell(new Label(7, i, "UTME SUBJECTS COMBINATION", cellFormat2));
                wsheet.addCell(new Label(16, i, "O-LEVEL SUBJECTS COMBINATION", cellFormat2));
                wsheet.addCell(new Label(32, i, "SUMMARY", cellFormat2));
                i++;
                // Create a row and put some cells in it. Rows are 0 based.

                wsheet.addCell(new Label(0, i, "SNO", cellFormat2));
                wsheet.addCell(new Label(1, i, "EG_NO", cellFormat2));
                wsheet.addCell(new Label(2, i, "SURNAME", cellFormat2));
                wsheet.addCell(new Label(3, i, "OTHER NAMES", cellFormat2));
                wsheet.addCell(new Label(4, i, "GENDER", cellFormat2));
                wsheet.addCell(new Label(5, i, "STATE", cellFormat2));
                wsheet.addCell(new Label(6, i, "LGA", cellFormat2));
                wsheet.addCell(new Label(7, i, "ENG", cellFormat2));
                wsheet.addCell(new Label(8, i, "SUBJ2", cellFormat2));
                wsheet.addCell(new Label(9, i, "SUBJ2 SCORE", cellFormat2));
                wsheet.addCell(new Label(10, i, "SUBJ3", cellFormat2));
                wsheet.addCell(new Label(11, i, "SUBJ3 SCORE", cellFormat2));
                wsheet.addCell(new Label(12, i, "SUBJ4", cellFormat2));
                wsheet.addCell(new Label(13, i, "SUBJ4 SCORE", cellFormat2));
                wsheet.addCell(new Label(14, i, "JAMB SCORE", cellFormat2));
                wsheet.addCell(new Label(15, i, "UTME MERIT SCORE", cellFormat2));
                wsheet.addCell(new Label(16, i, "SITINGS", cellFormat2));
                wsheet.addCell(new Label(17, i, "ENG GRADE", cellFormat2));
                wsheet.addCell(new Label(18, i, "ENG POINT", cellFormat2));
                wsheet.addCell(new Label(19, i, "MATHS GRADE", cellFormat2));
                wsheet.addCell(new Label(20, i, "MATHS POINT", cellFormat2));
                wsheet.addCell(new Label(21, i, "SUBJ3", cellFormat2));
                wsheet.addCell(new Label(22, i, "SUBJ3 GRADE", cellFormat2));
                wsheet.addCell(new Label(23, i, "SUBJ3 POINT", cellFormat2));
                wsheet.addCell(new Label(24, i, "SUBJ4", cellFormat2));
                wsheet.addCell(new Label(25, i, "SUBJ4 GRADE", cellFormat2));
                wsheet.addCell(new Label(26, i, "SUBJ4 POINT", cellFormat2));
                wsheet.addCell(new Label(27, i, "SUBJ5", cellFormat2));
                wsheet.addCell(new Label(28, i, "SUBJ5 GRADE", cellFormat2));
                wsheet.addCell(new Label(29, i, "SUBJ5 POINT", cellFormat2));
                wsheet.addCell(new Label(30, i, "OL TOTAL SCORE", cellFormat2));
                wsheet.addCell(new Label(31, i, "NO OF SITTINGS POINTS", cellFormat2));
                wsheet.addCell(new Label(32, i, "OL SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(33, i, "JAMB SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(34, i, "PUTME SCORE RATIO", cellFormat2));
                wsheet.addCell(new Label(35, i, "TOTAL SCORE", cellFormat2));
                wsheet.addCell(new Label(36, i, "GENERAL REMARKS", cellFormat2));
                wsheet.addCell(new Label(37, i, "UTME REMARKS", cellFormat2));
                wsheet.addCell(new Label(38, i, "OL REMARKS", cellFormat2));
                

                List<Applicants> appl = sess.getApplicantsByCourseStatus(admt.getCourse().getId(), admt.getSession(), "PAID", "UTME");
                List<Applicants> appl2 = sess.getApplicantsByCourseStatus(admt.getCourse().getId(), admt.getSession(), "REGISTERED", "UTME");
                appl.addAll(appl2);
                //List<Staff> al2 = sess.getAllStaff();
                i++;
                List<AdmissionTemplateUTME> listrec = new ArrayList();
                for (Applicants app : appl) {

                    AdmTempUTMEDet det = sess.getAdmTempUTMEDet(admt, app);
                    AdmTempOLDet ol = sess.getAdmTempOLDet(admt, app);
                    if (det != null && ol != null) {
                        try {
                            AdmissionTemplateUTME record = new AdmissionTemplateUTME();
                            record.setId(app.getId().toUpperCase());
                            record.setSurname(app.getSurname());
                            record.setOthernames(app.getOthernames());
                            record.setGender(app.getGender());
                            record.setState(app.getStateOfOrigin() != null ? app.getStateOfOrigin().getName() : "");
                            record.setLga(app.getLga() != null ? app.getLga().getName() : "");
                            record.setUtme(det);
                            record.setSittings(ol.getSittings());
                            record.setOlevel(ol);
                            int sc = 6;
                            if (ol.getSittings() == 1) {
                                sc = 10;
                            }
                            if (ol.getSittings() == 0) {
                                sc = 0;
                            }
                            record.setSittingScore(sc);
                            double olrat = admt.getOlevelPer();
                            double utmerat = admt.getUtmePer();
                            double olratio = (sc + ol.getTotaPoints()) * olrat / 40;
                            record.setOlratio(olratio);

                            double utmeration = det.getTotalUtme() * utmerat / 400;
                            record.setUtmearatio(utmeration);
                            double putmeration = 0;
                            record.setPutmeration(putmeration);

                            double totalsc = olratio + utmeration + putmeration;
                            record.setTotalscore(totalsc);
                            listrec.add(record);
                        } catch (Exception k) {
                        }
                    }

                }
                //sort list
                listrec.sort((r1, r2) -> Double.compare(r2.getTotalscore(), r1.getTotalscore()));
                int j = 1;
                for (AdmissionTemplateUTME det : listrec) {
                    //display records
                    wsheet.addCell(new Label(0, i, j + "", cellFormat2));
                    wsheet.addCell(new Label(1, i, det.getId(), cellFormat2));
                    wsheet.addCell(new Label(2, i, det.getSurname(), cellFormat2));
                    wsheet.addCell(new Label(3, i, det.getOthernames(), cellFormat2));
                    wsheet.addCell(new Label(4, i, det.getGender(), cellFormat2));
                    wsheet.addCell(new Label(5, i, det.getState(), cellFormat2));
                    wsheet.addCell(new Label(6, i, det.getLga(), cellFormat2));
                    wsheet.addCell(new Number(7, i, det.getUtme().getEng(), cellFormat2));
                    wsheet.addCell(new Label(8, i, det.getUtme().getSubj2(), cellFormat2));
                    wsheet.addCell(new Number(9, i, det.getUtme().getSubj2Score(), cellFormat2));
                    wsheet.addCell(new Label(10, i, det.getUtme().getSubj3(), cellFormat2));
                    wsheet.addCell(new Number(11, i, det.getUtme().getSubj3Score(), cellFormat2));
                    wsheet.addCell(new Label(12, i, det.getUtme().getSubj4(), cellFormat2));
                    wsheet.addCell(new Number(13, i, det.getUtme().getSubj4Score(), cellFormat2));
                    wsheet.addCell(new Number(14, i, det.getUtme().getTotalUtme(), cellFormat2));
                    wsheet.addCell(new Number(15, i, det.getUtme().getUtmeremitscore(), cellFormat2));
                    wsheet.addCell(new Number(16, i, det.getSittings(), cellFormat2));
                    wsheet.addCell(new Label(17, i, det.getOlevel().getEngGrade(), cellFormat2));
                    wsheet.addCell(new Number(18, i, det.getOlevel().getEng(), cellFormat2));
                    wsheet.addCell(new Label(19, i, det.getOlevel().getMathGrade(), cellFormat2));
                    wsheet.addCell(new Number(20, i, det.getOlevel().getMath(), cellFormat2));
                    wsheet.addCell(new Label(21, i, det.getOlevel().getSubj3(), cellFormat2));
                    wsheet.addCell(new Label(22, i, det.getOlevel().getSubj3Grade(), cellFormat2));
                    wsheet.addCell(new Number(23, i, det.getOlevel().getSubj3Point(), cellFormat2));
                    wsheet.addCell(new Label(24, i, det.getOlevel().getSubj4(), cellFormat2));
                    wsheet.addCell(new Label(25, i, det.getOlevel().getSubj4Grade(), cellFormat2));
                    wsheet.addCell(new Number(26, i, det.getOlevel().getSubj4Point(), cellFormat2));
                    wsheet.addCell(new Label(27, i, det.getOlevel().getSubj5(), cellFormat2));
                    wsheet.addCell(new Label(28, i, det.getOlevel().getSubj5Grade(), cellFormat2));
                    wsheet.addCell(new Number(29, i, det.getOlevel().getSubj5Point(), cellFormat2));
                    wsheet.addCell(new Number(30, i, det.getOlevel().getTotaPoints(), cellFormat2));
                    wsheet.addCell(new Number(31, i, det.getSittingScore(), cellFormat2));
                    wsheet.addCell(new Label(32, i, df.format(det.getOlratio()), cellFormat3));
                    wsheet.addCell(new Label(33, i, df.format(det.getUtmearatio()), cellFormat3));
                    wsheet.addCell(new Label(34, i, df.format(det.getPutmeration()), cellFormat3));
                    wsheet.addCell(new Label(35, i, df.format(det.getTotalscore()), cellFormat3));
                    String genrem = "ERROR";
                    try {
                        if (det.getUtme().getEng() > 0 && det.getUtme().getSubj2Score() > 0 && det.getUtme().getSubj3Score() > 0 && det.getUtme().getSubj4Score() > 0
                                && det.getOlevel().getEng() > 0 && det.getOlevel().getMath() > 0 && det.getOlevel().getSubj3Point() > 0
                                && det.getOlevel().getSubj4Point() > 0 && det.getOlevel().getSubj5Point() > 0) {
                            genrem = "";
                        } else {
                            String ut = "";
                            String olx = "";

                            if (det.getUtme().getEng() > 0 && det.getUtme().getSubj2Score() > 0 && det.getUtme().getSubj3Score() > 0 && det.getUtme().getSubj4Score() > 0) {

                            } else {
                                ut = "Wrong JAMB Combination ";
                            }
                            if (det.getOlevel().getEng() > 0 && det.getOlevel().getMath() > 0 && det.getOlevel().getSubj3Point() > 0
                                    && det.getOlevel().getSubj4Point() > 0 && det.getOlevel().getSubj5Point() > 0) {

                            } else {
                                olx = "Insufficient O-Level";

                            }
                            if (ut.length() > 0 && olx.length() > 0) {
                                genrem = ut + " and " + olx;
                            }
                            if (ut.length() > 0 && olx.length() == 0) {
                                genrem = ut;
                            }
                            if (ut.length() == 0 && olx.length() > 0) {
                                genrem = olx;
                            }

                        }
                    } catch (Exception ka) {
                    }
                    wsheet.addCell(new Label(36, i, genrem, cellFormat2));
                    wsheet.addCell(new Label(37, i, det.getUtme().getRemarks(), cellFormat2));
                    wsheet.addCell(new Label(38, i, det.getOlevel().getRemarks(), cellFormat2));
                    j++;
                    i++;

                }

                /////////////////////////////////////////////
                try {
                    wworkbook.write();
                    wworkbook.close();
                } catch (Exception k) {
                }

            } catch (IOException | WriteException jn) {
                jn.printStackTrace();
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
            System.out.println("Image downloaded successfully: " + savePath);
        } else {
            throw new Exception("Failed to download image. HTTP Response Code: " + connection.getResponseCode());
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
