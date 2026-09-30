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
    Courses course = null;
    String level = null;
    String semester = null;
    try {
        course = (Courses) session.getAttribute("course");
        level = (String) session.getAttribute("level");
        semester = (String) session.getAttribute("semester");
    } catch (Exception k) {
    }
    if (course == null || level == null || semester == null) {
        response.sendRedirect("/sem_reg_courses");
    }
%>



<%
    String id1 = request.getParameter("id");
    if (id1 != null) {
        id1 = settings.decryptText(id1);
        Semesterregistrationcourses pg = (Semesterregistrationcourses) sess.getSingleObject(Semesterregistrationcourses.class, id1);
        if (pg != null) {
            sess.deleteSemesterregistrationcourses(pg.getId());
        }

    }

    String id3 = request.getParameter("id3");
    if (id3 != null) {
        id3 = settings.decryptText(id3);
        Semesterregistrationcourses pg = (Semesterregistrationcourses) sess.getSingleObject(Semesterregistrationcourses.class, id3);
        if (pg != null) {
            String newstatus = "INACTIVE";
            if (pg.getCourseStatus().equalsIgnoreCase("ACTIVE")) {
                newstatus = "INACTIVE";
            } else {
                newstatus = "ACTIVE";
            }
            sess.updateSemesterregistrationcoursesStatus(pg.getId(), newstatus);
        }

    }

    String id2 = request.getParameter("id2");
    if (id2 != null) {
        id2 = settings.decryptText(id2);

        Semestercourses pg = (Semestercourses) sess.getSingleObject(Semestercourses.class, id2);
        if (pg != null) {
            pg.setStatus("ACTIVE");
            sess.updateSemesterCourseStatus(pg.getId(), "ACTIVE");
        }

    }


%>

<%     Semesterregistrationcucontrol minmax = sess.getSemesterregistrationcucontrol(course.getId(), level, semester);
    int mind = 0;
    int maxd = 0;
    String lab = "Add";
    try {
        if (minmax != null) {
            mind = minmax.getMincu();
            maxd = minmax.getMaxcu();
            lab = "Edit";
        }
    } catch (Exception jh) {
    }

