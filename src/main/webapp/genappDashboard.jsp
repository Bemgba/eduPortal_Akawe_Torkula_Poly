<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    // Check if user session exists
    if (user == null) {
        // Clear any existing session data and redirect to login
        session.invalidate();
        response.sendRedirect("/?error=session_expired");
        return; // Prevent further processing
    }

    // Check if user has proper role setup
    if (user.getDefaultRole() == null) {
        session.invalidate();
        response.sendRedirect("/?error=role_not_assigned");
        return;
    }

    // Check if role has proper default home page
    if (user.getDefaultRole().getDefaulthome() == null) {
        session.invalidate();
        response.sendRedirect("/?error=home_page_not_configured");
        return;
    }

    // CRITICAL: Check if user has Applicants record - if not, they need to complete their profile first
    Applicants userApplicantRecord = sess.getApplicantsById(user.getId());
    if (userApplicantRecord == null) {
        // This is a new user who registered but hasn't created their application profile yet
        // They need to complete the biodata form first before accessing other applicant features
        // Don't redirect - let the page show the biodata form (existing logic will handle this)
    } else {
        // User has Applicants record - check for biodata completeness on first login
        String firstLogin = request.getParameter("login_success");
        if ("true".equals(firstLogin)) {
            try {
                Applicantsbiodata biodata = (Applicantsbiodata) sess.getSingleObject(Applicantsbiodata.class, user.getId());
                if (biodata == null) {
                    // Don't redirect - let the page show the biodata form
                }
            } catch (Exception e) {
                // Continue to dashboard - user can access profile update manually if needed
            }
        }
    }
%>


<%
    // ===== PERFORMANCE OPTIMIZATION: Declare cache variables early =====
    Map<String, List<Payments>> paymentsCache = new HashMap<>();
    Map<String, List<Schoolsattended>> institutionsCache = new HashMap<>();
    Map<String, List<Uploadeddocuments>> documentsCache = new HashMap<>();
    
    String idxd = request.getParameter("id");
    if (idxd != null && idxd.length() > 0) {
        idxd = settings.decryptText(idxd);
        Applicants app = sess.getApplicants(idxd);

        if (app != null) {
            try {
                session.setAttribute("app", app);

                // Always show details view when ID parameter is provided
                // Don't redirect to application forms - show details instead
                // Check if application has missing data sections
                boolean hasMissingData = false;
                List<String> missingSections = new ArrayList<>();

                // Check Course Details (basic info should be present if application exists)
                // Check UTME Details and Guardian Information
                Applicantsutme utme = sess.getApplicantsutme(app.getId());
                boolean utmeCompleteInitial = utme != null && utme.getEngScore() != null
                        && utme.getSubj2() != null && utme.getSubj3() != null && utme.getSubj4() != null;

                boolean guardianCompleteInitial = app.getGuardianName() != null && !app.getGuardianName().trim().isEmpty()
                        && app.getGuardianAddress() != null && !app.getGuardianAddress().trim().isEmpty();

                boolean personalCompleteInitial = app.getQualification() != null && !app.getQualification().trim().isEmpty()
                        && app.getMaritalStatus() != null && !app.getMaritalStatus().trim().isEmpty();

                if (!utmeCompleteInitial) {
                    hasMissingData = true;
                    missingSections.add("UTME Details");
                }

                if (!guardianCompleteInitial) {
                    hasMissingData = true;
                    missingSections.add("Sponsor Information");
                }

                if (!personalCompleteInitial) {
                    hasMissingData = true;
                    missingSections.add("Personal Particular");
                }

                // Check Institutions Attended - direct database call for single app view
                List<Schoolsattended> institutions = sess.getSchoolsattendedByRegno(app.getId());
                if (institutions == null || institutions.isEmpty()) {
                    hasMissingData = true;
                    missingSections.add("Institutions Attended");
                }

                // Check Supporting Documents - direct database call for single app view
                List<Uploadeddocuments> documents = sess.getUploadeddocumentsByRegno(app.getId());
                if (documents == null || documents.isEmpty()) {
                    hasMissingData = true;
                    missingSections.add("Supporting Documents");
                }

                // Check O-level Results for remedial applications (programme.id = 1015)
                boolean isRemedialApp = false;
                try {
                    if (app.getCourse1() != null
                            && app.getCourse1().getSchoolProgrammeId() != null
                            && app.getCourse1().getSchoolProgrammeId().getProgrammeId() != null) {
                        int programId = app.getCourse1().getSchoolProgrammeId().getProgrammeId().getId();
                        isRemedialApp = (programId == 1015);
                    }
                } catch (Exception e) {
                    // Default to false if there's any error
                }

                if (isRemedialApp) {
                    try {
                        long olevelCount = sess.countOlevelSubjectsByUser(app.getId());
                        if (olevelCount < 5) { // Minimum 5 O-level subjects required
                            hasMissingData = true;
                            missingSections.add("O-Level Results");
                        }
                    } catch (Exception e) {
                        hasMissingData = true;
                        missingSections.add("O-Level Results");
                    }
                }

                // Check Payment Status - direct database call for single app view
                List<Payments> payments = sess.getPaymentsByRegno(app.getId());
                boolean hasPayment = payments != null && payments.size() > 0;

                // When ID parameter is provided, always show details view
                // Set a flag to show the details view instead of redirecting
                request.setAttribute("showApplicationDetails", true);
                request.setAttribute("applicationToView", app);
                request.setAttribute("hasMissingData", hasMissingData);
                request.setAttribute("missingSections", missingSections);
                request.setAttribute("hasPayment", hasPayment);
            } catch (Exception ka) {
                //ka.printStackTrace();
            }
        }
    }
%>

