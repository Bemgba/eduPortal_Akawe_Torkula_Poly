<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

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
        <title><%=settings.productName%> - Payment History</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">My Payments</h2>
                </div>
            </header>

            <!-- JavaScript to update the page title -->
            <script>
                // Get the dynamic title from a JSP variable
                var newTitle = "<%= "Payment history for " + std.getSurname() + " " + std.getOthernames()%>";
                // Update the page title
                document.title = newTitle;
            </script>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <%
                        List<Payments> payments = sess.getPaymentsByRegno(std.getId());
                        double total = payments.stream()
                                .mapToDouble(Payments::getAmount)
                                .sum();
                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Total  N<%=settings.formatno.format(total)%></strong></div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id="dataTable">
                                        <thead>
                                        <th class="center">SNO</th>
                                        <th>Payment Type</th>
                                        <th>Session</th>
                                        <th>Semester</th>
                                        <th>Level</th>
                                        <th>Date Paid</th>
                                        <th>Amount</th>
                                        <th class="right">Download Receipt</th>
                                        </thead>
                                        <tbody>
                                            <%
                                                int sn = 1;
                                                for (Payments pay : payments) {
                                            %>
                                            <tr>
                                                <td class="center"><%=sn%></td>
                                                <td><%=pay.getFeesGroupId().getName()%></td>
                                                <td><%=pay.getSessionPaid()%></td>
                                                <td><%=pay.getSemesterPaid()%></td>
                                                <td><%=pay.getLevel()%></td>
                                                <td><%=settings.formatDate(pay.getDatePaid())%></td>
                                                <td class="right"><%=settings.formatno.format(pay.getAmount())%></td>
                                                <td><a href="/DownloadReceipt?id=<%=pay.getId()%>" target="_blank">Download</a></td>
                                            </tr>
                                            <%

                                                    sn++;
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.row-->
                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

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