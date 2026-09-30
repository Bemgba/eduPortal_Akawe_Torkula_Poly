/*
 * Download Complete Applications for Admission Consideration
 * Exports all applications with complete UTME details and payment in Excel format
 */
package com.mnl.eduportal.servlet;

import com.mnl.eduportal.entities.Applicants;
import com.mnl.eduportal.entities.Applicantsutme;
import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Sessionmanager;
import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.entities.Utmesubjects;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.Workbook;

/**
 *
 * @author System
 */
public class DownloadCompleteApplications extends HttpServlet {

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
        
        // Verify user authentication
        String userId = request.getParameter("id");
        if (userId != null && userId.trim().length() > 0) {
            userId = settings.decryptText(userId);
            Users user = sess.getUsers(userId);
            if (user == null) {
                response.sendRedirect("/?error=unauthorized");
                return;
            }
        } else {
            response.sendRedirect("/?error=unauthorized");
            return;
        }

        try {
            // Get current session for applications
            Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
            if (sessmanx == null) {
                response.sendRedirect("/staff_dashboard?error=No current application session found");
                return;
            }

            // Get all complete applications for the current session
            List<Applicants> completeApplications = getCompleteApplications(sessmanx.getName());
            
            System.out.println("Found " + completeApplications.size() + " complete applications for session: " + sessmanx.getName());

            // Generate Excel file
            String filename = "Complete_Applications_" + sessmanx.getName().replace("/", "_") + "_" + System.currentTimeMillis() + ".xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-disposition", "attachment; filename=" + filename);

