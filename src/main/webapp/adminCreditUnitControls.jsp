<%-- 
    Document   : adminCreditUnitControls
    Created on : Dec 27, 2024
    Author     : Kiro
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
    // Handle form submissions
    String schools = request.getParameter("schools");
    String fac = request.getParameter("fac");
    String courseId = request.getParameter("courseId");
    String level = request.getParameter("level");
    String semester = request.getParameter("semester");
    String minCu = request.getParameter("minCu");
    String maxCu = request.getParameter("maxCu");
    String action = request.getParameter("action");
    String msg = "";
    String sty = "danger";

    // Handle create/update credit unit control
    if ("save".equals(action) && courseId != null && level != null && semester != null) {
        try {
            Semesterregistrationcucontrol existing = sess.getSemesterregistrationcucontrol(courseId, level, semester);
            if (existing == null) {
                // Create new
                String id = courseId + level + semester + settings.generateId("", 4);
                existing = new Semesterregistrationcucontrol(id);
                Courses course = (Courses) sess.getSingleObject(Courses.class, courseId);
                existing.setCourseId(course);
                existing.setLevel(level);
                existing.setSemester(semester);
                existing.setMincu(Integer.parseInt(minCu));
                existing.setMaxcu(Integer.parseInt(maxCu));
                sess.newEntry(existing);
                msg = "Credit unit control created successfully";
                sty = "success";
            } else {
                // Update existing
                sess.updateSemesterregistrationcucontrol(existing.getId(), Integer.parseInt(minCu), Integer.parseInt(maxCu));
                msg = "Credit unit control updated successfully";
                sty = "success";
            }
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
            sty = "danger";
        }
    }

    // Handle delete
    if ("delete".equals(action)) {
        String controlId = request.getParameter("controlId");
        try {
            Semesterregistrationcucontrol control = (Semesterregistrationcucontrol) sess.getSingleObject(Semesterregistrationcucontrol.class, controlId);
            if (control != null) {
                sess.deleteObject(control);
                msg = "Credit unit control deleted successfully";
                sty = "success";
            }
        } catch (Exception e) {
            msg = "Error deleting: " + e.getMessage();
            sty = "danger";
        }
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Credit Unit Controls Management</title>
        
        <script>
            function loadCourses() {
                const schoolId = document.getElementById('schools').value;
                const facultyId = document.getElementById('fac').value;
                
                if (schoolId && facultyId) {
                    fetch('AjaxServlet?action=loadCoursesBySchoolFaculty&schoolId=' + schoolId + '&facultyId=' + facultyId)
                        .then(response => response.text())
                        .then(data => {
                            document.getElementById('courseId').innerHTML = data;
                        })
                        .catch(error => console.error('Error:', error));
                }
            }
            
            function editControl(courseId, level, semester, minCu, maxCu) {
                document.getElementById('courseId').value = courseId;
                document.getElementById('level').value = level;
                document.getElementById('semester').value = semester;
                document.getElementById('minCu').value = minCu;
                document.getElementById('maxCu').value = maxCu;
                document.getElementById('action').value = 'save';
            }
            
            function resetForm() {
                document.getElementById('controlForm').reset();
                document.getElementById('action').value = 'save';
            }
        </script>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Credit Unit Controls Management</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <% if (!msg.isEmpty()) { %>
                    <div class="alert alert-<%=sty%> alert-dismissible fade show" role="alert">
                        <%=msg%>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <!-- Filter Section -->
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                <strong>Credit Unit Controls Management</strong>
                <div class="float-end">
                    <a href="/course_management" class="btn btn-info btn-sm me-2">Manage Courses</a>
                    <a href="/manage_sem_courses" class="btn btn-warning btn-sm">Manage Semester Courses</a>
                </div>
            </div>
                            <div class="card-body">
                                <form name="controlForm" id="controlForm" method="post" action="">
                                    <input type="hidden" name="action" id="action" value="save">
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">School</span>
                                                <select class="form-select" name="schools" id="schools" onchange="loadCourses()" required>
                                                    <option value="">Select School</option>
                                                    <%
                                                        try {
                                                            List<Schools> lsch = sess.getAllSchoos();
                                                            for (Schools prod : lsch) {
                                                                String selected = schools != null && schools.equals(prod.getId()) ? "selected" : "";
                                                    %>
                                                    <option value="<%=prod.getId()%>" <%=selected%>><%=prod.getName()%></option>
                                                    <%
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Faculty</span>
                                                <select class="form-select" name="fac" id="fac" onchange="loadCourses()" required>
                                                    <option value="">Select Faculty</option>
                                                    <%
                                                        try {
                                                            List<FacultiesDirectorates> lsch = sess.getAllFacultiesDirectorates();
                                                            for (FacultiesDirectorates prod : lsch) {
                                                                String selected = fac != null && fac.equals(prod.getId()) ? "selected" : "";
                                                    %>
                                                    <option value="<%=prod.getId()%>" <%=selected%>><%=prod.getName()%></option>
                                                    <%
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Course</span>
                                                <select class="form-select" name="courseId" id="courseId" required>
                                                    <option value="">Select Course</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Level</span>
                                                <select class="form-select" name="level" id="level" required>
                                                    <option value="">Select Level</option>
                                                    <option value="100">100</option>
                                                    <option value="200">200</option>
                                                    <option value="300">300</option>
                                                    <option value="400">400</option>
                                                    <option value="500">500</option>
                                                    <option value="600">600</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Semester</span>
                                                <select class="form-select" name="semester" id="semester" required>
                                                    <option value="">Select Semester</option>
                                                    <option value="First">First</option>
                                                    <option value="Second">Second</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Min Credit Units</span>
                                                <input type="number" class="form-control" name="minCu" id="minCu" min="0" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">Max Credit Units</span>
                                                <input type="number" class="form-control" name="maxCu" id="maxCu" min="0" required>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-6">
                                            <input type="submit" class="btn btn-success px-4" value="Save Control"/>
                                            <button type="button" class="btn btn-secondary px-4" onclick="resetForm()">Reset</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Display existing controls -->
                    <% if (schools != null && fac != null && !schools.isEmpty() && !fac.isEmpty()) { %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Existing Credit Unit Controls</strong>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Department</th>
                                                <th>Course</th>
                                                <th>Level</th>
                                                <th>Semester</th>
                                                <th>Min CU</th>
                                                <th>Max CU</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                try {
                                                    // Get all courses for the selected school and faculty
                                                    List<Courses> courses = sess.getCoursesBySchoolAndFaculty(schools, fac);
                                                    
                                                    for (Courses course : courses) {
                                                        // Get all credit unit controls for this course
                                                        List<Semesterregistrationcucontrol> controls = sess.getSemesterregistrationcucontrolByCourse(course.getId());
                                                        
                                                        for (Semesterregistrationcucontrol control : controls) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=course.getDepartmentId().getName()%></td>
                                                <td><%=course.getName()%></td>
                                                <td><%=control.getLevel()%></td>
                                                <td><%=control.getSemester()%></td>
                                                <td><%=control.getMincu()%></td>
                                                <td><%=control.getMaxcu()%></td>
                                                <td>
                                                    <button type="button" class="btn btn-primary btn-sm" 
                                                            onclick="editControl('<%=course.getId()%>', '<%=control.getLevel()%>', '<%=control.getSemester()%>', <%=control.getMincu()%>, <%=control.getMaxcu()%>)">
                                                        Edit
                                                    </button>
                                                    <a href="?action=delete&controlId=<%=control.getId()%>&schools=<%=schools%>&fac=<%=fac%>" 
                                                       class="btn btn-danger btn-sm" 
                                                       onclick="return confirm('Are you sure you want to delete this control?')">
                                                        Delete
                                                    </a>
                                                </td>
                                            </tr>
                                            <%
                                                            i++;
                                                        }
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
                    <% } %>

                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

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