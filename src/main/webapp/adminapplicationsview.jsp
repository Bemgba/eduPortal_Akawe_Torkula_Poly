<%-- 
    Document   : adminapplicationsview
    Created on : January 2025
    Author     : BEMGBA
    Purpose    : View applications list for a specific course and session
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    String courseid = null;
    try {
        courseid = (String) session.getAttribute("cos");
    } catch (Exception k) {
    }

    // Handle direct parameter access for individual course view
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        Courses cos = sess.getCourses(id);
        if (cos != null) {
            session.setAttribute("cos", cos.getId());
            courseid = cos.getId();
        }
    }

    // Handle "ALL" case for viewing all applications OR specific course via id2
    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        if (id2.equalsIgnoreCase("ALL")) {
            session.setAttribute("cos", "ALL");
            courseid = "ALL";
        } else {
            // id2 contains a course ID
            Courses cos = sess.getCourses(id2);
            if (cos != null) {
                session.setAttribute("cos", cos.getId());
                courseid = cos.getId();
            }
        }
    }

    if (courseid == null) {
        response.sendRedirect("/adminssion_list");
        return;
    }
    
    // Build session map for all schools
    Map<String, String> schoolSessionMap = new HashMap<>();
    String[] schools = {"S001", "S002", "S003", "S004", "S005", "S006"};
    for (String schoolId : schools) {
        try {
            Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation(schoolId, "APPLICATION");
            if (sessmanx != null) {
                schoolSessionMap.put(schoolId, sessmanx.getName());
            }
        } catch (Exception e) {
            System.out.println("Warning: Could not get session for school " + schoolId);
        }
    }