%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Semester Courses for <%=course.getName()%></title>


        <script>

            async function getCoursesTakingsemco(semcourse) {

                try {
                    const url = "AjaxServlet?action=getCoursesTakingsemco&id2=" + escape(semcourse);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(semcourse + "k").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error loading data:", error);
                    document.getElementById(semcourse + "k").innerHTML = "<p>Error loading data. Please try again later.</p>";
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
                    <h2 class="title">Semester Courses for <%=course.getName()%> <%=level%> Level <%=semester%> Semester</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">



                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">You can click on a course to deactivate/activate from the tabs
                                <a href="/sem_reg_courses" class="btn btn-danger btn-sm float-end">Back</a>
                            </div>

                        </div>
                        <div class="card mb-4">
                            <div class="card-header">Click to add new Course
                            </div>
                            <div class="card-body">
                                <p>
                                    <button class="btn btn-success" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">Add New</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="example">
                                        <%
                                            String semcourses = request.getParameter("semcourses");
                                            String regtype = request.getParameter("regtype");
                                            String creditunits = request.getParameter("creditunits");
                                            String perp = request.getParameter("perp");
                                            String perca = request.getParameter("perca");
                                            String perexam = request.getParameter("perexam");
                                            String button2 = request.getParameter("button2");
                                            if (button2 != null && button2.length() > 0) {
                                                Semesterregistrationcourses src = sess.getSemesterregistrationcourses(semcourses, course.getId());
                                                if (src != null) {
                                        %>
                                        <div class="alert alert-warning">This semester course is already added to the selected course</div>
                                        <%
                                        } else {
                                            String idy = settings.getTodaysdate().split("-")[0] + settings.generateId("", 4);
                                            src = new Semesterregistrationcourses(idy);
                                            Semestercourses smc = (Semestercourses) sess.getSingleObject(Semestercourses.class, semcourses);
                                            src.setCourseId(course);
                                            src.setCourseStatus("ACTIVE");
                                            src.setCourseType(regtype);
                                            src.setCreditUnit(Integer.parseInt(creditunits));
                                            src.setLevel(level);
                                            src.setPerPractical(Integer.parseInt(perp));
                                            src.setPerca(Integer.parseInt(perca));
                                            src.setPerexam(Integer.parseInt(perexam));
                                            src.setSemester(semester);
                                            src.setSemesterCourseId(smc);
                                            src.setCourseCategory("CCMAS");
                                            sess.newEntry(src);

                                        %>
                                        <div class="alert alert-success">This semester course has been added to <%=course.getName()%> successfully</div>
                                        <%
                                                }
                                            }
                                        %>

                                        <%
                                            String micu = request.getParameter("micu");
                                            String macu = request.getParameter("macu");
                                            String button3 = request.getParameter("button3");
                                            System.out.println("sssss " + micu + ", " + macu + ", " + button3);
                                            if (button3 != null && button3.length() > 0) {
                                                if (minmax == null) {
                                                    String idy = course.getId() + level + settings.generateId("", 4);
                                                    minmax = new Semesterregistrationcucontrol(idy);
                                                    minmax.setCourseId(course);
                                                    minmax.setLevel(level);
                                                    minmax.setMaxcu(Integer.parseInt(macu));
                                                    minmax.setMincu(Integer.parseInt(micu));
                                                    minmax.setSemester(semester);
                                                    sess.newEntry(minmax);
                                                    minmax = sess.getSemesterregistrationcucontrol(course.getId(), level, semester);
                                                    mind = minmax.getMincu();
                                                    maxd = minmax.getMaxcu();
                                                    lab = "Edit";
                                                } else {

                                                    sess.updateSemesterregistrationcucontrol(minmax.getId(), Integer.parseInt(micu), Integer.parseInt(macu));
                                                    minmax = sess.getSemesterregistrationcucontrol(course.getId(), level, semester);
                                                    mind = minmax.getMincu();
                                                    maxd = minmax.getMaxcu();
                                                    lab = "Edit";
                                                }
                                            }
                                        %>

                                        <%
                                            List<Semesterregistrationcourses> allcouurses = sess.getSemesterRegistrationCourses(course.getId(), level, semester, "ACTIVE");
                                            allcouurses.addAll(sess.getSemesterRegistrationCourses(course.getId(), level, semester, "INACTIVE"));
                                            int nocore = 0;
                                            int nogst = 0;
                                            int noelective = 0;
                                            try {
                                                List<Semesterregistrationcourses> allcore = allcouurses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("CORE")
                                                        && oltype.getCourseStatus().equalsIgnoreCase("ACTIVE"))
                                                        .collect(Collectors.toList());
                                                nocore = allcore.size();
                                                List<Semesterregistrationcourses> allgst = allcouurses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("GST")
                                                        && oltype.getCourseStatus().equalsIgnoreCase("ACTIVE"))
                                                        .collect(Collectors.toList());
                                                nogst = allgst.size();
                                                List<Semesterregistrationcourses> allelective = allcouurses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("ELECTIVE")
                                                        && oltype.getCourseStatus().equalsIgnoreCase("ACTIVE"))
                                                        .collect(Collectors.toList());
                                                noelective = allelective.size();

                                            } catch (Exception h) {
                                            }
                                        %>



                                        <form name="edit" method="post" action="">
                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    Select Semester Course   
                                                </span>
                                                <input list="semcoursesl" name="semcourses" class="form-control" id="semcoursesid" placeholder="Type to search...">
<datalist id="semcoursesl">
     <option value="">Select One</option>
                                                    <%                                                  
                                                        List<Semestercourses> listp = sess.getSemesterCourseList(level, course.getSchoolProgrammeId().getProgrammeId().getId());
                                                        for (Semestercourses semc : listp) {

                                                    %>
                                                    <option value="<%=semc.getId()%>"><%=semc.getCode() + " : " + semc.getName()%></option>
                                                    <%
                                                        }
                                                    %>
                                                    

