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
    String idu = request.getParameter("id");
    if (idu != null) {
        idu = settings.decryptText(idu);
        Hostels host = (Hostels) sess.getSingleObject(Hostels.class, idu);
        if (host != null) {
            session.setAttribute("host", host);
            response.sendRedirect("/edit_hostel_manager");
        }
    }
%>

<%
    String idu2 = request.getParameter("id2");
    if (idu2 != null) {
        idu2 = settings.decryptText(idu2);
        Hostelrooms host = (Hostelrooms) sess.getSingleObject(Hostelrooms.class, idu2);
        if (host != null) {
            session.setAttribute("rooms", host);
            response.sendRedirect("/edit_hostel_rooms");
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Manage Hostels</title>

    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Manage Hostels</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12 alert alert-info">
                        This platform allows you to edit, rearrange, number and activate/deactivate hostels and rooms. 
                        <p>Kindly contact ICT if you want to add additional hostels or rooms</p>
                    </div>



                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-body">

                                <div class="accordion" id="accordionExample">
                                    <%                                        try {

                                            List<Hostels> hostels = sess.getHostelsByStatusAndGender("ACTIVE", "Female");
                                            hostels.addAll(sess.getHostelsByStatusAndGender("ACTIVE", "Male"));
                                            hostels.addAll(sess.getHostelsByStatusAndGender("INACTIVE", "Female"));
                                            hostels.addAll(sess.getHostelsByStatusAndGender("INACTIVE", "Male"));
                                            for (Hostels data : hostels) {
                                                List<Hostelrooms> lrooms = sess.getHostelsRooms(data.getId());
                                                int sum = 0;
                                                try {
                                                    sum = lrooms.stream()
                                                            .mapToInt(a -> a.getMaxCapacity())
                                                            .sum();
                                                } catch (Exception k) {
                                                }


                                    %>
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="heading<%=data.getId()%>">
                                            <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapse<%=data.getId()%>" aria-expanded="false" aria-controls="collapse<%=data.getId()%>">
                                                <%=data.getName()%>(R=<%=lrooms.size()%>, C=<%=sum%>)
                                            </button>
                                        </h2>
                                        <div class="accordion-collapse collapse" id="collapse<%=data.getId()%>" aria-labelledby="heading<%=data.getId()%>" data-coreui-parent="#accordionExample" style="">
                                            <div class="accordion-body">
                                                <table class="table table-striped">
                                                    <tr>
                                                        <th>Name:</th>
                                                        <td><%=data.getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Gender:</th>
                                                        <td><%=data.getGender()%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Location:</th>
                                                        <td><%=data.getLocation()%></td>
                                                    </tr>
                                                    <%
                                                        String ssty = "danger";
                                                        String asty = "warning";
                                                        try {
                                                            if (data.getStatus().equalsIgnoreCase("ACTIVE")) {
                                                                ssty = "success";
                                                            }
                                                            if (data.getApplicationStatus().equalsIgnoreCase("OPEN")) {
                                                                asty = "success";
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                    <tr>
                                                        <th>Status:</th>
                                                        <td><span class="alert alert-<%=ssty%>"><%=data.getStatus()%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Application Status:</th>
                                                        <td><span class="alert alert-<%=ssty%>"><%=data.getApplicationStatus()%></span></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Fees:</th>
                                                        <td>N<%=settings.formatno.format(data.getFee())%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Rooms:</th>
                                                        <td><%=lrooms.size()%></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Total Capacity:</th>
                                                        <td><%=sum%></td>
                                                    </tr>
                                                    <tr>
                                                        <th></th>
                                                        <td>
                                                            <a href="/hostel_manager?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-primary btn-sm">Edit</a>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Room Number</th>
                                                                <th>Capacity</th>    
                                                                <th>Status</th>   
                                                                <th>Action</th>                     
                                                                <th>History</th>                     
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                int i = 1;
                                                                for (Hostelrooms item : lrooms) {
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=item.getRoomNo().toUpperCase()%></td>
                                                                <td><%=item.getMaxCapacity()%></td>
                                                                <td><%=item.getRoomStatus()%></td>
                                                                <td><a href="/hostel_manager?id2=<%=settings.encodeUrl(settings.encryptText(item.getId()))%>" class="btn btn-primary btn-sm">Edit</a></td>
                                                                <td><a href="/hostel_manager?id3=<%=settings.encodeUrl(settings.encryptText(item.getId()))%>" class="btn btn-secondary btn-sm">View</a></td>
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
                                    <%                                                }

                                        } catch (Exception k) {
                                        }
                                    %>


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