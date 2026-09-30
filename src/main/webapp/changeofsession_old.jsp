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
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Session Manager</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Session Manager</h2>
                </div>
            </header>
            <%                    String idx = request.getParameter("idx");
                if (idx != null && idx.length() > 0) {
                idx = settings.decryptText(idx);
                    Sessionmanager smu = sess.getSessionmanager(idx);
                    if (smu != null) {
                        String newst = "OPEN";
                        if (smu.getStatus().equalsIgnoreCase("OPEN")) {
                            newst = "CLOSED";
                        }
                        smu.setStatus(newst);
                        sess.updateSessionmanager(smu);
                        
                    }
                }
            %>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <p>
                                <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>
                            </p>
                            <div class="collapse" id="collapseExample" style="">
                                <div class="alert alert-warning">
                                    <p>This operation should be performed with high level of care as it will but be reversed thereafter.</p>
                                    <p>The change of session Operation should be performed after due verification from the University Management</p>
                                    <p>This operation is open for both Application and Registration</p>
                                    <p>If it is a total change of session for registration, Student's classes will be promoted asside other operations</p>

                                </div>
                            </div>
                            <div class="card-header"><strong>Select Session to Create</strong></div>
                            <div class="card-body">
                                <%    
                                    String sessiond = request.getParameter("sessiond");
                                    String semester = request.getParameter("semester");
                                    String schools = request.getParameter("schools");
                                    String operation = request.getParameter("operation");
                                    String button = request.getParameter("button");
                                    String processProgression = request.getParameter("processProgression");

                                    List<Sessionmanager> sessionlist = sess.getAllSessionmanager();
                                    String submit = request.getParameter("submit");
                                    String createdSessionId = null;
                                    
                                    // Handle session creation
                                    if (button != null && sessiond != null && sessiond.length() > 0) {
                                        List<Sessionmanager> sublist = sessionlist.stream()
                                                .filter(d -> d.getName().equalsIgnoreCase(sessiond) && d.getOperation().equalsIgnoreCase(operation)
                                                && d.getSemester().equalsIgnoreCase(semester) && d.getSchoolId().getId().equalsIgnoreCase(schools))
                                                .toList();
                                        if (sublist.size() > 0) {
                                %>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i> This session is already created
                                </div>
                                <%
                                        } else {
                                            String id = sessiond.split("/")[0] + settings.generateId("", 4);
                                            Sessionmanager smu = new Sessionmanager(id);
                                            smu.setName(sessiond);
                                            smu.setOperation(operation);
                                            Schools sch = sess.getSchools(schools);
                                            smu.setSchoolId(sch);
                                            smu.setSemester(semester);
                                            smu.setStartDate(settings.getCurrentDateTime());
                                            smu.setStatus("OPEN");
                                            
                                            // Create session (without progression)
                                            sess.newSessionmanager(smu);
                                            createdSessionId = id;
                                            
                                            sessionlist = sess.getAllSessionmanager();
                                %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> 
                                    <strong>Session Created Successfully!</strong><br>
                                    Session: <strong><%=sessiond%></strong>, Semester: <strong><%=semester%></strong>, Operation: <strong><%=operation%></strong>
                                </div>
                                
                                <%
                                            // If this is a REGISTRATION session, show progression processing option
                                            if (operation.equalsIgnoreCase("REGISTRATION")) {
                                %>
                                <div class="card border-info mb-3">
                                    <div class="card-header bg-info text-white">
                                        <i class="fas fa-users"></i> Student Progression Processing
                                    </div>
                                    <div class="card-body">
                                        <p>
                                            <strong>Important:</strong> This session requires student progression to be created.
                                            This process will update all students' progression records for the new session.
                                        </p>
                                        <p class="text-muted">
                                            <i class="fas fa-info-circle"></i> 
                                            Processing is done in batches to prevent system timeout. 
                                            This may take several minutes depending on the number of students.
                                        </p>
                                        <p class="text-warning">
                                            <i class="fas fa-exclamation-triangle"></i> 
                                            <strong>Monitor Progress:</strong> Check the server console logs for real-time progress updates during processing.
                                        </p>
                                        <form action="" method="post" id="progressionForm">
                                            <input type="hidden" name="processProgression" value="<%=id%>">
                                            <button type="submit" class="btn btn-primary btn-lg" id="processBtn">
                                                <i class="fas fa-cogs"></i> Start Processing (Check Console for Progress)
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                    
                                    // Handle progression processing
                                    if (processProgression != null && processProgression.length() > 0) {
                                %>
                                <div class="card border-primary mb-3">
                                    <div class="card-header bg-primary text-white">
                                        <i class="fas fa-check-circle"></i> Processing Completed
                                    </div>
                                    <div class="card-body">
                                        <div class="alert alert-info mb-3">
                                            <i class="fas fa-info-circle"></i> 
                                            <strong>Note:</strong> Processing happens on the server. Check server console logs for real-time progress updates.
                                        </div>
                                        <%
                                            try {
                                                long startTime = System.currentTimeMillis();
                                                
                                                // Process progression in batches
                                                java.util.Map<String, Object> result = sess.createSessionProgressionBatched(processProgression);
                                                
                                                long endTime = System.currentTimeMillis();
                                                long duration = (endTime - startTime) / 1000; // seconds
                                                
                                                Boolean success = (Boolean) result.get("success");
                                                Integer totalStudents = (Integer) result.get("totalStudents");
                                                Integer processedStudents = (Integer) result.get("processedStudents");
                                                Integer failedStudents = (Integer) result.get("failedStudents");
                                                Integer batchSize = (Integer) result.get("batchSize");
                                                Integer totalBatches = (Integer) result.get("totalBatches");
                                                
                                                if (success != null && success) {
                                        %>
                                        <div class="alert alert-success">
                                            <h5><i class="fas fa-check-circle"></i> Progression Processing Completed Successfully!</h5>
                                            <hr>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong>Total Students:</strong> <%=totalStudents%></p>
                                                    <p><strong>Processed:</strong> <%=processedStudents%></p>
                                                    <p><strong>Duration:</strong> <%=duration%> seconds</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p><strong>Batch Size:</strong> <%=batchSize%> students/batch</p>
                                                    <p><strong>Total Batches:</strong> <%=totalBatches%></p>
                                                    <p><strong>Avg Time/Batch:</strong> <%=String.format("%.2f", (double)duration/totalBatches)%> seconds</p>
                                                </div>
                                            </div>
                                        </div>
                                        <%
                                                } else {
                                                    java.util.List<String> errors = (java.util.List<String>) result.get("errors");
                                        %>
                                        <div class="alert alert-warning">
                                            <h5><i class="fas fa-exclamation-triangle"></i> Progression Processing Completed with Errors</h5>
                                            <hr>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong>Total Students:</strong> <%=totalStudents%></p>
                                                    <p><strong>Processed:</strong> <%=processedStudents%></p>
                                                    <p><strong>Failed:</strong> <%=failedStudents%></p>
                                                    <p><strong>Duration:</strong> <%=duration%> seconds</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p><strong>Batch Size:</strong> <%=batchSize%> students/batch</p>
                                                    <p><strong>Total Batches:</strong> <%=totalBatches%></p>
                                                    <p><strong>Success Rate:</strong> <%=String.format("%.1f", (processedStudents * 100.0) / totalStudents)%>%</p>
                                                </div>
                                            </div>
                                            <%
                                                if (errors != null && !errors.isEmpty()) {
                                            %>
                                            <hr>
                                            <p><strong>Errors:</strong></p>
                                            <div style="max-height: 300px; overflow-y: auto;">
                                                <ul>
                                                    <%
                                                        for (String error : errors) {
                                                    %>
                                                    <li><%=error%></li>
                                                    <%
                                                        }
                                                    %>
                                                </ul>
                                            </div>
                                            <%
                                                }
                                            %>
                                        </div>
                                        <%
                                                }
                                            } catch (Exception e) {
                                        %>
                                        <div class="alert alert-danger">
                                            <h5><i class="fas fa-times-circle"></i> Error Processing Progression</h5>
                                            <p><%=e.getMessage()%></p>
                                        </div>
                                        <%
                                                e.printStackTrace();
                                            }
                                        %>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Session
                                            </span>
                                            <%                                               Sessionmanager smx = sess.getLatestSession();
                                                String latestsess = settings.getSessionAfter(smx.getName());
                                                List<String> smxx = settings.getSessionsBefore(latestsess, 5);

                                            %>
                                            <select class="form-select" name="sessiond" id="sessiond">
                                                <option value="">Select One</option>
                                                <%                                                    try {
                                                        for (String data : smxx) {
                                                %>
                                                <option value="<%=data%>"><%=data%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Semester
                                            </span>
                                            <select class="form-select" name="semester" id="semester">
                                                <option value="">Select One</option>
                                                <option value="First">First</option>
                                                <option value="Second">Second</option>
                                                <option value="Session">Session</option>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select School
                                            </span>
                                            <%                                                List<Schools> schl = sess.getAllSchoos();
                                            %>
                                            <select class="form-select" name="schools" id="schools" onchange="loadItems();">
                                                <option value="">Select One</option>
                                                <%
                                                    try {
                                                        for (Schools sch : schl) {
                                                %>
                                                <option value="<%=sch.getId()%>"><%=sch.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Operation
                                            </span>
                                            <select class="form-select" name="operation" id="operation">
                                                <option value="">Select One</option>
                                                <option value="APPLICATION">APPLICATION</option>
                                                <option value="REGISTRATION">REGISTRATION</option>
                                            </select>
                                        </div>


                                        <div class="row">
                                            <div class="col-12">
                                                <input type="submit" name="button" class="btn btn-primary px-4" value="Create"/>
                                            </div>

                                        </div>

                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (sessionlist.size() == 0) {
                    %>
                    <div class='alert alert-warning'>No Session manager record found!</div>
                    <%
                    } else {

                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>List of Session managers</div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>School</th>
                                                <th>Session</th>
                                                <th>Semester</th>
                                                <th>Operation</th>
                                                <th>Opened</th>
                                                <th>Status</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                int i = 1;
                                                for (Sessionmanager data : sessionlist) {
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getSchoolId().getName()%></td>
                                                <td><%=data.getName()%></td>
                                                <td><%=data.getSemester()%></td>
                                                <td><%=data.getOperation()%></td>
                                                <%
                                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = "";
                                                    try{
                                                    formattedDate=sdf.format(data.getStartDate());
                                                    }catch(Exception k){}
                                                %>
                                                <td><%=formattedDate%></td>
                                                <%
                                                    String st = data.getStatus();
                                                    String sty = "danger";
                                                    if (st.equalsIgnoreCase("OPEN")) {
                                                        sty = "success";
                                                    }
                                                %>

                                                <td><a href="/session_change?idx=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-<%=sty%> btn-sm"><%=data.getStatus()%></a></td>
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
                    %>


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
                                                    
                                                    // Handle progression processing form submission
                                                    $('#progressionForm').on('submit', function(e) {
                                                        var btn = $('#processBtn');
                                                        btn.prop('disabled', true);
                                                        btn.html('<i class="fas fa-spinner fa-spin"></i> Processing... Please wait');
                                                        
                                                        // Show warning that this may take time
                                                        if (!confirm('This process may take several minutes depending on the number of students. Do you want to continue?')) {
                                                            e.preventDefault();
                                                            btn.prop('disabled', false);
                                                            btn.html('<i class="fas fa-cogs"></i> Process Student Progression Now');
                                                            return false;
                                                        }
                                                    });

                                                });
        </script>
    </body>
</html>