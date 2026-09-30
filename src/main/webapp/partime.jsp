<%-- 
    Document   : template
    Created on : 6 Dec 2025, 15:48:36
    Author     : BEMGBA
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
    List<Schoolsattended> lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
    List<Applicantsreferees> lref = sess.getApplicantsrefereesByRegno(genapp.getId());
    List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());
    
    // Initialize Applicantsothers to resolve undefined variable
    Applicantsothers others = null;
    try {
        others = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
    } catch (Exception e) {
        others = null;
    }
    
    // Load O-level data for partime applications
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
    
    // O-level message variables (declared at broader scope for HTML access)
    String olevelMessage = "";
    String olevelMessageType = "";
    
    // Handle section parameter to determine which accordion to expand
    String sectionParam = request.getParameter("section");
    String expandOlevel = "";  // Default: don't expand any section
    String expandPersonal = "";
    String expandInstitutions = "";
    String expandDocuments = "";
    String expandSubmit = "";
    
    if (sectionParam != null) {
        // Expand specific section based on parameter
        if (sectionParam.equals("olevel")) {
            expandOlevel = "show";
        } else if (sectionParam.equals("personal") || sectionParam.equals("guardian")) {
            expandPersonal = "show";
        } else if (sectionParam.equals("institutions")) {
            expandInstitutions = "show";
        } else if (sectionParam.equals("documents")) {
            expandDocuments = "show";
        } else {
            // Default behavior - expand first incomplete section
            expandOlevel = "show";
        }
    } else {
        // Default behavior when no section parameter - expand first incomplete section
        expandOlevel = "show";
    }
