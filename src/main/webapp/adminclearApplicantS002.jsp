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
<%
    Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S002", "APPLICATION");
    
    // Check if S002 school exists
    if (sessmanx == null) {
        // S002 school no longer exists, redirect with error
        response.sendRedirect("/adminrolePages.jsp?error=school_not_available");
        return;
    }

    List<Courses> coursesl = sess.getCoursesBySchoolAndProgramme("S002", "1002");
    coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1004"));
    coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1005"));
%>

<%
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        Courses cos = sess.getCourses(id);
        if (cos != null && sessmanx != null) {
            session.setAttribute("cos", cos);
            session.setAttribute("sessions", sessmanx.getName());

            response.sendRedirect("/clear_pg");
        }
    }
%>

<%
    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        if (id2.equalsIgnoreCase("CLEAR")) {
            sess.autoScreen("S002", 1002);
            sess.autoScreen("S002", 1004);
            sess.autoScreen("S002", 1005);
        }
    }
%>


<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Clear Applicants</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Clear Applicants</h2>
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
                                        <p>This page allows you to clear applicants to allow them proceed with registration</p>
                                        <p>Always remember to confirm applicant's payments records before clearing</p>
                                        <!--<a href="/applicant_pg_clearance?id2=<%=settings.encodeUrl(settings.encryptText("CLEAR"))%>" class="btn btn-sm btn-primary">Auto Clear</a>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%                        if (sessmanx != null) {


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
                                                <th>Total Admitted</th>
                                                <th>Total Cleared</th>
                                                <th>Quota</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                    int i = 1;
                                                for (Courses data : coursesl) {
                                                    long admitted = 0;
                                                    long cleared = 0;
                                                    int quota = 0;
                                                    try {
                                                        Admissiontemplate admc = sess.getAdmissiontemplate(data.getId(), sessmanx.getName());
                                                        if (admc != null) {
                                                            quota = admc.getTotalMerit();
                                                        }
                                                    } catch (Exception k) {
                                                    }

                                                    try {
                                                        admitted = sess.getCountAdmissionsByCourseStatus(data.getId(), sessmanx.getName(), "ALL", "ALL");
                                                    } catch (Exception e) {
                                                    }

                                                    try {
                                                        cleared = sess.getCountStudentsByCourseSessionadm(data.getId(), sessmanx.getName(), "ALL");
                                                    } catch (Exception e) {
                                                    }

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>

                                                <td><%=admitted%></td>
                                                <td><%=cleared%></td>
                                                <td><%=quota%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/applicant_pg_clearance?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">View</a></td>
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