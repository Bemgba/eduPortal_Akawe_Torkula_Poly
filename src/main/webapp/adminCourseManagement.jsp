<%-- 
    Document   : adminCourseManagement
    Created on : Jan 7, 2025
    Author     : BEMGBA
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
    String courseId = request.getParameter("courseId");
    String courseName = request.getParameter("courseName");
    String courseCode = request.getParameter("courseCode");
    String schoolProgrammeId = request.getParameter("schoolProgrammeId");
    String departmentId = request.getParameter("departmentId");
    String headId = request.getParameter("headId");
    String headTitle = request.getParameter("headTitle");
    String defaultMinLevel = request.getParameter("defaultMinLevel");
    String defaultMaxLevel = request.getParameter("defaultMaxLevel");
    String defaultMaxSpill = request.getParameter("defaultMaxSpill");
    String defaultDuration = request.getParameter("defaultDuration");
    String entryRequirements = request.getParameter("entryRequirements");
    String action = request.getParameter("action");
    String msg = "";
    String sty = "danger";

    // Handle create/update course
    if ("save".equals(action) && courseName != null && courseCode != null && schoolProgrammeId != null) {
        if (departmentId == null || departmentId.isEmpty()) {
            msg = "Department is required. Please select a department.";
            sty = "danger";
        } else {
        try {
            if (courseId != null && !courseId.isEmpty()) {
                // Update existing course using direct JPQL update (avoids loading the full entity graph)
                Integer minLevel = (defaultMinLevel != null && !defaultMinLevel.isEmpty()) ? Integer.parseInt(defaultMinLevel) : null;
                Integer maxLevel = (defaultMaxLevel != null && !defaultMaxLevel.isEmpty()) ? Integer.parseInt(defaultMaxLevel) : null;
                Integer maxSpill = (defaultMaxSpill != null && !defaultMaxSpill.isEmpty()) ? Integer.parseInt(defaultMaxSpill) : null;
                Integer duration = (defaultDuration != null && !defaultDuration.isEmpty()) ? Integer.parseInt(defaultDuration) : null;
                String hId = (headId != null && !headId.isEmpty()) ? headId : null;
                String hTitle = (headTitle != null && !headTitle.isEmpty()) ? headTitle : null;
                
                sess.updateCourse(courseId, courseName, courseCode, schoolProgrammeId, departmentId,
                        hId, hTitle, minLevel, maxLevel, maxSpill, duration, entryRequirements);
                msg = "Course updated successfully";
                sty = "success";
            } else {
                // Create new course
                String newId = settings.generateId("CRS", 6);
                Courses course = new Courses(newId);
                course.setName(courseName);
                course.setCode(courseCode);
                
                // Set school programme
                Schoolprogrammes sp = (Schoolprogrammes) sess.getSingleObject(Schoolprogrammes.class, schoolProgrammeId);
                course.setSchoolProgrammeId(sp);
                
                // Set department (required)
                Departments dept = (Departments) sess.getSingleObject(Departments.class, departmentId);
                course.setDepartmentId(dept);
                
                // Set head of department
                if (headId != null && !headId.isEmpty()) {
                    Users head = (Users) sess.getSingleObject(Users.class, headId);
                    course.setHeadId(head);
                }
                
                // Set head title
                if (headTitle != null && !headTitle.isEmpty()) {
                    Positions position = (Positions) sess.getSingleObject(Positions.class, headTitle);
                    course.setHeadTitle(position);
                }
                
                // Set numeric fields
                if (defaultMinLevel != null && !defaultMinLevel.isEmpty()) {
                    course.setDefaultMinLevel(Integer.parseInt(defaultMinLevel));
                }
                if (defaultMaxLevel != null && !defaultMaxLevel.isEmpty()) {
                    course.setDefaultMaxLevel(Integer.parseInt(defaultMaxLevel));
                }
                if (defaultMaxSpill != null && !defaultMaxSpill.isEmpty()) {
                    course.setDefaultMaxSpill(Integer.parseInt(defaultMaxSpill));
                }
                if (defaultDuration != null && !defaultDuration.isEmpty()) {
                    course.setDefaultDuration(Integer.parseInt(defaultDuration));
                }
                
                course.setEntryRequirements(entryRequirements);
                sess.newEntry(course);
                msg = "Course created successfully";
                sty = "success";
            }
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
            sty = "danger";
            e.printStackTrace();
        }
        } // Close the department validation block
    }

    // Handle delete
    if ("delete".equals(action) && courseId != null) {
        try {
            Courses course = (Courses) sess.getSingleObject(Courses.class, courseId);
            if (course != null) {
                sess.deleteObject(course);
                msg = "Course deleted successfully";
                sty = "success";
            }
        } catch (Exception e) {
            msg = "Error deleting course: " + e.getMessage();
            sty = "danger";
        }
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Course Management</title>
        
        <script>
            function editCourse(courseId, courseName, courseCode, schoolProgrammeId, departmentId, headId, headTitle, 
                              defaultMinLevel, defaultMaxLevel, defaultMaxSpill, defaultDuration, entryRequirements) {
                document.getElementById('courseId').value = courseId || '';
                document.getElementById('courseName').value = courseName || '';
                document.getElementById('courseCode').value = courseCode || '';
                document.getElementById('schoolProgrammeId').value = schoolProgrammeId || '';
                document.getElementById('departmentId').value = departmentId || '';
                document.getElementById('headId').value = headId || '';
                document.getElementById('headTitle').value = headTitle || '';
                document.getElementById('defaultMinLevel').value = defaultMinLevel || '';
                document.getElementById('defaultMaxLevel').value = defaultMaxLevel || '';
                document.getElementById('defaultMaxSpill').value = defaultMaxSpill || '';
                document.getElementById('defaultDuration').value = defaultDuration || '';
                document.getElementById('entryRequirements').value = entryRequirements || '';
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
            
            function loadDepartments() {
                const schoolProgrammeId = document.getElementById('schoolProgrammeId').value;
                
                if (schoolProgrammeId) {
                    fetch('AjaxServlet?action=loadDepartmentsBySchoolProgramme&schoolProgrammeId=' + schoolProgrammeId)
                        .then(response => response.text())
                        .then(data => {
                            document.getElementById('departmentId').innerHTML = '<option value="">Select Department</option>' + data;
                        })
                        .catch(error => console.error('Error:', error));
                }
            }
            
            function confirmDelete(courseId, courseName) {
                if (confirm('Are you sure you want to delete the course "' + courseName + '"? This action cannot be undone.')) {
                    window.location.href = '?action=delete&courseId=' + courseId;
                }
                return false;
            }
            
            // Event listeners for edit and delete buttons
            document.addEventListener('DOMContentLoaded', function() {
                // Edit button event listeners
                document.querySelectorAll('.edit-course-btn').forEach(function(button) {
                    button.addEventListener('click', function() {
                        const courseId = this.getAttribute('data-course-id');
                        const courseName = this.getAttribute('data-course-name');
                        const courseCode = this.getAttribute('data-course-code');
                        const schoolProgrammeId = this.getAttribute('data-school-programme-id');
                        const departmentId = this.getAttribute('data-department-id');
                        const headId = this.getAttribute('data-head-id');
                        const headTitle = this.getAttribute('data-head-title');
                        const defaultMinLevel = this.getAttribute('data-default-min-level');
                        const defaultMaxLevel = this.getAttribute('data-default-max-level');
                        const defaultMaxSpill = this.getAttribute('data-default-max-spill');
                        const defaultDuration = this.getAttribute('data-default-duration');
                        const entryRequirements = this.getAttribute('data-entry-requirements');
                        
                        editCourse(courseId, courseName, courseCode, schoolProgrammeId, departmentId, headId, headTitle,
                                 defaultMinLevel, defaultMaxLevel, defaultMaxSpill, defaultDuration, entryRequirements);
                    });
                });
                
                // Delete button event listeners
                document.querySelectorAll('.delete-course-btn').forEach(function(button) {
                    button.addEventListener('click', function() {
                        const courseId = this.getAttribute('data-course-id');
                        const courseName = this.getAttribute('data-course-name');
                        confirmDelete(courseId, courseName);
                    });
                });
            });
        </script>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Course Management</h2>
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

                    <!-- Course List -->
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Course Management</strong>
                                <div class="float-end">
                                    <button type="button" class="btn btn-success btn-sm" data-coreui-toggle="modal" data-coreui-target="#courseModal" onclick="resetForm()">
                                        Add New Course
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Programme Code</th>
                                                <th>Programme Name</th>
                                                <th>Programme Type</th>
                                                <th>Department</th>
                                                <th>Duration (Semester)</th>
                                                <th>Level Range</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                try {
                                                    List<Courses> courses = sess.getAllCourses();
                                                    
                                                    for (Courses course : courses) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=course.getCode() != null ? course.getCode() : ""%></td>
                                                <td><%=course.getName()%></td>
                                                <td><%=course.getSchoolProgrammeId() != null ? course.getSchoolProgrammeId().getSchoolId().getName() + " - " + course.getSchoolProgrammeId().getProgrammeId().getName() : ""%></td>
                                                <td><%=course.getDepartmentId() != null ? course.getDepartmentId().getName() : "Not Set"%></td>
                                                <td><%=course.getDefaultDuration() != null ? course.getDefaultDuration() : "Not Set"%></td>
                                                <td><%=(course.getDefaultMinLevel() != null ? course.getDefaultMinLevel() : "?") + " - " + (course.getDefaultMaxLevel() != null ? course.getDefaultMaxLevel() : "?")%></td>
                                                <td>
                                                    <button type="button" class="btn btn-primary btn-sm edit-course-btn" 
                                                            data-course-id="<%=course.getId()%>"
                                                            data-course-name="<%=course.getName()%>"
                                                            data-course-code="<%=course.getCode() != null ? course.getCode() : ""%>"
                                                            data-school-programme-id="<%=course.getSchoolProgrammeId() != null ? course.getSchoolProgrammeId().getId() : ""%>"
                                                            data-department-id="<%=course.getDepartmentId() != null ? course.getDepartmentId().getId() : ""%>"
                                                            data-head-id="<%=course.getHeadId() != null ? course.getHeadId().getId() : ""%>"
                                                            data-head-title="<%=course.getHeadTitle() != null ? course.getHeadTitle().getId() : ""%>"
                                                            data-default-min-level="<%=course.getDefaultMinLevel() != null ? course.getDefaultMinLevel() : ""%>"
                                                            data-default-max-level="<%=course.getDefaultMaxLevel() != null ? course.getDefaultMaxLevel() : ""%>"
                                                            data-default-max-spill="<%=course.getDefaultMaxSpill() != null ? course.getDefaultMaxSpill() : ""%>"
                                                            data-default-duration="<%=course.getDefaultDuration() != null ? course.getDefaultDuration() : ""%>"
                                                            data-entry-requirements="<%=course.getEntryRequirements() != null ? course.getEntryRequirements().replace("\"", "&quot;") : ""%>">
                                                        Edit
                                                    </button>
                                                    <button type="button" class="btn btn-danger btn-sm delete-course-btn" 
                                                            data-course-id="<%=course.getId()%>"
                                                            data-course-name="<%=course.getName()%>">
                                                        Delete
                                                    </button>
                                                </td>
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

                    <!-- Course Modal -->
                    <div class="modal fade" id="courseModal" tabindex="-1" aria-labelledby="courseModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="courseModalLabel">Course Management</h5>
                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="alert alert-info">
                                        <small><strong>Note:</strong> Fields marked with * are required.</small>
                                    </div>
                                    <form name="courseForm" id="courseForm" method="post" action="">
                                        <input type="hidden" name="action" id="action" value="save">
                                        <input type="hidden" name="courseId" id="courseId">
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Course Code *</span>
                                                    <input type="text" class="form-control" name="courseCode" id="courseCode" required>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Course Name *</span>
                                                    <input type="text" class="form-control" name="courseName" id="courseName" required>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">School/Programme *</span>
                                                    <select class="form-select" name="schoolProgrammeId" id="schoolProgrammeId" onchange="loadDepartments()" required>
                                                        <option value="">Select School/Programme</option>
                                                        <%
                                                            try {
                                                                List<Schoolprogrammes> schoolProgrammes = sess.getAllSchoolprogrammes();
                                                                for (Schoolprogrammes sp : schoolProgrammes) {
                                                        %>
                                                        <option value="<%=sp.getId()%>"><%=sp.getSchoolId().getName()%> - <%=sp.getProgrammeId().getName()%></option>
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
                                                    <span class="input-group-text">Department *</span>
                                                    <select class="form-select" name="departmentId" id="departmentId" required>
                                                        <option value="">Select Department</option>
                                                        <%
                                                            try {
                                                                List<Departments> departments = sess.getAllDepartments();
                                                                System.out.println("DEBUG: Found " + departments.size() + " departments");
                                                                for (Departments dept : departments) {
                                                                    System.out.println("DEBUG: Department - " + dept.getId() + ": " + dept.getName());
                                                        %>
                                                        <option value="<%=dept.getId()%>"><%=dept.getName()%></option>
                                                        <%
                                                                }
                                                            } catch (Exception k) {
                                                                System.out.println("DEBUG: Error loading departments: " + k.getMessage());
                                                                k.printStackTrace();
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Head of Department</span>
                                                    <select class="form-select" name="headId" id="headId">
                                                        <option value="">Select Head</option>
                                                        <%
                                                            try {
                                                                List<Users> users = sess.getAllStaff();
                                                                for (Users u : users) {
                                                        %>
                                                        <option value="<%=u.getId()%>"><%=u.getUsername() != null ? u.getUsername() : ""%> <%=u.getUsername() != null ? u.getUsername() : ""%></option>
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
                                                    <span class="input-group-text">Head Title</span>
                                                    <select class="form-select" name="headTitle" id="headTitle">
                                                        <option value="">Select Title</option>
                                                        <%
                                                            try {
                                                                List<Positions> positions = sess.getAllPositions();
                                                                for (Positions pos : positions) {
                                                        %>
                                                        <option value="<%=pos.getId()%>"><%=pos.getName()%></option>
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
                                            <div class="col-md-3">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Min Level</span>
                                                    <input type="number" class="form-control" name="defaultMinLevel" id="defaultMinLevel" min="100" max="900">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Max Level</span>
                                                    <input type="number" class="form-control" name="defaultMaxLevel" id="defaultMaxLevel" min="100" max="900">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Max Spill</span>
                                                    <input type="number" class="form-control" name="defaultMaxSpill" id="defaultMaxSpill" min="0">
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Duration (Semesters)</span>
                                                    <input type="number" class="form-control" name="defaultDuration" id="defaultDuration" min="1" max="10">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="input-group mb-3">
                                                    <span class="input-group-text">Entry Requirements</span>
                                                    <textarea class="form-control" name="entryRequirements" id="entryRequirements" rows="4"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-6">
                                                <input type="submit" class="btn btn-success px-4" value="Save Course"/>
                                                <button type="button" class="btn btn-secondary px-4" onclick="resetForm()">Reset</button>
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
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

        <!-- DataTables and jQuery -->
        <script src="vendors/jquery/js/jquery.min.js"></script>
        <script src="vendors/datatables.net/js/dataTables.min.js"></script>
        <script src="vendors/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
        <script src="js/dataTables.buttons.js"></script>
        <script src="js/buttons.dataTables.js"></script>
        <script src="js/jszip.min.js"></script>
        <script src="js/pdfmake.min.js"></script>
        <script src="js/vfs_fonts.js"></script>
        <script src="js/buttons.html5.min.js"></script>
        <script src="js/buttons.print.min.js"></script>

        <script>
            $(document).ready(function () {
                $('#dataTable').DataTable({
                    responsive: true,
                    "info": true,
                    "pageLength": 25,
                    "lengthMenu": [25, 50, 100, 200, 500],
                    "dom": 'Bfrtip',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                });
            });
        </script>
    </body>
</html>