            generateExcelReport(response, completeApplications, sessmanx.getName());

        } catch (Exception e) {
            System.out.println("Error generating complete applications report: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("/staff_dashboard?error=" + settings.encodeUrl("Error generating report: " + e.getMessage()));
        }
    }

    /**
     * Get all applications that have complete UTME details and payment
     */
    private List<Applicants> getCompleteApplications(String session) {
        try {
            System.out.println("Getting complete applications for session: " + session);
            
            // Reset statistics
            totalApplicants = 0;
            qualifiedApplicants = 0;
            noUtmeData = 0;
            incompleteUtme = 0;
            noPayment = 0;
            noUtmeAndNoPayment = 0;
            
            // Get all applicants using the same method as adminapplicationsview.jsp
            List<Applicants> allApplicants = new ArrayList<>();
            
            // Get all courses for undergraduate programs
            List<Courses> coursesl = sess.getCoursesBySchoolAndProgramme("S001", "1001");
            coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S003", "1001"));
            
            System.out.println("Found " + coursesl.size() + " courses to check");
            
            for (Courses course : coursesl) {
                List<String> appTypesToSearch = new ArrayList<>();
                appTypesToSearch.add("ug");        // New applications from portal
                appTypesToSearch.add("UTME");      // Legacy UTME applications
                appTypesToSearch.add("DE");        // Direct Entry applications
                appTypesToSearch.add("REM");       // Remedial applications
                
                List<Applicants> courseApplicants = sess.getApplicantsByCourseAndTypes(course.getId(), session, "ALL", appTypesToSearch);
                System.out.println("Course " + course.getName() + ": found " + courseApplicants.size() + " applicants");
                allApplicants.addAll(courseApplicants);
            }
            
            totalApplicants = allApplicants.size();
            System.out.println("Total applicants found: " + totalApplicants);
            
            // Now filter for complete applications (UTME + Payment) and track statistics
            List<Applicants> completeApplications = new ArrayList<>();
            
            for (Applicants app : allApplicants) {
                boolean isComplete = false;
                boolean hasUtmeData = false;
                boolean hasCompleteUtme = false;
                boolean hasPayment = false;
                
                try {
                    // Check UTME details
                    Applicantsutme utme = app.getApplicantsutme();
                    
                    if (utme != null) {
                        hasUtmeData = true;
                        hasCompleteUtme = (utme.getEngScore() != null && 
                                         utme.getSubj2() != null && utme.getSubj2Score() != null &&
                                         utme.getSubj3() != null && utme.getSubj3Score() != null &&
                                         utme.getSubj4() != null && utme.getSubj4Score() != null &&
                                         utme.getTotalUtme() != null);
                    }
                    
                    // Check payment status using the same method as adminapplicationsview.jsp
                    try {
                        List<Payments> applicantPayments = sess.getPaymentsByRegno(app.getId());
                        hasPayment = !applicantPayments.isEmpty();
                    } catch (Exception ex) {
                        hasPayment = false;
                    }
                    
                    isComplete = hasCompleteUtme && hasPayment;
                    
                    // Track statistics
                    if (isComplete) {
                        qualifiedApplicants++;
                        completeApplications.add(app);
                        System.out.println("✓ QUALIFIED: " + app.getId() + 
                            " (Course: " + (app.getCourse1() != null ? app.getCourse1().getName() : "Unknown") + 
                            ", UTME: " + (utme != null ? utme.getTotalUtme() : "N/A") + 
                            ", Payment: " + hasPayment + ")");
                    } else {
                        // Track disqualification reasons
                        String reason = "";
                        if (!hasUtmeData && !hasPayment) {
                            noUtmeAndNoPayment++;
                            reason = "No UTME Data & No Payment";
                        } else if (!hasUtmeData) {
                            noUtmeData++;
                            reason = "No UTME Data";
                        } else if (!hasCompleteUtme && !hasPayment) {
                            incompleteUtme++;
                            reason = "Incomplete UTME & No Payment";
                        } else if (!hasCompleteUtme) {
                            incompleteUtme++;
                            reason = "Incomplete UTME Data";
                        } else if (!hasPayment) {
                            noPayment++;
                            reason = "No Payment";
                        }
                        
                        System.out.println("✗ DISQUALIFIED: " + app.getId() + 
                            " (Course: " + (app.getCourse1() != null ? app.getCourse1().getName() : "Unknown") + 
                            ", Reason: " + reason + 
                            ", UTME Complete: " + hasCompleteUtme + 
                            ", Payment: " + hasPayment + ")");
                    }
                    
                } catch (Exception e) {
                    System.out.println("Error checking application " + app.getId() + ": " + e.getMessage());
                }
            }
            
            System.out.println("\n=== QUALIFICATION SUMMARY ===");
            System.out.println("Total Applicants: " + totalApplicants);
            System.out.println("Qualified: " + qualifiedApplicants);
            System.out.println("No UTME Data: " + noUtmeData);
            System.out.println("Incomplete UTME: " + incompleteUtme);
            System.out.println("No Payment: " + noPayment);
            System.out.println("No UTME & No Payment: " + noUtmeAndNoPayment);
            System.out.println("Qualification Rate: " + (totalApplicants > 0 ? (double) qualifiedApplicants / totalApplicants * 100 : 0) + "%");
            
            // Sort by course name and UTME score
            completeApplications.sort((a1, a2) -> {
                try {
                    // First sort by course name
                    String course1 = a1.getCourse1() != null ? a1.getCourse1().getName() : "";
                    String course2 = a2.getCourse1() != null ? a2.getCourse1().getName() : "";
                    int courseCompare = course1.compareTo(course2);
                    
                    if (courseCompare != 0) {
                        return courseCompare;
                    }
                    
                    // Then sort by UTME score (descending)
                    Integer utme1 = a1.getApplicantsutme() != null ? a1.getApplicantsutme().getTotalUtme() : 0;
                    Integer utme2 = a2.getApplicantsutme() != null ? a2.getApplicantsutme().getTotalUtme() : 0;
                    return utme2.compareTo(utme1); // Descending order
                } catch (Exception e) {
                    return 0;
                }
            });
            
            return completeApplications;

        } catch (Exception e) {
            System.out.println("Error querying complete applications: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    // Statistics tracking
    private int totalApplicants = 0;
    private int qualifiedApplicants = 0;
    private int noUtmeData = 0;
    private int incompleteUtme = 0;
    private int noPayment = 0;
    private int noUtmeAndNoPayment = 0;

    /**
     * Generate Excel report with complete applications and detailed summary
     */
    private void generateExcelReport(HttpServletResponse response, List<Applicants> applications, String session) 
            throws IOException, WriteException {
        
        WritableWorkbook workbook = Workbook.createWorkbook(response.getOutputStream());
        
        // Sheet 1: Complete Applications (same format as template)
        WritableSheet sheet1 = workbook.createSheet("Complete Applications", 0);
        generateCompleteApplicationsSheet(sheet1, applications);
        
        // Sheet 2: Summary Report
        WritableSheet sheet2 = workbook.createSheet("Summary Report", 1);
        generateSummarySheet(sheet2, session);

        workbook.write();
        workbook.close();

        System.out.println("Excel report generated successfully with " + applications.size() + " complete applications");
    }

    /**
     * Generate the main sheet with complete applications in template format
     */
    private void generateCompleteApplicationsSheet(WritableSheet sheet, List<Applicants> applications) 
            throws WriteException {
        
        // Create headers (same as template)
        sheet.addCell(new Label(0, 0, "JAMB_NO"));
        sheet.addCell(new Label(1, 0, "NAME"));
        sheet.addCell(new Label(2, 0, "GENDER"));
        sheet.addCell(new Label(3, 0, "STATE"));
        sheet.addCell(new Label(4, 0, "AGGREGATE"));
        sheet.addCell(new Label(5, 0, "COURSE"));
        sheet.addCell(new Label(6, 0, "LGA"));
        sheet.addCell(new Label(7, 0, "SUBJ1"));
        sheet.addCell(new Label(8, 0, "SUBJ1_SCORE"));
        sheet.addCell(new Label(9, 0, "SUBJ2"));
        sheet.addCell(new Label(10, 0, "SUBJ2_SCORE"));
        sheet.addCell(new Label(11, 0, "SUBJ3"));
        sheet.addCell(new Label(12, 0, "SUBJ3_SCORE"));
        sheet.addCell(new Label(13, 0, "ENG_SCORE"));

        int row = 1;
        int successCount = 0;
        int errorCount = 0;

        for (Applicants app : applications) {
            try {
                Applicantsutme utme = app.getApplicantsutme();
                if (utme == null) {
                    System.out.println("Skipping application " + app.getId() + " - no UTME data");
                    errorCount++;
                    continue;
                }

                // JAMB_NO
                sheet.addCell(new Label(0, row, app.getId().toUpperCase()));

                // NAME
                String fullName = (app.getSurname() != null ? app.getSurname() : "") + " " + 
                                 (app.getOthernames() != null ? app.getOthernames() : "");
                sheet.addCell(new Label(1, row, fullName.trim().toUpperCase()));

                // GENDER
                String gender = app.getGender();
                if ("Female".equalsIgnoreCase(gender)) {
                    gender = "F";
                } else if ("Male".equalsIgnoreCase(gender)) {
                    gender = "M";
                }
                sheet.addCell(new Label(2, row, gender != null ? gender : ""));

                // STATE
                String state = "";
                try {
                    if (app.getStateOfOrigin() != null) {
                        state = app.getStateOfOrigin().getName().toUpperCase();
                    }
                } catch (Exception e) {
                    System.out.println("Error getting state for " + app.getId() + ": " + e.getMessage());
                }
                sheet.addCell(new Label(3, row, state));

                // AGGREGATE
                Integer totalUtme = utme.getTotalUtme();
                sheet.addCell(new Label(4, row, totalUtme != null ? totalUtme.toString() : "0"));

                // COURSE
                String course = "";
                try {
                    if (app.getCourse1() != null) {
                        course = app.getCourse1().getName().toUpperCase();
                    }
                } catch (Exception e) {
                    System.out.println("Error getting course for " + app.getId() + ": " + e.getMessage());
                }
                sheet.addCell(new Label(5, row, course));

                // LGA
                String lga = "";
                try {
                    if (app.getLga() != null) {
                        lga = app.getLga().getName().toUpperCase();
                    }
                } catch (Exception e) {
                    System.out.println("Error getting LGA for " + app.getId() + ": " + e.getMessage());
                }
                sheet.addCell(new Label(6, row, lga));

                // UTME Subjects - Convert IDs back to names
                String subj1Name = getSubjectName(utme.getSubj2()); // subj2 is actually first subject
                String subj2Name = getSubjectName(utme.getSubj3()); // subj3 is actually second subject  
                String subj3Name = getSubjectName(utme.getSubj4()); // subj4 is actually third subject

                // SUBJ1 and SUBJ1_SCORE
                sheet.addCell(new Label(7, row, subj1Name));
                sheet.addCell(new Label(8, row, utme.getSubj2Score() != null ? utme.getSubj2Score().toString() : "0"));

                // SUBJ2 and SUBJ2_SCORE
                sheet.addCell(new Label(9, row, subj2Name));
                sheet.addCell(new Label(10, row, utme.getSubj3Score() != null ? utme.getSubj3Score().toString() : "0"));

                // SUBJ3 and SUBJ3_SCORE
                sheet.addCell(new Label(11, row, subj3Name));
                sheet.addCell(new Label(12, row, utme.getSubj4Score() != null ? utme.getSubj4Score().toString() : "0"));

                // ENG_SCORE
                sheet.addCell(new Label(13, row, utme.getEngScore() != null ? utme.getEngScore().toString() : "0"));

                row++;
                successCount++;

            } catch (Exception e) {
                System.out.println("Error processing application " + app.getId() + ": " + e.getMessage());
                e.printStackTrace();
                errorCount++;
            }
        }

        System.out.println("Complete Applications Sheet: " + successCount + " applications exported");
    }

    /**
     * Generate summary sheet with detailed breakdown of all applicants
     */
    private void generateSummarySheet(WritableSheet sheet, String session) throws WriteException {
        int row = 0;
        
        // Title
        sheet.addCell(new Label(0, row++, "ADMISSION CONSIDERATION REPORT"));
        sheet.addCell(new Label(0, row++, "Session: " + session));
        sheet.addCell(new Label(0, row++, "Generated: " + new java.util.Date()));
        row++; // Empty row
        
        // Summary Statistics
        sheet.addCell(new Label(0, row++, "SUMMARY STATISTICS"));
        sheet.addCell(new Label(0, row++, "==================="));
        sheet.addCell(new Label(0, row, "Total Applicants Found:"));
        sheet.addCell(new Label(2, row++, String.valueOf(totalApplicants)));
        
        sheet.addCell(new Label(0, row, "Qualified for Admission:"));
        sheet.addCell(new Label(2, row++, String.valueOf(qualifiedApplicants)));
        
        sheet.addCell(new Label(0, row, "Qualification Rate:"));
        double rate = totalApplicants > 0 ? (double) qualifiedApplicants / totalApplicants * 100 : 0;
        sheet.addCell(new Label(2, row++, String.format("%.1f%%", rate)));
        row++; // Empty row
        
        // Disqualification Breakdown
        sheet.addCell(new Label(0, row++, "DISQUALIFICATION BREAKDOWN"));
        sheet.addCell(new Label(0, row++, "==============================="));
        
        sheet.addCell(new Label(0, row, "No UTME Data:"));
        sheet.addCell(new Label(2, row++, String.valueOf(noUtmeData)));
        
        sheet.addCell(new Label(0, row, "Incomplete UTME Data:"));
        sheet.addCell(new Label(2, row++, String.valueOf(incompleteUtme)));
        
        sheet.addCell(new Label(0, row, "No Payment:"));
        sheet.addCell(new Label(2, row++, String.valueOf(noPayment)));
        
        sheet.addCell(new Label(0, row, "No UTME & No Payment:"));
        sheet.addCell(new Label(2, row++, String.valueOf(noUtmeAndNoPayment)));
        row++; // Empty row
        
        // Requirements for Qualification
        sheet.addCell(new Label(0, row++, "QUALIFICATION REQUIREMENTS"));
        sheet.addCell(new Label(0, row++, "==========================="));
        sheet.addCell(new Label(0, row++, "To qualify for admission consideration, applicants must have:"));
        sheet.addCell(new Label(0, row++, "1. Complete UTME Data (English + 3 other subjects with scores)"));
        sheet.addCell(new Label(0, row++, "2. Payment Record in the system"));
        sheet.addCell(new Label(0, row++, "3. Application Status: SUBMITTED"));
        row++; // Empty row
        
        // Notes
        sheet.addCell(new Label(0, row++, "NOTES"));
        sheet.addCell(new Label(0, row++, "====="));
        sheet.addCell(new Label(0, row++, "- Only qualified applicants appear in 'Complete Applications' sheet"));
        sheet.addCell(new Label(0, row++, "- Applicants are sorted by Course and UTME Total Score (descending)"));
        sheet.addCell(new Label(0, row++, "- UTME subjects are converted from IDs to readable names"));
        sheet.addCell(new Label(0, row++, "- This report includes all application types: UG, UTME, DE, REM"));
        
        System.out.println("Summary Sheet generated with detailed breakdown");
    }

    /**
     * Convert UTME subject ID back to subject name
     */
    private String getSubjectName(String subjectId) {
        if (subjectId == null || subjectId.trim().isEmpty()) {
            return "";
        }

        try {
            Utmesubjects subject = sess.getUtmesubjects(subjectId);
            if (subject != null) {
                return subject.getName().toUpperCase();
            } else {
                System.out.println("Subject not found for ID: " + subjectId);
            }
        } catch (Exception e) {
            System.out.println("Error getting subject name for ID " + subjectId + ": " + e.getMessage());
        }

        // If subject not found, return the ID itself (fallback)
        System.out.println("Using fallback for subject ID: " + subjectId);
        return subjectId.toUpperCase();
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
        return "Download Complete Applications for Admission Consideration";
    }// </editor-fold>

}