<%!    // Helper method to get the correct application form URL based on program type
    public String getApplicationFormUrl(Applicants app) {
        return getApplicationFormUrl(app, null);
    }

    // Overloaded method to include section parameter
    public String getApplicationFormUrl(Applicants app, String section) {
        try {
            if (app != null && app.getCourse1() != null
                    && app.getCourse1().getSchoolProgrammeId() != null
                    && app.getCourse1().getSchoolProgrammeId().getProgrammeId() != null) {

                int programId = app.getCourse1().getSchoolProgrammeId().getProgrammeId().getId();
                String baseUrl = "";

                if (programId == 1002) {
                    baseUrl = "/app_part_time";
                } else if (programId == 1003) {
                    baseUrl = "/app_part_time";
                } else if (programId == 1005) {
                    baseUrl = "/app_tvet";
                } else if ((programId == 1015)||(programId == 1006)||(programId == 1007)) {
                    baseUrl = "/remedialApplication";
                } else {
                    baseUrl = "/application_main1";
                }

                // Add section parameter if provided
                if (section != null && !section.trim().isEmpty()) {
                    baseUrl += "?section=" + section;
                }

                return baseUrl;
            }
        } catch (Exception e) {
            // Default to main application form if there's any error
        }

        String baseUrl = "/application_main1";
        if (section != null && !section.trim().isEmpty()) {
            baseUrl += "?section=" + section;
        }
        return baseUrl;
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Dashboard</title>

        <style>
            .payment-status-badge {
                font-size: 0.85em;
                padding: 0.4em 0.6em;
                border-radius: 0.375rem;
                font-weight: 500;
            }

            .payment-status-badge:hover {
                transform: scale(1.05);
                transition: transform 0.2s ease;
            }

            .table td {
                vertical-align: middle;
            }

            .badge {
                font-size: 0.8em;
            }

            /* Enhanced card styling for statistics */
            .card.bg-success, .card.bg-danger, .card.bg-primary, .card.bg-warning {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .card.bg-success:hover, .card.bg-danger:hover, .card.bg-primary:hover, .card.bg-warning:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }

            .display-6 {
                font-size: 2.5rem;
                font-weight: 700;
            }

            .progress {
                border-radius: 10px;
                overflow: hidden;
            }

            .progress-bar {
                transition: width 0.6s ease;
            }

            /* Navigation active state */
            .nav-link.active {
                background-color: rgba(13, 110, 253, 0.1);
                color: #0d6efd;
                border-radius: 0.375rem;
            }
        </style>

        <script>
            var req;
            var isIE;
            var country;
            var states;
            var countryval;
            var statesval;
            var lga;

            function init() {

            }

            // Show login success toast
            function showLoginSuccessToast() {
                // Check if this is a fresh login (not a page refresh)
                const urlParams = new URLSearchParams(window.location.search);
                const loginSuccess = urlParams.get('login_success');

                if (loginSuccess === 'true') {
                    // Create and show toast
                    const toastHtml = `
                        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="loginSuccessToast">
                            <div class="d-flex">
                                <div class="toast-body">
                                    <i class="fas fa-check-circle me-2"></i>
                                    Welcome back! Login successful.
                                </div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-coreui-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                    `;

                    // Add toast to page
                    let toastContainer = document.getElementById('toast-container');
                    if (!toastContainer) {
                        toastContainer = document.createElement('div');
                        toastContainer.id = 'toast-container';
                        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
                        toastContainer.style.zIndex = '1055';
                        document.body.appendChild(toastContainer);
                    }

                    toastContainer.innerHTML = toastHtml;

                    // Show toast using CoreUI
                    const toastElement = document.getElementById('loginSuccessToast');
                    const toast = new coreui.Toast(toastElement, {
                        autohide: true,
                        delay: 4000
                    });
                    toast.show();

                    // Clean up URL to remove login_success parameter
                    const newUrl = window.location.pathname;
                    window.history.replaceState({}, document.title, newUrl);
                }
            }

            // Run when page loads
            document.addEventListener('DOMContentLoaded', showLoginSuccessToast);

            function initRequest() {
                if (window.XMLHttpRequest) {
                    if (navigator.userAgent.indexOf('MSIE') != -1) {
                        isIE = true;
                    }
                    return new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    isIE = true;
                    return new ActiveXObject("Microsoft.XMLHTTP");
                }
            }

            function loadStates() {
                var sel2 = document.getElementById("country");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadState&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadStates;
                req.send(null);
            }

            function callloadStates() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("states").innerHTML = req.responseText;
                    }
                }
            }

            function loadLgas() {
                var sel2 = document.getElementById("states");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadlga&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadLgas;
                req.send(null);
            }

            function callloadLgas() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("lgas").innerHTML = req.responseText;
                    }
                }
            }

            function loadStatesEdit() {
                var sel2 = document.getElementById("countryedit");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadState&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadStatesEdit;
                req.send(null);
            }

            function callloadStatesEdit() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("statesedit").innerHTML = req.responseText;
                    }
                }
            }

            function loadLgasEdit() {
                var sel2 = document.getElementById("statesedit");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadlga&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadLgasEdit;
                req.send(null);
            }

            function callloadLgasEdit() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("lgasedit").innerHTML = req.responseText;
                    }
                }
            }

            function loadProgrammes() {
                var sel2 = document.getElementById("school");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadSchoolProgrammes&id2=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadProgrammes;
                req.send(null);
            }

            function callloadProgrammes() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("prog").innerHTML = req.responseText;
                    }
                }
            }

            function loadCourses() {
                var sel1 = document.getElementById("school");
                var sel2 = document.getElementById("prog");
                var countryval1 = sel1.options[sel1.selectedIndex].value;
                var countryval2 = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadCourses&id2=" + escape(countryval1) + "&id3=" + escape(countryval2);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadCourses;
                req.send(null);
            }

            function callloadCourses() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("courses").innerHTML = req.responseText;
                    }
                }
            }



        </script>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/applicant_navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Dashboard</h2>
                </div>
            </header>

            <%

                // ===== PERFORMANCE OPTIMIZATION: Cache expensive queries =====
                // Load user applications once and cache payment data to avoid N+1 queries
                List<Applicants> userApplications = null;

                try {
                    userApplications = sess.getApplicantsByEmail(user.getEmail());

                    // Pre-load all related data to avoid N+1 queries
                    for (Applicants app : userApplications) {
                        paymentsCache.put(app.getId(), sess.getPaymentsByRegno(app.getId()));
                        institutionsCache.put(app.getId(), sess.getSchoolsattendedByRegno(app.getId()));
                        documentsCache.put(app.getId(), sess.getUploadeddocumentsByRegno(app.getId()));
                    }
                } catch (Exception e) {
                    userApplications = new ArrayList<>();
                }

                // Initialize message variables for the entire page
                String msg = "";
                String sty = "danger";

                // PERFORMANCE FIX: Load biodata once and cache it
                 std = sess.getApplicantsbiodataById(user.getId());
                // ===== END PERFORMANCE OPTIMIZATION =====

                String surnameedit = null;
                String othernamesedit = null;
                String genderedit = null;
                String dobedit = null;
                String phonenoedit = null;
                String contactaddedit = null;
                String hometownedit = null;
                String countryedit = null;
                String statesedit = null;
                String lgasedit = null;
                byte[] fileedit = null;
                String extedit = "";
                String buttonedit = null;

                String surname = null;
                String othernames = null;
                String gender = null;
                String dob = null;
                String phoneno = null;
                String contactadd = null;
                String hometown = null;
                String country = null;
                String states = null;
                String lgas = null;
                byte[] file = null;
                String ext = "";
                String button = null;

                String UPLOAD_DIRECTORY = "/home/jux1235/passports";

                if (ServletFileUpload.isMultipartContent(request)) {
                    try {
                        ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
                        List<FileItem> formItems = upload.parseRequest(request);

                        for (FileItem item : formItems) {
                            if (!item.isFormField()) {
                                String fileName = new File(item.getName()).getName();
                                String fieldName = item.getFieldName();

                                if (fieldName.equalsIgnoreCase("passport")) {
                                    try {
                                        ext = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                    } catch (Exception d) {
                                    }
                                    file = item.get();
                                }
                                if (fieldName.equalsIgnoreCase("passportedit")) {
                                    try {
                                        extedit = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                    } catch (Exception d) {
                                    }
                                    fileedit = item.get();
                                }

                            } else {
                                String fieldName = item.getFieldName();
                                String fieldValue = item.getString();

                                if (fieldName.equalsIgnoreCase("surnameedit")) {
                                    surnameedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("othernamesedit")) {
                                    othernamesedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("genderedit")) {
                                    genderedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("dobedit")) {
                                    dobedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("phonenoedit")) {
                                    phonenoedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("contactaddedit")) {
                                    contactaddedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("hometownedit")) {
                                    hometownedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("countryedit")) {
                                    countryedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("statesedit")) {
                                    statesedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("lgasedit")) {
                                    lgasedit = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("buttonedit")) {
                                    buttonedit = fieldValue;
                                }

                                ///////////////////////////
                                if (fieldName.equalsIgnoreCase("surname")) {
                                    surname = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("othernames")) {
                                    othernames = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("gender")) {
                                    gender = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("dob")) {
                                    dob = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("phoneno")) {
                                    phoneno = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("contactadd")) {
                                    contactadd = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("hometown")) {
                                    hometown = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("country")) {
                                    country = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("states")) {
                                    states = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("lgas")) {
                                    lgas = fieldValue;
                                }
                                if (fieldName.equalsIgnoreCase("button")) {
                                    button = fieldValue;
                                }

                            }
                        }

                    } catch (Exception ex) {
                        //ex.printStackTrace();
                    }
                }

                if (buttonedit != null && lgasedit != null && surnameedit != null && surnameedit.length() > 0 && othernamesedit != null && othernamesedit.length() > 0) {
                    surnameedit = surnameedit.trim().replaceAll("\\s+", " ");
                    othernamesedit = othernamesedit.trim().replaceAll("\\s+", " ");
                    boolean valids = surnameedit.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");
                    boolean valido = othernamesedit.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");

                    if (valids && valido) {
                        try {
                            Applicantsbiodata apb = new Applicantsbiodata(user.getId());
                            apb.setSurname(surnameedit);
                            apb.setOthernames(othernamesedit);
                            apb.setContactAddress(contactaddedit);
                            apb.setDateAdded(settings.getCurrentDateTime());
                            apb.setDateOfBirth(dobedit);
                            apb.setGender(genderedit);
                            apb.setHomeTown(hometownedit);
                            apb.setLga(sess.getLgas(Integer.valueOf(lgasedit)));
                            apb.setState(sess.getStates(Integer.valueOf(statesedit)));
                            apb.setNationality(sess.getCountries(Integer.valueOf(countryedit)));
                            apb.setPhoneno(phonenoedit);

                            sess.updateApplicant(apb);

                            if (fileedit != null && (extedit.contains(".jpg") || extedit.contains(".jpeg") || extedit.contains(".png"))) {
                                String filePath = UPLOAD_DIRECTORY + File.separator + user.getId() + extedit;
                                settings.resizeImage(fileedit, settings.PASSPORT_WIDTH, settings.PASSPORT_HEIGHT, filePath);
                                sess.savePassport(user.getId(), "passports/" + user.getId() + extedit);
                            }

                            // Redirect to dashboard after successful update
                            if (!response.isCommitted()) {
                                response.sendRedirect("/gen_app_dashboard");
                                return;
                            }

                            msg = "Record updated successfully";
                            sty = "success";
                            std = apb;
                        } catch (Exception e) {
                            System.out.println("DEBUG: Error during biodata update: " + e.getMessage());
                            e.printStackTrace();
                            msg = "Error updating record: " + e.getMessage();
                            sty = "danger";
                        }
                    } else {
                        msg = "Your full name " + surnameedit + "," + othernamesedit + " does not look like a person's name. Kindly review and resubmit";
                    }
                }

            %>


            <%                if (button != null && lgas != null && surname != null && surname.length() > 0 && othernames != null && othernames.length() > 0) {
                    System.out.println("DEBUG: Processing new biodata for user: " + user.getId());
                    surname = surname.trim().replaceAll("\\s+", " ");
                    othernames = othernames.trim().replaceAll("\\s+", " ");
                    boolean valids = surname.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");
                    boolean valido = othernames.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");

                    if (valids && valido) {
                        try {
                            System.out.println("DEBUG: Creating new Applicantsbiodata for user: " + user.getId());
                            Applicantsbiodata apb = new Applicantsbiodata(user.getId());
                            apb.setSurname(surname);
                            apb.setOthernames(othernames);
                            apb.setContactAddress(contactadd);
                            apb.setDateAdded(settings.getCurrentDateTime());
                            apb.setDateOfBirth(dob);
                            apb.setGender(gender);
                            apb.setHomeTown(hometown);
                            apb.setLga(sess.getLgas(Integer.valueOf(lgas)));
                            apb.setState(sess.getStates(Integer.valueOf(states)));
                            apb.setNationality(sess.getCountries(Integer.valueOf(country)));
                            apb.setPhoneno(phoneno);

                            sess.newEntry(apb);
                            System.out.println("DEBUG: New biodata created successfully");

                            if (file != null && (ext.contains(".jpg") || ext.contains(".jpeg") || ext.contains(".png"))) {
                                String filePath = UPLOAD_DIRECTORY + File.separator + user.getId() + ext;
                                settings.resizeImage(file, settings.PASSPORT_WIDTH, settings.PASSPORT_HEIGHT, filePath);
                                sess.savePassport(user.getId(), "passports/" + user.getId() + ext);
                            }

                            // Redirect to dashboard after successful creation
                            if (!response.isCommitted()) {
                                response.sendRedirect("/gen_app_dashboard");
                                return;
                            }

                            msg = "Record added successfully";
                            sty = "success";
                            std = apb;
                        } catch (Exception e) {
                            System.out.println("DEBUG: Error during biodata creation: " + e.getMessage());
                            e.printStackTrace();
                            msg = "Error creating record: " + e.getMessage();
                            sty = "danger";
                        }
                    } else {
                        msg = "Your full name " + surname + "," + othernames + " does not look like a person's name. Kindly review and resubmit";
                    }
                }

            %>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <!-- Profile Creation Success Message -->
                    <%                        String profileCreated = request.getParameter("profile_created");
                        if ("true".equals(profileCreated)) {
                    %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle me-3 fs-4"></i>
                            <div>
                                <h6 class="alert-heading mb-1">Profile Created Successfully!</h6>
                                <p class="mb-0">
                                    Welcome to your dashboard! Your profile has been created and you can now start your applications.
                                </p>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                    %>

                    <%
                        // Check if we should show application details instead of the dashboard
                        Boolean showDetails = (Boolean) request.getAttribute("showApplicationDetails");
                        Applicants appToView = (Applicants) request.getAttribute("applicationToView");

                        if (showDetails != null && showDetails && appToView != null) {
                            // Show application details view

                            // Define all completion variables at the beginning
                            // Check if personal details are complete (including qualification and marital status)
                            boolean personalDetailsComplete = appToView.getSurname() != null && !appToView.getSurname().trim().isEmpty()
                                    && appToView.getOthernames() != null && !appToView.getOthernames().trim().isEmpty()
                                    && appToView.getDateOfBirth() != null && appToView.getEmailAddress() != null
                                    && appToView.getStateOfOrigin() != null && appToView.getLga() != null
                                    && appToView.getQualification() != null && !appToView.getQualification().trim().isEmpty()
                                    && appToView.getMaritalStatus() != null && !appToView.getMaritalStatus().trim().isEmpty();

                            // Check guardian information completion
                            boolean guardianComplete = appToView.getGuardianName() != null && !appToView.getGuardianName().trim().isEmpty()
                                    && appToView.getGuardianAddress() != null && !appToView.getGuardianAddress().trim().isEmpty();

                            // Check UTME completion
                            Map<String, Object> utmeDetailsMap = sess.getUtmeDetailsWithSubjectNames(appToView.getId());
                            boolean utmeComplete = !utmeDetailsMap.isEmpty()
                                    && utmeDetailsMap.get("engScore") != null
                                    && utmeDetailsMap.get("subj2Name") != null
                                    && utmeDetailsMap.get("subj3Name") != null
                                    && utmeDetailsMap.get("subj4Name") != null;

                            // Check institutions completion using cached data if available
                            List<Schoolsattended> schoolsAttended = institutionsCache.get(appToView.getId());
                            if (schoolsAttended == null) {
                                schoolsAttended = sess.getSchoolsattendedByRegno(appToView.getId());
                            }
                            boolean institutionsComplete = !schoolsAttended.isEmpty();

                            // Check documents completion using cached data if available
                            List<Uploadeddocuments> documentsSubmitted = documentsCache.get(appToView.getId());
                            if (documentsSubmitted == null) {
                                documentsSubmitted = sess.getUploadeddocumentsByRegno(appToView.getId());
                            }
                            boolean documentsComplete = !documentsSubmitted.isEmpty();

                            // Check payment completion using cached data if available
                            List<Payments> paymentsSubmitted = paymentsCache.get(appToView.getId());
                            if (paymentsSubmitted == null) {
                                paymentsSubmitted = sess.getPaymentsByRegno(appToView.getId());
                            }
                            boolean paymentComplete = !paymentsSubmitted.isEmpty();

                            // Check if this is a remedial application (programme.id = 1015) to show O-level results
                            boolean isRemedialApplication = false;
                            try {
                                if (appToView.getCourse1() != null
                                        && appToView.getCourse1().getSchoolProgrammeId() != null
                                        && appToView.getCourse1().getSchoolProgrammeId().getProgrammeId() != null) {
                                    int programId = appToView.getCourse1().getSchoolProgrammeId().getProgrammeId().getId();
                                    isRemedialApplication = (programId == 1015);
                                }
                            } catch (Exception e) {
                                // Default to false if there's any error
                            }

                            // Get O-level results for remedial applications
                            List<Olevelresults> olevelResults = null;
                            List<Olevelresultsitems> olevelItems = null;
                            long olevelCount = 0;
                            boolean olevelComplete = false;

                            if (isRemedialApplication) {
                                try {
                                    olevelResults = sess.getOlevelresultsByUserId(appToView.getId());
                                    olevelItems = sess.getOlevelresultsItemsByUserId(appToView.getId());
                                    olevelCount = sess.countOlevelSubjectsByUser(appToView.getId());
                                    olevelComplete = olevelCount >= 5; // Minimum 5 O-level subjects required
                                } catch (Exception e) {
                                    olevelResults = new ArrayList<>();
                                    olevelItems = new ArrayList<>();
                                    olevelCount = 0;
                                    olevelComplete = false;
                                }
                            }

                            // Calculate overall completion percentage
                            int totalSections = isRemedialApplication ? 7 : 6; // Add O-level for remedial applications
                            int completedSections = 0;
                            if (personalDetailsComplete) {
                                completedSections++;
                            }
                            if (guardianComplete) {
                                completedSections++;
                            }
                            if (utmeComplete) {
                                completedSections++;
                            }
                            if (isRemedialApplication && olevelComplete) {
                                completedSections++; // Add O-level completion for remedial
                            }
                            if (institutionsComplete) {
                                completedSections++;
                            }
                            if (documentsComplete) {
                                completedSections++;
                            }
                            if (paymentComplete) {
                                completedSections++;
                            }

                            int completionPercentage = (completedSections * 100) / totalSections;

                            // Update completion text via JavaScript
                            String completionText = completedSections + " of " + totalSections + " sections complete (" + completionPercentage + "%)";
                            String completionClass = "text-muted";
                            if (completionPercentage == 100) {
                                completionClass = "text-success";
                            } else if (completionPercentage >= 50) {
                                completionClass = "text-warning";
                            } else {
                                completionClass = "text-danger";
                            }
                    %>

                    <!-- Application Details View -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h2><i class="fas fa-file-alt me-2"></i>Application Details</h2>
                                    <small class="text-muted">
                                        <i class="fas fa-chart-pie me-1"></i>
                                        <span id="completion-text">Loading completion status...</span>
                                    </small>
                                </div>
                                <div>
                                    <a href="/gen_app_dashboard" class="btn btn-secondary me-2">
                                        <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                                    </a>
                                    <%
                                        // Show download button for submitted applications
                                        if (appToView.getStatus() != null
                                                && (appToView.getStatus().equalsIgnoreCase("COMPLETED")
                                                || appToView.getStatus().equalsIgnoreCase("SUBMITTED")
                                                || appToView.getStatus().equalsIgnoreCase("PAID")
                                                || appToView.getStatus().equalsIgnoreCase("REGISTERED"))) {
                                    %>
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(appToView.getId()))%>" 
                                       class="btn btn-primary" target="_blank">
                                        <i class="fas fa-download me-1"></i>Download Application Form
                                    </a>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Application Status Alert -->
                    <%
                        // Determine display status and completion status
                        String displayStatus = "";
                        String completionStatus = "";
                        String alertClass = "";
                        String statusMessage = "";

                        // Check if application has all required data and payment
                        boolean hasPayment = false;
                        boolean hasAllData = true;
                        List<String> missingItems = new ArrayList<>();

                        // Check payment status - use existing variable
                        try {
                            hasPayment = paymentsSubmitted != null && paymentsSubmitted.size() > 0;
                            if (!hasPayment) {
                                missingItems.add("Payment");
                            }
                        } catch (Exception e) {
                            hasPayment = false;
                            missingItems.add("Payment");
                        }

                        // Check if all required data sections are present
                        // Basic personal data
                        if (appToView.getSurname() == null || appToView.getSurname().trim().isEmpty()
                                || appToView.getOthernames() == null || appToView.getOthernames().trim().isEmpty()
                                || appToView.getDateOfBirth() == null || appToView.getEmailAddress() == null) {
                            hasAllData = false;
                            missingItems.add("Personal Details");
                        }

                        // UTME Details and Guardian Information - use existing variables
                        if (!utmeComplete) {
                            hasAllData = false;
                            missingItems.add("UTME Details");
                        }

                        if (!guardianComplete) {
                            hasAllData = false;
                            missingItems.add("Guardian Information");
                        }

                        boolean qualificationComplete = appToView.getQualification() != null && !appToView.getQualification().trim().isEmpty()
                                && appToView.getMaritalStatus() != null && !appToView.getMaritalStatus().trim().isEmpty();

                        if (!qualificationComplete) {
                            hasAllData = false;
                            missingItems.add("Personal Information");
                        }

                        // Institutions Attended - use existing variables
                        if (!institutionsComplete) {
                            hasAllData = false;
                            missingItems.add("Institutions Attended");
                        }

                        // Supporting Documents - use existing variables
                        if (!documentsComplete) {
                            hasAllData = false;
                            missingItems.add("Supporting Documents");
                        }

                        // Determine completion status (for tooltip)
                        // Check if application has been actually submitted (Confirm & Submit completed)
                        boolean hasBeenSubmitted = appToView.getStatus() != null
                                && (appToView.getStatus().equalsIgnoreCase("SUBMITTED")
                                || appToView.getStatus().equalsIgnoreCase("COMPLETED")
                                || appToView.getStatus().equalsIgnoreCase("REGISTERED"));

                        if (hasBeenSubmitted) {
                            completionStatus = "COMPLETED";
                            displayStatus = "SUBMITTED";
                            alertClass = "success";
                            statusMessage = "Your application has been submitted successfully.";
                        } else if (hasAllData && hasPayment) {
                            completionStatus = "READY TO SUBMIT";
                            displayStatus = "READY TO SUBMIT";
                            alertClass = "info";
                            statusMessage = "Your application details and payment are complete. Please confirm and submit your application to finalize the process.";
                        } else {
                            completionStatus = "NOT COMPLETED";
                            displayStatus = "NOT SUBMITTED";
                            alertClass = "warning";
                            statusMessage = "Your application is not yet submitted. Complete all sections and make payment to submit.";
                        }
                    %>
                    <div class="alert alert-<%=alertClass%> mb-4">
                        <p class="mb-0"><%=statusMessage%></p>
                        <%
                            if (!missingItems.isEmpty()) {
                        %>
                        <small class="text-muted">
                            <br><strong>Missing:</strong> 
                            <%
                                for (int i = 0; i < missingItems.size(); i++) {
                                    out.print(missingItems.get(i));
                                    if (i < missingItems.size() - 1) {
                                        out.print(", ");
                                    }
                                }
                            %>
                        </small>
                        <%
                            }
                        %>
                        <%
                            if (hasAllData && hasPayment && !hasBeenSubmitted) {
                                // Show "Go to Confirm & Submit" button when ready to submit
                        %>
                        <br><br>
                        <a href="<%=getApplicationFormUrl(appToView, "submit")%>" class="btn btn-primary btn-sm" style="animation: pulse 2s infinite;">
                            <i class="fas fa-check-circle me-1"></i>Go to Confirm & Submit
                        </a>
                        <%
                            } else if (!hasAllData || !hasPayment) {
                                // Show "Complete Application" button when sections are missing
                        %>
                        <br><br>
                        <a href="<%=getApplicationFormUrl(appToView)%>" class="btn btn-primary btn-sm">
                            <i class="fas fa-edit me-1"></i>Complete Application
                        </a>
                        <%
                            }
                        %>
                    </div>

                    <!-- Personal Details -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-user me-2"></i>Personal Details</h5>
                            <%
                                if (personalDetailsComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                // PERFORMANCE FIX: Use already cached biodata instead of loading again
                                Applicantsbiodata biodata = std;
                                if (biodata == null) {
                                    // Try to get by user ID if not found (fallback)
                                    Users appUser = sess.getUsersByEmail(appToView.getEmailAddress());
                                    if (appUser != null) {
                                        biodata = sess.getApplicantsbiodataById(appUser.getId());
                                    }
                                }

                                if (!personalDetailsComplete) {
                            %>
                            <div class="alert alert-warning mb-3">
                                <i class="fas fa-info-circle me-2"></i>
                                Some personal details are missing. Please complete your profile to proceed with your application.
                                <a href="<%=getApplicationFormUrl(appToView, "personal")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-edit me-1"></i>Complete Personal Details
                                </a>
                            </div>
                            <%
                                }
                            %>
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">Full Name:</th>
                                            <td><%=appToView.getSurname() != null && appToView.getOthernames() != null
                                                    ? appToView.getSurname() + ", " + appToView.getOthernames()
                                                    : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Email Address:</th>
                                            <td><%=appToView.getEmailAddress() != null ? appToView.getEmailAddress() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Phone Number:</th>
                                            <td><%=appToView.getPhoneNo() != null ? appToView.getPhoneNo() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Gender:</th>
                                            <td><%=appToView.getGender() != null ? appToView.getGender() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Date of Birth:</th>
                                            <td><%=appToView.getDateOfBirth() != null ? appToView.getDateOfBirth() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Qualification:</th>
                                            <td><%=appToView.getQualification() != null ? appToView.getQualification() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">State of Origin:</th>
                                            <td><%=appToView.getStateOfOrigin() != null ? appToView.getStateOfOrigin().getName() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>LGA:</th>
                                            <td><%=appToView.getLga() != null ? appToView.getLga().getName() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Home Town:</th>
                                            <td><%=appToView.getHomeTown() != null ? appToView.getHomeTown() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Contact Address:</th>
                                            <td><%=appToView.getContactAddress() != null ? appToView.getContactAddress() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Marital Status:</th>
                                            <td><%=appToView.getMaritalStatus() != null ? appToView.getMaritalStatus() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Details -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5><i class="fas fa-graduation-cap me-2"></i>Course Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">Application ID:</th>
                                            <td><strong><%=appToView.getId()%></strong></td>
                                        </tr>
                                        <tr>
                                            <th>Course of Study:</th>
                                            <td><%=appToView.getCourse1().getName()%></td>
                                        </tr>
                                        <tr>
                                            <th>Faculty:</th>
                                            <td><%=appToView.getCourse1().getDepartmentId().getFacultyId().getName()%></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">Session:</th>
                                            <td><%=appToView.getSession()%></td>
                                        </tr>
                                        <tr>
                                            <th>Application Type:</th>
                                            <td><%=appToView.getApplicationType()%></td>
                                        </tr>
                                        <tr>
                                            <th>Date Initiated:</th>
                                            <td><%=appToView.getDateInitiated() != null ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(appToView.getDateInitiated()) : "N/A"%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Guardian Information -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-user-friends me-2"></i>Sponsor Information</h5>
                            <%
                                if (guardianComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (!guardianComplete) {
                            %>
                            <div class="alert alert-warning mb-3">
                                <i class="fas fa-info-circle me-2"></i>
                                Sponsor information is required. Please provide your Sponsor details.
                                <a href="<%=getApplicationFormUrl(appToView, "guardian")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-edit me-1"></i>Add Sponsor Information
                                </a>
                            </div>
                            <%
                                }
                            %>
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">Sponsor Name:</th>
                                            <td><%=appToView.getGuardianName() != null ? appToView.getGuardianName() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th width="40%">Sponsor Phone</th>
                                            <td><%=appToView.getSponsorPhone() != null ? appToView.getSponsorPhone() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <tr>
                                            <th>Sponsor Address:</th>
                                            <td><%=appToView.getGuardianAddress() != null ? appToView.getGuardianAddress() : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>



                    <!-- UTME Details -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-clipboard-list me-2"></i>UTME Details</h5>
                            <%
                                if (utmeComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (utmeDetailsMap.isEmpty()) {
                            %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                UTME details have not been provided yet.
                                <a href="<%=getApplicationFormUrl(appToView, "utme")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-plus me-1"></i>Add UTME Details
                                </a>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th width="40%">English Score:</th>
                                            <td><%=utmeDetailsMap.get("engScore") != null ? utmeDetailsMap.get("engScore") : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <%
                                            if (utmeDetailsMap.get("subj2Name") != null) {
                                        %>
                                        <tr>
                                            <th>Subject 2:</th>
                                            <td><%=utmeDetailsMap.get("subj2Name")%></td>
                                        </tr>
                                        <tr>
                                            <th>Subject 2 Score:</th>
                                            <td><%=utmeDetailsMap.get("subj2Score") != null ? utmeDetailsMap.get("subj2Score") : "<span class='text-muted'>Not provided</span>"%></td>
                                        </tr>
                                        <%
                                        } else {
                                        %>
                                        <tr>
                                            <th>Subject 2:</th>
                                            <td><span class='text-muted'>Not provided</span></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <%
                                            if (utmeDetailsMap.get("subj3Name") != null) {
                                        %>
                                        <tr>
                                            <th width="40%">Subject 3:</th>
                                            <td><%=utmeDetailsMap.get("subj3Name")%></td>
                                        </tr>
                                        <tr>
                                            <th>Subject 3 Score:</th>
                                            <td><%=utmeDetailsMap.get("subj3Score") != null ? utmeDetailsMap.get("subj3Score") : "N/A"%></td>
                                        </tr>
                                        <%
                                            }
                                            if (utmeDetailsMap.get("subj4Name") != null) {
                                        %>
                                        <tr>
                                            <th>Subject 4:</th>
                                            <td><%=utmeDetailsMap.get("subj4Name")%></td>
                                        </tr>
                                        <tr>
                                            <th>Subject 4 Score:</th>
                                            <td><%=utmeDetailsMap.get("subj4Score") != null ? utmeDetailsMap.get("subj4Score") : "N/A"%></td>
                                        </tr>
                                        <%
                                            }
                                            if (utmeDetailsMap.get("totalUtme") != null) {
                                        %>
                                        <tr>
                                            <th><strong>Total UTME Score:</strong></th>
                                            <td><strong><%=utmeDetailsMap.get("totalUtme")%></strong></td>
                                        </tr>
                                        <%
                                            }
                                            if (utmeDetailsMap.get("postUtme") != null && !utmeDetailsMap.get("postUtme").equals(0)) {
                                        %>
                                        <tr>
                                            <th><strong>Post UTME Score:</strong></th>
                                            <td><strong><%=utmeDetailsMap.get("postUtme")%></strong></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </table>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!-- O-Level Results (for Remedial Applications only) -->
                    <%
                        if (isRemedialApplication) {
                    %>
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-graduation-cap me-2"></i>O-Level Results 
                                <%=olevelCount > 0 ? "(" + olevelCount + "/9 subjects)" : ""%>
                            </h5>
                            <%
                                if (olevelComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (olevelResults == null || olevelResults.isEmpty()) {
                            %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No O-level results have been provided yet. Please add your O-level examination results.
                                <a href="<%=getApplicationFormUrl(appToView, "details")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-plus me-1"></i>Add O-Level Results
                                </a>
                            </div>
                            <%
                            } else {
                                // Group O-level items by sitting
                                Map<String, List<Olevelresultsitems>> itemsBySitting = new HashMap<>();
                                Map<String, Olevelresults> sittingData = new HashMap<>();

                                for (Olevelresultsitems item : olevelItems) {
                                    String sitting = item.getOlevelResultsId().getSitting();
                                    itemsBySitting.computeIfAbsent(sitting, k -> new ArrayList<>()).add(item);
                                    sittingData.put(sitting, item.getOlevelResultsId());
                                }
                            %>
                            <div class="row mb-3">
                                <div class="col-12">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="mb-0"><i class="fas fa-check-circle text-success me-2"></i>Your O-Level Results (<%=olevelCount%>/9 subjects)</h6>
                                        <a href="<%=getApplicationFormUrl(appToView, "details")%>" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-plus me-1"></i>Add More Subjects
                                        </a>
                                    </div>

                                    <%
                                        for (String sitting : itemsBySitting.keySet()) {
                                            List<Olevelresultsitems> sittingItems = itemsBySitting.get(sitting);
                                            Olevelresults sittingResult = sittingData.get(sitting);
                                    %>
                                    <div class="mb-4">
                                        <h6 class="text-primary mb-2">
                                            <i class="fas fa-calendar-alt me-1"></i><%=sitting%> Sitting 
                                            <span class="badge bg-info ms-2"><%=sittingItems.size()%> subjects</span>
                                        </h6>

                                        <!-- Sitting Details -->
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless">
                                                    <tr>
                                                        <th width="40%">Exam Name:</th>
                                                        <td><%=sittingResult.getName() != null ? sittingResult.getName() : "N/A"%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Result Type:</th>
                                                        <td><%=sittingResult.getResultType() != null ? sittingResult.getResultType().toUpperCase() : "N/A"%></td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless">
                                                    <tr>
                                                        <th width="40%">Registration No:</th>
                                                        <td><%=sittingResult.getRegistrationNo() != null ? sittingResult.getRegistrationNo() : "N/A"%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Exam Date:</th>
                                                        <td><%=sittingResult.getExamDate() != null ? sittingResult.getExamDate() : "N/A"%></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>

                                        <!-- Subjects and Grades -->
                                        <div class="row">
                                            <%
                                                for (Olevelresultsitems item : sittingItems) {
                                            %>
                                            <div class="col-md-3 col-sm-4 col-6 mb-2">
                                                <div class="d-flex align-items-center">
                                                    <span class="badge bg-success me-2" style="min-width: 25px;"><%=item.getGrade() != null ? item.getGrade().getId() : "N/A"%></span>
                                                    <small class="text-truncate"><%=item.getSubject() != null ? item.getSubject() : "N/A"%></small>
                                                </div>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    %>

                                    <%
                                        if (olevelCount < 9) {
                                    %>
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Note:</strong> You can add up to <%=(9 - olevelCount)%> more O-level subject(s). 
                                        Maximum of 9 subjects allowed across both sittings.
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <%
                        }
                    %>

                    <!-- Institutions Attended -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-school me-2"></i>Institutions Attended 
                                <%=!schoolsAttended.isEmpty() ? "(" + schoolsAttended.size() + ")" : ""%>
                            </h5>
                            <%
                                if (institutionsComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (schoolsAttended.isEmpty()) {
                            %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No institutions have been added yet. Please add at least one institution you attended.
                                <a href="<%=getApplicationFormUrl(appToView, "institutions")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-plus me-1"></i>Add Institution
                                </a>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <small class="text-muted">You have added <%=schoolsAttended.size()%> institution(s)</small>
                                <a href="<%=getApplicationFormUrl(appToView, "institutions")%>" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-plus me-1"></i>Add More Institutions
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Institution Name</th>
                                            <th>Start Date</th>
                                            <th>End Date</th>
                                            <th>Qualification</th>
                                            <th>Year of Award</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
                                            for (Schoolsattended school : schoolsAttended) {
                                        %>
                                        <tr>
                                            <td><%=school.getName()%></td>
                                            <td><%=school.getStartDate() != null ? dateFormatter.format(school.getStartDate()) : "N/A"%></td>
                                            <td><%=school.getEndDate() != null ? dateFormatter.format(school.getEndDate()) : "N/A"%></td>
                                            <td><%=school.getQualification() != null ? school.getQualification() : "N/A"%></td>
                                            <td><%=school.getYearOfAward() != null ? school.getYearOfAward() : "N/A"%></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!-- Documents Submitted -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-file-upload me-2"></i>Documents Submitted 
                                <%=!documentsSubmitted.isEmpty() ? "(" + documentsSubmitted.size() + ")" : ""%>
                            </h5>
                            <%
                                if (documentsComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Complete</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-warning"><i class="fas fa-exclamation-triangle me-1"></i>Incomplete</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (documentsSubmitted.isEmpty()) {
                            %>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No documents have been uploaded yet. Please upload required supporting documents.
                                <a href="<%=getApplicationFormUrl(appToView, "documents")%>" class="btn btn-sm btn-primary ms-2">
                                    <i class="fas fa-upload me-1"></i>Upload Documents
                                </a>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <small class="text-muted">You have uploaded <%=documentsSubmitted.size()%> document(s)</small>
                                <a href="<%=getApplicationFormUrl(appToView, "documents")%>" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-plus me-1"></i>Upload More Documents
                                </a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Document Name</th>
                                            <th>Date Uploaded</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Uploadeddocuments doc : documentsSubmitted) {
                                        %>
                                        <tr>
                                            <td><%=doc.getName()%></td>
                                            <td><%=doc.getDateAdded() != null ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(doc.getDateAdded()) : "N/A"%></td>
                                            <td>
                                                <a href="<%=settings.docUrl%>/<%=doc.getUrl()%>" target="_blank" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i>View
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!-- Payment Status -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-credit-card me-2"></i>Payment Status</h5>
                            <%
                                if (paymentComplete) {
                            %>
                            <span class="badge bg-success"><i class="fas fa-check me-1"></i>Paid</span>
                            <%
                            } else {
                            %>
                            <span class="badge bg-danger"><i class="fas fa-exclamation-triangle me-1"></i>Unpaid</span>
                            <%
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                if (paymentsSubmitted.isEmpty()) {
                            %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                No payment has been made for this application. Payment is required to submit your application.
                                <a href="/app_payment?id=<%=settings.encodeUrl(settings.encryptText(appToView.getId()))%>" class="btn btn-sm btn-success ms-2">
                                    <i class="fas fa-credit-card me-1"></i>Make Payment Now
                                </a>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="alert alert-success mb-3">
                                <i class="fas fa-check-circle me-2"></i>
                                Payment has been completed for this application.
                            </div>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Payment Reference</th>
                                            <th>Amount</th>
                                            <th>Date Paid</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (Payments payment : paymentsSubmitted) {
                                        %>
                                        <tr>
                                            <td><%=payment.getId()%></td>
                                            <td>₦<%=String.format("%,.2f", payment.getAmount())%></td>
                                            <td><%=payment.getDatePaid() != null ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(payment.getDatePaid()) : "N/A"%></td>
                                            <td><span class="badge bg-success">Paid</span></td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <%
                        // Determine what actions are needed using existing variables
                        List<String> neededActions = new ArrayList<>();
                        if (!personalDetailsComplete) {
                            neededActions.add("Complete Personal Details");
                        }
                        if (!guardianComplete) {
                            neededActions.add("Add Guardian Information");
                        }
                        if (!utmeComplete) {
                            neededActions.add("Add UTME Details");
                        }
                        if (isRemedialApplication && !olevelComplete) {
                            neededActions.add("Add O-Level Results");
                        }
                        if (!institutionsComplete) {
                            neededActions.add("Add Institution Details");
                        }
                        if (!documentsComplete) {
                            neededActions.add("Upload Documents");
                        }
                        if (!paymentComplete) {
                            neededActions.add("Make Payment");
                        }

                        if (!neededActions.isEmpty()) {
                    %>
                    <div class="card mb-4 border-warning">
                        <div class="card-header bg-warning text-dark">
                            <h5><i class="fas fa-tasks me-2"></i>Actions Required</h5>
                        </div>
                        <div class="card-body">
                            <p class="mb-3">Complete the following to submit your application:</p>
                            <div class="row">
                                <%
                                    for (int i = 0; i < neededActions.size(); i++) {
                                        String action = neededActions.get(i);
                                        String buttonClass = action.equals("Make Payment") ? "btn-success" : "btn-primary";
                                        String icon = "fas fa-edit";
                                        String url = getApplicationFormUrl(appToView);

                                        // Set specific section parameters and icons based on action
                                        if (action.equals("Make Payment")) {
                                            icon = "fas fa-credit-card";
                                            url = "/app_payment?id=" + settings.encodeUrl(settings.encryptText(appToView.getId()));
                                        } else if (action.equals("Complete Personal Details")) {
                                            url = getApplicationFormUrl(appToView, "personal");
                                            icon = "fas fa-user";
                                        } else if (action.equals("Add Guardian Information")) {
                                            url = getApplicationFormUrl(appToView, "guardian");
                                            icon = "fas fa-user-friends";
                                        } else if (action.equals("Add UTME Details")) {
                                            url = getApplicationFormUrl(appToView, "utme");
                                            icon = "fas fa-clipboard-list";
                                        } else if (action.equals("Add O-Level Results")) {
                                            url = getApplicationFormUrl(appToView, "details");
                                            icon = "fas fa-graduation-cap";
                                        } else if (action.equals("Add Institution Details")) {
                                            url = getApplicationFormUrl(appToView, "institutions");
                                            icon = "fas fa-school";
                                        } else if (action.equals("Upload Documents")) {
                                            url = getApplicationFormUrl(appToView, "documents");
                                            icon = "fas fa-file-upload";
                                        }
                                %>
                                <div class="col-md-6 col-lg-4 mb-2">
                                    <a href="<%=url%>" class="btn <%=buttonClass%> btn-sm w-100">
                                        <i class="<%=icon%> me-1"></i><%=action%>
                                    </a>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <div class="card mb-4 border-success">
                        <div class="card-header bg-success text-white">
                            <h5><i class="fas fa-check-circle me-2"></i>Application Complete</h5>
                        </div>
                        <div class="card-body">
                            <%
                                if (hasBeenSubmitted) {
                            %>
                            <p class="mb-0">
                                <i class="fas fa-thumbs-up me-2 text-success"></i>
                                Congratulations! Your application is complete and has been submitted successfully.
                            </p>
                            <%
                                } else {
                            %>
                            <p class="mb-0">
                                <i class="fas fa-check-circle me-2 text-success"></i>
                                Excellent! All required sections have been completed. Your application is ready for final submission.
                            </p>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <%
                        }

                        // Calculate completion percentage for JavaScript using existing variables
                        int totalSectionsJS = isRemedialApplication ? 7 : 6; // Add O-level for remedial applications
                        int completedSectionsJS = 0;
                        if (personalDetailsComplete) {
                            completedSectionsJS++;
                        }
                        if (guardianComplete) {
                            completedSectionsJS++;
                        }
                        if (utmeComplete) {
                            completedSectionsJS++;
                        }
                        if (isRemedialApplication && olevelComplete) {
                            completedSectionsJS++; // Add O-level completion for remedial
                        }
                        if (institutionsComplete) {
                            completedSectionsJS++;
                        }
                        if (documentsComplete) {
                            completedSectionsJS++;
                        }
                        if (paymentComplete) {
                            completedSectionsJS++;
                        }

                        int completionPercentageJS = (completedSectionsJS * 100) / totalSectionsJS;
                        String completionTextJS = completedSectionsJS + " of " + totalSectionsJS + " sections complete (" + completionPercentageJS + "%)";
                        String completionClassJS = "text-muted";
                        if (completionPercentageJS == 100) {
                            completionClassJS = "text-success";
                        } else if (completionPercentageJS >= 50) {
                            completionClassJS = "text-warning";
                        } else {
                            completionClassJS = "text-danger";
                        }
                    %>

                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const completionElement = document.getElementById('completion-text');
                            if (completionElement) {
                                completionElement.innerHTML = '<%=completionTextJS%>';
                                completionElement.className = '<%=completionClassJS%>';
                            }
                        });
                    </script>

                    <%
                    } else {
                        // Show normal dashboard content
                    %>
                    <%
                        if (msg != null && msg.length() > 0) {
                    %>
                    <div class="alert alert-<%=sty%>"><%=msg%></div>
                    <%
                        }
                    %>
                    <%
                        if (std != null) {
                    %>

                    <div class="card mb-4">
                        <%                                                String school = request.getParameter("school");
                            String prog = request.getParameter("prog");
                            String courses = request.getParameter("courses");
                            String button2 = request.getParameter("button2");
                            if (button2 != null && button2.length() > 0) {
                                System.out.println("DEBUG: Starting application creation for school: " + school + ", course: " + courses);

                                // Check for duplicate application first
                                boolean hasDuplicate = sess.hasDuplicateApplicationForCourse(user.getEmail(), courses);
                                if (hasDuplicate) {
                                    Applicants existingApp = sess.getExistingApplicationForCourse(user.getEmail(), courses);
                                    Courses existingCourse = sess.getCourses(courses);
                        %>
                        <div class="alert alert-warning">
                            <h5><i class="fas fa-exclamation-triangle me-2"></i>Duplicate Application Detected</h5>
                            <p>You already have an application for <strong><%=existingCourse.getName()%></strong>.</p>
                            <p><strong>Existing Application ID:</strong> <%=existingApp.getId()%></p>
                            <p><strong>Status:</strong> <span class="badge bg-info"><%=existingApp.getStatus()%></span></p>
                            <p><strong>Session:</strong> <%=existingApp.getSession()%></p>
                            <hr>
                            <p class="mb-0">
                                <strong>Options:</strong>
                                <a href="/gen_app_dashboard?id=<%=settings.encodeUrl(settings.encryptText(existingApp.getId()))%>" class="btn btn-primary btn-sm ms-2">
                                    <i class="fas fa-eye me-1"></i>View Existing Application
                                </a>
                            </p>
                        </div>
                        <%
                        } else {
                            try {
                                Sessionmanager smd = sess.getCurrentSessionManagerBySchoolAndOperation(school, "APPLICATION");
                                System.out.println("DEBUG: Session manager found: " + (smd != null ? smd.getName() : "null"));
                                if (smd != null && smd.getStatus().equalsIgnoreCase("OPEN")) {
                                    //String id = std.getId() + settings.generateId("", 4);
                                    // Generate application ID with null-safe abbreviation
                                    String schoolAbbr = smd.getSchoolId().getAbbreviation();
                                    System.out.println("DEBUG: School abbreviation: " + schoolAbbr);
                                    System.out.println("DEBUG: School ID: " + smd.getSchoolId().getId());
                                    System.out.println("DEBUG: Session name: " + smd.getName());

                                    if (schoolAbbr == null || schoolAbbr.trim().isEmpty()) {
                                        schoolAbbr = smd.getSchoolId().getId(); // Use school ID as fallback
                                        System.out.println("DEBUG: Using school ID as abbreviation: " + schoolAbbr);
                                    }
                                    String id = schoolAbbr.toLowerCase() + smd.getName().split("/")[1].substring(2, 4) + settings.generateId("", 5);
                                    System.out.println("DEBUG: Generated application ID: " + id);
                                    Applicants app = new Applicants(id);
                                    Courses cos = sess.getCourses(courses);
                                    Programmes progd = cos.getSchoolProgrammeId().getProgrammeId();

                                    String apptype = progd.getCode();
                                    app.setApplicationType(apptype);
                                    app.setContactAddress(std.getContactAddress());
                                    app.setCountry(std.getNationality());
                                    app.setCourse1(cos);
                                    app.setDateInitiated(settings.getCurrentDateTime());
                                    app.setDateOfBirth(std.getDateOfBirth());
                                    app.setEmailAddress(std.getUsers().getEmail());
                                    app.setGender(std.getGender());
                                    app.setHomeTown(std.getHomeTown());
                                    app.setLga(std.getLga());
                                    app.setOthernames(std.getOthernames());
                                    app.setPhoneNo(std.getPhoneno());
                                    app.setProgrammeId(cos.getSchoolProgrammeId().getProgrammeId());
                                    app.setSchoolId(cos.getSchoolProgrammeId().getSchoolId());
                                    app.setSession(smd.getName());
                                    app.setStateOfOrigin(std.getState());
                                    app.setStatus("NOT SUBMITTED");
                                    app.setSurname(std.getSurname());
                                    sess.newEntry(app);
                        %>
                        <div class="alert alert-success">
                            <h5><i class="fas fa-check-circle me-2"></i>Application Created Successfully!</h5>
                            <p>Your application for <strong><%=cos.getName()%></strong> in the <%=smd.getName()%> session has been initiated.</p>
                            <p><strong>Application ID:</strong> <%=id%></p>
                            <p class="mb-0">
                                <a href="/gen_app_dashboard?id=<%=settings.encodeUrl(settings.encryptText(id))%>" class="btn btn-primary">
                                    <i class="fas fa-eye me-1"></i>View Application Details
                                </a>
                            </p>
                        </div>
                        <%
                        } else if (smd != null) {
                        %>
                        <div class="alert alert-danger">Session <%=smd.getName()%> for application has been closed for <%=smd.getSchoolId().getName()%></div>
                        <%
                        } else {
                        %>
                        <div class="alert alert-danger">No active session found for the selected school. Please contact the administrator.</div>
                        <%
                                        }

                                    } catch (Exception k) {
                                        System.out.println("DEBUG: Error in application creation: " + k.getMessage());
                                        k.printStackTrace();
                                    }
                                } // Close the else block for duplicate check
                            } // Close the main if (button2 != null) block


                        %>

                        <div class="card-header">

                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>
                            <%
                                // Only get session manager for the existing school S001
                                Sessionmanager smmain = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
                                String st = "";
                                String stc5 = (smmain != null && smmain.getStatus().equalsIgnoreCase("OPEN")) ? "success" : "danger";
                                String c5 = "<span class=\"alert alert-" + stc5 + "\">"
                                        + (smmain != null ? smmain.getStatus() : "CLOSED")
                                        + "</span><br/>";
                            %>

                            <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Statuses of Active Sessions</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="table-responsive-sm">
                                                <table class="table table-striped table-hover" id='dataTable'>
                                                    <thead>
                                                        <tr>
                                                            <th class="center">#</th>
                                                            <th>School</th>
                                                            <th>Current Session</th>
                                                            <th>Application Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            if (smmain != null) {
                                                        %>
                                                        <tr>
                                                            <td>1</td>
                                                            <td><%=smmain.getSchoolId().getName()%></td>
                                                            <td><%=smmain.getName()%></td>
                                                            <td><%=c5%></td>
                                                        </tr>
                                                        <%
                                                        } else {
                                                        %>
                                                        <tr>
                                                            <td>1</td>
                                                            <td>School S001</td>
                                                            <td>No Active Session</td>
                                                            <td><span class="alert alert-danger">CLOSED</span></td>
                                                        </tr>
                                                        <%
                                                            }
                                                        %>
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

                            <div class="modal fade" id="payments" tabindex="-1" aria-labelledby="paymentsLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="paymentsLabel">My Payments</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <%
                                                // Calculate total payments for summary using cached data
                                                try {
                                                    List<Payments> allPayments = new ArrayList<>();

                                                    // Use cached payment data instead of making new queries
                                                    for (Applicants applicant : userApplications) {
                                                        List<Payments> applicantPayments = paymentsCache.get(applicant.getId());
                                                        if (applicantPayments != null) {
                                                            allPayments.addAll(applicantPayments);
                                                        }
                                                    }

                                                    double totalAmount = allPayments.stream().mapToDouble(Payments::getAmount).sum();
                                                    int totalPayments = allPayments.size();
                                            %>

                                            <!-- Payment Summary Card -->
                                            <div class="card mb-3 border-success">
                                                <div class="card-body">
                                                    <div class="row text-center">
                                                        <div class="col-md-6">
                                                            <h5 class="text-success">Total Payments</h5>
                                                            <h3 class="text-primary"><%=totalPayments%></h3>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <h5 class="text-success">Total Amount</h5>
                                                            <h3 class="text-success">₦<%=settings.formatno.format(totalAmount)%></h3>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%
                                                } catch (Exception ex) {
                                                    // Handle summary calculation error
                                                }
                                            %>

                                            <div class="table-responsive-sm">
                                                <table class="table table-striped table-hover" id='dataTable'>
                                                    <thead>
                                                        <tr>
                                                            <th class="center">#</th>
                                                            <th>Application ID</th>
                                                            <th>Payment Ref</th>
                                                            <th>Date</th>
                                                            <th>Amount</th>
                                                            <th>Purpose</th>
                                                            <th>Download Receipt</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            try {
                                                                // Use cached applicant and payment data
                                                                List<Payments> lpay = new ArrayList<>();

                                                                // Collect payments from cached data
                                                                for (Applicants applicant : userApplications) {
                                                                    List<Payments> applicantPayments = paymentsCache.get(applicant.getId());
                                                                    if (applicantPayments != null) {
                                                                        lpay.addAll(applicantPayments);
                                                                    }
                                                                }

                                                                // Sort payments by date (most recent first)
                                                                lpay.sort(( p1,   p2) -> p2.getDatePaid().compareTo(p1.getDatePaid()));

                                                                int k = 1;
                                                                for (Payments payd : lpay) {
                                                        %>
                                                        <tr>
                                                            <td><%=k%></td>
                                                            <td><span class="badge bg-info"><%=payd.getPayerId()%></span></td>
                                                            <td><%=payd.getId()%></td>
                                                            <%
                                                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                                String formattedDate = sdf.format(payd.getDatePaid());
                                                            %>
                                                            <td><%=formattedDate%></td>
                                                            <td class="right"><strong>₦<%=settings.formatno.format(payd.getAmount())%></strong></td>
                                                            <td><%=payd.getFeesGroupId().getName()%></td>

                                                            <td><a href="/DownloadReceipt?id=<%=payd.getId()%>" target="_blank" class="btn btn-success btn-sm">Download</a></td>
                                                        </tr>
                                                        <%
                                                                    k++;
                                                                }
                                                            } catch (Exception k) {
                                                            }
                                                        %>


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

                            <!-- Modal -->
                            <div class="modal fade" id="newapp" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">New Application</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">

                                            <div class="alert alert-info">Kindly select School and programme so we can provide available courses for you</div>
                                            <form name="edit" method="post" action="">
                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Select School   
                                                    </span>
                                                    <select class="form-select" name="school" id="school" onchange="loadProgrammes();">
                                                        <option value="">Select School</option>
                                                        <%
                                                            try {
                                                                // Get all schools - TODO: Cache this data at application level for better performance
                                                                List<Schools> allSchools = sess.getAllSchoos();
                                                                for (Schools schoolItem : allSchools) {
                                                                    // Check if this school has an active session manager
                                                                    // TODO: Optimize by batch-loading session managers for all schools
                                                                    Sessionmanager schoolSession = null;
                                                                    String dis = "";
                                                                    String lab = "";

                                                                    try {
                                                                        schoolSession = sess.getCurrentSessionManagerBySchoolAndOperation(schoolItem.getId(), "APPLICATION");
                                                                        if (schoolSession != null && schoolSession.getStatus().equalsIgnoreCase("CLOSED")) {
                                                                            dis = " disabled ";
                                                                            lab = " (application closed for " + schoolSession.getName() + ")";
                                                                        }
                                                                    } catch (Exception e) {
                                                                        // No active session for this school - still show it but note it
                                                                        lab = " (no active session)";
                                                                    }
                                                        %>
                                                        <option value="<%=schoolItem.getId()%>" <%=dis%>><%=schoolItem.getName()%> <%=lab%></option>
                                                        <%
                                                            }
                                                        } catch (Exception k) {
                                                            System.out.println("DEBUG: Error loading school dropdown: " + k.getMessage());
                                                            k.printStackTrace();
                                                            // Fallback to original logic if there's an error
                                                            if (smmain != null) {
                                                                String dis = "";
                                                                String lab = "";
                                                                if (smmain.getStatus().equalsIgnoreCase("CLOSED")) {
                                                                    dis = " disabled ";
                                                                    lab = " (application closed for " + smmain.getName() + ")";
                                                                }
                                                        %>
                                                        <option value="<%=smmain.getSchoolId().getId()%>" <%=dis%>><%=smmain.getSchoolId().getName()%> <%=lab%></option>
                                                        <%
                                                        } else {
                                                            // Show S001 even if no session manager exists
                                                        %>
                                                        <option value="S001" disabled>School S001 (no active session)</option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Select Programme Type 
                                                    </span>
                                                    <select class="form-select" name="prog" id="prog" onchange="loadCourses();">

                                                    </select>
                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Select Programme
                                                    </span>
                                                    <select class="form-select" name="courses" id="courses">

                                                    </select>
                                                </div>

                                                <div class="row">
                                                    <div class="col-6">
                                                        <input type="submit" name="button2" class="btn btn-success px-4" value="Start Application"/>
                                                    </div>
                                                </div>

                                            </form>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal fade" id="editprofile" tabindex="-1" aria-labelledby="editprofileLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="editprofileLabel">Edit My Profile</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="" method="POST" role="form" name="editProfile" enctype="multipart/form-data">

                                                <div class="input-group mb-3">
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
                                                </div>
                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Surname  
                                                    </span>
                                                    <input class="form-control" type="text" name="surnameedit" value="<%=std.getSurname()%>" minlength="2" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Other Names
                                                    </span>
                                                    <input class="form-control" value="<%=std.getOthernames()%>" type="text" minlength="2" required="" name="othernamesedit">
                                                </div>
                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Gender    
                                                    </span>
                                                    <select class="form-select" name="genderedit">
                                                        <option value="Male" <%=std.getGender().equalsIgnoreCase("Male") ? "selected=\"\"" : ""%>>Male</option>
                                                        <option value="Female" <%=std.getGender().equalsIgnoreCase("Female") ? "selected=\"\"" : ""%>>Female</option>
                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Date of Birth  
                                                    </span>
                                                    <input class="form-control" type="date" name="dobedit" value="<%=std.getDateOfBirth()%>" min="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 90)%>" max="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 16)%>" readonly>
                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Phone Number 
                                                    </span>
                                                    <input class="form-control" type="tel" minlength="11" maxlength="13" name="phonenoedit" value="<%=std.getPhoneno()%>" readonly>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Contact Address 
                                                    </span>
                                                    <input class="form-control" type="text" name="contactaddedit" value="<%=std.getContactAddress()%>" >
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Home Town    
                                                    </span>
                                                    <input class="form-control" type="text"  name="hometownedit" value="<%=std.getHomeTown()%>">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Country 
                                                    </span>
                                                    <select class="form-select" name="countryedit" id="countryedit" onchange="loadStatesEdit();">
                                                        <%
                                                            try {
                                                                // TODO: Optimize with lazy loading - load countries via AJAX when modal opens
                                                                List<Countries> col = sess.getAllCountries();
                                                                for (Countries co : col) {
                                                                    String sel = "";
                                                                    if (co.getId() == std.getNationality().getId()) {
                                                                        sel = "selected = \"\"";
                                                                    }
                                                        %>
                                                        <option value="<%=co.getId()%>" <%=sel%>><%=co.getName()%></option>
                                                        <%
                                                                }
                                                            } catch (Exception k) {
                                                            }
                                                        %>


                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        State of Origin   
                                                    </span>

                                                    <select class="form-select" name="statesedit" id="statesedit" onchange="loadLgasEdit();">
                                                        <%
                                                            if (std.getState() != null) {
                                                        %>
                                                        <option value="<%=std.getState().getId()%>" selected="" ><%=std.getState().getName()%></option>
                                                        <%
                                                            }

                                                            try {
                                                                List<States> col = sess.getAllStatesInCountry(1173);
                                                                for (States co : col) {
                                                                    String sel = "";
                                                                    if (co.getId() == std.getState().getId()) {
                                                                        sel = "selected = \"\"";
                                                                    }
                                                        %>
                                                        <option value="<%=co.getId()%>" <%=sel%>><%=co.getName()%></option>
                                                        <%
                                                                }
                                                            } catch (Exception k) {
                                                            }
                                                        %>


                                                    </select>
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Local Government Area   
                                                    </span>

                                                    <select class="form-select" id="lgasedit" name="lgasedit">
                                                        <%
                                                            if (std.getLga() != null) {
                                                        %>
                                                        <option value="<%=std.getLga().getId()%>" selected=""><%=std.getLga().getName()%></option>
                                                        <%
                                                            }
                                                            try {
                                                                List<Lgas> col = sess.getAllLgasInStte(10035);
                                                                for (Lgas co : col) {

                                                        %>
                                                        <option value="<%=co.getId()%>"><%=co.getName()%></option>
                                                        <%
                                                                }
                                                            } catch (Exception k) {
                                                            }
                                                        %>


                                                    </select>
                                                </div>

                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Upload Passport (Optional)
                                                    </span>
                                                    <input class="form-control" type="file" name="passportedit" accept=".jpg, .png, .jpeg">
                                                </div>


                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="buttonedit" class="btn btn-primary px-4" value="Edit Biodata"/>
                                                    </div>

                                                </div>

                                            </form>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class="card-body">
                            <!-- Application Statistics Cards -->
                            <%
                                // Calculate statistics
                                int totalApplications = 0;
                                int paidApplications = 0;
                                int unpaidApplications = 0;
                                int completedApplications = 0;
                                int notCompletedApplications = 0;
                                int pendingApplications = 0;

                                // Use cached data instead of making new queries
                                List<Applicants> list = userApplications;
                                totalApplications = list.size();

                                for (Applicants app : list) {
                                    // Count payment status using cached data
                                    try {
                                        List<Payments> applicantPayments = paymentsCache.get(app.getId());
                                        if (applicantPayments != null && !applicantPayments.isEmpty()) {
                                            paidApplications++;
                                        } else {
                                            unpaidApplications++;
                                        }
                                    } catch (Exception ex) {
                                        unpaidApplications++;
                                    }

                                    // Count application status
                                    if (app.getStatus().equalsIgnoreCase("SUBMITTED")
                                            || app.getStatus().equalsIgnoreCase("COMPLETED")) {
                                        completedApplications++;
                                    } else if (app.getStatus().equalsIgnoreCase("NOT SUBMITTED")
                                            || app.getStatus().equalsIgnoreCase("NOT COMPLETED")) {
                                        notCompletedApplications++;
                                    } else if (app.getStatus().equalsIgnoreCase("PENDING")) {
                                        pendingApplications++;
                                    }
                                }

                                // Calculate progress percentage
                                double progressPercentage = totalApplications > 0 ? (double) completedApplications / totalApplications * 100 : 0;
                            %>

                            <div class="row mb-4">
                                <!-- Payment Status Cards -->
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-success text-white h-100">
                                        <div class="card-body text-center">
                                            <div class="display-6 fw-bold"><%=paidApplications%></div>
                                            <div class="small">
                                                <i class="fas fa-check-circle me-1"></i>
                                                PAID Applications
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3 mb-3">
                                    <div class="card bg-danger text-white h-100">
                                        <div class="card-body text-center">
                                            <div class="display-6 fw-bold"><%=unpaidApplications%></div>
                                            <div class="small">
                                                <i class="fas fa-times-circle me-1"></i>
                                                UNPAID Applications
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Application Status Cards -->
                                <div class="col-md-3 mb-3">
                                    <div class="card bg-primary text-white h-100">
                                        <div class="card-body text-center">
                                            <div class="display-6 fw-bold"><%=completedApplications%></div>
                                            <div class="small">
                                                <i class="fas fa-clipboard-check me-1"></i>
                                                SUBMITTED Applications
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-3 mb-3">
                                    <div class="card bg-warning text-white h-100">
                                        <div class="card-body text-center">
                                            <div class="display-6 fw-bold"><%=notCompletedApplications%></div>
                                            <div class="small">
                                                <i class="fas fa-clipboard-list me-1"></i>
                                                NOT SUBMITTED Applications
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Application Progress Card -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="fas fa-chart-line me-2"></i>
                                                Application Progress Overview
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <div class="d-flex justify-content-between mb-2">
                                                        <span>Overall Progress</span>
                                                        <span class="fw-bold"><%=String.format("%.1f", progressPercentage)%>%</span>
                                                    </div>
                                                    <div class="progress mb-3" style="height: 20px;">
                                                        <div class="progress-bar bg-success" role="progressbar" 
                                                             id="progressBar"
                                                             aria-valuenow="<%=String.format("%.1f", progressPercentage)%>" 
                                                             aria-valuemin="0" 
                                                             aria-valuemax="100">
                                                        </div>
                                                    </div>
                                                    <script>
                                                        document.getElementById('progressBar').style.width = '<%=String.format("%.1f", progressPercentage)%>%';
                                                    </script>
                                                    <div class="row text-center">
                                                        <div class="col-4">
                                                            <div class="text-success fw-bold"><%=completedApplications%></div>
                                                            <small class="text-muted">Submitted</small>
                                                        </div>
                                                        <div class="col-4">
                                                            <div class="text-warning fw-bold"><%=notCompletedApplications%></div>
                                                            <small class="text-muted">In Progress</small>
                                                        </div>
                                                        <div class="col-4">
                                                            <div class="text-info fw-bold"><%=pendingApplications%></div>
                                                            <small class="text-muted">Pending</small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-center">
                                                    <div class="display-4 text-primary fw-bold"><%=totalApplications%></div>
                                                    <div class="text-muted">Total Applications</div>
                                                    <% if (totalApplications == 0) { %>
                                                    <div class="mt-3">
                                                        <button class="btn btn-success" data-coreui-toggle="modal" data-coreui-target="#newapp">
                                                            <i class="fas fa-plus me-1"></i>
                                                            Start Your First Application
                                                        </button>
                                                    </div>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Application Statistics Cards -->
                            <%
                                // Calculate statistics
                                totalApplications = 0;
                                paidApplications = 0;
                                 unpaidApplications = 0;
                                completedApplications = 0;
                             notCompletedApplications = 0;
                                 pendingApplications = 0;

                                // Use cached data instead of making new queries
                                list = userApplications;
                                totalApplications = list.size();

                                for (Applicants app : list) {
                                    // Count payment status using cached data
                                    try {
                                        List<Payments> applicantPayments = paymentsCache.get(app.getId());
                                        if (applicantPayments != null && !applicantPayments.isEmpty()) {
                                            paidApplications++;
                                        } else {
                                            unpaidApplications++;
                                        }
                                    } catch (Exception ex) {
                                        unpaidApplications++;
                                    }

                                    // Count application status
                                    if (app.getStatus().equalsIgnoreCase("SUBMITTED")
                                            || app.getStatus().equalsIgnoreCase("COMPLETED")) {
                                        completedApplications++;
                                    } else if (app.getStatus().equalsIgnoreCase("NOT SUBMITTED")
                                            || app.getStatus().equalsIgnoreCase("NOT COMPLETED")) {
                                        notCompletedApplications++;
                                    } else if (app.getStatus().equalsIgnoreCase("PENDING")) {
                                        pendingApplications++;
                                    }
                                }

                                // Calculate progress percentage
                                 progressPercentage = totalApplications > 0 ? (double) completedApplications / totalApplications * 100 : 0;
                            %>

                            <!-- Applications Table -->
                            <div class="table-responsive-sm">
                                <table class="table table-striped table-hover" id='dataTable'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Application ID</th>
                                            <th>Course Applied For</th>
                                            <th>Application Status</th>
                                            <th>Payment Status</th>
                                            <th>Date Started</th>
                                            <th>Session Applied</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int i = 1;
                                            for (Applicants pay : list) {

                                                // Simple payment status check: Does this application ID have any payment?
                                                String paymentStatus = "UNPAID";
                                                String paymentBadgeClass = "bg-danger";
                                                String paymentIcon = "❌";
                                                boolean hasPayment = false;

                                                try {
                                                    // Check if there are any payments using cached data
                                                    List<Payments> applicantPayments = paymentsCache.get(pay.getId());
                                                    if (applicantPayments != null && !applicantPayments.isEmpty()) {
                                                        paymentStatus = "PAID";
                                                        paymentBadgeClass = "bg-success";
                                                        paymentIcon = "✅";
                                                        hasPayment = true;
                                                    }
                                                } catch (Exception ex) {
                                                    // Handle payment check error - default to UNPAID
                                                }

                                        %>
                                        <tr>
                                            <td class="center"><%=i%></td>
                                            <td><%=pay.getId()%></td>
                                            <td><%=pay.getCourse1().getName()%></td>
                                            <td>
                                                <%
                                                    String statusBadge = "bg-secondary";
                                                    if (pay.getStatus().equalsIgnoreCase("SUBMITTED")
                                                            || pay.getStatus().equalsIgnoreCase("COMPLETED")) {
                                                        statusBadge = "bg-success";
                                                    } else if (pay.getStatus().equalsIgnoreCase("NOT SUBMITTED")
                                                            || pay.getStatus().equalsIgnoreCase("NOT COMPLETED")) {
                                                        statusBadge = "bg-warning";
                                                    } else if (pay.getStatus().equalsIgnoreCase("PENDING")) {
                                                        statusBadge = "bg-info";
                                                    }
                                                %>
                                                <span class="badge <%=statusBadge%>"><%=pay.getStatus()%></span>
                                            </td>
                                            <td>
                                                <span class="badge payment-status-badge <%=paymentBadgeClass%>"><%=paymentIcon%> <%=paymentStatus%></span>
                                            </td>
                                            <td><%=settings.formatDate(pay.getDateInitiated())%></td>
                                            <td><%=pay.getSession()%></td>
                                            <td class="center">
                                                <a class="btn btn-primary btn-sm" href="/gen_app_dashboard?id=<%=settings.encodeUrl(settings.encryptText(pay.getId()))%>">Details</a>
                                                <%
                                                    // Show Pay button based on application status and payment status
                                                    boolean showPayButton = false;

                                                    // Check if application is not yet submitted (NOT SUBMITTED status)
                                                    if (pay.getStatus() != null
                                                            && (pay.getStatus().equalsIgnoreCase("NOT COMPLETED")
                                                            || pay.getStatus().equalsIgnoreCase("NOT SUBMITTED"))) {
                                                        showPayButton = !hasPayment; // Only show if no payment made
                                                    }

                                                    if (showPayButton) {
                                                %>
                                                <a class="btn btn-success btn-sm ms-1" href="/app_payment?id=<%=settings.encodeUrl(settings.encryptText(pay.getId()))%>" title="Make Payment to Submit Application">Pay</a>
                                                <%
                                                } else if (hasPayment) {
                                                %>
                                                <span class="badge bg-success ms-1" title="Payment Completed">Paid</span>
                                                <%
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <%
                                                i++;
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <style>
                        .biodata-form-container {
                            background: #ffffff;
                            border-radius: 8px;
                            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
                            overflow: hidden;
                        }

                        .biodata-instructions {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            padding: 20px 25px;
                            margin-bottom: 0;
                        }

                        .biodata-instructions h5 {
                            margin: 0 0 15px 0;
                            font-weight: 600;
                            font-size: 1.1rem;
                        }

                        .biodata-instructions ul {
                            margin: 0;
                            padding-left: 20px;
                            font-size: 0.9rem;
                            line-height: 1.8;
                        }

                        .biodata-instructions li {
                            margin-bottom: 8px;
                        }

                        .biodata-fieldset {
                            border: 1px solid #e0e0e0;
                            padding: 25px;
                            margin: 25px;
                            border-radius: 6px;
                            background: #fafbfc;
                        }

                        .biodata-legend {
                            padding: 0 15px;
                            font-weight: 600;
                            color: #667eea;
                            font-size: 1.1rem;
                            width: auto;
                            margin-bottom: 0;
                            float: none;
                        }

                        .biodata-grid-2 {
                            display: grid;
                            grid-template-columns: repeat(2, 1fr);
                            gap: 20px;
                            margin-bottom: 20px;
                        }

                        .biodata-grid-3 {
                            display: grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap: 20px;
                            margin-bottom: 20px;
                        }

                        .biodata-form-group {
                            margin-bottom: 20px;
                        }

                        .biodata-form-group label {
                            font-size: 0.9rem;
                            font-weight: 600;
                            color: #495057;
                            display: block;
                            margin-bottom: 8px;
                        }

                        .biodata-form-group input,
                        .biodata-form-group select,
                        .biodata-form-group textarea {
                            width: 100%;
                            padding: 10px 12px;
                            border-radius: 6px;
                            border: 1px solid #ced4da;
                            font-size: 0.95rem;
                            transition: border-color 0.2s, box-shadow 0.2s;
                        }

                        .biodata-form-group input:focus,
                        .biodata-form-group select:focus,
                        .biodata-form-group textarea:focus {
                            outline: none;
                            border-color: #667eea;
                            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.15);
                        }

                        .biodata-submit-section {
                            text-align: center;
                            padding: 20px 25px;
                            background: #f8f9fa;
                            border-top: 1px solid #e0e0e0;
                        }

                        .biodata-submit-btn {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: #fff;
                            padding: 12px 50px;
                            border: none;
                            border-radius: 6px;
                            font-size: 1rem;
                            font-weight: 600;
                            cursor: pointer;
                            transition: transform 0.2s, box-shadow 0.2s;
                        }

                        .biodata-submit-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                        }

                        @media (max-width: 768px) {
                            .biodata-grid-2,
                            .biodata-grid-3 {
                                grid-template-columns: 1fr;
                            }
                        }
                    </style>

                    <div class="biodata-form-container mb-4">
                        <div class="biodata-instructions">
                            <h5><i class="fas fa-info-circle me-2"></i>Important Instructions</h5>
                            <ul>
                                <li>Complete your bio-data before starting any application</li>
                                <li>Details provided will be used for all your applications</li>
                                <li>Ensure all information is accurate and matches your official documents</li>
                                <li>Upload a clear passport photograph (JPG,PNG, or JPEG format only)</li>
                                <li>Phone number is compulsory (e.g., 07000000000)</li>
                            </ul>
                        </div>

                        <form action="" method="POST" role="form" name="addnew" enctype="multipart/form-data">
                            <fieldset class="biodata-fieldset">
                                <legend class="biodata-legend">Personal Particulars</legend>

                                <div class="biodata-grid-2">
                                    <div class="biodata-form-group">
                                        <label>Surname (Capital Letters) <span class="text-danger">*</span></label>
                                        <input type="text" name="surname" minlength="2" required class="form-control" placeholder="Enter your surname">
                                    </div>
                                    <div class="biodata-form-group">
                                        <label>Other Names <span class="text-danger">*</span></label>
                                        <input type="text" name="othernames" minlength="2" required class="form-control" placeholder="Enter your other names">
                                    </div>
                                </div>

                                <div class="biodata-grid-3">
                                    <div class="biodata-form-group">
                                        <label>Gender <span class="text-danger">*</span></label>
                                        <select name="gender" class="form-select" required>
                                            <option value="">Select Gender</option>
                                            <option value="Male">Male</option>
                                            <option value="Female">Female</option>
                                        </select>
                                    </div>
                                    <div class="biodata-form-group">
                                        <label>Date of Birth <span class="text-danger">*</span></label>
                                        <input type="date" name="dob" class="form-control" required
                                               min="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 90)%>" 
                                               max="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 16)%>">
                                    </div>
                                    <div class="biodata-form-group">
                                        <label>Phone Number <span class="text-danger">*</span></label>
                                        <input type="number" name="phoneno" minlength="11" maxlength="13" class="form-control" 
                                               placeholder="2347000000000" required>
                                    </div>
                                </div>

                                <div class="biodata-grid-2">
                                    <div class="biodata-form-group">
                                        <label>Home Town <span class="text-danger">*</span></label>
                                        <input type="text" name="hometown" class="form-control" placeholder="Enter your home town" required>
                                    </div>
                                    <div class="biodata-form-group">
                                        <label>Country <span class="text-danger">*</span></label>
                                        <select name="country" id="country" class="form-select" onchange="loadStates();" required>
                                            <%
                                                try {
                                                    List<Countries> col = sess.getAllCountries();
                                                    for (Countries co : col) {
                                                        String sel = "";
                                                        if (co.getId() == 1173) {
                                                            sel = "selected";
                                                        }
                                            %>
                                            <option value="<%=co.getId()%>" <%=sel%>><%=co.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>

                                <div class="biodata-grid-2">
                                    <div class="biodata-form-group">
                                        <label>State of Origin <span class="text-danger">*</span></label>
                                        <select name="states" id="states" class="form-select" onchange="loadLgas();" required>
                                            <%
                                                try {
                                                    List<States> col = sess.getAllStatesInCountry(1173);
                                                    for (States co : col) {
                                                        String sel = "";
                                                        if (co.getId() == 10035) {
                                                            sel = "selected";
                                                        }
                                            %>
                                            <option value="<%=co.getId()%>" <%=sel%>><%=co.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="biodata-form-group">
                                        <label>Local Government Area <span class="text-danger">*</span></label>
                                        <select id="lgas" name="lgas" class="form-select" required>
                                            <%
                                                try {
                                                    List<Lgas> col = sess.getAllLgasInStte(10035);
                                                    for (Lgas co : col) {
                                            %>
                                            <option value="<%=co.getId()%>"><%=co.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>

                                <div class="biodata-form-group">
                                    <label>Contact Address <span class="text-danger">*</span></label>
                                    <textarea name="contactadd" class="form-control" rows="3" placeholder="Enter your full contact address" required></textarea>
                                </div>

                                <div class="biodata-form-group">
                                    <label>Upload Passport Photograph <span class="text-danger">*</span></label>
                                    <input type="file" name="passport" class="form-control" required accept=".jpg, .png, .jpeg">
                                    <small class="text-muted">Accepted formats: JPG, PNG, JPEG (Max size: 2MB)</small>
                                </div>
                            </fieldset>

                            <div class="biodata-submit-section">
                                <button type="submit" name="button" class="biodata-submit-btn">
                                    <i class="fas fa-save me-2"></i>Save Bio-Data
                                </button>
                            </div>
                        </form>
                    </div>
                    <%
                        }
                    %>
                    <%
                        } // End of else block for normal dashboard content
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
                                            // Ensure edit profile modal readonly fields stay readonly
                                            document.addEventListener('DOMContentLoaded', function () {
                                                // Initialize tooltips
                                                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-coreui-toggle="tooltip"]'));
                                                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                    return new coreui.Tooltip(tooltipTriggerEl);
                                                });

                                                // Function to enforce readonly on specific fields
                                                function enforceReadonlyFields() {
                                                    const phoneField = document.querySelector('input[name="phonenoedit"]');
                                                    const dobField = document.querySelector('input[name="dobedit"]');

                                                    if (phoneField) {
                                                        phoneField.setAttribute('readonly', 'readonly');
                                                        phoneField.style.backgroundColor = '#f8f9fa';
                                                        phoneField.style.cursor = 'not-allowed';
                                                        phoneField.title = 'Phone number cannot be edited';
                                                    }

                                                    if (dobField) {
                                                        dobField.setAttribute('readonly', 'readonly');
                                                        dobField.style.backgroundColor = '#f8f9fa';
                                                        dobField.style.cursor = 'not-allowed';
                                                        dobField.title = 'Date of birth cannot be edited';
                                                    }
                                                }

                                                // Enforce readonly when modal is shown
                                                const editProfileModal = document.getElementById('editprofile');
                                                if (editProfileModal) {
                                                    editProfileModal.addEventListener('shown.coreui.modal', enforceReadonlyFields);
                                                    // Also enforce immediately
                                                    enforceReadonlyFields();
                                                }
                                            });
        </script>

    </body>
</html>