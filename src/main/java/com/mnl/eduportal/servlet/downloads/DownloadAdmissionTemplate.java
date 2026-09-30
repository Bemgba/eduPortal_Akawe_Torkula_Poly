/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.downloads;

import com.mnl.eduportal.entities.Admissiontemplate;
import com.mnl.eduportal.entities.Admissiontemplateolevel;
import com.mnl.eduportal.entities.Admissiontemplateutme;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Lgas;
import com.mnl.eduportal.entities.States;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.AdmTempOLDet;
import com.mnl.eduportal.util.AdmTempUTMEDet;
import com.mnl.eduportal.util.AdmissionTemplateUTME;
import com.mnl.eduportal.util.MeritAdmission;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
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
public class DownloadAdmissionTemplate extends HttpServlet {

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
                WritableSheet wsheet0 = wworkbook.createSheet("Admission_Summary", 0);
                WritableSheet wsheet1 = wworkbook.createSheet("Merit_List", 1);
                WritableSheet wsheet2 = wworkbook.createSheet("Other_Recommended_Cases", 2);
                WritableSheet wsheet3 = wworkbook.createSheet("Non_Recommended_Cases", 3);
                int m0 = 0;
                int m1 = 0;
                int m2 = 0;
                int m3 = 0;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                m0++;
                wsheet1.mergeCells(0, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                m1++;
                wsheet1.mergeCells(0, m2, 38, m2);
                wsheet1.addCell(new Label(0, m2, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                m2++;
                wsheet1.mergeCells(0, m3, 38, m3);
                wsheet1.addCell(new Label(0, m3, "AKAWE TORKULA POLYTECHNIC,P.M.B. 102211 MAKURDI, BENUE STATE", cellFormat));
                m3++;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                m0++;
                wsheet1.mergeCells(0, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                m1++;
                wsheet2.mergeCells(0, m2, 38, m2);
                wsheet2.addCell(new Label(0, m2, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                m2++;
                wsheet3.mergeCells(0, m3, 38, m3);
                wsheet3.addCell(new Label(0, m3, admt.getSession() + " ADMISSION LIST FOR " + admt.getCourse().getName().toUpperCase(), cellFormat2));
                m3++;

                wsheet0.mergeCells(0, m0, 4, m0);
                wsheet0.addCell(new Label(0, m0, " SUMMARY OF ADMISSION", cellFormat2));
                m0++;
                m0++;
                wsheet1.mergeCells(0, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, " MERIR LIST", cellFormat2));
                m1++;

                wsheet2.mergeCells(0, m2, 38, m2);
                wsheet2.addCell(new Label(0, m2, " OTHER RECOMMENDED CASES", cellFormat2));
                m2++;
                wsheet3.mergeCells(0, m3, 38, m3);
                wsheet3.addCell(new Label(0, m3, " NON RECOMMENDED CASES", cellFormat2));
                m3++;

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

                wsheet1.mergeCells(0, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, "UTME REQUIREMENT: " + utmereq, cellFormat2));
                m1++;
                wsheet1.mergeCells(0, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, "O-LEVEL REQUIREMENT: " + olreq, cellFormat2));
                m1++;
                wsheet1.mergeCells(0, m1, 6, m1);
                wsheet1.mergeCells(7, m1, 15, m1);
                wsheet1.mergeCells(16, m1, 31, m1);
                wsheet1.mergeCells(32, m1, 38, m1);
                wsheet1.addCell(new Label(0, m1, "BIO DATA", cellFormat2));
                wsheet1.addCell(new Label(7, m1, "UTME SUBJECTS COMBINATION", cellFormat2));
                wsheet1.addCell(new Label(16, m1, "O-LEVEL SUBJECTS COMBINATION", cellFormat2));
                wsheet1.addCell(new Label(32, m1, "SUMMARY", cellFormat2));
                m1++;

                wsheet2.mergeCells(0, m2, 38, m2);
                wsheet2.addCell(new Label(0, m2, "UTME REQUIREMENT: " + utmereq, cellFormat2));
                m2++;
                wsheet2.mergeCells(0, m2, 38, m2);
                wsheet2.addCell(new Label(0, m2, "O-LEVEL REQUIREMENT: " + olreq, cellFormat2));
                m2++;
                wsheet2.mergeCells(0, m2, 6, m2);
                wsheet2.mergeCells(7, m2, 15, m2);
                wsheet2.mergeCells(16, m2, 31, m2);
                wsheet2.mergeCells(32, m2, 38, m2);
                wsheet2.addCell(new Label(0, m2, "BIO DATA", cellFormat2));
                wsheet2.addCell(new Label(7, m2, "UTME SUBJECTS COMBINATION", cellFormat2));
                wsheet2.addCell(new Label(16, m2, "O-LEVEL SUBJECTS COMBINATION", cellFormat2));
                wsheet2.addCell(new Label(32, m2, "SUMMARY", cellFormat2));
                m2++;

                wsheet3.mergeCells(0, m3, 38, m3);
                wsheet3.addCell(new Label(0, m3, "UTME REQUIREMENT: " + utmereq, cellFormat2));
                m3++;
                wsheet3.mergeCells(0, m3, 38, m3);
                wsheet3.addCell(new Label(0, m3, "O-LEVEL REQUIREMENT: " + olreq, cellFormat2));
                m3++;
                wsheet3.mergeCells(0, m3, 6, m3);
                wsheet3.mergeCells(7, m3, 15, m3);
                wsheet3.mergeCells(16, m3, 31, m3);
                wsheet3.mergeCells(32, m3, 38, m3);
                wsheet3.addCell(new Label(0, m3, "BIO DATA", cellFormat2));
                wsheet3.addCell(new Label(7, m3, "UTME SUBJECTS COMBINATION", cellFormat2));
                wsheet3.addCell(new Label(16, m3, "O-LEVEL SUBJECTS COMBINATION", cellFormat2));
                wsheet3.addCell(new Label(32, m3, "SUMMARY", cellFormat2));
                m3++;

                // Create a row and put some cells in it. Rows are 0 based.
                wsheet1.addCell(new Label(0, m1, "SNO", cellFormat2));
                wsheet1.addCell(new Label(1, m1, "EG_NO", cellFormat2));
                wsheet1.addCell(new Label(2, m1, "SURNAME", cellFormat2));
                wsheet1.addCell(new Label(3, m1, "OTHER NAMES", cellFormat2));
                wsheet1.addCell(new Label(4, m1, "GENDER", cellFormat2));
                wsheet1.addCell(new Label(5, m1, "STATE", cellFormat2));
                wsheet1.addCell(new Label(6, m1, "LGA", cellFormat2));
                wsheet1.addCell(new Label(7, m1, "ENG", cellFormat2));
                wsheet1.addCell(new Label(8, m1, "SUBJ2", cellFormat2));
                wsheet1.addCell(new Label(9, m1, "SUBJ2 SCORE", cellFormat2));
                wsheet1.addCell(new Label(10, m1, "SUBJ3", cellFormat2));
                wsheet1.addCell(new Label(11, m1, "SUBJ3 SCORE", cellFormat2));
                wsheet1.addCell(new Label(12, m1, "SUBJ4", cellFormat2));
                wsheet1.addCell(new Label(13, m1, "SUBJ4 SCORE", cellFormat2));
                wsheet1.addCell(new Label(14, m1, "JAMB SCORE", cellFormat2));
                wsheet1.addCell(new Label(15, m1, "POST UTME SCORE (Not Used)", cellFormat2));
                wsheet1.addCell(new Label(16, m1, "SITINGS", cellFormat2));
                wsheet1.addCell(new Label(17, m1, "ENG GRADE", cellFormat2));
                wsheet1.addCell(new Label(18, m1, "ENG POINT", cellFormat2));
                wsheet1.addCell(new Label(19, m1, "MATHS GRADE", cellFormat2));
                wsheet1.addCell(new Label(20, m1, "MATHS POINT", cellFormat2));
                wsheet1.addCell(new Label(21, m1, "SUBJ3", cellFormat2));
                wsheet1.addCell(new Label(22, m1, "SUBJ3 GRADE", cellFormat2));
                wsheet1.addCell(new Label(23, m1, "SUBJ3 POINT", cellFormat2));
                wsheet1.addCell(new Label(24, m1, "SUBJ4", cellFormat2));
                wsheet1.addCell(new Label(25, m1, "SUBJ4 GRADE", cellFormat2));
                wsheet1.addCell(new Label(26, m1, "SUBJ4 POINT", cellFormat2));
                wsheet1.addCell(new Label(27, m1, "SUBJ5", cellFormat2));
                wsheet1.addCell(new Label(28, m1, "SUBJ5 GRADE", cellFormat2));
                wsheet1.addCell(new Label(29, m1, "SUBJ5 POINT", cellFormat2));
                wsheet1.addCell(new Label(30, m1, "OL TOTAL SCORE", cellFormat2));
                wsheet1.addCell(new Label(31, m1, "NO OF SITTINGS POINTS", cellFormat2));
                wsheet1.addCell(new Label(32, m1, "OL SCORE RATIO", cellFormat2));
                wsheet1.addCell(new Label(33, m1, "JAMB SCORE RATIO", cellFormat2));
                wsheet1.addCell(new Label(34, m1, "PUTME SCORE RATIO (Not Used)", cellFormat2));
                wsheet1.addCell(new Label(35, m1, "TOTAL SCORE", cellFormat2));
                wsheet1.addCell(new Label(36, m1, "GENERAL REMARKS", cellFormat2));
                wsheet1.addCell(new Label(37, m1, "UTME REMARKS", cellFormat2));
                wsheet1.addCell(new Label(38, m1, "OL REMARKS", cellFormat2));
                m1++;

                wsheet2.addCell(new Label(0, m2, "SNO", cellFormat2));
                wsheet2.addCell(new Label(1, m2, "EG_NO", cellFormat2));
                wsheet2.addCell(new Label(2, m2, "SURNAME", cellFormat2));
                wsheet2.addCell(new Label(3, m2, "OTHER NAMES", cellFormat2));
                wsheet2.addCell(new Label(4, m2, "GENDER", cellFormat2));
                wsheet2.addCell(new Label(5, m2, "STATE", cellFormat2));
                wsheet2.addCell(new Label(6, m2, "LGA", cellFormat2));
                wsheet2.addCell(new Label(7, m2, "ENG", cellFormat2));
                wsheet2.addCell(new Label(8, m2, "SUBJ2", cellFormat2));
                wsheet2.addCell(new Label(9, m2, "SUBJ2 SCORE", cellFormat2));
                wsheet2.addCell(new Label(10, m2, "SUBJ3", cellFormat2));
                wsheet2.addCell(new Label(11, m2, "SUBJ3 SCORE", cellFormat2));
                wsheet2.addCell(new Label(12, m2, "SUBJ4", cellFormat2));
                wsheet2.addCell(new Label(13, m2, "SUBJ4 SCORE", cellFormat2));
                wsheet2.addCell(new Label(14, m2, "JAMB SCORE", cellFormat2));
                wsheet2.addCell(new Label(15, m2, "POST UTME SCORE (Not Used)", cellFormat2));
                wsheet2.addCell(new Label(16, m2, "SITINGS", cellFormat2));
                wsheet2.addCell(new Label(17, m2, "ENG GRADE", cellFormat2));
                wsheet2.addCell(new Label(18, m2, "ENG POINT", cellFormat2));
                wsheet2.addCell(new Label(19, m2, "MATHS GRADE", cellFormat2));
                wsheet2.addCell(new Label(20, m2, "MATHS POINT", cellFormat2));
                wsheet2.addCell(new Label(21, m2, "SUBJ3", cellFormat2));
                wsheet2.addCell(new Label(22, m2, "SUBJ3 GRADE", cellFormat2));
                wsheet2.addCell(new Label(23, m2, "SUBJ3 POINT", cellFormat2));
                wsheet2.addCell(new Label(24, m2, "SUBJ4", cellFormat2));
                wsheet2.addCell(new Label(25, m2, "SUBJ4 GRADE", cellFormat2));
                wsheet2.addCell(new Label(26, m2, "SUBJ4 POINT", cellFormat2));
                wsheet2.addCell(new Label(27, m2, "SUBJ5", cellFormat2));
                wsheet2.addCell(new Label(28, m2, "SUBJ5 GRADE", cellFormat2));
                wsheet2.addCell(new Label(29, m2, "SUBJ5 POINT", cellFormat2));
                wsheet2.addCell(new Label(30, m2, "OL TOTAL SCORE", cellFormat2));
                wsheet2.addCell(new Label(31, m2, "NO OF SITTINGS POINTS", cellFormat2));
                wsheet2.addCell(new Label(32, m2, "OL SCORE RATIO", cellFormat2));
                wsheet2.addCell(new Label(33, m2, "JAMB SCORE RATIO", cellFormat2));
                wsheet2.addCell(new Label(34, m2, "PUTME SCORE RATIO (Not Used)", cellFormat2));
                wsheet2.addCell(new Label(35, m2, "TOTAL SCORE", cellFormat2));
                wsheet2.addCell(new Label(36, m2, "GENERAL REMARKS", cellFormat2));
                wsheet2.addCell(new Label(37, m2, "UTME REMARKS", cellFormat2));
                wsheet2.addCell(new Label(38, m2, "OL REMARKS", cellFormat2));
                m2++;

                wsheet3.addCell(new Label(0, m3, "SNO", cellFormat2));
                wsheet3.addCell(new Label(1, m3, "EG_NO", cellFormat2));
                wsheet3.addCell(new Label(2, m3, "SURNAME", cellFormat2));
                wsheet3.addCell(new Label(3, m3, "OTHER NAMES", cellFormat2));
                wsheet3.addCell(new Label(4, m3, "GENDER", cellFormat2));
                wsheet3.addCell(new Label(5, m3, "STATE", cellFormat2));
                wsheet3.addCell(new Label(6, m3, "LGA", cellFormat2));
                wsheet3.addCell(new Label(7, m3, "ENG", cellFormat2));
                wsheet3.addCell(new Label(8, m3, "SUBJ2", cellFormat2));
                wsheet3.addCell(new Label(9, m3, "SUBJ2 SCORE", cellFormat2));
                wsheet3.addCell(new Label(10, m3, "SUBJ3", cellFormat2));
                wsheet3.addCell(new Label(11, m3, "SUBJ3 SCORE", cellFormat2));
                wsheet3.addCell(new Label(12, m3, "SUBJ4", cellFormat2));
                wsheet3.addCell(new Label(13, m3, "SUBJ4 SCORE", cellFormat2));
                wsheet3.addCell(new Label(14, m3, "JAMB SCORE", cellFormat2));
                wsheet3.addCell(new Label(15, m3, "POST UTME SCORE (Not Used)", cellFormat2));
                wsheet3.addCell(new Label(16, m3, "SITINGS", cellFormat2));
                wsheet3.addCell(new Label(17, m3, "ENG GRADE", cellFormat2));
                wsheet3.addCell(new Label(18, m3, "ENG POINT", cellFormat2));
                wsheet3.addCell(new Label(19, m3, "MATHS GRADE", cellFormat2));
                wsheet3.addCell(new Label(20, m3, "MATHS POINT", cellFormat2));
                wsheet3.addCell(new Label(21, m3, "SUBJ3", cellFormat2));
                wsheet3.addCell(new Label(22, m3, "SUBJ3 GRADE", cellFormat2));
                wsheet3.addCell(new Label(23, m3, "SUBJ3 POINT", cellFormat2));
                wsheet3.addCell(new Label(24, m3, "SUBJ4", cellFormat2));
                wsheet3.addCell(new Label(25, m3, "SUBJ4 GRADE", cellFormat2));
                wsheet3.addCell(new Label(26, m3, "SUBJ4 POINT", cellFormat2));
                wsheet3.addCell(new Label(27, m3, "SUBJ5", cellFormat2));
                wsheet3.addCell(new Label(28, m3, "SUBJ5 GRADE", cellFormat2));
                wsheet3.addCell(new Label(29, m3, "SUBJ5 POINT", cellFormat2));
                wsheet3.addCell(new Label(30, m3, "OL TOTAL SCORE", cellFormat2));
                wsheet3.addCell(new Label(31, m3, "NO OF SITTINGS POINTS", cellFormat2));
                wsheet3.addCell(new Label(32, m3, "OL SCORE RATIO", cellFormat2));
                wsheet3.addCell(new Label(33, m3, "JAMB SCORE RATIO", cellFormat2));
                wsheet3.addCell(new Label(34, m3, "PUTME SCORE RATIO (Not Used)", cellFormat2));
                wsheet3.addCell(new Label(35, m3, "TOTAL SCORE", cellFormat2));
                wsheet3.addCell(new Label(36, m3, "GENERAL REMARKS", cellFormat2));
                wsheet3.addCell(new Label(37, m3, "UTME REMARKS", cellFormat2));
                wsheet3.addCell(new Label(38, m3, "OL REMARKS", cellFormat2));
                m3++;

                List<Applicants> appl = sess.getApplicantsByCourseStatus(admt.getCourse().getId(), admt.getSession(), "PAID", "UTME");
                List<Applicants> appl2 = sess.getApplicantsByCourseStatus(admt.getCourse().getId(), admt.getSession(), "REGISTERED", "UTME");
                appl.addAll(appl2);
                //List<Staff> al2 = sess.getAllStaff();

                List<AdmissionTemplateUTME> listrec = new ArrayList();
                List<AdmissionTemplateUTME> listnonrec = new ArrayList();
                List<AdmissionTemplateUTME> merit = new ArrayList();
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
                            // POST UTME removed as per Federal Ministry of Education directive
                            // double postutmerat = admt.getAptitudePer();
                            double olratio = (sc + ol.getTotaPoints()) * olrat / 40;
                            record.setOlratio(olratio);

                            double utmeration = det.getTotalUtme() * utmerat / 400;
                            record.setUtmearatio(utmeration);
                            // POST UTME calculation removed
                            // double postutmeratio = det.getPostutmescore()* postutmerat / 400;
                            record.setPutmeration(0.0); // Set to 0 since POST UTME is no longer used

                            // Modified formula: Only UTME + O-Level (POST UTME removed)
                            double totalsc = olratio + utmeration;
                            record.setTotalscore(totalsc);
                            listrec.add(record);
                        } catch (Exception k) {
                        }
                    }

                }
                //sort list
                listrec.sort((r1, r2) -> Double.compare(r2.getTotalscore(), r1.getTotalscore()));
                int j = 1;
                int k = 1;
                int nonrec = 0;
                for (AdmissionTemplateUTME det : listrec) {
                    //display records
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

                    if (genrem.length() > 0) {
                        nonrec++;
                        wsheet3.addCell(new Label(0, m3, k + "", cellFormat2));
                        wsheet3.addCell(new Label(1, m3, det.getId(), cellFormat2));
                        wsheet3.addCell(new Label(2, m3, det.getSurname(), cellFormat2));
                        wsheet3.addCell(new Label(3, m3, det.getOthernames(), cellFormat2));
                        wsheet3.addCell(new Label(4, m3, det.getGender(), cellFormat2));
                        wsheet3.addCell(new Label(5, m3, det.getState(), cellFormat2));
                        wsheet3.addCell(new Label(6, m3, det.getLga(), cellFormat2));
                        wsheet3.addCell(new Number(7, m3, det.getUtme().getEng(), cellFormat2));
                        wsheet3.addCell(new Label(8, m3, det.getUtme().getSubj2(), cellFormat2));
                        wsheet3.addCell(new Number(9, m3, det.getUtme().getSubj2Score(), cellFormat2));
                        wsheet3.addCell(new Label(10, m3, det.getUtme().getSubj3(), cellFormat2));
                        wsheet3.addCell(new Number(11, m3, det.getUtme().getSubj3Score(), cellFormat2));
                        wsheet3.addCell(new Label(12, m3, det.getUtme().getSubj4(), cellFormat2));
                        wsheet3.addCell(new Number(13, m3, det.getUtme().getSubj4Score(), cellFormat2));
                        wsheet3.addCell(new Number(14, m3, det.getUtme().getTotalUtme(), cellFormat2));
                        wsheet3.addCell(new Number(15, m3, det.getUtme().getPostutmescore(), cellFormat2));
                        wsheet3.addCell(new Number(16, m3, det.getSittings(), cellFormat2));
                        wsheet3.addCell(new Label(17, m3, det.getOlevel().getEngGrade(), cellFormat2));
                        wsheet3.addCell(new Number(18, m3, det.getOlevel().getEng(), cellFormat2));
                        wsheet3.addCell(new Label(19, m3, det.getOlevel().getMathGrade(), cellFormat2));
                        wsheet3.addCell(new Number(20, m3, det.getOlevel().getMath(), cellFormat2));
                        wsheet3.addCell(new Label(21, m3, det.getOlevel().getSubj3(), cellFormat2));
                        wsheet3.addCell(new Label(22, m3, det.getOlevel().getSubj3Grade(), cellFormat2));
                        wsheet3.addCell(new Number(23, m3, det.getOlevel().getSubj3Point(), cellFormat2));
                        wsheet3.addCell(new Label(24, m3, det.getOlevel().getSubj4(), cellFormat2));
                        wsheet3.addCell(new Label(25, m3, det.getOlevel().getSubj4Grade(), cellFormat2));
                        wsheet3.addCell(new Number(26, m3, det.getOlevel().getSubj4Point(), cellFormat2));
                        wsheet3.addCell(new Label(27, m3, det.getOlevel().getSubj5(), cellFormat2));
                        wsheet3.addCell(new Label(28, m3, det.getOlevel().getSubj5Grade(), cellFormat2));
                        wsheet3.addCell(new Number(29, m3, det.getOlevel().getSubj5Point(), cellFormat2));
                        wsheet3.addCell(new Number(30, m3, det.getOlevel().getTotaPoints(), cellFormat2));
                        wsheet3.addCell(new Number(31, m3, det.getSittingScore(), cellFormat2));
                        wsheet3.addCell(new Label(32, m3, df.format(det.getOlratio()), cellFormat3));
                        wsheet3.addCell(new Label(33, m3, df.format(det.getUtmearatio()), cellFormat3));
                        wsheet3.addCell(new Label(34, m3, df.format(det.getPutmeration()), cellFormat3));
                        wsheet3.addCell(new Label(35, m3, df.format(det.getTotalscore()), cellFormat3));
                        wsheet3.addCell(new Label(36, m3, genrem, cellFormat2));
                        wsheet3.addCell(new Label(37, m3, det.getUtme().getRemarks(), cellFormat2));
                        wsheet3.addCell(new Label(38, m3, det.getOlevel().getRemarks(), cellFormat2));
                        m3++;
                        k++;
                    } else {
                        listnonrec.add(det);

                    }

                }
//listnonrec;
//merit;
                int meritTotal = admt.getTotalMerit();
                double perNM = admt.getNationalMerit();
                int nm = 0;
                int sm = 0;
                int lm = 0;
                int lgcount = 0;
                int remain = 0;

