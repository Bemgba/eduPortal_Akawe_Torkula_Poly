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

<%    
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        if (id.contains(";")) {
            String[] splitter = id.split(";");
            String sessionx = splitter[0];
            String operation = splitter[1];
            Sessionmanager smx = (Sessionmanager) sess.getSingleObject(Sessionmanager.class, sessionx);
            if (smx != null) {
                if (operation.equalsIgnoreCase("NCOMP") || operation.equalsIgnoreCase("COMP") || operation.equalsIgnoreCase("ADM")) {
                    session.setAttribute("smx", smx);
                    session.setAttribute("op", operation);
                    
                    response.sendRedirect("/pp_app_list");
                }
            }
        }
    }
%>
<%    
    List<Sessionmanager> smr = sess.getAllSessionmanager("S002", "APPLICATION", "Session");
    

%>
<html lang="en">
    <head>
         <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - PG Applicants</title>

        <script>
            
            async function loadItems() {
                try {
                    var sel2 = document.getElementById("schools");
                    var catval = sel2.options[sel2.selectedIndex].value;
                    const url = "AjaxServlet?action=loadItemsAndSessions&id2=" + escape(catval);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    const id = respText.split("::")[0];  // First part of the response
                    const id2 = respText.split("::")[1]; // Second part of the response
                    document.getElementById("item").innerHTML = id; // Use `id` here
                    document.getElementById("sessions").innerHTML = id2;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            
            
            function loadSesssem() {
                const sel2 = document.getElementById("item");
                const catval = sel2.value;
                const url = "AjaxServlet?action=loadsesssem&id=" + escape(catval);
                
                fetch(url)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Network response was not ok");
                            }
                            return response.text();
                        })
                        .then(data => {
                            document.getElementById("semester").innerHTML = data;
                        })
                        .catch(error => console.error("Fetch error:", error));
            }
        </script>

    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">PG Applicants</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Click on a record to view details of the PG Applicants</strong></div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTablefac'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Session</th>
                                                <th>Date Opened</th>
                                                <th>Status</th>
                                                <th>Not Completed</th>
                                                <th>Completed</th>
                                                <th>Admitted</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                int i = 1;
                                                
                                                for (Sessionmanager data : smr) {
                                                    String sty = "danger";
                                                    try {
                                                        if (data.getStatus().equalsIgnoreCase("OPEN")) {
                                                            sty = "success";
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                    String id1 = data.getId() + ";NCOMP";
                                                    String id2 = data.getId() + ";COMP";
                                                    String id3 = data.getId() + ";ADM";
                                                    id1 = settings.encodeUrl(settings.encryptText(id1));
                                                    id2 = settings.encodeUrl(settings.encryptText(id2));
                                                    id3 = settings.encodeUrl(settings.encryptText(id3));
                                                    
                                                    long noncomp = 0;
                                                    long nocomp = 0;
                                                    long noadm = 0;
                                                    try {
                                                        noncomp = sess.countApplicantsByTypeSessionStatus(data.getName(), "NOT COMPLETED", "POST GRADUATE");
                                                        nocomp = sess.countApplicantsByTypeSessionStatus(data.getName(), "COMPLETED", "POST GRADUATE");
                                                        noadm = sess.countApplicantsByTypeSessionStatus(data.getName(), "ADMITTED", "POST GRADUATE");
                                                    } catch (Exception j) {
                                                    }
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>
                                                <% 
                                                    String formattedDate = "N/A";
                                                    try {
                                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                        formattedDate = sdf.format(data.getStartDate());
                                                    } catch (Exception ka) {
                                                    }
                                                %>
                                                <td><%=formattedDate%></td>
                                                <td><span class="alert alert-<%=sty%>"><%=data.getStatus()%></span></td>
                                                <td><a href="/pp_applicants?id=<%=id1%>" class="btn btn-outline-danger btn-sm"><%=noncomp%></a></td>
                                                <td><a href="/pp_applicants?id=<%=id2%>" class="btn btn-outline-warning btn-sm"><%=nocomp%></a></td>
                                                <td><a href="/pp_applicants?id=<%=id3%>" class="btn btn-outline-primary btn-sm"><%=noadm%></a></td>
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
                new DataTable('#dataTablefac', {
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