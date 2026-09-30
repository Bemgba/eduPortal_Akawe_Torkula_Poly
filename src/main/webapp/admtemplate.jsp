<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Handle view/edit redirect BEFORE any HTML output
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        String cou = "";
        String sessd = "";
        if (id.contains(";")) {
            cou = id.split(";")[0];
            sessd = id.split(";")[1];
        }
        if (cou.length() > 0 && sessd.length() > 0) {
            Courses cod = sess.getCourses(cou);
            if (cod != null) {
                session.setAttribute("cou", cod);
                session.setAttribute("sessd", sessd);
                response.sendRedirect("adm_temp_addedit");
                return;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Admission Templates Setup</title>
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
                    %>
                    <h2 class="title">Download Admission Template for <%=sessionx%></h2>
                </div>
            </header>
            <%
                String op = request.getParameter("op");
                if (op != null && op.length() > 0) {
                    if (op.equalsIgnoreCase("GENERATE")) {
                        sess.resetAdmissionTemplate(sessionx, "S001");
                        sess.resetAdmissionTemplate(sessionx, "S003");
                    }
                }

                String id2 = request.getParameter("id2");
                if (id2 != null && id2.length() > 0) {
                    id2 = settings.decryptText(id2);
                    String cou2 = "";
                    String sessd2 = "";
                    if (id2.contains(";")) {
                        cou2 = id2.split(";")[0];
                        sessd2 = id2.split(";")[1];
                    }
                    if (cou2.length() > 0 && sessd2.length() > 0) {
                        sess.resetAdmissionTemplateByCourse(sessd2, cou2);
                    }
                }
            %>
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
                                        <p>Admission template is used to process admission for Undergraduate applicants </p>
                                        <p>You can use the 'Pull from Previous' button to initialize from the previous session template. Kindly note that this will reset app existing settings.</p>
                                        <p>Always remember to cross-check before proceeding to generate admission template list. Only applicants that have PAID and updated their records will be visible for preparation of admission template list</p>

                                    </div>
                                </div>

                            </div>
                            <div class="card-body">

                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Session</label>
                                                    <div class="col-sm-7">
                                                        <select name="sessions" id="sessions" class="form-select">
                                                            <%
                                                                try {
                                                            %>
                                                            <option value="<%=sessmanx.getName()%>" selected=""><%=sessmanx.getName()%></option>
                                                            <%
                                                                List<Sessionmanager> list = sess.getAllSessionmanager("S001", "APPLICATION", "Session");
                                                                for (Sessionmanager listd : list) {
                                                            %>
                                                            <option value="<%=listd.getName()%>"><%=listd.getName()%></option>     
                                                            <%
                                                                    }
                                                                } catch (Exception k) {
                                                                }
                                                            %>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">View</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        String sessions = request.getParameter("sessions");
                        if (sessions != null) {
                            List<Courses> listc = sess.getCoursesBySchool("S001");
                            List<Courses> l2 = sess.getCoursesBySchool("S003");
                            listc.addAll(l2);

                            if (listc.size() == 0) {
                    %>
                    <div class='alert alert-warning'>No course available</div>
                    <%
                    } else {

                    %>
                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong><%=listc.size()%></strong> courses
                                <a class="btn btn-warning btn-sm float-end" href="/app_adm_temp?op=GENERATE" title="This will reset to previous values">Pull from Previous</a>

                            </div>

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Course</th>
                                                <th>Dept. Code</th>
                                                <th>Fac. Code</th>
                                                <th>Comp. Subjs</th>
                                                <th>Other Subjs</th>
                                                <th class="center">More</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;

                                                for (Courses course : listc) {
                                                    String comp = "Not Set";
                                                    String oth = "Not Set";
                                                    String peutme = "Not Set";
                                                    String peol = "Not Set";
                                                    String peputme = "Not Set";
                                                    Admissiontemplate adml = sess.getAdmissiontemplate(course.getId(), sessions);
                                                    if (adml != null) {
                                                        comp = adml.getCompulsorySubjects() + "";
                                                        oth = adml.getOtherSubjects() + "";
                                                        peutme = adml.getUtmePer() + "";
                                                        peol = adml.getOlevelPer() + "";
                                                        peputme = adml.getAptitudePer() + "";
                                                        try {
                                                            Collection<Admissiontemplateolevel> listx = adml.getAdmissiontemplateolevelCollection();

                                                            List<Admissiontemplateolevel> admtl = sess.getAdmissiontemplateolevel(adml.getId());

                                                            List<Admissiontemplateolevel> listoc = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C"))
                                                                    .collect(Collectors.toList());
                                                            List<Admissiontemplateolevel> listoo = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O"))
                                                                    .collect(Collectors.toList());

                                                            comp += "/" + listoc.size();
                                                            oth += "/" + listoo.size();
                                                        } catch (Exception j) {
                                                            j.printStackTrace();
                                                        }
                                                    }
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=course.getName().toUpperCase()%></td>
                                                <td><%=course.getDepartmentId().getCode()%></td>
                                                <td><%=course.getDepartmentId().getFacultyId().getCode()%></td>
                                                <td><%=comp%></td>
                                                <td><%=oth%></td>
                                                <td class="center">
                                                    <a class="btn btn-primary btn-sm" href="/app_adm_temp?id=<%=settings.encodeUrl(settings.encryptText(course.getId() + ";" + sessions))%>">View</a>
                                                    <%
                                                        if (comp.equalsIgnoreCase("Not Set")) {
                                                    %>
                                                    <br/>
                                                    <a class="btn btn-warning btn-sm" href="/app_adm_temp?id2=<%=settings.encodeUrl(settings.encryptText(course.getId() + ";" + sessions))%>" title="This will reset to previous values">Preload</a>
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