</datalist>
                                                
                                                
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Registration Type 
                                                </span>
                                                <select class="form-select" name="regtype" id="regtype">
                                                    <option value="">Select One</option>
                                                    <option value="CORE">CORE</option>
                                                    <option value="GST">GST/EPS</option>
                                                    <option value="ELECTIVE">ELECTIVE</option>
                                                </select>
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Credit Units 
                                                </span>
                                                <input type="number" min="0" class="form-control" name="creditunits" required=""/>
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Percent Practicals 
                                                </span>
                                                <input type="number" min="0" class="form-control" name="perp" value="0" required=""/>
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Percent CA 
                                                </span>
                                                <input type="number" min="0" class="form-control" value="30" name="perca" required=""/>
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Percent Exam 
                                                </span>
                                                <input type="number" min="0" class="form-control" name="perexam" value="70" required=""/>
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
                        <div class="card mb-4">
                            <div class="card-header">
                                Details
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTab'>
                                        <tr>
                                            <th>Minimum Credit Units</th>
                                            <td><%=mind%></td>
                                        </tr>
                                        <tr>
                                            <th>Maximum Credit Units</th>
                                            <td><%=maxd%></td>
                                        </tr>
                                        <tr>
                                            <th>Number of GST</th>
                                            <td><%=nogst%></td>
                                        </tr>
                                        <tr>
                                            <th>Number of CORE</th>
                                            <td><%=nocore%></td>
                                        </tr>
                                        <tr>
                                            <th>Number of ELECTIVES</th>
                                            <td><%=noelective%></td>
                                        </tr>

                                        <tr>
                                            <th></th>
                                            <td>

                                                <button type="button" class="btn btn-primary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                                    Edit                                
                                                </button>

                                                <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="exampleModalLabel">Edit Semester Registration Controls</h5>
                                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">

                                                                <form name="edit2" method="post" action="">


                                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                                            Minimum Credit Units
                                                                        </span>
                                                                        <input type="number" min="0" value="<%=mind%>" class="form-control" name="micu" required=""/>
                                                                    </div>
                                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                                            Maximum Credit Units
                                                                        </span>
                                                                        <input type="number" value="<%=maxd%>" min="0" class="form-control" name="macu" required=""/>
                                                                    </div>

                                                                    <div class="row">
                                                                        <div class="col-6">
                                                                            <input type="submit" name="button3" class="btn btn-primary px-4" value="<%=lab%>"/>
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
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4">



                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable2'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Course Code</th>
                                                <th>Course Name</th>
                                                <th>Credit Unit</th>
                                                <th>Course Type</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%    int n = 1;
                                                for (Semesterregistrationcourses data2 : allcouurses) {
                                            %>
                                            <tr>
                                                <td><%=n%></td>
                                                <td><%=data2.getSemesterCourseId().getCode()%></td>
                                                <td><%=data2.getSemesterCourseId().getName()%></td>
                                                <td><%=data2.getCreditUnit()%></td>
                                                <td><%=data2.getCourseType()%></td>
                                                <td>
                                                    <%
                                                        if (data2.getCourseStatus().equalsIgnoreCase("ACTIVE")) {
                                                    %>
                                                    <a title="Click to deactivate" href="/edit_semester_courses?id3=<%=settings.encodeUrl(settings.encryptText(data2.getId()))%>" class="btn btn-success btn-sm">ACTIVE</a>
                                                    <%
                                                    } else {
                                                    %>
                                                    <a title="Click to activate" href="/edit_semester_courses?id3=<%=settings.encodeUrl(settings.encryptText(data2.getId()))%>" class="btn btn-warning btn-sm">INACTIVE</a>
                                                    <%
                                                        }
                                                    %>
                                                    <a href="/edit_semester_courses?id=<%=settings.encodeUrl(settings.encryptText(data2.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                            </tr>
                                            <%
                                                    n++;
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

                new DataTable('#dataTable2', {
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