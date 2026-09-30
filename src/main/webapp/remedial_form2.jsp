<%--
    Document   : remedial_form2
    Created on : 16 JAN 2026
    Author     : BEMGBA
    Purpose    : O-Level Results Entry Only
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%
    // Security check - user must be logged in
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Get applicant biodata - will be provided by header_applicant_gen.jspf
    // Applicantsbiodata std = sess.getApplicantsbiodataById(user.getId());
    // Note: std variable is declared in header_applicant_gen.jspf
    
    // For now, just check if user is logged in
    // The header will handle biodata loading and validation
    
    // Get applicant record - for O-level, we need the applicant ID
    Applicants genapp = null;
    try {
        genapp = (Applicants) sess.getSingleObject(Applicants.class, user.getId());
        if (genapp == null) {
            genapp = sess.getApplicants(user.getId());
        }
    } catch (Exception e) {
        genapp = sess.getApplicants(user.getId());
    }
    
    // IMPORTANT: Always use user.getId() for O-level results to prevent duplicates
    // O-level results are tied to the USER, not the application
    String userId = user.getId();
    String applicantId = (genapp != null) ? genapp.getId() : user.getId();
    
    System.out.println("DEBUG remedial_form2: userId=" + userId + ", applicantId=" + applicantId);
%>

