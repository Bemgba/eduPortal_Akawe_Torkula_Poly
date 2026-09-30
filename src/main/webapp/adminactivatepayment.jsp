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
        <title><%=settings.productName%> - Activate Payment</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Activate Payment</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter Payment Reference to activate payment</strong></div>
                            <div class="card-body">
                                <%    String refno = request.getParameter("payerno");
                                    Paymentreference prd = null;
                                    String submit = request.getParameter("submit");
                                    if (submit != null && refno != null && refno.length() > 0) {
                                        prd = (Paymentreference) sess.getSingleObject(Paymentreference.class, refno);
                                        if (prd != null) {
                                            Payments pay = (Payments) sess.getSingleObject(Payments.class, refno);
                                            if (pay != null) {
                                            session.setAttribute("prd", null);
                                %>
                                <div class="alert alert-info">Reference Number <%=refno%> already paid for </div>
                                <%
                                    } else {
                                        prd = sess.updatePaymentReference(refno);
                                        session.setAttribute("prd", prd);

                                    }
                                } else {
session.setAttribute("prd", null);
                                %>
                                <div class="alert alert-danger">Reference Number <%=refno%> not found!</div>
                                <%
                                        }
                                    }
                                %>

                                <%
                                    String datepaid = request.getParameter("datepaid");
                                    String refnox = request.getParameter("refnox");
                                    String submit2 = request.getParameter("button");
                                    if (submit2 != null && datepaid != null && datepaid.length() > 0 && refnox != null && refnox.length() > 0) {
                                    //refnox = settings.decryptText(refnox);
                                        Paymentreference prb = (Paymentreference) sess.getSingleObject(Paymentreference.class, refnox);
                                        if (prb != null) {
                                            if (prb.getPaidStatus().equalsIgnoreCase("PENDING")) {
                                                sess.changePaymentreferenceStatus(refnox, "SUCCESSFUL");
                                                sess.updatePayments();
                                %>
                                <div class="alert alert-success">Record updated successfully</div>
                                <%
                                            }
                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify2">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Enter Reference Number</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="payerno" type="text" name="payerno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-success mb-3" type="submit">View</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>



                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        Paymentreference prdx = null;
                        try {
                            prdx = (Paymentreference) session.getAttribute("prd");
                        } catch (Exception k) {
                        }
                        if (prdx != null) {
                            if (prdx.getPaidStatus().equalsIgnoreCase("PENDING")) {


                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>Activate Payment Reference <%=prdx.getId()%></strong></div>
                            <div class="card-body">
                                <form action='' method='post' name="verify">
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Reference Number
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getId()%>"/>

                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Payment Type
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getFeesGroupId().getName()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Registration Number
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getPayerRegistrationIo()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Full Namer
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getPayerName()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Session
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getSession()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Semester
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=prdx.getSemester()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Amount
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=settings.formatno.format(prdx.getAmount())%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Date Generated
                                        </span>
                                        <input type="text" class="form-control" readonly="" value="<%=settings.formatDate(prdx.getDateGenerated())%>"/>
                                    </div>

                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Date Paid
                                        </span>
                                        <input type="date" class="form-control" max="<%=settings.getTodaysdate()%>" name="datepaid"/>
                                        <input type="hidden" name="refnox" value="<%=prdx.getId()%>"/>
                                    </div>

                                    <div class="row">
                                        <div class="col-12">
                                            <input type="submit" name="button" class="btn btn-primary px-4" value="Activate"/>
                                        </div>

                                    </div>

                                </form>

                            </div>
                        </div>
                    </div>

                    <%
                            }
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