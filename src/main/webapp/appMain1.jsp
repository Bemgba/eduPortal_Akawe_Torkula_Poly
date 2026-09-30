<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
        return;
    }
%>

<%
    Applicants genapp = null;
    try {
        genapp = (Applicants) session.getAttribute("app");
    } catch (Exception x) {
    }
    if (genapp == null) {
        response.sendRedirect("/gen_app_dashboard");
        return;
    }
%>

<%    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        Schoolsattended dd = (Schoolsattended) sess.getSingleObject(Schoolsattended.class, id2);
        if (dd != null) {
            sess.deleteObject("Schoolsattended", dd.getId());
        }
    }

    String id3 = request.getParameter("id3");
    if (id3 != null && id3.length() > 0) {
        id3 = settings.decryptText(id3);
        Applicantsreferees dd = (Applicantsreferees) sess.getSingleObject(Applicantsreferees.class, id3);
        if (dd != null) {
            sess.deleteObject("Applicantsreferees", dd.getId());
        }
    }

    String id4 = request.getParameter("id4");
    if (id4 != null && id4.length() > 0) {
        id4 = settings.decryptText(id4);
        Uploadeddocuments dd = (Uploadeddocuments) sess.getSingleObject(Uploadeddocuments.class, id4);
        if (dd != null) {
            try {
                String fpath = settings.documentroot + "/" + dd.getUrl();
                File storeFile = new File(fpath);
                if (storeFile.exists()) {
                    storeFile.delete();
                }
            } catch (Exception h) {
            }
            sess.deleteObject("Uploadeddocuments", dd.getId());
        }
    }
%>

