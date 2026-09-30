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
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Admission Templates</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <%                        String sessionx = "None";
                        Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
                        if (sessmanx != null) {
                            sessionx = sessmanx.getName();
                        }

                        String course = request.getParameter("course");
                    %>
                    <h2 class="title">Download Admission Template for <%=sessionx%></h2>
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
                                        <p>This page allows you to export the UTME applicants list directly from the JAMB CAPS platform into the University portal.</p>
                                        <p>You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format</p>
                                        <p>Verify that the file complies with the original format as can be seen from this template <a href="templates/applicants_list_utme.xls">Download now</a></p>
                                        <p>Also remember to verify with the report that is generated after the file upload for entries that are successful and those that are not</p>
                                        <%
                                            if (sessmanx != null) {
                                        %>
                                        <p>Applicants will be uploaded against the <strong><%=sessionx%></strong> academic session. Note that only current session for application can be treated.</p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">

                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Course</label>
                                                    <div class="col-sm-5">
                                                        <select name="course" id="course" class="form-select">
                                                            <%
                                                                try {
                                                            %>
                                                            <option value="" selected="">Select One</option>
                                                            <%
                                                                List<Courses> list = sess.getCoursesBySchool("S001");
                                                                List<Courses> list2 = sess.getCoursesBySchool("S003");
                                                                list.addAll(list2);
                                                                for (Courses listd : list) {
                                                            %>
                                                            <option value="<%=listd.getId()%>"><%=listd.getName()%></option>     
                                                            <%
                                                                    }
                                                                } catch (Exception k) {
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-5">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View</button>  
                                                        <a href="/DownloadUTMEList?id=<%=settings.encodeUrl(settings.encryptText(sessionx))%>" target="_blank" class="btn btn-success mb-3">Download Full UTME List</a>
                                                        <a href="/admin_utme_list?id4=<%=settings.encodeUrl(settings.encryptText(sessionx))%>" target="_blank" class="btn btn-secondary mb-3">View Full UTME List</a>
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (sessmanx != null) {
                            List<Applicants> appl = sess.getApplicantsByCourseStatus(course, sessmanx.getName(), "PAID", "UTME");
                            List<Applicants> appl2 = sess.getApplicantsByCourseStatus(course, sessmanx.getName(), "REGISTERED", "UTME");
                            appl.addAll(appl2);

                            if (appl.size() == 0) {
                    %>
                    <div class='alert alert-warning'>No applicant found for <strong><%=sessmanx.getName()%></strong> application session</div>
                    <%
                    } else {

                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <%    Admissiontemplate admc = sess.getAdmissiontemplate(course, sessmanx.getName());
                                if (admc != null) {
                                    String tid = settings.encodeUrl(settings.encryptText(admc.getId()));
                            %>
                            <div class="card-header"><strong><%=appl.size()%></strong> records found                                   
                                <a class="btn btn-warning btn-sm float-end" href="DownloadAdmissionTemplate?idx=<%=tid%>">Download</a>
                                <div class="alert alert-info">
                                    <strong>Admission Criteria</strong>
                                    <%

                                        List<Admissiontemplateolevel> admtl = sess.getAdmissiontemplateolevel(admc.getId());
                                        List<Admissiontemplateutme> admtlU = sess.getAdmissiontemplateutme(admc.getId());

                                        List<Admissiontemplateolevel> listoc = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C"))
                                                .collect(Collectors.toList());
                                        List<Admissiontemplateolevel> listoo = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O"))
                                                .collect(Collectors.toList());

                                        List<Admissiontemplateutme> listocU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("C"))
                                                .collect(Collectors.toList());
                                        List<Admissiontemplateutme> listooU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("O"))
                                                .collect(Collectors.toList());

                                    %>
                                    <ol>
                                        <li>
                                            <strong>UTME: </strong> 
                                            <%                                                    for (Admissiontemplateutme ut : listocU) {
                                            %>
                                            <%=ut.getUtmesubjects().getName()%>, 
                                            <%
                                                }
                                            %>
                                            and any <%=admc.getOtherUtme()%> of 
                                            <%
                                                for (Admissiontemplateutme ut : listooU) {
                                            %>
                                            <%=ut.getUtmesubjects().getName()%>, 
                                            <%
                                                }
                                            %>
                                        </li>
                                        <li>
                                            <strong>O-Level: </strong> 
                                            <%
                                                for (Admissiontemplateolevel ut : listoc) {
                                            %>
                                            <%=ut.getOlevelSubject().getName()%>, 
                                            <%
                                                }
                                            %>
                                            and any <%=admc.getOtherSubjects()%> of 
                                            <%
                                                for (Admissiontemplateolevel ut : listoo) {
                                            %>
                                            <%=ut.getOlevelSubject().getName()%>, 
                                            <%
                                                }
                                            %>
                                        </li>
                                    </ol>


                                </div>
                            </div>

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>UTME No</th>
                                                <th>Full Name</th>
                                                <th>UTME</th>
                                                <th>OL Score</th>
                                                <th class="center">More</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Applicants app : appl) {
                                                    int agg = 0;
                                                    try {
                                                        Applicantsutme utme = sess.getApplicantsutme(app.getId());
                                                        if (utme != null) {
                                                            agg = utme.getTotalUtme();
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                    List<String> lapp = sess.getOlevelsForAdmission(app, admtl);
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=app.getId().toUpperCase()%></td>
                                                <td><%=app.getSurname() + " " + app.getOthernames()%></td>
                                                <td><%=app.getApplicantsutme().getTotalUtme()%></td>
                                                <%
                                                    int sc = 0;
                                                    try {
                                                        AdmTempOLDet ol = sess.getAdmTempOLDet(admc, app);
                                                        sc = ol.getTotaPoints();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=sc%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/app_adm_download_template?id=<%=settings.encodeUrl(settings.encryptText(app.getId()))%>">View</a></td>
                                            </tr>
                                            <%
                                                    i++;
                                                }
                                            %>


                                        </tbody>
                                    </table>
                                </div>

                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>


                    <%
                            }
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