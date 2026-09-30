<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.Optional"%>
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
        <title><%=settings.productName%> - School Fees Performance</title>



    </head>

    <%
        String id = request.getParameter("id");
        Courses cos = null;
        String startsess = "";
        String endsess = "";
        if (id != null && id.length() > 0) {
            id = settings.decryptText(id);

            if (id.contains(";")) {
                String[] spl = id.split(";");
                try {
                    String coid = spl[0];
                    startsess = spl[1];
                    endsess = spl[2];
                    cos = sess.getCourses(coid);
                } catch (Exception d) {
                    response.sendRedirect("/pp_adm_list5");
                    return;
                }
            } else {
                response.sendRedirect("/pp_adm_list5");
                return;
            }
        } else {
            response.sendRedirect("/pp_adm_list5");
            return;
        }

        if (cos == null || startsess.length() == 0 || endsess.length() == 0) {
            response.sendRedirect("/pp_adm_list5");
            return;
        }
    %>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">School Fees Performance</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">


                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>Course: <strong><%=cos.getName()%></strong></p>
                                <p>Department: <strong><%=cos.getDepartmentId().getName()%></strong></p>
                                <p>Faculty: <strong><%=cos.getDepartmentId().getFacultyId().getName()%></strong></p>
                                <p>Start Session: <strong><%=startsess%></strong></p>
                                <p>End Session: <strong><%=endsess%></strong></p>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm" style="max-height: auto; overflow-y: auto;">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th colspan="5"></th>
                                                    <%
                                                        try {
                                                            String tmp = startsess;
                                                            while (tmp.compareToIgnoreCase(endsess) <= 0) {

                                                    %>
                                                <th colspan="2"><%=tmp%></th>
                                                    <%
                                                                tmp = settings.getSessionAfter(tmp);
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>

                                                <th></th>
                                            </tr>
                                            <tr>
                                                <th>#</th>
                                                <th>Matric No</th>
                                                <th>Full name</th>
                                                <th>Ind. Status</th>
                                                <th>Level</th>
                                                    <%
                                                        try {
                                                            String tmp = startsess;
                                                            while (tmp.compareToIgnoreCase(endsess) <= 0) {

                                                    %>
                                                <th>First Semester</th>
                                                <th>Second Semester</th>
                                                    <%                                                           
                                                        tmp = settings.getSessionAfter(tmp);
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>

                                                <th>Outstanding Fees</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                String schfitem = sess.getSchoolFeesId(cos.getSchoolProgrammeId().getSchoolId().getId()).getId();
                                                try {
                                                    List<String> stdp = sess.getStudentprogressionByCourseSessionSemester(cos.getId(), startsess, endsess, "First");
                                                    for (String student : stdp) {

                                                        double outstanding = 0;
                                                        try {

                                                            Students std = sess.getStudentsById(student);
                                                            if (std != null) {
                                            %>
                                            <tr>
                                                <td><%= i++%></td>

                                                <%
                                                    String matricno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                                                    String indst = "Non_indigene";
                                                    try {
                                                        if (std.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                                                            indst = "Indigene";
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <th><%=matricno.toUpperCase()%></th>
                                                <th><%=std.getSurname() + " " + std.getOthernames()%></th>
                                                <td><%= indst%></td>
                                                <td><%= std.getCurrentClass()%></td>

                                                <%
                                                    String tmp = startsess;
                                                    while (tmp.compareToIgnoreCase(endsess) <= 0) {
                                                        final String comp = tmp;
                                                        Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();
                                                        Studentprogression regF = null;
                                                        Studentprogression regS = null;
                                                        try {
                                                            Optional<Studentprogression> regoF = prograssion.stream()
                                                                    .filter(person -> person.getSessionAdded().equals(comp)
                                                                    && person.getSemesterAdded().equals("First"))
                                                                    .findFirst();
                                                            regF = regoF.get();

                                                            Optional<Studentprogression> regoS = prograssion.stream()
                                                                    .filter(person -> person.getSessionAdded().equals(comp)
                                                                    && person.getSemesterAdded().equals("Second"))
                                                                    .findFirst();
                                                            regS = regoS.get();
                                                        } catch (Exception k) {
                                                        }

                                                        double amf = 0;
                                                        double ams = 0;
                                                        String df = "";
                                                        String ds = "";
                                                        if (regF != null) {

                                                            List<Payments> payF = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), schfitem, tmp, "First");
                                                            amf = payF.stream().mapToDouble(dd -> dd.getAmount())
                                                                    .sum();
                                                            if (amf > 0) {
                                                                df = settings.formatno.format(amf);
                                                            } else {
                                                                String ind = "None";
                                                                String schd = "None";
                                                                String prog = "None";
                                                                String facd = "None";
                                                                String dept = "None";
                                                                String course = "None";
                                                                String level = "None";
                                                                String campus = "None";

                                                                String regno = "";
                                                                Date dfrom = settings.getCurrentDateTime();
                                                                try {

                                                                    regno = std.getId();

                                                                    schd = std.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                                                                    prog = std.getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                                                                    facd = std.getCourseId().getDepartmentId().getFacultyId().getId();
                                                                    dept = std.getCourseId().getDepartmentId().getId();
                                                                    course = std.getCourseId().getId();
                                                                    if (std.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                                                                        ind = "indigene";
                                                                    } else {
                                                                        ind = "non_indigene";
                                                                    }
                                                                    level = regF.getLevelAdded();
                                                                    List<Feessetup> feessetup = sess.getFeessetup(schfitem, regF.getSessionAdded(), regF.getSemesterAdded(), schd, prog, facd, dept,
                                                                            course, level, ind, campus, dfrom, std.getId());
                                                                    if (feessetup.size() > 0) {
                                                                        double total = feessetup.stream()
                                                                                .mapToDouble(Feessetup::getAmount)
                                                                                .sum();
                                                                        outstanding += total;

                                                                    }
                                                                } catch (Exception a) {
                                                                }
                                                            }
                                                        }

                                                        if (regS != null) {
                                                            List<Payments> payS = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), schfitem, tmp, "Second");
                                                            ams = payS.stream().mapToDouble(dd -> dd.getAmount()).sum();

                                                            if (ams > 0) {
                                                                ds = settings.formatno.format(ams);
                                                            } else {
                                                                String ind = "None";
                                                                String schd = "None";
                                                                String prog = "None";
                                                                String facd = "None";
                                                                String dept = "None";
                                                                String course = "None";
                                                                String level = "None";
                                                                String campus = "None";

                                                                String regno = "";
                                                                Date dfrom = settings.getCurrentDateTime();
                                                                try {

                                                                    regno = std.getId();

                                                                    schd = std.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                                                                    prog = std.getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                                                                    facd = std.getCourseId().getDepartmentId().getFacultyId().getId();
                                                                    dept = std.getCourseId().getDepartmentId().getId();
                                                                    course = std.getCourseId().getId();
                                                                    if (std.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                                                                        ind = "indigene";
                                                                    } else {
                                                                        ind = "non_indigene";
                                                                    }
                                                                    level = regS.getLevelAdded();
                                                                    List<Feessetup> feessetup = sess.getFeessetup(schfitem, regS.getSessionAdded(), regS.getSemesterAdded(), schd, prog, facd, dept,
                                                                            course, level, ind, campus, dfrom, std.getId());
                                                                    if (feessetup.size() > 0) {
                                                                        double total = feessetup.stream()
                                                                                .mapToDouble(Feessetup::getAmount)
                                                                                .sum();
                                                                        outstanding += total;

                                                                    }
                                                                } catch (Exception a) {
                                                                }

                                                            }
                                                        }


                                                %>
                                                
                                                <td class="text-right"><%=df%></td>
                                                <td class="text-right"><%=ds%></td>
                                                <%
                                                        tmp = settings.getSessionAfter(tmp);
                                                    }
                                                %>
                                                <td class="text-right"><%= settings.formatno.format(outstanding)%></td>
                                                <%
                                                                }
                                                            } catch (Exception ka) {
                                                            }

                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>





                                            </tr>

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