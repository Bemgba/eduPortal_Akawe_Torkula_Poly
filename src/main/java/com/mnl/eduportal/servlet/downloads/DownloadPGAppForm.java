/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.downloads;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.html.WebColors;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsothers;
import com.mnl.eduportal.entities.Applicantsreferees;
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.entities.Schoolsattended;
import com.mnl.eduportal.entities.Uploadeddocuments;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FooterPageEvent;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author eaglescan
 */
public class DownloadPGAppForm extends HttpServlet {

    @EJB
    private MainSession sess;

    Settings util = new Settings();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * @throws com.itextpdf.text.DocumentException
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, DocumentException {
        String id = request.getParameter("id");
        Applicants app = null;
        Applicantsothers other = null;
        String logo = util.logo;
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
            app = sess.getApplicants(id);
            if (app != null) {
                other = app.getApplicantsothers();
                /////////////////////
                //Dispay card
                String filename = ("PG_Application_" + app.getId()) + ".pdf";
                response.setContentType("application/pdf");
                response.setHeader("Content-disposition", "inline; filename=" + filename);
                try {

                    Document document = new Document(PageSize.A4);
                    PdfWriter pdfWriter = PdfWriter.getInstance(document, response.getOutputStream());
                    pdfWriter.setEncryption(null, null, ~PdfWriter.ALLOW_COPY, PdfWriter.STANDARD_ENCRYPTION_128);
                    pdfWriter.createXmpMetadata();
                    FooterPageEvent event = new FooterPageEvent();
                    pdfWriter.setPageEvent(event);
                    document.setMargins(20, 20, 5, 5);
                    document.addAuthor(util.universityName);
                    document.addCreator("Mfedoo Nig Ltd (07032163353)");
                    document.addSubject(filename);
                    document.addCreationDate();
                    document.addTitle(filename);
                    // step 3
                    document.open();

                    PdfPTable body = new PdfPTable(1);
                    body.setWidthPercentage(100);
                    try {
                        body.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    body.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPTable head1 = new PdfPTable(5);
                    head1.setWidthPercentage(100);
                    try {
                        head1.setWidths(new int[]{5, 15, 60, 15, 5});
                    } catch (DocumentException s) {
                    }
                    head1.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPCell space = new PdfPCell(new Phrase(" ", new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD, BaseColor.BLACK)));
                    space.setHorizontalAlignment(Element.ALIGN_CENTER);
                    space.setBorder(PdfPCell.NO_BORDER);

                    head1.addCell(space);
                    Image image1 = Image.getInstance(util.baseurl + "/" + logo);
                    image1.setAlignment(Element.ALIGN_RIGHT);
                    head1.addCell(image1);

                    PdfPTable head1b = new PdfPTable(1);
                    head1b.setWidthPercentage(100);
                    try {
                        head1b.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    head1b.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPCell head10 = new PdfPCell(new Phrase(util.universityName.toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    head10.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head10.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head10);

                    PdfPCell head1a = new PdfPCell(new Phrase("APPLICATION FOR ADMISSION INTO", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL, BaseColor.BLACK)));
                    head1a.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a);

                    PdfPCell head1a3 = new PdfPCell(new Phrase(app.getCourse1().getSchoolProgrammeId().getSchoolId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    head1a3.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a3.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a3);
                    PdfPCell head1a4 = new PdfPCell(new Phrase("APPLICATION NO: " + app.getId().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD, BaseColor.BLACK)));
                    head1a4.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a4.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a4);

                    head1.addCell(head1b);

                    String imgurl = util.baseurl + "/" + "assets/img/noperson.png";
                    try {
                        Users usr = sess.getUsersByEmail(app.getEmailAddress());
                        if (usr != null) {
                            Passports pp = sess.getPassports(usr.getId());
                            if (pp != null) {
                                if (pp.getUrl() != null) {
                                    imgurl = util.documentroot + "/" + pp.getUrl();
                                }
                            }
                        }

                    } catch (Exception hc) {
                    }
                    Image pasport = Image.getInstance(imgurl);
                    pasport.setAlignment(Element.ALIGN_RIGHT);
                    head1.addCell(pasport);

                    head1.addCell(space);
                    body.addCell(head1);

                    ///////////////////////////
                    BaseColor itemheadingcolor = WebColors.getRGBColor("#000000");
                    BaseColor itemheadingbg = WebColors.getRGBColor("#c0e6ff");

                    PdfPCell payitemsh = new PdfPCell(new Phrase("PERSONAL DETAILS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    payitemsh.setHorizontalAlignment(Element.ALIGN_LEFT);
                    payitemsh.setBorder(PdfPCell.NO_BORDER);
                    payitemsh.setBackgroundColor(itemheadingbg);
                    body.addCell(payitemsh);

                    PdfPTable head2 = new PdfPTable(2);
                    head2.setWidthPercentage(100);
                    try {
                        head2.setWidths(new int[]{30, 70});
                    } catch (DocumentException s) {
                    }
                    head2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    head2.addCell("FULL NAME:");
                    head2.addCell(app.getSurname().toUpperCase() + " " + app.getOthernames());
                    head2.addCell("GENDER:");
                    head2.addCell(app.getGender());
                    head2.addCell("DATE OF BIRTH:");
                    head2.addCell(app.getDateOfBirth());
                    head2.addCell("PHONE NO:");
                    head2.addCell(app.getPhoneNo());
                    head2.addCell("EMAIL ADDRESS:");
                    head2.addCell(app.getEmailAddress());
                    head2.addCell("MARITAL STATUS:");
                    head2.addCell(app.getMaritalStatus());
                    head2.addCell("NATIONALIST:");
                    String country="";
                    try{
                        country =app.getCountry().getName();
                    }catch(Exception k){}
                    head2.addCell(country);
                    head2.addCell("STATE OF ORIGIN:");
                    String state ="";
                    String lga="";
                    try{
                       state= app.getStateOfOrigin().getName();
                    }catch(Exception k){}
                    try{
                      lga=app.getLga().getName();
                    }catch(Exception k){}
                    head2.addCell(state);
                    head2.addCell("LGA:");
                    head2.addCell(lga);
                    head2.addCell("CONTACT ADDRESS:");
                    head2.addCell(app.getContactAddress());
                    body.addCell(head2);

                    PdfPCell coursed = new PdfPCell(new Phrase("COURSE DETAILS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    coursed.setHorizontalAlignment(Element.ALIGN_LEFT);
                    coursed.setBorder(PdfPCell.NO_BORDER);
                    coursed.setBackgroundColor(itemheadingbg);
                    body.addCell(coursed);
                    PdfPTable det1 = new PdfPTable(2);
                    det1.setWidthPercentage(100);
                    try {
                        det1.setWidths(new int[]{30, 70});
                    } catch (DocumentException s) {
                    }
                    det1.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    det1.addCell("COURSE APPLIED:");
                    det1.addCell(app.getCourse1().getName());
                    det1.addCell("DEPARTMENT:");
                    det1.addCell(app.getCourse1().getDepartmentId().getName());
                    det1.addCell("FACULTY:");
                    det1.addCell(app.getCourse1().getDepartmentId().getFacultyId().getName());
                    det1.addCell("SESSION:");
                    det1.addCell(app.getSession());
                    det1.addCell("PROGRAMME:");
                    det1.addCell(app.getCourse1().getSchoolProgrammeId().getProgrammeId().getName());
                    det1.addCell("DURATION (semesters):");
                    det1.addCell(app.getCourse1().getDefaultDuration() + "");
                    body.addCell(det1);

                    PdfPCell schoolsd = new PdfPCell(new Phrase("INSTITUTIONS ATTENDED", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    schoolsd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    schoolsd.setBorder(PdfPCell.NO_BORDER);
                    schoolsd.setBackgroundColor(itemheadingbg);
                    body.addCell(schoolsd);
                    try {
                        PdfPTable titleTb = new PdfPTable(3);
                        titleTb.setWidthPercentage(100);
                        try {
                            titleTb.setWidths(new int[]{50, 25, 25});
                        } catch (DocumentException s) {
                        }
                        //titleTb.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                        PdfPCell tcode = new PdfPCell(new Phrase("NAME", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tcode.setHorizontalAlignment(Element.ALIGN_LEFT);
                        //tcode.setBorder(PdfPCell.NO_BORDER);
                        titleTb.addCell(tcode);
                        PdfPCell tname = new PdfPCell(new Phrase("PERIOD", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tname.setHorizontalAlignment(Element.ALIGN_LEFT);
                        //tname.setBorder(PdfPCell.NO_BORDER);
                        titleTb.addCell(tname);

                        PdfPCell tcu = new PdfPCell(new Phrase("CERTIFICATE", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tcu.setHorizontalAlignment(Element.ALIGN_LEFT);
                        //tcu.setBorder(PdfPCell.NO_BORDER);
                        titleTb.addCell(tcu);

                        List<Schoolsattended> lschatt = sess.getSchoolsattendedByRegno(app.getId());
                        if (!lschatt.isEmpty()) {

                            for (Schoolsattended data : lschatt) {
                                try {
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                    String per = sdf.format(data.getStartDate()) + " To " + sdf.format(data.getEndDate());
                                    titleTb.addCell(new PdfPCell(new Phrase(per, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getQualification(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                } catch (Exception k) {
                                }
                            }
                            body.addCell(titleTb);
                        }

                    } catch (Exception a) {
                    }

                    PdfPCell refd = new PdfPCell(new Phrase("REFEREES", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    refd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    refd.setBorder(PdfPCell.NO_BORDER);
                    refd.setBackgroundColor(itemheadingbg);
                    body.addCell(refd);
                    try {
                        PdfPTable titleTb = new PdfPTable(4);
                        titleTb.setWidthPercentage(100);
                        try {
                            titleTb.setWidths(new int[]{30, 25, 20, 25});
                        } catch (DocumentException s) {
                        }
                        //titleTb.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                        PdfPCell tcode = new PdfPCell(new Phrase("NAME", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tcode.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleTb.addCell(tcode);
                        PdfPCell tname = new PdfPCell(new Phrase("EMAIL", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tname.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleTb.addCell(tname);

                        PdfPCell tcu = new PdfPCell(new Phrase("PHONE NO", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        tcu.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleTb.addCell(tcu);
                        PdfPCell rank = new PdfPCell(new Phrase("RANK", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        rank.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titleTb.addCell(rank);

                        List<Applicantsreferees> lschatt = sess.getApplicantsrefereesByRegno(app.getId());
                        if (!lschatt.isEmpty()) {

                            for (Applicantsreferees data : lschatt) {
                                try {
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getEmailAddress(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getPhoneNo(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getRank(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                } catch (Exception k) {
                                }
                            }
                            body.addCell(titleTb);
                        }

                    } catch (Exception a) {
                    }

                    PdfPCell docsd = new PdfPCell(new Phrase("DOCUMENTS SUBMITTED", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    docsd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    docsd.setBorder(PdfPCell.NO_BORDER);
                    docsd.setBackgroundColor(itemheadingbg);
                    body.addCell(docsd);
                    try {
                        PdfPTable titleTb = new PdfPTable(1);
                        titleTb.setWidthPercentage(100);
                        try {
                            titleTb.setWidths(new int[]{100});
                        } catch (DocumentException s) {
                        }

                        List<Uploadeddocuments> lschatt = sess.getUploadeddocumentsByRegno(app.getId());
                        if (!lschatt.isEmpty()) {

                            for (Uploadeddocuments data : lschatt) {
                                try {
                                    titleTb.addCell(new PdfPCell(new Phrase(data.getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK))));
                                } catch (Exception k) {
                                }
                            }
                            body.addCell(titleTb);
                        }

                    } catch (Exception a) {
                    }

                    document.add(body);
                    document.newPage();
                    document.close();
                } catch (DocumentException | IOException j) {
                }

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
        try {
            processRequest(request, response);
        } catch (DocumentException ex) {
        }
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
        try {
            processRequest(request, response);
        } catch (DocumentException ex) {
        }
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
