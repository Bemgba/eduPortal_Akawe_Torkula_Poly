<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    String sessiond = null;
    String courseid = null;
    try {
        sessiond = (String) session.getAttribute("sessions");
        courseid = (String) session.getAttribute("cos");
    } catch (Exception k) {
    }
    if (sessiond == null || courseid == null) {
        response.sendRedirect("/adminssion_list");
    }

%>
<%    String idu = request.getParameter("idu");
    if (idu != null && idu.length() > 0) {
        idu = settings.decryptText(idu);

        Admissions adm = sess.getAdmissions(idu);
        if (adm != null) {
            try {
                sess.changeApplicantStatus(idu, "PAID");
                sess.deleteAdmissions(idu);
            } catch (Exception k) {
            }
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Admission List</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">

                    <h2 class="title">Admission List for <%=sessiond%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <a href="/adminssion_list" class="btn btn-danger">Back</a>
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
                                                <th>FACULTY</th>
                                                <th>DEPARTMENT</th>
                                                <th>COURSE</th>
                                                <th>REG NO</th>
                                                <th>SURNAME</th>
                                                <th>OTHER NAMES</th>
                                                <th>DATE OF BIRTH</th>
                                                <th>STATE OF ORIGIN</th>
                                                <th>LGA</th>
                                                <th>MOE</th>
                                                <th>MERIT TYPE</th>
                                                <th>STATUS</th>
                                                <th>ACTION</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    int i = 1;
                                                    List<Admissions> appl = sess.getAdmissionsByCourseStatus(courseid, sessiond, "ALL", "ALL","S001",1001);
                                                    appl.addAll(sess.getAdmissionsByCourseStatus(courseid, sessiond, "ALL", "ALL","S003",1001));
                                                    for (Admissions data : appl) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=data.getCourseId().getDepartmentId().getFacultyId().getName()%></td>
                                                <td><%=data.getCourseId().getDepartmentId().getName()%></td>
                                                <td><%=data.getCourseId().getName()%></td>
                                                <td><%=data.getId().toUpperCase()%></td>
                                                <td><%=data.getSurname()%></td>
                                                <td><%=data.getOthernames()%></td>
                                                <td><%=data.getDateOfBirth()%></td>
                                                <%
                                                    String state = "";
                                                    String lga = "";
                                                    try {
                                                        state = data.getStateOfOriginId().getName();
                                                        lga = data.getLgaId().getName();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=state%></td>
                                                <td><%=lga%></td>
                                                <td><%=data.getModeOfEntry()%></td>
                                                <td><%=data.getMeritType()%></td>
                                                <td><%=data.getAdmissionStatus()%></td>
                                                <%
                                                    if (data.getAdmissionStatus().equalsIgnoreCase("PENDING")) {
                                                %>
                                                <td><a href="/adminssion_view?idu=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                                <%
                                                } else {
                                                %>
                                                <td></td>
                                                <%
                                                    }
                                                %>




                                            </tr>
                                            <%
                                                        i++;
                                                    }
                                                } catch (Exception k) {
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