<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Comparator"%>
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
        <title><%=settings.productName%> - Update Student's Progression</title>
    </head>


    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Update Student's Progression</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View Instructions</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>This page allows you to add a new session to a student's progression. It can be used to manage defered sessions and semesters as well as add omitted progressions.</p>
                                        <p>You can also remove or de-register a student at a particular session/semester. Kindly note that only this operation is only applicable to non registered sessions/semesters</p>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">
                                <%                                        String id = request.getParameter("id");
                                    System.out.println("aaaaaaaaaa " + id);
                                    if (id != null && id.length() > 0) {
                                        System.out.println("ddddddddddd " + id);
                                        id = settings.decryptText(id);
                                        System.out.println("aaaaaaaaaa " + id);
                                        Studentprogression spt = (Studentprogression) sess.getSingleObject(Studentprogression.class, id);
                                        System.out.println("fffffffffffffffffff " + id);
                                        if (spt != null) {
                                            sess.deleteStudentprogression(id);
                                %>
                                <div class="alert alert-danger">Record for session <%=spt.getSessionAdded()%> <%=spt.getSemesterAdded()%> semester has been removed</div>
                                <%
                                        }
                                    }
                                %>

                                <%    String studentno = request.getParameter("studentno");
                                    String submit = request.getParameter("submit");
                                    Students stdx = null;
                                    if (submit != null && studentno != null && studentno.length() > 0) {
                                        studentno = studentno.trim();
                                        studentno = studentno.toLowerCase();
                                        stdx = sess.getStudentsById(studentno);
                                        if (stdx == null) {
                                            session.setAttribute("stdx", null);
                                %>
                                <div class="alert alert-danger">Student number <%=studentno%> is not found!</div>
                                <%
                                        } else {
                                            session.setAttribute("stdx", stdx);
                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Enter Student's Number</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="studentno" type="text" name="studentno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View Details</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        try {
                            stdx = (Students) session.getAttribute("stdx");
                        } catch (Exception fs) {
                        }
                        if (stdx != null) {

                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <%                                    String sessions = request.getParameter("sessions");
                                    String semester = request.getParameter("semester");
                                    String level = request.getParameter("level");
                                    String button2 = request.getParameter("button2");
                                    if (button2 != null && sessions != null && sessions.length() > 0 && semester != null && semester.length() > 0 && level != null && level.length() > 0) {
                                        Studentprogression spx = sess.getStudentprogressionByStdSessSem(stdx.getId(), sessions, semester);
                                        if (spx != null) {
                                %>
                                <div class="alert alert-danger">This session <%=sessions%> and semester <%=semester%> already exist</div>
                                <%
                                } else {
                                    String idd = stdx.getId() + settings.generateId(sessions.split("/")[0], 7);
                                    spx = new Studentprogression(idd);
                                    spx.setCourseId(stdx.getCourseId());
                                    spx.setDateAdded(settings.getCurrentDateTime());
                                    spx.setLevelAdded(level);
                                    spx.setRegistrationStatus("0");
                                    spx.setSemesterAdded(semester);
                                    spx.setSessionAdded(sessions);
                                    spx.setStudentsId(stdx);
                                    sess.newStudentprogression(spx);
                                    stdx = sess.getStudentsById(spx.getStudentsId().getId());
                                %>
                                <div class="alert alert-success">Record for session <%=spx.getSessionAdded()%> <%=spx.getSemesterAdded()%> semester has been added</div>

                                <%
                                        }
                                    }
                                %>
                                <button type="button" class="btn btn-success btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#newapp">
                                    Add New Record
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="newapp" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">New Session Progression</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">

                                                <form name="edit" method="post" action="">
                                                    <div class="input-group mb-3"><span class="input-group-text">
                                                            Select Session   
                                                        </span>
                                                        <select class="form-select" name="sessions" id="sessions">
                                                            <option value="">Select Session</option>
                                                            <%                                                            Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation(stdx.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
                                                                String sessx = sm.getName();
                                                                while (sessx.compareToIgnoreCase(stdx.getSessionAdmitted()) > 0) {
                                                            %>
                                                            <option value="<%=sessx%>"><%=sessx%></option>
                                                            <%
                                                                    sessx = settings.getSessionBefore(sessx);
                                                                }

                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Semester 
                                                        </span>
                                                        <select class="form-select" name="semester" id="semester">
                                                            <option value="">Select Semester</option>
                                                            <option value="First">First</option>
                                                            <option value="Second">Second</option>
                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Level 
                                                        </span>
                                                        <select class="form-select" name="level" id="level">
                                                            <option value="">Select Level</option>
                                                            <%                                                                int minl = stdx.getCourseId().getDefaultMinLevel();
                                                                int maxl = stdx.getCourseId().getDefaultMaxLevel();
                                                                for (int lev = minl; lev <= maxl; lev += 100) {
                                                            %>
                                                            <option value="<%=lev%>"><%=lev%></option>
                                                            <%
                                                                }

                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button2" class="btn btn-success px-4" value="Add Record"/>
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
                            <div class="card-body">
                                <table class="table table-striped table-hover"
                                       <tbody>
                                        <tr>
                                            <th>
                                                Matric Number
                                            </th>
                                            <td>
                                                <%                                                    String regn = stdx.getMatricNo() != null ? stdx.getMatricNo() : stdx.getRegistrationNo();
                                                    regn = regn.toUpperCase();
                                                %>
                                                <%=regn%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                Full Name
                                            </th>
                                            <td>
                                                <%=stdx.getSurname() + " " + stdx.getOthernames()%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                Course of Study
                                            </th>
                                            <td>
                                                <%=stdx.getCourseId().getName()%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                Session Admitted
                                            </th>
                                            <td>
                                                <%=stdx.getSessionAdmitted()%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                Current Level
                                            </th>
                                            <td>
                                                <%=stdx.getCurrentClass()%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                Mode of Entry
                                            </th>
                                            <td>
                                                <%=stdx.getModeOfEntry()%>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <%
                            Collection<Studentprogression> prograssion = stdx.getStudentprogressionCollection();
                        %>
                        <div class="card mb-4">
                            <div class="card-header"><strong>Student progression history</div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th class="center">SNO</th>
                                                <th>Session</th>
                                                <th>Semester</th>
                                                <th>Level</th>
                                                <th>Course</th>
                                                <th>Registration Status</th>
                                                <th>Date Registered</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                int sn = 1;
                                                try {
                                                    List<Studentprogression> prograssionSorted = prograssion.stream()
                                                            .sorted(Comparator.comparing(Studentprogression::getSessionAdded)
                                                                    .reversed())
                                                            .collect(Collectors.toList());

                                                    for (Studentprogression progress : prograssionSorted) {
                                            %>
                                            <tr>
                                                <td class="center"><%=sn%></td>
                                                <td><%=progress.getSessionAdded()%></td>
                                                <td><%=progress.getSemesterAdded()%></td>
                                                <td><%=progress.getLevelAdded()%></td>
                                                <td><%=progress.getCourseId().getName()%></td>
                                                <td><%=settings.getRegistrationStatusLabel(progress.getRegistrationStatus())%></td>
                                                <td><%=settings.formatDate(progress.getDateRegistered())%></td>
                                                <td>
                                                    <%
                                                        if (progress.getRegistrationStatus().equalsIgnoreCase("0")) {
                                                    %>
                                                    <a class="btn btn-danger btn-sm" href="/update_progression?id=<%=settings.encodeUrl(settings.encryptText(progress.getId()))%>">Remove</a>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <%
                                                        sn++;
                                                    }
                                                } catch (Exception ka) {

                                                }

                                            %>
                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%                        }
                    %>


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