%>   
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Part Time || Certificate Application</title>
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

            #subjectTable .btn-danger:disabled {
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
                    document.getElementById("det").innerHTML = respText;     // Use `id2` here
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
                    <h2 class="title">Part-TIME Diploma  & Certificate Application</h2>
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

                                                                            // Encode the byte array to a Base64 string
                                                                            imgurl = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);

                                                                            // Create the HTML <img> tag
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
                                
                                // Note: Don't update application status to SUBMITTED here - only update when attestation is completed
                                // sess.checkAndUpdateApplicationStatus(genapp.getId());
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }

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
                                // O-Level Form Processing Logic (similar to remedial_form2.jsp)
                                String name = request.getParameter("name");
                                String resultType = request.getParameter("resultType");
                                String registrationNo = request.getParameter("registrationNo");
                                String examDate = request.getParameter("examDate");
                                String sitting = request.getParameter("sitting");
                                String[] subjectIds = request.getParameterValues("subject[]");
                                String[] gradeIds = request.getParameterValues("grade[]");
                                String submitOlevel = request.getParameter("submitOlevel");
                                
                                // Hidden fields for existing sitting
                                String hiddenName = request.getParameter("hiddenName");
                                String hiddenResultType = request.getParameter("hiddenResultType");
                                String hiddenRegistrationNo = request.getParameter("hiddenRegistrationNo");
                                String hiddenExamDate = request.getParameter("hiddenExamDate");
                                String isExistingSittingStr = request.getParameter("isExistingSitting");
                                boolean isExistingSitting = "true".equals(isExistingSittingStr);
                                
                                // Debug: Check all parameters
                                System.out.println("DEBUG PARTIME: Checking O-level parameters:");
                                System.out.println("  - submitOlevel: " + submitOlevel);
                                System.out.println("  - name: " + name);
                                System.out.println("  - examDate: " + examDate);
                                System.out.println("  - sitting: " + sitting);
                                System.out.println("  - subjectIds: " + (subjectIds != null ? subjectIds.length + " items" : "null"));
                                System.out.println("  - gradeIds: " + (gradeIds != null ? gradeIds.length + " items" : "null"));
                                
                                if (submitOlevel != null && name != null && examDate != null && sitting != null 
                                        && subjectIds != null && gradeIds != null) {
                                    System.out.println("DEBUG PARTIME: O-level form submitted!");
                                    System.out.println("  - submitOlevel: " + submitOlevel);
                                    System.out.println("  - name: " + name);
                                    System.out.println("  - examDate: " + examDate);
                                    System.out.println("  - sitting: " + sitting);
                                    System.out.println("  - subjectIds length: " + (subjectIds != null ? subjectIds.length : "null"));
                                    System.out.println("  - gradeIds length: " + (gradeIds != null ? gradeIds.length : "null"));
                                    System.out.println("  - sess object: " + (sess != null ? "available" : "null"));
                                    System.out.println("  - user object: " + (user != null ? user.getId() : "null"));
                                    System.out.println("  - genapp object: " + (genapp != null ? genapp.getId() : "null"));
                                    
                                    try {
                                        String userId = user.getId();
                                        String applicantId = genapp.getId();
                                        
                                        // Use hidden fields if this is an existing sitting
                                        if (isExistingSitting && hiddenName != null && !hiddenName.trim().isEmpty()) {
                                            name = hiddenName;
                                            resultType = hiddenResultType;
                                            registrationNo = hiddenRegistrationNo;
                                            examDate = hiddenExamDate;
                                        }
                                        
                                        // Validation
                                        if (name == null || name.trim().isEmpty() || resultType == null || resultType.trim().isEmpty()
                                                || examDate == null || examDate.trim().isEmpty() || sitting == null || sitting.trim().isEmpty()) {
                                            olevelMessage = "All required fields must be filled.";
                                            olevelMessageType = "danger";
                                        } else {
                                            // Get existing O-level results by BOTH userId AND applicationId
                                            List<Olevelresults> existingResultsByUser = sess.getOlevelresultsByUserId(userId);
                                            List<Olevelresults> existingResultsByApp = sess.getOlevelresultsByUserId(applicantId);
                                            
                                            // Combine both lists and remove duplicates
                                            List<Olevelresults> allExistingResults = new ArrayList<>();
                                            allExistingResults.addAll(existingResultsByUser);
                                            for (Olevelresults appResult : existingResultsByApp) {
                                                boolean exists = false;
                                                for (Olevelresults userResult : existingResultsByUser) {
                                                    if (appResult.getId().equals(userResult.getId())) {
                                                        exists = true;
                                                        break;
                                                    }
                                                }
                                                if (!exists) {
                                                    allExistingResults.add(appResult);
                                                }
                                            }
                                            
                                            long existingCountByUser = sess.countOlevelSubjectsByUser(userId);
                                            long existingCountByApp = sess.countOlevelSubjectsByUser(applicantId);
                                            long totalExistingCount = Math.max(existingCountByUser, existingCountByApp);
                                            
                                            // Check if maximum subjects reached
                                            if (totalExistingCount >= 9) {
                                                olevelMessage = "Maximum 9 O-level subjects already reached.";
                                                olevelMessageType = "danger";
                                            } else {
                                                // Check for existing sitting
                                                Olevelresults existingSittingResult = null;
                                                for (Olevelresults result : allExistingResults) {
                                                    if (sitting.equals(result.getSitting())) {
                                                        existingSittingResult = result;
                                                        break;
                                                    }
                                                }
                                                
                                                // Validate: Maximum 2 sittings allowed
                                                if (existingSittingResult == null && allExistingResults.size() >= 2) {
                                                    olevelMessage = "Maximum 2 sittings allowed. You already have First and Second sittings.";
                                                    olevelMessageType = "danger";
                                                } else {
                                                    // Use existing or create new sitting result
                                                    Olevelresults result = existingSittingResult;
                                                    if (result == null) {
                                                        System.out.println("DEBUG PARTIME: Creating new O-level sitting record");
                                                        result = new Olevelresults();
                                                        String idu = settings.generateId("", 10);
                                                        result.setId(idu);
                                                        result.setUserId(userId);  // Always use userId for consistency
                                                        result.setName(name);
                                                        result.setResultType(resultType);
                                                        result.setRegistrationNo(registrationNo);
                                                        result.setExamDate(examDate);
                                                        result.setSitting(sitting);
                                                        result.setDateAdded(settings.getCurrentDateTime());
                                                        System.out.println("DEBUG PARTIME: About to save O-level sitting: " + idu);
                                                        sess.newEntry(result);
                                                        System.out.println("DEBUG PARTIME: O-level sitting saved successfully");
                                                    } else {
                                                        System.out.println("DEBUG PARTIME: Using existing sitting record: " + result.getId());
                                                    }
                                                
                                                    // Process subjects - check for duplicates across BOTH userId and applicationId
                                                    List<Olevelresultsitems> existingItemsByUser = sess.getOlevelresultsItemsByUserId(userId);
                                                    List<Olevelresultsitems> existingItemsByApp = sess.getOlevelresultsItemsByUserId(applicantId);
                                                    
                                                    // Combine both lists
                                                    List<Olevelresultsitems> allExistingItems = new ArrayList<>();
                                                    allExistingItems.addAll(existingItemsByUser);
                                                    for (Olevelresultsitems appItem : existingItemsByApp) {
                                                        boolean exists = false;
                                                        for (Olevelresultsitems userItem : existingItemsByUser) {
                                                            if (appItem.getId().equals(userItem.getId())) {
                                                                exists = true;
                                                                break;
                                                            }
                                                        }
                                                        if (!exists) {
                                                            allExistingItems.add(appItem);
                                                        }
                                                    }
                                                    
                                                    int addedCount = 0;
                                                    int skippedCount = 0;
                                                    int allowed = (int)(9 - totalExistingCount);
                                                    
                                                    for (int i = 0; i < subjectIds.length && addedCount < allowed; i++) {
                                                        String subjId = subjectIds[i];
                                                        String gradeId = (i < gradeIds.length) ? gradeIds[i] : null;
                                                        
                                                        if (subjId != null && !subjId.isEmpty() && gradeId != null && !gradeId.isEmpty()) {
                                                            System.out.println("DEBUG PARTIME: Processing subject " + (i+1) + ": " + subjId + " with grade: " + gradeId);
                                                            Olevelsubjects subjEntity = (Olevelsubjects) sess.getSingleObject(Olevelsubjects.class, subjId);
                                                            
                                                            // Check for duplicates in combined list
                                                            boolean subjectExists = false;
                                                            if (subjEntity != null) {
                                                                for (Olevelresultsitems item : allExistingItems) {
                                                                    if (item.getSubject().equals(subjEntity.getName())) {
                                                                        subjectExists = true;
                                                                        System.out.println("DEBUG PARTIME: Subject already exists: " + subjEntity.getName());
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                            
                                                            if (!subjectExists) {
                                                                System.out.println("DEBUG PARTIME: Adding new subject: " + (subjEntity != null ? subjEntity.getName() : subjId));
                                                                Olevelgrades gradeEntity = (Olevelgrades) sess.getSingleObject(Olevelgrades.class, gradeId);
                                                                Olevelresultsitems item = new Olevelresultsitems();
                                                                item.setId(settings.generateId(result.getId(), 4) + "_" + System.nanoTime());
                                                                item.setOlevelResultsId(result);
                                                                item.setSubject(subjEntity != null ? subjEntity.getName() : subjId);
                                                                item.setGrade(gradeEntity);
                                                                System.out.println("DEBUG PARTIME: About to save subject item: " + item.getId());
                                                                sess.newEntry(item);
                                                                System.out.println("DEBUG PARTIME: Subject item saved successfully");
                                                                addedCount++;
                                                            } else {
                                                                skippedCount++;
                                                            }
                                                        } else {
                                                            System.out.println("DEBUG PARTIME: Skipping empty subject/grade at index " + i);
                                                        }
                                                    }
                                                    
                                                    // Build success message - recount to get accurate total
                                                    long newTotalCountByUser = sess.countOlevelSubjectsByUser(userId);
                                                    long newTotalCountByApp = sess.countOlevelSubjectsByUser(applicantId);
                                                    long newTotalCount = Math.max(newTotalCountByUser, newTotalCountByApp);
                                                    
                                                    System.out.println("DEBUG PARTIME: Final counts - added: " + addedCount + ", skipped: " + skippedCount + ", total: " + newTotalCount);
                                                    
                                                    olevelMessage = "<strong>Success!</strong> " + addedCount + " subject(s) added successfully.<br>";
                                                    olevelMessage += "<strong>Total O-level subjects:</strong> " + newTotalCount + "/9<br>";
                                                    
                                                    if (skippedCount > 0) {
                                                        olevelMessage += "<br><strong>Note:</strong> " + skippedCount + " duplicate subject(s) were skipped.";
                                                    }
                                                    
                                                    olevelMessageType = "success";
                                                    
                                                    // Refresh O-level data
                                                    olevelResults = sess.getOlevelresultsByUserId(user.getId());
                                                    olevelItems = sess.getOlevelresultsItemsByUserId(user.getId());
                                                    olevelCount = sess.countOlevelSubjectsByUser(user.getId());
                                                    System.out.println("DEBUG PARTIME: Refreshed O-level count: " + olevelCount);
                                                }
                                            }
                                        }
                                    } catch (Exception ex) {
                                        ex.printStackTrace();
                                        olevelMessage = "Error saving O-level results: " + ex.getMessage();
                                        olevelMessageType = "danger";
                                    }
                                } else {
                                    System.out.println("DEBUG PARTIME: O-level form NOT processed - missing parameters:");
                                    if (submitOlevel == null) System.out.println("  - submitOlevel is null");
                                    if (name == null) System.out.println("  - name is null");
                                    if (examDate == null) System.out.println("  - examDate is null");
                                    if (sitting == null) System.out.println("  - sitting is null");
                                    if (subjectIds == null) System.out.println("  - subjectIds is null");
                                    if (gradeIds == null) System.out.println("  - gradeIds is null");
                                }
                            %>

                            <%     
                                String training = request.getParameter("training");
                                String empstatus = request.getParameter("empstatus");
                                String fieldstudy = request.getParameter("fieldstudy");
                                String research = request.getParameter("research");
                                String guardianname = request.getParameter("guardianname");
                                String guardianadd = request.getParameter("guardianadd");
                                String sponsorphone = request.getParameter("sponsor_phone");
                                String quali = request.getParameter("quali");
                                String maritalstatus = request.getParameter("maritalstatus");
                                String button4b = request.getParameter("buttonPersonal");
                                
                                // Handle Personal Information form submission (Guardian & Personal details)
                                if (button4b != null && button4b.length() > 0) {
                                    System.out.println("DEBUG: Updating personal info for user: " + genapp.getId());
                                    
                                    try {
                                    // Update basic applicant information (guardian, qualification, marital status)
                        System.out.println("DEBUG: Updating applicant info for user: " + genapp.getId());
            if (true) {
                // 🚫 Don’t update — just show message
                out.println("<div class='alert alert-success'>Updating personal information...</div>");
            } else {
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
                                                    others = dd;
                                                } else {
                                                    others = new Applicantsothers(genapp.getId());
                                                    others.setApplicationType("POST GRADUATE");
                                                    others.setCurrentlyTraining(training);
                                                    others.setEmploymentStatus(empstatus);
                                                    others.setFieldOfStudy(fieldstudy);
                                                    others.setResearchExperience(research);
                                                    sess.newEntry(others);
                                                }
                                                genapp = sess.getApplicants(genapp.getId());
                                            } catch (Exception k) {
                                                System.out.println("Error updating Applicantsothers: " + k.getMessage());
                                            }
                                        }
                            }  // Added missing closing brace for else block
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%                                    } catch (Exception v) {
                                        System.out.println("ERROR: Exception in personal info processing: " + v.getMessage());
                                        v.printStackTrace();
                                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>Error saving personal details: " + v.getMessage() + "</div>");
                                    }
                                }
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
                                                    others = dd; // Update global others variable
                                                } else {
                                                    others = new Applicantsothers(genapp.getId());
                                                    others.setApplicationType("POST GRADUATE");
                                                    others.setCurrentlyTraining(training);
                                                    others.setEmploymentStatus(empstatus);
                                                    others.setFieldOfStudy(fieldstudy);
                                                    others.setResearchExperience(research);
                                                    sess.newEntry(others);
                                                }
                                            } catch (Exception k) {
                                                System.out.println("Error updating Applicantsothers: " + k.getMessage());
                                            }
                                        }
                                        
                                        // Note: Don't update application status to SUBMITTED here - only update when attestation is completed
                                        // sess.checkAndUpdateApplicationStatus(genapp.getId());
                                        
                                        // Refresh the genapp object to get updated data
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
                                boolean hasAllData = true;
                                List<String> missingItems = new ArrayList<>();
                                
                                // Check O-level Details (required for part-time applications)
                                if (olevelCount < 5) {
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
                                if (genapp.getGuardianName() == null || genapp.getGuardianName().trim().isEmpty() ||
                                    genapp.getGuardianAddress() == null || genapp.getGuardianAddress().trim().isEmpty()) {
                                    hasAllData = false;
                                    missingItems.add("Sponsor Information");
                                }
                                
                                // Check payment status
                                boolean hasPayment = false;
                                try {
                                    List<Payments> payments = sess.getPaymentsByRegno(genapp.getId());
                                    hasPayment = payments != null && payments.size() > 0;
                                } catch (Exception e) {
                                    hasPayment = false;
                                }
                                
                                if (!hasPayment) {
                                    missingItems.add("Application Fee Payment");
                                }
                                
                                // Determine status display with more specific messaging
                                String statusClass = "warning";
                                String statusMessage = "";
                                
                                if (hasAllData && hasPayment) {
                                    statusClass = "success";
                                    statusMessage = "Your application is complete and has been submitted successfully.";
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
                                        statusMessage = "Your application is in progress. Please complete remaining " + missingCount + " sections to proceed.";
                                    } else if (missingCount >= 3) {
                                        statusMessage = "Your application has been started. Please complete required sections below to proceed.";
                                    } else {
                                        statusMessage = "Your application is incomplete. Please complete all required sections below.";
                                    }
                                }
                            %>
                            
                            <div class="alert alert-<%=statusClass%> mb-4">
                                <h5><i class="fas fa-info-circle me-2"></i>Application Status: <strong><%=genapp.getStatus()%></strong></h5>
                                <p class="mb-0"><%=statusMessage%></p>
                                
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
                                // This allows users to complete missing sections even after submission
                                int i = 1;
                                if (i == 1) {
                            %>


                            <div class="accordion" id="accordionExample">
                                <!-- O-Level Results Section -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOlevel">
                                        <%
                                            String olevelStatus = "";
                                            String olevelIcon = "fas fa-exclamation-triangle text-warning";
                                            
                                            // Check O-level completion (minimum 5 subjects for part-time applications)
                                            boolean olevelComplete = olevelCount >= 5;
                                            
                                            if (olevelComplete) {
                                                olevelStatus = " ✓";
                                                olevelIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOlevel" aria-expanded="true" aria-controls="collapseOlevel">
                                            <i class="<%=olevelIcon%> me-2"></i>O-Level Results (<%=olevelCount%> subjects added)<%=olevelStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=sectionParam != null && sectionParam.equals("olevel") ? "show" : expandOlevel%>" id="collapseOlevel" aria-labelledby="headingOlevel" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            
                                            <% if (olevelMessage != null && !olevelMessage.isEmpty()) { %>
                                            <div class="alert alert-<%=olevelMessageType%> alert-dismissible fade show" role="alert">
                                                <%=olevelMessage%>
                                                <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                                            </div>
                                            <% } %>
                                            
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-graduation-cap me-2"></i>O-Level Results Entry</h6>
                                                <p class="mb-0">Please enter your O-Level examination results. You can add results from up to 2 sittings (First and Second sitting) with a maximum of 9 subjects total. Minimum 5 subjects required for part-time applications.</p>
                                            </div>
                                            
                                            <%
                                                // Get existing O-level results by BOTH userId AND applicationId
                                                List<Olevelresults> existingResultsByUser = sess.getOlevelresultsByUserId(user.getId());
                                                List<Olevelresults> existingResultsByApp = sess.getOlevelresultsByUserId(genapp.getId());
                                                
                                                // Combine and deduplicate
                                                List<Olevelresults> existingResults = new ArrayList<>();
                                                existingResults.addAll(existingResultsByUser);
                                                for (Olevelresults appResult : existingResultsByApp) {
                                                    boolean exists = false;
                                                    for (Olevelresults userResult : existingResultsByUser) {
                                                        if (appResult.getId().equals(userResult.getId())) {
                                                            exists = true;
                                                            break;
                                                        }
                                                    }
                                                    if (!exists) {
                                                        existingResults.add(appResult);
                                                    }
                                                }
                                                
                                                List<Olevelresultsitems> existingItemsByUser = sess.getOlevelresultsItemsByUserId(user.getId());
                                                List<Olevelresultsitems> existingItemsByApp = sess.getOlevelresultsItemsByUserId(genapp.getId());
                                                
                                                // Combine items
                                                List<Olevelresultsitems> existingItems = new ArrayList<>();
                                                existingItems.addAll(existingItemsByUser);
                                                for (Olevelresultsitems appItem : existingItemsByApp) {
                                                    boolean exists = false;
                                                    for (Olevelresultsitems userItem : existingItemsByUser) {
                                                        if (appItem.getId().equals(userItem.getId())) {
                                                            exists = true;
                                                            break;
                                                        }
                                                    }
                                                    if (!exists) {
                                                        existingItems.add(appItem);
                                                    }
                                                }
                                                
                                                long existingCountByUser = sess.countOlevelSubjectsByUser(user.getId());
                                                long existingCountByApp = sess.countOlevelSubjectsByUser(genapp.getId());
                                                long existingCount = Math.max(existingCountByUser, existingCountByApp);
                                                
                                                // Analyze existing sittings
                                                boolean hasFirstSitting = false;
                                                boolean hasSecondSitting = false;
                                                String availableSitting = "";
                                                
                                                for (Olevelresults result : existingResults) {
                                                    if ("First".equals(result.getSitting())) {
                                                        hasFirstSitting = true;
                                                    } else if ("Second".equals(result.getSitting())) {
                                                        hasSecondSitting = true;
                                                    }
                                                }
                                                
                                                // Determine available sitting options
                                                if (!hasFirstSitting && !hasSecondSitting) {
                                                    availableSitting = "both";
                                                } else if (hasFirstSitting && !hasSecondSitting) {
                                                    availableSitting = "first_or_second";
                                                } else if (!hasFirstSitting && hasSecondSitting) {
                                                    availableSitting = "second_or_first";
                                                } else {
                                                    availableSitting = "both_existing";
                                                }
                                                
                                                // Group existing items by sitting
                                                Map<String, List<Olevelresultsitems>> itemsBySitting = new HashMap<>();
                                                Map<String, Olevelresults> sittingData = new HashMap<>();
                                                for (Olevelresultsitems item : existingItems) {
                                                    String sittingKey = item.getOlevelResultsId().getSitting();
                                                    itemsBySitting.computeIfAbsent(sittingKey, k -> new ArrayList<>()).add(item);
                                                    sittingData.put(sittingKey, item.getOlevelResultsId());
                                                }
                                            %>
                                            
                                            <!-- Display existing O-level results -->
                                            <% if (!existingResults.isEmpty()) { %>
                                            <div class="existing-subjects" style="background-color: #f8f9fa; border-left: 4px solid #28a745; padding: 15px; margin-bottom: 20px; border-radius: 0.375rem;">
                                                <h5><i class="fas fa-check-circle text-success"></i> Your Existing O-Level Results (<%=existingCount%>/9 subjects)</h5>
                                                <% for (String sittingKey : itemsBySitting.keySet()) { %>
                                                <h6 class="mt-3">
                                                    <strong><%=sittingKey%> Sitting:</strong> 
                                                    <span class="badge bg-info"><%=itemsBySitting.get(sittingKey).size()%> subjects</span>
                                                </h6>
                                                <div class="row">
                                                    <% for (Olevelresultsitems item : itemsBySitting.get(sittingKey)) { %>
                                                    <div class="col-md-3 mb-2">
                                                        <span class="badge bg-success subject-badge" style="margin: 2px; font-size: 0.9em; padding: 0.5em 0.75em;">
                                                            <%=item.getSubject()%>: <%=item.getGrade().getId()%>
                                                        </span>
                                                    </div>
                                                    <% } %>
                                                </div>
                                                <% } %>
                                            </div>
                                            <% } %>
                                            
                                            <% if (existingCount < 9 && !"none".equals(availableSitting)) { %>
                                            <div class="alert alert-warning">
                                                <strong>Sitting Rules:</strong>
                                                <ul class="mb-0 mt-2">
                                                    <li>Maximum 9 subjects total across both sittings</li>
                                                    <li>Maximum 2 sittings allowed (First and Second)</li>
                                                    <li>You can add <%=(9 - existingCount)%> more subject(s)</li>
                                                    <% if (hasFirstSitting && hasSecondSitting) { %>
                                                    <li class="text-success">Both sittings exist - you can add subjects to either sitting until 9 total</li>
                                                    <% } else if (hasFirstSitting) { %>
                                                    <li>You can add subjects to your existing First Sitting or start a Second Sitting</li>
                                                    <% } else if (hasSecondSitting) { %>
                                                    <li>You can add subjects to your existing Second Sitting or start a First Sitting</li>
                                                    <% } else { %>
                                                    <li>You can start with either First or Second Sitting</li>
                                                    <% } %>
                                                </ul>
                                            </div>
                                            
                                            <div class="dynamic-form-container" style="border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 20px; background-color: #ffffff;">
                                                <form method="post" action="">
                                                    <!-- Hidden sitting data for auto-fill -->
                                                    <% for (Map.Entry<String, Olevelresults> entry : sittingData.entrySet()) {
                                                        Olevelresults sittingResult = entry.getValue();
                                                    %>
                                                    <input type="hidden" id="sitting_<%=entry.getKey()%>_name" value="<%=sittingResult.getName()%>" />
                                                    <input type="hidden" id="sitting_<%=entry.getKey()%>_resultType" value="<%=sittingResult.getResultType()%>" />
                                                    <input type="hidden" id="sitting_<%=entry.getKey()%>_regNo" value="<%=sittingResult.getRegistrationNo() != null ? sittingResult.getRegistrationNo() : ""%>" />
                                                    <input type="hidden" id="sitting_<%=entry.getKey()%>_examDate" value="<%=sittingResult.getExamDate()%>" />
                                                    <% } %>
                                                    
                                                    <!-- Hidden fields for form submission -->
                                                    <input type="hidden" id="hiddenName" name="hiddenName" />
                                                    <input type="hidden" id="hiddenResultType" name="hiddenResultType" />
                                                    <input type="hidden" id="hiddenRegistrationNo" name="hiddenRegistrationNo" />
                                                    <input type="hidden" id="hiddenExamDate" name="hiddenExamDate" />
                                                    <input type="hidden" id="isExistingSitting" name="isExistingSitting" value="false" />
                                                    
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Name</span>
                                                        <input type="text" class="form-control" id="name" name="name" required />
                                                        <small class="form-text auto-fill-help" id="nameHelp" style="display:none; color: #28a745; font-size: 0.875em; margin-top: 0.25rem;">
                                                            <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                                        </small>
                                                    </div>
                                                    
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Result Type</span>
                                                        <select id="resultType" name="resultType" class="form-select" required>
                                                            <option value="">-- Select Result Type --</option>
                                                            <option value="waec">WAEC</option>
                                                            <option value="neco">NECO</option>
                                                            <option value="nabteb">NABTEB</option>
                                                            <option value="gce">GCE</option>
                                                        </select>
                                                        <small class="form-text auto-fill-help" id="resultTypeHelp" style="display:none; color: #28a745; font-size: 0.875em; margin-top: 0.25rem;">
                                                            <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                                        </small>
                                                    </div>
                                                    
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Registration No</span>
                                                        <input type="text" class="form-control" id="registrationNo" name="registrationNo" />
                                                        <small class="form-text auto-fill-help" id="regNoHelp" style="display:none; color: #28a745; font-size: 0.875em; margin-top: 0.25rem;">
                                                            <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                                        </small>
                                                    </div>
                                                    
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Exam Date</span>
                                                        <input type="date" class="form-control" id="examDate" name="examDate" required />
                                                        <small class="form-text auto-fill-help" id="examDateHelp" style="display:none; color: #28a745; font-size: 0.875em; margin-top: 0.25rem;">
                                                            <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                                        </small>
                                                    </div>
                                                    
                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Sitting</span>
                                                        <select id="sitting" name="sitting" class="form-select" required>
                                                            <% if ("both".equals(availableSitting)) { %>
                                                            <option value="">-- Select Sitting --</option>
                                                            <option value="First">First Sitting</option>
                                                            <option value="Second">Second Sitting</option>
                                                            <% } else if ("first_or_second".equals(availableSitting)) { %>
                                                            <option value="">-- Select Sitting --</option>
                                                            <option value="First">Add to First Sitting (existing)</option>
                                                            <option value="Second">Start Second Sitting</option>
                                                            <% } else if ("second_or_first".equals(availableSitting)) { %>
                                                            <option value="">-- Select Sitting --</option>
                                                            <option value="Second">Add to Second Sitting (existing)</option>
                                                            <option value="First">Start First Sitting</option>
                                                            <% } else if ("both_existing".equals(availableSitting)) { %>
                                                            <option value="">-- Select Sitting --</option>
                                                            <option value="First">Add to First Sitting (existing)</option>
                                                            <option value="Second">Add to Second Sitting (existing)</option>
                                                            <% } %>
                                                        </select>
                                                    </div>
                                                    
                                                    <h4>Add Subjects & Grades</h4>
                                                    <div class="alert alert-info">
                                                        <small><i class="fas fa-info-circle"></i> You can add one or more subjects at a time. Click "Add Subject" to add more rows.</small>
                                                        <% if (!existingItems.isEmpty()) { %>
                                                        <br><small><i class="fas fa-exclamation-triangle"></i> <strong>Note:</strong> You already have <%=existingCount%> subject(s) recorded. Duplicate subjects will be automatically skipped.</small>
                                                        <% } %>
                                                    </div>
                                                    
                                                    <table id="subjectTable" class="table">
                                                        <thead>
                                                            <tr>
                                                                <th>Subject</th>
                                                                <th>Grade</th>
                                                                <th>Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="subjectTableBody">
                                                            <tr>
                                                                <td>
                                                                    <select name="subject[]" class="form-select" required>
                                                                        <option value="">-- Select Subject --</option>
                                                                        <% for (Olevelsubjects subj : olevelSubjectsList) { %>
                                                                        <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                                                                        <% } %>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <select name="grade[]" class="form-select" required>
                                                                        <option value="">-- Select Grade --</option>
                                                                        <% for (Olevelgrades g : olevelGradesList) { %>
                                                                        <option value="<%=g.getId()%>"><%=g.getId()%></option>
                                                                        <% } %>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-danger btn-sm" onclick="removeSubjectRow(this)" disabled>Remove</button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    
                                                    <button type="button" id="addSubjectBtn" class="btn btn-secondary mb-3" onclick="addSubjectRow()" style="background-color: #6c757d; border-color: #6c757d;">
                                                        <i class="fas fa-plus"></i> Add Subject
                                                    </button>
                                                    <br/>
                                                    
                                                    <button type="submit" name="submitOlevel" class="btn btn-primary px-4">
                                                        <i class="fas fa-save me-2"></i>Submit O-Level Results
                                                    </button>
                                                </form>
                                            </div>
                                            
                                            <% } else { %>
                                            <div class="alert alert-success">
                                                <h5><i class="fas fa-check-circle"></i> O-Level Requirements Complete</h5>
                                                <% if (existingCount >= 9) { %>
                                                <p>You have submitted the maximum 9 O-level subjects.</p>
                                                <% } %>
                                                <% if (hasFirstSitting && hasSecondSitting) { %>
                                                <p>Both First and Second sittings are complete.</p>
                                                <% } %>
                                                <p class="mb-0">If you need to make changes, please contact support desk.</p>
                                            </div>
                                            <% } %>
                                            
                                            <div id="olevelScripts" data-remaining="<%=(9 - (int) existingCount)%>"></div>
                                            
                                        </div>
                                    </div>
                                </div>

                                <!-- Guardian & Personal Information Section (goes to applicants.java) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingPersonal">
                                        <%
                                            String personalStatus = "";
                                            String personalIcon = "fas fa-exclamation-triangle text-warning";
                                            
                                            // Check Guardian information completion
                                            boolean guardianComplete = genapp.getGuardianName() != null && !genapp.getGuardianName().trim().isEmpty() &&
                                                genapp.getGuardianAddress() != null && !genapp.getGuardianAddress().trim().isEmpty();
                                            
                                            // Check personal information completion
                                            boolean personalComplete = genapp.getQualification() != null && !genapp.getQualification().trim().isEmpty() &&
                                                genapp.getMaritalStatus() != null && !genapp.getMaritalStatus().trim().isEmpty();
                                            
                                            // Section is complete only if BOTH guardian and personal info are complete
                                            if (guardianComplete && personalComplete) {
                                                personalStatus = " ✓";
                                                personalIcon = "fas fa-check-circle text-success";
                                            } else if (guardianComplete || personalComplete) {
                                                personalStatus = " ⚠️";
                                                personalIcon = "fas fa-exclamation-circle text-warning";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapsePersonal" aria-expanded="false" aria-controls="collapsePersonal">
                                            <i class="<%=personalIcon%> me-2"></i>Sponsor & Personal Information<%=personalStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=sectionParam != null && (sectionParam.equals("personal") || sectionParam.equals("guardian")) ? "show" : ""%>" id="collapsePersonal" aria-labelledby="headingPersonal" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-info-circle me-2"></i>Sponsor & Personal Information</h6>
                                                <p class="mb-0">Please provide your Sponsor information and personal details. This information is stored in your applicant profile and can be updated at any time.</p>
                                            </div>
                                            
                                            <form action="" method="POST" role="form" name="personalForm">
                                                
                                                <!-- Guardian Information Section -->
                                                <h6 class="mb-3"><i class="fas fa-user-friends me-2"></i>Sponsor Information</h6>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Sponsor Name
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=genapp.getGuardianName() != null ? genapp.getGuardianName() : ""%>" minlength="2" required name="guardianname" placeholder="Enter guardian's full name">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Sponsor phone    
                                                    </span>
                                                    <textarea class="form-control"  rows="2" minlength="2" required placeholder="Enter phone">
                                                        <%=genapp.getPhoneNo() != null ? genapp.getPhoneNo() : ""%>
                                                    </textarea>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Sponsor Address    
                                                    </span>
                                                    <textarea class="form-control" name="guardianadd" rows="2" minlength="2" required placeholder="Enter guardian's address"><%=genapp.getGuardianAddress() != null ? genapp.getGuardianAddress() : ""%></textarea>
                                                </div>
                                                
                                                <!-- Personal Information Section -->
                                                <hr class="my-4">
                                                <h6 class="mb-3"><i class="fas fa-user me-2"></i>Personal Information</h6>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Qualification
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=genapp.getQualification() != null ? genapp.getQualification() : ""%>" required name="quali" placeholder="Enter your highest qualification">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Marital Status
                                                    </span>
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
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Currently Training
                                                    </span>
                                                    <select class="form-select" name="training">
                                                        <option value="">Select Training Status</option>
                                                        <option value="YES" <%=others != null && others.getCurrentlyTraining() != null && others.getCurrentlyTraining().equals("YES") ? "selected" : ""%>>Yes</option>
                                                        <option value="NO" <%=others != null && others.getCurrentlyTraining() != null && others.getCurrentlyTraining().equals("NO") ? "selected" : ""%>>No</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Employment Status
                                                    </span>
                                                    <select class="form-select" name="empstatus">
                                                        <option value="">Select Employment Status</option>
                                                        <option value="EMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("EMPLOYED") ? "selected" : ""%>>Employed</option>
                                                        <option value="UNEMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("UNEMPLOYED") ? "selected" : ""%>>Unemployed</option>
                                                        <option value="SELF_EMPLOYED" <%=others != null && others.getEmploymentStatus() != null && others.getEmploymentStatus().equals("SELF_EMPLOYED") ? "selected" : ""%>>Self Employed</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Field of Study
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=others != null && others.getFieldOfStudy() != null ? others.getFieldOfStudy() : ""%>" name="fieldstudy" placeholder="Enter your field of study">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Research Experience
                                                    </span>
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

                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="buttonPersonal" class="btn btn-success px-4" value="Save Sponsor & Personal Information"/>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                               
                                                </div>
                                                
                                                <%
                                                    // Add POST GRADUATE specific fields if applicable
                                                    if (genapp.getApplicationType() != null && genapp.getApplicationType().equalsIgnoreCase("POST GRADUATE")) {
                                                %>
                                                <hr class="my-4">
                                                <h6 class="mb-3"><i class="fas fa-graduation-cap me-2"></i>Additional Information (Post Graduate)</h6>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Currently Training
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=others != null && others.getCurrentlyTraining() != null ? others.getCurrentlyTraining() : ""%>" name="training" placeholder="Enter Current Training">
                                                </div>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Employment Status
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=others != null && others.getEmploymentStatus() != null ? others.getEmploymentStatus() : ""%>" name="empstatus" placeholder="Enter Employment Status">
                                                </div>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Field of Study
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=others != null && others.getFieldOfStudy() != null ? others.getFieldOfStudy() : ""%>" name="fieldstudy" placeholder="Enter Field of Study">
                                                </div>
                                                
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Research Experience
                                                    </span>
                                                    <textarea class="form-control" name="research" rows="3" placeholder="Describe your research experience"><%=others != null && others.getResearchExperience() != null ? others.getResearchExperience() : ""%></textarea>
                                                </div>
                                                <%
                                                    } else {
                                                %>
                                                <!-- Hidden fields for non-PG applications -->
                                                <input type="hidden" name="training" value="">
                                                <input type="hidden" name="empstatus" value="">
                                                <input type="hidden" name="fieldstudy" value="">
                                                <input type="hidden" name="research" value="">
                                                <%
                                                    }
                                                %>
                                                
                                                <div class="d-grid gap-2 mt-4">
                                                    <input type="submit" name="buttonPersonal" class="btn btn-success px-4" value="Save Sponsor & Personal Information"/>
                                                </div>
                                            </div>
                                        </div>
                                    </form>

                                        </div>
                                    </div>
                                
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSix">
                                        <%
                                            String instStatus = "";
                                            String instIcon = "fas fa-exclamation-triangle text-warning";
                                            if (lschatt != null && !lschatt.isEmpty()) {
                                                instStatus = " ✓";
                                                instIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseSix" aria-expanded="false" aria-controls="collapseSix">
                                            <i class="<%=instIcon%> me-2"></i>Institutions Attended (<%=lschatt.size()%> added)<%=instStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandInstitutions%>" id="collapseSix" aria-labelledby="headingSix" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (lschatt == null || lschatt.isEmpty()) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-exclamation-triangle me-2"></i>No Institutions Added Yet</h6>
                                                <p class="mb-0">Please add at least one institution you have attended. This is required to complete your application.</p>
                                                <small class="text-muted">
                                                    <strong>Tip:</strong> Include all secondary schools, colleges, or universities you have attended.
                                                </small>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <div class="alert alert-success mb-3">
                                                <h6><i class="fas fa-check-circle me-2"></i>Institutions Added</h6>
                                                <p class="mb-0">You have added <%=lschatt.size()%> institution(s). You can add more if needed.</p>
                                            </div>
                                            <%
                                                }
                                            %>

                                            <form action='' method='post' name="institutions">
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Name of Institution    
                                                    </span>
                                                    <input class="form-control" type="text"  name="instname" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Start date    
                                                    </span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="inststartdate" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        End Date    
                                                    </span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="instenddate">
                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Year Graduated   
                                                    </span>
                                                    <input class="form-control" type="number" max="<%=settings.getTodaysdate().split("-")[0]%>"  name="instcertyear">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Results   
                                                    </span>
                                                    <input class="form-control" type="text"  name="instresults">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Registration Number   
                                                    </span>
                                                    <input class="form-control" type="text"  name="instregno">
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

                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <%
                                            String docsStatus = "";
                                            String docsIcon = "fas fa-exclamation-triangle text-warning";
                                            if (ldocs != null && !ldocs.isEmpty()) {
                                                docsStatus = " ✓";
                                                docsIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                            <i class="<%=docsIcon%> me-2"></i>Supporting Documents (<%=ldocs.size()%> added)<%=docsStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandDocuments%>" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <form action='' method='post' name="uploaddocs" enctype="multipart/form-data">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                        <div class="mb-3 row">
                                                            <label class="col-sm-3 col-form-label" for="payerno">Document Name</label>
                                                            <div class="col-sm-4">
                                                                <input class="form-control" name="docname" type="text" required="">
                                                            </div>
                                                            <div class="col-sm-3">
                                                                <input class="form-control" type="file"  accept=".pdf, .png, .jpg" name="file2" required="">
                                                            </div>
                                                            <div class="col-sm-2">

                                                                <button name="submit4d" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                            </div></div>
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

                                        </div>
                                    </div>
                                </div>


                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingFive">
                                        <%
                                            String submitStatus = "";
                                            String submitIcon = "fas fa-exclamation-triangle text-warning";
                                            boolean canSubmit = hasAllData && hasPayment;
                                            if (canSubmit) {
                                                submitStatus = " ✓";
                                                submitIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseFive" aria-expanded="true" aria-controls="collapseThree">
                                            <i class="<%=submitIcon%> me-2"></i>Confirm and Submit<%=submitStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandSubmit%>" id="collapseFive" aria-labelledby="headingFive" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (!canSubmit) {
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
                                                } else {
                                            %>
                                            <div class="alert alert-success mb-3">
                                                <h6><i class="fas fa-check-circle me-2"></i>Ready to Submit</h6>
                                                <p class="mb-0">All required sections have been completed. You can now submit your application.</p>
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
                                                if (canSubmit) {
                                            %>
                                            <form action='' method='post' name="attestation">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                        <div class="mb-3 row">
                                                            <div class="col-sm-1">
                                                                <input class="form-check-input" name="attestationbox" type="checkbox"  required="">
                                                            </div>
                                                            <label class="col-sm-9 form-check-label" for="attestationbox"><strong>Declaration:</strong> I <%=std.getSurname() + " " + std.getOthernames()%>, hereby declare that the information stated above is to the best of my knowledge and belief, accurate in every detail.</label>

                                                            <div class="col-sm-2">

                                                                <button name="submit6"  value="Submit" class="btn btn-primary mb-3" type="submit">Submit Application</button>                       
                                                            </div></div>
                                                    </div>
                                                </div>
                                            </form>
                                            <%
                                                } else {
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
                   


                            <%
                            } else {
                                String payid = "10004";

                                List<Feessetup> feessetup = new ArrayList();
                                try {
                                    String ind = "None";
                                    String sch = "None";
                                    String prog = "None";
                                    String fac = "None";
                                    String dept = "None";
                                    String course = "None";
                                    String level = "None";
                                    String campus = "None";

                                    String regno = "";
                                    String fullname = "";
                                    String coursename = "";
                                    Date dfrom = settings.getCurrentDateTime();
                                    try {

                                        regno = std.getId();
                                        fullname = std.getSurname() + " " + std.getOthernames();
                                        coursename = genapp.getCourse1().getName();

                                        sch = genapp.getCourse1().getSchoolProgrammeId().getSchoolId().getId();
                                        prog = genapp.getCourse1().getSchoolProgrammeId().getProgrammeId().getId() + "";
                                        fac = genapp.getCourse1().getDepartmentId().getFacultyId().getId();
                                        dept = genapp.getCourse1().getDepartmentId().getId();
                                        course = genapp.getCourse1().getId();
                                        feessetup = sess.getFeessetup(payid, genapp.getSession(), "Session", sch, prog, fac, dept,
                                                course, level, ind, campus, dfrom, std.getId());
                                        if (feessetup.size() > 0) {
                                            String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                                            boolean exist = false;
                                            if (fgx.equalsIgnoreCase("No")) {
                                                List<Payments> payl2 = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), payid, genapp.getSession(), "Session");
                                                if (payl2.size() > 0) {
                                                    exist = true;
                                                }

                                            }
                                            if (exist) {

                                            } else {
                                                String email = genapp.getEmailAddress();
                                                double total = feessetup.stream()
                                                        .mapToDouble(Feessetup::getAmount)
                                                        .sum();
                                                session.setAttribute("FEESSETUP", feessetup);
                                                session.setAttribute("level", level);
                                                session.setAttribute("sessions", genapp.getSession());
                                                session.setAttribute("feesgroup", payid);
                                                session.setAttribute("sesssem", "Session");
                                                session.setAttribute("regno", regno);
                                                session.setAttribute("fullname", fullname);
                                                session.setAttribute("coursename", coursename);
                                                session.setAttribute("phoneno", genapp.getPhoneNo());
                                                session.setAttribute("email", email);
                                                session.setAttribute("id", std.getId());

                                                Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                                                Schools schoolId = genapp.getCourse1().getSchoolProgrammeId().getSchoolId();
                                                Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                                        total, std.getId(), settings.getCurrentDateTime(), "PENDING", null, genapp.getSession(), "Session", "", "", "", "", fullname,
                                                        genapp.getPhoneNo(), email, "", feesGroupId, schoolId);
                                                pr.setPayerRegistrationIo(regno);
                                                pr.setCourseId(genapp.getCourse1().getId());
                                                pr.setLevel(level);
                                                sess.newEntry(pr);
                                                try {
                                                    session.setAttribute("pr", pr);

                                                } catch (Exception k) {
                                                }
                                                String returnurl = "/application_pg1";
                                                returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                try {
                                                    session.setAttribute("return", returnurl);
                                                } catch (Exception k) {
                                                }
                            %>
                            <a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-lg" style="margin-bottom: 10px">Pay PG Application and Continue</a>
                            <%
                                                        //response.sendRedirect("/invoice?return=" + returnurl);
                                                    }

                                                }
                                            } catch (Exception a) {
                                            }
                                        } catch (Exception k) {
                                        }
                                    }
                                }
                                if (genapp.getStatus().equalsIgnoreCase("SUBMITTED") || 
                                    genapp.getStatus().equalsIgnoreCase("COMPLETED")) {
                            %>
                            <div class="alert alert-success mb-4">
                                <h6><i class="fas fa-check-circle me-2"></i>Application Submitted Successfully</h6>
                                <p class="mb-2">Your application has been received. You will be notified via email and on this platform for next action.</p>
                                <p class="mb-0">
                                    <strong>Note:</strong> You can still update your information below if needed, or download your application form.
                                </p>
                                <div class="mt-2">
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-primary btn-sm">
                                        <i class="fas fa-download me-1"></i>Download Application Form
                                    </a>
                                </div>
                            </div>
                            <%
                                }
                                if (genapp.getStatus().equalsIgnoreCase("ADMITTED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your application has been processed successfully, Kindly download your admission letter from the list of documents, follow the instruction of it to complete your admission process</p>
                                <p>Download Documents:
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-warning btn-sm float-end">Application Form</a> 
                                    <%
                                        try {
                                            List<Uploadeddocuments> uploads = sess.getUploadeddocumentsByRegno(genapp.getId());
                                            for (Uploadeddocuments data : uploads) {
                                                String urld = settings.docUrl + "/" + data.getUrl();
                                    %>
                                    <a href="<%=urld%>" target="_blank" class="btn btn-primary btn-sm float-end"><%=data.getName()%></a> 
                                    <%
                                            }
                                        } catch (Exception n) {
                                        }
                                    %>
                                </p>
                            </div>
                            <%
                                }
                            %>
                     
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
            // O-level dynamic form functionality
            document.addEventListener('DOMContentLoaded', function() {
                const scriptsDiv = document.getElementById('olevelScripts');
                if (!scriptsDiv) return;
                
                const maxSubjects = parseInt(scriptsDiv.getAttribute('data-remaining'));
                let currentRows = 1;
                
                // Auto-fill functionality for existing sittings
                const sittingSelect = document.getElementById('sitting');
                const nameField = document.getElementById('name');
                const resultTypeField = document.getElementById('resultType');
                const regNoField = document.getElementById('registrationNo');
                const examDateField = document.getElementById('examDate');
                
                // Hidden fields
                const hiddenName = document.getElementById('hiddenName');
                const hiddenResultType = document.getElementById('hiddenResultType');
                const hiddenRegistrationNo = document.getElementById('hiddenRegistrationNo');
                const hiddenExamDate = document.getElementById('hiddenExamDate');
                const isExistingSitting = document.getElementById('isExistingSitting');
                
                // Helper elements
                const nameHelp = document.getElementById('nameHelp');
                const resultTypeHelp = document.getElementById('resultTypeHelp');
                const regNoHelp = document.getElementById('regNoHelp');
                const examDateHelp = document.getElementById('examDateHelp');
                
                if (sittingSelect) {
                    sittingSelect.addEventListener('change', function() {
                        const selectedSitting = this.value;
                        const selectedOption = this.options[this.selectedIndex];
                        const isExisting = selectedOption && selectedOption.text.includes('(existing)');
                        
                        if (isExisting && selectedSitting) {
                            // Get data from hidden fields
                            const nameData = document.getElementById('sitting_' + selectedSitting + '_name');
                            const resultTypeData = document.getElementById('sitting_' + selectedSitting + '_resultType');
                            const regNoData = document.getElementById('sitting_' + selectedSitting + '_regNo');
                            const examDateData = document.getElementById('sitting_' + selectedSitting + '_examDate');
                            
                            if (nameData && resultTypeData && examDateData) {
                                // Auto-fill visible fields
                                nameField.value = nameData.value;
                                nameField.readOnly = true;
                                nameField.classList.add('auto-filled');
                                
                                resultTypeField.value = resultTypeData.value;
                                resultTypeField.disabled = true;
                                resultTypeField.classList.add('auto-filled');
                                
                                if (regNoData && regNoData.value) {
                                    regNoField.value = regNoData.value;
                                    regNoField.readOnly = true;
                                    regNoField.classList.add('auto-filled');
                                }
                                
                                examDateField.value = examDateData.value;
                                examDateField.readOnly = true;
                                examDateField.classList.add('auto-filled');
                                
                                // Populate hidden fields
                                hiddenName.value = nameData.value;
                                hiddenResultType.value = resultTypeData.value;
                                hiddenRegistrationNo.value = regNoData ? regNoData.value : '';
                                hiddenExamDate.value = examDateData.value;
                                isExistingSitting.value = 'true';
                                
                                // Show help text
                                if (nameHelp) nameHelp.style.display = 'block';
                                if (resultTypeHelp) resultTypeHelp.style.display = 'block';
                                if (regNoHelp && regNoData && regNoData.value) regNoHelp.style.display = 'block';
                                if (examDateHelp) examDateHelp.style.display = 'block';
                            }
                        } else {
                            // Clear and enable fields for new sitting
                            nameField.value = '';
                            nameField.readOnly = false;
                            nameField.classList.remove('auto-filled');
                            
                            resultTypeField.value = '';
                            resultTypeField.disabled = false;
                            resultTypeField.classList.remove('auto-filled');
                            
                            regNoField.value = '';
                            regNoField.readOnly = false;
                            regNoField.classList.remove('auto-filled');
                            
                            examDateField.value = '';
                            examDateField.readOnly = false;
                            examDateField.classList.remove('auto-filled');
                            
                            // Clear hidden fields
                            hiddenName.value = '';
                            hiddenResultType.value = '';
                            hiddenRegistrationNo.value = '';
                            hiddenExamDate.value = '';
                            isExistingSitting.value = 'false';
                            
                            // Hide help text
                            if (nameHelp) nameHelp.style.display = 'none';
                            if (resultTypeHelp) resultTypeHelp.style.display = 'none';
                            if (regNoHelp) regNoHelp.style.display = 'none';
                            if (examDateHelp) examDateHelp.style.display = 'none';
                        }
                    });
                }
                
                window.addSubjectRow = function() {
                    if (currentRows >= maxSubjects) {
                        alert('You can only add ' + maxSubjects + ' more subject(s).');
                        return;
                    }
                    
                    const tbody = document.getElementById('subjectTableBody');
                    const newRow = tbody.rows[0].cloneNode(true);
                    newRow.querySelectorAll('select').forEach(select => select.selectedIndex = 0);
                    
                    const removeBtn = newRow.querySelector('button');
                    removeBtn.disabled = false;
                    
                    tbody.appendChild(newRow);
                    currentRows++;
                    
                    if (currentRows >= maxSubjects) {
                        document.getElementById('addSubjectBtn').disabled = true;
                    }
                    
                    updateRemoveButtons();
                };
                
                window.removeSubjectRow = function(button) {
                    const tbody = document.getElementById('subjectTableBody');
                    if (tbody.rows.length > 1) {
                        button.closest('tr').remove();
                        currentRows--;
                        document.getElementById('addSubjectBtn').disabled = false;
                        updateRemoveButtons();
                    }
                };
                
                function updateRemoveButtons() {
                    const tbody = document.getElementById('subjectTableBody');
                    const removeButtons = tbody.querySelectorAll('button');
                    removeButtons.forEach((btn) => {
                        btn.disabled = tbody.rows.length === 1;
                    });
                }
                
                // Form validation
                const form = document.querySelector('form[method="post"]');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const subjectSelects = document.querySelectorAll('select[name="subject[]"]');
                        const selectedSubjects = [];
                        let hasDuplicates = false;
                        
                        subjectSelects.forEach(select => {
                            if (select.value && selectedSubjects.includes(select.value)) {
                                hasDuplicates = true;
                            } else if (select.value) {
                                selectedSubjects.push(select.value);
                            }
                        });
                        
                        if (hasDuplicates) {
                            e.preventDefault();
                            alert('Please ensure no duplicate subjects are selected.');
                            return false;
                        }
                        
                        // Show loading message
                        const submitBtn = form.querySelector('button[name="submitOlevel"]');
                        if (submitBtn) {
                            // Add hidden field to ensure submitOlevel parameter is sent even when button is disabled
                            const hiddenSubmit = document.createElement('input');
                            hiddenSubmit.type = 'hidden';
                            hiddenSubmit.name = 'submitOlevel';
                            hiddenSubmit.value = 'true';
                            form.appendChild(hiddenSubmit);
                            
                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
                            submitBtn.disabled = true;
                        }
                    });
                }
            });
        </script>

    </body>
</html>