%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Applications List</title>

        <style>
            .payment-status-badge {
                font-size: 0.85em;
                padding: 0.4em 0.6em;
                border-radius: 0.375rem;
                font-weight: 500;
            }

            .status-badge {
                font-size: 0.85em;
                padding: 0.4em 0.6em;
                border-radius: 0.375rem;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <%                        String courseTitle = "All Courses";
                        String displaySession = "Multiple Sessions";
                        if (!courseid.equalsIgnoreCase("ALL")) {
                            try {
                                Courses cos = sess.getCourses(courseid);
                                if (cos != null) {
                                    courseTitle = cos.getName();
                                    String schoolId = cos.getSchoolProgrammeId().getSchoolId().getId();
                                    if (schoolSessionMap.containsKey(schoolId)) {
                                        displaySession = schoolSessionMap.get(schoolId);
                                    }
                                }
                            } catch (Exception k) {
                            }
                        }
                    %>
                    <h2 class="title">Applications List for <%=courseTitle%> - <%=displaySession%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <a href="/adminssion_list" class="btn btn-danger">Back to Admission List</a>
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Application ID</th>
                                                <th>SURNAME</th>
                                                <th>OTHER NAMES</th>
                                                <th>EMAIL</th>
                                                <th>PHONE</th>
                                                <th>COURSE APPLIED</th>
                                                <th>APPLICATION TYPE</th>
                                                <th>DATE INITIATED</th>
                                                <th>APPLICATION STATUS</th>
                                                <th>PAYMENT STATUS</th>
                                                <th>STATE OF ORIGIN</th>
                                                <th>LGA</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    int i = 1;
                                                    List<Applicants> appl = new ArrayList<>();

                                                    if (courseid.equalsIgnoreCase("ALL")) {
                                                        // Get all applicants for all courses in all sessions
                                                        List<Courses> coursesl = new ArrayList<>();
                                                        
                                                        // S001 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S001", "1001"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S001", "1005"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S001", "1015"));
                                                        
                                                        // S002 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1002"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1004"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1005"));
                                                        
                                                        // S003 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S003", "1001"));
                                                        
                                                        // S004 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S004", "1002"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S004", "1004"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S004", "1005"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S004", "1017"));
                                                        
                                                        // S005 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S005", "1015"));
                                                        
                                                        // S006 programmes
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S006", "1016"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S006", "1017"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S006", "1018"));
                                                        coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S006", "1019"));

                                                        // Define all application types
                                                        List<String> appTypesToSearch = new ArrayList<>();
                                                        appTypesToSearch.add("dip");
                                                        appTypesToSearch.add("odip");
                                                        appTypesToSearch.add("UTME");
                                                        appTypesToSearch.add("Cert");
                                                        appTypesToSearch.add("HND");
                                                        appTypesToSearch.add("TVET");
                                                        appTypesToSearch.add("IJMBE SCIENCES");
                                                        appTypesToSearch.add("IJMBE SOS");
                                                        appTypesToSearch.add("IJMBE ARTS");

                                                        for (Courses course : coursesl) {
                                                            try {
                                                                // Get school ID for this course
                                                                String schoolId = course.getSchoolProgrammeId().getSchoolId().getId();
                                                                
                                                                // Get session for this school
                                                                String sessionForSchool = schoolSessionMap.get(schoolId);
                                                                
                                                                if (sessionForSchool != null) {
                                                                    List<Applicants> courseApplicants = sess.getApplicantsByCourseAndTypes(
                                                                        course.getId(), 
                                                                        sessionForSchool, 
                                                                        "ALL", 
                                                                        appTypesToSearch
                                                                    );
                                                                    appl.addAll(courseApplicants);
                                                                    
                                                                    System.out.println("DEBUG: Course " + course.getName() + " (School: " + schoolId + ", Session: " + sessionForSchool + ") - found " + courseApplicants.size() + " applicants");
                                                                } else {
                                                                    System.out.println("WARNING: No session found for school " + schoolId + ", course " + course.getName());
                                                                }
                                                            } catch (Exception e) {
                                                                System.out.println("ERROR: Failed to get applicants for course " + course.getName() + ": " + e.getMessage());
                                                            }
                                                        }
                                                    } else {
                                                        // Get applicants for specific course
                                                        List<String> appTypesToSearch = new ArrayList<>();
                                                        appTypesToSearch.add("dip");
                                                        appTypesToSearch.add("odip");
                                                        appTypesToSearch.add("UTME");
                                                        appTypesToSearch.add("Cert");
                                                        appTypesToSearch.add("HND");
                                                        appTypesToSearch.add("TVET");
                                                        appTypesToSearch.add("IJMBE SCIENCES");
                                                        appTypesToSearch.add("IJMBE SOS");
                                                        appTypesToSearch.add("IJMBE ARTS");

                                                        // Get the course to determine its school
                                                        Courses course = sess.getCourses(courseid);
                                                        if (course != null) {
                                                            String schoolId = course.getSchoolProgrammeId().getSchoolId().getId();
                                                            String sessionForSchool = schoolSessionMap.get(schoolId);
                                                            
                                                            if (sessionForSchool != null) {
                                                                appl = sess.getApplicantsByCourseAndTypes(courseid, sessionForSchool, "ALL", appTypesToSearch);
                                                                System.out.println("DEBUG: Course " + course.getName() + " (School: " + schoolId + ", Session: " + sessionForSchool + ") - found " + appl.size() + " applicants");
                                                            } else {
                                                                System.out.println("WARNING: No session found for school " + schoolId);
                                                            }
                                                        }
                                                    }

                                                    for (Applicants data : appl) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=data.getId().toUpperCase()%></td>
                                                <td><%=data.getSurname()%></td>
                                                <td><%=data.getOthernames()%></td>
                                                <td><%=data.getEmailAddress()%></td>
                                                <td><%=data.getPhoneNo()%></td>
                                                <td><%=data.getCourse1().getName()%></td>
                                                <td><%=data.getApplicationType()%></td>
                                                <td><%=settings.formatDate(data.getDateInitiated())%></td>

                                                <!-- Application Status -->
                                                <td>
                                                    <%
                                                        String statusBadge = "bg-secondary";
                                                        if (data.getStatus().equalsIgnoreCase("COMPLETED")) {
                                                            statusBadge = "bg-success";
                                                        } else if (data.getStatus().equalsIgnoreCase("NOT COMPLETED")) {
                                                            statusBadge = "bg-warning text-dark";
                                                        } else if (data.getStatus().equalsIgnoreCase("PENDING")) {
                                                            statusBadge = "bg-info";
                                                        }
                                                    %>
                                                    <span class="badge status-badge <%=statusBadge%>"><%=data.getStatus()%></span>
                                                </td>

                                                <!-- Payment Status -->
                                                <td>
                                                    <%
                                                        String paymentStatus = "UNPAID";
                                                        String paymentBadgeClass = "bg-danger";
                                                        String paymentIcon = "❌";

                                                        try {
                                                            // Check if there are any payments where payer_id = application.id
                                                            List<Payments> applicantPayments = sess.getPaymentsByRegno(data.getId());
                                                            if (!applicantPayments.isEmpty()) {
                                                                paymentStatus = "PAID";
                                                                paymentBadgeClass = "bg-success";
                                                                paymentIcon = "✅";
                                                            }
                                                        } catch (Exception ex) {
                                                            // Handle payment check error - default to UNPAID
                                                        }
                                                    %>
                                                    <span class="badge payment-status-badge <%=paymentBadgeClass%>"><%=paymentIcon%> <%=paymentStatus%></span>
                                                </td>

                                                <%
                                                    String state = "";
                                                    String lga = "";
                                                    try {
                                                        if (data.getStateOfOrigin() != null) {
                                                            state = data.getStateOfOrigin().getName();
                                                        }
                                                        if (data.getLga() != null) {
                                                            lga = data.getLga().getName();
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=state%></td>
                                                <td><%=lga%></td>
                                            </tr>
                                            <%
                                                        i++;
                                                    }
                                                } catch (Exception k) {
                                                    System.out.println("ERROR in applications view: " + k.getMessage());
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