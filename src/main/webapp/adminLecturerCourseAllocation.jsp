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
        <title><%=settings.productName%> - Lecturer Course Allocation</title>

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
                    <h2 class="title"> Lecturer Course Allocation</h2>
                </div>
            </header>

            <%                    String msg = "";
                String std = "danger";

                String idh = request.getParameter("id");
                if (idh != null && idh.length() > 0) {
                    idh = settings.decryptText(idh);
                    Userfaculties stffac = (Userfaculties) sess.getSingleObject(Userfaculties.class, idh);
                    if (stffac != null) {
                        sess.deleteObject(stffac);
                    }
                }
            %>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select Course and Session to view Allocation</strong></div>
                            <div class="card-body">
                                <%    String staffnod = request.getParameter("staffno");
                                    String fac = request.getParameter("fac");

                                    String submit = request.getParameter("submit");
                                    if (submit != null && staffnod != null && staffnod.length() > 0 && fac != null && fac.length() > 0) {
                                        String id = staffnod + fac;
                                        

                                    }
                                %>
                                <div class="example">
                                    <%
                                        if (msg.length() > 0) {
                                    %>
                                    <div class="alert alert-<%=std%>"><%=msg%></div>
                                    <%
                                        }
                                    %>
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <div class="col-sm-4">
                                                        <select id="courses" name="courses" class='form-select' onchange="loadSessions()">
                                                            <option value="">Select Course</option>
                                                            <%
                                                                try {
                                                                    List<Userfaculties> usersl = sess.getUserfacultiesByUserid(user.getId());
                                                                    for (Userfaculties usf : usersl) {
                                                                        List<Courses> coursesl = sess.getCoursesByFaculty(usf.getFacultyId().getId());
                                                                        for (Courses co : coursesl) {
                                                            %>
                                                            <option value="<%=co.getId()%>"><%=co.getName()%></option>
                                                            <%
                                                                        }
                                                                    }

                                                                } catch (Exception ka) {
                                                                }
                                                            %>
                                                        </select>                      
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <select name="sessions" id="sessions" class='form-select'>
                                                            <option value="">Select Session</option>
                                                           
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


                    <div class='alert alert-info'>
                        <%
                            try {
                                List<Users> lstaff = sess.getUsersByRole("1038");

                                for (Users role : lstaff) {
                                    Staff stdy = sess.getStaffById(role.getId());
                                    if (stdy != null) {
                                        String sty = "warning";
                                        int itz = 0;
                                        try {
                                            List<Userfaculties> facs = sess.getUserfacultiesByUserid(stdy.getId());
                                            itz = facs.size();
                                            if (itz > 0) {
                                                sty = "success";
                                            }
                                        } catch (Exception ks) {
                                        }
                        %>
                        <span class="btn btn-<%=sty%> btn-sm" title="<%=stdy.getSurname() + " " + stdy.getOthernames()%>"> <%=stdy.getStaffNo().toUpperCase()%> (<%=itz%>)</span>
                        <%
                                    }
                                }
                            } catch (Exception k) {
                            }
                        %>
                    </div>


                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>List of courses and CPO assignments</div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Faculty</th>
                                                <th>No. of Courses</th>
                                                <th>CPOs</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                List<FacultiesDirectorates> lsch = sess.getAllFacultiesDirectorates();
                                                for (FacultiesDirectorates sch : lsch) {
                                                    int in = 0;
                                                    try {
                                                        List<Courses> coursesl = sess.getCoursesByFaculty(sch.getId());;
                                                        in = coursesl.size();
                                                    } catch (Exception k) {
                                                    }
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=sch.getName()%></td>
                                                <td><%=in%></td>

                                                <td>
                                                    <%
                                                        int siz = 0;
                                                        List<Userfaculties> usersl = sess.getUserfacultiesByFaculty(sch.getId());
                                                        for (Userfaculties usf : usersl) {
                                                            String staffno = "";
                                                            String fname = "";
                                                            Staff stfd = sess.getStaffById(usf.getUserId().getId());
                                                            if (stfd != null) {
                                                                staffno = stfd.getStaffNo().toUpperCase();
                                                                fname = stfd.getSurname() + " " + stfd.getOthernames();
                                                            }
                                                    %>
                                                    <a title="<%=fname%> | Click to remove" href="/admin_cpo_allocation?id=<%=settings.encodeUrl(settings.encryptText(usf.getUserId().getId()))%>" class="btn btn-danger btn-sm"><%=staffno%></a> | 
                                                    <%
                                                        }
                                                    %>
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