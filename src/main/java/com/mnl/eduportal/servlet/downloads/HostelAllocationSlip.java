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
import com.mnl.eduportal.entities.Hostelallocation;
import com.mnl.eduportal.entities.Hostelapplication;
import com.mnl.eduportal.entities.Passports;
import com.mnl.eduportal.entities.Payments;
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
public class HostelAllocationSlip extends HttpServlet {

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
        String id = request.getParameter("id5");
        Students std = null;
        String logo = util.logo;
        Hostelapplication sp = null;
        Hostelallocation all = null;
        if (id != null && id.length() > 0) {
            id = util.decryptText(id);
            sp = (Hostelapplication) sess.getSingleObject(Hostelapplication.class, id);
            if (sp != null && sp.getApplicationStatus().equalsIgnoreCase("ALLOCATED")) {
                std = sp.getStudentId();
                all = sess.getHostelallocation(std.getId(), sp.getSessions());
                if (all != null && all.getStatus().equalsIgnoreCase("ALLOCATED")) {
                if (std.getCourseId().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                    logo = util.chslogo;
                }

                /////////////////////
                //Dispay card
                String regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                String rtx = regno.replaceAll("/", "_");
                String filename = ("HostelAllocation_" + rtx) + ".pdf";
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

                    PdfPCell head1a2 = new PdfPCell(new Phrase("(Students Affairs Division)", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    head1a2.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a2.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a2);

                    PdfPCell head1a3 = new PdfPCell(new Phrase(sp.getSessions() + " HOSTEL ALLOCATION SLIP", new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    head1a3.setHorizontalAlignment(Element.ALIGN_CENTER);
                    head1a3.setBorder(PdfPCell.NO_BORDER);
                    head1b.addCell(head1a3);

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

                    String fgi = "10155";
                    String date = "";
                    String pin = "";
                    String level = "";
                    double amount = 0;
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        List<Payments> li = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fgi, sp.getSessions(), "Session");
                        if (!li.isEmpty()) {
                            Payments pay = li.get(0);
                            pin = pay.getId();
                            level = pay.getLevel();
                            amount = pay.getAmount();

                            date = sdf.format(pay.getDatePaid());
                        }
                    } catch (Exception k) {
                    }
                    body.addCell("PERSONAL DETAILS");
                    //////////////////////
                    PdfPTable data1 = new PdfPTable(4);
                    data1.setWidthPercentage(100);
                    try {
                        data1.setWidths(new int[]{20, 30, 15, 35});
                    } catch (DocumentException s) {
                    }
                    data1.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    data1.addCell("Registration No: ");
                    PdfPCell cell1 = new PdfPCell(new Phrase(regno.toUpperCase(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell1.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell1);

                    data1.addCell("Session: ");
                    PdfPCell cell2 = new PdfPCell(new Phrase(sp.getSessions(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell2.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell2);
                    data1.addCell("Name: ");
                    PdfPCell cell3 = new PdfPCell(new Phrase(std.getSurname() + " " + std.getOthernames(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell3.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell3);
                    data1.addCell("Nationality: ");
                    String nat = std.getNationality() != null ? std.getNationality().getName() : "";
                    PdfPCell cell4 = new PdfPCell(new Phrase(nat, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell4.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell4);
                    data1.addCell("Course: ");
                    PdfPCell cell5 = new PdfPCell(new Phrase(std.getCourseId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell5.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell5.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell5);
                    data1.addCell("State: ");
                    String sta = std.getStateOfOrigin() != null ? std.getStateOfOrigin().getName() : "";
                    PdfPCell cell6 = new PdfPCell(new Phrase(sta, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell6.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell6.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell6);
                    data1.addCell("Gender: ");
                    PdfPCell cell7 = new PdfPCell(new Phrase(std.getGender(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell7.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell7.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell7);
                    data1.addCell("LGA: ");
                    String lga = std.getLga() != null ? std.getLga().getName() : "";
                    PdfPCell cell8 = new PdfPCell(new Phrase(lga, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell8.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell8.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell8);
                    data1.addCell("Department: ");
                    PdfPCell cell9 = new PdfPCell(new Phrase(std.getCourseId().getDepartmentId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell9.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell9.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell9);
                    data1.addCell("Address: ");
                    PdfPCell cell10 = new PdfPCell(new Phrase(std.getContactAddress(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell10.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell10.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell10);
                    data1.addCell("Faculty: ");
                    PdfPCell cell11 = new PdfPCell(new Phrase(std.getCourseId().getDepartmentId().getFacultyId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell11.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell11.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell11);
                    data1.addCell("Phone Number: ");
                    PdfPCell cell12 = new PdfPCell(new Phrase(std.getPhoneNo(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell12.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell12.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell12);
                    data1.addCell("Level: ");
                    PdfPCell cell13 = new PdfPCell(new Phrase(level, new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cell13.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cell13.setBorder(PdfPCell.NO_BORDER);
                    data1.addCell(cell13);
                    data1.addCell(" ");
                    data1.addCell(" ");
                    body.addCell(data1);

                    body.addCell("FOR OFFICIL USE");

                    PdfPTable data2 = new PdfPTable(4);
                    data2.setWidthPercentage(100);
                    try {
                        data2.setWidths(new int[]{20, 30, 20, 30});
                    } catch (DocumentException s) {
                    }
                    data2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);
                    data2.addCell("Hostel Allocated: ");
                    PdfPCell cellb1 = new PdfPCell(new Phrase(sp.getHostelId().getName(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cellb1.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cellb1.setBorder(PdfPCell.NO_BORDER);
                    data2.addCell(cellb1);
                    data2.addCell("Location: ");
                    PdfPCell cellb2 = new PdfPCell(new Phrase(sp.getHostelId().getLocation(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cellb2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cellb2.setBorder(PdfPCell.NO_BORDER);
                    data2.addCell(cellb2);
                    data2.addCell("Room Number: ");
                    PdfPCell cellb3 = new PdfPCell(new Phrase(all.getHostelRoomId().getRoomNo(), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cellb3.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cellb3.setBorder(PdfPCell.NO_BORDER);
                    data2.addCell(cellb3);
                    data2.addCell("Amount Paid: ");
                    PdfPCell cellb4 = new PdfPCell(new Phrase(util.formatno.format(amount), new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD, BaseColor.BLACK)));
                    cellb4.setHorizontalAlignment(Element.ALIGN_LEFT);
                    cellb4.setBorder(PdfPCell.NO_BORDER);
                    data2.addCell(cellb4);

                    body.addCell(data2);

                    ////////////////////////
                    body.addCell(space);
                    body.addCell(space);

                    QRCodeManagement qr = new QRCodeManagement();
                    String encoded = regno + " || " + std.getSurname() + " " + std.getOthernames() + " || " + sp.getHostelId().getName() + " || " + "1A";
                    byte[] qrcodebyte = qr.createQRCode(encoded, 30, 30);

                    //BufferedImage bimage = qr.createImageFromBytes(qrcodebyte);
                    //ImageData imageData = ImageDataFactory.create(qrcodebyte);
                    //Image qrcode = new Image(imageData);
                    Image qrcode = Image.getInstance(qrcodebyte);

                    PdfPTable qrtable = new PdfPTable(3);
                    qrtable.setWidthPercentage(100);
                    try {
                        qrtable.setWidths(new int[]{40, 40, 20});
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

                    signt.addCell("______________________");
                    PdfPCell signtext = new PdfPCell(new Phrase("Date/Sign Dean:", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    signtext.setHorizontalAlignment(Element.ALIGN_LEFT);
                    signtext.setBorder(PdfPCell.NO_BORDER);
                    signt.addCell(signtext);

                    qrtable.addCell(signt);

                    PdfPTable signt2 = new PdfPTable(1);
                    signt2.setWidthPercentage(100);
                    try {
                        signt2.setWidths(new int[]{100});
                    } catch (DocumentException s) {
                    }
                    signt2.getDefaultCell().setBorder(PdfPCell.NO_BORDER);

                    signt2.addCell("______________________");
                    PdfPCell signtext2 = new PdfPCell(new Phrase("Date/Sign Student Affairs Officer:", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLDITALIC, BaseColor.BLACK)));
                    signtext2.setHorizontalAlignment(Element.ALIGN_LEFT);
                    signtext2.setBorder(PdfPCell.NO_BORDER);
                    signt2.addCell(signtext2);

                    qrtable.addCell(signt2);
                    qrtable.addCell(qrcode);

                    body.addCell(qrtable);

                    document.add(body);
                    document.newPage();

                    document.close();
                } catch (IOException | DocumentException d) {
                }

            
        
    

    /////////////////////////
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