<%
    // O-Level Form Processing Logic
    String name = request.getParameter("name");
    String resultType = request.getParameter("resultType");
    String registrationNo = request.getParameter("registrationNo");
    String examDate = request.getParameter("examDate");
    String sitting = request.getParameter("sitting");
    String[] subjectIds = request.getParameterValues("subject[]");
    String[] gradeIds = request.getParameterValues("grade[]");
    
    // Hidden fields for existing sitting
    String hiddenName = request.getParameter("hiddenName");
    String hiddenResultType = request.getParameter("hiddenResultType");
    String hiddenRegistrationNo = request.getParameter("hiddenRegistrationNo");
    String hiddenExamDate = request.getParameter("hiddenExamDate");
    String isExistingSittingStr = request.getParameter("isExistingSitting");
    boolean isExistingSitting = "true".equals(isExistingSittingStr);
    
    String message = "";
    String messageType = "";
    
    // Debug: Check what parameters are being received
    System.out.println("DEBUG: Form parameters received:");
    System.out.println("  - name: " + name);
    System.out.println("  - resultType: " + resultType);
    System.out.println("  - examDate: " + examDate);
    System.out.println("  - sitting: " + sitting);
    System.out.println("  - subjectIds: " + (subjectIds != null ? subjectIds.length : "null"));
    System.out.println("  - gradeIds: " + (gradeIds != null ? gradeIds.length : "null"));
    System.out.println("  - isExistingSittingStr: " + isExistingSittingStr);

    if (name != null && examDate != null && sitting != null 
            && subjectIds != null && gradeIds != null) {
        try {
            System.out.println("DEBUG: Form submitted for applicant: " + applicantId);
            System.out.println("  - Sitting: " + sitting);
            System.out.println("  - isExistingSitting: " + isExistingSitting);
            System.out.println("  - Name: " + name);
            System.out.println("  - resultType from form: " + resultType);
            System.out.println("  - Subjects count: " + subjectIds.length);
            
            // Use hidden fields if this is an existing sitting (because visible fields are disabled and won't submit)
            if (isExistingSitting && hiddenName != null && !hiddenName.trim().isEmpty()) {
                name = hiddenName;
                resultType = hiddenResultType;
                registrationNo = hiddenRegistrationNo;
                examDate = hiddenExamDate;
                System.out.println("  - Using hidden fields for existing sitting");
                System.out.println("  - resultType from hidden: " + resultType);
            }
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() || resultType == null || resultType.trim().isEmpty()
                    || examDate == null || examDate.trim().isEmpty() || sitting == null || sitting.trim().isEmpty()) {
                message = "All required fields must be filled. Missing: ";
                if (name == null || name.trim().isEmpty()) message += "Name ";
                if (resultType == null || resultType.trim().isEmpty()) message += "ResultType ";
                if (examDate == null || examDate.trim().isEmpty()) message += "ExamDate ";
                if (sitting == null || sitting.trim().isEmpty()) message += "Sitting ";
                messageType = "danger";
                System.out.println("  - Validation failed: " + message);
            } else {
                // DOUBLE CHECK: Get existing O-level results by BOTH userId AND applicationId
                // This prevents duplicates whether user enters via navigation link or application details
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
                
                System.out.println("  - Existing count by userId: " + existingCountByUser);
                System.out.println("  - Existing count by applicationId: " + existingCountByApp);
                System.out.println("  - Total existing count: " + totalExistingCount);
                System.out.println("  - Checking by userId: " + userId + " AND applicationId: " + applicantId);
                
                // Check if maximum subjects reached (check both)
                if (totalExistingCount >= 9) {
                    message = "Maximum 9 O-level subjects already reached.";
                    messageType = "danger";
                } else {
                    // Check for existing sitting in combined results
                    Olevelresults existingSittingResult = null;
                    for (Olevelresults result : allExistingResults) {
                        if (sitting.equals(result.getSitting())) {
                            existingSittingResult = result;
                            System.out.println("  - Found existing sitting: " + result.getId() + " (userId: " + result.getUserId() + ")");
                            break;
                        }
                    }
                    
                    // Validate: Maximum 2 sittings allowed (check combined results)
                    if (existingSittingResult == null && allExistingResults.size() >= 2) {
                        message = "Maximum 2 sittings allowed. You already have First and Second sittings.";
                        messageType = "danger";
                        System.out.println("  - Rejected: Already have 2 sittings (combined check)");
                    } else {
                        // Use existing or create new sitting result
                        Olevelresults result = existingSittingResult;
                        if (result == null) {
                            System.out.println("  - Creating new sitting record");
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
                            sess.newEntry(result);
                        } else {
                            System.out.println("  - Reusing existing sitting record: " + result.getId());
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
                        List<String> duplicateSubjects = new ArrayList<>();
                        int allowed = (int)(9 - totalExistingCount);
                        
                        System.out.println("  - Allowed subjects to add: " + allowed);
                        System.out.println("  - Existing items count (combined): " + allExistingItems.size());
                        
                        for (int i = 0; i < subjectIds.length && addedCount < allowed; i++) {
                            String subjId = subjectIds[i];
                            String gradeId = (i < gradeIds.length) ? gradeIds[i] : null;
                            
                            System.out.println("  - Processing subject " + (i+1) + ": " + subjId + " with grade: " + gradeId);
                            
                            if (subjId != null && !subjId.isEmpty() && gradeId != null && !gradeId.isEmpty()) {
                                Olevelsubjects subjEntity = (Olevelsubjects) sess.getSingleObject(Olevelsubjects.class, subjId);
                                
                                // Check for duplicates in combined list
                                boolean subjectExists = false;
                                if (subjEntity != null) {
                                    for (Olevelresultsitems item : allExistingItems) {
                                        if (item.getSubject().equals(subjEntity.getName())) {
                                            subjectExists = true;
                                            duplicateSubjects.add(subjEntity.getName());
                                            System.out.println("    - Subject already exists: " + subjEntity.getName());
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
                                    sess.newEntry(item);
                                    addedCount++;
                                    System.out.println("    - Added subject: " + (subjEntity != null ? subjEntity.getName() : subjId));
                                } else {
                                    skippedCount++;
                                }
                            }
                        }
                        
                        System.out.println("  - Total added: " + addedCount + ", skipped: " + skippedCount);
                        
                        // Build success message - recount to get accurate total
                        long newTotalCountByUser = sess.countOlevelSubjectsByUser(userId);
                        long newTotalCountByApp = sess.countOlevelSubjectsByUser(applicantId);
                        long newTotalCount = Math.max(newTotalCountByUser, newTotalCountByApp);
                        
                        message = "<strong>Success!</strong> " + addedCount + " subject(s) added successfully.<br>";
                        message += "<strong>Total O-level subjects:</strong> " + newTotalCount + "/9<br>";
                        
                        if (skippedCount > 0) {
                            message += "<br><strong>Note:</strong> " + skippedCount + " duplicate subject(s) were skipped.";
                        }
                        
                        messageType = "success";
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            message = "Error saving O-level results: " + ex.getMessage();
            messageType = "danger";
        }
    }
    
    // Load grades and subjects for form
    List<Olevelgrades> gradesList = sess.getAllOlevelgrades();
    List<Olevelsubjects> subjectsList = sess.getAllOlevelsubjects("ACTIVE");
%>

<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - O-Level Results</title>
    
    <style>
        .existing-subjects {
            background-color: #f8f9fa;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 0.375rem;
        }
        
        .subject-badge {
            margin: 2px;
            font-size: 0.9em;
            padding: 0.5em 0.75em;
        }
        
        .dynamic-form-container {
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 20px;
            background-color: #ffffff;
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
    <%@include file="WEB-INF/jspf/applicant_navigations.jspf"%>
    
    <div class="wrapper d-flex flex-column min-vh-100">
        <header class="header header-sticky p-0">
            <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
            <div class="container-fluid px-4">
                <div class="d-flex justify-content-between align-items-center">
                    <h2 class="title">O-Level Results</h2>
                    <a href="/gen_app_dashboard" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </header>
        
        <div class="body flex-grow-1">
            <div class="container-lg px-4 py-4">
                
                <% if (message != null && !message.isEmpty()) { %>
                <div class="alert alert-<%=messageType%> alert-dismissible fade show" role="alert">
                    <%=message%>
                    <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                </div>
                <% } %>
                
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Enter O-Level Results</h5>
                    </div>
                    <div class="card-body">
                        
                        <%
                            // DOUBLE CHECK: Get existing O-level results by BOTH userId AND applicationId
                            List<Olevelresults> existingResultsByUser = sess.getOlevelresultsByUserId(userId);
                            List<Olevelresults> existingResultsByApp = sess.getOlevelresultsByUserId(applicantId);
                            
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
                            
                            List<Olevelresultsitems> existingItemsByUser = sess.getOlevelresultsItemsByUserId(userId);
                            List<Olevelresultsitems> existingItemsByApp = sess.getOlevelresultsItemsByUserId(applicantId);
                            
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
                            
                            long existingCountByUser = sess.countOlevelSubjectsByUser(userId);
                            long existingCountByApp = sess.countOlevelSubjectsByUser(applicantId);
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
                            
                            // Debug output
                            System.out.println("DEBUG O-Level: User " + userId);
                            System.out.println("  - Existing count: " + existingCount);
                            System.out.println("  - Has first sitting: " + hasFirstSitting);
                            System.out.println("  - Has second sitting: " + hasSecondSitting);
                            System.out.println("  - Available sitting: " + availableSitting);
                            System.out.println("  - Form will show: " + (existingCount < 9 && !"none".equals(availableSitting)));
                            
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
                        <div class="existing-subjects">
                            <h5><i class="fas fa-check-circle text-success"></i> Your Existing O-Level Results (<%=existingCount%>/9 subjects)</h5>
                            <% for (String sittingKey : itemsBySitting.keySet()) { %>
                            <h6 class="mt-3">
                                <strong><%=sittingKey%> Sitting:</strong> 
                                <span class="badge bg-info"><%=itemsBySitting.get(sittingKey).size()%> subjects</span>
                            </h6>
                            <div class="row">
                                <% for (Olevelresultsitems item : itemsBySitting.get(sittingKey)) { %>
                                <div class="col-md-3 mb-2">
                                    <span class="badge bg-success subject-badge">
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
                        
                        <div class="dynamic-form-container">
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
                                    <small class="form-text auto-fill-help" id="nameHelp" style="display:none;">
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
                                    <small class="form-text auto-fill-help" id="resultTypeHelp" style="display:none;">
                                        <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                    </small>
                                </div>
                                
                                <div class="input-group mb-3">
                                    <span class="input-group-text">Registration No</span>
                                    <input type="text" class="form-control" id="registrationNo" name="registrationNo" />
                                    <small class="form-text auto-fill-help" id="regNoHelp" style="display:none;">
                                        <i class="fas fa-info-circle"></i> Auto-filled from existing sitting
                                    </small>
                                </div>
                                
                                <div class="input-group mb-3">
                                    <span class="input-group-text">Exam Date</span>
                                    <input type="date" class="form-control" id="examDate" name="examDate" required />
                                    <small class="form-text auto-fill-help" id="examDateHelp" style="display:none;">
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
                                                    <% for (Olevelsubjects subj : subjectsList) { %>
                                                    <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                                                    <% } %>
                                                </select>
                                            </td>
                                            <td>
                                                <select name="grade[]" class="form-select" required>
                                                    <option value="">-- Select Grade --</option>
                                                    <% for (Olevelgrades g : gradesList) { %>
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
                                
                                <button type="submit" class="btn btn-primary px-4">
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
                            <p class="mb-0">If you need to make changes, please contact the support desk.</p>
                        </div>
                        <% } %>
                        
                        <div id="olevelScripts" data-remaining="<%=(9 - (int) existingCount)%>"></div>
                        
                    </div>
                </div>
                
            </div>
        </div>
        
        <%@include file="WEB-INF/jspf/footer.jspf"%>
    </div>
    
    <%@include file="WEB-INF/jspf/footerjs.jspf"%>
    
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
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
                        submitBtn.disabled = true;
                    }
                });
            }
        });
    </script>
</body>
</html>
