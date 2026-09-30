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
    Sessionmanager smx = null;
    String operation = null;
    String label = "";
    List<Applicants> applicants = new ArrayList();
    try {
        smx = (Sessionmanager) session.getAttribute("smx");
        operation = (String) session.getAttribute("op");
    } catch (Exception k) {
    }
    if (smx == null || operation == null) {
        response.sendRedirect("/pp_applicants");
    }
    if (operation.equalsIgnoreCase("NCOMP")) {
        label = "Not Completed";
        applicants = sess.getApplicantsByTypeSessionStatus(smx.getName(), "NOT COMPLETED", "POST GRADUATE");
    }
    if (operation.equalsIgnoreCase("COMP")) {
        label = "Completed";
        applicants = sess.getApplicantsByTypeSessionStatus(smx.getName(), "COMPLETED", "POST GRADUATE");
    }
    if (operation.equalsIgnoreCase("ADM")) {
        label = "Admitted";
        applicants = sess.getApplicantsByTypeSessionStatus(smx.getName(), "ADMITTED", "POST GRADUATE");
    }


%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - <%=label%> PG Applicants for <%=smx.getName()%></title>

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
                    <h2 class="title"><%=label%> PG Applicants for <%=smx.getName()%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Click on the buttons to view details</strong>
                                <a href="/pp_applicants" class="btn btn-danger btn-sm">Back</a>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm" style="max-height: auto;overflow-y: auto; border: 1px solid #ddd;">
                                    <table class="table table-striped table-hover" id='dataTablefac'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Course</th>
                                                <th>Application No</th>
                                                <th>Full Name</th>
                                                <th>Email Address</th>
                                                <th>Phone No</th>
                                                <th>State</th>
                                                <th>LGA</th>
                                                <th>Gender</th>
                                                <th>Date Completed</th>
                                                <th>View Form</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                int i = 1;

                                                for (Applicants data : applicants) {
                                                    String sty = "danger";
                                                    try {
                                                        if (data.getStatus().equalsIgnoreCase("OPEN")) {
                                                            sty = "success";
                                                        }
                                                    } catch (Exception k) {
                                                    }

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <%
                                                    String course = "N/A";
                                                    try {
                                                        course = data.getCourse1().getName();
                                                    } catch (Exception ka) {
                                                    }
                                                %>
                                                <td><%=course%></td>
                                                <td><%=data.getId()%></td>
                                                <td><%=data.getSurname() + " " + data.getOthernames()%></td>
                                                <td><%=data.getEmailAddress()%></td>
                                                <td><%=data.getPhoneNo()%></td>
                                                <%
                                                    String state = "N/A";
                                                    try {
                                                        state = data.getStateOfOrigin().getName();
                                                    } catch (Exception k) {
                                                    }
                                                     String lga = "N/A";
                                                    try {
                                                        lga = data.getLga().getName();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=state%></td>
                                                <td><%=lga%></td>
                                                <td><%=data.getGender()%></td>
                                                <%
                                                String sdate="";
                                                try{
                                                sdate = settings.formatDate(data.getDateCompleted());
                                                    }catch(Exception ka){}
                                                %>
                                                <td><%=sdate%></td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button class="btn btn-primary dropdown-toggle" type="button" data-coreui-toggle="dropdown" aria-expanded="false">Downloads</button>
                                                        <ul class="dropdown-menu" style="">
                                                            <li><a class="dropdown-item" href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">Application Form</a></li>
                                                            <%
                                                            try{
                                                            List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(data.getId());
                                                            for(Uploadeddocuments dd : ldocs){
                                                            String url = settings.docUrl + "/" + dd.getUrl();
                                                            %>
                                                            <li><a class="dropdown-item" href="<%=url%>"><%=dd.getName()%></a></li>
                                                            <%
                                                                }
                                                                }catch(Exception k){}
                                                            %>
                                                        </ul>
                                                    </div>
                                                
                                                </td>
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