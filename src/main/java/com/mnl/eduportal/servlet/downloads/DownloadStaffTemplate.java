package com.mnl.eduportal.servlet.downloads;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.format.Colour;

/**
 * Servlet to generate Excel template for staff bulk upload
 */
@WebServlet(name = "DownloadStaffTemplate", urlPatterns = {"/DownloadStaffTemplate"})
public class DownloadStaffTemplate extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String filename = "Staff_Bulk_Upload_Template.xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);
        
        try {
            WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
            WritableSheet wsheet = wworkbook.createSheet("Staff Template", 0);
            
            // Create header format (bold, colored background)
            WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.BOLD);
            WritableCellFormat headerFormat = new WritableCellFormat(headerFont);
            headerFormat.setBackground(Colour.GRAY_25);
            
            // Add headers with format
            wsheet.addCell(new Label(0, 0, "STAFF_NO", headerFormat));
            wsheet.addCell(new Label(1, 0, "TITLE", headerFormat));
            wsheet.addCell(new Label(2, 0, "SURNAME", headerFormat));
            wsheet.addCell(new Label(3, 0, "OTHERNAMES", headerFormat));
            wsheet.addCell(new Label(4, 0, "GENDER", headerFormat));
            wsheet.addCell(new Label(5, 0, "PERSONAL_EMAIL", headerFormat));
            wsheet.addCell(new Label(6, 0, "PHONE_NO", headerFormat));
            wsheet.addCell(new Label(7, 0, "DATE_OF_BIRTH", headerFormat));
            wsheet.addCell(new Label(8, 0, "MARITAL_STATUS", headerFormat));
            
            // Add sample data row
            wsheet.addCell(new Label(0, 1, "STAFF001"));
            wsheet.addCell(new Label(1, 1, "Dr"));
            wsheet.addCell(new Label(2, 1, "Doe"));
            wsheet.addCell(new Label(3, 1, "John"));
            wsheet.addCell(new Label(4, 1, "Male"));
            wsheet.addCell(new Label(5, 1, "john.doe@example.com"));
            wsheet.addCell(new Label(6, 1, "08012345678"));
            wsheet.addCell(new Label(7, 1, "1980-01-15"));
            wsheet.addCell(new Label(8, 1, "Married"));
            
            // Add instructions sheet
            WritableSheet instructionsSheet = wworkbook.createSheet("Instructions", 1);
            instructionsSheet.addCell(new Label(0, 0, "STAFF BULK UPLOAD INSTRUCTIONS", headerFormat));
            instructionsSheet.addCell(new Label(0, 2, "REQUIRED FIELDS (Must be filled):"));
            instructionsSheet.addCell(new Label(0, 3, "1. STAFF_NO - Unique staff number (e.g., STAFF001)"));
            instructionsSheet.addCell(new Label(0, 4, "2. SURNAME - Staff member's surname"));
            instructionsSheet.addCell(new Label(0, 5, "3. OTHERNAMES - Staff member's other names"));
            instructionsSheet.addCell(new Label(0, 6, "4. PERSONAL_EMAIL - Valid email address (will be used for login)"));
            instructionsSheet.addCell(new Label(0, 7, "5. PHONE_NO - 11-digit phone number"));
            
            instructionsSheet.addCell(new Label(0, 9, "OPTIONAL FIELDS:"));
            instructionsSheet.addCell(new Label(0, 10, "- TITLE: Mr, Mrs, Miss, Dr, Prof, Engr, Arc"));
            instructionsSheet.addCell(new Label(0, 11, "- GENDER: Male or Female"));
            instructionsSheet.addCell(new Label(0, 12, "- DATE_OF_BIRTH: Format YYYY-MM-DD (e.g., 1980-01-15)"));
            instructionsSheet.addCell(new Label(0, 13, "- MARITAL_STATUS: Single, Married, Divorced, Widowed"));
            
            instructionsSheet.addCell(new Label(0, 15, "IMPORTANT NOTES:"));
            instructionsSheet.addCell(new Label(0, 16, "- Do not modify the header row"));
            instructionsSheet.addCell(new Label(0, 17, "- Staff numbers must be unique"));
            instructionsSheet.addCell(new Label(0, 18, "- Email addresses must be unique"));
            instructionsSheet.addCell(new Label(0, 19, "- Staff number will be used as initial password"));
            instructionsSheet.addCell(new Label(0, 20, "- Duplicate records will be skipped"));
            instructionsSheet.addCell(new Label(0, 21, "- Delete the sample data row before uploading"));
            
            wworkbook.write();
            wworkbook.close();
            
            System.out.println("Staff template generated successfully");
            
        } catch (Exception e) {
            System.out.println("Error generating staff template: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Error generating template: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Staff Template Download Servlet";
    }
}
