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
        <title><%=settings.productName%> - Update User Email Address</title>

        <script>

            async function loadUserDetails() {
                try {
                    document.getElementById("details").innerHTML = "Loading...";
                    let searchText = document.getElementById("searchtext").value.trim();
                    let searchFrom = document.getElementById("searchfrom").value;
                    if (searchText === "") {
                        alert("Please enter a user number.");
                        return;
                    }

                    if (searchFrom === "") {
                        alert("Please select a category.");
                        return;
                    }

                    const url = "AjaxServlet?action=loadUserDetails&id=" + escape(searchText) + "&id2=" + escape(searchFrom);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById("details").innerHTML = respText;     // Use `id2` here
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
                    <h2 class="title"> Update User Email Address</h2>
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
                                    String newemail = request.getParameter("newemail");
                                    String submit = request.getParameter("button2");
                                    if (submit != null && submit.length() > 0 && newemail != null && newemail.trim().length() > 0 && searchtext != null && searchtext.length() > 0 && searchfrom != null && searchfrom.length() > 0) {
                                        newemail = newemail.trim().toLowerCase();
                                        searchtext = searchtext.trim().toLowerCase();
                                        Users usx = sess.getUsersByEmail(newemail);
                                        String userid = "";
                                        if (searchfrom.equalsIgnoreCase("Applicant")) {
                                            Applicants app = sess.getApplicantsById(searchtext);
                                            if (app != null) {
                                                sess.updateApplicantEmail(app.getId(), newemail);
                                                userid = app.getId();
                                            }
                                        }
                                        if (searchfrom.equalsIgnoreCase("Staff")) {
                                            Staff app = sess.getStaffById(searchtext);
                                            if (app != null) {
                                                sess.updateStaffEmail(app.getId(), newemail);
                                                userid = app.getId();
                                            }

                                        }
                                        if (searchfrom.equalsIgnoreCase("Student")) {
                                            Students app = sess.getStudentsById(searchtext);
                                            if (app != null) {
                                                sess.updateStudents(app.getId(), newemail);
                                                userid = app.getId();
                                            }

                                        }
                                        if (userid != null && userid.length() > 0) {
                                            if (usx != null) {
                                %>
                                <div class="alert alert-warning">This email address <%=newemail%> has been added successfully to <%=searchfrom%> id <%=searchtext%> however, we can not create  login account with it because somebody is already using it.</div>
                                <%
                                } else {
                                    sess.updateUserEmail(userid, newemail);
                                %>
                                <div class="alert alert-success">This email address <%=newemail%> has been added successfully to <%=searchfrom%> id <%=searchtext%>, you can also use it to login to the portal.</div>
                                <%
                                    }

                                } else {
                                %>
                                <div class="alert alert-danger">No user was fount in <%=searchfrom%> matching <%=searchtext%> .</div>
                                <%
                                        }

                                    }


                                %>
                                <div class="example">

                                    <form name="edit" method="post" action="">
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Enter User Number   
                                            </span>
                                            <input id="searchtext" name="searchtext" placeholder="Enter search text" class='form-control' type="text" required=""/>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Category 
                                            </span>
                                            <select name="searchfrom" id="searchfrom" class='form-select'>
                                                <option value="">Search From</option>
                                                <option value="Applicant">Applicant</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Student">Student</option>

                                            </select>   
                                        </div>
                                        <div class="input-group mb-4">
                                            <a href="#" class="btn btn-secondary btn-sm" onclick="event.preventDefault(); loadUserDetails();">View Details</a>
                                        </div>
                                        <div id="details">

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