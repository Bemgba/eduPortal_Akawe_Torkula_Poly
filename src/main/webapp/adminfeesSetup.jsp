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

<%    String schools = request.getParameter("schools");
    String sessions = request.getParameter("sessions");
    String semester = request.getParameter("semester");
    String item = request.getParameter("item");
    List<Paymentreference> paylist = new ArrayList();
    String submit = request.getParameter("button");
    if (submit != null && item != null && item.length() > 0) {
        try {
            session.setAttribute("schools", schools);
            session.setAttribute("sessions", sessions);
            session.setAttribute("semester", semester);
            session.setAttribute("item", item);
            response.reset();  // Clears any buffered response data
            response.sendRedirect("/admin_fees_details");
            return;
        } catch (Exception k) {
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Fees Setup</title>

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
                    <h2 class="title">Fees Setup</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select category to view fees setup</strong>
                                <a href="/create_fees_group" class="btn btn-info btn-sm float-end">Manage Fee Groups</a>
                            </div>
                            <div class="card-body">

                                <div class="example">
                                    <form action='' method='post' name="verify">


                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select School
                                            </span>
                                            <%                                                List<Schools> schl = sess.getAllSchoos();
                                            %>
                                            <select class="form-select" name="schools" id="schools" onchange="loadItems();">
                                                <option value="">Select One</option>
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
                                                Payment Item
                                            </span>
                                            <select class="form-select" name="item" id="item">
                                                <option value="">Select One</option>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Session 
                                            </span>
                                            <select class="form-select" name="sessions" id="sessions">
                                                <option value="">Select One</option>
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
                                                <input type="submit" name="button" class="btn btn-primary px-4" value="View"/>
                                            </div>

                                        </div>

                                    </form>
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