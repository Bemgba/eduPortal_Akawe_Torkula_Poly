<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>
<%
    // Build session map for all schools
    Map<String, Sessionmanager> schoolSessionMap = new HashMap<>();
    String[] schools = {"S001", "S002", "S003", "S004", "S005", "S006"};
    for (String schoolId : schools) {
        try {
            Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation(schoolId, "APPLICATION");
            if (sessmanx != null) {
                schoolSessionMap.put(schoolId, sessmanx);
            }
        } catch (Exception e) {
            System.out.println("Warning: Could not get session for school " + schoolId);
        }
    }
    
    // Use S001 session as default for display purposes (or first available)
    Sessionmanager defaultSession = schoolSessionMap.get("S001");
    if (defaultSession == null && !schoolSessionMap.isEmpty()) {
        defaultSession = schoolSessionMap.values().iterator().next();
    }
%>

<%
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        Courses cos = sess.getCourses(id);
        if (cos != null && defaultSession != null) {
            session.setAttribute("cos", cos.getId());
            
            // Get the appropriate session for this course's school
            String schoolId = cos.getSchoolProgrammeId().getSchoolId().getId();
            Sessionmanager courseSession = schoolSessionMap.get(schoolId);
            if (courseSession != null) {
                session.setAttribute("sessions", courseSession.getName());
            } else {
                session.setAttribute("sessions", defaultSession.getName());
            }
            
            response.sendRedirect("/adminssion_view");
        }
    }
%>

<%
    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        if(id2.equalsIgnoreCase("ALL") && defaultSession != null) {
            session.setAttribute("cos", "ALL");
            session.setAttribute("sessions", "Multiple Sessions");
            
            response.sendRedirect("/adminssion_view");
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - UTME Admissions</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">UTME Admissions</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>This page allows you to process admission for only UTME and DE applicants.</p>
                                        <p>You can add one by one or upload an excel file one course at a time</p>
                                        <p>You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format</p>
                                        <p>Always remember to confirm your upload report that it is what you intend to upload and in the desired course before leaving</p>

                                        <%                                       
                                            if (defaultSession != null) {
                                        %>
                                        <p>Admissions are being processed for multiple sessions across different schools. Each school may have its own active session.</p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">
                               
                                <a href="/Downloadadmissionlist?id=<%=settings.encodeUrl(settings.encryptText(defaultSession != null ? defaultSession.getName() : ""))%>" class="btn btn-warning btn-sm float-end">Download Full List</a>    
                                <a href="/adminssion_list?id2=<%=settings.encodeUrl(settings.encryptText("ALL"))%>" class="btn btn-primary btn-sm float-end">View Full Admission List</a>    
                                <a href="/applications_view?id2=<%=settings.encodeUrl(settings.encryptText("ALL"))%>" class="btn btn-info btn-sm float-end">View All Applications</a>    


                                <button type="button" class="btn btn-success btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                    Add to Admission
                                </button>

                                <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Add applicant to admission list</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action='' method='post' name="verify2">
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Enter Jamb Number
                                                        </span>
                                                        <input type="text" name="jambno" id="jambno" class="form-control" required=""/>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Full Name
                                                        </span>
                                                        <input type="text" name="fullname" id="fullname" class="form-control" readonly="" />
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Course Applied
                                                        </span>
                                                        <input type="text" name="courseapplied" id="courseapplied" class="form-control" readonly=""/>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Course Admitted into
                                                        </span>
                                                        <select class="form-select" name="courses" id="courses">
                                                            <option value="">Select One</option>
                                                            <%                        
                                                                List<Courses> coursesl = sess.getAllCourses();
                                                                
                                                                for (Courses course : coursesl) {
                                                            %>
                                                            <option value="<%=course.getId()%>"><%=course.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Mode of Entry
                                                        </span>
                                                        <select class="form-select" name="moe" id="moe">
                                                            <option value="">Select One</option>

                                                            <option value="UTME">UTME</option>
                                                            <option value="DE">DE</option>

                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Merit Type
                                                        </span>
                                                        <select class="form-select" name="merittype" id="merittype">
                                                            <option value="">Select One</option>

                                                            <option value="NM">National Merit</option>
                                                            <option value="SM">State Merit</option>
                                                            <option value="ELG">Equality of LGA</option>
                                                            <option value="LM">Locality</option>
                                                            <option value="SPECIAL">Special Merit</option>
                                                        </select>
                                                    </div>


                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button2" class="btn btn-success px-4" value="Add to Admission"/>
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

                                <button type="button" class="btn btn-secondary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#uploadadm">
                                    Upload admission list
                                </button>

                                <div class="modal fade" id="uploadadm" tabindex="-1" aria-labelledby="uploadsLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="uploadsLabel">Upload admission list per course</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action='UploadJambAdmissionlist' method='post' name="verify4" enctype="multipart/form-data">

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Course Admitted into
                                                        </span>
                                                        <select class="form-select" name="courses" id="courses">
                                                            <option value="">Select One</option>
                                                            <%    
                                                                for (Courses course : coursesl) {
                                                            %>
                                                            <option value="<%=course.getId()%>"><%=course.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select admission file (<a href="templates/admissionlist.xls" target="_blank">Download template</a>)
                                                        </span>
                                                        <input type="file" name="uploadfile" id="uploadfile" class="form-control" accept=".xls" required=""/>
                                                    </div>



                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button3" class="btn btn-success px-4" value="Upload Admission"/>
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
                        </div>
                    </div>

                    <%
                        if (defaultSession != null) {
                            // Get all courses from all school-programme associations
                            coursesl = sess.getAllCourses();

                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Course</th>
                                                <th>Total Applicants <small>(click to view)</small></th>
                                                <th>Total Admitted</th>
                                                <th>Admission Quota</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                    int i = 1;
                                                for (Courses data : coursesl) {
                                                    long app = 0;
                                                    long adm = 0;
                                                    int quota = 0;
                                                    
                                                    // Get school ID for this course
                                                    String schoolId = data.getSchoolProgrammeId().getSchoolId().getId();
                                                    Sessionmanager courseSession = schoolSessionMap.get(schoolId);
                                                    
                                                    if (courseSession == null) {
                                                        System.out.println("WARNING: No session found for school " + schoolId + ", course " + data.getName());
                                                        continue;
                                                    }
                                                    
                                                    try {
                                                        Admissiontemplate admc = sess.getAdmissiontemplate(data.getId(), courseSession.getName());
                                                        if (admc != null) {
                                                            quota = admc.getTotalMerit();
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                    try {
                                                        // Count ALL applicants for this course/session - no type filter
                                                        app = sess.getCountApplicantsByCourse(data.getId(), courseSession.getName(), "ALL");
                                                    } catch (Exception e) {
                                                        // Skip on error
                                                    }
                                                    
                                                    try {
                                                        adm = sess.getCountAdmissionsByCourseStatus(data.getId(), courseSession.getName(), "ALL", "ALL");
                                                    } catch (Exception e) {
                                                    }

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>

                                                <td><a href="/applications_view?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-link p-0" title="Click to view all applications for this course"><%=app%></a></td>
                                                <td><%=adm%></td>
                                                <td><%=quota%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/adminssion_list?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">View</a></td>
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
                
            });
        </script>
    </body>
</html>