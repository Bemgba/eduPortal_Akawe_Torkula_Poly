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
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Studentprogression;
import com.mnl.eduportal.entities.Students;
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
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author eaglescan
 */
public class DownloadExamCard extends HttpServlet {

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
        Students std = null;
        String logo = util.logo;
        Studentprogression sp = null;
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
            sp = sess.getStudentprogressionById(id);
            if (sp != null) {
                std = sp.getStudentsId();
                if (std.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                    logo = util.chslogo;
                }

                /////////////////////
                //Dispay card
                String regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                String rtx = regno.replaceAll("/", "_");
                String filename = ("ExaminationCard_" + rtx) + ".pdf";
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

                    PdfPCell head1a2 = new PdfPCell(new Phrase("(Office of the Registrar)", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    head1a2.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2);

                    PdfPCell head1a3 = new PdfPCell(new Phrase(sp.getSessionAdded() + ", " + sp.getSemesterAdded().toUpperCase() + " SEMESTER EXAMINATION CARD", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    head1a3.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a3.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a3);
                    PdfPCell head1a4 = new PdfPCell(new Phrase(std.getCourseId().getSchoolProgrammeId().getSchoolId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD, BaseColor.BLACK)));
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

                    PdfPTable details = new PdfPTable(1);
                    details.setWidthPercentage(100);
                    try {
                        details.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    details.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    PdfPTable head2a = new PdfPTable(3);
                    head2a.setWidthPercentage(100);
                    try {
                        head2a.setWidths(new int[]{40, 30, 30});
                    } catch (DocumentException s) {
                    }
                    String fgi;
                    String date = "";
                    String pin = "";
                    String registered = "";
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        fgi = sess.getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId()).getId();
                        List<Payments> li = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fgi, sp.getSessionAdded(), sp.getSemesterAdded());
                        if (!li.isEmpty()) {
                            Payments pay = li.get(0);
                            pin = pay.getId();

                            date = sdf.format(pay.getDatePaid());
                        }
                        registered = sdf.format(sp.getDateRegistered());
                    } catch (Exception k) {
                    }
                    head2a.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    PdfPCell paymentsa = new PdfPCell(new Phrase("Payment No: " + pin, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paymentsa.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paymentsa.setBorder(PdfPCell.NO_BORDER);
                    head2a.addCell(paymentsa);

                    PdfPCell paymentsb = new PdfPCell(new Phrase("Paid: " + date, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, BaseColor.BLACK)));
                    paymentsb.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paymentsb.setBorder(PdfPCell.NO_BORDER);
                    head2a.addCell(paymentsb);
                    PdfPCell paymentsc = new PdfPCell(new Phrase("Registered: " + registered, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paymentsc.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    paymentsc.setBorder(PdfPCell.NO_BORDER);
                    head2a.addCell(paymentsc);

                    details.addCell(head2a);
                    body.addCell(details);

                    //////////////////////
                    PdfPTable instructions = new PdfPTable(1);
                    instructions.setWidthPercentage(100);
                    try {
                        instructions.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    instructions.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    instructions.addCell("Matriculation Number: " + regno.toUpperCase());
                    instructions.addCell("To the Invigilator,");
                    instructions.addCell("Examination Number: " + util.generateExamcardNumber(regno, sp.getSemesterAdded()).toUpperCase());
                    instructions.addCell("Please admit " + std.getSurname() + " " + std.getOthernames() + " in the department of " + std.getCourseId().getDepartmentId().getName() + ", Faculty of " + std.getCourseId().getDepartmentId().getFacultyId().getName() + " to write " + sp.getSemesterAdded() + " Semester " + std.getCourseId().getSchoolProgrammeId().getProgrammeId().getName() + " Examination for " + sp.getSessionAdded() + " Session");
                    instructions.addCell(" ");
                    PdfPCell instructionsH = new PdfPCell(new Phrase("Instructions", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    instructionsH.setHorizontalAlignment(Element.ALIGN_LEFT);
                    instructionsH.setBorder(PdfPCell.NO_BORDER);
                    instructions.addCell(instructionsH);
                    instructions.addCell("1. Do not write anything on your examination card");
                    instructions.addCell("2. Do not write anything on your question paper");
                    instructions.addCell("3. Do not exchange your examination card");
                    instructions.addCell("4. Do not impersonate or be impersonated");
                    instructions.addCell("5. Fill in your particulars accurately on the front cover of the examination booklet");
                    instructions.addCell("6. Ensure that your attendance slip is fully completed and submitted");
                    instructions.addCell("7. Submit your answer script before you leave the examination hall");
                    instructions.addCell("8. Ensure that you have your student I.D Card on your person.");
                    body.addCell(instructions);
                    ////////////////////////
                    body.addCell(space);

                    String signatures = util.getExamCardSignatures(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());

                    QRCodeManagement qr = new QRCodeManagement();
                    String encoded = regno + " || " + std.getSurname() + " " + std.getOthernames() + " || " + sp.getSessionAdded() + " || " + sp.getSemesterAdded();
                    byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);

                    //BufferedImage bimage = qr.createImageFromBytes(qrcodebyte);
                    //ImageData imageData = ImageDataFactory.create(qrcodebyte);
                    //Image qrcode = new Image(imageData);
                    Image qrcode = Image.getInstance(qrcodebyte);

                    PdfPTable qrtable = new PdfPTable(3);
                    qrtable.setWidthPercentage(100);
                    try {
                        qrtable.setWidths(new int[]{20, 60, 20});
                    } catch (DocumentException s) {
                    }
                    qrtable.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPTable signt = new PdfPTable(1);
                    signt.setWidthPercentage(100);
                    try {
                        signt.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    signt.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    Image sign = Image.getInstance(signatures);
                    sign.setAlignment(Element.ALIGN_RIGHT);
                    signt.addCell(sign);
                    PdfPCell signtext = new PdfPCell(new Phrase("Registrar", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    signtext.setHorizontalAlignment(Element.ALIGN_LEFT);
                    signtext.setBorder(PdfPCell.NO_BORDER);
                    signt.addCell(signtext);

                    qrtable.addCell(signt);

                    PdfPCell hh = new PdfPCell(new Phrase(" "));
                    hh.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    hh.setBorder(PdfPCell.NO_BORDER);
                    qrtable.addCell(hh);
                    qrtable.addCell(qrcode);

                    body.addCell(qrtable);

                    PdfPTable regulations = new PdfPTable(1);
                    regulations.setWidthPercentage(100);
                    try {
                        regulations.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    regulations.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    PdfPCell reginst = new PdfPCell(new Phrase("EXAMINATION REGULATIONS", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    reginst.setHorizontalAlignment(Element.ALIGN_LEFT);
                    reginst.setBorder(PdfPCell.NO_BORDER);
                    regulations.addCell(reginst);
                    regulations.addCell("1. Only writing materials or any other specially allowed shall be introduced into the examination hall.");
                    regulations.addCell("2. Candidates must be seated in the examination hall at least 10 minutes before the scheduled time.");
                    regulations.addCell("3. No candidate shall be allowed into the examination 30 minutes after its commencement or leave the hall before the expiration of the first 45 minutes or the last 15 minutes.");
                    regulations.addCell("4. Assisting, aiding or abetting cheating in any examination is prohibited.");
                    regulations.addCell("5. Silence must be maintained during examination. To call the attention of the invigilator, only raise your hand.");
                    regulations.addCell("6. Smoking is prohibited in the examination.");
                    regulations.addCell("7. No examination answer scripts/sheets shall be taken out by any candidate.");
                    regulations.addCell("8. Introduction of cheat-notes, pieces of paper or any other material relevant to the examination or not is prohibited.");
                    regulations.addCell("9. Introduction of mobile phones and or similar electronic devices into the examination hall whether switched on or off is prohibited.");
                    regulations.addCell("10. No candidate shall be allowed to leave examination hall unaccompanied and return to the hall.");
                    regulations.addCell("11. Any infraction of any of the contents of the examination card shall constitute an examination irregularity and be subject to appropriate sanctions.");

                    body.addCell(regulations);
                    document.add(body);
                    document.newPage();

                    document.close();
                } catch (IOException | DocumentException d) {
                }
                /////////////////////////

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
