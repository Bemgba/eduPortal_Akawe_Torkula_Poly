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
        <title><%=settings.productName%> - View Hostel Allocations</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">View Hostel Allocations</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Session to view Allocations</strong></div>
                            <div class="card-body">
                                <%    String sessions = request.getParameter("sessions");
                                    List<Hostels> happl = new ArrayList();
                                    String submit = request.getParameter("submit");
                                    if (submit != null && sessions != null && sessions.length() > 0) {

                                        happl = sess.getHostelsByStatusAndGender("ACTIVE", "Female");
                                        happl.addAll(sess.getHostelsByStatusAndGender("INACTIVE", "Female"));
                                        happl.addAll(sess.getHostelsByStatusAndGender("ACTIVE", "Male"));
                                        happl.addAll(sess.getHostelsByStatusAndGender("INACTIVE", "Male"));
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

                        } else {
                            long pending = sess.countHostelapplicationBySessionAndStatus(sessions, "PENDING");
                            long reserved = sess.countHostelapplicationBySessionAndStatus(sessions, "RESERVED");
                            long allocated = sess.countHostelapplicationBySessionAndStatus(sessions, "ALLOCATED");
                            long total = pending + reserved + allocated;
                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>Total Applicants: <%=total%>, PENDING: <%=pending%>, RESERVED: <%=reserved%>, ALLOCATED: <%=allocated%></strong></div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Hostel</th>
                                                <th>Rooms</th>
                                                <th>Capacity</th>
                                                <th>Status</th>
                                                <th>Gender</th>
                                                <th>Tot. Applicants</th>
                                                <th>Allocations</th>
                                                <th class="right">View</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                List<Hostelapplication> nor = sess.getHostelapplicationBySession(sessions);
                                                for (Hostels data : happl) {
                                                    List<Hostelrooms> htr = sess.getHostelsRooms(data.getId());
                                                    long cap = 0;
                                                    long rms = 0;
                                                    long nores = 0;
                                                    long tapp = 0;
                                                    try {
                                                        cap = htr.stream().mapToLong(a -> a.getMaxCapacity()).sum();
                                                        rms = htr.size();
                                                    } catch (Exception k) {
                                                    }
                                                    try {
                                                        long pendingb = sess.countHostelapplicationByHostelSessionAndStatus(data.getId(), sessions, "PENDING");
                                                        long reservedb = sess.countHostelapplicationByHostelSessionAndStatus(data.getId(), sessions, "RESERVED");
                                                        long allocatedb = sess.countHostelapplicationByHostelSessionAndStatus(data.getId(), sessions, "ALLOCATED");
                                                        long totalb = pendingb + reservedb + allocatedb;
                                                        tapp = totalb;
                                                        nores = allocatedb;

                                                    } catch (Exception k) {
                                                    }


                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>
                                                <td><%=rms%></td>
                                                <td><%=cap%></td>
                                                <td><%=data.getStatus()%></td>
                                                <td><%=data.getGender()%></td>
                                                <td><%=tapp%></td>
                                                <td><%=nores%></td>
                                                <td class="right">

                                                    <a href="/view_hostel_app?id3=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-success btn-sm">Details</a>

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