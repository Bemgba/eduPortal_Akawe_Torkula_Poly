<%-- 
    Document   : adminCreateFeesGroup
    Created on : Fix for missing fee groups
    Author     : BEMGBA
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    // Comprehensive user session validation
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Additional safety checks
    if (user.getDefaultRole() == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Verify session is still valid
    try {
        String userId = user.getId();
        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect("/");
            return;
        }
    } catch (Exception e) {
        response.sendRedirect("/");
        return;
    }
%>

<%
    String msg = "";
    String sty = "info";
    
    String createButton = request.getParameter("createButton");
    String schoolId = request.getParameter("schoolId");
    String feesGroupName = request.getParameter("feesGroupName");
    String description = request.getParameter("description");
    
    if (createButton != null && schoolId != null && schoolId.length() > 0 && feesGroupName != null && feesGroupName.length() > 0) {
        try {
            Schools school = sess.getSchools(schoolId);
            if (school != null) {
                // Check if fee group already exists
                List<Feesgroup> existing = sess.getFeesgroupBySchoolAndCategory(schoolId, "ALL");
                boolean exists = existing.stream().anyMatch(fg -> fg.getName().equalsIgnoreCase(feesGroupName));
                
                if (!exists) {
                    String fgId =  settings.generateId("", 5);
                    Feesgroup fg = new Feesgroup(fgId);
                    fg.setName(feesGroupName.toUpperCase());
                    fg.setSchoolId(school);
                    fg.setAccountId((Accounts) sess.getSingleObject(Accounts.class, 100));
                    fg.setDescription(description != null ? description : "Fee group for " + school.getName());
                    fg.setSessionSemester("Session");
                    fg.setRepeatPayment("No");
                    fg.setCategory("Students");
                    fg.setVisibility("PUBLIC");
                    sess.newEntry(fg);
                    
                    msg = "Fee group '" + feesGroupName + "' created successfully for " + school.getName();
                    sty = "success";
                } else {
                    msg = "Fee group '" + feesGroupName + "' already exists for " + school.getName();
                    sty = "warning";
                }
            } else {
                msg = "School not found";
                sty = "danger";
            }
        } catch (Exception e) {
            msg = "Error creating fee group: " + e.getMessage();
            sty = "danger";
            e.printStackTrace();
        }
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Create Fee Group</title>
    </head>
    <body>
        <%
        try {
        %>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Create Fee Group</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Create Fee Group for School</strong>
                                <a href="/fees_setup" class="btn btn-secondary btn-sm float-end">Back to Fees Setup</a>
                            </div>
                            <div class="card-body">
                                <%
                                    if (msg.length() > 0) {
                                %>
                                <div class="alert alert-<%=sty%>"><%=msg%></div>
                                <%
                                    }
                                %>
                                
                                <form action="" method="post" name="createFeeGroup">
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Select School</span>
                                        <select class="form-select" name="schoolId" required>
                                            <option value="">Select School</option>
                                            <%
                                                try {
                                                    List<Schools> schools = sess.getAllSchoos();
                                                    for (Schools school : schools) {
                                            %>
                                            <option value="<%=school.getId()%>" <%=school.getId().equals(schoolId) ? "selected" : ""%>>
                                                <%=school.getName()%>
                                            </option>
                                            <%
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>
                                        </select>
                                    </div>
                                    
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Fee Group Name</span>
                                        <input type="text" class="form-control" name="feesGroupName" 
                                               value="<%=feesGroupName != null ? feesGroupName : "SCHOOL FEES"%>" 
                                               placeholder="e.g., SCHOOL FEES" required>
                                    </div>
                                    
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Description</span>
                                        <input type="text" class="form-control" name="description" 
                                               value="<%=description != null ? description : ""%>" 
                                               placeholder="Optional description">
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-12">
                                            <input type="submit" name="createButton" class="btn btn-success px-4" value="Create Fee Group"/>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Payment Diagnostic Section -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Payment Diagnostic Tool</strong>
                                <small class="text-muted">- Troubleshoot payment/fee setup mismatches</small>
                            </div>
                            <div class="card-body">
                                <%
                                    String diagnosticStudentId = request.getParameter("diagnosticStudentId");
                                    String diagnosticButton = request.getParameter("diagnosticButton");
                                    
                                    if (diagnosticButton != null && diagnosticStudentId != null && diagnosticStudentId.length() > 0) {
                                %>
                                <div class="alert alert-info">
                                    <h5>Diagnostic Results for Student: <%=diagnosticStudentId%></h5>
                                    <%
                                        try {
                                            Students student = sess.getStudentsById(diagnosticStudentId);
                                            if (student != null) {
                                                String studentSchoolId = student.getCourseId().getSchoolProgrammeId().getSchoolId().getName();
                                                String courseId = student.getCourseId().getName();
                                                String programmeId = student.getCourseId().getSchoolProgrammeId().getProgrammeId().getName() + "";
                                                
                                                // Get expected fee group
                                                Feesgroup expectedFeeGroup = sess.getSchoolFeesId(studentSchoolId);
                                                
                                                out.println("<h6>Student Information:</h6>");
                                                out.println("<ul>");
                                                out.println("<li><strong>School:</strong> " + studentSchoolId + "</li>");
                                                out.println("<li><strong>Programme:</strong> " + programmeId + "</li>");
                                                out.println("<li><strong>Course:</strong> " + courseId + "</li>");
                                                out.println("<li><strong>Expected Fee Group:</strong> " + (expectedFeeGroup != null ? expectedFeeGroup.getId() + " (" + expectedFeeGroup.getName() + ")" : "NOT FOUND") + "</li>");
                                                out.println("</ul>");
                                                
                                                // Get all payments for this student
                                                List<Payments> allPayments = sess.getPaymentsByRegno(diagnosticStudentId);
                                                out.println("<h6>All Payments (" + allPayments.size() + "):</h6>");
                                                if (allPayments.size() > 0) {
                                                    out.println("<div class='table-responsive'>");
                                                    out.println("<table class='table table-sm table-bordered'>");
                                                    out.println("<tr><th>Payment ID</th><th>Amount</th><th>Fee Group</th><th>Session</th><th>Semester</th><th>Date</th></tr>");
                                                    for (Payments payment : allPayments) {
                                                        out.println("<tr>");
                                                        out.println("<td>" + payment.getId() + "</td>");
                                                        out.println("<td>N" + settings.formatno.format(payment.getAmount()) + "</td>");
                                                        out.println("<td>" + payment.getFeesGroupId().getName() + "</td>");
                                                        out.println("<td>" + payment.getSessionPaid() + "</td>");
                                                        out.println("<td>" + payment.getSemesterPaid() + "</td>");
                                                        out.println("<td>" + (payment.getDatePaid() != null ? payment.getDatePaid() : "N/A") + "</td>");
                                                        out.println("</tr>");
                                                    }
                                                    out.println("</table>");
                                                    out.println("</div>");
                                                } else {
                                                    out.println("<p class='text-warning'>No payments found for this student.</p>");
                                                }
                                                
                                                // Get fee setups for expected fee group
                                                if (expectedFeeGroup != null) {
                                                    // Use the available getFeessetup method with broader parameters
                                                    List<Feessetup> feeSetups = sess.getFeessetup(expectedFeeGroup.getId(), "2024/2025", "First", studentSchoolId, programmeId);
                                                    out.println("<h6>Fee Setups for Expected Fee Group (" + feeSetups.size() + "):</h6>");
                                                    if (feeSetups.size() > 0) {
                                                        out.println("<div class='table-responsive'>");
                                                        out.println("<table class='table table-sm table-bordered'>");
                                                        out.println("<tr><th>Setup ID</th><th>Session</th><th>Semester</th><th>School</th><th>Programme</th><th>Level</th><th>Amount</th></tr>");
                                                        for (Feessetup setup : feeSetups) {
                                                            out.println("<tr>");
                                                            out.println("<td>" + setup.getId() + "</td>");
                                                            out.println("<td>" + setup.getSessionAdded() + "</td>");
                                                            out.println("<td>" + setup.getSemesterAdded() + "</td>");
                                                            out.println("<td>" + setup.getSchoolScope() + "</td>");
                                                            out.println("<td>" + setup.getProgrammeScope() + "</td>");
                                                            out.println("<td>" + setup.getLevelScope() + "</td>");
                                                            out.println("<td>N" + settings.formatno.format(setup.getAmount()) + "</td>");
                                                            out.println("</tr>");
                                                        }
                                                        out.println("</table>");
                                                        out.println("</div>");
                                                    } else {
                                                        out.println("<p class='text-warning'>No fee setups found for the expected fee group.</p>");
                                                    }
                                                }
                                                
                                                // Recommendations
                                                out.println("<h6>Recommendations:</h6>");
                                                out.println("<div class='alert alert-warning'>");
                                                if (expectedFeeGroup == null) {
                                                    out.println("<p><strong>Issue:</strong> No fee group found for school " + studentSchoolId + "</p>");
                                                    out.println("<p><strong>Solution:</strong> Create a 'SCHOOL FEES' fee group for this school using the form above.</p>");
                                                } else {
                                                    boolean hasMatchingPayment = false;
                                                    for (Payments payment : allPayments) {
                                                        if (payment.getFeesGroupId().getId().equals(expectedFeeGroup.getId())) {
                                                            hasMatchingPayment = true;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    if (!hasMatchingPayment) {
                                                        out.println("<p><strong>Issue:</strong> Student has payments but none match the expected fee group (" + expectedFeeGroup.getId() + ")</p>");
                                                        out.println("<p><strong>Solution:</strong> Either:</p>");
                                                        out.println("<ul>");
                                                        out.println("<li>Update the payment records to use fee group " + expectedFeeGroup.getId() + "</li>");
                                                        out.println("<li>Or create fee setups for the fee groups used in the payments</li>");
                                                        out.println("</ul>");
                                                    } else {
                                                        out.println("<p><strong>Status:</strong> Payment and fee group match. Check semester and session alignment.</p>");
                                                    }
                                                }
                                                out.println("</div>");
                                                
                                            } else {
                                                out.println("<p class='text-danger'>Student not found with ID: " + diagnosticStudentId + "</p>");
                                            }
                                        } catch (Exception e) {
                                            out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
                                            e.printStackTrace();
                                        }
                                    %>
                                </div>
                                <%
                                    }
                                %>
                                
                                <form action="" method="post" name="diagnosticForm">
                                    <div class="input-group mb-3">
                                        <span class="input-group-text">Student ID</span>
                                        <input type="text" class="form-control" name="diagnosticStudentId" 
                                               value="<%=diagnosticStudentId != null ? diagnosticStudentId : "2021116421"%>" 
                                               placeholder="Enter student registration number" required>
                                        <input type="submit" name="diagnosticButton" class="btn btn-primary" value="Diagnose"/>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Fee Groups Statistics -->
                        <div class="row mb-4">
                            <%
                                int totalFeeGroups = 0;
                                int schoolsWithFeeGroups = 0;
                                int schoolsWithoutFeeGroups = 0;
                                
                                try {
                                    List<Schools> allSchools = sess.getAllSchoos();
                                    for (Schools school : allSchools) {
                                        List<Feesgroup> feeGroups = sess.getFeesgroupBySchoolAndCategory(school.getId(), "ALL");
                                        if (feeGroups.isEmpty()) {
                                            schoolsWithoutFeeGroups++;
                                        } else {
                                            schoolsWithFeeGroups++;
                                            totalFeeGroups += feeGroups.size();
                                        }
                                    }
                                } catch (Exception k) {
                                    k.printStackTrace();
                                }
                            %>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card text-white bg-primary">
                                    <div class="card-body">
                                        <div class="fs-4 fw-semibold"><%=totalFeeGroups%></div>
                                        <div>Total Fee Groups</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card text-white bg-success">
                                    <div class="card-body">
                                        <div class="fs-4 fw-semibold"><%=schoolsWithFeeGroups%></div>
                                        <div>Schools with Fee Groups</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card text-white bg-warning">
                                    <div class="card-body">
                                        <div class="fs-4 fw-semibold"><%=schoolsWithoutFeeGroups%></div>
                                        <div>Schools without Fee Groups</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-xl-3">
                                <div class="card text-white bg-info">
                                    <div class="card-body">
                                        <div class="fs-4 fw-semibold"><%=schoolsWithFeeGroups + schoolsWithoutFeeGroups%></div>
                                        <div>Total Schools</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Display existing fee groups -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Existing Fee Groups (<%=totalFeeGroups%> total)</strong>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="schoolFilter" class="form-label">Filter by School:</label>
                                    <select id="schoolFilter" class="form-select" style="width: 300px;">
                                        <option value="">All Schools</option>
                                        <%
                                            try {
                                                List<Schools> allSchools = sess.getAllSchoos();
                                                for (Schools school : allSchools) {
                                        %>
                                        <option value="<%=school.getName()%>"><%=school.getName()%></option>
                                        <%
                                                }
                                            } catch (Exception k) {
                                            }
                                        %>
                                    </select>
                                </div>
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>School</th>
                                                <th>Fee Group ID</th>
                                                <th>Fee Group Name</th>
                                                <th>Description</th>
                                                <th>Category</th>
                                                <th>Session/Semester</th>
                                                <th>Repeat Payment</th>
                                                <th>Visibility</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    int rowNum = 1;
                                                    List<Schools> allSchools = sess.getAllSchoos();
                                                    for (Schools school : allSchools) {
                                                        List<Feesgroup> feeGroups = sess.getFeesgroupBySchoolAndCategory(school.getId(), "ALL");
                                                        if (feeGroups.isEmpty()) {
                                            %>
                                            <tr>
                                                <td><%=rowNum++%></td>
                                                <td><%=school.getName()%></td>
                                                <td colspan="7"><em>No fee groups configured</em></td>
                                            </tr>
                                            <%
                                                        } else {
                                                            for (Feesgroup fg : feeGroups) {
                                            %>
                                            <tr>
                                                <td><%=rowNum++%></td>
                                                <td><%=school.getName()%></td>
                                                <td><%=fg.getId()%></td>
                                                <td><%=fg.getName()%></td>
                                                <td><%=fg.getDescription() != null ? fg.getDescription() : ""%></td>
                                                <td><%=fg.getCategory() != null ? fg.getCategory() : ""%></td>
                                                <td><%=fg.getSessionSemester() != null ? fg.getSessionSemester() : ""%></td>
                                                <td><%=fg.getRepeatPayment() != null ? fg.getRepeatPayment() : ""%></td>
                                                <td><%=fg.getVisibility() != null ? fg.getVisibility() : ""%></td>
                                            </tr>
                                            <%
                                                            }
                                                        }
                                                    }
                                                } catch (Exception k) {
                                                    k.printStackTrace();
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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

        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

        <script>
            $(document).ready(function () {
                var table = new DataTable('#dataTable', {
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

                // School filter functionality
                $('#schoolFilter').on('change', function() {
                    var selectedSchool = this.value;
                    table.column(1).search(selectedSchool).draw();
                });
            });
        </script>
        <%
        } catch (Exception e) {
            // Handle any null pointer exceptions gracefully
            out.println("<div class='container-lg px-4'>");
            out.println("<div class='alert alert-danger'>");
            out.println("<h4>Session Error</h4>");
            out.println("<p>Your session has expired or there was an authentication error. Please <a href='/'>login again</a>.</p>");
            out.println("</div>");
            out.println("</div>");
            e.printStackTrace();
        }
        %>
    </body>
</html>