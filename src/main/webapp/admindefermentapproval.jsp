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
        <title><%=settings.productName%> - Approve Deferment</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Approve Deferment</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="alert alert-info">This operation will enable you to approve the deferment of a student allowing him/her to be able to register at a different session from the usual one.
                            <p>Do not do this without the student's knowledge to avoid no operation afterwards.</p>
                            <p>The Deferment number requested in the form is found on the student's deferment form</p>
                            <p>The approving staff number can be found from the 'Search user' menu</p>
                        </div>
                        <div class="card mb-4">
                            <%                                String sessionapp = request.getParameter("sessionapp");
                                String semesterapp = request.getParameter("semesterapp");
                                String staffno = request.getParameter("staffno");
                                String dateapproved = request.getParameter("dateapproved");
                                String approvedef = request.getParameter("approvedef");
                                if (approvedef != null && dateapproved != null && staffno != null && staffno.trim().length() > 0) {
                                    staffno = staffno.toLowerCase();
                                    Staff stfd = sess.getStaffById(staffno);
                                    if (stfd != null) {
                                        Deferments app = null;
                                        try {
                                            app = (Deferments) session.getAttribute("app");
                                        } catch (Exception ka) {
                                        }
                                        if (app != null) {
                                            sess.approveDeferment(app.getId(), stfd.getId(), sessionapp, semesterapp, dateapproved);
                                            Deferments appd = sess.getDeferments(app.getId());
                                            if (appd != null) {
                                                session.setAttribute("app", appd);
                                            } else {
                                                session.setAttribute("app", null);
                                            }
                            %>
                            <div class="alert alert-success">Deferment approved successfully</div>
                            <%
                                }
                            } else {
                            %>
                            <div class="alert alert-danger">Staff Number <%=staffno%> is not found</div>
                            <%
                                    }

                                }

                            %>
                            <div class="card-header"><strong>Enter Deferment Number</strong></div>
                            <div class="card-body">
                                <%    String defno = request.getParameter("defno");

                                    String submit = request.getParameter("submit");
                                    if (submit != null && defno != null && defno.length() > 0) {
                                        defno = defno.trim().toLowerCase();
                                        Deferments appd = sess.getDeferments(defno);
                                        if (appd != null) {
                                            session.setAttribute("app", appd);
                                        } else {
                                            session.setAttribute("app", null);
                                %>
                                <div class="alert alert-danger">No Deferment record found matching number <%=defno%></div>
                                <%
                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-4 col-form-label" for="payerno">Enter Deferment Number</label>
                                                    <div class="col-sm-5">
                                                        <input class="form-control" id="defno" type="text" name="defno" required="">
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
                        Deferments app = null;
                        try {
                            app = (Deferments) session.getAttribute("app");
                        } catch (Exception ka) {
                        }
                    %>
                    <%
                        if (app != null) {
                    %>

                    <div class="card mb-4">

                        <div class="card-header"><strong><%=app.getStudentId().getSurname() + " " + app.getStudentId().getOthernames()%>'s deferment details,  Status: <%=app.getApprovalStatus()%></strong>
                            <%
                                String stt = app.getApprovalStatus();
                                if (stt.equalsIgnoreCase("DENIED")) {
                            %>
                            <div class="alert alert-warning">This application's status is already 'DENIED', you can not change it</div>
                            <%
                            } else if (stt.equalsIgnoreCase("APPROVED")) {
                            %>
                            <div class="alert alert-warning">This application's status is already 'APPROVED'. You can not change it</div>
                            <%
                            } else {

                            %>
                            <a href="#" class="btn btn-success btn-sm mb-3 float-end" data-coreui-toggle="modal" data-coreui-target="#facmod">
                                Approve Deferment
                            </a>
                            <div class="modal fade" id="facmod" tabindex="-1" aria-labelledby="facmodlab" aria-hidden="true" style="display: none;">
                                <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="facmodlab">Record Deferment Approval <%=app.getId()%></h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form action="" method="post" name="facform">
                                                <div class="row">
                                                    <div class="col-4">
                                                        Select Session Approved
                                                    </div>
                                                    <div class="col-8">
                                                        <select name="sessionapp" class="form-select">
                                                            <option value="<%=app.getExpectedResumptionSession()%>" selected=""><%=app.getExpectedResumptionSession()%></option>
                                                            <%
                                                                try {
                                                                    String sessd = app.getExpectedResumptionSession();
                                                                    while (sessd.compareToIgnoreCase(app.getSession()) > 0) {
                                                            %>
                                                            <option value="<%=sessd%>"><%=sessd%></option>
                                                            <%
                                                                        sessd = settings.getSessionBefore(sessd);
                                                                    }

                                                                } catch (Exception k) {
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-4">
                                                        Select Semester Approved
                                                    </div>
                                                    <div class="col-8">
                                                        <select name="semesterapp" class="form-select">
                                                            <option value="<%=app.getExpectedResumptionSemester()%>" selected=""><%=app.getExpectedResumptionSemester()%></option>
                                                            <option value="<%=app.getExpectedResumptionSemester().equalsIgnoreCase("First") ? "Second" : "First"%>"><%=app.getExpectedResumptionSemester().equalsIgnoreCase("First") ? "Second" : "First"%></option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-4">
                                                        Enter Approving Staff Number
                                                    </div>
                                                    <div class="col-8">
                                                        <input type="text" required="" class="form-control" name="staffno"/> 
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-4">
                                                        Enter Date approved
                                                    </div>
                                                    <div class="col-8">
                                                        <input type="date" required="" class="form-control" name="dateapproved" max="<%=settings.getTodaysdate()%>"/> 
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-6">
                                                    </div>
                                                    <div class="col-6">
                                                        <input type="submit" name="approvedef" class="btn btn-success px-4" value="Submit Approval"/>
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
                                }
                            %>
                        </div>
                        <div class="card-body">
                            <%
                                String idu = settings.encodeUrl(settings.encryptText(app.getId()));
                            %>
                            <embed src="/DownloadDefermentForm?id=<%=idu%>" style="width: 100%; height: 700px" type="application/pdf">
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