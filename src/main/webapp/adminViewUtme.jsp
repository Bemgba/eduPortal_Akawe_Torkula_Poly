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
    String id4 = request.getParameter("id4");
    if (id4 != null && id4.length() > 0) {
        id4 = settings.decryptText(id4);
    } else {
        response.sendRedirect("/app_adm_download_template");
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - UTME Applicants List</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">

                    <h2 class="title">UTME Applicants List for <%=id4%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <a href="/app_adm_download_template" class="btn btn-danger">Back</a>
                                </p>
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
                                                <th>FACULTY</th>
                                                <th>DEPARTMENT</th>
                                                <th>COURSE</th>
                                                <th>REG NO</th>
                                                <th>SURNAME</th>
                                                <th>OTHER NAMES</th>
                                                <th>DATE OF BIRTH</th>
                                                <th>STATE OF ORIGIN</th>
                                                <th>LGA</th>
                                                <th>PHONE NO</th>
                                                <th>EMAIL</th>
                                                <th>ENG SCORE</th>
                                                <th>SUBJ2</th>
                                                <th>SUBJ2 SCORE</th>
                                                <th>SUBJ3</th>
                                                <th>SUBJ3 SCORE</th>
                                                <th>SUBJ4</th>
                                                <th>SUBJ4 SCORE</th>
                                                <th>TOTAL UTME</th>
                                                <th>Post UTMEE</th>
                                                <th>STATUS</th>
                                                <th>OL RESULT</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    int i = 1;
                                                    List<Applicants> appl = sess.getApplicantsByTypeSessionStatus(id4, "ALL", "UTME");
                                                    for (Applicants data : appl) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=data.getCourse1().getDepartmentId().getFacultyId().getName()%></td>
                                                <td><%=data.getCourse1().getDepartmentId().getName()%></td>
                                                <td><%=data.getCourse1().getName()%></td>
                                                <td><%=data.getId().toUpperCase()%></td>
                                                <td><%=data.getSurname()%></td>
                                                <td><%=data.getOthernames()%></td>
                                                <td><%=data.getDateOfBirth()%></td>
                                                <%
                                                    String state = "";
                                                    String lga = "";
                                                    try {
                                                        state = data.getStateOfOrigin().getName();
                                                        lga = data.getLga().getName();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=state%></td>
                                                <td><%=lga%></td>
                                                <td><%=data.getPhoneNo()%></td>
                                                <td><%=data.getEmailAddress()%></td>
                                                <%
                                                    Applicantsutme utme = data.getApplicantsutme();
                                                    if (utme != null) {
                                                        // Resolve subject names
                                                        String subj2Name = "N/A";
                                                        String subj3Name = "N/A";
                                                        String subj4Name = "N/A";
                                                        
                                                        if (utme.getSubj2() != null) {
                                                            Utmesubjects subj2 = sess.getUtmesubjects(utme.getSubj2());
                                                            subj2Name = subj2 != null ? subj2.getName() : "Unknown Subject";
                                                        }
                                                        
                                                        if (utme.getSubj3() != null) {
                                                            Utmesubjects subj3 = sess.getUtmesubjects(utme.getSubj3());
                                                            subj3Name = subj3 != null ? subj3.getName() : "Unknown Subject";
                                                        }
                                                        
                                                        if (utme.getSubj4() != null) {
                                                            Utmesubjects subj4 = sess.getUtmesubjects(utme.getSubj4());
                                                            subj4Name = subj4 != null ? subj4.getName() : "Unknown Subject";
                                                        }
                                                %>

                                                <td><%=utme.getEngScore()%></td>
                                                <td><%=subj2Name%></td>
                                                <td><%=utme.getSubj2Score()%></td>
                                                <td><%=subj3Name%></td>
                                                <td><%=utme.getSubj3Score()%></td>
                                                <td><%=subj4Name%></td>
                                                <td><%=utme.getSubj4Score()%></td>
                                                <td><%=utme.getTotalUtme()%></td>
                                                <td><%=utme.getPostUtme()%></td>

                                                <%
                                                    }
                                                    String olevel = "";
                                                    Olevelresults olr = sess.getOlevelresults(data.getId());
                                                    if (olr != null) {
                                                        olevel = olr.getResultType() + "= ";
                                                        List<Olevelresultsitems> olri = sess.getOlevelresultsItems(olr.getId());
                                                        for (Olevelresultsitems items : olri) {
                                                            //for (Olevelresultsitems items : olr.getOlevelresultsitemsCollection()) {
                                                            String olrid = items.getSubject() + ":(" + items.getGrade().getId() + "), ";
                                                            olevel += olrid;
                                                        }
                                                    }
                                                %>
                                                <td><%=data.getStatus()%></td>
                                                <td><%=olevel%></td>


                                            </tr>
                                            <%

                                                        i++;
                                                    }
                                                } catch (Exception k) {
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