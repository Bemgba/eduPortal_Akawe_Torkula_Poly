<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }

    // Handle individual applicant view
    String viewId = request.getParameter("id");
    Applicants applicantToView = null;
    boolean showApplicantDetails = false;
    
    if (viewId != null && viewId.length() > 0) {
        try {
            viewId = settings.decryptText(viewId);
            applicantToView = sess.getApplicants(viewId);
            if (applicantToView != null) {
                showApplicantDetails = true;
            }
        } catch (Exception e) {
            // Handle decryption error - invalid ID
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <style>
            #uploadProgressContainer {
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-left: 4px solid #007bff;
            }
            
            #uploadProgressBar {
                font-weight: bold;
                font-size: 14px;
            }
            
            .progress {
                background-color: #e9ecef;
                border-radius: 10px;
                overflow: hidden;
            }
            
            .upload-form-disabled {
                opacity: 0.6;
                pointer-events: none;
            }
            
            #uploadSummary .h4 {
                font-weight: bold;
                margin-bottom: 5px;
            }
            
            #uploadSummary .text-center {
                padding: 10px;
                border-radius: 8px;
                background-color: #f8f9fa;
                margin-bottom: 10px;
            }
            
            #closeProgressBtn {
                border-radius: 20px;
                padding: 5px 15px;
            }
            
            #downloadReportBtn {
                border-radius: 25px;
                padding: 10px 25px;
                font-weight: bold;
            }
        </style>
        <title><%=settings.productName%> - UTME Applicants</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">UTME Applicants</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <!-- Success/Error Messages at Top -->
                    <%
                        String msg = request.getParameter("msg");
                        String msg2 = request.getParameter("msg2");
                        String error = request.getParameter("error");
                        
                        if (msg != null && msg.length() > 0) {
                    %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>O-Level Upload:</strong> <%=msg%>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                        if (msg2 != null && msg2.length() > 0) {
                    %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Applicants Upload:</strong> <%=msg2%>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                        if (error != null && error.length() > 0) {
                    %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Upload Error:</strong> <%=error%>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                    %>
                    
                    <!-- Individual Applicant Details View -->
                    <%
                        if (showApplicantDetails && applicantToView != null) {
                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-user me-2"></i>
                                    Applicant Details: <%=applicantToView.getSurname() + " " + applicantToView.getOthernames()%>
                                </h5>
                                <a href="/app_adm_upload" class="btn btn-secondary btn-sm">
                                    <i class="fas fa-arrow-left me-1"></i>Back to List
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <!-- Basic Information -->
                                    <div class="col-md-6">
                                        <h6 class="text-primary mb-3">
                                            <i class="fas fa-info-circle me-2"></i>Basic Information
                                        </h6>
                                        <table class="table table-sm">
                                            <tr>
                                                <td><strong>JAMB Number:</strong></td>
                                                <td><%=applicantToView.getId().toUpperCase()%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Full Name:</strong></td>
                                                <td><%=applicantToView.getSurname() + " " + applicantToView.getOthernames()%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Course Applied:</strong></td>
                                                <td><%=applicantToView.getCourse1() != null ? applicantToView.getCourse1().getName() : "N/A"%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Gender:</strong></td>
                                                <td><%=applicantToView.getGender()%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>State of Origin:</strong></td>
                                                <td><%=applicantToView.getStateOfOrigin() != null ? applicantToView.getStateOfOrigin().getName() : "N/A"%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>LGA:</strong></td>
                                                <td><%=applicantToView.getLga() != null ? applicantToView.getLga().getName() : "N/A"%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Application Type:</strong></td>
                                                <td><span class="badge bg-info"><%=applicantToView.getApplicationType()%></span></td>
                                            </tr>
                                        </table>
                                    </div>
                                    
                                    <!-- UTME Details -->
                                    <div class="col-md-6">
                                        <h6 class="text-success mb-3">
                                            <i class="fas fa-graduation-cap me-2"></i>UTME Details
                                        </h6>
                                        <%
                                            Applicantsutme utme = sess.getApplicantsutme(applicantToView.getId());
                                            if (utme != null) {
                                        %>
                                        <table class="table table-sm">
                                            <tr>
                                                <td><strong>Total UTME Score:</strong></td>
                                                <td><span class="badge bg-success fs-6"><%=utme.getTotalUtme()%></span></td>
                                            </tr>
                                            <tr>
                                                <td><strong>English:</strong></td>
                                                <td><%=utme.getEngScore()%></td>
                                            </tr>
                                            <%
                                                if (utme.getSubj2() != null && !utme.getSubj2().trim().isEmpty()) {
                                                    try {
                                                        Utmesubjects subj2 = sess.getUtmesubjects(utme.getSubj2());
                                            %>
                                            <tr>
                                                <td><strong>Subject 2:</strong></td>
                                                <td><%=subj2 != null ? subj2.getName() : utme.getSubj2()%> (<%=utme.getSubj2Score()%>)</td>
                                            </tr>
                                            <%
                                                    } catch (Exception e) {
                                            %>
                                            <tr>
                                                <td><strong>Subject 2:</strong></td>
                                                <td><%=utme.getSubj2()%> (<%=utme.getSubj2Score()%>)</td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                                if (utme.getSubj3() != null && !utme.getSubj3().trim().isEmpty()) {
                                                    try {
                                                        Utmesubjects subj3 = sess.getUtmesubjects(utme.getSubj3());
                                            %>
                                            <tr>
                                                <td><strong>Subject 3:</strong></td>
                                                <td><%=subj3 != null ? subj3.getName() : utme.getSubj3()%> (<%=utme.getSubj3Score()%>)</td>
                                            </tr>
                                            <%
                                                    } catch (Exception e) {
                                            %>
                                            <tr>
                                                <td><strong>Subject 3:</strong></td>
                                                <td><%=utme.getSubj3()%> (<%=utme.getSubj3Score()%>)</td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                                if (utme.getSubj4() != null && !utme.getSubj4().trim().isEmpty()) {
                                                    try {
                                                        Utmesubjects subj4 = sess.getUtmesubjects(utme.getSubj4());
                                            %>
                                            <tr>
                                                <td><strong>Subject 4:</strong></td>
                                                <td><%=subj4 != null ? subj4.getName() : utme.getSubj4()%> (<%=utme.getSubj4Score()%>)</td>
                                            </tr>
                                            <%
                                                    } catch (Exception e) {
                                            %>
                                            <tr>
                                                <td><strong>Subject 4:</strong></td>
                                                <td><%=utme.getSubj4()%> (<%=utme.getSubj4Score()%>)</td>
                                            </tr>
                                            <%
                                                    }
                                                }
                                            %>
                                        </table>
                                        <%
                                            } else {
                                        %>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            No UTME details found for this applicant
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                                
                                <!-- Payment Status -->
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <h6 class="text-warning mb-3">
                                            <i class="fas fa-credit-card me-2"></i>Payment Status
                                        </h6>
                                        <%
                                            List<Payments> payments = sess.getPaymentsByRegno(applicantToView.getId());
                                            if (payments != null && !payments.isEmpty()) {
                                                // Check if any payment has a valid date AND matches the applicant's session
                                                boolean hasPaidPayment = false;
                                                boolean hasSessionPayment = false;
                                                int sessionPaymentCount = 0;
                                                
                                                for (Payments payment : payments) {
                                                    if (payment.getDatePaid() != null) {
                                                        hasPaidPayment = true;
                                                        // Check if payment is for the same session as the application
                                                        if (applicantToView.getSession().equals(payment.getSessionPaid())) {
                                                            hasSessionPayment = true;
                                                            sessionPaymentCount++;
                                                        }
                                                    }
                                                }
                                                
                                                if (hasSessionPayment) {
                                        %>
                                        <div class="alert alert-success">
                                            <i class="fas fa-check-circle me-2"></i>
                                            Payment completed for session <strong><%=applicantToView.getSession()%></strong>
                                            <small class="d-block">Found <%=sessionPaymentCount%> payment(s) for this session</small>
                                        </div>
                                        <%
                                                } else if (hasPaidPayment) {
                                        %>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            Payment found but not for current session <strong><%=applicantToView.getSession()%></strong>
                                            <small class="d-block">Payments exist for other sessions but not for this application session</small>
                                        </div>
                                        <%
                                                } else {
                                        %>
                                        <div class="alert alert-info">
                                            <i class="fas fa-clock me-2"></i>
                                            Payment records exist but no completion date found
                                        </div>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <div class="alert alert-danger">
                                            <i class="fas fa-times-circle me-2"></i>
                                            No payment records found for this applicant
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                                
                                <!-- O-Level Status -->
                                <div class="row mt-3">
                                    <div class="col-12">
                                        <h6 class="text-info mb-3">
                                            <i class="fas fa-book me-2"></i>O-Level Status
                                        </h6>
                                        <%
                                            Olevelresults olevel = sess.getOlevelresults(applicantToView.getId());
                                            if (olevel != null) {
                                                List<Olevelresultsitems> olevelItems = sess.getOlevelresultsItems(olevel.getId());
                                                if (olevelItems != null && !olevelItems.isEmpty()) {
                                        %>
                                        <div class="alert alert-success">
                                            <i class="fas fa-check-circle me-2"></i>
                                            O-Level results uploaded - <%=olevelItems.size()%> subjects found
                                        </div>
                                        <%
                                                } else {
                                        %>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            O-Level record exists but no subject details found
                                        </div>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle me-2"></i>
                                            No O-Level results uploaded yet
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        } else if (!showApplicantDetails) {
                            // Show the normal upload forms and list only when not viewing individual applicant
                    %>
                    
                    <!-- Upload Progress Bar (Hidden by default) -->
                    <div id="uploadProgressContainer" class="col-12 mb-4" style="display: none;">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-upload me-2"></i>
                                        <span id="uploadProgressTitle">Processing Upload...</span>
                                    </h5>
                                    <button type="button" id="closeProgressBtn" class="btn btn-sm btn-outline-secondary" style="display: none;">
                                        <i class="fas fa-times"></i> Close
                                    </button>
                                </div>
                                <div class="progress mb-3" style="height: 25px;">
                                    <div id="uploadProgressBar" class="progress-bar progress-bar-striped progress-bar-animated" 
                                         role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                                        <span id="uploadProgressText">0%</span>
                                    </div>
                                </div>
                                <div id="uploadProgressMessage" class="text-muted">
                                    <i class="fas fa-spinner fa-spin me-2"></i>
                                    Uploading and processing your file...
                                </div>
                                <div id="uploadSummary" class="mt-3" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <div class="h4 text-primary mb-0" id="totalRecords">0</div>
                                                <small class="text-muted">Total Records</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <div class="h4 text-success mb-0" id="successRecords">0</div>
                                                <small class="text-muted">Successful</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center">
                                                <div class="h4 text-danger mb-0" id="errorRecords">0</div>
                                                <small class="text-muted">Errors/Skipped</small>
                                            </div>
                                        </div>
                                    </div>
<!--                                    <div class="text-center mt-3">
                                        <button type="button" id="downloadReportBtn" class="btn btn-success" style="display: none;">
                                            <i class="fas fa-download me-2"></i>Download Detailed Report
                                        </button>
                                    </div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>This page allows you to export the UTME applicants list directly from the JAMB CAPS platform into the University portal.</p>
                                        <p>You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format</p>
                                        <p><strong>Important:</strong> UTME subjects in your Excel file must exist in the database. Use the <a href="/utme_subjects" target="_blank" class="btn btn-sm btn-info">UTME Subjects Management</a> page to add subjects before uploading.</p>
                                        <p>Download templates to ensure your files comply with the required format:</p>
                                        <ul>
                                            <li><strong>Applicants Data:</strong> <a href="templates/applicants_list_utme.xls" target="_blank">Download Template</a></li>
                                            <li><strong>Passports:</strong> Upload multiple image files (.jpg format) named with JAMB numbers (e.g., 202440202794ef.jpg)</li>
                                            <li><strong>O-Level Results:</strong> <a href="templates/utme_olevel.xls" target="_blank">Download Template</a></li>
                                            <li><strong>Post UTME Results:</strong> <a href="templates/utme_postutme.xls" target="_blank">Download Template</a></li>
                                        </ul>
                                        <p>Also remember to verify with the report that is generated after the file upload for entries that are successful and those that are not</p>
                                        <p><strong>Note:</strong> For Post UTME Results, your excel file should only contain S/NO, JAMB_NO and SCORE columns</p>
                                        <%                                        Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
                                            if (sessmanx != null) {
                                        %>
                                        <p>Applicants will be uploaded against the <strong><%=sessmanx.getName()%></strong> academic session. Note that only current session for application can be treated.</p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">

                                <div class="example">
                                    <form action='UploadUTMEApplicants?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Applicants File (<a href="templates/applicants_list_utme.xls" target="_blank" class="btn btn-outline-info btn-sm">Download Template</a>)</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list" type="file" accept=".xls" name="list" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="example">
                                    <form action='UploadUTMEPassports?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify2" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Passports Folder</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list2" type="file" name="list2" required="" multiple="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit2" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="example">
                                    <form action='UploadUTMEOLevel?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify3" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select O-level File (<a href="templates/utme_olevel.xls" target="_blank" class="btn btn-outline-info btn-sm">Download Template</a>)</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list3" type="file"  accept=".xls" name="list3" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit3" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                        <div class="example">
                                    <form action='UploadUTMEPostutme?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Post UTME File (<a href="templates/utme_postutme.xls" target="_blank" class="btn btn-outline-info btn-sm">Download Template</a>)</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list" type="file" accept=".xls" name="list" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%
                        if (sessmanx != null) {
                            // Check what filter level to use
                            String filterLevel = request.getParameter("filter");
                            if (filterLevel == null) filterLevel = "qualified"; // Default to qualified
                            
                            Long size = 0L;
                            List<Object[]> appl = new ArrayList<>();
                            
                            if ("all".equals(filterLevel)) {
                                // Show all applicants (original behavior)
                                size = sess.countApplicantsBySessionAndType(sessmanx.getName(), "UTME");
                                appl = sess.getApplicantsBySessionAndType(sessmanx.getName(), "UTME", 2000, 0);
                            } else if ("payment".equals(filterLevel)) {
                                // Show applicants with any payment (less strict)
                                size = sess.countApplicantsBySessionAndType(sessmanx.getName(), "UTME");
                                appl = sess.getApplicantsBySessionAndType(sessmanx.getName(), "UTME", 2000, 0);
                                // Filter in Java for now
                                appl = appl.stream().filter(pay -> {
                                    try {
                                        List<Payments> payments = sess.getPaymentsByRegno(pay[0].toString());
                                        return payments != null && !payments.isEmpty();
                                    } catch (Exception e) {
                                        return false;
                                    }
                                }).collect(java.util.stream.Collectors.toList());
                                size = (long) appl.size();
                            } else {
                                // Use qualified applicants method (strict - payment + UTME + session match)
                                size = sess.countQualifiedApplicantsBySessionAndType(sessmanx.getName(), "UTME");
                                appl = sess.getQualifiedApplicantsBySessionAndType(sessmanx.getName(), "UTME", 2000, 0);
                            }
                            
                            Long si = size / 2000;
                            int index = 0;
                            try {
                                String h = request.getParameter("index");
                                if (h != null) {
                                    index = Integer.parseInt(h);
                                }
                            } catch (Exception k) {
                            }

                            if (size == 0) {
                    %>
                    <div class='alert alert-warning'>
                        No applicants found with current filter: <strong><%=filterLevel%></strong> for session <strong><%=sessmanx.getName()%></strong>
                        <div class="mt-2">
                            <small>Try different filter levels:</small><br>
                            <a href="/app_adm_upload?filter=all" class="btn btn-sm btn-outline-primary">All Applicants</a>
                            <a href="/app_adm_upload?filter=payment" class="btn btn-sm btn-outline-warning">With Any Payment</a>
                            <a href="/app_adm_upload?filter=qualified" class="btn btn-sm btn-outline-success">Fully Qualified</a>
                        </div>
                    </div>
                    <%
                    } else {

                    %>
                    <div class="col-12">
                        <div class="card mb-4">

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <strong><%=appl.size()%></strong> applicants found (Filter: <span class="badge bg-info"><%=filterLevel.toUpperCase()%></span>)
                                        <small class="text-muted d-block">Session: <strong><%=sessmanx.getName()%></strong></small>
                                    </div>
                                    <div class="btn-group" role="group">
                                        <a href="/app_adm_upload?filter=all" class="btn btn-sm <%="all".equals(filterLevel) ? "btn-primary" : "btn-outline-primary"%>">All</a>
                                        <a href="/app_adm_upload?filter=payment" class="btn btn-sm <%="payment".equals(filterLevel) ? "btn-warning" : "btn-outline-warning"%>">With Payment</a>
                                        <a href="/app_adm_upload?filter=qualified" class="btn btn-sm <%="qualified".equals(filterLevel) ? "btn-success" : "btn-outline-success"%>">Fully Qualified</a>
                                    </div>
                                </div>
                                
                                <!-- Filter Explanation -->
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <%
                                            if ("all".equals(filterLevel)) {
                                        %>
                                        <i class="fas fa-info-circle"></i> Showing all UTME applicants regardless of payment or completion status
                                        <%
                                            } else if ("payment".equals(filterLevel)) {
                                        %>
                                        <i class="fas fa-credit-card"></i> Showing applicants who have made any payment (any session)
                                        <%
                                            } else {
                                        %>
                                        <i class="fas fa-check-circle"></i> Showing applicants with: Payment for current session + Complete UTME details
                                        <%
                                            }
                                        %>
                                    </small>
                                </div>
                                
                                <!-- Debug: Show Qualification Rules -->
                                <div class="mt-3">
                                    <button class="btn btn-sm btn-outline-secondary" type="button" data-coreui-toggle="collapse" data-coreui-target="#qualificationRules" aria-expanded="false">
                                        <i class="fas fa-list-check"></i> View Qualification Rules
                                    </button>
                                    <div class="collapse mt-2" id="qualificationRules">
                                        <div class="alert alert-info">
                                            <h6><i class="fas fa-rules"></i> Current Qualification Rules for "Fully Qualified" Filter:</h6>
                                            <ol class="mb-0">
                                                <li><strong>Session Match:</strong> Applicant session = <%=sessmanx.getName()%></li>
                                                <li><strong>Application Type:</strong> UTME</li>
                                                <li><strong>Payment Validation:</strong>
                                                    <ul>
                                                        <li>Payment record exists (payerId = applicant.id OR payerRegistrationNo = applicant.id)</li>
                                                        <li>Payment has completion date (datePaid IS NOT NULL)</li>
                                                        <li>Payment session matches applicant session (sessionPaid = applicant.session)</li>
                                                    </ul>
                                                </li>
                                                <li><strong>UTME Validation:</strong>
                                                    <ul>
                                                        <li>UTME record exists (applicantId = applicant.id)</li>
                                                        <li>Total UTME score > 0</li>
                                                    </ul>
                                                </li>
                                            </ol>
                                            <div class="mt-2">
                                                <small class="text-muted">
                                                    <strong>Note:</strong> If no applicants appear with "Fully Qualified" filter, try "With Payment" or "All" to see what data is available.
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <p class="float-end">
                                    <%                                for (int ind = 0; ind <= si; ind++) {
                                            int x = ind * 2000;
                                            String styl = "warning";
                                            if (index == x) {
                                                styl = "secondary";
                                            }
                                    %>
                                    <a class="btn btn-<%=styl%> btn-sm" href="/app_adm_upload?index=<%=x%>">Page <%=ind + 1%></a> &nbsp;
                                    <%
                                        }
                                    %>
                                </p>
                            </div>

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>UTME No</th>
                                                <th>Full Name</th>
                                                <th>Course</th>
                                                <th>Aggregate</th>
                                                <th>Gender</th>
                                                <th>State</th>
                                                <th class="center">More</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Object[] pay : appl) {
                                                    int agg = 0;
                                                    try {
                                                        Applicantsutme utme = sess.getApplicantsutme(pay[0].toString());
                                                        if (utme != null) {
                                                            agg = utme.getTotalUtme();
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=pay[0].toString().toUpperCase()%></td>
                                                <td><%=pay[1] + " " + pay[2]%></td>
                                                <td><%=pay[3]%></td>
                                                <td><%=agg%></td>
                                                <td><%=pay[4]%></td>
                                                <td><%=pay[5]%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/app_adm_upload?id=<%=settings.encodeUrl(settings.encryptText(pay[0].toString()))%>">View</a></td>
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
                    </div>


                    <%
                            }
                        }
                    %>


                </div>
            </div>
            <%
                } // End of showApplicantDetails conditional
            %>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->

        <script src="vendors/jquery/js/jquery.min.js"></script>
        <script src="vendors/datatables.net/js/dataTables.min.js"></script>
        <script src="vendors/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
        <script src="js/datatables.js"></script>

        <script src="js/dataTables.js"></script>
        <script src="js/dataTables.buttons.js"></script>
        <script src="js/buttons.dataTables.js"></script>
        <script src="js/jszip.min.js"></script>
        <script src="js/pdfmake.min.js"></script>
        <script src="js/vfs_fonts.js"></script>
        <script src="js/buttons.html5.min.js"></script>
        <script src="js/buttons.print.min.js"></script>
        <script src="js/jquery-3.7.1.js"></script>

        <script>
            $(document).ready(function () {
                // Global variable to track active progress intervals
                let activeProgressInterval = null;
                
                // Initialize DataTables if table exists
                if ($('#example').length) {
                    $('#example').DataTable({
                        dom: 'Bfrtip',
                        buttons: [
                            'copy', 'csv', 'excel', 'pdf', 'print'
                        ]
                    });
                }
                
                // Close progress bar button
                $('#closeProgressBtn').on('click', function() {
                    hideProgressBar();
                });
                
                // Download report button
                $('#downloadReportBtn').on('click', function() {
                    const downloadUrl = $(this).data('download-url');
                    if (downloadUrl) {
                        window.location.href = downloadUrl;
                    }
                });
                
                // Handle UTME Applicants Upload Form
                $('form[name="verify"]').on('submit', function(e) {
                    e.preventDefault();
                    handleUpload(this, 'UTME Applicants');
                });
                
                // Handle Passports Upload Form
                $('form[name="verify2"]').on('submit', function(e) {
                    e.preventDefault();
                    handleUpload(this, 'Passports');
                });
                
                // Handle O-Level Upload Form
                $('form[name="verify3"]').on('submit', function(e) {
                    e.preventDefault();
                    handleUpload(this, 'O-Level Results');
                });
                
                // Handle Post UTME Upload Form
                $('form[action*="UploadUTMEPostutme"]').on('submit', function(e) {
                    e.preventDefault();
                    handleUpload(this, 'Post UTME Results');
                });
                
                function handleUpload(form, uploadType) {
                    // Validate file selection
                    const fileInput = $(form).find('input[type="file"]')[0];
                    if (!fileInput.files.length) {
                        alert('Please select a file to upload.');
                        return;
                    }
                    
                    // Validate file type for Excel files
                    const fileName = fileInput.files[0].name;
                    if (!fileName.toLowerCase().endsWith('.xls')) {
                        alert('Please select a valid Excel file (.xls format).');
                        return;
                    }
                    
                    // Show progress bar
                    showProgressBar(uploadType);
                    
                    // Disable form submit button
                    const submitBtn = $(form).find('button[type="submit"]');
                    const originalText = submitBtn.text();
                    submitBtn.prop('disabled', true).text('Uploading...');
                    
                    // Create FormData for file upload
                    const formData = new FormData(form);
                    
                    // Perform AJAX upload with progress tracking
                    $.ajax({
                        url: $(form).attr('action'),
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        timeout: 300000, // 5 minutes timeout
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest' // This tells the server it's an AJAX request
                        },
                        xhr: function() {
                            const xhr = new window.XMLHttpRequest();
                            
                            // Upload progress
                            xhr.upload.addEventListener('progress', function(evt) {
                                if (evt.lengthComputable) {
                                    const percentComplete = Math.round((evt.loaded / evt.total) * 40); // 40% for upload
                                    updateProgress(percentComplete, 'Uploading file... (' + formatBytes(evt.loaded) + ' / ' + formatBytes(evt.total) + ')');
                                }
                            }, false);
                            
                            return xhr;
                        },
                        beforeSend: function() {
                            updateProgress(5, 'Preparing upload...');
                        },
                        success: function(response, textStatus, xhr) {
                            // Processing phase - start at 50% after upload
                            updateProgress(50, 'Processing data...');
                            
                            // Use a more reliable progress simulation
                            simulateProcessingProgress(50, 95, function() {
                                // Force completion to 100% when server responds
                                updateProgress(100, 'Upload completed successfully!');
                                
                                setTimeout(function() {
                                    // Check if response is JSON (AJAX) or HTML (regular form)
                                    try {
                                        const jsonResponse = typeof response === 'string' ? JSON.parse(response) : response;
                                        
                                        if (jsonResponse.success) {
                                            // Show upload summary
                                            showUploadSummary(jsonResponse);
                                            
                                            // Show success message
                                            showMessage('success', uploadType + ' Upload Successful', 
                                                      `Upload completed! ${jsonResponse.successCount} records uploaded successfully, ${jsonResponse.errorCount} errors/skipped.`);
                                            
                                            // Auto-download report after 2 seconds
                                            setTimeout(function() {
                                                if (jsonResponse.reportDownloadUrl) {
                                                    window.location.href = jsonResponse.reportDownloadUrl;
                                                }
                                            }, 2000);
                                        } else {
                                            showMessage('danger', uploadType + ' Upload Error', jsonResponse.message || 'Upload failed');
                                        }
                                    } catch (e) {
                                        // Handle HTML response (fallback)
                                        if (response.includes('alert-success') || response.includes('Upload completed')) {
                                            showMessage('success', uploadType + ' Upload Successful', 
                                                      'Your file has been processed successfully. Check the auto-downloaded report for details.');
                                        } else if (response.includes('alert-danger') || response.includes('error')) {
                                            const tempDiv = $('<div>').html(response);
                                            const errorMsg = tempDiv.find('.alert-danger').text() || 'Upload completed with some issues.';
                                            showMessage('warning', uploadType + ' Upload Completed', errorMsg);
                                        } else {
                                            // Reload page to show server response
                                            window.location.reload();
                                        }
                                    }
                                    
                                    // Re-enable submit button
                                    submitBtn.prop('disabled', false).text(originalText);
                                }, 1000);
                            });
                        },
                        error: function(xhr, status, error) {
                            // Clear any active progress intervals
                            if (activeProgressInterval) {
                                clearInterval(activeProgressInterval);
                                activeProgressInterval = null;
                            }
                            
                            let errorMessage = 'Upload failed: ';
                            if (status === 'timeout') {
                                errorMessage += 'Request timed out. The file might be too large or the server is busy.';
                            } else if (xhr.status === 413) {
                                errorMessage += 'File is too large. Please try a smaller file.';
                            } else if (xhr.status === 0) {
                                errorMessage += 'Network connection lost. Please check your internet connection.';
                            } else {
                                errorMessage += error || 'Unknown error occurred.';
                            }
                            
                            updateProgress(0, 'Upload failed!');
                            $('#uploadProgressBar').removeClass('progress-bar-striped progress-bar-animated')
                                                  .addClass('bg-danger');
                            $('#uploadProgressMessage').html('<i class="fas fa-exclamation-circle me-2 text-danger"></i>Upload failed!');
                            
                            setTimeout(function() {
                                showMessage('danger', uploadType + ' Upload Error', errorMessage);
                                submitBtn.prop('disabled', false).text(originalText);
                                $('#closeProgressBtn').show(); // Show close button on error
                            }, 2000);
                        }
                    });
                }
                
                function showProgressBar(uploadType) {
                    // Clear any existing progress intervals
                    if (activeProgressInterval) {
                        clearInterval(activeProgressInterval);
                        activeProgressInterval = null;
                    }
                    
                    $('#uploadProgressTitle').text('Processing ' + uploadType + ' Upload...');
                    $('#uploadProgressBar').removeClass('bg-success bg-danger')
                                          .addClass('progress-bar-striped progress-bar-animated');
                    $('#uploadSummary').hide();
                    $('#closeProgressBtn').hide();
                    $('#downloadReportBtn').hide();
                    $('#uploadProgressContainer').slideDown(400);
                    
                    // Disable all upload forms during processing
                    $('.example form').addClass('upload-form-disabled');
                    
                    // Scroll to progress bar
                    setTimeout(function() {
                        $('html, body').animate({
                            scrollTop: $('#uploadProgressContainer').offset().top - 100
                        }, 500);
                    }, 200);
                }
                
                function updateProgress(percent, message) {
                    $('#uploadProgressBar').css('width', percent + '%').attr('aria-valuenow', percent);
                    $('#uploadProgressText').text(percent + '%');
                    
                    if (percent === 100) {
                        // Stop spinning animation and show success state
                        $('#uploadProgressBar').removeClass('progress-bar-striped progress-bar-animated')
                                              .addClass('bg-success');
                        $('#uploadProgressMessage').html('<i class="fas fa-check-circle me-2 text-success"></i>' + message);
                        $('#closeProgressBtn').show(); // Show close button when complete
                        
                        // Clear any active intervals
                        if (activeProgressInterval) {
                            clearInterval(activeProgressInterval);
                            activeProgressInterval = null;
                        }
                    } else {
                        // Keep spinning animation for progress
                        $('#uploadProgressMessage').html('<i class="fas fa-spinner fa-spin me-2"></i>' + message);
                    }
                }
                
                function showUploadSummary(jsonResponse) {
                    $('#totalRecords').text(jsonResponse.totalRecords);
                    $('#successRecords').text(jsonResponse.successCount);
                    $('#errorRecords').text(jsonResponse.errorCount);
                    
                    if (jsonResponse.reportDownloadUrl) {
                        $('#downloadReportBtn').data('download-url', jsonResponse.reportDownloadUrl).show();
                    }
                    
                    $('#uploadSummary').slideDown();
                }
                
                function hideProgressBar() {
                    // Clear any active progress intervals
                    if (activeProgressInterval) {
                        clearInterval(activeProgressInterval);
                        activeProgressInterval = null;
                    }
                    
                    $('#uploadProgressContainer').slideUp(400);
                    
                    // Re-enable all upload forms
                    $('.example form').removeClass('upload-form-disabled');
                }
                
                function showMessage(type, title, message) {
                    const alertHtml = `
                        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                            <strong>${title}:</strong> ${message}
                            <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                        </div>
                    `;
                    
                    // Remove existing alerts
                    $('.alert').remove();
                    
                    // Add new alert at the top
                    $('.container-lg.px-4').prepend(alertHtml);
                    
                    // Scroll to top to show the message
                    $('html, body').animate({scrollTop: 0}, 500);
                    
                    // Auto-hide success messages after 10 seconds
                    if (type === 'success') {
                        setTimeout(function() {
                            $('.alert-success').fadeOut();
                        }, 10000);
                    }
                }
                
                function formatBytes(bytes, decimals = 2) {
                    if (bytes === 0) return '0 Bytes';
                    const k = 1024;
                    const dm = decimals < 0 ? 0 : decimals;
                    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
                    const i = Math.floor(Math.log(bytes) / Math.log(k));
                    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
                }
                
                function simulateProcessingProgress(startPercent, endPercent, callback) {
                    // Clear any existing interval
                    if (activeProgressInterval) {
                        clearInterval(activeProgressInterval);
                    }
                    
                    let currentProgress = startPercent;
                    const increment = 2;
                    const interval = 120;
                    
                    activeProgressInterval = setInterval(function() {
                        currentProgress += increment;
                        
                        if (currentProgress >= endPercent) {
                            clearInterval(activeProgressInterval);
                            activeProgressInterval = null;
                            updateProgress(endPercent, 'Finalizing upload...');
                            if (callback) callback();
                        } else {
                            updateProgress(currentProgress, 'Processing records and generating report...');
                        }
                    }, interval);
                    
                    // Safety timeout to ensure progress completes even if something goes wrong
                    setTimeout(function() {
                        if (activeProgressInterval) {
                            clearInterval(activeProgressInterval);
                            activeProgressInterval = null;
                        }
                        if (currentProgress < endPercent) {
                            updateProgress(endPercent, 'Finalizing upload...');
                            if (callback) callback();
                        }
                    }, 5000); // 5 second safety timeout
                }
            });
        </script>


        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>




        <script>

            $(document).ready(function () {
                new DataTable('#dataTable', {
                    responsive: true,
                    "info": true,
                    "pageLength": 25,
                    "lengthMenu": [25, 50, 100, 200, 500],
                    "dom": 'lBfrtip',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    layout: {
                        topStart: 'buttons'
                    }
                });

            });
        </script>
    </body>
</html>