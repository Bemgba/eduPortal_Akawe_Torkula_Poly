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
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FooterPageEvent;
import com.mnl.eduportal.util.Settings;
import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author eaglescan
 */
public class DownloadTranscriptForm extends HttpServlet {

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
        Applicants app = null;
        String logo = util.logo;
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
            app = sess.getApplicants(id);
            if (app != null) {
                if (app.getCourse1().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                    logo = util.chslogo;
                }

                /////////////////////
                //Dispay card
                String filename = ("Trandscript_Form" + app.getId()) + ".pdf";
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

                    PdfPTable head1 = new PdfPTable(3);
                    head1.setWidthPercentage(100);
                    try {
                        head1.setWidths(new int[]{40, 20, 40});
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
                    head1.addCell(space);
                    body.addCell(head1);

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

                    PdfPCell head1a = new PdfPCell(new Phrase(app.getCourse1().getSchoolProgrammeId().getSchoolId().getName().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL, BaseColor.BLACK)));
                    head1a.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a);

                    PdfPCell head1a2 = new PdfPCell(new Phrase("(TRANSCRIPT FORM)", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    head1a2.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2);

                    body.addCell(head1b);

                    PdfPTable head2 = new PdfPTable(2);
                    head2.setWidthPercentage(100);
                    try {
                        head2.setWidths(new int[]{40, 60});
                    } catch (DocumentException s) {
                    }
                    head2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    BaseColor fullnameolor = WebColors.getRGBColor("#132f59");

                    PdfPCell paygroupt = new PdfPCell(new Phrase("APPLICATION NO: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt);

                    PdfPCell paygroupd = new PdfPCell(new Phrase(app.getId().toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd);

                    PdfPCell paygroupt2 = new PdfPCell(new Phrase("FULL NAME: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt2.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt2);

                    PdfPCell paygroupd2 = new PdfPCell(new Phrase(app.getSurname() + " " + app.getOthernames(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd2.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd2);

                    PdfPCell paygroupt3 = new PdfPCell(new Phrase("COURSE APPLIED FOR: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt3.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt3);

                    PdfPCell paygroupd3 = new PdfPCell(new Phrase(app.getCourse1().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd3.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd3);

                    PdfPCell paygroupt4 = new PdfPCell(new Phrase("DEPARTMENT: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt4.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt4);

                    PdfPCell paygroupd4 = new PdfPCell(new Phrase(app.getCourse1().getDepartmentId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd4.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd4);

                    PdfPCell paygroupt5 = new PdfPCell(new Phrase("FACULTY: ", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    paygroupt5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupt5.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupt5);

                    PdfPCell paygroupd5 = new PdfPCell(new Phrase(app.getCourse1().getDepartmentId().getFacultyId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.NORMAL, fullnameolor)));
                    paygroupd5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    paygroupd5.setBorder(PdfPCell.NO_BORDER);
                    head2.addCell(paygroupd5);

                    body.addCell(head2);
                    body.addCell(space);

                    //////////////////////
                    PdfPTable instructions = new PdfPTable(1);
                    instructions.setWidthPercentage(100);
                    try {
                        instructions.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    instructions.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    instructions.addCell("Note: TO THE ACADEMIC RECORDS OFFICE OF APPLICANTS ALMAMATER (THE UNIVERSITY AND/OR OTHER HIGHER INSTITUTION(S) ATTENDED)");
                    instructions.addCell("This form and transcript should be mailed urgently to:");

                    body.addCell(instructions);
                    ////////////////////////
                    body.addCell(space);

                    PdfPTable head3 = new PdfPTable(2);
                    head3.setWidthPercentage(100);
                    try {
                        head3.setWidths(new int[]{40, 60});
                    } catch (DocumentException s) {
                    }
                    head3.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    head3.addCell(space);

                    PdfPTable instructions2 = new PdfPTable(1);
                    instructions2.setWidthPercentage(100);
                    try {
                        instructions2.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    instructions2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    instructions2.addCell("THE SECRETARY,");
                    instructions2.addCell(app.getCourse1().getSchoolProgrammeId().getSchoolId().getName().toUpperCase());
                    instructions2.addCell(util.universityName.toUpperCase());
                    instructions2.addCell("NIGERIA");

                    head3.addCell(instructions2);

                    body.addCell(head3);

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
