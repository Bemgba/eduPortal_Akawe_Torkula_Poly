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



<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - View Hostel Applicants</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">View Hostel Applicants</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <%    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        Hostelapplication appx = (Hostelapplication) sess.getSingleObject(Hostelapplication.class, id2);
        if (appx != null) {
            Hostelallocation alld = sess.getHostelallocation(appx.getStudentId().getId(), appx.getSessions());
            if (appx != null) {
                sess.deleteHostelallocation(alld.getId());
                appx.setApplicationStatus("PENDING");
                sess.updateRecord(appx);
                %>
                <div class="alert alert-success">Reservation has been revoked successfully!</div>
                        <%
            }
        }
    }

%>
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Session to view Applicants</strong></div>
                            <div class="card-body">
                                <%    String sessions = request.getParameter("sessions");
                                    String status = request.getParameter("status");
                                    List<Hostelapplication> happl = new ArrayList();
                                    String submit = request.getParameter("submit");
                                    if (submit != null && sessions != null && sessions.length() > 0) {

                                        happl = sess.getHostelapplicationBySessionAndStatus(sessions, status);
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Session</label>
                                                    <div class="col-sm-7">
                                                        <select name="sessions" class="form-select">
                                                            <option value="">Select One</option>

                                                            <%
                                                                List<Sessionmanager> sml = sess.getAllSessionmanager("S001", "REGISTRATION", "First");
                                                                for (Sessionmanager smd : sml) {
                                                            %>
                                                            <option value="<%=smd.getName()%>"><%=smd.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="col-sm-7">
                                                        <select name="status" class="form-select">
                                                            <option value="">Select One</option>
                                                            <option value="PENDING">PENDING</option>
                                                            <option value="RESERVED">RESERVED</option>
                                                            <option value="ALLOCATED">ALLOCATED</option>

                                                        </select>
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">List Records</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (happl.size() == 0) {
                            if (sessions != null && sessions.trim().length() > 0) {
                    %>
                    <div class='alert alert-warning'>No record found for <%=sessions%>!</div>
                    <%
                        }
                    } else {

                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong><%=status%> Applicants for <%=sessions%></strong></div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Hostel</th>
                                                <th>Date Started</th>
                                                <th>Date Allocated</th>
                                                <th>Status</th>
                                                <th>Registration No</th>
                                                <th>Full Name</th>
                                                <th>Course</th>
                                                <th>Level</th>
                                                <th>State</th>
                                                <th class="right">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Hostelapplication data : happl) {
                                                    List<Hostelrooms> htr = sess.getHostelsRooms(data.getHostelId().getId());
                                                    long cap = 0;
                                                    long rms = 0;
                                                    try {
                                                        cap = htr.stream().mapToLong(a -> a.getMaxCapacity()).sum();
                                                        rms = htr.size();
                                                    } catch (Exception k) {
                                                    }
                                                    Students stx = data.getStudentId();
                                                    String regno = stx.getRegistrationNo().toUpperCase();
                                                    if (stx.getMatricNo() != null) {
                                                        regno = stx.getMatricNo().toUpperCase();
                                                    }
                                                    String level = stx.getCurrentClass();
                                                    try {
                                                        Studentprogression pro = sess.getStudentprogressionByStdSessSem(stx.getId(), sessions, "First");
                                                        if (pro != null) {
                                                            level = pro.getLevelAdded();
                                                        }
                                                    } catch (Exception ka) {
                                                    }
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getHostelId().getName()%>(R:<%=rms%>,C:<%=cap%>)</td>
                                                <%
                                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                    String startd = "PENDING";
                                                    String alldate = "PENDING";
                                                    try {
                                                        startd = sdf.format(data.getDateStarted());
                                                    } catch (Exception s) {
                                                    }
                                                    try {
                                                        alldate = sdf.format(data.getDateAllocated());
                                                    } catch (Exception s) {
                                                    }
                                                %>
                                                <td><%=startd%></td>
                                                <td><%=alldate%></td>
                                                <td><%=data.getApplicationStatus()%></td>
                                                <td><%=regno%></td>
                                                <td><%=stx.getSurname() + " " + stx.getOthernames()%></td>
                                                <td><%=stx.getCourseId().getName()%></td>
                                                <td><%=level%></td>
                                                <% String sta = "Nil";
                                                    try {
                                                        sta = stx.getStateOfOrigin().getName();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=sta%></td>
                                                <td class="right">
                                                    <%
                                                        if (data.getApplicationStatus().equalsIgnoreCase("PENDING")) {
                                                            List<Payments> lpay = sess.getPaymentsByRegnoSessSemFeesgroup(stx.getId(), "10160", sessions, "Session");
                                                            if (lpay.size() > 0) {
                                                    %>
                                                    <a href="/view_hostel_app?id3=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-success btn-sm">Reserve</a>
                                                    <%
                                                    } else {
                                                    %>
                                                    No Application Payment
                                                    <%
                                                            }
                                                        }
                                                        if (data.getApplicationStatus().equalsIgnoreCase("RESERVED")) {
                                                    %>
                                                    <a href="/view_hostel_app?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-warning btn-sm">Revoke</a>
                                                    <%
                                                        }
                                                        if (data.getApplicationStatus().equalsIgnoreCase("ALLOCATED")) {
                                                            Hostelallocation hall = sess.getHostelallocation(stx.getId(), sessions);
                                                            if (hall != null) {
                                                    %>
                                                    <%=hall.getHostelRoomId().getRoomNo()%>
                                                    <%
                                                            }
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