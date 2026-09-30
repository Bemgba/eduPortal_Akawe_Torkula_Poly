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
        <title><%=settings.productName%> - Yearly Payment Summary</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">View Yearly Payment Summary</h2>
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
                                                Start Year    
                                            </span>
                                            <input class="form-control" type="number" min="2000" required="" name="startdate"  value="<%=settings.getTodaysdate().split("-")[0]%>" max="<%=settings.getTodaysdate().split("-")[0]%>">
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                End Year 
                                            </span>
                                            <input class="form-control" type="number" min="2000" required="" name="enddate" value="<%=settings.getTodaysdate().split("-")[0]%>"  max="<%=settings.getTodaysdate().split("-")[0]%>">
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
                            <div class="card-header"><strong>Payment summary from <%=schools.length%> schools from  <%=startdate%> to <%=enddate%></strong></div>
                            <div class="card-body">

                                <div class="accordion" id="accordionExample">
                                    <%
                                        try {
                                            for (String sc : schools) {
                                                Schools schd = sess.getSchools(sc);
                                                if (schd != null) {

                                    %>
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="heading<%=schd.getId()%>">
                                            <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapse<%=schd.getId()%>" aria-expanded="false" aria-controls="collapse<%=schd.getId()%>"><%=schd.getName()%></button>
                                        </h2>
                                        <div class="accordion-collapse collapse" id="collapse<%=schd.getId()%>" aria-labelledby="heading<%=schd.getId()%>" data-coreui-parent="#accordionExample" style="">
                                            <div class="accordion-body">
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover">
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Payment Item</th>
                                                                    <%
                                                                        int siz = Integer.valueOf(enddate) - Integer.valueOf(startdate) + 2;
                                                                        double dtot[] = new double[siz];
                                                                        for (int h = 0; h < siz; h++) {
                                                                            dtot[h] = 0;
                                                                        }
                                                                        try {
                                                                            for (int y = Integer.valueOf(startdate); y <= Integer.valueOf(enddate); y++) {
                                                                    %>
                                                                <th><%=y%></th>    
                                                                    <%
                                                                            }
                                                                        } catch (Exception j) {
                                                                        }
                                                                    %>
                                                                <th>Total</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                int i = 1;
                                                                List<Feesgroup> itemsl = sess.getFeesgroupBySchoolAndYearRange(sc, startdate, enddate);
                                                                for (Feesgroup item : itemsl) {
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=item.getName().toUpperCase()%></td>
                                                                <%
                                                                    double total = 0;
                                                                    try {
                                                                        int k = 0;
                                                                        for (int y = Integer.valueOf(startdate); y <= Integer.valueOf(enddate); y++) {
                                                                            double amount = 0;
                                                                            try {
                                                                                amount = sess.sumPaymentByItemSchoolYear(item.getId(), sc, y + "");
                                                                            } catch (Exception ka) {
                                                                            }
                                                                            dtot[k] += amount;
                                                                %>
                                                                <td style="text-align: right"><%=settings.formatno.format(amount)%></td>
                                                                <%
                                                                            total += amount;
                                                                            k++;
                                                                        }
                                                                    } catch (Exception j) {
                                                                    }

                                                                    dtot[siz-1] += total;
                                                                %>
                                                                <td style="text-align: right"><%=settings.formatno.format(total)%></td> 


                                                            </tr>
                                                            <%
                                                                    i++;
                                                                }
                                                            %>
                                                        </tbody>
                                                        <tfoot>
                                                            <tr>
                                                                <th>x</th>
                                                                <th>Total</th>
                                                                    <%
                                                                        for (int h = 0; h < siz; h++) {
                                                                    %>
                                                                <th style="text-align: right"><%=settings.formatno.format(dtot[h])%></th>
                                                                    <%
                                                                        }


                                                                    %>
                                                            </tr>
                                                        </tfoot>
                                                    </table>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <%                                                }

                                            }
                                        } catch (Exception k) {
                                        }
                                    %>


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