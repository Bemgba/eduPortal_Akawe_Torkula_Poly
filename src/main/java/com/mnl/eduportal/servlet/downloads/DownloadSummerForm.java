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
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.entities.Summerschoolapplication;
import com.mnl.eduportal.entities.Summerschoolregistration;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FooterPageEvent;
import com.mnl.eduportal.util.QRCodeManagement;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author eaglescan
 */
public class DownloadSummerForm extends HttpServlet {

    @EJB
    private MainSession sess;

    Settings util = new Settings();

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
        Students std;
        String logo = util.logo;
        Summerschoolapplication sp;
        List<Summerschoolregistration> lstreg;
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
            sp = sess.getSummerschoolapplicationById(id);
            if (sp != null && sp.getApplicationStatus().equalsIgnoreCase("REGISTERED")) {

                std = sp.getStudentsId();
                lstreg = sess.getSummerschoolregistrationByStudent(sp.getId());
                if (std.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                    logo = util.chslogo;
                }

                /////////////////////
                //Dispay card
                String regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                String rtx = regno.replaceAll("/", "_");
                String filename = ("SummerSchoolRegistration_" + rtx) + ".pdf";
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
                        head1.setWidths(new int[]{5, 10, 70, 10, 5});
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

                    PdfPCell head1a = new PdfPCell(new Phrase(util.universityAddress, new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL, BaseColor.BLACK)));
                    head1a.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a);

                    PdfPCell head1a3 = new PdfPCell(new Phrase("SUMMER SCHOOL REGISTRATION", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    head1a3.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a3.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a3);
                    PdfPCell head1a4 = new PdfPCell(new Phrase(sp.getSummerSchoolStatusId().getSessionStarted(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD, BaseColor.BLACK)));
                    head1a4.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a4.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a4);

                    head1.addCell(head1b);

                    String imgurl = util.baseurl + "/" + "assets/img/noperson.png";
                    try {
                        Passports pp = sess.getPassports(std.getId());
                        if (pp != null) {
                            if (pp.getUrl() != null) {
                                imgurl = util.documentroot + "/" + pp.getUrl();
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
                    PdfPTable details = new PdfPTable(1);
                    details.setWidthPercentage(100);
                    try {
                        details.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    details.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPTable head2 = new PdfPTable(2);
                    head2.setWidthPercentage(100);
                    try {
                        head2.setWidths(new int[]{30, 70});
                    } catch (DocumentException s) {
                    }
                    head2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    BaseColor fullnameolor = WebColors.getRGBColor("#132f59");

                    PdfPCell paygroupt = new PdfPCell(new Phrase("FULL NAME: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt);

                    PdfPCell paygroupd = new PdfPCell(new Phrase(std.getSurname() + " " + std.getOthernames(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd);

                    PdfPCell lgat = new PdfPCell(new Phrase("REGISTRATION NO.: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    lgat.setHorizontalAlignment(Element.ALIGN_LEFT);
                    lgat.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(lgat);

                    PdfPCell lgad = new PdfPCell(new Phrase(regno.toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    lgad.setHorizontalAlignment(Element.ALIGN_LEFT);
                    lgad.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(lgad);

                    PdfPCell schoolt = new PdfPCell(new Phrase("PROGRAMME:", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    schoolt.setHorizontalAlignment(Element.ALIGN_LEFT);
                    schoolt.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(schoolt);

                    PdfPCell bankd = new PdfPCell(new Phrase(sp.getSummerSchoolStatusId().getSchoolProgrammeId().getProgrammeId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    bankd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    bankd.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(bankd);

                    PdfPCell accnot = new PdfPCell(new Phrase("COURSE OF STUDY: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    accnot.setHorizontalAlignment(Element.ALIGN_LEFT);
                    accnot.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(accnot);

                    PdfPCell bankd2 = new PdfPCell(new Phrase(std.getCourseId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    bankd2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    bankd2.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(bankd2);

                    PdfPCell empty1 = new PdfPCell(new Phrase("LEVEL", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    empty1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty1.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty1);

                    PdfPCell empty2 = new PdfPCell(new Phrase(std.getCurrentClass(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    empty2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty2.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty2);

                    PdfPCell empty3 = new PdfPCell(new Phrase("DATE REGISTERED", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    empty3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty3.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty3);
                    String datereg = "";
                    try {
                        datereg = util.formatDate(sp.getDateRegistered());
                    } catch (Exception k) {
                    }

                    PdfPCell empty4 = new PdfPCell(new Phrase(datereg, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    empty4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty4.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty4);

                    PdfPCell empty5 = new PdfPCell(new Phrase("COURSES REGISTERED", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    empty5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty5.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty5);

                    PdfPCell empty6 = new PdfPCell(new Phrase(lstreg.size() + "", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    empty6.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty6.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty6);

                    details.addCell(head2);

                    PdfPCell detailscell = new PdfPCell(details);
                    BaseColor background = WebColors.getRGBColor("#fff2e6");
                    detailscell.setBorder(PdfPCell.NO_BORDER);
                    detailscell.setBackgroundColor(background);
                    body.addCell(detailscell);
                    body.addCell(space);

                    BaseColor itemheadingcolor = WebColors.getRGBColor("#000000");
                    BaseColor itemheadingbg = WebColors.getRGBColor("#00DD00");

                    PdfPCell payitemsh = new PdfPCell(new Phrase("COURSE DETAILS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    payitemsh.setHorizontalAlignment(Element.ALIGN_LEFT);
                    payitemsh.setBorder(PdfPCell.NO_BORDER);
                    payitemsh.setBackgroundColor(itemheadingbg);
                    body.addCell(payitemsh);

                    PdfPTable titleTb = new PdfPTable(3);
                    titleTb.setWidthPercentage(100);
                    try {
                        titleTb.setWidths(new int[]{10, 20, 70});
                    } catch (DocumentException s) {
                    }
                    //titleTb.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPCell tcode = new PdfPCell(new Phrase("S/NO", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    tcode.setHorizontalAlignment(Element.ALIGN_LEFT);
                    //tcode.setBorder(PdfPCell.NO_BORDER);
                    titleTb.addCell(tcode);
                    PdfPCell tname = new PdfPCell(new Phrase("COURSE CODE", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    tname.setHorizontalAlignment(Element.ALIGN_LEFT);
                    //tname.setBorder(PdfPCell.NO_BORDER);
                    titleTb.addCell(tname);

                    PdfPCell tcu = new PdfPCell(new Phrase("COURSE NAME", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    tcu.setHorizontalAlignment(Element.ALIGN_LEFT);
                    //tcu.setBorder(PdfPCell.NO_BORDER);
                    titleTb.addCell(tcu);

                    String coursesd = "";
                    if (!lstreg.isEmpty()) {

                        //pitable.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                        int in = 1;

                        for (Summerschoolregistration data : lstreg) {
                            try {
                                PdfPCell ticode = new PdfPCell(new Phrase(in + "", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                                ticode.setHorizontalAlignment(Element.ALIGN_LEFT);
                                //ticode.setBorder(PdfPCell.NO_BORDER);
                                titleTb.addCell(ticode);
                                PdfPCell tiname = new PdfPCell(new Phrase(data.getSemesterCourseId().getCode(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                                tiname.setHorizontalAlignment(Element.ALIGN_LEFT);
                                //tiname.setBorder(PdfPCell.NO_BORDER);
                                titleTb.addCell(tiname);

                                PdfPCell ticu = new PdfPCell(new Phrase(data.getSemesterCourseId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                                ticu.setHorizontalAlignment(Element.ALIGN_LEFT);
                                //ticu.setBorder(PdfPCell.NO_BORDER);
                                titleTb.addCell(ticu);

                                coursesd += (data.getSemesterCourseId().getCode() + ", ");

                            } catch (Exception k) {
                            }
                            in++;
                        }
                        body.addCell(titleTb);
                    }

                    body.addCell(space);

                    QRCodeManagement qr = new QRCodeManagement();
                    String encoded = regno.toUpperCase() + " || " + "Full Name: " + std.getSurname() + " " + std.getOthernames() + " || " + sp.getSummerSchoolStatusId().getSessionStarted() + " || " + coursesd;
                    byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);

                    //BufferedImage bimage = qr.createImageFromBytes(qrcodebyte);
                    //ImageData imageData = ImageDataFactory.create(qrcodebyte);
                    //Image qrcode = new Image(imageData);
                    Image qrcode = Image.getInstance(qrcodebyte);

                    PdfPTable qrtable = new PdfPTable(2);
                    qrtable.setWidthPercentage(100);
                    try {
                        qrtable.setWidths(new int[]{80, 20});
                    } catch (DocumentException s) {
                    }
                    qrtable.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPCell hh = new PdfPCell(new Phrase(" "));
                    hh.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    hh.setBorder(PdfPCell.NO_BORDER);
                    qrtable.addCell(hh);
                    qrtable.addCell(qrcode);

                    body.addCell(qrtable);

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
