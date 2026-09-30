/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet;

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
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.ConvertNumberToWord;
import com.mnl.eduportal.util.FooterPageEvent;
import com.mnl.eduportal.util.QRCodeManagement;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author eaglescan
 */
public class DownloadInvoice extends HttpServlet {

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
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
        }
        Paymentreference stf = null;
        String logo=util.logo;
        try {

            stf = sess.getPaymentreference(id);
        } catch (Exception js) {
        }
        String filename = ("Invoice_" + id + util.getCurrentTime()).replaceAll(" ", "") + ".pdf";
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

            if (stf != null) {

                String regno = stf.getPayerRegistrationIo();
                String fromchs = " FOR MAIN UNIVERSITY";

                try {
                    Students std = sess.getStudentsById(stf.getPayerId());
                    if (std != null) {
                        regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                        if (std.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                            fromchs = " FOR COLLEGE OF HEALTH SCIENCE";
                            logo=util.chslogo;
                        }
                    }
                } catch (Exception k) {
                }

                try {
                    PdfPTable body = new PdfPTable(1);
                    body.setWidthPercentage(100);
                    try {
                        body.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    body.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPTable head1 = new PdfPTable(4);
                    head1.setWidthPercentage(100);
                    try {
                        head1.setWidths(new int[]{5, 10, 80, 5});
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

                    PdfPCell head1a2 = new PdfPCell(new Phrase("BANK PAYMENT REFERENCE " + fromchs, new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    head1a2.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2);

                    PdfPCell head1a2b = new PdfPCell(new Phrase("UNPAID", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.RED)));
                    head1a2b.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2b.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2b);

                    PdfPCell head1a2c = new PdfPCell(new Phrase(stf.getId(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD, BaseColor.RED)));
                    head1a2c.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2c.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2c);

                    head1.addCell(head1b);
                    head1.addCell(space);

                    body.addCell(head1);
                    //PdfPCell space1 = new PdfPCell(new Phrase(" ", new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD, BaseColor.BLACK)));
                    //space1.setHorizontalAlignment(Element.ALIGN_CENTER);
                    //space1.setBorder(PdfPCell.NO_BORDER);
                    //body.addCell(space1);

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

                    PdfPCell paygroupd = new PdfPCell(new Phrase(stf.getPayerName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd);

                    PdfPCell lgat = new PdfPCell(new Phrase("REGISTRATION NO.: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    lgat.setHorizontalAlignment(Element.ALIGN_LEFT);
                    lgat.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(lgat);

                    PdfPCell lgad = new PdfPCell(new Phrase(regno, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    lgad.setHorizontalAlignment(Element.ALIGN_LEFT);
                    lgad.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(lgad);

                    PdfPCell bankt = new PdfPCell(new Phrase("SCHOOL: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    bankt.setHorizontalAlignment(Element.ALIGN_LEFT);
                    bankt.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(bankt);

                    try {
                        String school = "Not available";
                        String prog = "Not available";
                        String cours = "Not available";
                        try {
                            Courses cos = sess.getCourses(stf.getCourseId());
                            if (cos != null) {
                                school = cos.getSchoolProgrammeId().getSchoolId().getName();
                                prog = cos.getSchoolProgrammeId().getProgrammeId().getName();
                                cours = cos.getName();
                            }
                        } catch (Exception k) {
                        }
                        PdfPCell bankd = new PdfPCell(new Phrase(school, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                        bankd.setHorizontalAlignment(Element.ALIGN_LEFT);
                        bankd.setBorder(PdfPCell.NO_BORDER);
                        head2.addCell(bankd);

                        PdfPCell schoolt = new PdfPCell(new Phrase("PROGRAMME:", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        schoolt.setHorizontalAlignment(Element.ALIGN_LEFT);
                        schoolt.setBorder(PdfPCell.NO_BORDER);
                        head2.addCell(schoolt);

                        PdfPCell bankdb = new PdfPCell(new Phrase(prog, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                        bankdb.setHorizontalAlignment(Element.ALIGN_LEFT);
                        bankdb.setBorder(PdfPCell.NO_BORDER);
                        head2.addCell(bankdb);

                        PdfPCell accnot = new PdfPCell(new Phrase("COURSE: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                        accnot.setHorizontalAlignment(Element.ALIGN_LEFT);
                        accnot.setBorder(PdfPCell.NO_BORDER);
                        head2.addCell(accnot);

                        PdfPCell bankdc = new PdfPCell(new Phrase(cours, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                        bankdc.setHorizontalAlignment(Element.ALIGN_LEFT);
                        bankdc.setBorder(PdfPCell.NO_BORDER);
                        head2.addCell(bankdc);
                    } catch (Exception k) {

                    }

                    PdfPCell empty1 = new PdfPCell(new Phrase("LEVEL", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    empty1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty1.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty1);

                    PdfPCell empty2 = new PdfPCell(new Phrase(stf.getLevel(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    empty2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    empty2.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(empty2);

                    details.addCell(head2);

                    PdfPCell detailscell = new PdfPCell(details);
                    BaseColor background = WebColors.getRGBColor("#fff2e6");
                    detailscell.setBorder(PdfPCell.NO_BORDER);
                    detailscell.setBackgroundColor(background);
                    body.addCell(detailscell);
                    body.addCell(space);

                    //////////////////////
                    //allowances
                    BaseColor itemheadingcolor = WebColors.getRGBColor("#000000");
                    BaseColor itemheadingbg = WebColors.getRGBColor("#00DD00");
                    PdfPCell payitemsh = new PdfPCell(new Phrase("PAYMENT DETAILS ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, itemheadingcolor)));
                    payitemsh.setHorizontalAlignment(Element.ALIGN_LEFT);
                    payitemsh.setBorder(PdfPCell.NO_BORDER);
                    payitemsh.setBackgroundColor(itemheadingbg);
                    body.addCell(payitemsh);

                    PdfPTable pitable = new PdfPTable(2);
                    pitable.setWidthPercentage(100);
                    try {
                        pitable.setWidths(new int[]{35, 65});
                    } catch (DocumentException s) {
                    }
                    pitable.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    try {
                        PdfPCell piitemsd = new PdfPCell(new Phrase("PAYMENT DETAILS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                        piitemsd.setHorizontalAlignment(Element.ALIGN_LEFT);
                        piitemsd.setBorder(PdfPCell.NO_BORDER);
                        pitable.addCell(piitemsd);
                        PdfPCell piamountd = new PdfPCell(new Phrase(stf.getFeesGroupId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                        piamountd.setHorizontalAlignment(Element.ALIGN_LEFT);
                        piamountd.setBorder(PdfPCell.NO_BORDER);
                        pitable.addCell(piamountd);
                    } catch (Exception k) {
                    }

                    PdfPCell piitemsd = new PdfPCell(new Phrase("PAYMENT ID", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd);
                    PdfPCell piamountd = new PdfPCell(new Phrase(stf.getId(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd);

                    PdfPCell piitemsd1 = new PdfPCell(new Phrase("DATE GENERATED", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd1.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd1);
                    PdfPCell piamountd1 = new PdfPCell(new Phrase(util.formatDate(stf.getDateGenerated()), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd1.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd1);

                    PdfPCell piitemsd2 = new PdfPCell(new Phrase("SESSION", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd2.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd2);
                    PdfPCell piamountd2 = new PdfPCell(new Phrase(stf.getSession(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd2.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd2);

                    PdfPCell piitemsd3 = new PdfPCell(new Phrase("SEMESTER", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd3.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd3);
                    PdfPCell piamountd3 = new PdfPCell(new Phrase(stf.getSemester(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd3.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd3);

                    PdfPCell piitemsd4 = new PdfPCell(new Phrase("AMOUNT", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd4.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd4);
                    PdfPCell piamountd4 = new PdfPCell(new Phrase(util.formatno.format(stf.getAmount()), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd4.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd4);

                    PdfPCell piitemsd5 = new PdfPCell(new Phrase("IN WORDS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piitemsd5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piitemsd5.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piitemsd5);
                    String inwords = stf.getAmount() + "";
                    ConvertNumberToWord words = new ConvertNumberToWord();
                    try {
                        inwords = words.convertAmount(stf.getAmount());
                    } catch (Exception k) {
                    }
                    PdfPCell piamountd5 = new PdfPCell(new Phrase(inwords, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    piamountd5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    piamountd5.setBorder(PdfPCell.NO_BORDER);
                    pitable.addCell(piamountd5);

                    body.addCell(pitable);

                    body.addCell(space);

                    QRCodeManagement qr = new QRCodeManagement();
                    String encoded = "Payment ID: " + stf.getId() + " | " + "Full Name: " + stf.getPayerName() + " | Registration No: " + stf.getPayerRegistrationIo() + " | Amount: " + util.formatno.format(stf.getAmount());
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

//Image qrcode = new Image(ImageDataFactory.create(QRCODE));
                    //qrcode.setHeight(80);
                    //qrcode.setWidth(80);
                    //qrcode.setBorder(Border.NO_BORDER);
                    //qrcode.setHorizontalAlignment(HorizontalAlignment.RIGHT);
                    //qrcode.setPadding(1);
                    //qrcode.setMarginTop(250);
                    //.setPaddingTop(PageSize.A4.rotate().getHeight()- qrcode.getImageHeight());
                    //qrcode.setPaddingTop(detailsTable.getHeight().getValue() - qrcode.getImageHeight());
                    body.addCell(qrtable);

                    document.add(body);
                    document.newPage();

                } catch (DocumentException | IOException j) {
                }
            }

            document.close();
        } catch (IOException | DocumentException d) {
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
            Logger.getLogger(DownloadReceipt.class.getName()).log(Level.SEVERE, null, ex);
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