<%   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    // GLOBAL VARIABLES INITIALIZATION (Moved to top to fix "cannot find symbol" errors)
    boolean hasAllData = false;
    boolean hasPayment = false;
    boolean hasBeenSubmitted = false;
    String sectionParam = "";
    String expandUtme = "";  // Default: don't expand any section
    String expandPersonal = "";
    String expandInstitutions = "";
    String expandDocuments = "";
    String expandSubmit = "";
    List<Schoolsattended> lschatt = null;
    List<Uploadeddocuments> ldocs = null;
    List<String> missingItems = null;

    // CONSOLIDATED DATA LOADING - Load all data once for performance
    lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
    List<Applicantsreferees> lref = sess.getApplicantsrefereesByRegno(genapp.getId());
    ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());

    // Ensure lists are never null to prevent scope issues
    if (lschatt == null) {
        lschatt = new ArrayList<>();
    }
    if (lref == null) {
        lref = new ArrayList<>();
    }
    if (ldocs == null) {
        ldocs = new ArrayList<>();
    }

    // Load UTME data once
    Applicantsutme utmeCheck = null;
    try {
        utmeCheck = (Applicantsutme) sess.getSingleObject(Applicantsutme.class, genapp.getId());
    } catch (Exception e) {
        // utmeCheck remains null
    }

    // Load O-level data once
    List<Olevelresults> olevelResults = null;
    List<Olevelresultsitems> olevelItems = null;
    long olevelCount = 0;
    List<Olevelsubjects> olevelSubjectsList = null;
    List<Olevelgrades> olevelGradesList = null;

    try {
        olevelResults = sess.getOlevelresultsByUserId(user.getId());
        olevelItems = sess.getOlevelresultsItemsByUserId(user.getId());
        olevelCount = sess.countOlevelSubjectsByUser(user.getId());
        olevelSubjectsList = sess.getAllOlevelsubjects("ACTIVE");
        olevelGradesList = sess.getAllOlevelgrades();
    } catch (Exception e) {
        olevelResults = new ArrayList<>();
        olevelItems = new ArrayList<>();
        olevelCount = 0;
        olevelSubjectsList = new ArrayList<>();
        olevelGradesList = new ArrayList<>();
    }

    // Check if this is a remedial application (programme.id = 1015)
    boolean isRemedialApp = false;
    try {
        if (genapp.getCourse1() != null
                && genapp.getCourse1().getSchoolProgrammeId() != null
                && genapp.getCourse1().getSchoolProgrammeId().getProgrammeId() != null) {
            int programId = genapp.getCourse1().getSchoolProgrammeId().getProgrammeId().getId();
            isRemedialApp = (programId == 1015);
        }
    } catch (Exception e) {
        isRemedialApp = false;
    }

    // CONSOLIDATED COMPLETION STATUS CHECKS
    // Check Guardian information completion
    boolean guardianComplete = genapp.getGuardianName() != null && !genapp.getGuardianName().trim().isEmpty()
            && genapp.getGuardianAddress() != null && !genapp.getGuardianAddress().trim().isEmpty();

    // Check personal information completion
    boolean personalInfoComplete = genapp.getQualification() != null && !genapp.getQualification().trim().isEmpty()
            && genapp.getMaritalStatus() != null && !genapp.getMaritalStatus().trim().isEmpty();

    // Combined personal section completion (both guardian and personal info)
    boolean personalSectionComplete = guardianComplete && personalInfoComplete;

    // Check UTME completion
    boolean utmeComplete = utmeCheck != null && utmeCheck.getEngScore() != null
            && utmeCheck.getSubj2() != null && utmeCheck.getSubj3() != null && utmeCheck.getSubj4() != null;

    // Check O-level completion
    boolean olevelRequired = isRemedialApp;
    boolean olevelComplete = !olevelRequired || (olevelCount >= 5);

    // Check institutions completion
    boolean institutionsComplete = lschatt != null && lschatt.size() > 0;

    // Check documents completion
    boolean documentsComplete = ldocs != null && ldocs.size() > 0;

    // Check payment status
    hasPayment = false;
    try {
        List<Payments> payments = sess.getPaymentsByRegno(genapp.getId());
        hasPayment = payments != null && payments.size() > 0;
    } catch (Exception e) {
        hasPayment = false;
    }

    // Load Applicantsothers data once
    Applicantsothers others = null;
    try {
        others = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
    } catch (Exception e) {
        // others remains null
    }

    // Handle section parameter to determine which accordion to expand
    sectionParam = request.getParameter("section");
    expandUtme = "";  // Default: don't expand any section
    expandPersonal = "";
    expandInstitutions = "";
    expandDocuments = "";
    expandSubmit = "";

    if (sectionParam != null) {
        // Expand specific section based on parameter
        if (sectionParam.equals("utme")) {
            expandUtme = "show";
        } else if (sectionParam.equals("personal") || sectionParam.equals("guardian")) {
            expandPersonal = "show";
        } else if (sectionParam.equals("institutions")) {
            expandInstitutions = "show";
        } else if (sectionParam.equals("documents")) {
            expandDocuments = "show";
        } else if (sectionParam.equals("submit") || sectionParam.equals("confirm")) {
            expandSubmit = "show";
        } else {
            // Default behavior - expand first incomplete section
            expandUtme = "show";
        }
    } else {
        // Default behavior when no section parameter
        // If payment is complete, open all sections; otherwise, keep them closed
        if (hasPayment) {
            expandUtme = "show";
            expandPersonal = "show";
            expandInstitutions = "show";
            expandDocuments = "show";
            expandSubmit = "show";
        }
        // If payment not complete, all sections remain closed (payment will be opened by default)
    }

    // STEP LOCKING LOGIC - Define all step variables here for global access
    // 1. Payment Status (always unlocked)
    boolean step1_paymentComplete = hasPayment;

    // 2. Personal Information Status (unlocked when payment complete)
    boolean step2_personalUnlocked = step1_paymentComplete;
    boolean step2_personalComplete = personalSectionComplete;

    // 3. UTME Status (unlocked when personal complete)
    boolean step3_utmeUnlocked = step2_personalUnlocked && step2_personalComplete;
    boolean step3_utmeComplete = utmeComplete;

    // 4. O-Level Status (unlocked when UTME complete, required for remedial only)
    boolean step4_olevelUnlocked = step3_utmeUnlocked && step3_utmeComplete;
    boolean step4_olevelRequired = olevelRequired;
    boolean step4_olevelComplete = olevelComplete;

    // 5. Institutions Status (unlocked when O-level complete or not required)
    boolean step5_institutionsUnlocked = step4_olevelUnlocked && step4_olevelComplete;
    boolean step5_institutionsComplete = institutionsComplete;

    // 6. Documents Status (unlocked when institutions complete)
    boolean step6_documentsUnlocked = step5_institutionsUnlocked && step5_institutionsComplete;
    boolean step6_documentsComplete = documentsComplete;

    // 7. Final Submission Status (unlocked when all previous complete)
    boolean step7_submitUnlocked = step6_documentsUnlocked && step6_documentsComplete;
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Diploma Application</title>
        <style>
            /* O-level form styling */
            .auto-filled {
                background-color: #f8f9fa !important;
                border-color: #6c757d;
            }

            .auto-filled:focus {
                background-color: #f8f9fa !important;
                box-shadow: 0 0 0 0.2rem rgba(108, 117, 125, 0.25);
            }

            #subjectsTable .btn-danger:disabled {
                opacity: 0.3;
            }

            .olevel-sitting-info {
                background-color: #e3f2fd;
                border-left: 4px solid #2196f3;
                padding: 10px;
                margin-bottom: 15px;
            }

            .subject-grade-badge {
                min-width: 25px;
                text-align: center;
            }

            /* Call-to-action button styling */
            .cta-button {
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0.7);
                }
                70% {
                    box-shadow: 0 0 0 10px rgba(0, 123, 255, 0);
                }
                100% {
                    box-shadow: 0 0 0 0 rgba(0, 123, 255, 0);
                }
            }

            /* Ready to submit accordion styling */
            .ready-to-submit .accordion-button {
                background-color: #e7f3ff;
                border-color: #007bff;
            }

            .ready-to-submit .accordion-button:not(.collapsed) {
                background-color: #cce7ff;
                border-color: #007bff;
            }

            /* Locked accordion styling */
            .accordion-button:disabled {
                background-color: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
                opacity: 0.6;
            }

            .accordion-button:disabled:hover {
                background-color: #f8f9fa;
                color: #6c757d;
            }
        </style>
        <script>
            async function loadDocument(id) {
                try {
                    const url = "AjaxServlet?action=loadDodument&id2=" + escape(id);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById("det").innerHTML = respText;
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
        </script>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Diploma Application</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <% if (std != null) {
                        List<Payments> payl = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                        if (payl.size() > 0) {
                            if (genapp.getStatus().equals("PENDING")) {
                                genapp.setStatus("PAID");
                                sess.updateRecord(genapp);
                            }
                        }
                    %>

                    <div class="card mb-4">
                        <div class="card-header">
                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>
                            <a href="/gen_app_dashboard" class="btn btn-danger btn-sm float-end">Back</a>
                            <button type="button" class="btn btn-primary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                View Bio-Data
                            </button>

                            <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Bio-Data</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="table-responsive-sm">
                                                <table class="table table-striped">
                                                    <tbody>
                                                        <tr> 
                                                            <td>Email Address</td>
                                                            <td><%=genapp.getEmailAddress()%></td>
                                                            <td rowspan="5">
                                                                <%
                                                                    String imgurl = "assets/img/noperson.png";
                                                                    try {
                                                                        Passports pp = sess.getPassports(std.getId());
                                                                        if (pp != null) {
                                                                            File imageFile = new File(settings.documentroot + "/" + pp.getUrl());
                                                                            byte[] imageBytes = Files.readAllBytes(imageFile.toPath());
                                                                            imgurl = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);
                                                                        }
                                                                    } catch (Exception hc) {
                                                                    }
                                                                %>
                                                                <img src="<%=imgurl%>" style="height: 150px; width: auto" />                                                                
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>Surname</th>
                                                            <td><%=std.getSurname()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Other Names</th>
                                                            <td><%=std.getOthernames()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Gender</th>
                                                            <td><%=std.getGender()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Date of Birth </th>
                                                            <td><%=std.getDateOfBirth()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Phone Number</th>
                                                            <td colspan="2"><%=std.getPhoneno()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Contact Address</th>
                                                            <td colspan="2"><%=std.getContactAddress()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Home Town </th>
                                                            <td colspan="2"><%=std.getHomeTown()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Country</th>
                                                            <td colspan="2"><%=std.getNationality().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>State of Origin </th>
                                                            <td colspan="2"><%=std.getState().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Local Government Area </th>
                                                            <td colspan="2"><%=std.getLga().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="3">Application Details</th>
                                                        </tr>
                                                        <tr>
                                                            <th>Session</th>
                                                            <td colspan="2"><%=genapp.getSession()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Application Number</th>
                                                            <td colspan="2"><%=genapp.getId()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Course of Study</th>
                                                            <td colspan="2"><%=genapp.getCourse1().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Faculty</th>
                                                            <td colspan="2"><%=genapp.getCourse1().getDepartmentId().getFacultyId().getName()%></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card-body">
                            <%
                                String instname = request.getParameter("instname");
                                String inststartdate = request.getParameter("inststartdate");
                                String instenddate = request.getParameter("instenddate");
                                String instcertyear = request.getParameter("instcertyear");
                                String instresults = request.getParameter("instresults");
                                String instregno = request.getParameter("instregno");
                                String button4a = request.getParameter("button4a");
                                if (instname != null && instname.length() > 0 && button4a != null && button4a.length() > 0) {
                                    try {
                                        String sdate = inststartdate + " 00:00:00";
                                        String edate = instenddate + " 23:59:59";

                                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                                        // Define final variables
                                        final Date sdated = dateFormat.parse(sdate);
                                        final Date edated = dateFormat.parse(edate);

                                        // Filter using final variables
                                        List<Schoolsattended> contains = lschatt.stream()
                                                .filter(data -> data.getName().equalsIgnoreCase(instname)
                                                && data.getStartDate().compareTo(sdated) == 0)
                                                .collect(Collectors.toList());
                                        if (!contains.isEmpty()) {
                            %>
                            <div class="alert alert-danger">This institution has already been added</div>
                            <%
                            } else {
                                String id = genapp.getId() + settings.generateId("", 4);
                                Schoolsattended scha = new Schoolsattended(id);
                                scha.setEndDate(edated);
                                scha.setName(instname);
                                scha.setQualification(instresults);
                                scha.setRegNo(instregno);
                                scha.setStartDate(sdated);
                                scha.setYearOfAward(Integer.valueOf(instcertyear));
                                scha.setAppId(genapp.getId());
                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%                                        }
                                        lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
                                    } catch (Exception ks) {
                                    }
                                }
                            %>

                            <%
                                String docname = null;
                                String file2 = null;
                                String submit4d = null;
                                byte[] fileedit = null;
                                String url = null;
                                String ext = "";
                                String id = genapp.getId() + settings.generateId("", 4);

                                String UPLOAD_DIRECTORY = settings.documentroot + "/docs";

                                String msg = "";
                                String sty = "danger";
                                if (ServletFileUpload.isMultipartContent(request)) {
                                    try {
                                        ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
                                        List<FileItem> formItems = upload.parseRequest(request);
                                        for (FileItem item : formItems) {
                                            if (!item.isFormField()) {
                                                String fileName = new File(item.getName()).getName();
                                                String fieldName = item.getFieldName();
                                                if (fieldName.equalsIgnoreCase("file2")) {
                                                    try {
                                                        ext = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                                    } catch (Exception d) {
                                                    }
                                                    fileedit = item.get();

                                                    try {
                                                        if (!ext.matches("\\.(pdf|jpg|png|docx?)")) {

                                                        } else {

                                                            File uploadDir = new File(UPLOAD_DIRECTORY);
                                                            if (!uploadDir.exists()) {
                                                                uploadDir.mkdir();
                                                            }

                                                            String filePath = UPLOAD_DIRECTORY + File.separator + id + ext;
                                                            File storeFile = new File(filePath);
                                                            item.write(storeFile); // Save file to disk

                                                            url = "docs/" + id + ext;
                                                        }
                                                    } catch (Exception xs) {
                                                    }
                                                }

                                            } else {
                                                String fieldName = item.getFieldName();
                                                String fieldValue = item.getString();

                                                if (fieldName.equalsIgnoreCase("docname")) {
                                                    docname = fieldValue;
                                                }
                                                if (fieldName.equalsIgnoreCase("submit4d")) {
                                                    submit4d = fieldValue;
                                                }
                                            }
                                        }

                                    } catch (Exception ex) {
                                    }
                                }

                                if (submit4d != null && fileedit != null && docname != null && docname.length() > 0) {
                                    final String finalDocName = docname.trim();
                                    try {
                                        // Check if document already exists
                                        boolean exists = ldocs.stream()
                                                .anyMatch(data -> data.getName().equalsIgnoreCase(finalDocName));

                                        if (exists) {
                            %>
                            <div class="alert alert-danger">This Document has already been added</div>
                            <%
                            } else {
                                // Create new document entry
                                Uploadeddocuments scha = new Uploadeddocuments(id);
                                scha.setDateAdded(settings.getCurrentDateTime());
                                scha.setGroupId(genapp.getId());
                                scha.setName(docname);
                                scha.setUploadedBy(user.getId());
                                scha.setUrl(url);

                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }
                                        // Refresh list
                                        ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());

                                    } catch (Exception k) {
                                    }
                                }
                            %>

                            <%                                
                                String utmeno = request.getParameter("utmeno");
                                String engsc = request.getParameter("engsc");
                                String subj2 = request.getParameter("subj2");
                                String subj2sc = request.getParameter("subj2sc");
                                String subj3 = request.getParameter("subj3");
                                String subj3sc = request.getParameter("subj3sc");
                                String subj4 = request.getParameter("subj4");
                                String subj4sc = request.getParameter("subj4sc");
                                String button4k = request.getParameter("button4k");

                                String training = request.getParameter("training");
                                String empstatus = request.getParameter("empstatus");
                                String fieldstudy = request.getParameter("fieldstudy");
                                String research = request.getParameter("research");
                                String guardianname = request.getParameter("guardianname");
                                String guardianadd = request.getParameter("guardianadd");
                                String sponsorphone = request.getParameter("sponsor_phone");
                                String quali = request.getParameter("quali");
                                String maritalstatus = request.getParameter("maritalstatus");
                                if (button4k != null && button4k.length() > 0 && utmeno != null && utmeno.trim().length() > 0) {
                                    System.out.println("DEBUG: Processing UTME form for user: " + genapp.getId());
                                    System.out.println("DEBUG: UTME Registration Number: '" + utmeno + "' (length: " + utmeno.length() + ")");

                                    // Validate UTME registration number
                                    if (utmeno.trim().length() < 5) {
                                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>Error: UTME Registration Number must be at least 5 characters long.</div>");
                                    } else if (utmeno.trim().length() > 15) {
                                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>Error: UTME Registration Number cannot be longer than 15 characters. You entered " + utmeno.length() + " characters. Please check and enter the correct JAMB number.</div>");
                                    } else {
                                        try {
                                            // Check if UTME already exists for this applicant
                                            Applicantsutme utme = (Applicantsutme) sess.getSingleObject(Applicantsutme.class, genapp.getId());
                                            if (utme != null) {
                                                // Don't update — just show message
                                                out.println("<div class='alert alert-warning'>UTME subjects and scores already exist for this user. To update, please contact the administrator.</div>");
                                            } else {
                                                // Create new UTME record
                                                Applicantsutme utmeNew = new Applicantsutme(genapp.getId());
                                                System.out.println("DEBUG: Setting JAMB No: " + utmeno + " for applicant ID: " + genapp.getId());
                                                utmeNew.setJambNo(utmeno);
                                                utmeNew.setEngScore(Integer.valueOf(engsc));
                                                utmeNew.setSubj2(subj2);
                                                utmeNew.setSubj2Score(Integer.valueOf(subj2sc));
                                                utmeNew.setSubj3(subj3);
                                                utmeNew.setSubj3Score(Integer.valueOf(subj3sc));
                                                utmeNew.setSubj4(subj4);
                                                utmeNew.setSubj4Score(Integer.valueOf(subj4sc));

                                                // Calculate total UTME score
                                                int totalUtme = Integer.valueOf(engsc) + Integer.valueOf(subj2sc) + Integer.valueOf(subj3sc) + Integer.valueOf(subj4sc);
                                                utmeNew.setTotalUtme(totalUtme);

                                                sess.newEntry(utmeNew);

                                                genapp = sess.getApplicants(genapp.getId());
                                                out.println("<div class='alert alert-success'>UTME Record saved successfully! Total Score: " + totalUtme + "</div>");
                                            }

                                            // Update basic applicant information (guardian, qualification, marital status)
                                            System.out.println("DEBUG: Updating applicant info for user: " + genapp.getId());
                                            sess.updateApplicants(genapp.getId(), guardianname, guardianadd, sponsorphone, quali, maritalstatus);

                                            // Only handle Applicantsothers for POST GRADUATE applications
                                            if (genapp.getApplicationType() != null && genapp.getApplicationType().equalsIgnoreCase("POST GRADUATE")) {
                                                sess.updateApplicantsothers(genapp.getId(), "POST GRADUATE", training, empstatus, fieldstudy, research);
                                                try {
                                                    Applicantsothers dd = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                                    if (dd != null) {
                                                        sess.updateApplicantsothers(genapp.getId(), "POST GRADUATE", training, empstatus, fieldstudy, research);
                                                    } else {
                                                        others = new Applicantsothers(genapp.getId());
                                                        others.setApplicationType("POST GRADUATE");
                                                        others.setCurrentlyTraining(training);
                                                        others.setEmploymentStatus(empstatus);
                                                        others.setFieldOfStudy(fieldstudy);
                                                        others.setResearchExperience(research);
                                                        sess.newEntry(others);
                                                        // Reload global variable after creation
                                                        others = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                                    }
                                                    genapp = sess.getApplicants(genapp.getId());
                                                } catch (Exception k) {
                                                    System.out.println("Error updating Applicantsothers: " + k.getMessage());
                                                }
                                            }

                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%                                    } catch (Exception v) {
                                        System.out.println("ERROR: Exception in UTME processing: " + v.getMessage());
                                        v.printStackTrace();
                                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>Error saving UTME details: " + v.getMessage() + "</div>");
                                    }
                                }
                            } // End of button4k check
                            %>

                            <%
                                String attestationbox = request.getParameter("attestationbox");
                                String submit6 = request.getParameter("submit6");

                                // Handle Guardian & Personal Information form submission
                                String buttonPersonal = request.getParameter("buttonPersonal");
                                if (buttonPersonal != null && buttonPersonal.length() > 0) {
                                    try {
                                        // Update basic applicant information (guardian, qualification, marital status)
                                        sess.updateApplicants(genapp.getId(), guardianname, guardianadd, sponsorphone, quali, maritalstatus);

                                        // Only handle Applicantsothers for POST GRADUATE applications
                                        if (genapp.getApplicationType() != null && genapp.getApplicationType().equalsIgnoreCase("POST GRADUATE")) {
                                            try {
                                                Applicantsothers dd = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                                if (dd != null) {
                                                    sess.updateApplicantsothers(genapp.getId(), "POST GRADUATE", training, empstatus, fieldstudy, research);
                                                    // Reload global variable after update
                                                    others = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                                } else {
                                                    others = new Applicantsothers(genapp.getId());
                                                    others.setApplicationType("POST GRADUATE");
                                                    others.setCurrentlyTraining(training);
                                                    others.setEmploymentStatus(empstatus);
                                                    others.setFieldOfStudy(fieldstudy);
                                                    others.setResearchExperience(research);
                                                    sess.newEntry(others);
                                                    // Reload global variable after creation
                                                    others = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                                }
                                            } catch (Exception k) {
                                                System.out.println("Error updating Applicantsothers: " + k.getMessage());
                                            }
                                        }

                                        // Refresh genapp object to get updated data
                                        genapp = sess.getApplicants(genapp.getId());

                                        out.println("<div class='alert alert-success'><i class='fas fa-check-circle me-2'></i>Sponsor & Personal Information saved successfully!</div>");

                                    } catch (Exception v) {
                                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>Error saving Sponsor & Personal Information: " + v.getMessage() + "</div>");
                                        v.printStackTrace();
                                    }
                                }

                                if (submit6 != null && submit6.length() > 0) {
                                    if (attestationbox != null) {
                                        try {
                                            sess.completeApplicantStatus(genapp.getId());
                                            genapp = sess.getApplicants(genapp.getId());
                            %>
                            <div class="alert alert-success">Congratulations!, Your application has been completed successfully. You will be notified via email on next action and application progress</div>
                            <%
                                        } catch (Exception k) {
                                        }
                                    }
                                }
                            %>

                            <%
                                // Check completion status and missing sections
                                hasAllData = true;
                                missingItems = new ArrayList<>();

                                // Check if this is a remedial application for O-level requirements
                                boolean isRemedialForCompletion = false;
                                long olevelCountForCompletion = 0;
                                try {
                                    if (genapp.getCourse1() != null
                                            && genapp.getCourse1().getSchoolProgrammeId() != null
                                            && genapp.getCourse1().getSchoolProgrammeId().getProgrammeId() != null) {
                                        int programId = genapp.getCourse1().getSchoolProgrammeId().getProgrammeId().getId();
                                        isRemedialForCompletion = (programId == 1015);
                                    }
                                    // Get O-level count once for all applications (for display and validation)
                                    olevelCountForCompletion = sess.countOlevelSubjectsByUser(user.getId());
                                } catch (Exception e) {
                                    // Default to false if there's any error
                                }

                                // Check UTME Details
                                if (utmeCheck == null || utmeCheck.getEngScore() == null
                                        || utmeCheck.getSubj2() == null || utmeCheck.getSubj3() == null || utmeCheck.getSubj4() == null) {
                                    hasAllData = false;
                                    missingItems.add("UTME Details");
                                }

                                // Check O-level Results for remedial applications
                                if (isRemedialForCompletion && olevelCountForCompletion < 5) {
                                    hasAllData = false;
                                    missingItems.add("O-Level Results (minimum 5 subjects required)");
                                }

                                // Check Institutions Attended
                                if (lschatt == null || lschatt.isEmpty()) {
                                    hasAllData = false;
                                    missingItems.add("Institutions Attended");
                                }

                                // Check Supporting Documents
                                if (ldocs == null || ldocs.isEmpty()) {
                                    hasAllData = false;
                                    missingItems.add("Supporting Documents");
                                }

                                // Check Guardian Information
                                if (genapp.getGuardianName() == null || genapp.getGuardianName().trim().isEmpty()
                                        || genapp.getGuardianAddress() == null || genapp.getGuardianAddress().trim().isEmpty()) {
                                    hasAllData = false;
                                    missingItems.add("Sponsor Information");
                                }

                                // Check Personal Information (qualification and marital status)
                                if (genapp.getQualification() == null || genapp.getQualification().trim().isEmpty()
                                        || genapp.getMaritalStatus() == null || genapp.getMaritalStatus().trim().isEmpty()) {
                                    hasAllData = false;
                                    missingItems.add("Personal Information (Qualification & Marital Status)");
                                }

                                // Check payment status
                                if (!hasPayment) {
                                    missingItems.add("Application Fee Payment");
                                }

                                // Check if application has been submitted (Confirm & Submit completed)
                                hasBeenSubmitted = genapp.getStatus() != null
                                        && (genapp.getStatus().equalsIgnoreCase("SUBMITTED")
                                        || genapp.getStatus().equalsIgnoreCase("COMPLETED")
                                        || genapp.getStatus().equalsIgnoreCase("REGISTERED"));

                                // Application is only truly complete when it has been submitted
                                boolean isFullyComplete = hasAllData && hasPayment && hasBeenSubmitted;

                                // Determine status display with more specific messaging
                                String statusClass = "warning";
                                String statusMessage = "";

                                if (isFullyComplete) {
                                    statusClass = "success";
                                    statusMessage = "Your application is complete and has been submitted successfully.";
                                } else if (hasAllData && hasPayment && !hasBeenSubmitted) {
                                    statusClass = "info";
                                    statusMessage = "Your application details and payment are complete. Please confirm and submit your application to finalize the process.";
                                } else if (hasAllData && !hasPayment) {
                                    statusClass = "info";
                                    statusMessage = "Your application details are complete. Please make payment to submit your application.";
                                } else {
                                    // More specific messaging based on what's missing
                                    int missingCount = missingItems.size();
                                    if (missingCount == 1) {
                                        String missingItem = missingItems.get(0);
                                        if (missingItem.equals("Application Fee Payment")) {
                                            statusMessage = "Your application details are complete. Please make payment to submit your application.";
                                            statusClass = "info";
                                        } else {
                                            statusMessage = "Your application is almost complete. Please provide your " + missingItem.toLowerCase() + " to continue.";
                                        }
                                    } else if (missingCount == 2) {
                                        statusMessage = "Your application is in progress. Please complete the remaining " + missingCount + " sections to proceed.";
                                    } else if (missingCount >= 3) {
                                        statusMessage = "Your application has been started. Please complete the required sections below to proceed.";
                                    } else {
                                        statusMessage = "Your application is incomplete. Please complete all required sections below.";
                                    }
                                }
                            %>

                            <div class="alert alert-<%=statusClass%> mb-4">
                                <h5><i class="fas fa-info-circle me-2"></i>Application Status: <strong><%=genapp.getStatus()%></strong></h5>
                                <p class="mb-0"><%=statusMessage%></p>

                                <%
                                    // Add call-to-action button when ready to submit
                                    if (hasAllData && hasPayment && !hasBeenSubmitted) {
                                %>
                                <hr class="my-3">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div>
                                        <small class="text-muted">
                                            <i class="fas fa-arrow-down me-1"></i>
                                            Scroll down to the "Confirm and Submit" section to finalize your application
                                        </small>
                                    </div>
                                    <a href="/application_main1?section=submit" class="btn btn-primary btn-sm cta-button">
                                        <i class="fas fa-check-circle me-1"></i>Go to Confirm & Submit
                                    </a>
                                </div>
                                <%
                                    }
                                %>

                                <%
                                    if (!missingItems.isEmpty()) {
                                %>
                                <hr class="my-2">
                                <small class="text-muted">
                                    <strong>Missing/Required Sections:</strong><br>
                                    <%
                                        for (int i = 0; i < missingItems.size(); i++) {
                                            String item = missingItems.get(i);
                                            String badgeClass = "badge bg-warning text-dark";
                                            if (item.equals("Application Fee Payment")) {
                                                badgeClass = "badge bg-danger";
                                            }
                                    %>
                                    <span class="<%=badgeClass%> me-1 mb-1"><%=item%></span>
                                    <%
                                        }
                                    %>
                                </small>
                                <%
                                    }
                                %>

                                <%
                                    if (!hasPayment && hasAllData) {
                                %>
                                <br><br>
                                <a href="/app_payment?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" class="btn btn-success btn-sm">
                                    <i class="fas fa-credit-card me-1"></i>Make Payment Now
                                </a>
                                <%
                                    }
                                %>
                            </div>

                            <%
                                // Always show the form regardless of status
                                int i = 1;
                                if (i == 1) {
                            %>

                            <div class="accordion" id="accordionExample">
                                <!-- 1. PAYMENT SECTION (First - Always Unlocked) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingPayment">
                                        <%
                                            String paymentStatus = "";
                                            String paymentIcon = "fas fa-exclamation-triangle text-warning";
                                            if (step1_paymentComplete) {
                                                paymentStatus = " ✓";
                                                paymentIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapsePayment" aria-expanded="false" aria-controls="collapsePayment">
                                            <i class="<%=paymentIcon%> me-2"></i>1. Application Fee Payment<%=paymentStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=!step1_paymentComplete ? "show" : (sectionParam != null && sectionParam.equals("payment") ? "show" : "")%>" id="collapsePayment" aria-labelledby="headingPayment" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <%
                                                if (!step1_paymentComplete) {
                                            %>
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-credit-card me-2"></i>Application Fee Payment Required</h6>
                                                <p class="mb-0">You must complete your application fee payment before proceeding to other sections.</p>
                                            </div>

                                            <div class="text-center">
                                                <a href="/app_payment?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" class="btn btn-success btn-lg">
                                                    <i class="fas fa-credit-card me-2"></i>Make Payment Now
                                                </a>
                                            </div>
                                            <%
                                            } else {
                                            %>
                                            <div class="alert alert-success">
                                                <h6><i class="fas fa-check-circle me-2"></i>Payment Completed</h6>
                                                <p class="mb-0">Your application fee payment has been successfully processed. You can now proceed to the next section.</p>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>

                                <!-- 2. PERSONAL INFORMATION SECTION -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingPersonalSection">
                                        <%
                                            String personalStatus = "";
                                            String personalIcon = "fas fa-exclamation-triangle text-warning";
                                            if (!step2_personalUnlocked) {
                                                personalIcon = "fas fa-lock text-muted";
                                            } else if (step2_personalComplete) {
                                                personalStatus = " ✓";
                                                personalIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapsePersonalSection" aria-expanded="false" aria-controls="collapsePersonalSection" <%=!step2_personalUnlocked ? "disabled" : ""%>>
                                            <i class="<%=personalIcon%> me-2"></i>2. Guardian & Personal Information<%=personalStatus%>
                                            <%=!step2_personalUnlocked ? " (Complete payment first)" : ""%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=sectionParam != null && (sectionParam.equals("personal") || sectionParam.equals("guardian")) && step2_personalUnlocked ? "show" : ""%>" id="collapsePersonalSection" aria-labelledby="headingPersonalSection" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <%
                                                if (!step2_personalUnlocked) {
                                            %>
                                            <div class="alert alert-warning">
                                                <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                <p class="mb-0">Complete the payment section first to unlock this section.</p>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <!-- Guardian & Personal Information Section -->
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="headingGuardianPersonal">
                                                    <%
                                                        String guardianPersonalStatus = "";
                                                        String guardianPersonalIcon = "fas fa-exclamation-triangle text-warning";

                                                        // Check Guardian information completion
                                                        guardianComplete = genapp.getGuardianName() != null && !genapp.getGuardianName().trim().isEmpty()
                                                                && genapp.getGuardianAddress() != null && !genapp.getGuardianAddress().trim().isEmpty();

                                                        // Check personal information completion
                                                        boolean personalComplete = genapp.getQualification() != null && !genapp.getQualification().trim().isEmpty()
                                                                && genapp.getMaritalStatus() != null && !genapp.getMaritalStatus().trim().isEmpty();

                                                        // Section is complete only if BOTH guardian and personal info are complete
                                                        if (guardianComplete && personalComplete) {
                                                            guardianPersonalStatus = " ✓";
                                                            guardianPersonalIcon = "fas fa-check-circle text-success";
                                                        } else if (guardianComplete || personalComplete) {
                                                            guardianPersonalStatus = " ⚠️";
                                                            guardianPersonalIcon = "fas fa-exclamation-circle text-warning";
                                                        }
                                                    %>
                                                    <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseGuardianPersonal" aria-expanded="false" aria-controls="collapseGuardianPersonal">
                                                        <i class="<%=guardianPersonalIcon%> me-2"></i>Sponsor & Personal Information<%=guardianPersonalStatus%>
                                                    </button>
                                                </h2>
                                                <div class="accordion-collapse collapse <%=sectionParam != null && (sectionParam.equals("personal") || sectionParam.equals("guardian")) ? "show" : ""%>" id="collapseGuardianPersonal" aria-labelledby="headingGuardianPersonal" data-coreui-parent="#accordionExample">
                                                    <div class="accordion-body">
                                                        <div class="alert alert-info mb-3">
                                                            <h6><i class="fas fa-info-circle me-2"></i>Sponsor & Personal Information</h6>
                                                            <p class="mb-0">Please provide your Sponsor information and personal details. This information is stored in your applicant profile and can be updated at any time.</p>
                                                        </div>

                                                        <form action="" method="POST" role="form" name="personalForm">
                                                            <!-- Guardian Information Section -->
                                                            <h6 class="mb-3"><i class="fas fa-user-friends me-2"></i>Sponsor Information</h6>

                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Sponsor Name</span>
                                                                <input class="form-control" type="text" value="<%=genapp.getGuardianName() != null ? genapp.getGuardianName() : ""%>" minlength="2" required name="guardianname" placeholder="Enter guardian's full name">
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Sponsor phone</span>
                                                                <input class="form-control" type="text" value="<%=genapp.getPhoneNo() != null ? genapp.getPhoneNo() : ""%>" minlength="2" required name="sponsor_phone" placeholder="Enter Sponsor's Phone number">
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Sponsor Address</span>
                                                                <textarea class="form-control" name="guardianadd" rows="2" minlength="2" required placeholder="Enter guardian's address"><%=genapp.getGuardianAddress() != null ? genapp.getGuardianAddress() : ""%></textarea>
                                                            </div>

                                                            <!-- Personal Information Section -->
                                                            <hr class="my-4">
                                                            <h6 class="mb-3"><i class="fas fa-user me-2"></i>Personal Information</h6>

                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Qualification</span>
                                                                <input class="form-control" type="text" value="<%=genapp.getQualification() != null ? genapp.getQualification() : ""%>" required name="quali" placeholder="Enter your highest qualification">
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Marital Status</span>
                                                                <select class="form-select" name="maritalstatus" required>
                                                                    <option value="">Select Marital Status</option>
                                                                    <option value="SINGLE" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("SINGLE") ? "selected" : ""%>>Single</option>
                                                                    <option value="MARRIED" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("MARRIED") ? "selected" : ""%>>Married</option>
                                                                    <option value="DIVORCED" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("DIVORCED") ? "selected" : ""%>>Divorced</option>
                                                                    <option value="WIDOWED" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("WIDOWED") ? "selected" : ""%>>Widowed</option>
                                                                </select>
                                                            </div>

                                                            <%
                                                                // Only show POST GRADUATE specific fields for POST GRADUATE applications
                                                                if (genapp.getApplicationType() != null && genapp.getApplicationType().equalsIgnoreCase("POST GRADUATE")) {
                                                            %>
                                                            <hr class="my-4">
                                                            <div class="alert alert-info mb-3">
                                                                <small><i class="fas fa-info-circle me-1"></i>The following fields are specific to Post Graduate applications:</small>
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Currently Training</span>
                                                                <select class="form-select" name="training">
                                                                    <option value="">Select Training Status</option>
                                                                    <option value="YES" <%=others != null && others.getCurrentlyTraining() != null && others.getCurrentlyTraining().equals("YES") ? "selected" : ""%>>Yes</option>
                                                                    <option value="NO" <%=others != null && others.getCurrentlyTraining() != null && others.getCurrentlyTraining().equals("NO") ? "selected" : ""%>>No</option>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Employment Status</span>
                                                                <select class="form-select" name="empstatus">
                                                                    <option value="">Select Employment Status</option>
                                                                    <option value="EMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("EMPLOYED") ? "selected" : ""%>>Employed</option>
                                                                    <option value="UNEMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("UNEMPLOYED") ? "selected" : ""%>>Unemployed</option>
                                                                    <option value="SELF_EMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("SELF_EMPLOYED") ? "selected" : ""%>>Self Employed</option>
                                                                </select>
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Field of Study</span>
                                                                <input class="form-control" type="text" value="<%=others != null && others.getFieldOfStudy() != null ? others.getFieldOfStudy() : ""%>" name="fieldstudy" placeholder="Enter your field of study">
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Research Experience</span>
                                                                <textarea class="form-control" name="research" rows="3" placeholder="Describe your research experience"><%=others != null && others.getResearchExperience() != null ? others.getResearchExperience() : ""%></textarea>
                                                            </div>
                                                            <%
                                                            } else {
                                                                // For non-POST GRADUATE applications, set empty values for these fields
                                                            %>
                                                            <input type="hidden" name="training" value="">
                                                            <input type="hidden" name="empstatus" value="">
                                                            <input type="hidden" name="fieldstudy" value="">
                                                            <input type="hidden" name="research" value="">
                                                            <%
                                                                }
                                                            %>

                                                            <!-- Hidden fields for UTME info (empty for Personal-only form) -->
                                                            <input type="hidden" name="utmeno" value="<%=utmeCheck != null && utmeCheck.getJambNo() != null ? utmeCheck.getJambNo() : ""%>">
                                                            <input type="hidden" name="engsc" value="<%=utmeCheck != null && utmeCheck.getEngScore() != null ? utmeCheck.getEngScore() : ""%>">
                                                            <input type="hidden" name="subj2" value="<%=utmeCheck != null && utmeCheck.getSubj2() != null ? utmeCheck.getSubj2() : ""%>">
                                                            <input type="hidden" name="subj2sc" value="<%=utmeCheck != null && utmeCheck.getSubj2Score() != null ? utmeCheck.getSubj2Score() : ""%>">
                                                            <input type="hidden" name="subj3" value="<%=utmeCheck != null && utmeCheck.getSubj3() != null ? utmeCheck.getSubj3() : ""%>">
                                                            <input type="hidden" name="subj3sc" value="<%=utmeCheck != null && utmeCheck.getSubj3Score() != null ? utmeCheck.getSubj3Score() : ""%>">
                                                            <input type="hidden" name="subj4" value="<%=utmeCheck != null && utmeCheck.getSubj4() != null ? utmeCheck.getSubj4() : ""%>">
                                                            <input type="hidden" name="subj4sc" value="<%=utmeCheck != null && utmeCheck.getSubj4Score() != null ? utmeCheck.getSubj4Score() : ""%>">

                                                            <div class="row">
                                                                <div class="col-12">
                                                                    <input type="submit" name="buttonPersonal" class="btn btn-success px-4" value="Save Sponsor & Personal Information"/>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- End Guardian & Personal Information Section -->

                                            <!-- UTME Section -->
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="headingUtme">
                                                    <%
                                                        String utmeStatus = "";
                                                        String utmeIcon = "fas fa-exclamation-triangle text-warning";

                                                        // Check if UTME section is unlocked (personal section must be complete)
                                                        boolean utmeUnlocked_local = step3_utmeUnlocked;

                                                        if (!utmeUnlocked_local) {
                                                            utmeIcon = "fas fa-lock text-muted";
                                                        } else if (step3_utmeComplete) {
                                                            utmeStatus = " ✓";
                                                            utmeIcon = "fas fa-check-circle text-success";
                                                        }
                                                    %>
                                                    <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseUtme" aria-expanded="true" aria-controls="collapseUtme" <%=!utmeUnlocked_local ? "disabled" : ""%>>
                                                        <i class="<%=utmeIcon%> me-2"></i>3. UTME Details<%=utmeStatus%>
                                                        <%=!utmeUnlocked_local ? " (Complete personal information first)" : ""%>
                                                    </button>
                                                </h2>
                                                <div class="accordion-collapse collapse <%=sectionParam != null && sectionParam.equals("utme") ? "show" : expandUtme%>" id="collapseUtme" aria-labelledby="headingUtme" data-coreui-parent="#accordionExample">
                                                    <div class="accordion-body">
                                                        <%
                                                            if (!utmeUnlocked_local) {
                                                        %>
                                                        <div class="alert alert-warning">
                                                            <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                            <p class="mb-0">Complete the personal information section first to unlock UTME details.</p>
                                                        </div>
                                                        <%
                                                        } else {
                                                        %>

                                                        <%
                                                            if (utmeCheck != null) {
                                                        %>
                                                        <div class="alert alert-info mb-3">
                                                            <h6><i class="fas fa-info-circle me-2"></i>Existing UTME Record Found</h6>
                                                            <p class="mb-0">Your UTME data is pre-filled below. You can review and update it if needed.</p>

                                                            <!-- Display existing UTME data -->
                                                            <div class="row mt-3">
                                                                <div class="col-md-6">
                                                                    <strong>English Score:</strong> <%=utmeCheck.getEngScore() != null ? utmeCheck.getEngScore() : "N/A"%><br>
                                                                    <%
                                                                        if (utmeCheck.getSubj2() != null) {
                                                                            Utmesubjects subj2Name = sess.getUtmesubjects(utmeCheck.getSubj2());
                                                                    %>
                                                                    <strong>Subject 2:</strong> <%=subj2Name != null ? subj2Name.getName() : "Unknown"%> (<%=utmeCheck.getSubj2Score() != null ? utmeCheck.getSubj2Score() : "N/A"%>)<br>
                                                                    <%
                                                                        }
                                                                        if (utmeCheck.getSubj3() != null) {
                                                                            Utmesubjects subj3Name = sess.getUtmesubjects(utmeCheck.getSubj3());
                                                                    %>
                                                                    <strong>Subject 3:</strong> <%=subj3Name != null ? subj3Name.getName() : "Unknown"%> (<%=utmeCheck.getSubj3Score() != null ? utmeCheck.getSubj3Score() : "N/A"%>)<br>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <%
                                                                        if (utmeCheck.getSubj4() != null) {
                                                                            Utmesubjects subj4Name = sess.getUtmesubjects(utmeCheck.getSubj4());
                                                                    %>
                                                                    <strong>Subject 4:</strong> <%=subj4Name != null ? subj4Name.getName() : "Unknown"%> (<%=utmeCheck.getSubj4Score() != null ? utmeCheck.getSubj4Score() : "N/A"%>)<br>
                                                                    <%
                                                                        }
                                                                        if (utmeCheck.getTotalUtme() != null) {
                                                                    %>
                                                                    <strong>Total UTME Score:</strong> <%=utmeCheck.getTotalUtme()%>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <%
                                                        } else {
                                                        %>
                                                        <div class="alert alert-warning mb-3">
                                                            <h6><i class="fas fa-exclamation-triangle me-2"></i>UTME Information Required</h6>
                                                            <p class="mb-0">Please enter your UTME subjects and scores below. This information is required to complete your application.</p>
                                                            <small class="text-muted">
                                                                <strong>Note:</strong> Ensure all scores are accurate as they cannot be modified after submission.
                                                            </small>
                                                        </div>
                                                        <%
                                                            }
                                                        %>

                                                        <form action="" method="POST" role="form" name="utmeForm">
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">UTME Registration Number</span>
                                                                <input class="form-control" type="text" value="<%=utmeCheck != null && utmeCheck.getJambNo() != null ? utmeCheck.getJambNo() : ""%>" minlength="2" required name="utmeno" placeholder="Enter UTME Registration Number">
                                                            </div>
                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">English Scores</span>
                                                                <input class="form-control" type="number" value="<%=utmeCheck != null && utmeCheck.getEngScore() != null ? utmeCheck.getEngScore() : ""%>" min="0" max="100" required name="engsc" placeholder="Enter English score (0-100)">
                                                            </div>

                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Subject 2</span>
                                                                <select class="form-select" name="subj2" required>
                                                                    <option value="">Select Subject</option>
                                                                    <%
                                                                        List<Utmesubjects> utmel = sess.getAlUtmesubjects("ACTIVE");
                                                                        for (Utmesubjects utme : utmel) {
                                                                            String selected = "";
                                                                            if (utmeCheck != null && utmeCheck.getSubj2() != null && utmeCheck.getSubj2().equals(utme.getId())) {
                                                                                selected = "selected";
                                                                            }
                                                                    %>
                                                                    <option value="<%=utme.getId()%>" <%=selected%>><%=utme.getName()%></option>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                                &nbsp;
                                                                <input class="form-control" type="number" value="<%=utmeCheck != null && utmeCheck.getSubj2Score() != null ? utmeCheck.getSubj2Score() : ""%>" min="0" max="100" required name="subj2sc" placeholder="Enter score (0-100)">
                                                            </div>

                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Subject 3</span>
                                                                <select class="form-select" name="subj3" required>
                                                                    <option value="">Select Subject</option>
                                                                    <%
                                                                        for (Utmesubjects utme : utmel) {
                                                                            String selected = "";
                                                                            if (utmeCheck != null && utmeCheck.getSubj3() != null && utmeCheck.getSubj3().equals(utme.getId())) {
                                                                                selected = "selected";
                                                                            }
                                                                    %>
                                                                    <option value="<%=utme.getId()%>" <%=selected%>><%=utme.getName()%></option>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                                &nbsp;
                                                                <input class="form-control" type="number" value="<%=utmeCheck != null && utmeCheck.getSubj3Score() != null ? utmeCheck.getSubj3Score() : ""%>" min="0" max="100" required name="subj3sc" placeholder="Enter score (0-100)">
                                                            </div>

                                                            <div class="input-group mb-4">
                                                                <span class="input-group-text">Subject 4</span>
                                                                <select class="form-select" name="subj4" required>
                                                                    <option value="">Select Subject</option>
                                                                    <%
                                                                        for (Utmesubjects utme : utmel) {
                                                                            String selected = "";
                                                                            if (utmeCheck != null && utmeCheck.getSubj4() != null && utmeCheck.getSubj4().equals(utme.getId())) {
                                                                                selected = "selected";
                                                                            }
                                                                    %>
                                                                    <option value="<%=utme.getId()%>" <%=selected%>><%=utme.getName()%></option>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                                &nbsp;
                                                                <input class="form-control" type="number" value="<%=utmeCheck != null && utmeCheck.getSubj4Score() != null ? utmeCheck.getSubj4Score() : ""%>" min="0" max="100" required name="subj4sc" placeholder="Enter score (0-100)">
                                                            </div>

                                                            <!-- Hidden fields for Guardian & Personal info (empty for UTME-only form) -->
                                                            <input type="hidden" name="guardianname" value="<%=genapp.getGuardianName() != null ? genapp.getGuardianName() : ""%>">
                                                            <input type="hidden" name="sponsor_phone" value="<%=genapp.getSponsorPhone() != null ? genapp.getSponsorPhone() : ""%>">
                                                            <input type="hidden" name="guardianadd" value="<%=genapp.getGuardianAddress() != null ? genapp.getGuardianAddress() : ""%>">
                                                            <input type="hidden" name="quali" value="<%=genapp.getQualification() != null ? genapp.getQualification() : ""%>">
                                                            <input type="hidden" name="maritalstatus" value="<%=genapp.getMaritalStatus() != null ? genapp.getMaritalStatus() : ""%>">

                                                            <input type="hidden" name="training" value="<%=others != null && others.getCurrentlyTraining() != null ? others.getCurrentlyTraining() : ""%>">
                                                            <input type="hidden" name="empstatus" value="<%=others != null && others.getEmploymentStatus() != null ? others.getEmploymentStatus() : ""%>">
                                                            <input type="hidden" name="fieldstudy" value="<%=others != null && others.getFieldOfStudy() != null ? others.getFieldOfStudy() : ""%>">
                                                            <input type="hidden" name="research" value="<%=others != null && others.getResearchExperience() != null ? others.getResearchExperience() : ""%>">

                                                            <div class="row">
                                                                <div class="col-12">
                                                                    <input type="submit" name="button4k" class="btn btn-primary px-4" value="Save UTME Details"/>
                                                                </div>
                                                            </div>
                                                        </form>
                                                        <%
                                                            } // End of utmeUnlocked_local check
                                                        %>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- End UTME Section -->
                                            <%
                                                } // End of step2_personalUnlocked check
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Personal Information Section -->

                                <!-- 4. O-Level Results Section -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOlevel">
                                        <%
                                            String olevelStatus = "";
                                            String olevelIcon = "fas fa-exclamation-triangle text-warning";

                                            if (!step4_olevelUnlocked) {
                                                olevelIcon = "fas fa-lock text-muted";
                                            } else if (olevelComplete) {
                                                olevelStatus = " ✓";
                                                olevelIcon = "fas fa-check-circle text-success";
                                            }

                                            String expandOlevel = "";
                                            if (sectionParam != null && sectionParam.equals("olevel")) {
                                                expandOlevel = "show";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOlevel" aria-expanded="false" aria-controls="collapseOlevel" <%=!step4_olevelUnlocked ? "disabled" : ""%>>
                                            <i class="<%=olevelIcon%> me-2"></i>4. O-Level Results (<%=olevelCount%> subjects added)<%=olevelStatus%>
                                            <%=!step4_olevelUnlocked ? " (Complete UTME details first)" : ""%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=step4_olevelUnlocked && sectionParam != null && sectionParam.equals("olevel") ? "show" : (step4_olevelUnlocked ? expandOlevel : "")%>" id="collapseOlevel" aria-labelledby="headingOlevel" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <%
                                                if (!step4_olevelUnlocked) {
                                            %>
                                            <div class="alert alert-warning">
                                                <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                <p class="mb-0">Complete the UTME details section first to unlock O-Level results entry.</p>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-graduation-cap me-2"></i>O-Level Results Entry</h6>
                                                <p class="mb-0">Please enter your O-Level examination results. You can add results from up to 2 sittings (First and Second sitting) with a maximum of 9 subjects total. <%=isRemedialApp ? "Minimum 5 subjects required for remedial applications." : ""%></p>
                                            </div>
                                            
                                            <!-- O-level form would go here -->
                                            <div class="alert alert-info">
                                                <p>O-Level form would be displayed here for remedial applications.</p>
                                                <p>Current O-Level subject count: <strong><%=olevelCount%></strong></p>
                                                <% if (olevelCount >= 5 && isRemedialApp) { %>
                                                <div class="alert alert-success mt-2">
                                                    <i class="fas fa-check-circle me-2"></i>Minimum requirement of 5 subjects met for remedial application.
                                                </div>
                                                <% } %>
                                            </div>
                                            <%
                                                } // End of step4_olevelUnlocked check
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <!-- End O-Level Results Section -->

                                <!-- 5. Institutions Attended Section -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSix">
                                        <%
                                            String instStatus = "";
                                            String instIcon = "fas fa-exclamation-triangle text-warning";

                                            if (!step5_institutionsUnlocked) {
                                                instIcon = "fas fa-lock text-muted";
                                            } else if (lschatt != null && !lschatt.isEmpty()) {
                                                instStatus = " ✓";
                                                instIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseSix" aria-expanded="false" aria-controls="collapseSix" <%=!step5_institutionsUnlocked ? "disabled" : ""%>>
                                            <i class="<%=instIcon%> me-2"></i>5. Institutions Attended (<%=lschatt.size()%> added)<%=instStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandInstitutions%>" id="collapseSix" aria-labelledby="headingSix" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (!step5_institutionsUnlocked) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                <p class="mb-0">Complete the O-Level section first to unlock Institutions section.</p>
                                            </div>
                                            <%
                                            } else if (lschatt == null || lschatt.isEmpty()) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-exclamation-triangle me-2"></i>No Institutions Added Yet</h6>
                                                <p class="mb-0">Please add at least one institution you have attended. This is required to complete your application.</p>
                                                <small class="text-muted">
                                                    <strong>Tip:</strong> Include all secondary schools, colleges, or universities you have attended.
                                                </small>
                                            </div>
                                            <%
                                            }
                                            %>

                                            <% if (step5_institutionsUnlocked) { %>
                                            <form action='' method='post' name="institutions">
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Name of Institution</span>
                                                    <input class="form-control" type="text" name="instname" required="">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Start date</span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="inststartdate" required="">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">End Date</span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="instenddate">
                                                </div>

                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Year Graduated</span>
                                                    <input class="form-control" type="number" max="<%=settings.getTodaysdate().split("-")[0]%>" name="instcertyear">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Results</span>
                                                    <input class="form-control" type="text" name="instresults">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Registration Number</span>
                                                    <input class="form-control" type="text" name="instregno">
                                                </div>

                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="button4a" class="btn btn-primary px-4" value="Add Record"/>
                                                    </div>
                                                </div>
                                            </form>

                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Name</th>
                                                        <th>From</th>
                                                        <th>To</th>
                                                        <th>Certificate</th>
                                                        <th>Remove</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (Schoolsattended data : lschatt) {
                                                    %>
                                                    <tr>
                                                        <td><%=data.getName()%></td>
                                                        <td><%=sdf.format(data.getStartDate())%></td>
                                                        <td><%=sdf.format(data.getEndDate())%></td>
                                                        <td><%=data.getQualification()%></td>
                                                        <td><a href="/application_pg1?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Institutions Attended Section -->

                                <!-- 6. Supporting Documents Section -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <%
                                            String docsStatus = "";
                                            String docsIcon = "fas fa-exclamation-triangle text-warning";
                                            
                                            if (!step6_documentsUnlocked) {
                                                docsIcon = "fas fa-lock text-muted";
                                            } else if (ldocs != null && !ldocs.isEmpty()) {
                                                docsStatus = " ✓";
                                                docsIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo" <%=!step6_documentsUnlocked ? "disabled" : ""%>>
                                            <i class="<%=docsIcon%> me-2"></i>6. Supporting Documents (<%=ldocs.size()%> added)<%=docsStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandDocuments%>" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (!step6_documentsUnlocked) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                <p class="mb-0">Complete the Institutions section first to unlock Documents section.</p>
                                            </div>
                                            <%
                                            }
                                            %>
                                            
                                            <% if (step6_documentsUnlocked) { %>
                                            <form action='' method='post' name="uploaddocs" enctype="multipart/form-data">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">
                                                        <div class="mb-3 row">
                                                            <label class="col-sm-3 col-form-label" for="payerno">Document Name</label>
                                                            <div class="col-sm-4">
                                                                <input class="form-control" name="docname" type="text" required="">
                                                            </div>
                                                            <div class="col-sm-3">
                                                                <input class="form-control" type="file" accept=".pdf, .png, .jpg" name="file2" required="">
                                                            </div>
                                                            <div class="col-sm-2">
                                                                <button name="submit4d" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>

                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Doc. Name</th>
                                                        <th>Preview</th>
                                                        <th>Remove</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (Uploadeddocuments data : ldocs) {
                                                    %>
                                                    <tr>
                                                        <td><%=data.getName()%></td>
                                                        <td>
                                                            <div class="col-sm-2">
                                                                <a href="#" 
                                                                   class="btn btn-secondary mb-3"
                                                                   data-coreui-toggle="modal" 
                                                                   data-coreui-target="#details" 
                                                                   onclick="loadDocument('<%=data.getId()%>')" 
                                                                   >
                                                                    Preview
                                                                </a>

                                                                <div class="modal fade" id="details" tabindex="-1" aria-labelledby="detailslab" aria-hidden="true">
                                                                    <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <h5 class="modal-title" id="detailslab"><%=data.getName()%></h5>
                                                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                            </div>
                                                                            <div class="modal-body">
                                                                                <div id="det">Loading...</div>
                                                                            </div>
                                                                            <div class="modal-footer">
                                                                                <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                        </td>
                                                        <td><a href="/application_pg1?id4=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Supporting Documents Section -->

                                <!-- 7. Confirm and Submit Section -->
                                <div class="accordion-item<%=(hasAllData && hasPayment && !hasBeenSubmitted) ? " ready-to-submit" : ""%>">
                                    <h2 class="accordion-header" id="headingFive">
                                        <%
                                            String submitStatus = "";
                                            String submitIcon = "fas fa-exclamation-triangle text-warning";
                                            boolean canSubmit = hasAllData && hasPayment;

                                            // Only show green checkmark if application has been actually submitted
                                            if (hasBeenSubmitted) {
                                                submitStatus = " ✓";
                                                submitIcon = "fas fa-check-circle text-success";
                                            } else if (canSubmit) {
                                                // Ready to submit but not yet submitted - show info icon
                                                submitIcon = "fas fa-info-circle text-info";
                                            }
                                        %>
                                        <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseFive" aria-expanded="true" aria-controls="collapseFive" <%=!step7_submitUnlocked ? "disabled" : ""%>>
                                            <i class="<%=submitIcon%> me-2"></i>7. Confirm and Submit<%=submitStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=sectionParam != null && (sectionParam.equals("submit") || sectionParam.equals("confirm")) ? "show" : expandSubmit%>" id="collapseFive" aria-labelledby="headingFive" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (!step7_submitUnlocked) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-lock me-2"></i>Section Locked</h6>
                                                <p class="mb-0">Complete all previous sections first to unlock final submission.</p>
                                            </div>
                                            <%
                                                } else if (!canSubmit) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-exclamation-triangle me-2"></i>Cannot Submit Application Yet</h6>
                                                <p class="mb-2">You must complete all required sections before you can submit your application:</p>
                                                <ul class="mb-0">
                                                    <%
                                                        for (String item : missingItems) {
                                                    %>
                                                    <li><%=item%></li>
                                                        <%
                                                            }
                                                        %>
                                                </ul>
                                                <%
                                                    if (!hasPayment && hasAllData) {
                                                %>
                                                <hr class="my-2">
                                                <a href="/app_payment?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" class="btn btn-success btn-sm">
                                                    <i class="fas fa-credit-card me-1"></i>Make Payment Now
                                                </a>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <%
                                            } else if (!hasBeenSubmitted) {
                                            %>
                                            <div class="alert alert-success mb-3">
                                                <h6><i class="fas fa-check-circle me-2"></i>Ready to Submit</h6>
                                                <p class="mb-0">All required sections have been completed. You can now submit your application by checking the declaration below and clicking "Submit Application".</p>
                                            </div>
                                            <%
                                            } else {
                                            %>
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-check-circle me-2"></i>Application Submitted</h6>
                                                <p class="mb-0">Your application has been successfully submitted and is now being processed.</p>
                                            </div>
                                            <%
                                                }
                                            %>

                                            <div class="alert alert-info">
                                                <strong>Important Notice:</strong><br>
                                                Note that by confirming your application, you are agreeing that you have gone through your application and have satisfied that every needed information is provided correctly. 
                                                Any modification after this action will not be permitted.
                                                <p>However, this action marks the completion of your application process and it is after this that your application will be received by the school for processing.</p>
                                            </div>

                                            <%
                                                if (canSubmit && !hasBeenSubmitted) {
                                            %>
                                            <form action='' method='post' name="attestation">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">
                                                        <div class="card border-primary">
                                                            <div class="card-body">
                                                                <div class="mb-3 row align-items-center">
                                                                    <div class="col-sm-1">
                                                                        <input class="form-check-input" name="attestationbox" type="checkbox" required="" style="transform: scale(1.2);">
                                                                    </div>
                                                                    <label class="col-sm-9 form-check-label" for="attestationbox">
                                                                        <strong>Declaration:</strong> I <%=std.getSurname() + " " + std.getOthernames()%>, hereby declare that the information stated above is to the best of my knowledge and belief, accurate in every detail.
                                                                    </label>
                                                                    <div class="col-sm-2">
                                                                        <button name="submit6" value="Submit" class="btn btn-success btn-lg" type="submit">
                                                                            <i class="fas fa-paper-plane me-2"></i>Submit Application
                                                                        </button>                       
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                            <%
                                            } else if (hasBeenSubmitted) {
                                            %>
                                            <div class="text-center">
                                                <div class="alert alert-success">
                                                    <h5><i class="fas fa-check-circle me-2"></i>Application Successfully Submitted</h5>
                                                    <p class="mb-0">Your application was submitted on <%=genapp.getDateInitiated()%> and is now being processed.</p>
                                                </div>
                                            </div>
                                            <%
                                            } else if (!step7_submitUnlocked) {
                                            %>
                                            <div class="text-center">
                                                <button class="btn btn-secondary" disabled>
                                                    <i class="fas fa-lock me-1"></i>Complete All Sections First
                                                </button>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Confirm and Submit Section -->
                            </div>
                            <!-- End Accordion -->
                            <%
                                } // End of if (i == 1)
                            } else { // End of if (std != null) - else block
                                // This block handles the case where std is null
                                // The original code had logic here for payment processing
                                // Since std is null, we can't proceed with payment
                            %>
                            <div class="alert alert-danger">
                                <h6><i class="fas fa-exclamation-triangle me-2"></i>Error: Student information not found</h6>
                                <p class="mb-0">Unable to load student information. Please contact support or try again later.</p>
                            </div>
                            <%
                            } // End of else block for if (std != null)
                            %>
                        </div>
                    </div>
                </div>
            </div>

            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>

        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
        <script src="js/popovers.js"></script>

        <script>
            // UTME form validation
            window.validateUTMEForm = function() {
                var utmeno = document.getElementsByName('utmeno')[0].value.trim();
                var engsc = document.getElementsByName('engsc')[0].value;
                var subj2sc = document.getElementsByName('subj2sc')[0].value;
                var subj3sc = document.getElementsByName('subj3sc')[0].value;
                var subj4sc = document.getElementsByName('subj4sc')[0].value;

                if (utmeno === '') {
                    alert('UTME Registration Number is required');
                    return false;
                }

                if (engsc === '' || subj2sc === '' || subj3sc === '' || subj4sc === '') {
                    alert('All subject scores are required');
                    return false;
                }

                var scores = [parseInt(engsc), parseInt(subj2sc), parseInt(subj3sc), parseInt(subj4sc)];
                for (var i = 0; i < scores.length; i++) {
                    if (scores[i] < 0 || scores[i] > 100) {
                        alert('All scores must be between 0 and 100');
                        return false;
                    }
                }

                var total = scores.reduce(function (a, b) {
                    return a + b;
                }, 0);
                if (total < 160) {
                    if (!confirm('Your total UTME score is ' + total + ', which is below the typical minimum of 160. Do you want to continue?')) {
                        return false;
                    }
                }

                return true;
            };
            
            document.addEventListener('DOMContentLoaded', function () {
                // Auto-scroll to expanded section if section parameter is present
                const urlParams = new URLSearchParams(window.location.search);
                const section = urlParams.get('section');
                if (section === 'submit' || section === 'confirm') {
                    setTimeout(() => {
                        const confirmSection = document.getElementById('collapseFive');
                        if (confirmSection && confirmSection.classList.contains('show')) {
                            confirmSection.scrollIntoView({behavior: 'smooth', block: 'start'});
                        }
                    }, 500);
                }
            });
        </script>
    </body>
</html>