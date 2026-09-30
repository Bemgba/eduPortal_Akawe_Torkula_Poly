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
    List<Programmes> lprog = sess.getAllProgrammes();
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">

        <title><%=settings.productName%> - Semester Courses Management</title>
    </head>
    <%
        String id1d = request.getParameter("id1");
        if (id1d != null) {
            id1d = settings.decryptText(id1d);
            String[] split = id1d.split(";");
            String prod = split[0];
            String stat = split[1];
            Programmes pg = (Programmes) sess.getSingleObject(Programmes.class, Integer.valueOf(prod));
            if (pg != null && stat.equalsIgnoreCase("ACTIVE")) {
                session.setAttribute("prog", pg);
                session.setAttribute("stat", stat);
                response.sendRedirect("/list_sem_courses");
            }
            
            if (pg != null && stat.equalsIgnoreCase("INACTIVE")) {
                session.setAttribute("prog", pg);
                session.setAttribute("stat", stat);
                response.sendRedirect("/list_sem_courses");
            }
            
        }
        

    %>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Semester Courses Management</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <%                            String prog = request.getParameter("prog");
                            String coursecode = request.getParameter("coursecode");
                            String coursename = request.getParameter("coursename");
                            String semester = request.getParameter("semester");
                            String level = request.getParameter("level");
                            String units = request.getParameter("units");
                            String button2 = request.getParameter("button2");
                            if (button2 != null && button2.length() > 0 && coursecode != null && coursecode.length() > 0) {
                                coursecode = coursecode.trim();
                                coursecode = coursecode.toUpperCase();
                                try {
                                    Semestercourses semco = sess.getSemestercoursesByCodeAndProgramme(coursecode, prog);
                                    if (semco != null) {
                        %>
                        <div class="alert alert-danger">Course code <%=coursecode%> is already added to this programme</div>
                        <%
                        } else {
                            String id = settings.getTodaysdate().split("-")[0] + settings.generateId("", 4);
                            Semestercourses sc = new Semestercourses(id);
                            Programmes prg = (Programmes) sess.getSingleObject(Programmes.class, Integer.valueOf(prog));
                            sc.setCode(coursecode);
                            sc.setCreditUnit(Integer.valueOf(units));
                            sc.setDefaultLevel(level);
                            sc.setName(coursename);
                            sc.setProgrammeId(prg);
                            sc.setSemestercourseCategory("CCMAS");
                            sc.setSemester(semester);
                            sc.setStatus("ACTIVE");
                            sess.newEntry(sc);
                        %>
                        <div class="alert alert-success">Course code <%=coursecode%> has been added successfully</div>
                        <%
                                    }
                                } catch (Exception k) {
                                }
                            }
                        %>
                        <div class="card mb-4">
                            <div class="card-header"><strong>Click to view inactive courses and Click on the active courses to add new and deactivate</strong>
                                <p>Newly added courses are automatically made active</p>
                                <div class="float-end">
                                    <a href="/course_management" class="btn btn-info btn-sm me-2">Manage Programes</a>
                                    <a href="/credit_unit_controls" class="btn btn-info btn-sm me-2">Credit Unit Controls</a>
                                    <a href="/sem_reg_courses" class="btn btn-warning btn-sm me-2">Registration Controls</a>
<!--                                    <button type="button" class="btn btn-success btn-sm" data-coreui-toggle="modal" data-coreui-target="#newapp">
                                        AddNew
                                    </button>-->
                                </div>
                            </div>
                            <div class="card-body">

                                <!-- Modal -->
                                <div class="modal fade" id="newapp" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Add New Semester Course</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">

                                                <div class="alert alert-info">Kindly select School and programme so we can provide available courses for you</div>
                                                <form name="edit" method="post" action="">
                                                    <div class="input-group mb-3"><span class="input-group-text">
                                                            Select Programme   
                                                        </span>
                                                        
                                                        <select class="form-select" name="prog" id="prog">
                                                            <option value="">Select Programme</option>
                                                            <%                                                            try {
                                                                    
                                                                    for (Programmes prod : lprog) {
                                                            %>
                                                            <option value="<%=prod.getId()%>"> <%=prod.getName()%></option>
                                                            <%
                                                                    }
                                                                } catch (Exception k) {
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Enter Course Code 
                                                        </span>
                                                        <input type="text" class="form-control" name="coursecode" minlength="3" required=""/>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Enter Course Name 
                                                        </span>
                                                        <input type="text" class="form-control" name="coursename" minlength="3" required=""/>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Default Semester (<em>Can be adjusted</em>)
                                                        </span>
                                                        <select class="form-select" name="semester" id="semester">
                                                            <option value="">Select One</option>
                                                            <option value="First">First</option>
                                                            <option value="Second">Second</option>
                                                        </select>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Default Level 
                                                        </span>
                                                        <input type="number" name="level" class="form-control" minlength="3" maxlength="3" min="100" max="900" required=""/>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Credit Units 
                                                        </span>
                                                        <input type="number" name="units" min="0" class="form-control" required=""/>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button2" class="btn btn-success px-4" value="Add Now"/>
                                                        </div>
                                                    </div>

                                                </form>
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



                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Programme</th>
                                                <th>Active Courses</th>
                                                <th>In-Active Courses</th>
                                                <th>Details</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Programmes data : lprog) {

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>

                                                <%
                                                    List<Semestercourses> active = sess.getAllSemestercoursesByStatusAndProgramme("ACTIVE", data.getId() + "");
                                                    List<Semestercourses> inactive = sess.getAllSemestercoursesByStatusAndProgramme("INACTIVE", data.getId() + "");
                                                    String id1 = data.getId() + ";ACTIVE";
                                                    id1 = settings.encodeUrl(settings.encryptText(id1));
                                                    
                                                    String id2 = data.getId() + ";INACTIVE";
                                                    id2 = settings.encodeUrl(settings.encryptText(id2));
                                                %>

                                                <td><%=active.size()%></td>
                                                <td><%=inactive.size()%></td>
                                                <td><a href="/manage_sem_courses?id1=<%=id1%>" class="btn btn-primary btn-sm">Details</a></td>
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