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
    Programmes prog = null;
    try {
        prog = (Programmes) session.getAttribute("prog");
    } catch (Exception k) {
    }
    if (prog == null) {
        response.sendRedirect("/manage_sem_courses");
    }
%>

<%
    // Handle form submissions for Edit/Delete
    String courseId = request.getParameter("courseId");
    String courseName = request.getParameter("courseName");
    String courseCode = request.getParameter("courseCode");
    String semester = request.getParameter("semester");
    String defaultLevel = request.getParameter("defaultLevel");
    String creditUnit = request.getParameter("creditUnit");
    String note = request.getParameter("note");
    String semestercourseCategory = request.getParameter("semestercourseCategory");
    String action = request.getParameter("action");
    String msg = "";
    String sty = "danger";

    // Handle create/update semester course
    if ("save".equals(action) && courseName != null && courseCode != null) {
        try {
            if (courseId != null && !courseId.isEmpty()) {
                // Update existing course using direct JPQL update
                Integer creditUnitVal = null;
                if (creditUnit != null && !creditUnit.isEmpty()) {
                    creditUnitVal = Integer.parseInt(creditUnit);
                }
                sess.updateSemestercourse(courseId, courseName, courseCode.toUpperCase(), semester, defaultLevel, creditUnitVal, note, semestercourseCategory);
                msg = "Semester course '" + courseName + "' has been updated successfully!";
                sty = "success";
            } else {
                // Create new course
                String newId = settings.generateId("SMC", 6);
                Semestercourses course = new Semestercourses(newId);
                course.setProgrammeId(prog);
                course.setStatus("ACTIVE");
                course.setName(courseName);
                course.setCode(courseCode.toUpperCase());
                course.setSemester(semester);
                course.setDefaultLevel(defaultLevel);
                course.setNote(note);
                course.setSemestercourseCategory(semestercourseCategory);
                if (creditUnit != null && !creditUnit.isEmpty()) {
                    course.setCreditUnit(Integer.parseInt(creditUnit));
                }
                sess.newEntry(course);
                msg = "New semester course '" + courseName + "' has been created successfully!";
                sty = "success";
            }
        } catch (Exception e) {
            // Check if the error is related to the missing summerschoolapplication table
            if (e.getMessage().contains("summerschoolapplication") || e.getMessage().contains("relation") && e.getMessage().contains("does not exist")) {
                msg = "Database configuration issue: Summer school application table is missing. Please contact system administrator.";
            } else if (e.getMessage().contains("duplicate") || e.getMessage().contains("unique")) {
                msg = "Failed to save course: A course with code '" + courseCode + "' already exists in this programme.";
            } else if (e.getMessage().contains("constraint")) {
                msg = "Failed to save course: Invalid data provided. Please check all fields.";
            } else {
                msg = "Failed to save semester course: " + e.getMessage();
            }
            sty = "danger";
          //  e.printStackTrace();
        }
    }

    // Handle delete
    if ("delete".equals(action) && courseId != null) {
        try {
            // Check if course is being used by students first (single DB call for validation)
            try {
                List<Semesterregistrationcourses> registrations = sess.getSemesterregistrationcoursesBySemestercourseid(courseId);
                if (registrations != null && !registrations.isEmpty()) {
                    // If we need the course name for the message and don't have it from request, get it
                    String courseNameForMsg = (courseName != null && !courseName.isEmpty()) ? courseName : "Course";
                    msg = "Cannot delete course '" + courseNameForMsg + "': It is currently being used by " + registrations.size() + " student(s).";
                    sty = "warning";
                } else {
                    // Use the specific delete method for Semestercourses (no need to fetch the object first)
                    sess.deleteSemestercourses(courseId);
                    String courseNameForMsg = (courseName != null && !courseName.isEmpty()) ? courseName : "Course";
                    msg = "Semester course '" + courseNameForMsg + "' has been deleted successfully!";
                    sty = "success";
                    // Redirect to same page to refresh the data
                    response.sendRedirect("/list_sem_courses");
                    return;
                }
            } catch (Exception checkEx) {
                // If we can't check usage, proceed with deletion but warn
                sess.deleteSemestercourses(courseId);
                String courseNameForMsg = (courseName != null && !courseName.isEmpty()) ? courseName : "Course";
                msg = "Semester course '" + courseNameForMsg + "' has been deleted successfully!";
                sty = "success";
                // Redirect to same page to refresh the data
                response.sendRedirect("/list_sem_courses");
                return;
            }
        } catch (Exception e) {
            if (e.getMessage().contains("constraint") || e.getMessage().contains("foreign key")) {
                msg = "Cannot delete course: It is being referenced by other records in the system.";
            } else {
                msg = "Failed to delete semester course: " + e.getMessage();
                //e.printStackTrace(); // Add this to see the actual error
            }
            sty = "danger";
        }
    }

    // Handle activate/deactivate (existing functionality)
    String id1 = request.getParameter("id");
    if (id1 != null) {
        id1 = settings.decryptText(id1);
        Semestercourses pg = (Semestercourses) sess.getSingleObject(Semestercourses.class, id1);
        if (pg != null) {
            sess.updateSemesterCourseStatus(pg.getId(), "INACTIVE");
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

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Semester Courses for <%=prog.getName()%></title>

        <script>

            async function getCoursesTakingsemco(semcourse) {
                try {
                    const url = "AjaxServlet?action=getCoursesTakingsemco&id2=" + escape(semcourse);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(semcourse + "k").innerHTML = respText;
                } catch (error) {
                    console.error("Error loading data:", error);
                    document.getElementById(semcourse + "k").innerHTML = "<p>Error loading data. Please try again later.</p>";
                }
            }

            function editCourse(courseId, courseName, courseCode, semester, defaultLevel, creditUnit, note, semestercourseCategory) {
                document.getElementById('courseId').value = courseId || '';
                document.getElementById('courseName').value = courseName || '';
                document.getElementById('courseCode').value = courseCode || '';
                document.getElementById('semester').value = semester || '';
                document.getElementById('defaultLevel').value = defaultLevel || '';
                document.getElementById('creditUnit').value = creditUnit || '';
                document.getElementById('note').value = note || '';
                document.getElementById('semestercourseCategory').value = semestercourseCategory || '';
                document.getElementById('action').value = 'save';
                
                // Show modal using CoreUI
                const modal = document.getElementById('courseModal');
                const coreUIModal = new coreui.Modal(modal);
                coreUIModal.show();
            }
            
            function resetForm() {
                document.getElementById('courseForm').reset();
                document.getElementById('courseId').value = '';
                document.getElementById('action').value = 'save';
            }
            
            function confirmDelete(courseId, courseName) {
                if (confirm('Are you sure you want to delete the semester course "' + courseName + '"? This action cannot be undone.')) {
                    // Show loading indicator
                    const deleteButtons = document.querySelectorAll('button[onclick*="confirmDelete"]');
                    deleteButtons.forEach(btn => {
                        if (btn.onclick.toString().includes(courseId)) {
                            btn.disabled = true;
                            btn.innerHTML = 'Deleting...';
                        }
                    });
                    
                    // Redirect to delete action and reload page
                    window.location.href = window.location.pathname + '?action=delete&courseId=' + courseId;
                }
                return false;
            }

        </script>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Semester Courses for <%=prog.getName()%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <%-- Display success/error messages --%>
                    <% if (msg != null && !msg.isEmpty()) { %>
                        <div class="alert alert-<%=sty%> alert-dismissible fade show" role="alert">
                            <%=msg%>
                            <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header">You can click on a course to deactivate/activate from the tabs
                                <button type="button" class="btn btn-success btn-sm float-end me-2" onclick="resetForm(); const modal = document.getElementById('courseModal'); const coreUIModal = new coreui.Modal(modal); coreUIModal.show();">Add New Course</button>
                                <a href="/manage_sem_courses" class="btn btn-danger btn-sm float-end">Back</a>
                            </div>
                            <div class="card-body">
                                <%
                                    List<Semestercourses> active = sess.getAllSemestercoursesByStatusAndProgramme("ACTIVE", prog.getId() + "");
                                    List<Semestercourses> inactive = sess.getAllSemestercoursesByStatusAndProgramme("INACTIVE", prog.getId() + "");
                                %>
                                <div class="tab-content rounded-bottom">
                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1017">
                                        <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link active" id="pills-home-tab" data-coreui-toggle="pill" data-coreui-target="#pills-home" type="button" role="tab" aria-controls="pills-home" aria-selected="true">Active Courses</button>
                                            </li>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link" id="pills-profile-tab" data-coreui-toggle="pill" data-coreui-target="#pills-profile" type="button" role="tab" aria-controls="pills-profile" aria-selected="false" tabindex="-1">Inactive Courses</button>
                                            </li>
                                        </ul>
                                        <div class="tab-content" id="pills-tabContent">
                                            <div class="tab-pane fade active show" id="pills-home" role="tabpanel" aria-labelledby="pills-home-tab">
                                                <p>This courses are registrable by students</p>
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover" id='dataTable'>
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Course Code</th>
                                                                <th>Course Name</th>
                                                                <th>Credit Unit</th>
                                                                <th>Semester</th>
                                                                <th>Level</th>
                                                                <th>Used By</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%    int m = 1;
                                                                for (Semestercourses data : active) {
                                                            %>
                                                            <tr>
                                                                <td><%=m%></td>
                                                                <td><%=data.getCode()%></td>
                                                                <td><%=data.getName()%></td>
                                                                <td><%=data.getCreditUnit()%></td>
                                                                <td><%=data.getSemester()%></td>
                                                                <td><%=data.getDefaultLevel()%></td>
                                                                <%
                                                                    int siz = 0;
                                                                    try {
                                                                        List<Semesterregistrationcourses> cos = sess.getSemesterregistrationcoursesBySemestercourseid(data.getId());
                                                                        siz = cos.size();
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                                <td>
                                                                    <a href="#" 
                                                                       data-coreui-toggle="modal" 
                                                                       data-coreui-target="#<%=data.getId()%>" 
                                                                       onclick="event.preventDefault();getCoursesTakingsemco('<%=data.getId()%>')" 
                                                                       >
                                                                        <%=siz%>
                                                                    </a>

                                                                    <div class="modal fade" id="<%=data.getId()%>" tabindex="-1" aria-labelledby="<%=data.getId()%>lab" aria-hidden="true">
                                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="<%=data.getId()%>lab">List of Courses offering <%=data.getName()%> (<%=data.getCode()%>)</h5>
                                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <div id="<%=data.getId()%>k">Loading...</div>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>  
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-primary btn-sm" 
                                                                            onclick="editCourse('<%=data.getId()%>', '<%=data.getName().replace("'", "\\'")%>', '<%=data.getCode()%>', '<%=data.getSemester() != null ? data.getSemester() : ""%>', '<%=data.getDefaultLevel() != null ? data.getDefaultLevel() : ""%>', '<%=data.getCreditUnit() != null ? data.getCreditUnit() : ""%>', '<%=data.getNote() != null ? data.getNote().replace("'", "\\'") : ""%>', '<%=data.getSemestercourseCategory() != null ? data.getSemestercourseCategory() : ""%>')">
                                                                        Edit
                                                                    </button>
                                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                                            onclick="confirmDelete('<%=data.getId()%>', '<%=data.getName().replace("'", "\\'")%>')">
                                                                        Delete
                                                                    </button>
                                                                    <a href="/list_sem_courses?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-warning btn-sm" title="Click to Deactivate">Deactivate</a>
                                                                </td>
                                                            </tr>
                                                            <%
                                                                    m++;
                                                                }
                                                            %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="tab-pane fade" id="pills-profile" role="tabpanel" aria-labelledby="pills-profile-tab">
                                                <p>These courses are not registrable by students but can be used for result processing and transcript.</p>
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover" id='dataTable2'>
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Course Code</th>
                                                                <th>Course Name</th>
                                                                <th>Credit Unit</th>
                                                                <th>Semester</th>
                                                                <th>Level</th>
                                                                <th>Used By</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%    int n = 1;
                                                                for (Semestercourses data : inactive) {
                                                            %>
                                                            <tr>
                                                                <td><%=n%></td>
                                                                <td><%=data.getCode()%></td>
                                                                <td><%=data.getName()%></td>
                                                                <td><%=data.getCreditUnit()%></td>
                                                                <td><%=data.getSemester()%></td>
                                                                <td><%=data.getDefaultLevel()%></td>
                                                                <%
                                                                    int siz = 0;
                                                                    try {
                                                                        List<Semesterregistrationcourses> cos = sess.getSemesterregistrationcoursesBySemestercourseid(data.getId());
                                                                        siz = cos.size();
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                                <td>
                                                                    <a href="#" 
                                                                       data-coreui-toggle="modal" 
                                                                       data-coreui-target="#<%=data.getId()%>inactive" 
                                                                       onclick="event.preventDefault();getCoursesTakingsemco('<%=data.getId()%>')" 
                                                                       >
                                                                        <%=siz%>
                                                                    </a>

                                                                    <div class="modal fade" id="<%=data.getId()%>inactive" tabindex="-1" aria-labelledby="<%=data.getId()%>inactivelab" aria-hidden="true">
                                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="<%=data.getId()%>inactivelab">List of Courses offering <%=data.getName()%> (<%=data.getCode()%>)</h5>
                                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <div id="<%=data.getId()%>k">Loading...</div>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-primary btn-sm" 
                                                                            onclick="editCourse('<%=data.getId()%>', '<%=data.getName().replace("'", "\\'")%>', '<%=data.getCode()%>', '<%=data.getSemester() != null ? data.getSemester() : ""%>', '<%=data.getDefaultLevel() != null ? data.getDefaultLevel() : ""%>', '<%=data.getCreditUnit() != null ? data.getCreditUnit() : ""%>', '<%=data.getNote() != null ? data.getNote().replace("'", "\\'") : ""%>', '<%=data.getSemestercourseCategory() != null ? data.getSemestercourseCategory() : ""%>')">
                                                                        Edit
                                                                    </button>
                                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                                            onclick="confirmDelete('<%=data.getId()%>', '<%=data.getName().replace("'", "\\'")%>')">
                                                                        Delete
                                                                    </button>
                                                                    <a href="/list_sem_courses?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-success btn-sm" title="Click to Activate">Activate</a>
                                                                </td>
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
                        </div>
                    </div>

                    <!-- Course Modal -->
                    <div class="modal fade" id="courseModal" tabindex="-1" aria-labelledby="courseModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content" style="max-height: 90vh;">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="courseModalLabel">Add/Edit Semester Course</h5>
                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form id="courseForm" method="post">
                                    <div class="modal-body" style="max-height: 70vh; overflow-y: auto;">
                                        <input type="hidden" id="courseId" name="courseId">
                                        <input type="hidden" id="action" name="action" value="save">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="courseCode" class="form-label">Course Code <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="courseCode" name="courseCode" required maxlength="15" style="text-transform: uppercase;">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="creditUnit" class="form-label">Credit Unit</label>
                                                    <input type="number" class="form-control" id="creditUnit" name="creditUnit" min="1" max="10">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="courseName" class="form-label">Course Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="courseName" name="courseName" required maxlength="150">
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="semester" class="form-label">Semester</label>
                                                    <select class="form-select" id="semester" name="semester">
                                                        <option value="">Select Semester</option>
                                                        <option value="1">First Semester</option>
                                                        <option value="2">Second Semester</option>
                                                        <option value="BOTH">Both Semesters</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="defaultLevel" class="form-label">Default Level</label>
                                                    <select class="form-select" id="defaultLevel" name="defaultLevel">
                                                        <option value="">Select Level</option>
                                                        <option value="100">100 Level</option>
                                                        <option value="200">200 Level</option>
                                                        <option value="300">300 Level</option>
                                                        <option value="400">400 Level</option>
                                                        <option value="500">500 Level</option>
                                                        <option value="600">600 Level</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="semestercourseCategory" class="form-label">Course Category</label>
                                            <select class="form-select" id="semestercourseCategory" name="semestercourseCategory">
                                                <option value="">Select Category</option>
                                                <option value="CORE">Core Course</option>
                                                <option value="ELECTIVE">Elective Course</option>
                                                <option value="GENERAL">General Studies</option>
                                                <option value="PRACTICAL">Practical Course</option>
                                            </select>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="note" class="form-label">Note</label>
                                            <textarea class="form-control" id="note" name="note" rows="3" maxlength="200"></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-coreui-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-primary">Save Course</button>
                                    </div>
                                </form>
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