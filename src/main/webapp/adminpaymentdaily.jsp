<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Map"%>
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
        <title><%=settings.productName%> - Daily Payment Collection</title>

        <script>

            async function viewPayments(sch,xdate) {

                try {
                    const url = "AjaxServlet?action=viewPayments&id2=" + escape(sch)+"&id3="+escape(xdate);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(xdate+"k").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error loading data:", error);
                    document.getElementById(xdate+"k").innerHTML = "<p>Error loading data. Please try again later.</p>";
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
                    <h2 class="title">View Daily Payment Collection</h2>
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


                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Date</th>
                                                <th>Count</th>
                                                <th>Total</th>
                                                <th>Details</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                long tno = 0;
                                                double tam = 0;

                                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                                while (startdate.compareTo(enddate) <= 0) { // Ensure inclusive loop
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=startdate%></td>
                                                <%
                                                    long no = 0;
                                                    double am = 0;
                                                    String lsch = "";
                                                    String dsch = "";
                                                    for (String sc : schools) {
                                                        try {
                                                            lsch += (sc + "_");
                                                            Schools ddh = sess.getSchools(sc);
                                                            if (ddh != null) {
                                                                dsch += (ddh.getName() + ", ");
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                        try {
                                                            Map<String, Object> det = sess.sumPaymentsBySchoolAndDateRange(sc, startdate, startdate);
                                                            Double totalAmount = (Double) det.get("totalAmount");
                                                            Long entryCount = (Long) det.get("entryCount");

                                                            no += (entryCount != null) ? entryCount : 0;
                                                            am += (totalAmount != null) ? totalAmount : 0.0;
                                                        } catch (Exception ja) {
                                                        }
                                                    }
                                                    tam += am;
                                                    tno += no;
                                                    String startdated = startdate.replaceAll("-", "_");
                                                %>
                                                <td><%=no%></td>
                                                <td><%=settings.formatno.format(am)%></td>
                                                <td>
                                                    <a href="#" 
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=startdate.replaceAll("-", "_")%>" 
                                                       onclick="viewPayments('<%=lsch%>', '<%=startdated%>')" 
                                                       >
                                                        Details
                                                    </a>

                                                    <div class="modal fade" id="<%=startdate.replaceAll("-", "_")%>" tabindex="-1" aria-labelledby="<%=startdate.replaceAll("-", "_")%>lab" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=startdate.replaceAll("-", "_")%>lab"><%=startdate%> payment report from <%=dsch%></h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=startdate.replaceAll("-", "_")%>k">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%
                                                    i++;
                                                    startdate = settings.getDateAhead(startdate, 1); // Move to next date
                                                }
                                            %>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="2"><strong>Grand Total</strong></td>
                                                <td><strong><%=tno%></strong></td>
                                                <td><strong><%=settings.formatno.format(tam)%></strong></td>
                                                <td>-</td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>



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