                double perSM = admt.getStateMerit();
                double perLM = admt.getLgaMerit();
                List<MeritAdmission> meritAdm = new ArrayList();
                List<MeritAdmission> listnm = new ArrayList();
                List<MeritAdmission> listsm = new ArrayList();
                List<MeritAdmission> listlm = new ArrayList();

                List<Lgas> lgas = sess.getAllLgasInStte(settings.indigeneStateCode);

                int totapp = 0;
                try {
                    List<Applicants> applz = sess.getApplicantsByCourseStatus(admt.getCourse().getId(), admt.getSession(), "ALL", "UTME");
                    totapp = applz.size();
                } catch (Exception k1) {
                }
                wsheet0.addCell(new Label(0, m0, "TOTAL APPLICA NTS", cellFormat2));
                wsheet0.addCell(new Label(1, m0, totapp + "", cellFormat2));
                m0++;

                wsheet0.addCell(new Label(0, m0, "REGISTERED APPLICANTS", cellFormat2));
                wsheet0.addCell(new Label(1, m0, appl.size() + "", cellFormat3));
                m0++;
                int reccases = appl.size() - nonrec;
                wsheet0.addCell(new Label(0, m0, "RECOMMENDED CASES", cellFormat2));
                wsheet0.addCell(new Label(1, m0, reccases + "", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "NON RECOMMENDED CASES", cellFormat2));
                wsheet0.addCell(new Label(1, m0, nonrec + "", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "QUOTA FOR MERIT LIST", cellFormat2));
                wsheet0.addCell(new Label(1, m0, meritTotal + "", cellFormat3));
                m0++;
                wsheet0.addCell(new Label(0, m0, "NO. ON MERIT LIST", cellFormat2));
                wsheet0.addCell(new Label(1, m0, "", cellFormat3));
                int noonmerit = m0;
                m0++;
                m0++;
                wsheet0.addCell(new Label(0, m0, "QUOTA DISTRIBUTION", cellFormat2));
                m0++;
                wsheet0.addCell(new Label(0, m0, "ADMISSION TYPE", cellFormat2));
                wsheet0.addCell(new Label(1, m0, "PERCENTAGE", cellFormat2));
                wsheet0.addCell(new Label(2, m0, "QUOTA", cellFormat2));
                wsheet0.addCell(new Label(3, m0, "NUMBER ADMITTED", cellFormat2));
                m0++;

