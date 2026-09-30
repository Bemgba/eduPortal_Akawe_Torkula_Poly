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
        <title><%=settings.productName%> - Resolve Pending Payments</title>

        <script>

            async function updateRecord(recordid) {
                try {
                    const url = "AjaxServlet?action=updatePaymentRef&id=" + escape(recordid);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    const id = respText.split("::")[0];  // First part of the response
                    const id2 = respText.split("::")[1]; // Second part of the response
                    document.getElementById(recordid + "b").innerHTML = id; // Use `id` here
                    document.getElementById(recordid).innerHTML = id2;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }


        </script>

    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Resolve Pending Payments</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter Payer's number to view Payment attempts</strong></div>
                            <div class="card-body">
                                <%    String payerno = request.getParameter("payerno");
                                    List<Paymentreference> paylist = new ArrayList();
                                    String submit = request.getParameter("submit");
                                    if (submit != null && payerno != null && payerno.length() > 0) {
                                        payerno = payerno.toLowerCase();
                                        paylist = sess.getPaymentreferenceByRegno(payerno);
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Enter Payer's Number</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="payerno" type="text" name="payerno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">List Payment Attempts</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (paylist.size() == 0) {
                            if (payerno != null && payerno.trim().length() > 0) {
                    %>
                    <div class='alert alert-warning'>No payment attempt found for <%=payerno%>!</div>
                    <%
                        }
                    } else {

                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <%                                String regnod = paylist.get(0).getPayerId();
                                Students stdd = sess.getStudentsById(paylist.get(0).getPayerId());
                                if (stdd != null) {
                                    if (stdd.getMatricNo() != null) {
                                        regnod = stdd.getMatricNo().toUpperCase();
                                    }
                                }
                            %>
                            <div class="card-header"><strong>Payment attempts for <%=stdd.getSurname() + " " + stdd.getOthernames()%> (<%=regnod%>)</div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Reference No</th>
                                                <th>Payment Type</th>
                                                <th>Date Generated</th>
                                                <th class="right">Amount</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Paymentreference pay : paylist) {
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=pay.getId()%></td>
                                                <td><%=pay.getFeesGroupId().getName()%></td>
                                                <%
                                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = sdf.format(pay.getDateGenerated());
                                                %>
                                                <td><%=formattedDate%></td>
                                                <td class="right"><%=settings.formatno.format(pay.getAmount())%></td>
                                                <%
                                                    String sty = "danger";
                                                    String labe = "Resolve";
                                                    String link = "href=\"#\" onclick=\"event.preventDefault(); updateRecord(\'" + pay.getId() + "\');\"";
                                                    if (pay.getPaidStatus().equalsIgnoreCase("PAID")) {
                                                        sty = "success";
                                                        link = "href=\"/DownloadReceipt?id=" + pay.getId() + "\" target=\"_blank\"";
                                                        labe = "Download Receipt";
                                                    }
                                                %>
                                                <td id="<%=pay.getId()%>b"><span class="alert alert-<%=sty%>"><%=pay.getPaidStatus()%></span></td>
                                                <td id="<%=pay.getId()%>"><a <%=link%> class="btn btn-link px-0"><%=labe%></a></td>
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