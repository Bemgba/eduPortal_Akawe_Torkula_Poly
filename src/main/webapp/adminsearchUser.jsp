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
        <title><%=settings.productName%> - Search User</title>

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
                    <h2 class="title"> Search User</h2>
                </div>
            </header>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter criteria to search</strong></div>
                            <div class="card-body">
                                <%    String searchtext = request.getParameter("searchtext");
                                    String searchfrom = request.getParameter("searchfrom");

                                    String submit = request.getParameter("submit");

                                %>
                                <div class="example">

                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <div class="col-sm-4">
                                                        <input id="searchtext" name="searchtext" placeholder="Enter search text" class='form-control' type="text" required=""/>

                                                    </div>
                                                    <div class="col-sm-4">
                                                        <select name="searchfrom" id="searchfrom" class='form-select'>
                                                            <option value="">Search From</option>
                                                            <option value="Applicant">Applicant</option>
                                                            <option value="Staff">Staff</option>
                                                            <option value="Student">Student</option>

                                                        </select>                      
                                                    </div>
                                                    <div class="col-sm-4">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>





                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>List of records matching search text</div>
                            <div class="card-body">
                                <%    if (submit != null && searchfrom != null && searchfrom.length() > 0 && searchtext != null && searchtext.length() > 0) {
                                        searchtext = searchtext.toLowerCase();

                                        List<UsersDTO> lsch = sess.searchUser(searchtext, searchfrom);
                                        if (lsch.isEmpty()) {
                                %>
                                <div class="alert alert-warning">No search record found in <%=searchfrom%> matching <%=searchtext%></div>
                                <%
                                } else {
                                %>


                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Username</th>
                                                <th>Identification No</th>
                                                <th>Full Name</th>
                                                <th>Role</th>
                                                <th>Email Address</th>
                                                <th>Phone Number</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;

                                                for (UsersDTO sch : lsch) {
                                                    int in = 0;

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=sch.getUsername()%></td>
                                                <td><%=sch.getIdno()%></td>
                                                <td><%=sch.getFullname()%></td>
                                                <td><%=sch.getRole()%></td>
                                                <td><%=sch.getEmail()%></td>
                                                <td><%=sch.getPhoneno()%></td>

                                            </tr>
                                            <%
                                                    i++;
                                                }
                                            %>


                                        </tbody>
                                    </table>
                                </div>
                                <%
                                        }
                                    }
                                %>
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