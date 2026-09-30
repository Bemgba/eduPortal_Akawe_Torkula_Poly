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
        <title><%=settings.productName%> - Change Staff Roles</title>

        <script>

            async function viewDetails() {
                try {
                    var staffno = document.getElementById("staffno").value;
                    const url = "AjaxServlet?action=viewStaffDetails&id2=" + escape(staffno);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById("det").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }

            async function loadUsers(recordid) {
                try {
                    const url = "AjaxServlet?action=loadUsers&id2=" + escape(recordid);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(recordid + "k").innerHTML = respText; // Use `id` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }

            async function loadPages(recordid) {
                try {
                    const url = "AjaxServlet?action=loadPages&id2=" + escape(recordid);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(recordid + "l").innerHTML = respText; // Use `id` here
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
                    <h2 class="title">Staff Roles</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Enter Staff Number to Change/View Role</strong></div>
                            <div class="card-body">
                                <%                                    List<Roles> lroles = sess.getRolesByType("STAFF_PUBLIC");
                                    String staffno = request.getParameter("staffno");
                                    String newrole = request.getParameter("newrole");
                                    String msg = "";
                                    String sty = "danger";
                                    String submit = request.getParameter("submit");
                                    if (submit != null && staffno != null && staffno.length() > 0) {
                                        staffno = staffno.toLowerCase();
                                        Staff stfd = sess.getStaffById(staffno);
                                        if (stfd != null) {
                                            int iro = Integer.valueOf(newrole);
                                            Roles ro = (Roles) sess.getSingleObject(Roles.class, iro);
                                            if (ro != null) {
                                                Users usdx = (Users) sess.getSingleObject(Users.class, stfd.getId());
                                                if (usdx != null) {
                                                    sess.updateUserRole(stfd.getId(), iro);
                                                }
                                                msg = "Staff matching " + staffno + " has been added to role " + ro.getName();
                                            } else {
                                                msg = "This role is not found or not assignable";
                                            }

                                            sty = "success";
                                        } else {
                                            msg = "Staff matching either number or university email " + staffno + " is not found";
                                        }

                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="staffno">Staff Number</label>
                                                    <div class="col-sm-3">
                                                        <input class="form-control" id="staffno" type="text" name="staffno" required="">
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <select name="newrole" class='form-select'>
                                                            <%
                                                                try {
                                                                    for (Roles role : lroles) {
                                                            %>
                                                            <option value="<%=role.getId()%>"><%=role.getName()%></option>
                                                            <%
                                                                    }
                                                                } catch (Exception ka) {
                                                                }
                                                            %>
                                                        </select>                      
                                                    </div>
                                                    <div class="col-sm-2">
                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Change Role</button>                       
                                                    </div>
                                                    <div class="col-sm-2">
                                                        <a href="#" 
                                                           class="btn btn-secondary mb-3"
                                                           data-coreui-toggle="modal" 
                                                           data-coreui-target="#details" 
                                                           onclick="viewDetails()" 
                                                           >
                                                            View Details
                                                        </a>

                                                        <div class="modal fade" id="details" tabindex="-1" aria-labelledby="detailslab" aria-hidden="true">
                                                            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="detailslab">User Details</h5>
                                                                        <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">

                                                                        <div id="det">Loading...</div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%

                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong><%=lroles.size()%> staff's public roles found</div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Role</th>
                                                <th>Number of Staff</th>
                                                <th>Pages</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Roles role : lroles) {
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=role.getName()%></td>
                                                <%
                                                    int size = 0;
                                                    try {
                                                        size = sess.getUsersByRole(role.getId() + "").size();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td>

                                                    <a href="#" 
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=role.getId()%>s" 
                                                       onclick="loadUsers('<%=role.getId()%>')" 
                                                       >
                                                        <%=size%>
                                                    </a>

                                                    <div class="modal fade" id="<%=role.getId()%>s" tabindex="-1" aria-labelledby="<%=role.getId()%>slab" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=role.getId()%>slab">List Staff as  <%=role.getName()%></h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=role.getId()%>k">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <%
                                                    int pagess = 0;
                                                    try {
                                                        pagess = sess.getAllPagesforRole(role.getId() + "").size();
                                                    } catch (Exception k) {
                                                    }

                                                %>
                                                <td>

                                                    <a href="#" 
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=role.getId()%>m" 
                                                       onclick="loadPages('<%=role.getId()%>')" 
                                                       >
                                                        <%=pagess%>
                                                    </a>

                                                    <div class="modal fade" id="<%=role.getId()%>m" tabindex="-1" aria-labelledby="<%=role.getId()%>mlab" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=role.getId()%>mlab">Pages accessible by <%=role.getName()%></h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=role.getId()%>l">Loading...</div>
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