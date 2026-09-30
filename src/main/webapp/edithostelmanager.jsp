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
    Hostels data = null;
    try {
        data = (Hostels) session.getAttribute("host");
    } catch (Exception k) {
    }
    if (data == null) {
        response.sendRedirect("/hostel_manager");
    }
%>



<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Edit <%=data.getName()%></title>

    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Edit <%=data.getName()%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">



                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">Kindly edit hostel details from here
                                <a href="/hostel_manager" class="btn btn-danger btn-sm float-end">Back</a>
                            </div>

                        </div>
                        <div class="card mb-4">
                            <%
                                String hostelname = request.getParameter("hostelname");
                                String location = request.getParameter("location");
                                String status = request.getParameter("status");
                                String appstatus = request.getParameter("appstatus");
                                String fees = request.getParameter("fees");
                                String button3 = request.getParameter("button3");
                                if (button3 != null && button3.length() > 0) {
                                    try {
                                        data.setFee(Double.parseDouble(fees));
                                        data.setLocation(location);
                                        data.setName(hostelname);
                                        data.setStatus(status);
                                        data.setApplicationStatus(appstatus);
                                        sess.updateRecord(data);
                                        data = (Hostels) sess.getSingleObject(Hostels.class, data.getId());
                            %>
                            <div class="alert alert-success">Record has been updated successfully</div>
                            <%
                                    } catch (Exception k) {
                                    }
                                }
                            %>
                            <div class="card-body">
                                <form name="edit2<%=data.getId()%>" method="post" action="">
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Hostel Name
                                        </span>
                                        <input type="text" value="<%=data.getName()%>" class="form-control" name="hostelname" required=""/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Location
                                        </span>
                                        <input type="text" value="<%=data.getLocation()%>" class="form-control" name="location" required=""/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Status
                                        </span>
                                        <select name="status" class="form-select">
                                            <option value="ACTIVE" <%=data.getStatus().equalsIgnoreCase("ACTIVE") ? "selected=\"\"" : ""%>">ACTIVE</option>
                                            <option value="INACTIVE" <%=data.getStatus().equalsIgnoreCase("INACTIVE") ? "selected=\"\"" : ""%>">INACTIVE</option> 
                                        </select>
                                    </div>
                                         <div class="input-group mb-4"><span class="input-group-text">
                                           Application Status
                                        </span>
                                        <select name="appstatus" class="form-select">
                                            <option value="OPEN" <%=data.getApplicationStatus().equalsIgnoreCase("OPEN") ? "selected=\"\"" : ""%>">OPEN</option>
                                            <option value="CLOSED" <%=data.getApplicationStatus().equalsIgnoreCase("CLOSED") ? "selected=\"\"" : ""%>">CLOSED</option> 
                                        </select>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Fees
                                        </span>
                                        <input type="number" value="<%=data.getFee()%>" min="0" class="form-control" name="fees" required=""/>
                                    </div>

                                    <div class="row">
                                        <div class="col-6">
                                            <input type="submit" name="button3" class="btn btn-primary px-4" value="Edit"/>
                                        </div>
                                    </div>

                                </form>

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

                new DataTable('#dataTable2', {
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