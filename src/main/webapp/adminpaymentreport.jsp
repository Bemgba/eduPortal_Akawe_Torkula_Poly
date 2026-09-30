<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.Optional"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%   
 if (user == null) {
        response.sendRedirect("/");
        return;
    }
%>


<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - School Fees Performance</title>

        <%                                    String sch = request.getParameter("schools");
            String fac = request.getParameter("fac");
            String startsess = request.getParameter("startsesion");
            String endsess = request.getParameter("endsession");
            String msg = "";
            String sty = "danger";
            String submit = request.getParameter("button2");
        %>

    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">School Fees Performance</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select query criteria</strong></div>
                            <div class="card-body">

                                <div class="example">
                                    <form name="edit" method="post" action="">
                                        <div class="input-group mb-3"><span class="input-group-text">
                                                Select School   
                                            </span>
                                            <select class="form-select" name="schools" id="schools">
                                                <option value="">Select School</option>
                                                <%                                                            try {
                                                        List<Schools> lsch = sess.getAllSchoos();
                                                        for (Schools prod : lsch) {
                                                %>
                                                <option value="<%=prod.getId()%>"> <%=prod.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Faculty 
                                            </span>
                                            <select class="form-select" name="fac" id="fac">
                                                <option value="">Select Faculty</option>
                                                <%                                                            try {
                                                        List<FacultiesDirectorates> lsch = sess.getAllFacultiesDirectorates();
                                                        for (FacultiesDirectorates prod : lsch) {
                                                %>
                                                <option value="<%=prod.getId()%>"> <%=prod.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Start Session
                                            </span>
                                            <select class="form-select" name="startsesion" id="startsesion">
                                                <option value="">Select Session</option>
                                                <%                                                            try {
                                                        Sessionmanager smx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "REGISTRATION");
                                                        String start = settings.listSession;
                                                        String currsess = smx.getName();
                                                        while (currsess.compareToIgnoreCase(start) >= 0) {
                                                %>
                                                <option value="<%=currsess%>"><%=currsess%></option>
                                                <%
                                                            currsess = settings.getSessionBefore(currsess);
                                                        }

                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select End Session
                                            </span>
                                            <select class="form-select" name="endsession" id="endsession">
                                                <option value="">Select Session</option>
                                                <%                                                            try {
                                                        Sessionmanager smx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "REGISTRATION");
                                                        String start = settings.listSession;
                                                        String currsess = smx.getName();
                                                        while (currsess.compareToIgnoreCase(start) >= 0) {
                                                %>
                                                <option value="<%=currsess%>"><%=currsess%></option>
                                                <%
                                                            currsess = settings.getSessionBefore(currsess);
                                                        }

                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="row">
                                            <div class="col-6">
                                                <input type="submit" name="button2" class="btn btn-success px-4" value="View Records"/>
                                            </div>
                                        </div>

                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (submit != null && startsess != null && startsess.length() > 0 && endsess != null && endsess.length() > 0) {
                            String facname = "";
                            try {
                                FacultiesDirectorates fd = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, fac);
                                if (fd != null) {
                                    facname = fd.getName();
                                }
                            } catch (Exception k) {
                            }

                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>School fees performance in <%=facname%> from <%=startsess%> to <%=endsess%>. Select Course to view Details</strong>
                            </div>
                            <div class="card-body">

                                <div class="tab-content rounded-bottom">
                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1006">
                                        <div class="row g-4">
                                            <%
                                                List<Courses> coursel = sess.getCoursesBySchoolAndFaculty(sch, fac);
                                                for (Courses data : coursel) {

                                                    String id = data.getId() + ";" + startsess + ";" + endsess;

                                                    id = settings.encodeUrl(settings.encryptText(id));
                                            %>
                                            <div class="col-12 col-sm-6 col-xl-4 col-xxl-3">
                                                <div class="card overflow-hidden">
                                                    <div class="card-body p-0 d-flex align-items-center">
                                                        <div class="bg-warning text-white p-4 me-3">
                                                            <svg class="icon icon-xl">
                                                            <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-moon"></use>
                                                            </svg>
                                                        </div>
                                                        <div>
                                                            <div class="text-body-secondary text-uppercase fw-semibold small"><a href="/perfor_det?id=<%=id%>"><%=data.getName()%></a></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <%
                                                }
                                            %>
                                            <!-- /.col-->


                                        </div>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                    <% }%>


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