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
        <title><%=settings.productName%> - Monthly Payment Summary</title>

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
                    <h2 class="title">View Monthly Payment Summary</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Month range and schools to view</strong></div>
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
                                                Start Month    
                                            </span>
                                            <input class="form-control" type="month" min="2000-01" required="" name="startdate"  value="<%=settings.getTodaysdate().split("-")[0] + "-01"%>" max="<%=settings.getTodaysdate().split("-")[0] + "-" + settings.getTodaysdate().split("-")[1]%>">
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                End Month 
                                            </span>
                                            <input class="form-control" type="month" min="2000-01" required="" name="enddate" value="<%=settings.getTodaysdate().split("-")[0] + "-" + settings.getTodaysdate().split("-")[1]%>"  max="<%=settings.getTodaysdate().split("-")[0] + "-" + settings.getTodaysdate().split("-")[1]%>">
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
                        String year = startdate.split("-")[0];
                        String year2 = enddate.split("-")[0];
                        if (!year.equalsIgnoreCase(year2)) {
                    %>
                    <div class='alert alert-warning'>Kindly select Month range from the same year. You selected <%=startdate%> and <%=enddate%></div>
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
                                                                        String smonth = startdate.split("-")[1];
                                                                        String emonth = enddate.split("-")[1];
                                                                        int st = 1;
                                                                        int ed = 1;
                                                                        try {
                                                                            st = Integer.valueOf(smonth);
                                                                            ed = Integer.valueOf(emonth);
                                                                        } catch (Exception k) {
                                                                        }
                                                                        int siz = ed - st + 2;
                                                                        double dtot[] = new double[siz];
                                                                        for (int h = 0; h < siz; h++) {
                                                                            dtot[h] = 0;
                                                                        }
                                                                        try {
                                                                            for (int y = st; y <= ed; y++) {
                                                                                String code = y + "";
                                                                                if (y < 10) {
                                                                                    code = "0" + y;
                                                                                }
                                                                                String mname = settings.getMonthNameShort(code);
                                                                    %>
                                                                <th><%=mname%></th>    
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
                                                                List<Feesgroup> itemsl = sess.getFeesgroupBySchoolAndMonthRange(sc, startdate, enddate);
                                                                for (Feesgroup item : itemsl) {
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=item.getName().toUpperCase()%></td>
                                                                <%
                                                                    double total = 0;
                                                                    try {
                                                                        int k = 0;
                                                                        for (int y = st; y <= ed; y++) {
                                                                            String code = y + "";
                                                                            if (y < 10) {
                                                                                code = "0" + y;
                                                                            }
                                                                            double amount = 0;
                                                                            String mon = year + "-" + code;
                                                                            try {
                                                                                amount = sess.sumPaymentByItemSchoolMonth(item.getId(), sc, mon);
                                                                            } catch (Exception ka) {
                                                                            }
                                                                            dtot[k] += amount;

                                                                            String idu = item.getId() + sc + mon;
                                                                            String para = item.getId() + ";" + sc + ";" + mon;
                                                                %>
                                                                <td style="text-align: right">

                                                                    <a href="#" 
                                                                       data-coreui-toggle="modal" 
                                                                       data-coreui-target="#<%=idu%>" 
                                                                       onclick="loadDataFromDatabase('<%=para%>')" 
                                                                       >
                                                                        <%=settings.formatno.format(amount)%>
                                                                    </a>

                                                                    <div class="modal fade" id="<%=idu%>" tabindex="-1" aria-labelledby="<%=idu%>lab" aria-hidden="true">
                                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="<%=idu%>lab">Payment Report for <%=item.getName()%> for <%=schd.getName()%> in <%=mon%></h5>
                                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">

                                                                                    <div id="<%=idu%>k">Loading...</div>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                </td>

                                                                <%
                                                                            total += amount;
                                                                            k++;
                                                                        }
                                                                    } catch (Exception j) {
                                                                    }

                                                                    dtot[siz - 1] += total;
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