                if (meritTotal > 0) {
                    if (perNM > 0) {
                        nm = (int) ((perNM * meritTotal) / 100);
                    }
                    if (perSM > 0) {
                        sm = (int) ((perSM * meritTotal) / 100);
                    }
                    if (perLM > 0) {
                        lm = (int) ((perLM * meritTotal) / 100);
                    }
                   // lm = meritTotal - (nm + sm);

                    lgcount = (int) (lm / lgas.size());
                    remain = lm % lgas.size();
                    if (listnonrec.size() > nm) {
                        for (int no = 0; no < nm; no++) {
                            AdmissionTemplateUTME dd = listnonrec.get(0);
                            listnm.add(new MeritAdmission(dd, "NM"));
                            listnonrec.remove(dd);
                        }
                    } else {
                        for (int no = 0; no < listnonrec.size(); no++) {
                            AdmissionTemplateUTME dd = listnonrec.get(0);
                            listnm.add(new MeritAdmission(dd, "NM"));
                            listnonrec.remove(dd);
                        }
                    }

                    States sta = sess.getStates(settings.indigeneStateCode);
                    List<AdmissionTemplateUTME> listst = listnonrec.stream().filter(oltype -> oltype.getState().equalsIgnoreCase(sta != null ? sta.getName() : "Benue"))
                            .collect(Collectors.toList());
                    if (listst.size() > sm) {
                        for (int no = 0; no < sm; no++) {
                            AdmissionTemplateUTME dd = listst.get(0);
                            listsm.add(new MeritAdmission(dd, "SM"));
                            listst.remove(dd);
                            listnonrec.remove(dd);
                        }
                    } else {
                        for (int no = 0; no < listst.size(); no++) {
                            AdmissionTemplateUTME dd = listst.get(0);
                            listsm.add(new MeritAdmission(dd, "SM"));
                            listst.remove(dd);
                            listnonrec.remove(dd);
                        }
                    }

                    wsheet0.addCell(new Label(0, m0, "NATIONAL MERIT", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, df.format(perNM), cellFormat3));
                    wsheet0.addCell(new Label(2, m0, nm + "", cellFormat3));
                    wsheet0.addCell(new Label(3, m0, listnm.size() + "", cellFormat3));
                    m0++;
                    wsheet0.addCell(new Label(0, m0, "STATE MERIT", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, df.format(perSM), cellFormat3));
                    wsheet0.addCell(new Label(2, m0, sm + "", cellFormat3));
                    wsheet0.addCell(new Label(3, m0, listsm.size() + "", cellFormat3));
                    m0++;
                    wsheet0.addCell(new Label(0, m0, "EQUALITY OF LG", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, df.format(perLM), cellFormat3));
                    wsheet0.addCell(new Label(2, m0, lm + "", cellFormat3));
                    wsheet0.addCell(new Label(3, m0, "LIST BELOW", cellFormat3));
                    wsheet0.addCell(new Label(4, m0, lgcount + " R " + remain, cellFormat2));
                    int indexl = m0;
                    m0++;
                    m0++;
                    wsheet0.addCell(new Label(0, m0, "EQUALITY OF LG DISTRIBUTION", cellFormat2));
                    m0++;
                    wsheet0.addCell(new Label(0, m0, "LGA NAME", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, "ELG", cellFormat2));
                    wsheet0.addCell(new Label(2, m0, "SM", cellFormat2));
                    wsheet0.addCell(new Label(3, m0, "NM", cellFormat2));
                    m0++;

                    // Allocate applicants per LGA
                    for (Lgas lg : lgas) {
                        List<AdmissionTemplateUTME> matchingApplicants = listst.stream()
                                .filter(applicant -> applicant.getLga().equalsIgnoreCase(lg.getName()))
                                .collect(Collectors.toList());

                        int allocatedCount = Math.min(matchingApplicants.size(), lgcount);

                        for (int i = 0; i < allocatedCount; i++) {
                            AdmissionTemplateUTME applicant = matchingApplicants.get(i);
                            listlm.add(new MeritAdmission(applicant, "ELG"));
                        }

                        // Remove allocated applicants from the original lists
                        listst.removeAll(matchingApplicants.subList(0, allocatedCount));
                        listnonrec.removeAll(matchingApplicants.subList(0, allocatedCount));
                    }

// Handle remaining applicants
                    Set<String> addedLGAs = new HashSet<>();
                    List<AdmissionTemplateUTME> extralist = new ArrayList<>();

                    for (AdmissionTemplateUTME applicant : new ArrayList<>(listst)) {
                        if (!addedLGAs.contains(applicant.getLga())) {
                            extralist.add(applicant);
                            addedLGAs.add(applicant.getLga());
                            listst.remove(applicant);
                            listnonrec.remove(applicant);
                        }
                    }

// Distribute remaining slots
                    for (int i = 0; i < remain && !extralist.isEmpty(); i++) {
                        AdmissionTemplateUTME applicant = extralist.remove(0);
                        listlm.add(new MeritAdmission(applicant, "ELG"));
                    }

// Add any leftover applicants back to the original lists
                    listst.addAll(extralist);
                    listnonrec.addAll(extralist);

// Output the allocations per LGA
                    for (Lgas lg : lgas) {
                        long countlg = listlm.stream()
                                .filter(admission -> admission.getUtme().getLga().equalsIgnoreCase(lg.getName()))
                                .count();
                        long countst = listsm.stream()
                                .filter(admission -> admission.getUtme().getLga().equalsIgnoreCase(lg.getName()))
                                .count();
                        long countnm = listnm.stream()
                                .filter(admission -> admission.getUtme().getLga().equalsIgnoreCase(lg.getName()))
                                .count();

                        wsheet0.addCell(new Label(0, m0, lg.getName(), cellFormat2));
                        wsheet0.addCell(new Label(1, m0, String.valueOf(countlg), cellFormat3));
                        wsheet0.addCell(new Label(2, m0, String.valueOf(countst), cellFormat3));
                        wsheet0.addCell(new Label(3, m0, String.valueOf(countnm), cellFormat3));
                        m0++;
                    }

                    long tcountlg = listlm.size() - listlm.stream()
                            .filter(admission -> admission.getUtme().getState().equalsIgnoreCase(sta.getName()))
                            .count();
                    long tcountst = listsm.size() - listsm.stream()
                            .filter(admission -> admission.getUtme().getState().equalsIgnoreCase(sta.getName()))
                            .count();
                    long tcountnm = listnm.size() - listnm.stream()
                            .filter(admission -> admission.getUtme().getState().equalsIgnoreCase(sta.getName()))
                            .count();

                    wsheet0.addCell(new Label(0, m0, "OTHERS", cellFormat2));
                    wsheet0.addCell(new Label(1, m0, String.valueOf(tcountlg), cellFormat3));
                    wsheet0.addCell(new Label(2, m0, String.valueOf(tcountst), cellFormat3));
                    wsheet0.addCell(new Label(3, m0, String.valueOf(tcountnm), cellFormat3));
                    m0++;

                    int nomer = listnm.size() + listsm.size() + listlm.size();
                    wsheet0.addCell(new Label(3, indexl, listlm.size() + "", cellFormat3));
                    wsheet0.addCell(new Label(1, noonmerit, nomer + "", cellFormat3));
                    meritAdm.addAll(listnm);
                    meritAdm.addAll(listsm);
                    meritAdm.addAll(listlm);

                    k = 1;
                    for (AdmissionTemplateUTME dd : listnonrec) {
                        //////////
                        //Other recommended
                        wsheet2.addCell(new Label(0, m2, k + "", cellFormat2));
                        wsheet2.addCell(new Label(1, m2, dd.getId(), cellFormat2));
                        wsheet2.addCell(new Label(2, m2, dd.getSurname(), cellFormat2));
                        wsheet2.addCell(new Label(3, m2, dd.getOthernames(), cellFormat2));
                        wsheet2.addCell(new Label(4, m2, dd.getGender(), cellFormat2));
                        wsheet2.addCell(new Label(5, m2, dd.getState(), cellFormat2));
                        wsheet2.addCell(new Label(6, m2, dd.getLga(), cellFormat2));
                        wsheet2.addCell(new Number(7, m2, dd.getUtme().getEng(), cellFormat2));
                        wsheet2.addCell(new Label(8, m2, dd.getUtme().getSubj2(), cellFormat2));
                        wsheet2.addCell(new Number(9, m2, dd.getUtme().getSubj2Score(), cellFormat2));
                        wsheet2.addCell(new Label(10, m2, dd.getUtme().getSubj3(), cellFormat2));
                        wsheet2.addCell(new Number(11, m2, dd.getUtme().getSubj3Score(), cellFormat2));
                        wsheet2.addCell(new Label(12, m2, dd.getUtme().getSubj4(), cellFormat2));
                        wsheet2.addCell(new Number(13, m2, dd.getUtme().getSubj4Score(), cellFormat2));
                        wsheet2.addCell(new Number(14, m2, dd.getUtme().getTotalUtme(), cellFormat2));
                        wsheet2.addCell(new Number(15, m2, dd.getUtme().getPostutmescore(), cellFormat2));
                        wsheet2.addCell(new Number(16, m2, dd.getSittings(), cellFormat2));
                        wsheet2.addCell(new Label(17, m2, dd.getOlevel().getEngGrade(), cellFormat2));
                        wsheet2.addCell(new Number(18, m2, dd.getOlevel().getEng(), cellFormat2));
                        wsheet2.addCell(new Label(19, m2, dd.getOlevel().getMathGrade(), cellFormat2));
                        wsheet2.addCell(new Number(20, m2, dd.getOlevel().getMath(), cellFormat2));
                        wsheet2.addCell(new Label(21, m2, dd.getOlevel().getSubj3(), cellFormat2));
                        wsheet2.addCell(new Label(22, m2, dd.getOlevel().getSubj3Grade(), cellFormat2));
                        wsheet2.addCell(new Number(23, m2, dd.getOlevel().getSubj3Point(), cellFormat2));
                        wsheet2.addCell(new Label(24, m2, dd.getOlevel().getSubj4(), cellFormat2));
                        wsheet2.addCell(new Label(25, m2, dd.getOlevel().getSubj4Grade(), cellFormat2));
                        wsheet2.addCell(new Number(26, m2, dd.getOlevel().getSubj4Point(), cellFormat2));
                        wsheet2.addCell(new Label(27, m2, dd.getOlevel().getSubj5(), cellFormat2));
                        wsheet2.addCell(new Label(28, m2, dd.getOlevel().getSubj5Grade(), cellFormat2));
                        wsheet2.addCell(new Number(29, m2, dd.getOlevel().getSubj5Point(), cellFormat2));
                        wsheet2.addCell(new Number(30, m2, dd.getOlevel().getTotaPoints(), cellFormat2));
                        wsheet2.addCell(new Number(31, m2, dd.getSittingScore(), cellFormat2));
                        wsheet2.addCell(new Label(32, m2, df.format(dd.getOlratio()), cellFormat3));
                        wsheet2.addCell(new Label(33, m2, df.format(dd.getUtmearatio()), cellFormat3));
                        wsheet2.addCell(new Label(34, m2, df.format(dd.getPutmeration()), cellFormat3));
                        wsheet2.addCell(new Label(35, m2, df.format(dd.getTotalscore()), cellFormat3));
                        wsheet2.addCell(new Label(36, m2, " ", cellFormat2));
                        wsheet2.addCell(new Label(37, m2, dd.getUtme().getRemarks(), cellFormat2));
                        wsheet2.addCell(new Label(38, m2, dd.getOlevel().getRemarks(), cellFormat2));
                        m2++;
                        k++;
                    }

                    k = 1;
                    for (MeritAdmission ddx : meritAdm) {
                        //////////
                        //Merit List
                        AdmissionTemplateUTME dd = ddx.getUtme();
                        wsheet1.addCell(new Label(0, m1, k + "", cellFormat2));
                        wsheet1.addCell(new Label(1, m1, dd.getId(), cellFormat2));
                        wsheet1.addCell(new Label(2, m1, dd.getSurname(), cellFormat2));
                        wsheet1.addCell(new Label(3, m1, dd.getOthernames(), cellFormat2));
                        wsheet1.addCell(new Label(4, m1, dd.getGender(), cellFormat2));
                        wsheet1.addCell(new Label(5, m1, dd.getState(), cellFormat2));
                        wsheet1.addCell(new Label(6, m1, dd.getLga(), cellFormat2));
                        wsheet1.addCell(new Number(7, m1, dd.getUtme().getEng(), cellFormat2));
                        wsheet1.addCell(new Label(8, m1, dd.getUtme().getSubj2(), cellFormat2));
                        wsheet1.addCell(new Number(9, m1, dd.getUtme().getSubj2Score(), cellFormat2));
                        wsheet1.addCell(new Label(10, m1, dd.getUtme().getSubj3(), cellFormat2));
                        wsheet1.addCell(new Number(11, m1, dd.getUtme().getSubj3Score(), cellFormat2));
                        wsheet1.addCell(new Label(12, m1, dd.getUtme().getSubj4(), cellFormat2));
                        wsheet1.addCell(new Number(13, m1, dd.getUtme().getSubj4Score(), cellFormat2));
                        wsheet1.addCell(new Number(14, m1, dd.getUtme().getTotalUtme(), cellFormat2));
                        wsheet1.addCell(new Number(15, m1, dd.getUtme().getPostutmescore(), cellFormat2));
                        wsheet1.addCell(new Number(16, m1, dd.getSittings(), cellFormat2));
                        wsheet1.addCell(new Label(17, m1, dd.getOlevel().getEngGrade(), cellFormat2));
                        wsheet1.addCell(new Number(18, m1, dd.getOlevel().getEng(), cellFormat2));
                        wsheet1.addCell(new Label(19, m1, dd.getOlevel().getMathGrade(), cellFormat2));
                        wsheet1.addCell(new Number(20, m1, dd.getOlevel().getMath(), cellFormat2));
                        wsheet1.addCell(new Label(21, m1, dd.getOlevel().getSubj3(), cellFormat2));
                        wsheet1.addCell(new Label(22, m1, dd.getOlevel().getSubj3Grade(), cellFormat2));
                        wsheet1.addCell(new Number(23, m1, dd.getOlevel().getSubj3Point(), cellFormat2));
                        wsheet1.addCell(new Label(24, m1, dd.getOlevel().getSubj4(), cellFormat2));
                        wsheet1.addCell(new Label(25, m1, dd.getOlevel().getSubj4Grade(), cellFormat2));
                        wsheet1.addCell(new Number(26, m1, dd.getOlevel().getSubj4Point(), cellFormat2));
                        wsheet1.addCell(new Label(27, m1, dd.getOlevel().getSubj5(), cellFormat2));
                        wsheet1.addCell(new Label(28, m1, dd.getOlevel().getSubj5Grade(), cellFormat2));
                        wsheet1.addCell(new Number(29, m1, dd.getOlevel().getSubj5Point(), cellFormat2));
                        wsheet1.addCell(new Number(30, m1, dd.getOlevel().getTotaPoints(), cellFormat2));
                        wsheet1.addCell(new Number(31, m1, dd.getSittingScore(), cellFormat2));
                        wsheet1.addCell(new Label(32, m1, df.format(dd.getOlratio()), cellFormat3));
                        wsheet1.addCell(new Label(33, m1, df.format(dd.getUtmearatio()), cellFormat3));
                        wsheet1.addCell(new Label(34, m1, df.format(dd.getPutmeration()), cellFormat3));
                        wsheet1.addCell(new Label(35, m1, df.format(dd.getTotalscore()), cellFormat3));
                        wsheet1.addCell(new Label(36, m1, ddx.getMeritStatus(), cellFormat2));
                        wsheet1.addCell(new Label(37, m1, dd.getUtme().getRemarks(), cellFormat2));
                        wsheet1.addCell(new Label(38, m1, dd.getOlevel().getRemarks(), cellFormat2));
                        m1++;
                        k++;
                    }
                }
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
