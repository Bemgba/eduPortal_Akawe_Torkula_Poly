<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>


<%
    String id3 = request.getParameter("id3");
    if (id3 != null && id3.length() > 0) {
        id3 = settings.decryptText(id3);
        Hostelapplication app = (Hostelapplication) sess.getSingleObject(Hostelapplication.class, id3);
        if (app != null) {

            String payid = "10160";
            List<Feessetup> feessetup = new ArrayList();
            try {
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

                    regno = app.getStudentId().getId();
                    fullname = app.getStudentId().getSurname() + " " + app.getStudentId().getOthernames();
                    coursename = app.getStudentId().getCourseId().getName();

                    sch = app.getStudentId().getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = app.getStudentId().getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                    fac = app.getStudentId().getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = app.getStudentId().getCourseId().getDepartmentId().getId();
                    course = app.getStudentId().getCourseId().getId();
                    feessetup = sess.getFeessetup(payid, app.getSessions(), "Session", sch, prog, fac, dept,
                            course, level, ind, campus, dfrom, app.getStudentId().getId());
                    if (feessetup.size() > 0) {
                        String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                        boolean exist = false;
                        if (fgx.equalsIgnoreCase("No")) {
                            List<Payments> paylreg = sess.getPaymentsByRegnoSessSemFeesgroup(app.getStudentId().getId(), "10160", app.getSessions(), "Session");
                            if (paylreg.size() > 0) {
                                exist = true;
                            }

                        }
                        if (exist) {

                        } else {
                            String email = app.getStudentId().getUniversityEmail() != null ? app.getStudentId().getUniversityEmail() : app.getStudentId().getPersonalEmail();
                            double total = feessetup.stream()
                                    .mapToDouble(Feessetup::getAmount)
                                    .sum();
                            session.setAttribute("FEESSETUP", feessetup);
                            session.setAttribute("level", level);
                            session.setAttribute("sessions", app.getSessions());
                            session.setAttribute("feesgroup", payid);
                            session.setAttribute("sesssem", "Session");
                            session.setAttribute("regno", regno);
                            session.setAttribute("fullname", fullname);
                            session.setAttribute("coursename", coursename);
                            session.setAttribute("phoneno", app.getStudentId().getPhoneNo());
                            session.setAttribute("email", email);
                            session.setAttribute("id", app.getStudentId().getId());

                            Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                            Schools schoolId = app.getStudentId().getCourseId().getSchoolProgrammeId().getSchoolId();
                            Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                    total, app.getStudentId().getId(), settings.getCurrentDateTime(), "PENDING", null, app.getSessions(), "Session", "", "", "", "", fullname,
                                    app.getStudentId().getPhoneNo(), email, "", feesGroupId, schoolId);
                            pr.setPayerRegistrationIo(regno);
                            pr.setCourseId(app.getStudentId().getCourseId().getId());
                            pr.setLevel(level);
                            sess.newEntry(pr);
                            try {
                                session.setAttribute("pr", pr);

                            } catch (Exception k) {
                            }
                            String returnurl = "/hostel_app";
                            returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                            try {
                                session.setAttribute("return", returnurl);
                            } catch (Exception k) {
                            }
                            response.sendRedirect("/invoice?return=" + returnurl);
%>
<script>
    window.location.href = "/invoice?return=<%=returnurl%>";
</script>
<%
                            //response.sendRedirect("/invoice?return=" + returnurl);
                        }

                    }
                } catch (Exception a) {
                    a.printStackTrace();
                }
            } catch (Exception k) {
                k.printStackTrace();
            }

        }
    }
%>

