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
        <title><%=settings.productName%> - Reset PG Application</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Reset PG Application</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="alert alert-info">This operation will reset PG application status to 'NOT COMPLETED'. This will enable to applicant makes corrections and resubmit his/her application. A notification will be sent to the applicant.
                            <p>Do not do this without the applicants knowledge to avoid no operation afterwards.</p></div>
                        <div class="card mb-4">
                            <%                                String resetcomment = request.getParameter("resetcomment");
                                String resetbut = request.getParameter("resetbut");
                                if (resetbut != null && resetcomment != null && resetcomment.trim().length() > 0) {
                                    Applicants app = null;
                                    try {
                                        app = (Applicants) session.getAttribute("app");
                                    } catch (Exception ka) {
                                    }
                                    if (app != null) {
                                        sess.resetApplicationStatus(app.getId());
                            %>
                            <div class="alert alert-success">Applicant status has been reset to 'NOT COMPLETED</div>
                            <%
                                    }
                                }

                            %>
                            <div class="card-header"><strong>Enter PG Application Number</strong></div>
                            <div class="card-body">
                                <%    String pgno = request.getParameter("pgno");

                                    String submit = request.getParameter("submit");
                                    if (submit != null && pgno != null && pgno.length() > 0) {
                                        pgno = pgno.trim().toLowerCase();
                                        Applicants appd = sess.getApplicantsById(pgno);
                                        if (appd != null) {
                                            session.setAttribute("app", appd);
                                        } else {
                                            session.setAttribute("app", null);
                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Enter PG Number</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="pgno" type="text" name="pgno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View Details</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>
                    <%
                        Applicants app = null;
                        try {
                            app = (Applicants) session.getAttribute("app");
                        } catch (Exception ka) {
                        }
                    %>
                    <%
                        if (app != null) {
                    %>

                    <div class="card mb-4">

                        <div class="card-header"><strong><%=app.getSurname() + " " + app.getOthernames()%>'s details,  Status: <%=app.getStatus()%></strong>
                            <%
                                String stt = app.getStatus();
                                if (stt.equalsIgnoreCase("NOT COMPLETED")) {
                            %>
                            <div class="alert alert-warning">This application's status is already 'NOT COMPLETED', you can not reset it</div>
                            <%
                            }else if (stt.equalsIgnoreCase("ADMITTED")) {
                            %>
                            <div class="alert alert-warning">This application has been admitted, you can not reset hit/her application</div>
                            <%
                            } else {
                                String ssx = "";
                                Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S002", "APPLICATION");
                                if (sessmanx != null) {
                                    ssx = sessmanx.getName();
                                    if (ssx.equalsIgnoreCase(app.getSession())) {
                            %>
                            <a href="#" class="btn btn-secondary btn-sm mb-3 float-end" data-coreui-toggle="modal" data-coreui-target="#facmod">
                                Change Status
                            </a>
                            <div class="modal fade" id="facmod" tabindex="-1" aria-labelledby="facmodlab" aria-hidden="true" style="display: none;">
                                <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="facmodlab">Reset Application status for <%=app.getSurname()%> <%=app.getOthernames()%></h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="" method="post" name="facform">
                                                <div class="row">
                                                    <div class="col-4">
                                                        Enter Comment
                                                    </div>
                                                    <div class="col-8">
                                                        <input type="text" name="resetcomment" class="form-control" required=""/>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-6">
                                                    </div>
                                                    <div class="col-6">
                                                        <input type="submit" name="resetbut" class="btn btn-secondary px-4" value="Reset"/>
                                                    </div>
                                                </div>

                                            </form>

                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            } else {
                                if (ssx.equalsIgnoreCase(app.getSession())) {
                            %>
                            <div class="alert alert-warning">This application is not in current session. you can not reset hit/her application</div>
                            <%
                                        }
                                    } else {
                            %>
                            <div class="alert alert-danger">No active session found for postgraduate applications (S002). This feature is currently unavailable.</div>
                            <%
                                    }
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <embed src="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(app.getId()))%>" style="width: 100%; height: 700px" type="application/pdf">
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