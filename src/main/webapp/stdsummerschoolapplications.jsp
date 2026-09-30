<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>


<%
    String idxd = request.getParameter("id");
    if (idxd != null && idxd.length() > 0) {
        idxd = settings.decryptText(idxd);
        Summerschoolapplication app = sess.getSummerschoolapplicationById(idxd);
        if (app != null) {
            try {
                session.setAttribute("app", app);
                response.sendRedirect("/summer_app1");
            } catch (Exception ka) {
            }
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Summer School Applications</title>

    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Summer School Applications</h2>
                </div>
            </header>

            <%    List<Summerschoolstatus> sumlist = sess.getAllSummerschoolstatusBySchoolProgramme(std.getCourseId().getSchoolProgrammeId().getId());
            %>



            <div class="body flex-grow-1">
                <div class="container-lg px-4">


                    <div class="card mb-4">
                        <%                                                String id2 = request.getParameter("id2");

                            if (id2 != null && id2.length() > 0) {
                                try {
                                    id2 = settings.decryptText(id2);
                                    if (id2.equalsIgnoreCase("Start")) {
                                        if (!sumlist.isEmpty()) {
                                            Summerschoolstatus data = sumlist.get(0);
                                            if (data.getApplicationStatus().equalsIgnoreCase("OPEN")) {
                                                Summerschoolapplication app = sess.getSummerschoolapplicationByStudent(std.getId(), data.getId());
                                                if (app != null) {
                        %>
                        <div class="alert alert-warning">You have already initiated application for this session. Kindly click on the 'View Details' in the list to proceed</div>
                        <%
                        } else {
                            String id = std.getId() + data.getSessionStarted().substring(0, 4);
                            Summerschoolapplication newapp = new Summerschoolapplication(id);
                            newapp.setApplicationStatus("PENDING");
                            newapp.setDateApplied(settings.getCurrentDateTime());
                            newapp.setRegistrationStatus("PENDING");
                            newapp.setStudentsId(std);
                            newapp.setSummerSchoolStatusId(data);
                            sess.newSummerschoolapplication(newapp);
                        %>
                        <div class="alert alert-success">Yor application for summer school has been initiated. Kindly click on the 'View Details' in the list to proceed</div>
                        <%
                            }
                        } else {
                        %>
                        <div class="alert alert-warning">Application for summer school for current session <%=data.getSessionStarted()%> has been closed and new session is yet to be opened. Kindly check back later</div>
                        <%
                            }
                        } else {
                        %>
                        <div class="alert alert-warning">Currently the University does not offer summer school for <%=std.getCourseId().getSchoolProgrammeId().getProgrammeId().getName()%> programme in <%=std.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%></div>
                        <%
                                        }
                                    }

                                } catch (Exception k) {
                                }
                            }


                        %>

                        <div class="card-header">
                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>


                            <button type="button" class="btn btn-warning btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                View Statuses
                            </button>&nbsp;&nbsp;

                            <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Statuses of Summer School for <%=std.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%> Sessions</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <%

                                                if (sumlist.size() > 0) {
                                            %>

                                            <div class="table-responsive-sm">
                                                <table class="table table-striped table-hover" id='dataTable'>
                                                    <thead>
                                                        <tr>
                                                            <th class="center">#</th>
                                                            <th>Session</th>
                                                            <th>Date Opened</th>
                                                            <th>Current Status</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            int i = 1;
                                                            for (Summerschoolstatus data : sumlist) {
                                                                String opened = "";
                                                                try {
                                                                    opened = settings.formatDate(data.getDateOpened());
                                                                } catch (Exception k) {
                                                                }
                                                                String stc = data.getApplicationStatus().equalsIgnoreCase("OPEN") ? "success" : "danger";
                                                                String c1 = "<span class=\"alert alert-" + stc + "\">"
                                                                        + data.getApplicationStatus()
                                                                        + "</span>";
                                                        %>


                                                        <tr>
                                                            <td><%=i%></td>
                                                            <td><%=data.getSessionStarted()%></td>
                                                            <td><%=opened%></td>
                                                            <td><%=c1%></td>
                                                        </tr>

                                                        <%
                                                                i++;
                                                            }
                                                        %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <%
                                            } else {
                                            %>
                                            <div class="alert alert-warning">Currently the University does not offer summer school for <%=std.getCourseId().getSchoolProgrammeId().getProgrammeId().getName()%> programme in <%=std.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%></div>
                                            <%
                                                }
                                            %>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%
                                String start = settings.encodeUrl(settings.encryptText("Start"));
                            %>
                            <a href="/std_summer_app?id2=<%=start%>" class="btn btn-success btn-sm float-end">Start Application</a>


                        </div>



                        <div class="card-body">               
                            <div class="table-responsive-sm">
                                <table class="table table-striped table-hover" id='dataTable'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Summer schools Applied For</th>
                                            <th>Application Status</th>
                                            <th>Date Started</th>
                                            <th>Details</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int i = 1;
                                            List<Summerschoolapplication> list = sess.getSummerschoolapplicationByStudent(std.getId());
                                            for (Summerschoolapplication data : list) {
                                                int agg = 0;

                                        %>
                                        <tr>
                                            <td class="center"><%=i%></td>
                                            <td><%=data.getSummerSchoolStatusId().getSessionStarted()%></td>
                                            <td><%=data.getApplicationStatus()%></td>
                                            <td><%=settings.formatDate(data.getDateApplied())%></td>
                                            <td class="center"><a class="btn btn-primary btn-sm" href="/std_summer_app?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">View Details</a></td>
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
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

        <script src="js/popovers.js"></script>
        <script>
        </script>

    </body>
</html>