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
        <title><%=settings.productName%> - Activate Student</title>


    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title"> Activate Student</h2>
                </div>
            </header>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter Student Number</strong></div>
                            <div class="card-body">
                                <%    String stdno = request.getParameter("stdno");

                                    String submit = request.getParameter("submit");

                                %>
                                <div class="example">

                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <div class="col-sm-6">
                                                        <input id="stdno" name="stdno" placeholder="Enter Student's number" class='form-control' type="text" required=""/>
                                                    </div>

                                                    <div class="col-sm-6">
                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View</button>                       
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>





                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>List of records matching search text</div>
                            <div class="card-body">
                                <%                                    String ddx = request.getParameter("ddx");
                                    if (ddx != null && ddx.length() > 0) {
                                        ddx = settings.decryptText(ddx);
                                        Users usdx = sess.getUsers(ddx);
                                        if (usdx != null) {
                                            String stat = usdx.getStatus();
                                            if (stat.equalsIgnoreCase("ACTIVE")) {
                                                stat = "INACTIVE";
                                            } else {
                                                stat = "ACTIVE";
                                            }
                                            usdx.setStatus(stat);
                                            sess.updateUserStatus(usdx.getId(), stat);
                                        }
                                    }

                                %>
                                <%                                    String idu = request.getParameter("idu");
                                    if (idu != null && idu.length() > 0) {
                                        idu = settings.decryptText(idu);
                                        Students stdu = sess.getStudentsById(idu);
                                        if (stdu != null) {
                                            Users usdx = sess.getUsers(idu);
                                            if (usdx == null) {
                                                usdx = new Users(idu);
                                                Roles rox = sess.getRoles(1059);
                                                usdx.setDefaultRole(rox);
                                                String uid = stdu.getMatricNo() != null ? stdu.getMatricNo() : stdu.getReligion();
                                                usdx.setPassword(uid);
                                                usdx.setUsername(uid);
                                                usdx.setStatus("ACTIVE");
                                                sess.newUsers(usdx);
                                %>
                                <div class="alert alert-success">Student's account has been created for  <%=stdu.getSurname() + " " + stdu.getOthernames()%>  with username and password as <%=uid%></div>
                                <%

                                            }
                                        }
                                    }
                                %>
                                <%    if (submit != null && stdno != null && stdno.length() > 0) {
                                        stdno = stdno.toLowerCase();
                                        Students stdu = sess.getStudentsById(stdno);
                                        if (stdu == null) {
                                %>
                                <div class="alert alert-danger">Student's number <%=stdno%> is not found</div>
                                <%
                                } else {
                                    Users usd = sess.getUsers(stdu.getId());
                                    if (usd == null) {
                                %>
                                <div class="alert alert-warning">Student <%=stdu.getSurname() + " " + stdu.getOthernames()%> is found matching <%=stdno%> but does not have login details. <br/>
                                    Kindly click <a href="/std_activate?idu=<%=settings.encodeUrl(settings.encryptText(stdu.getId()))%>" class="btn btn-warning btn-sm">here</a> to create account</div>
                                    <%
                                    } else {
                                    %>


                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th>Username</th>
                                                <th>Student's name</th>
                                                <th>Last Login</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                            <tr>
                                                <td><%=usd.getUsername()%></td>
                                                <td><%=stdu.getSurname() + " " + stdu.getOthernames()%></td>
                                                <%
                                                    String lastlogin = "Nil";
                                                    try {
                                                        lastlogin = settings.formatDate(usd.getDatelastlogin());
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=lastlogin%></td>
                                                <% String sty = "danger";
                                                    if (usd.getStatus().equalsIgnoreCase("ACTIVE")) {
                                                        sty = "success";
                                                    }
                                                %>
                                                <td><a href="/std_activate?ddx=<%=settings.encodeUrl(settings.encryptText(usd.getId()))%>" class='btn btn-sm btn-<%=sty%>'><%=usd.getStatus()%></a></td>

                                            </tr>



                                        </tbody>
                                    </table>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                %>
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