<%
    String id4 = request.getParameter("id4");
    if (id4 != null && id4.length() > 0) {
        id4 = settings.decryptText(id4);
        Hostelapplication app = (Hostelapplication) sess.getSingleObject(Hostelapplication.class, id4);
        if (app != null) {

            String payid = "10155";
            try {
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

                    regno = app.getStudentId().getId();
                    fullname = app.getStudentId().getSurname() + " " + app.getStudentId().getOthernames();
                    coursename = app.getStudentId().getCourseId().getName();

                    sch = app.getStudentId().getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = app.getStudentId().getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                    fac = app.getStudentId().getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = app.getStudentId().getCourseId().getDepartmentId().getId();
                    course = app.getStudentId().getCourseId().getId();
                    Feesgroup fg = (Feesgroup) sess.getSingleObject(Feesgroup.class, payid);
                    if (fg != null) {

                        String fgx = fg.getRepeatPayment();
                        boolean exist = false;
                        if (fgx.equalsIgnoreCase("No")) {
                            List<Payments> paylreg = sess.getPaymentsByRegnoSessSemFeesgroup(app.getStudentId().getId(), "10160", app.getSessions(), "Session");
                            if (paylreg.size() > 0) {
                                exist = true;
                            }

                        }
                        if (exist) {

                        } else {
                            String email = app.getStudentId().getUniversityEmail() != null ? app.getStudentId().getUniversityEmail() : app.getStudentId().getPersonalEmail();
                            double total = app.getHostelId().getFee();
                            //session.setAttribute("FEESSETUP", feessetup);
                            session.setAttribute("level", level);
                            session.setAttribute("sessions", app.getSessions());
                            session.setAttribute("feesgroup", payid);
                            session.setAttribute("sesssem", "Session");
                            session.setAttribute("regno", regno);
                            session.setAttribute("fullname", fullname);
                            session.setAttribute("coursename", coursename);
                            session.setAttribute("phoneno", app.getStudentId().getPhoneNo());
                            session.setAttribute("email", email);
                            session.setAttribute("id", app.getStudentId().getId());

                            Feesgroup feesGroupId = fg;
                            Schools schoolId = app.getStudentId().getCourseId().getSchoolProgrammeId().getSchoolId();
                            Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                    total, app.getStudentId().getId(), settings.getCurrentDateTime(), "PENDING", null, app.getSessions(), "Session", "", "", "", "", fullname,
                                    app.getStudentId().getPhoneNo(), email, "", feesGroupId, schoolId);
                            pr.setPayerRegistrationIo(regno);
                            pr.setCourseId(app.getStudentId().getCourseId().getId());
                            pr.setLevel(level);
                            sess.newEntry(pr);
                            try {
                                session.setAttribute("pr", pr);

                            } catch (Exception k) {
                            }
                            String returnurl = "/hostel_app";
                            returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                            try {
                                session.setAttribute("return", returnurl);
                            } catch (Exception k) {
                            }
                            response.sendRedirect("/invoice?return=" + returnurl);
%>
<script>
    window.location.href = "/invoice?return=<%=returnurl%>";
</script>
<%
                            //response.sendRedirect("/invoice?return=" + returnurl);
                        }

                    }
                } catch (Exception a) {
                    a.printStackTrace();
                }
            } catch (Exception k) {
                k.printStackTrace();
            }

        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Hostel Applications</title>

    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Hostel Applications</h2>
                </div>
            </header>

            <%    Hostelallocation alld = sess.getHostelallocation(std.getId(), sessman.getName());
                if (alld != null) {
                    if (alld.getStatus().equalsIgnoreCase("RESERVED")) {
                        String curr = settings.getTodaysdate();
                        String resdate = settings.formatDate(alld.getDateAdded());
                        long diff = settings.getDaysBetweenDates(curr, resdate);
                        diff = Math.abs(diff);
                        if (diff > 2) {
                            sess.deleteHostelallocation(alld.getId());
                            Hostelapplication appl = sess.getHostelapplication(std.getId(), sessman.getName());
                            if (appl != null) {
                                appl.setApplicationStatus("PENDING");
                                sess.updateRecord(appl);
                            }

                        }

                    }
                }

            %>

            <div class="body flex-grow-1">
                <div class="container-lg px-4">


                    <div class="card mb-4">
                        <%                                                String id2 = request.getParameter("hostel");

                            if (id2 != null && id2.length() > 0) {
                                try {
                                    Hostels hst = (Hostels) sess.getSingleObject(Hostels.class, id2);
                                    if (hst != null) {
                                        Feesgroup fg = sess.getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());

                                        if (fg != null) {
                                            List<Payments> pay1 = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fg.getId(), sessman.getName(), "First");
                                            if (pay1.size() > 0) {
                                                Hostelapplication detx = sess.getHostelapplication(std.getId(), sessman.getName());

                                                if (detx != null) {
                        %>
                        <div class="alert alert-warning">You have already initiated application for this session. Kindly click on the 'Action' in the list to proceed</div>
                        <%
                        } else {
                            String id = std.getId() + sessman.getName().split("/")[0];
                            Hostelapplication newapp = new Hostelapplication(id);
                            newapp.setApplicationStatus("PENDING");
                            newapp.setDateStarted(settings.getCurrentDateTime());
                            newapp.setHostelId(hst);
                            newapp.setSessions(sessman.getName());
                            newapp.setStudentId(std);
                            sess.newEntry(newapp);
                        %>
                        <div class="alert alert-success">Your application for hostel has been initiated. Kindly click on the 'Action' in the list to proceed</div>
                        <%
                            }
                        } else {
                        %>
                        <div class="alert alert-warning">Kindly pay your school fees before applying for hostel application</div>
                        <%
                                            }
                                        }
                                    }

                                } catch (Exception k) {
                                }
                            }


                        %>

                        <div class="card-header">
                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>

                            <button type="button" class="btn btn-primary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                Start Application                                
                            </button>

                            <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Start Hostel Application</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">

                                            <form name="edit2" method="post" action="">


                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Select Hostel
                                                    </span>
                                                    <select name="hostel" class="form-select">
                                                        <option value="">Select One</option>
                                                        <%
                                                            List<Hostels> listd = sess.getHostelsByStatusAndGender("ACTIVE", std.getGender());
                                                            for (Hostels datax : listd) {
                                                        %>
                                                        <option value="<%=datax.getId()%>" <%=datax.getApplicationStatus().equalsIgnoreCase("OPEN") ? "" : "disabled=\"\""%>><%=datax.getName()%> (<%=datax.getApplicationStatus()%>)</option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>


                                                <div class="row">
                                                    <div class="col-6">
                                                        <input type="submit" name="button3" class="btn btn-success px-4" value="Start"/>
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
                            <div class="table-responsive-sm">
                                <table class="table table-striped table-hover" id='dataTable'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Session</th>
                                            <th>Hostel</th>
                                            <th>Date Started</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int i = 1;
                                            List<Hostelapplication> list = sess.getHostelapplication(std.getId());
                                            for (Hostelapplication data : list) {
                                                int agg = 0;
                                        %>
                                        <tr>
                                            <td class="center"><%=i%></td>
                                            <td><%=data.getSessions()%></td>
                                            <td><%=data.getHostelId().getName()%></td>
                                            <%
                                                String started = "";
                                                try {
                                                    started = settings.formatDate(data.getDateStarted());
                                                } catch (Exception k) {
                                                }
                                            %>
                                            <td><%=started%></td>
                                            <td><%=data.getApplicationStatus()%></td>
                                            <td>
                                                <%
                                                    String comm = "";
                                                    List<Payments> payap = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10160", sessman.getName(), "Session");
                                                    if (payap.size() > 0) {
                                                        if (data.getApplicationStatus().equalsIgnoreCase("RESERVED")) {
                                                            List<Payments> payres = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10155", sessman.getName(), "Session");
                                                            if (payres.size() > 0) {
                                                                sess.allocateRoom(data.getId());
                                                                String room ="";
                                                                Hostelallocation all = sess.getHostelallocation(std.getId(), sessman.getName());
                                                                if(all != null){
                                                                room = all.getHostelRoomId().getRoomNo();
                                                    }
                                                %>
                                                Allocated: <%=room%>
                                                <a href="forms/hostelrules.pdf" target="_blank" class="btn btn-primary btn-sm">Download Rules</a>
                                                <a href="/HostelAllocationSlip?id5=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-primary btn-sm">Download Allocation</a>
                                                <%
                                                } else {
                                                %>
                                                <a href="/hostel_app?id4=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-success btn-sm">Pay Accommodation</a>
                                                <%
                                                    }
                                                } else if (data.getApplicationStatus().equalsIgnoreCase("ALLOCATED")) {
                                                %>

                                                <a href="/HostelAllocationSlip?id5=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-primary btn-sm">Download Allocation</a>                                       
                                                <%
                                                } else {
                                                %>
                                                Payment received. Wait for reservation.                                          
                                                <%
                                                    }
                                                } else {
                                                %>
                                                <a href="/hostel_app?id3=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-success btn-sm">Pay for Application</a>
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
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

        <script src="js/popovers.js"></script>
        <script>
        </script>

    </body>
</html>