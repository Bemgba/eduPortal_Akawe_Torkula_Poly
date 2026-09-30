<%--
    Document   : template
    Created on : 6 Oct 2025, 15:48:36
    Author     : BEMGBA
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
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
        response.sendRedirect("/remedialApplication");
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

<%
    // Handle section parameter to determine which accordion to expand
    String sectionParam = request.getParameter("section");
    String expandDetails = "show";  // Default: expand Additional Details section
    String expandDocuments = "";
    String expandSubmit = "show";  // Default: expand submit section
    
    if (sectionParam != null) {
        // Reset defaults
        expandDetails = "";
        expandSubmit = "";
        
        // Expand specific section based on parameter
        if (sectionParam.equals("personal") || sectionParam.equals("guardian") || sectionParam.equals("utme") || sectionParam.equals("details")) {
            expandDetails = "show";
        } else if (sectionParam.equals("documents")) {
            expandDocuments = "show";
        } else {
            // Default behavior
            expandDetails = "show";
            expandSubmit = "show";
        }
    }
%>

<%     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    List<Schoolsattended> lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
    List<Applicantsreferees> lref = sess.getApplicantsrefereesByRegno(genapp.getId());
    List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - IJMBE Application</title>

        <style>
            .existing-subjects {
                background-color: #f8f9fa;
                border-left: 4px solid #28a745;
                padding: 15px;
                margin-bottom: 20px;
            }

            .subject-badge {
                margin: 2px;
                font-size: 0.9em;
            }

            .dynamic-form-container {
                border: 1px solid #dee2e6;
                border-radius: 0.375rem;
                padding: 20px;
                background-color: #ffffff;
            }

            .subject-row {
                background-color: #f8f9fa;
                margin-bottom: 10px;
                padding: 10px;
                border-radius: 0.25rem;
            }

            #addSubjectBtn {
                background-color: #6c757d;
                border-color: #6c757d;
            }

            #addSubjectBtn:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }

            .auto-filled {
                background-color: #f8f9fa !important;
                border-left: 3px solid #28a745;
            }

            .auto-fill-help {
                color: #28a745;
                font-size: 0.875em;
                margin-top: 0.25rem;
            }
        </style>


    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">IJMBE Application</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <%                        System.out.println("DEBUG: In remedial_form.jsp - std object: " + (std != null ? "Available" : "Null"));
                        if (std != null) {
                            System.out.println("DEBUG: std.getId(): " + std.getId());
                            System.out.println("DEBUG: std.getSurname(): " + std.getSurname());
                        }
                    %>

                    <%     if (std != null) {

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

                            <%
                                if (std != null) {
                            %>

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
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }

                                        lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
                                    } catch (Exception ks) {
                                    }
                                }
                            %>




                            <%  String docname = null;
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

                            <%                                if ("POST".equalsIgnoreCase(request.getMethod())) {
                                    try {
                                        // Check if this is an existing sitting submission
                                        String isExistingSittingParam = request.getParameter("isExistingSitting");
                                        boolean isExistingSitting = "true".equals(isExistingSittingParam);

                                        String name, regnou, examDate, resultType;

                                        if (isExistingSitting) {
                                            // Use hidden field values for existing sitting
                                            name = request.getParameter("hiddenName");
                                            regnou = request.getParameter("hiddenRegistrationNo");
                                            examDate = request.getParameter("hiddenExamDate");
                                            resultType = request.getParameter("hiddenResultType");
                                        } else {
                                            // Use regular field values for new sitting
                                            name = request.getParameter("name");
                                            regnou = request.getParameter("registrationNo");
                                            examDate = request.getParameter("examDate");
                                            resultType = request.getParameter("resultType");
                                        }

                                        String sitting = request.getParameter("sitting");
                                        String[] subjectIds = request.getParameterValues("subject[]");
                                        String[] gradeIds = request.getParameterValues("grade[]");

                                        if (name != null && resultType != null && examDate != null && sitting != null
                                                && subjectIds != null && gradeIds != null) {

                                            // CRITICAL CHECK: Get existing O-level results by USER ID to prevent duplicates
                                            List<Olevelresults> existingResultsByUserId = sess.getOlevelresultsByUserId(user.getId());
                                            long existingCountByUserId = sess.countOlevelSubjectsByUser(user.getId());
                                            
                                            // Also get by application ID (for backward compatibility)
                                            List<Olevelresults> existingResults = sess.getOlevelresultsByUserId(genapp.getId());
                                            long existingCount = sess.countOlevelSubjectsByUser(genapp.getId());
                                            
                                            // Use the higher count and combined results
                                            long totalExistingCount = Math.max(existingCountByUserId, existingCount);
                                            
                                            // Combine results and deduplicate
                                            List<Olevelresults> allExistingResults = new ArrayList<>();
                                            allExistingResults.addAll(existingResultsByUserId);
                                            for (Olevelresults appResult : existingResults) {
                                                boolean exists = false;
                                                for (Olevelresults userResult : existingResultsByUserId) {
                                                    if (appResult.getId().equals(userResult.getId())) {
                                                        exists = true;
                                                        break;
                                                    }
                                                }
                                                if (!exists) {
                                                    allExistingResults.add(appResult);
                                                }
                                            }
                                            
                                            System.out.println("DEBUG remedial_form: userId=" + user.getId() + ", appId=" + genapp.getId());
                                            System.out.println("  - Count by userId: " + existingCountByUserId);
                                            System.out.println("  - Count by appId: " + existingCount);
                                            System.out.println("  - Total sittings: " + allExistingResults.size());

                                            // Check if user already has 9 subjects
                                            if (totalExistingCount >= 9) {
                                                out.print("<div class='alert alert-danger'>Maximum 9 O-level subjects already reached. Contact Support Desk if you need to make changes.</div>");
                                            } else {
                                                // CRITICAL: Check if user already has 2 sittings (check combined results)
                                                // If yes, only allow adding to existing sittings, not creating new ones
                                                boolean userHasTwoSittings = allExistingResults.size() >= 2;
                                                
                                                // Check sitting constraints
                                                Olevelresults existingSittingResult = null;
                                                boolean hasFirstSitting = false;
                                                boolean hasSecondSitting = false;

                                                for (Olevelresults result : allExistingResults) {
                                                    if ("First".equals(result.getSitting())) {
                                                        hasFirstSitting = true;
                                                        if (sitting.equals("First")) {
                                                            existingSittingResult = result;
                                                        }
                                                    } else if ("Second".equals(result.getSitting())) {
                                                        hasSecondSitting = true;
                                                        if (sitting.equals("Second")) {
                                                            existingSittingResult = result;
                                                        }
                                                    }
                                                }

                                                // Validate sitting selection - Allow adding to existing sittings until 9 subjects total
                                                boolean canProceed = true;
                                                String errorMessage = "";

                                                // CRITICAL: If user already has 2 sittings AND trying to create a new one, reject
                                                if (userHasTwoSittings && existingSittingResult == null) {
                                                    canProceed = false;
                                                    errorMessage = "Maximum 2 sittings already exist. You can only add subjects to existing sittings (up to 9 total).";
                                                    System.out.println("  - Rejected: User has 2 sittings, cannot create new one");
                                                }

                                                if (!canProceed) {
                                                    out.print("<div class='alert alert-danger'>" + errorMessage + "</div>");
                                                } else {
                                                    // Calculate how many subjects can be added
                                                    int allowed = 9 - (int) totalExistingCount;
                                                    int subjectsToAdd = Math.min(subjectIds.length, allowed);

                                                    // Use existing sitting result or create new one
                                                    Olevelresults result = existingSittingResult;
                                                    if (result == null) {
                                                        // Create new sitting result - ALWAYS use user.getId() for consistency
                                                        result = new Olevelresults();
                                                        String idu = settings.generateId("", 10);
                                                        result.setId(idu);
                                                        result.setName(name);
                                                        result.setResultType(resultType);
                                                        result.setRegistrationNo(regnou);
                                                        result.setUserId(user.getId());  // CRITICAL: Use user.getId() not genapp.getId()
                                                        result.setExamDate(examDate);
                                                        result.setSitting(sitting);
                                                        result.setDateAdded(settings.getCurrentDateTime());
                                                        result.setVerificationStatus("Pending");
                                                        sess.newEntry(result);
                                                        System.out.println("  - Created new sitting with userId: " + user.getId());
                                                    }

                                                    // Add subjects to the sitting
                                                    int addedCount = 0;
                                                    List<String> duplicateSubjects = new ArrayList<>();
                                                    List<String> addedSubjects = new ArrayList<>();

                                                    for (int i = 0; i < subjectsToAdd; i++) {
                                                        String subjId = subjectIds[i];
                                                        String gradeId = gradeIds[i];

                                                        if (subjId != null && !subjId.isEmpty() && gradeId != null && !gradeId.isEmpty()) {
                                                            // Check if subject already exists - use combined allExistingResults
                                                            List<Olevelresultsitems> existingItemsByUser = sess.getOlevelresultsItemsByUserId(user.getId());
                                                            List<Olevelresultsitems> existingItemsByApp = sess.getOlevelresultsItemsByUserId(genapp.getId());
                                                            
                                                            // Combine and deduplicate items
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
                                                            
                                                            boolean subjectExists = false;
                                                            String existingSitting = "";

                                                            Olevelsubjects subjEntity = (Olevelsubjects) sess.getSingleObject(Olevelsubjects.class, subjId);
                                                            if (subjEntity != null) {
                                                                for (Olevelresultsitems item : allExistingItems) {
                                                                    if (item.getSubject().equals(subjEntity.getName())) {
                                                                        subjectExists = true;
                                                                        existingSitting = item.getOlevelResultsId().getSitting();
                                                                        break;
                                                                    }
                                                                }
                                                            }

                                                            if (!subjectExists) {
                                                                Olevelgrades gradeEntity = (Olevelgrades) sess.getSingleObject(Olevelgrades.class, gradeId);

                                                                Olevelresultsitems item = new Olevelresultsitems();
                                                                item.setId(settings.generateId(result.getId(), 4) + "_" + System.nanoTime());
                                                                item.setOlevelResultsId(result);
                                                                item.setSubject(subjEntity != null ? subjEntity.getName() : subjId);
                                                                item.setGrade(gradeEntity);
                                                                item.setDateAdded(new Date());
                                                                item.setVerificationStatus("Pending");
                                                                sess.newEntry(item);
                                                                addedCount++;
                                                                addedSubjects.add(subjEntity.getName());
                                                            } else {
                                                                // Track duplicate subject with its existing sitting
                                                                duplicateSubjects.add(subjEntity.getName() + " (already in " + existingSitting + " sitting)");
                                                            }
                                                        }
                                                    }

                                                    // Provide comprehensive feedback
                                                    if (addedCount > 0) {
                                                        // Recalculate total using double-check
                                                        long newCountByUser = sess.countOlevelSubjectsByUser(user.getId());
                                                        long newCountByApp = sess.countOlevelSubjectsByUser(genapp.getId());
                                                        long newTotalCount = Math.max(newCountByUser, newCountByApp);
                                                        String sittingType = isExistingSitting ? "existing" : "new";
                                                        out.print("<div class='alert alert-success'>");
                                                        out.print("<strong>Success!</strong> " + addedCount + " subject(s) added successfully to " + sittingType + " " + sitting + " sitting.<br>");

                                                        // Show added subjects
                                                        if (!addedSubjects.isEmpty()) {
                                                            out.print("<strong>Added subjects:</strong> " + String.join(", ", addedSubjects) + "<br>");
                                                        }

                                                        out.print("<strong>Total O-level subjects:</strong> " + newTotalCount + "/9<br>");
                                                        if (isExistingSitting) {
                                                            out.print("<strong>Sitting details:</strong> " + name + " (" + resultType + ") - " + examDate);
                                                        }
                                                        out.print("</div>");
                                                    }

                                                    // Show duplicate subjects warning
                                                    if (!duplicateSubjects.isEmpty()) {
                                                        out.print("<div class='alert alert-warning'>");
                                                        out.print("<strong>Duplicate subjects skipped:</strong><br>");
                                                        out.print("The following subjects were not added because they already exist in your O-level records:<br>");
                                                        out.print("<ul class='mb-2'>");
                                                        for (String duplicate : duplicateSubjects) {
                                                            out.print("<li>" + duplicate + "</li>");
                                                        }
                                                        out.print("</ul>");
                                                        out.print("<small><i class='fas fa-info-circle'></i> Each subject can only be recorded once across all sittings.</small>");
                                                        out.print("</div>");
                                                    }

                                                    // Show message when no subjects were added
                                                    if (addedCount == 0 && duplicateSubjects.isEmpty()) {
                                                        out.print("<div class='alert alert-warning'>");
                                                        out.print("<strong>No subjects added.</strong> This could be because:<br>");
                                                        out.print("• Empty subject or grade selections<br>");
                                                        out.print("• Maximum subject limit reached<br>");
                                                        out.print("Please review your selections and try again.");
                                                        out.print("</div>");
                                                    }

                                                    if (subjectIds.length > allowed) {
                                                        // Recalculate using double-check
                                                        long finalCountByUser = sess.countOlevelSubjectsByUser(user.getId());
                                                        long finalCountByApp = sess.countOlevelSubjectsByUser(genapp.getId());
                                                        long finalTotalCount = Math.max(finalCountByUser, finalCountByApp);
                                                        out.print("<div class='alert alert-info'>");
                                                        out.print("<strong>Note:</strong> Only " + allowed + " subjects could be processed due to the 9-subject maximum limit. ");
                                                        out.print("You now have " + finalTotalCount + "/9 subjects total.");
                                                        out.print("</div>");
                                                    }
                                                }
                                            }
                                        } else {
                                            out.print("<div class='alert alert-danger'>");
                                            out.print("<strong>Missing required information:</strong><br>");
                                            if (name == null || name.trim().isEmpty()) {
                                                out.print("• Name is required<br>");
                                            }
                                            if (resultType == null || resultType.trim().isEmpty()) {
                                                out.print("• Result Type is required<br>");
                                            }
                                            if (examDate == null || examDate.trim().isEmpty()) {
                                                out.print("• Exam Date is required<br>");
                                            }
                                            if (sitting == null || sitting.trim().isEmpty()) {
                                                out.print("• Sitting selection is required<br>");
                                            }
                                            if (subjectIds == null || subjectIds.length == 0) {
                                                out.print("• At least one subject must be selected<br>");
                                            }
                                            if (gradeIds == null || gradeIds.length == 0) {
                                                out.print("• Grades must be selected for all subjects<br>");
                                            }
                                            out.print("Please fill in all required fields and try again.");
                                            out.print("</div>");
                                        }
                                    } catch (Exception ex) {
                                        ex.printStackTrace();
                                        out.print("<div class='alert alert-danger'>Error saving record: " + ex.getMessage() + "</div>");
                                    }
                                }
                                String utmeno = request.getParameter("utmeno");
                                String engsc = request.getParameter("engsc");
                                String subj2 = request.getParameter("subj2");
                                String subj2sc = request.getParameter("subj2sc");
                                String subj3 = request.getParameter("subj3");
                                String subj3sc = request.getParameter("subj3sc");
                                String subj4 = request.getParameter("subj4");
                                String subj4sc = request.getParameter("subj4sc");
                                String button4k = request.getParameter("button4k");

                                List<Olevelgrades> gradesList = sess.getAllOlevelgrades();
                                List<Olevelsubjects> subjectsList = sess.getAllOlevelsubjects("ACTIVE");
                                System.out.println("ssssss " + subjectsList.size());

                                String training = request.getParameter("training");
                                String empstatus = request.getParameter("empstatus");
                                String fieldstudy = request.getParameter("fieldstudy");
                                String research = request.getParameter("research");
                                String guardianname = request.getParameter("guardianname");
                                String guardianadd = request.getParameter("guardianadd");
                                String quali = request.getParameter("quali");
                                String maritalstatus = request.getParameter("maritalstatus");
                                if (button4k != null && button4k.length() > 0 && utmeno != null) {
                                    try {

                                        try {

                                        } catch (Exception ex) {
                                            ex.printStackTrace();
                                        }

                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%                                    } catch (Exception v) {
                                    }
                                }
                            %>


                            <%
                                String attestationbox = request.getParameter("attestationbox");
                                String submit6 = request.getParameter("submit6");
                                if (submit6 != null && submit6.length() > 0) {
                                    if (attestationbox != null) {
                                        try {
                                            sess.completeApplicantStatus(genapp.getId());
                                            genapp = sess.getApplicants(genapp.getId());
                            %>
                            <div class="alert alert-success">Congratulations!, Your application has been submitted successfully. You will be notified via email on next action and application progress</div>
                            <%
                                        } catch (Exception k) {
                                        }
                                    }
                                }
                            %>
                            <strong> Your application status is <%=genapp.getStatus()%> </strong>

                            <%                                if (genapp.getStatus().equalsIgnoreCase("NOT SUBMITTED")) {
                                    //List<Payments> payutme = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                                    //if (payutme.size() > 0) {
                                    int i = 1;
                                    if (i == 1) {
                            %>


                            <div class="accordion" id="accordionExample">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOne">
                                        <button class="accordion-button collapsed" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapseOne" 
                                                aria-expanded="true" aria-controls="collapseOne">
                                            Olevel Details
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandDetails%>" id="collapseOne" 
                                         aria-labelledby="headingOne" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">

                                            <div class="form-container">
                                                <h2>Enter O-Level Result</h2>

                                                <%
                                                    // DOUBLE CHECK: Get existing O-level results by BOTH userId AND applicationId
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
                                                    
                                                    // Get items from both sources
                                                    List<Olevelresultsitems> existingItemsByUser = sess.getOlevelresultsItemsByUserId(user.getId());
                                                    List<Olevelresultsitems> existingItemsByApp = sess.getOlevelresultsItemsByUserId(genapp.getId());
                                                    
                                                    // Combine and deduplicate items
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
                                                    
                                                    System.out.println("DEBUG remedial_form display: userId=" + user.getId() + ", appId=" + genapp.getId());
                                                    System.out.println("  - Count by userId: " + existingCountByUser);
                                                    System.out.println("  - Count by appId: " + existingCountByApp);
                                                    System.out.println("  - Combined results: " + existingResults.size() + " sittings, " + existingCount + " subjects");
                                                %>

                                                <%
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

                                                    // Determine what sitting options are available
                                                    if (!hasFirstSitting && !hasSecondSitting) {
                                                        availableSitting = "both"; // Can choose either
                                                    } else if (hasFirstSitting && !hasSecondSitting) {
                                                        availableSitting = "first_or_second"; // Can add to first or start second
                                                    } else if (!hasFirstSitting && hasSecondSitting) {
                                                        availableSitting = "second_or_first"; // Can add to second or start first
                                                    } else {
                                                        // Both sittings exist - can still add to either until 9 subjects total
                                                        availableSitting = "both_existing"; // Both sittings exist, can add to either
                                                    }

                                                    // Group existing items by sitting
                                                    Map<String, List<Olevelresultsitems>> itemsBySitting = new HashMap<>();
                                                    Map<String, Olevelresults> sittingData = new HashMap<>();
                                                    for (Olevelresultsitems item : existingItems) {
                                                        String sitting = item.getOlevelResultsId().getSitting();
                                                        itemsBySitting.computeIfAbsent(sitting, k -> new ArrayList<>()).add(item);
                                                        sittingData.put(sitting, item.getOlevelResultsId());
                                                    }
                                                %>

                                                <!-- Display existing O-level results -->
                                                <% if (!existingResults.isEmpty()) {%>
                                                <div class="existing-subjects">
                                                    <h5><i class="fas fa-check-circle text-success"></i> Your Existing O-Level Results (<%=existingCount%>/9 subjects)</h5>
                                                    <% for (String sitting : itemsBySitting.keySet()) {%>
                                                    <h6 class="mt-3"><strong><%=sitting%> Sitting:</strong> 
                                                        <span class="badge bg-info"><%=itemsBySitting.get(sitting).size()%> subjects</span>
                                                    </h6>
                                                    <div class="row">
                                                        <% for (Olevelresultsitems item : itemsBySitting.get(sitting)) {%>
                                                        <div class="col-md-3 mb-2">
                                                            <span class="badge bg-success subject-badge"><%=item.getSubject()%>: <%=item.getGrade().getId()%></span>
                                                        </div>
                                                        <% } %>
                                                    </div>
                                                    <% } %>
                                                </div>
                                                <% } %>

                                                <% if (existingCount < 9 && !"none".equals(availableSitting)) {%>
                                                <div class="alert alert-warning">
                                                    <strong>Sitting Rules:</strong>
                                                    <ul class="mb-0 mt-2">
                                                        <li>Maximum 9 subjects total across both sittings</li>
                                                        <li>Maximum 2 sittings allowed (First and Second)</li>
                                                        <li>You can add <%=(9 - (int)existingCount)%> more subject(s)</li>
                                                            <% if (hasFirstSitting && hasSecondSitting) { %>
                                                        <li class="text-success">Both sittings exist - you can add subjects to either sitting until 9 total</li>
                                                            <% } else if (hasFirstSitting) { %>
                                                        <li>You can add subjects to your existing First Sitting or start a Second Sitting</li>
                                                            <% } else if (hasSecondSitting) { %>
                                                        <li>You can add subjects to your existing Second Sitting or start a First Sitting</li>
                                                            <% } else { %>
                                                        <li>You can start with either First or Second Sitting</li>
                                                            <% }%>
                                                    </ul>
                                                </div>

                                                <div class="dynamic-form-container">
                                                    <form method="post" action="">
                                                        <!-- Hidden applicant ID -->
                                                        <input type="hidden" name="userId" value="<%= genapp.getId()%>" />

                                                        <!-- Hidden sitting data for auto-fill -->
                                                        <% for (Map.Entry<String, Olevelresults> entry : sittingData.entrySet()) {
                                                                Olevelresults sittingResult = entry.getValue();
                                                        %>
                                                        <input type="hidden" id="sitting_<%= entry.getKey()%>_name" value="<%= sittingResult.getName()%>" />
                                                        <input type="hidden" id="sitting_<%= entry.getKey()%>_resultType" value="<%= sittingResult.getResultType()%>" />
                                                        <input type="hidden" id="sitting_<%= entry.getKey()%>_regNo" value="<%= sittingResult.getRegistrationNo() != null ? sittingResult.getRegistrationNo() : ""%>" />
                                                        <input type="hidden" id="sitting_<%= entry.getKey()%>_examDate" value="<%= sittingResult.getExamDate()%>" />
                                                        <% } %>

                                                        <!-- Hidden fields for form submission when auto-filled -->
                                                        <input type="hidden" id="hiddenName" name="hiddenName" />
                                                        <input type="hidden" id="hiddenResultType" name="hiddenResultType" />
                                                        <input type="hidden" id="hiddenRegistrationNo" name="hiddenRegistrationNo" />
                                                        <input type="hidden" id="hiddenExamDate" name="hiddenExamDate" />
                                                        <input type="hidden" id="isExistingSitting" name="isExistingSitting" value="false" />

                                                        <div class="input-group mb-3">
                                                            <span class="input-group-text">Name</span>
                                                            <input type="text" class="form-control" id="name" name="name" required />
                                                            <small class="form-text auto-fill-help" id="nameHelp" style="display:none;"><i class="fas fa-info-circle"></i> Auto-filled from existing sitting</small>
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
                                                            <small class="form-text auto-fill-help" id="resultTypeHelp" style="display:none;"><i class="fas fa-info-circle"></i> Auto-filled from existing sitting</small>
                                                        </div>

                                                        <div class="input-group mb-3">
                                                            <span class="input-group-text">Registration No</span>
                                                            <input type="text" class="form-control" id="registrationNo" name="registrationNo" />
                                                            <small class="form-text auto-fill-help" id="regNoHelp" style="display:none;"><i class="fas fa-info-circle"></i> Auto-filled from existing sitting</small>
                                                        </div>

                                                        <div class="input-group mb-3">
                                                            <span class="input-group-text">Exam Date</span>
                                                            <input type="date" class="form-control" id="examDate" name="examDate" required />
                                                            <small class="form-text auto-fill-help" id="examDateHelp" style="display:none;"><i class="fas fa-info-circle"></i> Auto-filled from existing sitting</small>
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
                                                                <% } else { %>
                                                                <option value="">No more subjects allowed (9 reached)</option>
                                                                <% } %>
                                                            </select>
                                                        </div>

                                                        <h4>Add Subjects & Grades</h4>
                                                        <div class="alert alert-info">
                                                            <small><i class="fas fa-info-circle"></i> You can add one or more subjects at a time. Click "Add Subject" to add more rows.</small>
                                                            <% if (!existingItems.isEmpty()) {%>
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
                                                                            <% for (Olevelsubjects subj : subjectsList) {%>
                                                                            <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                                                                            <% } %>
                                                                        </select>
                                                                    </td>
                                                                    <td>
                                                                        <select name="grade[]" class="form-select" required>
                                                                            <option value="">-- Select Grade --</option>
                                                                            <% for (Olevelgrades g : gradesList) {%>
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

                                                        <button type="button" id="addSubjectBtn" class="btn btn-secondary mb-3" onclick="addSubjectRow()">
                                                            <i class="fas fa-plus"></i> Add Subject
                                                        </button>
                                                        <br/>

                                                        <input type="submit" class="btn btn-primary px-4" value="Submit O-Level Results"/>
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
                                                    <p class="mb-0">If you need to make changes, please contact the support desk.</p>
                                                </div>
                                                <% }%>

                                                <div id="olevelScripts" data-remaining="<%=(9 - (int) existingCount)%>"></div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Supporting Documents (<%=ldocs.size()%> added)</button>
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
                                        <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseFive" aria-expanded="true" aria-controls="collapseThree">Confirm and Submit</button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandSubmit%>" id="collapseFive" aria-labelledby="headingFive" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <div class="alert alert-warning">
                                                Note that by confirming your application, you are agreeing that you have gone through your application and have satisfied that every needed information is provided correctly. 
                                                Any modification after this action will not be permitted.
                                                <p>However, this action marks the completion of your application process and it is after this that your application will be received by the school for processing.</p>
                                            </div>
                                            <form action='' method='post' name="attestation">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                        <div class="mb-3 row">
                                                            <div class="col-sm-1">
                                                                <input class="form-check-input" name="attestationbox" type="checkbox"  required="">
                                                            </div>
                                                            <label class="col-sm-9 form-check-label" for="attestationbox"><strong>Declaration:</strong> I <%=std.getSurname() + " " + std.getOthernames()%>, hereby declare that the information stated above is to the best of my knowledge and belief, accurate in every detail.</label>

                                                            <div class="col-sm-2">

                                                                <button name="submit6"  value="Submit" class="btn btn-primary mb-3" type="submit">Submit</button>                       
                                                            </div></div>
                                                    </div>
                                                </div>
                                            </form>



                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%
                                } // Close the if (i == 1) block
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

                                if (genapp.getStatus().equalsIgnoreCase("SUBMITTED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your application has been received. You will be notified via email and on this platform for the next action.</p>
                                <p>Download Documents:
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-warning btn-sm float-end">Application Form</a>
                                </p>
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
                    </div>
                    <%
                        }
                    } // Close all status-related if blocks
                    else {
                        // Handle case where std is null
                        System.out.println("DEBUG: std is null for user " + user.getId() + " in remedial_form.jsp");
                    %>
                    <div class="alert alert-danger">
                        <h4>Profile Setup Required</h4>
                        <p>Your profile information is not available. This might be due to a system error or incomplete setup.</p>
                        <p><strong>User ID:</strong> <%=user.getId()%></p>
                        <p><strong>Username:</strong> <%=user.getUsername()%></p>
                        <p>Please contact the system administrator or try logging out and logging back in.</p>
                        <div class="mt-3">
                            <a href="/gen_app_dashboard" class="btn btn-primary me-2">Back to Dashboard</a>
                            <a href="/log_out" class="btn btn-secondary">Logout</a>
                        </div>
                    </div>
                    <%
                        }
                    %>
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

                                                                       async function loadDocument(id) {
                                                                       try {
                                                                       const url = "AjaxServlet?action=loadDodument&id2=" + escape(id);
                                                                       const response = await fetch(url);
                                                                       if (!response.ok) {
                                                                       throw new Error(`HTTP error! Status: ${response.status}`);
                                                                       }
                                                                       const respText = await response.text();
                                                                       document.getElementById("det").innerHTML = respText; // Use `id2` here
                                                                       } catch (error) {
                                                                       console.error("Error updating record:", error);
                                                                       }
                                                                       }
        </script>
        <script>
            // O-level dynamic form functionality
            document.addEventListener('DOMContentLoaded', function() {
            const scriptsDiv = document.getElementById('olevelScripts');
            if (scriptsDiv) {
            const maxSubjects = parseInt(scriptsDiv.getAttribute('data-remaining'));
            let currentRows = 1;
            // Auto-fill functionality for existing sittings
            const sittingSelect = document.getElementById('sitting');
            const nameField = document.getElementById('name');
            const resultTypeField = document.getElementById('resultType');
            const regNoField = document.getElementById('registrationNo');
            const examDateField = document.getElementById('examDate');
            // Hidden fields for submission
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
            // Check if this is an existing sitting (contains "existing" in the option text)
            const selectedOption = this.options[this.selectedIndex];
            const isExisting = selectedOption && selectedOption.text.includes('(existing)');
            if (isExisting && selectedSitting) {
            // Get data from hidden fields
            const nameData = document.getElementById('sitting_' + selectedSitting + '_name');
            const resultTypeData = document.getElementById('sitting_' + selectedSitting + '_resultType');
            const regNoData = document.getElementById('sitting_' + selectedSitting + '_regNo');
            const examDateData = document.getElementById('sitting_' + selectedSitting + '_examDate');
            if (nameData && resultTypeData && examDateData) {
            // Auto-fill the visible fields
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
            // Populate hidden fields for submission
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
            // Reset the values
            newRow.querySelectorAll('select').forEach(select => select.selectedIndex = 0);
            // Enable remove button
            const removeBtn = newRow.querySelector('button');
            removeBtn.disabled = false;
            tbody.appendChild(newRow);
            currentRows++;
            updateRemoveButtons();
            };
            window.removeSubjectRow = function(button) {
            const tbody = document.getElementById('subjectTableBody');
            if (tbody.rows.length > 1) {
            button.closest('tr').remove();
            currentRows--;
            updateRemoveButtons();
            }
            };
            function updateRemoveButtons() {
            const tbody = document.getElementById('subjectTableBody');
            const removeButtons = tbody.querySelectorAll('button');
            removeButtons.forEach((btn, index) => {
            btn.disabled = tbody.rows.length <= 1;
            });
            }

            // Form validation
            const form = document.querySelector('form[method="post"]');
            if (form) {
            form.addEventListener('submit', function(e) {
            const subjectSelects = document.querySelectorAll('select[name="subject[]"]');
            const selectedSubjects = [];
            let hasError = false;
            subjectSelects.forEach(select => {
            if (select.value && select.value !== '') {
            if (selectedSubjects.includes(select.value)) {
            alert('You cannot select the same subject multiple times.');
            hasError = true;
            return;
            }
            selectedSubjects.push(select.value);
            }
            });
            if (hasError) {
            e.preventDefault();
            }
            });
            }
            }
            });
        </script>
        <script>
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
            // Reset the values
            newRow.querySelectorAll('select').forEach(select => select.selectedIndex = 0);
            // Enable remove button
            const removeBtn = newRow.querySelector('button');
            removeBtn.disabled = false;
            tbody.appendChild(newRow);
            currentRows++;
            // Disable add button if max reached
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
            // Re-enable add button
            document.getElementById('addSubjectBtn').disabled = false;
            updateRemoveButtons();
            }
            };
            function updateRemoveButtons() {
            const tbody = document.getElementById('subjectTableBody');
            const removeButtons = tbody.querySelectorAll('button');
            removeButtons.forEach((btn, index) => {
            btn.disabled = tbody.rows.length === 1;
            });
            }

            // Add form validation to prevent duplicate subjects and ensure proper submission
            const form = document.querySelector('form[method="post"]');
            if (form) {
            form.addEventListener('submit', function(e) {
            const subjectSelects = document.querySelectorAll('select[name="subject[]"]');
            const selectedSubjects = [];
            let hasDuplicates = false;
            // Check for duplicate subjects
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

            // Ensure hidden fields are populated for existing sittings
            const isExisting = document.getElementById('isExistingSitting').value === 'true';
            if (isExisting) {
            // Double-check that hidden fields have values
            const hiddenName = document.getElementById('hiddenName');
            const hiddenResultType = document.getElementById('hiddenResultType');
            const hiddenExamDate = document.getElementById('hiddenExamDate');
            if (!hiddenName.value || !hiddenResultType.value || !hiddenExamDate.value) {
            e.preventDefault();
            alert('Error: Missing sitting information. Please reselect the sitting and try again.');
            return false;
            }
            }

            // Show loading message
            const submitBtn = form.querySelector('input[type="submit"]');
            if (submitBtn) {
            submitBtn.value = 'Saving...';
            submitBtn.disabled = true;
            }
            });
            }
            }
            });
        </script>
    </body>



</html>