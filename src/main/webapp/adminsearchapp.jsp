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
        <title><%=settings.productName%> - Search Applicants</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Search Applicants</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter Search term</strong></div>
                            <div class="card-body">
                                <%    String payerno = request.getParameter("payerno");
                                    String submit = request.getParameter("submit");
                                    if (submit != null && payerno != null && payerno.length() > 0) {
                                        payerno = payerno.toLowerCase();
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Enter Search term</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="payerno" type="text" name="payerno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Search Now</button>                       
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
           
                           

                               <div class="card-header"><strong>List of applicants records matching search text <%=payerno%></div>
                            <div class="card-body">
                                <%    if (submit != null && payerno != null && payerno.length() > 0 ) {
                                        payerno = payerno.toLowerCase();

                                        List<UsersDTO> lsch = sess.searchUser(payerno, "Applicant");
                                        if (lsch.isEmpty()) {
                                %>
                                <div class="alert alert-warning">No search record found in Applicants matching <%=payerno%></div>
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