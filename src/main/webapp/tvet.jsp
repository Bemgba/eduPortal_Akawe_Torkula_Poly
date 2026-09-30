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
    String expandPersonal = "show";  // Default: expand Personal section first
    String expandInstitutions = "";
    String expandDocuments = "";
    String expandSubmit = "";
    
    if (sectionParam != null) {
        // Reset defaults
        expandPersonal = "";
        expandInstitutions = "";
        expandDocuments = "";
        expandSubmit = "";
        
        // Expand specific section based on parameter
        if (sectionParam.equals("personal") || sectionParam.equals("guardian")) {
            expandPersonal = "show";
        } else if (sectionParam.equals("institutions")) {
            expandInstitutions = "show";
        } else if (sectionParam.equals("documents")) {
            expandDocuments = "show";
        } else if (sectionParam.equals("submit")) {
            expandSubmit = "show";
        } else {
            // Default behavior - expand personal section
            expandPersonal = "show";
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


    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">TVET Application</h2>
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

                            <%     
                // Handle personal information form submission
                String guardianname = request.getParameter("guardianname");
                String guardianadd = request.getParameter("guardianadd");
                String sponsorphone = request.getParameter("sponsor_phone");
                String quali = request.getParameter("quali");
                String maritalstatus = request.getParameter("maritalstatus");
                String buttonPersonal = request.getParameter("buttonPersonal");
                
                if (buttonPersonal != null && buttonPersonal.length() > 0) {
                    try {
                        sess.updateApplicants(genapp.getId(), guardianname, guardianadd, sponsorphone, quali, maritalstatus);
            %>
            <div class="alert alert-success">Personal and Sponsor information saved successfully!</div>
            <%
                    } catch (Exception v) {
                        out.println("<div class='alert alert-danger'>Error saving information: " + v.getMessage() + "</div>");
                    }
                }
            %>

            <%
                // TVET applications do not require UTME or O-level records
                // Only Personal & Sponsor Information is required
                
                // Remove all O-level and UTME processing code for TVET applications
                // This section is intentionally left clean for TVET requirements
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


                            <%
                                // Define variables for accordion status checking
                                boolean hasPersonalInfo = genapp.getGuardianName() != null && !genapp.getGuardianName().trim().isEmpty()
                                        && genapp.getGuardianAddress() != null && !genapp.getGuardianAddress().trim().isEmpty()
                                        && genapp.getQualification() != null && !genapp.getQualification().trim().isEmpty()
                                        && genapp.getMaritalStatus() != null && !genapp.getMaritalStatus().trim().isEmpty();
                            %>

                            <div class="accordion" id="accordionExample">
                                <!-- Personal & Sponsor Information Section (Required) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingPersonal">
                                        <%
                                            String personalStatus = "";
                                            String personalIcon = "fas fa-exclamation-triangle text-warning";
                                            if (hasPersonalInfo) {
                                                personalStatus = " ✓";
                                                personalIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button <%=hasPersonalInfo ? "collapsed" : ""%>" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapsePersonal" 
                                                aria-expanded="<%=!hasPersonalInfo%>" aria-controls="collapsePersonal">
                                            <i class="<%=personalIcon%> me-2"></i>Personal & Sponsor Information (Required)<%=personalStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandPersonal%>" id="collapsePersonal" 
                                         aria-labelledby="headingPersonal" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <%
                                                if (!hasPersonalInfo) {
                                            %>
                                            <div class="alert alert-warning mb-3">
                                                <h6><i class="fas fa-exclamation-triangle me-2"></i>Personal & Sponsor Information Required</h6>
                                                <p class="mb-0">Please provide your personal details and sponsor information to continue with your TVET application.</p>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <div class="alert alert-success mb-3">
                                                <h6><i class="fas fa-check-circle me-2"></i>Personal & Sponsor Information Complete</h6>
                                                <p class="mb-0">Your personal and sponsor information has been saved. You can update it if needed.</p>
                                            </div>
                                            <%
                                                }
                                            %>

                                            <form action='' method='post' name="personalInfo">
                                                <h6 class="mb-3"><i class="fas fa-user me-2"></i>Personal Information</h6>
                                                
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Qualification</span>
                                                    <select class="form-select" name="quali" required>
                                                        <option value="">Select Qualification</option>
                                                        <option value="SSCE" <%=genapp.getQualification() != null && genapp.getQualification().equals("SSCE") ? "selected" : ""%>>SSCE</option>
                                                        <option value="GCE" <%=genapp.getQualification() != null && genapp.getQualification().equals("GCE") ? "selected" : ""%>>GCE</option>
                                                        <option value="NECO" <%=genapp.getQualification() != null && genapp.getQualification().equals("NECO") ? "selected" : ""%>>NECO</option>
                                                        <option value="NABTEB" <%=genapp.getQualification() != null && genapp.getQualification().equals("NABTEB") ? "selected" : ""%>>NABTEB</option>
                                                        <option value="Others" <%=genapp.getQualification() != null && genapp.getQualification().equals("Others") ? "selected" : ""%>>Others</option>
                                                    </select>
                                                </div>

                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Marital Status</span>
                                                    <select class="form-select" name="maritalstatus" required>
                                                        <option value="">Select Marital Status</option>
                                                        <option value="Single" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("Single") ? "selected" : ""%>>Single</option>
                                                        <option value="Married" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("Married") ? "selected" : ""%>>Married</option>
                                                        <option value="Divorced" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("Divorced") ? "selected" : ""%>>Divorced</option>
                                                        <option value="Widowed" <%=genapp.getMaritalStatus() != null && genapp.getMaritalStatus().equals("Widowed") ? "selected" : ""%>>Widowed</option>
                                                    </select>
                                                </div>

                                                <hr class="my-4">
                                                <h6 class="mb-3"><i class="fas fa-user-friends me-2"></i>Sponsor Information</h6>

                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Sponsor Name</span>
                                                    <input class="form-control" type="text" 
                                                           value="<%=genapp.getGuardianName() != null ? genapp.getGuardianName() : ""%>" 
                                                           name="guardianname" placeholder="Enter sponsor's full name" required>
                                                </div>

                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Sponsor Address</span>
                                                    <textarea class="form-control" name="guardianadd" rows="3" 
                                                              placeholder="Enter sponsor's address" required><%=genapp.getGuardianAddress() != null ? genapp.getGuardianAddress() : ""%></textarea>
                                                </div>

                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Sponsor Phone</span>
                                                    <input class="form-control" type="tel" 
                                                           value="<%=genapp.getSponsorPhone() != null ? genapp.getSponsorPhone() : ""%>" 
                                                           name="sponsor_phone" placeholder="Enter sponsor's phone number" required>
                                                </div>

                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="buttonPersonal" class="btn btn-success px-4" value="Save Personal & Sponsor Information"/>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Institutions Attended Section (Optional) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingInstitutions">
                                        <%
                                            String instStatus = "";
                                            String instIcon = "fas fa-info-circle text-info";
                                            if (lschatt != null && !lschatt.isEmpty()) {
                                                instStatus = " ✓";
                                                instIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapseInstitutions" 
                                                aria-expanded="false" aria-controls="collapseInstitutions">
                                            <i class="<%=instIcon%> me-2"></i>Institutions Attended (Optional - <%=lschatt.size()%> added)<%=instStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandInstitutions%>" id="collapseInstitutions" 
                                         aria-labelledby="headingInstitutions" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-info-circle me-2"></i>Optional Section</h6>
                                                <p class="mb-0">Adding institution details is optional for TVET applications. You can skip this section if you prefer.</p>
                                                <small class="text-muted">
                                                    <strong>Note:</strong> If you choose to add institutions, include secondary schools, colleges, or other educational institutions you have attended.
                                                </small>
                                            </div>

                                            <form action='' method='post' name="institutions">
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Name of Institution</span>
                                                    <input class="form-control" type="text" name="instname">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Start Date</span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="inststartdate">
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
                                                    <span class="input-group-text">Results/Certificate</span>
                                                    <input class="form-control" type="text" name="instresults">
                                                </div>
                                                <div class="input-group mb-4">
                                                    <span class="input-group-text">Registration Number</span>
                                                    <input class="form-control" type="text" name="instregno">
                                                </div>

                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="button4a" class="btn btn-primary px-4" value="Add Institution"/>
                                                    </div>
                                                </div>
                                            </form>

                                            <%
                                                if (lschatt != null && !lschatt.isEmpty()) {
                                            %>
                                            <hr class="my-4">
                                            <h6 class="mb-3">Added Institutions</h6>
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
                                                        <td><a href="/tvet?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div>

                                <!-- Supporting Documents Section (Optional) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingDocuments">
                                        <%
                                            String docsStatus = "";
                                            String docsIcon = "fas fa-info-circle text-info";
                                            if (ldocs != null && !ldocs.isEmpty()) {
                                                docsStatus = " ✓";
                                                docsIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button collapsed" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapseDocuments" 
                                                aria-expanded="false" aria-controls="collapseDocuments">
                                            <i class="<%=docsIcon%> me-2"></i>Supporting Documents (Optional - <%=ldocs.size()%> added)<%=docsStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandDocuments%>" id="collapseDocuments" 
                                         aria-labelledby="headingDocuments" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <div class="alert alert-info mb-3">
                                                <h6><i class="fas fa-info-circle me-2"></i>Optional Section</h6>
                                                <p class="mb-0">Uploading supporting documents is optional for TVET applications. You can skip this section if you don't have documents to upload.</p>
                                                <small class="text-muted">
                                                    <strong>Accepted formats:</strong> PDF, PNG, JPG. Documents might include certificates, transcripts, or other relevant files.
                                                </small>
                                            </div>

                                            <form action='' method='post' name="uploaddocs" enctype="multipart/form-data">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">
                                                        <div class="mb-3 row">
                                                            <label class="col-sm-3 col-form-label" for="docname">Document Name</label>
                                                            <div class="col-sm-4">
                                                                <input class="form-control" name="docname" type="text" placeholder="Enter document name">
                                                            </div>
                                                            <div class="col-sm-3">
                                                                <input class="form-control" type="file" accept=".pdf, .png, .jpg" name="file2">
                                                            </div>
                                                            <div class="col-sm-2">
                                                                <button name="submit4d" class="btn btn-primary mb-3" type="submit">Upload</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>

                                            <%
                                                if (ldocs != null && !ldocs.isEmpty()) {
                                            %>
                                            <hr class="my-4">
                                            <h6 class="mb-3">Uploaded Documents</h6>
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Document Name</th>
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
                                                            <a href="#" class="btn btn-secondary btn-sm"
                                                               data-coreui-toggle="modal" 
                                                               data-coreui-target="#details" 
                                                               onclick="loadDocument('<%=data.getId()%>')">
                                                                Preview
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <a href="/tvet?id4=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" 
                                                               class="btn btn-danger btn-sm">Remove</a>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                            </table>

                                            <!-- Document Preview Modal -->
                                            <div class="modal fade" id="details" tabindex="-1" aria-labelledby="detailslab" aria-hidden="true">
                                                <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="detailslab">Document Preview</h5>
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
                                            <%
                                                }
                                            %>
                                        </div>
                                    </div>
                                </div> 

                                <!-- Confirm & Submit Section (Locked until payment) -->
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSubmit">
                                        <%
                                            String submitStatus = "";
                                            String submitIcon = "fas fa-exclamation-triangle text-warning";
                                            boolean hasPayment = false;
                                            try {
                                                List<Payments> paymentList = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                                                hasPayment = paymentList.size() > 0;
                                            } catch (Exception e) {
                                                // Handle payment check error
                                            }
                                            
                                            boolean canSubmit = hasPersonalInfo && hasPayment;
                                            if (canSubmit) {
                                                submitStatus = " ✓";
                                                submitIcon = "fas fa-check-circle text-success";
                                            }
                                        %>
                                        <button class="accordion-button <%=canSubmit ? "" : "collapsed"%>" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapseSubmit" 
                                                aria-expanded="<%=canSubmit%>" aria-controls="collapseSubmit">
                                            <i class="<%=submitIcon%> me-2"></i>Confirm & Submit<%=submitStatus%>
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse <%=expandSubmit%>" id="collapseSubmit" 
                                         aria-labelledby="headingSubmit" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">
                                            <%
                                                if (!hasPersonalInfo) {
                                            %>
                                            <div class="alert alert-warning">
                                                <h6><i class="fas fa-exclamation-triangle me-2"></i>Personal & Sponsor Information Required</h6>
                                                <p class="mb-0">Please complete the Personal & Sponsor Information section before submitting your application.</p>
                                            </div>
                                            <%
                                                } else if (!hasPayment) {
                                            %>
                                            <div class="alert alert-warning">
                                                <h6><i class="fas fa-credit-card me-2"></i>Payment Required</h6>
                                                <p class="mb-0">Payment is required before you can submit your TVET application. Please complete the payment process first.</p>
                                            </div>
                                            <%
                                                } else {
                                            %>
                                            <div class="alert alert-success">
                                                <h6><i class="fas fa-check-circle me-2"></i>Ready to Submit</h6>
                                                <p class="mb-0">All required sections are complete and payment has been made. You can now submit your TVET application.</p>
                                            </div>
                                            
                                            <div class="alert alert-warning">
                                                <h6><i class="fas fa-info-circle me-2"></i>Important Notice</h6>
                                                <p>By confirming your application, you are agreeing that you have reviewed your application and are satisfied that all needed information is provided correctly.</p>
                                                <p class="mb-0"><strong>Note:</strong> Any modification after this action will not be permitted. This action marks the completion of your application process and it is after this that your application will be received by the school for processing.</p>
                                            </div>

                                            <form action='' method='post' name="attestation">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-submit">
                                                        <div class="mb-3 row">
                                                            <div class="col-sm-1">
                                                                <input class="form-check-input" name="attestationbox" type="checkbox" required="">
                                                            </div>
                                                            <label class="col-sm-9 form-check-label" for="attestationbox">
                                                                <strong>Declaration:</strong> I <%=std.getSurname() + " " + std.getOthernames()%>, hereby declare that the information stated above is to the best of my knowledge and belief, accurate in every detail.
                                                            </label>
                                                            <div class="col-sm-2">
                                                                <button name="submit6" value="Submit" class="btn btn-success mb-3" type="submit">
                                                                    <i class="fas fa-paper-plane me-1"></i>Submit Application
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                            <%
                                                }
                                            %>
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
            // TVET Application - No O-level form functionality needed
            // Only basic document loading functionality is retained
        </script>
    </body>



</html>