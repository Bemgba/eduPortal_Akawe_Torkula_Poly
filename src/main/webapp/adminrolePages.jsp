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
        <title><%=settings.productName%> - Manage Role Pages</title>

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
                    <h2 class="title"> Manage Role Pages</h2>
                </div>
            </header>

            <%    int rowSize = 0;
                int wid = 80;
                List<Roles> row = sess.getRolesByType("ALL");
                List<Pages> al = sess.getAllPages();
                rowSize = row.size();
                int pageSize = al.size();
            %>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Page and role to bind</strong></div>
                            <div class="card-body">
                                <%
                                    String idk = request.getParameter("id");
                                    if (idk != null && idk.length() > 0) {
                                        idk = settings.decryptText(idk);
                                        String[] splitter = idk.split(";");
                                        Pages pag = (Pages) sess.getSingleObject(Pages.class, splitter[0]);
                                        if (pag != null) {
                                            sess.removeRoleFromPage(splitter[0], splitter[1]);
                                %>
                                <div class="alert alert-success">Role has been removed from page</div>
                                <%
                                        }
                                    }
                                %>
                                <%    String pagesd = request.getParameter("pages");
                                    String rolesd = request.getParameter("roles");

                                    String submit = request.getParameter("submit");
                                    if (submit != null && rolesd != null && rolesd.length() > 0 && pagesd != null && pagesd.length() > 0) {
                                        Pages pgd = (Pages) sess.getSingleObject(Pages.class, pagesd);
                                        int ind = 0;
                                        try {
                                            ind = Integer.parseInt(rolesd);
                                        } catch (Exception ka) {
                                        }
                                        Roles rnd = (Roles) sess.getSingleObject(Roles.class, ind);
                                        if (rnd != null && pgd != null) {
                                            if (pgd.getRoles().contains(ind + "")) {
                                %>
                                <div class="alert alert-danger">This role <%=rnd.getName()%> is already added to page <%=pgd.getName()%></div>
                                <%
                                } else {
                                    sess.addRoleToPage(pgd.getId(), ind);


                                %>
                                <div class="alert alert-success">The role <%=rnd.getName()%> has been added to <%=pgd.getName()%></div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="alert alert-danger">Wrong item selection</div>
                                <%
                                        }
                                    }

                                %>
                                <div class="example">

                                    <form action="" method="post" name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <div class="col-sm-4">
                                                        <select name="pages" id="pages" class='form-select'>
                                                            <option value="">Select Page</option>
                                                            <%         List<Pages> lpages = sess.getAllPages();
                                                                for (Pages paged : lpages) {
                                                            %>
                                                            <option value="<%=paged.getId()%>"><%=paged.getDescription()%> (<%=paged.getAlias()%>)</option>
                                                            <%
                                                                }
                                                            %>

                                                        </select> 
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <select name="roles" id="roles" class='form-select'>
                                                            <option value="">Select Role</option>
                                                            <%
                                                                List<Roles> lroles = sess.getRolesByType("STAFF_PUBLIC");
                                                                for (Roles rold : lroles) {
                                                            %>
                                                            <option value="<%=rold.getId()%>"><%=rold.getName()%></option>
                                                            <%
                                                                }

                                                            %>


                                                        </select>                      
                                                    </div>
                                                    <div class="col-sm-4">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Add</button>                       
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

                            <div class="card-header"><strong>List of Pages and associated roles</div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th width="5%" class="center">#</th>
                                                <th width="25%">Page Name</th>
                                                <th width="15%">Alias</th>
                                                <th width="55%">Users</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                int k = 1;
                                                for (Pages pay : lpages) {
                                            %>
                                            <tr>
                                                <td class="center"><%=k%></td>
                                                <td><%=pay.getDescription()%></td>
                                                <td><%=pay.getAlias()%></td>
                                                <td>
                                                    <%
                                                        try {
                                                            String[] rox = pay.getRoles().split(";");
                                                            for (String rd : rox) {
                                                                int ron = 0;
                                                                try {
                                                                    ron = Integer.parseInt(rd);
                                                                } catch (Exception sa) {
                                                                }
                                                                Roles rolex = sess.getRoles(ron);
                                                                if (rolex != null) {
                                                                    if (rolex.getRoleType() != null && rolex.getRoleType().equalsIgnoreCase("STAFF_PUBLIC")) {
                                                                        String idy = pay.getId() + ";" + ron;
                                                    %>
                                                    <a href="/admin_role_pages?id=<%=settings.encodeUrl(settings.encryptText(idy))%>" class="btn btn-warning btn-sm" title="Click to remove"><%=rolex.getName()%></a>
                                                    <%
                                                    } else {
                                                    %>
                                                    <a href="#" onclick="event.preventDefault();" class="btn btn-secondary btn-sm" title="Can not be removed"><%=rolex.getName()%></a>                                                    
                                                    <%
                                                                    }
                                                                }
                                                            }

                                                        } catch (Exception ka) {
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <%
                                                    k++;
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