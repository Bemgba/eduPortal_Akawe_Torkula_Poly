<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    String idx3 = request.getParameter("id");
    if (idx3 != null) {
        idx3 = settings.decryptText(idx3);
        if (idx3.contains(";")) {
            String split[] = idx3.split(";");
            String courseid = split[0];
            String level = split[1];
            String semester = split[2];
            Courses co = sess.getCourses(courseid);
            if (co != null) {
                session.setAttribute("course", co);
                session.setAttribute("level", level);
                session.setAttribute("semester", semester);

                response.sendRedirect("/edit_semester_courses");
            }
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Semester Registration Courses</title>

        <script>

            async function viewStudentsa(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsa&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "deta").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }

            async function viewStudentsb(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsb&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detb").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsc(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsc&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detc").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsd(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsd&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detd").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentse(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentse&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "dete").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsf(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsf&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detf").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsg(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsg&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detg").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }


            async function viewStudentsj(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsj&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detj").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsk(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsk&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detk").innerHTML = respText;     // Use `id2` here
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
                    <h2 class="title">Semester Registration Courses</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select query criteria</strong></div>
                            <div class="card-body">
                                <%                                    String schools = request.getParameter("schools");
                                    String fac = request.getParameter("fac");
                                    String msg = "";
                                    String sty = "danger";
                                    String submit = request.getParameter("button2");
                                    if (submit != null && schools != null && schools.length() > 0) {

                                    }
                                %>
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View Form</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="example">
                                        <form name="edit" method="post" action="">
                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    Select School   
                                                </span>
                                                <select class="form-select" name="schools" id="schools">
                                                    <option value="">Select School</option>
                                                    <%                                                            try {
                                                            List<Schools> lsch = sess.getAllSchoos();
                                                            for (Schools prod : lsch) {
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
                                                    Select Faculty 
                                                </span>
                                                <select class="form-select" name="fac" id="fac">
                                                    <option value="">Select Faculty</option>
                                                    <%                                                            try {
                                                            List<FacultiesDirectorates> lsch = sess.getAllFacultiesDirectorates();
                                                            for (FacultiesDirectorates prod : lsch) {
                                                    %>
                                                    <option value="<%=prod.getId()%>"> <%=prod.getName()%></option>
                                                    <%
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                </select>
                                            </div>

                                            <div class="row">
                                                <div class="col-6">
                                                    <input type="submit" name="button2" class="btn btn-success px-4" value="View Records"/>
                                                </div>
                                            </div>

                                        </form>
                                    </div>

                                </div>



                            </div>
                        </div>
                    </div>

                    <%
                        if (submit != null && schools != null && schools.length() > 0) {
                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong> records found</strong>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm" style="max-height: 400px; overflow-y: auto;">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th colspan="5"></th>
                                                <th colspan="6" class="text-center bg-primary text-white">First Semester</th>
                                                <th colspan="6" class="text-center bg-secondary text-white">Second Semester</th>
                                            </tr>
                                            <tr>
                                                <th>#</th>
                                                <th>Department</th>
                                                <th>Course</th>
                                                <th>Level</th>
                                                <th>Current Students</th>
                                                <th>GST Courses (TCU)</th>
                                                <th>Core Courses (TCU)</th>
                                                <th>General Electives</th>
                                                <th>Min CU</th>
                                                <th>Max CU</th>
                                                <th>View/Edit</th>
                                                <th>GST Courses (TCU)</th>
                                                <th>Core Courses (TCU)</th>
                                                <th>General Electives</th>
                                                <th>Min CU</th>
                                                <th>Max CU</th>
                                                <th>View/Edit</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                try {
                                                    List<CourseSummaryDTO> coursesData = sess.getCourseSummary(schools, fac);

                                                    for (CourseSummaryDTO data : coursesData) {
                                                        String id1 = data.getCourseId() + ";" + data.getLevel() + ";First";
                                                        id1 = settings.encodeUrl(settings.encryptText(id1));
                                                        String id2 = data.getCourseId() + ";" + data.getLevel() + ";Second";
                                                        id2 = settings.encodeUrl(settings.encryptText(id2));

                                                        Semesterregistrationcucontrol minmaxf = sess.getSemesterregistrationcucontrol(data.getCourseId(), data.getLevel(), "First");
                                                        Semesterregistrationcucontrol minmaxs = sess.getSemesterregistrationcucontrol(data.getCourseId(), data.getLevel(), "Second");
                                                        int mindf = 0;
                                                        int maxdf = 0;
                                                        int minds = 0;
                                                        int maxds = 0;
                                                        try {
                                                            if (minmaxf != null) {
                                                                mindf = minmaxf.getMincu();
                                                                maxdf = minmaxf.getMaxcu();
                                                            }
                                                            if (minmaxs != null) {
                                                                minds = minmaxs.getMincu();
                                                                maxds = minmaxs.getMaxcu();
                                                            }
                                                        } catch (Exception jh) {
                                                        }

                                            %>
                                            <tr>
                                                <td><%= i%></td>
                                                <td><%= data.getDepartmentName()%></td>
                                                <td><%= data.getCourseName()%></td>
                                                <td><%= data.getLevel()%></td>

                                                <td style="text-align:right"><%= data.getTotalStudents()%></td>
                                                <td style="text-align:right"><%=data.getGstFirstCount() + " (" + data.getGstFirstCredits() + ")"%></td>
                                                <td style="text-align:right"><%= data.getCoreFirstCount() + " (" + data.getCoreFirstCredits() + ")"%></td>
                                                <td style="text-align:right"><%= data.getElectiveFirstCount()%></td>
                                                <td style="text-align:right"><%= mindf%></td>
                                                <td style="text-align:right"><%= maxdf%></td>
                                                <td><a href="/sem_reg_courses?id=<%=id1%>" class="btn btn-primary btn-sm">View/Edit</a></td>
                                                <td style="text-align:right"><%=data.getGstSecondCount() + " (" + data.getGstSecondCredits() + ")"%></td>
                                                <td style="text-align:right"><%= data.getCoreSecondCount() + " (" + data.getCoreSecondCredits() + ")"%></td>
                                                <td style="text-align:right"><%= data.getElectiveSecondCount()%></td>
                                                <td style="text-align:right"><%= minds%></td>
                                                <td style="text-align:right"><%= maxds%></td>
                                                <td><a href="/sem_reg_courses?id=<%=id2%>" class="btn btn-primary btn-sm">View/Edit</a></td>
                                            </tr>
                                            <%
                                                        i++;
                                                    }
                                                } catch (Exception e) {
                                                    e.printStackTrace();
                                                }
                                            %>
                                        </tbody>
                                    </table>


                                </div>
                            </div>
                        </div>
                    </div>
                    <% }%>


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