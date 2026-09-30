<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    List<Feessetup> feessetup = new ArrayList();
    String fgi = "";
    Deferments defer = null;


%>

<%    String dd = request.getParameter("dd");
    if (dd != null) {
        dd = settings.decryptText(dd);
        Deferments def = sess.getDeferments(dd);
        if (def != null) {
            try {
                sess.deleteDeferments(dd);
            } catch (Exception k) {
            }
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - My Deferment</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">My Deferment Details</h2>
                </div>
            </header>

            <%                try {
                    defer = sess.getDefermentsByStudentSessSem(std.getId(), sessman.getName(), sessman.getSemester());
                    Feesgroup gfg = sess.getFeesgroupByNameAndSchool(settings.defermentName, std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if (gfg != null) {
                        fgi = gfg.getId();

                    }
                } catch (Exception k) {
                }
                String ind = "None";
                String sch = "None";
                String prog = "None";
                String fac = "None";
                String dept = "None";
                String course = "None";
                String level = "None";
                String campus = "None";

                String regno = "";
                String fullname = "";
                String coursename = "";
                Date dfrom = settings.getCurrentDateTime();
                try {

                    regno = std.getId();
                    fullname = std.getSurname() + " " + std.getOthernames();
                    coursename = std.getCourseId().getName();

                    sch = std.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = std.getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                    fac = std.getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = std.getCourseId().getDepartmentId().getId();
                    course = std.getCourseId().getId();
                    if (std.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                        ind = "indigene";
                    } else {
                        ind = "non_indigene";
                    }
                    level = reg.getLevelAdded();
                    feessetup = sess.getFeessetup(fgi, sessman.getName(), sessman.getSemester(), sch, prog, fac, dept,
                            course, level, ind, campus, dfrom, std.getId());

                } catch (Exception a) {
                }

            %>

            <%                 String nosemesters = request.getParameter("nosemesters");
                String reason = request.getParameter("reason");
                String submit = request.getParameter("button2");
                String msd = "";
                String sty = "danger";
                if (submit != null && submit.length() > 0 && nosemesters != null && nosemesters.length() > 0) {
                    try {
                        String id = std.getId() + settings.generateId("", 3);
                        Deferments def = new Deferments(id);
                        def.setApprovalStatus("PENDING");
                        int nosem = Integer.parseInt(nosemesters);
                        def.setDurationSemesters(nosem);
                        int odd = nosem % 2;
                        int ses = nosem / 2;
                        String currses = sessman.getName();
                        String currsem = sessman.getSemester();
                        for (int h = 0; h < ses; h++) {
                            currses = settings.getSessionAfter(currses);
                        }
                        if (odd == 1) {
                            if (currsem.equalsIgnoreCase("First")) {
                                currsem = "Second";
                            } else {
                                currsem = "First";
                            }
                        }
                        def.setExpectedResumptionSemester(currsem);
                        def.setExpectedResumptionSession(currses);
                        def.setLevelAt(reg.getLevelAdded());
                        List<Payments> li2 = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fgi, sessman.getName(), sessman.getSemester());
                        Payments pa = null;
                        if (li2.size() > 0) {
                            pa = li2.get(0);
                        }
                        def.setPaymentId(pa);
                        def.setReason(reason);
                        def.setSemester(sessman.getSemester());
                        def.setSession(sessman.getName());
                        def.setStudentId(std);
                        def.setDateApplied(settings.getCurrentDateTime());
                        sess.newEntry(def);
                        defer = sess.getDefermentsByStudentSessSem(std.getId(), sessman.getName(), sessman.getSemester());
                    } catch (Exception ka) {
                    }

                }


            %>
            <script>
                // Get the dynamic title from a JSP variable
                var newTitle = "<%= "Deferment details for " + std.getSurname() + " " + std.getOthernames()%>";
                // Update the page title
                document.title = newTitle;
            </script>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Deferment Details for <%=sessman.getName()%>, <%=sessman.getSemester()%> Semester</strong> 
                                <a href="/my_reg" class="btn btn-danger btn-sm float-right">Back</a>
                            </div>
                            <div class="card-body">
                                <%
                                    String schfees = "No Setup Yet";
                                    String paidStatus = "Not Paid";
                                    String paidsty = "danger";
                                    String defsty = "danger";
                                    String defstatus = "No Record";
                                    if (reg != null) {
                                %>
                                <div class="table-responsive-sm">

                                    <table class="table table-striped table-hover">

                                        <tbody>
                                            <tr>
                                                <th>Level</th>
                                                <td><%=reg.getLevelAdded()%></td>
                                            </tr>
                                            <tr>
                                                <th>Date Added</th>
                                                    <%
                                                        String dateadded = "Not Added";
                                                        try {
                                                            dateadded = sdf.format(reg.getDateAdded());
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><%=dateadded%></td>
                                            </tr>
                                            <tr>
                                                <th>Deferment Fees</th>
                                                    <%

                                                        if (defer != null) {
                                                            defstatus = defer.getApprovalStatus();
                                                            if (defstatus.equalsIgnoreCase("PENDING")) {

                                                            } else {
                                                                defsty = "success";
                                                            }
                                                        }
                                                        try {

                                                            if (feessetup.size() > 0) {
                                                                double total = feessetup.stream()
                                                                        .mapToDouble(Feessetup::getAmount)
                                                                        .sum();
                                                                schfees = "N" + settings.formatno.format(total);

                                                            }

                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><%=schfees%></td>
                                            </tr>
                                            <tr>
                                                <th>Payment Status</th>
                                                    <%

                                                        try {
                                                            List<Payments> li = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fgi, sessman.getName(), sessman.getSemester());
                                                            if (li.size() > 0) {
                                                                double total = li.stream()
                                                                        .mapToDouble(Payments::getAmount)
                                                                        .sum();
                                                                paidStatus = "Paid N" + settings.formatno.format(total);
                                                                paidsty = "success";
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><span class="alert alert-<%=paidsty%>"><%=paidStatus%></span></td>
                                            </tr>
                                            <tr>
                                                <th>Deferment Status</th>
                                                <td><span class="alert alert-<%=defsty%>"><%=defstatus%></span>
                                                    <%
                                                        if (!defstatus.equalsIgnoreCase("No Record")) {
                                                            String idu = settings.encodeUrl(settings.encryptText(defer.getId()));
                                                    %>

                                                    <a href="/DownloadDefermentForm?id=<%=idu%>" target="_blank" class="btn btn-primary btn-lg float-end">Download Form Form</a>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>
                                <%
                                } else {
                                %>
                                <div class="alert alert-warning">You have not been added to this current semester and session. Kindly contact the Directorate of ICT to addition beofre you can proceed</div> 
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        <div style="height: 10px"></div>
                        <%
                            if (reg != null) {
                                if (paidStatus.equalsIgnoreCase("Not Paid")) {
                                    //make payment
                                    String payid = fgi;

                                    PaymentreferenceDetail prd = sess.createStudentsPayments(std.getId(), payid, sessman.getName(), sessman.getSemester());
                                    if (prd.getPayref().length() > 0) {
                                        String email = std.getUniversityEmail() != null ? std.getUniversityEmail() : std.getPersonalEmail();
                                        double total = feessetup.stream()
                                                .mapToDouble(Feessetup::getAmount)
                                                .sum();
                                        session.setAttribute("FEESSETUP", feessetup);
                                        session.setAttribute("level", level);
                                        session.setAttribute("sessions", sessman.getName());
                                        session.setAttribute("feesgroup", payid);
                                        session.setAttribute("sesssem", sessman.getSemester());
                                        session.setAttribute("regno", regno);
                                        session.setAttribute("fullname", fullname);
                                        session.setAttribute("coursename", coursename);
                                        session.setAttribute("phoneno", std.getPhoneNo());
                                        session.setAttribute("email", email);
                                        session.setAttribute("id", std.getId());

                                        try {
                                            Paymentreference prx = sess.getPaymentreference(prd.getPayref());
                                            session.setAttribute("pr", prx);

                                        } catch (Exception k) {
                                        }
                                        String returnurl = "/std_deferment_p1";
                                        returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                        try {
                                            session.setAttribute("return", returnurl);
                                        } catch (Exception k) {
                                        }
                        %>
                        <a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-lg" style="margin-bottom: 10px">Pay and Proceed</a>
                        <%

                            } else {

                            }

                        } else {
                            if (defstatus.equalsIgnoreCase("No Record")) {
                                //register
                        %>
                        <div class="card mb-4">
                            <div class="card-header">
                                Deferment Registration
                            </div>
                            <div class="card-body">

                                <%
                                    if (msd.length() > 0) {
                                %>
                                <div class="alert alert-<%=sty%>"><%=msd%></div>
                                <%
                                    }
                                %>

                                <form action="" method="post" name="semregistration">
                                    <div class="input-group mb-3"><span class="input-group-text">
                                            Enter Reason for deferment   
                                        </span>
                                        <input type="text" required="" class="form-control" name="reason" id="reason"/>

                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Select number of semesters to defer 
                                        </span>
                                        <input type="number" required="" class="form-control" name="nosemesters" id="nosemesters" min="1" max="6"/>
                                    </div>

                                    <div class="row">
                                        <div class="col-6">
                                            <input type="submit" name="button2" class="btn btn-success px-4" value="File Application"/>
                                        </div>
                                    </div>
                                </form>


                            </div>
                        </div>
                        <%
                            }
                            if (defstatus.equalsIgnoreCase("PENDING")) {
                                String idu = settings.encodeUrl(settings.encryptText(defer.getId()));
                        %>

                        <a href="/std_deferment_p1?dd=<%=idu%>" class="btn btn-danger btn-lg" style="margin-bottom: 10px">Reset My Application</a>

                        <%
                                    }
                                }
                            }
                        %>

                    </div> 
                    <!-- /.row-->
                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
        <script>
        </script>

    </body>
</html>