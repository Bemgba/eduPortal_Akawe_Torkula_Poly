package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.*;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FileProcessingTracker;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.reports.UploadReport;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

/**
 * Servlet for bulk staff upload from Excel file
 */
@WebServlet(name = "UploadStaff", urlPatterns = {"/UploadStaff"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 20, // 20MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class UploadStaff extends HttpServlet {

    @Inject
    private MainSession sess;
    Settings settings = new Settings();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Part filePart = request.getPart("bulkFile");
        String userId = request.getParameter("id");
        
        if (userId != null && userId.trim().length() > 0) {
            userId = settings.decryptText(userId);
            Users user = sess.getUsers(userId);
            if (user == null) {
                userId = null;
            }
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileId = fileName + "_" + System.currentTimeMillis();

        FileProcessingTracker.updateStatus(fileId, "Processing");

        // Save the file temporarily
        Path tempFile = Files.createTempFile("upload_staff_", fileName);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, tempFile, StandardCopyOption.REPLACE_EXISTING);
        }

        // Process file and generate report
        try {
            List<UploadReport> uploadResults = processExcelFileWithReport(tempFile.toFile(), userId);
            
            // Generate report
            generateUploadReport(response, uploadResults, fileName);
            
            FileProcessingTracker.updateStatus(fileId, "Completed");
        } catch (Exception e) {
            System.out.println("CRITICAL ERROR in processing: " + e.getMessage());
            e.printStackTrace();
            FileProcessingTracker.updateStatus(fileId, "Failed");
            
            String errorMsg = "Upload failed: " + e.getMessage();
            response.sendRedirect("/adminAddStaff?error=" + settings.encodeUrl(errorMsg));
        } finally {
            tempFile.toFile().delete();
        }
    }

    private List<UploadReport> processExcelFileWithReport(File file, String uploadedBy) {
        System.out.println("=== STAFF BULK UPLOAD DEBUG START ===");
        System.out.println("Processing file: " + file.getName());
        System.out.println("File size: " + file.length() + " bytes");
        System.out.println("Uploaded by: " + uploadedBy);
        
        List<UploadReport> uploadResults = new ArrayList<>();
        int totalRows = 0;
        int successCount = 0;
        int errorCount = 0;
        
        try (InputStream fis = new FileInputStream(file)) {
            
            try {
                Workbook w = Workbook.getWorkbook(fis);
                Sheet sheet = w.getSheet(0);
                totalRows = sheet.getRows();
                System.out.println("Excel sheet loaded successfully. Total rows: " + totalRows);
                System.out.println("Processing rows starting from row 1 (skipping header)...");
                
                for (int row = 1; row < sheet.getRows(); row++) {
                    System.out.println("\n--- Processing Row " + row + " ---");
                    UploadReport det = new UploadReport();
                    String remarks;
                    
                    try {
                        // Read Excel columns - Column order must match template
                        // 0=STAFF_NO, 1=TITLE, 2=SURNAME, 3=OTHERNAMES, 4=GENDER, 
                        // 5=PERSONAL_EMAIL, 6=PHONE_NO, 7=DATE_OF_BIRTH, 8=MARITAL_STATUS
                        String staffNo = sheet.getCell(0, row).getContents().trim();
                        String title = sheet.getCell(1, row).getContents().trim();
                        String surname = sheet.getCell(2, row).getContents().trim();
                        String othernames = sheet.getCell(3, row).getContents().trim();
                        String gender = sheet.getCell(4, row).getContents().trim();
                        String personalEmail = sheet.getCell(5, row).getContents().trim();
                        String phoneNo = sheet.getCell(6, row).getContents().trim();
                        String dateOfBirth = sheet.getCell(7, row).getContents().trim();
                        String maritalStatus = sheet.getCell(8, row).getContents().trim();

                        System.out.println("Raw data from Excel:");
                        System.out.println("  STAFF_NO: '" + staffNo + "'");
                        System.out.println("  NAME: '" + surname + " " + othernames + "'");
                        System.out.println("  EMAIL: '" + personalEmail + "'");

                        // Validate required fields
                        if (staffNo.isEmpty() || surname.isEmpty() || othernames.isEmpty() || 
                            personalEmail.isEmpty() || phoneNo.isEmpty()) {
                            remarks = "Missing required fields (STAFF_NO, SURNAME, OTHERNAMES, EMAIL, PHONE required)";
                            System.out.println("  Result: ERROR - " + remarks);
                            errorCount++;
                            det.setId(staffNo.isEmpty() ? "Row " + row : staffNo.toUpperCase());
                            det.setDetails(remarks);
                            uploadResults.add(det);
                            continue;
                        }

                        // Format data
                        staffNo = staffNo.toUpperCase();
                        personalEmail = personalEmail.toLowerCase();
                        
                        // Phone number validation: strip non-digits, take last 10 digits
                        phoneNo = phoneNo.replaceAll("[^0-9]", ""); // Remove all non-digit characters
                        
                        // Validate phone has digits
                        if (phoneNo.isEmpty()) {
                            remarks = "Invalid phone number (no digits found)";
                            System.out.println("  Result: ERROR - " + remarks);
                            errorCount++;
                            det.setId(staffNo);
                            det.setDetails(remarks);
                            uploadResults.add(det);
                            continue;
                        }
                        
                        // Take last 10 digits if longer than 10
                        if (phoneNo.length() > 10) {
                            phoneNo = phoneNo.substring(phoneNo.length() - 10);
                        } else if (phoneNo.length() < 10) {
                            // Pad with zeros on the left if less than 10 digits
                            phoneNo = String.format("%010d", Long.parseLong(phoneNo));
                        }
                        
                        System.out.println("  PHONE (after validation): '" + phoneNo + "'");

                        // Check if staff number already exists
                        Staff existingStaff = sess.getStaffByStaffNo(staffNo);
                        if (existingStaff != null) {
                            remarks = "Staff Number " + staffNo + " already exists - skipped";
                            System.out.println("  Result: SKIPPED - " + remarks);
                            errorCount++;
                            det.setId(staffNo);
                            det.setDetails(remarks);
                            uploadResults.add(det);
                            continue;
                        }

                        // Check if email already exists
                        Users existingUser = sess.getUsersByEmail(personalEmail);
                        if (existingUser != null) {
                            remarks = "Email " + personalEmail + " already registered - skipped";
                            System.out.println("  Result: SKIPPED - " + remarks);
                            errorCount++;
                            det.setId(staffNo);
                            det.setDetails(remarks);
                            uploadResults.add(det);
                            continue;
                        }

                        // Generate unique ID
                        String userId = settings.generateId(settings.getTodaysdate().split("-")[0], 10);
                        
                        // Create Users record
                        Users newUser = new Users(userId);
                        newUser.setUsername(staffNo.toLowerCase());
                        newUser.setPassword(staffNo);
                        newUser.setEmail(personalEmail);
                        newUser.setDefaultRole(sess.getRoles(1057)); // Staff role
                        newUser.setStatus("ACTIVE");
                        
                        Date now = new Date();
                        newUser.setCreatedAt(now);
                        newUser.setUpdatedAt(now);
                        newUser.setCreatedBy(uploadedBy != null ? uploadedBy : "SYSTEM");
                        newUser.setFailedLoginAttempts(0);
                        newUser.setDeleted(false);
                        
                        // Create Staff record
                        Staff newStaff = new Staff(userId);
                        newStaff.setStaffNo(staffNo);
                        newStaff.setSurname(surname);
                        newStaff.setOthernames(othernames);
                        newStaff.setPersonalEmailAddress(personalEmail);
                        newStaff.setPhoneNo(phoneNo);
                        newStaff.setDateAdded(now);
                        
                        // Set optional fields if provided
                        if (!title.isEmpty()) newStaff.setTitle(title);
                        if (!gender.isEmpty()) newStaff.setGender(gender);
                        if (!dateOfBirth.isEmpty()) newStaff.setDateOfBirth(dateOfBirth);
                        if (!maritalStatus.isEmpty()) newStaff.setMaritalStatus(maritalStatus);
                        
                        // Save Users record first, then Staff record
                        try {
                            sess.newEntry(newUser);
                            sess.newEntry(newStaff);
                            
                            remarks = "Success";
                            successCount++;
                            System.out.println("  Result: SUCCESS");
                        } catch (Exception saveEx) {
                            remarks = "Save error: " + saveEx.getMessage();
                            errorCount++;
                            System.out.println("  Result: ERROR - " + remarks);
                        }
                        
                        det.setId(staffNo);
                        det.setDetails(remarks);
                        uploadResults.add(det);
                        
                    } catch (Exception j) {
                        System.out.println("Error processing row " + row + ": " + j.getMessage());
                        j.printStackTrace();
                        
                        det.setId("Row " + row);
                        det.setDetails("Processing error: " + j.getMessage());
                        uploadResults.add(det);
                        errorCount++;
                    }
                }
                
                System.out.println("\n=== UPLOAD SUMMARY ===");
                System.out.println("Total rows processed: " + (totalRows - 1));
                System.out.println("Successful records: " + successCount);
                System.out.println("Errors/Skipped: " + errorCount);
                System.out.println("=== STAFF BULK UPLOAD DEBUG END ===");
                
            } catch (BiffException e) {
                System.out.println("Excel file format error: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("Excel file format error: " + e.getMessage());
            }

        } catch (Exception k) {
            System.out.println("File processing error: " + k.getMessage());
            k.printStackTrace();
            throw new RuntimeException("File processing error: " + k.getMessage());
        }
        
        return uploadResults;
    }

    private void generateUploadReport(HttpServletResponse response, List<UploadReport> uploadResults, String originalFileName) throws IOException {
        int successCount = 0;
        int errorCount = 0;
        
        for (UploadReport result : uploadResults) {
            if (result.getDetails().equals("Success")) {
                successCount++;
            } else {
                errorCount++;
            }
        }
        
        String filename = "Staff_Upload_Report_" + System.currentTimeMillis() + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);
        
        try {
            WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
            WritableSheet wsheet = wworkbook.createSheet("Upload Report", 0);
            
            // Create headers
            wsheet.addCell(new Label(0, 0, "STAFF BULK UPLOAD REPORT"));
            wsheet.addCell(new Label(0, 1, "Original File: " + originalFileName));
            wsheet.addCell(new Label(0, 2, "Total Records Processed: " + uploadResults.size()));
            wsheet.addCell(new Label(0, 3, "Successful Uploads: " + successCount));
            wsheet.addCell(new Label(0, 4, "Failed/Skipped: " + errorCount));
            wsheet.addCell(new Label(0, 5, "Upload Date: " + new Date()));
            
            // Add detailed results
            wsheet.addCell(new Label(0, 7, "STAFF_NO"));
            wsheet.addCell(new Label(1, 7, "STATUS"));
            wsheet.addCell(new Label(2, 7, "REMARKS"));
            
            int row = 8;
            for (UploadReport result : uploadResults) {
                wsheet.addCell(new Label(0, row, result.getId()));
                wsheet.addCell(new Label(1, row, result.getDetails().equals("Success") ? "SUCCESS" : "ERROR"));
                wsheet.addCell(new Label(2, row, result.getDetails()));
                row++;
            }
            
            wworkbook.write();
            wworkbook.close();
            
            System.out.println("Upload report generated: " + filename);
            System.out.println("Summary - Success: " + successCount + ", Errors: " + errorCount);
            
        } catch (Exception e) {
            System.out.println("Error generating upload report: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Error generating upload report: " + e.getMessage());
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
        return "Staff Bulk Upload Servlet";
    }
}
