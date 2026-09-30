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
        <title><%=settings.productName%> - Daily Payment Report</title>

        <script>

            async function loadDataFromDatabase(recordid) {
                const s2 = recordid.replace(/;/g, "") + "k";

                try {
                    const url = "AjaxServlet?action=loadPayment1&id2=" + escape(recordid);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    console.log(s2);
                    document.getElementById(s2).innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error loading data:", error);
                    document.getElementById(s2).innerHTML = "<p>Error loading data. Please try again later.</p>";
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
                    <h2 class="title">View Daily Payment Report</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Date range and schools to view</strong></div>
                            <div class="card-body">
                                <%    String startdate = request.getParameter("startdate");
                                    String[] schools = request.getParameterValues("schools");
                                    String enddate = request.getParameter("enddate");
                                    List<Payments> paylist = new ArrayList();
                                    String submit = request.getParameter("button");

                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="input-group mb-3"><span class="input-group-text">
                                                Select Schools   
                                            </span>
                                            <%                                                List<Schools> schl = sess.getAllSchoos();
                                            %>
                                            <select class="form-select" name="schools" id="schools" multiple size="<%=schl.size() + 1%>">
                                                <%
                                                    try {
                                                        for (Schools sch : schl) {
                                                %>
                                                <option value="<%=sch.getId()%>"><%=sch.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>

                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Start Date    
                                            </span>
                                            <input class="form-control" type="date" min="2000-01-01" required="" name="startdate"  value="<%=settings.getTodaysdate()%>" max="<%=settings.getTodaysdate()%>">
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                End Date 
                                            </span>
                                            <input class="form-control" type="date" min="2000-01-01" required="" name="enddate" value="<%=settings.getTodaysdate()%>"  max="<%=settings.getTodaysdate()%>">
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <input type="submit" name="button" class="btn btn-primary px-4" value="View Records"/>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%

                        if (submit != null && startdate != null && schools != null && schools.length > 0) {

                            if (schools != null && schools.length == 0) {
                    %>
                    <div class='alert alert-warning'>No School selected</div>
                    <%
                    } else {


                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Payment details from <%=schools.length%> schools from  <%=startdate%> to <%=enddate%></strong></div>
                            <div class="card-body">

                                <%
                                    try {
                                        List<Payments> itemsl = new ArrayList();
                                        for (String sc : schools) {
                                            List<Payments> itemsld = sess.viewPaymentsBySchoolAndDateRange(sc, startdate, enddate);
                                            itemsl.addAll(itemsld);
                                        }

                                        double total = itemsl.stream()
                                                .mapToDouble(Payments::getAmount)
                                                .sum();
                                %>
                                <div class="table-responsive-sm">
                                    <div class="alert alert-info">Total Amount = N <%=settings.formatno.format(total)%></div>
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>School</th>
                                                <th>Payment Item</th>
                                                <th>Date</th>
                                                <th>Amount</th>
                                                <th>Registration No</th>
                                                <th>Payer's Name</th>
                                                <th>View Receipt</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                                int i = 1;

                                                for (Payments item : itemsl) {
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=item.getSchoolId().getName()%></td>
                                                <td><%=item.getFeesGroupId().getName()%></td>
                                                <%
                                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = sdf.format(item.getDatePaid());
                                                %>
                                                <td><%=formattedDate%></td>
                                                <td><%=settings.formatno.format(item.getAmount())%></td>
                                                <%
                                                    Students stdg = sess.getStudentsById(item.getPayerId());
                                                    String regnox = item.getPayerRegistrationNo();
                                                    if (stdg != null) {
                                                        regnox = stdg.getMatricNo() != null ? stdg.getMatricNo() : stdg.getRegistrationNo();
                                                    }
                                                %>
                                                <td><%=regnox%></td>
                                                <td><%=item.getPayerFullname()%></td>
                                                <td class="right"><a href="/DownloadReceipt?id=<%=item.getId()%>" target="_blank" class="btn btn-link px-0">View</a></td>


                                            </tr>
                                            <%
                                                    i++;
                                                }
                                            %>
                                        </tbody>

                                    </table>
                                </div>

                                <%
                                    } catch (Exception k) {
                                    }
                                %>



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