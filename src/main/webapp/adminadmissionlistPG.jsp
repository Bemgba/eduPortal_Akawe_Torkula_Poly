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
    Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S003", "APPLICATION");
%>

<%
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        Courses cos = sess.getCourses(id);
        if (cos != null && sessmanx != null) {
            session.setAttribute("cos", cos.getId());
            session.setAttribute("sessions", sessmanx.getName());

            response.sendRedirect("/adminssionPG_view");
        }
    }
%>

<%
    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        if (id2.equalsIgnoreCase("ALL") && sessmanx != null) {
            session.setAttribute("cos", "ALL");
            session.setAttribute("sessions", sessmanx.getName());

            response.sendRedirect("/adminssionPG_view");
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - PG Admissions</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">PG Admissions</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>This page allows you to process admission for only Postgraduate applicants.</p>
                                        <p>You can add one by one or upload an excel file one course at a time</p>
                                        <p>You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format</p>
                                        <p>Always remember to confirm your upload report that it is what you intend to upload and in the desired course before leaving</p>

                                        <%                                            if (sessmanx != null) {
                                        %>
                                        <p>Admission will be processed against the <strong><%=sessmanx.getName()%></strong> academic session. Note that only current session for application can be treated.</p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">
                                <%
                                    String jambno = request.getParameter("jambno");
                                    String courses = request.getParameter("courses");
                                    String button2 = request.getParameter("button2");
                                    if (jambno != null && jambno.trim().length() > 0 && button2 != null) {
                                        try {
                                            jambno = jambno.trim().toLowerCase();
                                            Applicants app = sess.getApplicantsById(jambno);
                                            if (app != null) {
                                                if (app.getSession().equalsIgnoreCase(sessmanx.getName())) {
                                                    Courses cos = sess.getCourses(courses);
                                                    if (cos != null) {
                                                        Admissions adm = new Admissions(jambno);
                                                        adm.setAdmissionStatus("PENDING");
                                                        adm.setAdmissionStatusComment("");
                                                        adm.setDateAdded(settings.getCurrentDateTime());
                                                        adm.setCourseId(cos);
                                                        adm.setDateOfBirth(app.getDateOfBirth());
                                                        adm.setGender(app.getGender());
                                                        adm.setLgaId(app.getLga());
                                                        adm.setMaritalStatus(app.getMaritalStatus());
                                                        adm.setMeritType(app.getMaritalStatus());
                                                        adm.setModeOfEntry("POST GRADUATE");
                                                        adm.setNationalityId(app.getCountry());
                                                        adm.setOthernames(app.getOthernames());
                                                        adm.setProgrammeId(app.getProgrammeId());
                                                        adm.setRegistrationNo(app.getId());
                                                        adm.setReligion("");
                                                        adm.setSchoolId(app.getSchoolId());
                                                        adm.setSession(sessmanx.getName());
                                                        adm.setStateOfOriginId(app.getStateOfOrigin());
                                                        adm.setSurname(app.getSurname());
                                                        sess.addUpdateAdmission(adm);

                                                        sess.changeApplicantStatus(jambno, "ADMITTED");
                                                        sess.generateAdmissionLetterPG(jambno, "s202410818");
                                %>
                                <div class="alert alert-success">Applicant has been admitted successfully</div>
                                <%
                                    }

                                } else {
                                %>
                                <div class="alert alert-danger">Error admitting applicants: Applicant not in current session</div>
                                <%
                                    }

                                } else {
                                %>
                                <div class="alert alert-danger">Error admitting applicants: Applicant's details not found</div>
                                <%
                                            }
                                        } catch (Exception k) {
                                        }
                                    }

                                %>

                                <a href="/DownloadadmissionlistPG?id=<%=settings.encodeUrl(settings.encryptText(sessmanx.getName()))%>" class="btn btn-warning btn-sm float-end">Download Full List</a>    
                                <a href="/adminssionPG_list?id2=<%=settings.encodeUrl(settings.encryptText("ALL"))%>" class="btn btn-primary btn-sm float-end">View Full List</a>    


                                <button type="button" class="btn btn-success btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                    Add to Admission
                                </button>

                                <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Add applicant to admission list</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action='' method='post' name="verify2">
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            PG Application Number
                                                        </span>
                                                        <input type="text" name="jambno" id="jambno" class="form-control" required=""/>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Full Name
                                                        </span>
                                                        <input type="text" name="fullname" id="fullname" class="form-control" readonly="" />
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Course Applied
                                                        </span>
                                                        <input type="text" name="courseapplied" id="courseapplied" class="form-control" readonly=""/>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Course Admitted into
                                                        </span>
                                                        <select class="form-select" name="courses" id="courses">
                                                            <option value="">Select One</option>
                                                            <%
                                                                List<Courses> coursesl = sess.getCoursesBySchoolAndProgramme("S002", "1002");
                                                                coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1004"));
                                                                coursesl.addAll(sess.getCoursesBySchoolAndProgramme("S002", "1005"));
                                                                for (Courses course : coursesl) {
                                                            %>
                                                            <option value="<%=course.getId()%>"><%=course.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </div>



                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button2" class="btn btn-success px-4" value="Add to Admission"/>
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

                                <button type="button" class="btn btn-secondary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#uploadadm">
                                    Upload admission list
                                </button>

                                <div class="modal fade" id="uploadadm" tabindex="-1" aria-labelledby="uploadsLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="uploadsLabel">Upload admission list per course</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action='UploadPGAdmissionlist' method='post' name="verify4" enctype="multipart/form-data">

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select Course Admitted into
                                                        </span>
                                                        <select class="form-select" name="courses" id="courses">
                                                            <option value="">Select One</option>
                                                            <%
                                                                for (Courses course : coursesl) {
                                                            %>
                                                            <option value="<%=course.getId()%>"><%=course.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Select admission file (<a href="templates/admissionlist_pg.xls" target="_blank">Download template</a>)
                                                        </span>
                                                        <input type="file" name="uploadfile" id="uploadfile" class="form-control" accept=".xls" required=""/>
                                                    </div>



                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button3" class="btn btn-success px-4" value="Upload Admission"/>
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

                    <%
                        if (sessmanx != null) {


                    %>
                    <div class="col-12">
                        <div class="card mb-4">


                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Course</th>
                                                <th>Total Applicants</th>
                                                <th>Total Admitted</th>
                                                <th>Admission Quota</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                    int i = 1;
                                                for (Courses data : coursesl) {
                                                    long app = 0;
                                                    long adm = 0;
                                                    int quota = 0;
                                                    try {
                                                        Admissiontemplate admc = sess.getAdmissiontemplate(data.getId(), sessmanx.getName());
                                                        if (admc != null) {
                                                            quota = admc.getTotalMerit();
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                    try {
                                                        app = sess.getCountApplicantsByCourseStatus(data.getId(), sessmanx.getName(), "ALL", "POST GRADUATE");
                                                    } catch (Exception e) {
                                                    }

                                                    try {
                                                        adm = sess.getCountAdmissionsByCourseStatus(data.getId(), sessmanx.getName(), "ALL", "ALL");
                                                    } catch (Exception e) {
                                                    }

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getName()%></td>

                                                <td><%=app%></td>
                                                <td><%=adm%></td>
                                                <td><%=quota%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/adminssionPG_list?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>">View</a></td>
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


                    <%
                        }
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