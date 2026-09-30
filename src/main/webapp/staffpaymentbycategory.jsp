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
        <title><%=settings.productName%> - Payment By Category</title>

        <script>

            async function loadDataFromDatabase(recordid) {
                const s2 = recordid.replace(/;/g, "") + "k";

                try {
                    const url = "AjaxServlet?action=loadPayment3&id2=" + escape(recordid);
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
                    <h2 class="title">Payment By Category</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Month range and schools to view</strong></div>
                            <div class="card-body">
                                <%    String sessionsd = request.getParameter("sessions");
                                    String[] schools = request.getParameterValues("schools");
                                    String semester = request.getParameter("semester");
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
                                                Select Session  
                                            </span>

                                            <select class="form-select" name="sessions" id="sessions">
                                                <option value="">Select One</option>
                                                <%
                                                    Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "REGISTRATION");
                                                    String sessions = "";
                                                    String initsess = settings.listSession;
                                                    try {
                                                        if (sm != null) {
                                                            sessions = sm.getName();
                                                            sessions = settings.getSessionAfter(sessions);
                                                        }
                                                    } catch (Exception k) {
                                                    }

                                                    while (sessions.compareTo(initsess) >= 0) {
                                                %>
                                                <option value="<%=sessions%>"><%=sessions%></option>
                                                <%
                                                        sessions = settings.getSessionBefore(sessions);
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Semester
                                            </span>
                                            <select class="form-select" name="semester" id="semester">
                                                <option value="">Select One</option>
                                                <option value="First">First</option>
                                                <option value="Second">Second</option>
                                                <option value="Session">Session</option>
                                            </select>
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
                        if (submit != null && sessionsd != null && schools != null && schools.length > 0) {

                            if (schools != null && schools.length == 0) {
                    %>
                    <div class='alert alert-warning'>No School selected</div>
                    <%
                    } else {

                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Payment summary from <%=schools.length%> schools in  <%=sessionsd%> ,  <%=semester%> Semester</strong></div>
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
                                                                <th>Count</th>                                                             
                                                                <th>Sum Amount</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                int i = 1;
                                                                List<PaymentSummaryDTO> itemsl = sess.getPaymentSummary(sessionsd, semester, sc);
                                                                for (PaymentSummaryDTO item : itemsl) {
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=item.getItemName().toUpperCase()%></td>
                                                                <%

                                                                    String idu = item.getItemId() + sc + sessionsd + semester;
                                                                    idu = idu.replaceAll("/", "_");
                                                                    sessionsd = sessionsd.replaceAll("/", "_");
                                                                    String para = item.getItemId() + ";" + sc + ";" + sessionsd + ";" + semester;
                                                                %>
                                                                <td style="text-align: right">

                                                                    <a href="#" 
                                                                       data-coreui-toggle="modal" 
                                                                       data-coreui-target="#<%=idu%>" 
                                                                       onclick="loadDataFromDatabase('<%=para%>')" 
                                                                       >
                                                                        <%=item.getRegnoCount()%>
                                                                    </a>

                                                                    <div class="modal fade" id="<%=idu%>" tabindex="-1" aria-labelledby="<%=idu%>lab" aria-hidden="true">
                                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="<%=idu%>lab">Payment Report for <%=item.getItemName()%>  in <%=schd.getName()%> for <%=sessionsd%>, <%=semester%> Semester</h5>
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

                                                                <td style="text-align: right"><%=settings.formatno.format(item.getTotalAmount())%></td> 


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