/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet.uploads;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Countries;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Coursesjambmapping;
import com.mnl.eduportal.entities.Lgas;
import com.mnl.eduportal.entities.Roles;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.States;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.entities.Utmesubjects;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.FileProcessingTracker;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.reports.UploadReport;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
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
import java.util.List;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
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
public class UploadUTMEApplicants extends HttpServlet {

    @Inject
    private MainSession sess;
    Settings settings = new Settings();

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
        Part filePart = request.getPart("list"); // Get uploaded file
        String userId = request.getParameter("id");
        if (userId != null && userId.trim().length() > 0) {
            userId = settings.decryptText(userId);
            Users user = sess.getUsers(userId);
            if (user == null) {
                userId = null;
            }
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileId = fileName + "_" + System.currentTimeMillis(); // Unique ID for tracking

        FileProcessingTracker.updateStatus(fileId, "Processing");

        // Save the file temporarily
        Path tempFile = Files.createTempFile("upload_", fileName);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, tempFile, StandardCopyOption.REPLACE_EXISTING);
        }

        // Process file synchronously and generate report
        try {
            List<UploadReport> uploadResults = processExcelFileWithReport(tempFile.toFile());
            
            // Check if this is an AJAX request
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjaxRequest = "XMLHttpRequest".equals(ajaxHeader);
            
            if (isAjaxRequest) {
                // For AJAX requests, save report to temp location and return JSON
                String reportFileName = "UTME_Upload_Report_" + System.currentTimeMillis() + ".xls";
                String reportPath = saveUploadReportToTemp(uploadResults, fileName, reportFileName);
                
                // Return JSON response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                int successCount = 0;
                int errorCount = 0;
                for (UploadReport result : uploadResults) {
                    if (result.getDetails().equals("Success")) {
                        successCount++;
                    } else {
                        errorCount++;
                    }
                }
                
                String jsonResponse = String.format(
                    "{\"success\": true, \"message\": \"Upload completed successfully\", " +
                    "\"totalRecords\": %d, \"successCount\": %d, \"errorCount\": %d, " +
                    "\"reportDownloadUrl\": \"/DownloadUploadReport?file=%s\"}",
                    uploadResults.size(), successCount, errorCount, reportFileName
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                // For regular form submissions, generate report directly
                generateUploadReport(response, uploadResults, fileName);
            }
            
            FileProcessingTracker.updateStatus(fileId, "Completed");
        } catch (Exception e) {
            System.out.println("CRITICAL ERROR in processing: " + e.getMessage());
            e.printStackTrace();
            FileProcessingTracker.updateStatus(fileId, "Failed");
            
            // Check if this is an AJAX request
            String ajaxHeader = request.getHeader("X-Requested-With");
            boolean isAjaxRequest = "XMLHttpRequest".equals(ajaxHeader);
            
            if (isAjaxRequest) {
                // Return JSON error response for AJAX requests
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                String jsonResponse = String.format(
                    "{\"success\": false, \"message\": \"Upload failed: %s\"}",
                    e.getMessage().replace("\"", "\\\"")
                );
                
                response.getWriter().write(jsonResponse);
            } else {
                // Redirect with error message for regular form submissions
                String errorMsg = "Upload failed: " + e.getMessage();
                response.sendRedirect("/app_adm_upload?error=" + settings.encodeUrl(errorMsg));
            }
        } finally {
            tempFile.toFile().delete();
        }
    }

    private List<UploadReport> processExcelFileWithReport(File file) {
        System.out.println("=== UTME APPLICANTS UPLOAD DEBUG START ===");
        System.out.println("Processing file: " + file.getName());
        System.out.println("File size: " + file.length() + " bytes");
        
        List<UploadReport> uploadResults = new ArrayList<>();
        int totalRows = 0;
        int successCount = 0;
        int errorCount = 0;
        
        try (InputStream fis = new FileInputStream(file)) {
            
            Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
            System.out.println("Current session manager: " + (sessmanx != null ? sessmanx.getName() : "NULL"));
            
            if (sessmanx == null) {
                System.out.println("ERROR: No current session manager found for S001/APPLICATION");
                throw new RuntimeException("No current session manager found for S001/APPLICATION");
            }

            // Initialize common course mappings if they don't exist
            System.out.println("Initializing course mappings...");
            sess.initializeCommonCourseMappings();
            
            try {
                Workbook w;
                try {
                    w = Workbook.getWorkbook(fis);
                    Sheet sheet = w.getSheet(0);
                    totalRows = sheet.getRows();
                    System.out.println("Excel sheet loaded successfully. Total rows: " + totalRows);
                    System.out.println("Processing rows starting from row 1 (skipping header)...");
                    
                    for (int row = 1; row < sheet.getRows(); row++) {
                        System.out.println("\n--- Processing Row " + row + " ---");
                        UploadReport det = new UploadReport();
                        String remarks;
                        
                        try {
                            // Read Excel columns - IMPORTANT: Column order must match template
                            String id = sheet.getCell(0, row).getContents();           // JAMB_NO
                            String name = sheet.getCell(1, row).getContents();         // NAME  
                            String gender = sheet.getCell(2, row).getContents();       // GENDER
                            String state = sheet.getCell(3, row).getContents();        // STATE
                            String agg = sheet.getCell(4, row).getContents();          // AGGREGATE
                            String course = sheet.getCell(5, row).getContents();       // COURSE
                            String lga = sheet.getCell(6, row).getContents();          // LGA
                            String subj1 = sheet.getCell(7, row).getContents();        // SUBJ1
                            String subj1_sc = sheet.getCell(8, row).getContents();     // SUBJ1_SCORE
                            String subj2 = sheet.getCell(9, row).getContents();        // SUBJ2
                            String subj2_sc = sheet.getCell(10, row).getContents();    // SUBJ2_SCORE
                            String subj3 = sheet.getCell(11, row).getContents();       // SUBJ3
                            String subj3_sc = sheet.getCell(12, row).getContents();    // SUBJ3_SCORE
                            String eng = sheet.getCell(13, row).getContents();         // ENG_SCORE

                            System.out.println("Raw data from Excel:");
                            System.out.println("  JAMB_NO: '" + id + "'");
                            System.out.println("  NAME: '" + name + "'");
                            System.out.println("  COURSE: '" + course + "'");

                            id = id.trim().toLowerCase();

                            String surname = "";
                            String othernames = "";
                            try {
                                String[] namex = name.split(" ");
                                surname = namex[0];
                                if (namex.length == 2) {
                                    othernames = (namex[1]).trim();
                                } else if (namex.length > 2) {
                                    othernames = (namex[1] + " " + namex[2]).trim();
                                }
                            } catch (Exception d) {
                                System.out.println("Error parsing name: " + d.getMessage());
                            }

                            try {
                                if (gender.trim().equalsIgnoreCase("F")) {
                                    gender = "Female";
                                } else {
                                    gender = "Male";
                                }
                            } catch (Exception k) {
                                System.out.println("Error normalizing gender: " + k.getMessage());
                            }

                            Countries countryId = null;
                            States stateId = null;
                            Lgas lgaId = null;
                            try {
                                countryId = sess.getCountries("Nigeria");
                            } catch (Exception k) {
                                System.out.println("Error getting country: " + k.getMessage());
                            }
                            try {
                                stateId = sess.getStates(state, "Nigeria");
                            } catch (Exception k) {
                                System.out.println("Error getting state: " + k.getMessage());
                            }
                            try {
                                lgaId = sess.getLgas(lga, state);
                            } catch (Exception k) {
                                System.out.println("Error getting LGA: " + k.getMessage());
                            }

                            Integer iagg = 0;
                            try {
                                iagg = Integer.valueOf(agg);
                            } catch (NumberFormatException k) {
                                System.out.println("Error parsing aggregate '" + agg + "': " + k.getMessage());
                            }

                            Courses bsucourse = null;
                            try {
                                Coursesjambmapping mapping = sess.getCoursesjambmapping(course.trim());
                                if (mapping != null) {
                                    bsucourse = mapping.getCourses();
                                    System.out.println("  Course lookup '" + course + "': Found - " + bsucourse.getName());
                                } else {
                                    System.out.println("  Course lookup '" + course + "': NOT FOUND in coursesjambmapping");
                                }
                            } catch (Exception k) {
                                System.out.println("Error getting course mapping for '" + course + "': " + k.getMessage());
                            }

                            // Look up UTME subject IDs from subject names for data consistency
                            String subj1Id = null;
                            String subj2Id = null; 
                            String subj3Id = null;
                            
                            try {
                                Utmesubjects utmeSubj1 = sess.getUtmesubjects(subj1.trim());
                                if (utmeSubj1 != null) {
                                    subj1Id = utmeSubj1.getId();
                                    System.out.println("  Subject 1 lookup: '" + subj1 + "' -> ID: " + subj1Id);
                                } else {
                                    System.out.println("  Subject 1 lookup: '" + subj1 + "' -> NOT FOUND in utmesubjects table");
                                }
                            } catch (Exception e) {
                                System.out.println("Error looking up subject 1 '" + subj1 + "': " + e.getMessage());
                            }
                            
                            try {
                                Utmesubjects utmeSubj2 = sess.getUtmesubjects(subj2.trim());
                                if (utmeSubj2 != null) {
                                    subj2Id = utmeSubj2.getId();
                                    System.out.println("  Subject 2 lookup: '" + subj2 + "' -> ID: " + subj2Id);
                                } else {
                                    System.out.println("  Subject 2 lookup: '" + subj2 + "' -> NOT FOUND in utmesubjects table");
                                }
                            } catch (Exception e) {
                                System.out.println("Error looking up subject 2 '" + subj2 + "': " + e.getMessage());
                            }
                            
                            try {
                                Utmesubjects utmeSubj3 = sess.getUtmesubjects(subj3.trim());
                                if (utmeSubj3 != null) {
                                    subj3Id = utmeSubj3.getId();
                                    System.out.println("  Subject 3 lookup: '" + subj3 + "' -> ID: " + subj3Id);
                                } else {
                                    System.out.println("  Subject 3 lookup: '" + subj3 + "' -> NOT FOUND in utmesubjects table");
                                }
                            } catch (Exception e) {
                                System.out.println("Error looking up subject 3 '" + subj3 + "': " + e.getMessage());
                            }

                            Integer isubj1 = 0;
                            Integer isubj2 = 0;
                            Integer isubj3 = 0;
                            Integer ieng = 0;
                            try {
                                isubj1 = Integer.valueOf(subj1_sc.trim());
                            } catch (NumberFormatException k) {
                                System.out.println("Error parsing subj1 score '" + subj1_sc + "': " + k.getMessage());
                            }
                            try {
                                isubj2 = Integer.valueOf(subj2_sc.trim());
                            } catch (NumberFormatException k) {
                                System.out.println("Error parsing subj2 score '" + subj2_sc + "': " + k.getMessage());
                            }
                            try {
                                isubj3 = Integer.valueOf(subj3_sc.trim());
                            } catch (NumberFormatException k) {
                                System.out.println("Error parsing subj3 score '" + subj3_sc + "': " + k.getMessage());
                            }
                            try {
                                ieng = Integer.valueOf(eng.trim());
                            } catch (NumberFormatException k) {
                                System.out.println("Error parsing English score '" + eng + "': " + k.getMessage());
                            }

                            // Check if applicant record already exists
                            Applicants existingApp = sess.getApplicantsById(id);
                            
                            if (existingApp != null) {
                                // Applicant exists (likely applied via portal) - update status and UTME data
                                System.out.println("  Existing applicant found - updating status and UTME data");
                                
                                try {
                                    // Update applicant status to PENDING (or whatever status is appropriate)
                                    existingApp.setStatus("PENDING");
                                    existingApp.setApplicationType("UTME");
                                    existingApp.setSession(sessmanx.getName());
                                    
                                    // Update course if provided and different
                                    if (bsucourse != null) {
                                        existingApp.setCourse1(bsucourse);
                                        existingApp.setProgrammeId(bsucourse.getSchoolProgrammeId().getProgrammeId());
                                        existingApp.setSchoolId(bsucourse.getSchoolProgrammeId().getSchoolId());
                                    }
                                    
                                    // Update demographic info if provided
                                    if (stateId != null) existingApp.setStateOfOrigin(stateId);
                                    if (lgaId != null) existingApp.setLga(lgaId);
                                    if (countryId != null) existingApp.setCountry(countryId);
                                    if (gender != null && !gender.trim().isEmpty()) existingApp.setGender(gender);
                                    
                                    // Check if UTME record exists
                                    Applicantsutme existingUtme = sess.getApplicantsutme(id);
                                    
                                    if (existingUtme != null) {
                                        // Update existing UTME record
                                        System.out.println("  Updating existing UTME record");
                                        existingUtme.setEngScore(ieng);
                                        existingUtme.setSubj2(subj1Id);
                                        existingUtme.setSubj2Score(isubj1);
                                        existingUtme.setSubj3(subj2Id);
                                        existingUtme.setSubj3Score(isubj2);
                                        existingUtme.setSubj4(subj3Id);
                                        existingUtme.setSubj4Score(isubj3);
                                        existingUtme.setTotalUtme(iagg);
                                        sess.updateObject(existingUtme);
                                    } else {
                                        // Create new UTME record for existing applicant
                                        System.out.println("  Creating new UTME record for existing applicant");
                                        Applicantsutme utme = new Applicantsutme(id);
                                        utme.setEngScore(ieng);
                                        utme.setSubj2(subj1Id);
                                        utme.setSubj2Score(isubj1);
                                        utme.setSubj3(subj2Id);
                                        utme.setSubj3Score(isubj2);
                                        utme.setSubj4(subj3Id);
                                        utme.setSubj4Score(isubj3);
                                        utme.setTotalUtme(iagg);
                                        existingApp.setApplicantsutme(utme);
                                        sess.newEntry(utme);
                                    }
                                    
                                    // Update the applicant record
                                    sess.updateObject(existingApp);
                                    
                                    // Ensure user record exists with correct role
                                    Users existingUser = sess.getUsers(id);
                                    if (existingUser == null) {
                                        System.out.println("  Creating user record for existing applicant");
                                        Users user = new Users(id);
                                        user.setPassword(id);
                                        user.setUsername(id);
                                        user.setStatus("ACTIVE");
                                        Roles ro = sess.getRoles(1063);
                                        user.setDefaultRole(ro);
                                        sess.newEntry(user);
                                    }
                                    
                                    remarks = "Success - Updated existing applicant record";
                                    successCount++;
                                    System.out.println("  Result: SUCCESS - Existing record updated");
                                    
                                } catch (Exception updateEx) {
                                    remarks = "Update error: " + updateEx.getMessage();
                                    System.out.println("  Result: ERROR - " + remarks);
                                    updateEx.printStackTrace();
                                    errorCount++;
                                }
                            } else {
                                // No existing applicant - check if user/UTME exists (shouldn't happen normally)
                                Users existingUser = sess.getUsers(id);
                                Applicantsutme existingUtme = sess.getApplicantsutme(id);
                                
                                if (existingUser != null || existingUtme != null) {
                                    // Orphaned user or UTME record without applicant - this is an error state
                                    String existingTypes = "";
                                    if (existingUser != null) existingTypes += "user ";
                                    if (existingUtme != null) existingTypes += "UTME ";
                                    remarks = "Data inconsistency - JAMB_NO: " + id.toUpperCase() + " has " + existingTypes.trim() + "records but no applicant record";
                                    System.out.println("  Result: ERROR - " + remarks);
                                    errorCount++;
                                } else {
                                    // No existing records - create new applicant
                                    if (bsucourse == null) {
                                    remarks = "No matching course found on the portal for: " + course + ". Please add course mapping to coursesjambmapping table.";
                                    System.out.println("  Result: ERROR - " + remarks);
                                    errorCount++;
                                } else {
                                    int calculatedTotal = isubj1 + isubj2 + isubj3 + ieng;
                                    
                                    if (iagg != calculatedTotal) {
                                        remarks = "Aggregate scores does not match sum of individual scores (Expected: " + iagg + ", Got: " + calculatedTotal + ")";
                                        System.out.println("  Result: ERROR - " + remarks);
                                        errorCount++;
                                    } else if (subj1Id == null || subj2Id == null || subj3Id == null) {
                                        // Check for missing subject IDs
                                        List<String> missingSubjects = new ArrayList<>();
                                        if (subj1Id == null) missingSubjects.add(subj1);
                                        if (subj2Id == null) missingSubjects.add(subj2);
                                        if (subj3Id == null) missingSubjects.add(subj3);
                                        
                                        remarks = "Unknown UTME subjects not found in database: " + String.join(", ", missingSubjects) + 
                                                ". Please add these subjects to the utmesubjects table first.";
                                        System.out.println("  Result: ERROR - " + remarks);
                                        errorCount++;
                                    } else {
                                        System.out.println("  Creating new applicant with UTME and user records...");
                                        
                                        try {
                                            // Create Applicants record
                                            Applicants appx = new Applicants(id);
                                            appx.setApplicationType("UTME");
                                            appx.setCountry(countryId);
                                            appx.setCourse1(bsucourse);
                                            appx.setDateCompleted(settings.getCurrentDateTime());
                                            appx.setDateInitiated(settings.getCurrentDateTime());
                                            appx.setGender(gender);
                                            appx.setLga(lgaId);
                                            appx.setOthernames(othernames);
                                            appx.setProgrammeId(bsucourse.getSchoolProgrammeId().getProgrammeId());
                                            appx.setSchoolId(bsucourse.getSchoolProgrammeId().getSchoolId());
                                            appx.setSession(sessmanx.getName());
                                            appx.setStateOfOrigin(stateId);
                                            appx.setStatus("PENDING");
                                            appx.setSurname(surname);
                                            
                                            // Create Applicantsutme record with subject IDs for data consistency
                                            Applicantsutme utme = new Applicantsutme(id);
                                            utme.setEngScore(ieng);
                                            utme.setSubj2(subj1Id);  // Save subject ID instead of name
                                            utme.setSubj2Score(isubj1);
                                            utme.setSubj3(subj2Id);  // Save subject ID instead of name
                                            utme.setSubj3Score(isubj2);
                                            utme.setSubj4(subj3Id);  // Save subject ID instead of name
                                            utme.setSubj4Score(isubj3);
                                            utme.setTotalUtme(iagg);
                                            
                                            // CRITICAL: Set the bidirectional relationship properly
                                            appx.setApplicantsutme(utme);
                                            // Note: Due to cascade = CascadeType.ALL, utme will be persisted automatically
                                            
                                            System.out.println("  UTME relationship set - Total: " + utme.getTotalUtme() + 
                                                             ", Subject IDs: " + utme.getSubj2() + "(" + utme.getSubj2Score() + "), " +
                                                             utme.getSubj3() + "(" + utme.getSubj3Score() + "), " +
                                                             utme.getSubj4() + "(" + utme.getSubj4Score() + "), " +
                                                             "English(" + utme.getEngScore() + ")");

                                            // Create Users record
                                            Users user = new Users(id);
                                            user.setPassword(id);
                                            user.setUsername(id);
                                            user.setStatus("ACTIVE");
                                            Roles ro = sess.getRoles(1063);
                                            user.setDefaultRole(ro);
                                            
                                            // Use atomic transaction to create all records (applicant + utme + user)
                                            System.out.println("  Saving all records atomically (applicant + utme + user)...");
                                            String result = sess.createApplicantWithUser(appx, user);
                                            
                                            if (result.equals("Success")) {
                                                remarks = "Success";
                                                successCount++;
                                                System.out.println("  Result: SUCCESS - All records created atomically");
                                            } else {
                                                remarks = result;
                                                errorCount++;
                                                System.out.println("  Result: ERROR - " + result);
                                            }
                                            
                                        } catch (Exception saveEx) {
                                            remarks = "Database save error: " + saveEx.getMessage();
                                            System.out.println("  Result: ERROR - " + remarks);
                                            saveEx.printStackTrace();
                                            errorCount++;
                                        }
                                    }
                                }
                            }
                            }

                            det.setId(id.toUpperCase());
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
                    System.out.println("Total rows processed: " + (totalRows - 1)); // Exclude header
                    System.out.println("Successful records: " + successCount);
                    System.out.println("Errors/Skipped: " + errorCount);
                    System.out.println("=== UTME APPLICANTS UPLOAD DEBUG END ===");
                    
                } catch (BiffException e) {
                    System.out.println("Excel file format error: " + e.getMessage());
                    e.printStackTrace();
                    throw new RuntimeException("Excel file format error: " + e.getMessage());
                }

            } catch (Exception js) {
                System.out.println("General processing error: " + js.getMessage());
                js.printStackTrace();
                throw new RuntimeException("General processing error: " + js.getMessage());
            }

        } catch (Exception k) {
            System.out.println("File processing error: " + k.getMessage());
            k.printStackTrace();
            throw new RuntimeException("File processing error: " + k.getMessage());
        }
        
        return uploadResults;
    }

    private String saveUploadReportToTemp(List<UploadReport> uploadResults, String originalFileName, String reportFileName) throws IOException {
        int successCount = 0;
        int errorCount = 0;
        
        for (UploadReport result : uploadResults) {
            if (result.getDetails().equals("Success")) {
                successCount++;
            } else {
                errorCount++;
            }
        }
        
        // Create temp directory if it doesn't exist
        File tempDir = new File(System.getProperty("java.io.tmpdir"), "upload_reports");
        if (!tempDir.exists()) {
            tempDir.mkdirs();
        }
        
        File reportFile = new File(tempDir, reportFileName);
        
        try {
            WritableWorkbook wworkbook = Workbook.createWorkbook(reportFile);
            WritableSheet wsheet = wworkbook.createSheet("Upload Report", 0);
            
            // Create headers
            wsheet.addCell(new Label(0, 0, "UPLOAD SUMMARY"));
            wsheet.addCell(new Label(0, 1, "Original File: " + originalFileName));
            wsheet.addCell(new Label(0, 2, "Total Records Processed: " + uploadResults.size()));
            wsheet.addCell(new Label(0, 3, "Successful Uploads: " + successCount));
            wsheet.addCell(new Label(0, 4, "Failed/Skipped: " + errorCount));
            wsheet.addCell(new Label(0, 5, "Upload Date: " + new java.util.Date()));
            
            // Add detailed results
            wsheet.addCell(new Label(0, 7, "JAMB_NO"));
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
            
            System.out.println("Upload report saved to temp: " + reportFile.getAbsolutePath());
            System.out.println("Summary - Success: " + successCount + ", Errors: " + errorCount);
            
            return reportFile.getAbsolutePath();
            
        } catch (Exception e) {
            System.out.println("Error saving upload report to temp: " + e.getMessage());
            e.printStackTrace();
            throw new IOException("Error saving upload report: " + e.getMessage());
        }
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
        
        String filename = "UTME_Upload_Report_" + System.currentTimeMillis() + ".xls";
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-disposition", "attachment; filename=" + filename);
        
        try {
            WritableWorkbook wworkbook = Workbook.createWorkbook(response.getOutputStream());
            WritableSheet wsheet = wworkbook.createSheet("Upload Report", 0);
            
            // Create headers
            wsheet.addCell(new Label(0, 0, "UPLOAD SUMMARY"));
            wsheet.addCell(new Label(0, 1, "Original File: " + originalFileName));
            wsheet.addCell(new Label(0, 2, "Total Records Processed: " + uploadResults.size()));
            wsheet.addCell(new Label(0, 3, "Successful Uploads: " + successCount));
            wsheet.addCell(new Label(0, 4, "Failed/Skipped: " + errorCount));
            wsheet.addCell(new Label(0, 5, "Upload Date: " + new java.util.Date()));
            
            // Add detailed results
            wsheet.addCell(new Label(0, 7, "JAMB_NO"));
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