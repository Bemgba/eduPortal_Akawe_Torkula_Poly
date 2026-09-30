<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Check if user has Applicants record - redirect to main dashboard if not
    Applicants std = sess.getApplicantsById(user.getId());
    if (std == null) {
        // New user without Applicants record should go to main dashboard to complete profile
        response.sendRedirect("/gen_app_dashboard");
        return;
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Dashboard</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Dashboard</h2>
                </div>
            </header>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <!-- Profile Update Notification -->
                    <%
                        boolean needsProfileUpdate = false;
                        boolean needsBiodata = false;
                        String profileMessage = "";
                        
                        // Check if user has biodata
                        try {
                            Applicantsbiodata biodata = (Applicantsbiodata) sess.getSingleObject(Applicantsbiodata.class, user.getId());
                            if (biodata == null) {
                                needsBiodata = true;
                                profileMessage = "Please complete your profile information to access all features.";
                            }
                        } catch (Exception e) {
                            // Continue without biodata check
                        }
                        
                        // Check for missing contact information from Applicants table (primary source)
                        // Only check if std is not null and biodata check passed
                        if (!needsBiodata && std != null && (std.getEmailAddress() == null || std.getEmailAddress().trim().isEmpty() ||
                            std.getPhoneNo() == null || std.getPhoneNo().trim().isEmpty())) {
                            needsProfileUpdate = true;
                            profileMessage = "Please update your profile with email and phone number to receive admission updates.";
                        }
                        
                        if (needsBiodata || needsProfileUpdate) {
                    %>
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-exclamation-triangle me-3 fs-4"></i>
                            <div class="flex-grow-1">
                                <h6 class="alert-heading mb-1">
                                    <%=needsBiodata ? "Profile Setup Required" : "Profile Update Required"%>
                                </h6>
                                <p class="mb-2"><%=profileMessage%></p>
                                <a href="/profile_update" class="btn btn-warning btn-sm">
                                    <i class="fas fa-user-edit me-1"></i>Update Profile Now
                                </a>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                    %>
                    
                    <div class="row g-4 mb-4">
                        <div class="col-sm-6 col-xl-4">

                            <div class="card text-white bg-primary-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Application Session </div>
                                        <div data-coreui-i18n="users"><%=std.getSession()%></div>
                                    </div>
                                </div>                             
                            </div>
                            <div style="height:10px"></div>
                            <%
                                String sty = "danger";
                                String msg = "";
                                try {
                                    if (std.getStatus().equalsIgnoreCase("PENDING")) {
                                        sty = "danger";
                                        msg = "Your application is Pending. If you are UTME applicants you are required to pay for screening and update your application. For Non-JAMB applicants you are required to pay for your application and also complete before it will be processed.";
                                    }
                                    if (!std.getStatus().equalsIgnoreCase("PENDING") && !std.getStatus().equalsIgnoreCase("ADMITTED") && !std.getStatus().equalsIgnoreCase("ACCEPTED")) {
                                        sty = "warning";
                                        msg = "Your application is undergoing processing. You will be requied to pay to check your admission in due course";
                                    }
                                    if (std.getStatus().equalsIgnoreCase("ADMITTED")) {
                                        sty = "success";
                                        msg = "Congratulations. You have been admitted. You are required to pay for Admission Letter/Acceptance to proceed";
                                    }

                                    if (std.getStatus().equalsIgnoreCase("ACCEPTED")) {
                                        sty = "success";
                                        msg = "Congratulations. You have accepted your admission. Your account will be changed to a student account.";
                                    }
                                } catch (Exception k) {
                                }
                            %>
                            <div class="card text-white bg-<%=sty%>-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Application Status </div>
                                        <div data-coreui-i18n="users"><%=std.getStatus()%></div>
                                    </div>

                                </div>  
                                <div class="c-chart-wrapper mt-3 mx-3"><%=msg%>
                                </div>
                            </div>

                            <div style="height:10px"></div>
                            <div class="card text-white bg-info-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Application Type </div>
                                        <div data-coreui-i18n="users"><%=std.getApplicationType()%></div>
                                    </div>
                                </div>                             
                            </div>
                            <div style="height:10px"></div>
                            <div class="row">
                                <div class="col-sm-12 col-xl-12">
                                    <%
                                        if (std.getApplicationType().equalsIgnoreCase("UTME")) {
                                            List<Payments> payutme = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10046", std.getSession(), "Session");
                                            List<Payments> payutmeCHS = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10195", std.getSession(), "Session");
                                            payutme.addAll(payutmeCHS);
                                            if (payutme.size() > 0) {
                                    %>
                                    <button name="edit" class="btn btn-primary btn-sm" style="margin-bottom: 10px">Post UTME</button>

                                    <button type="button" class="btn btn-warning btn-sm" data-coreui-toggle="modal" data-coreui-target="#edit">
                                        Edit
                                    </button>

                                    <!-- Modal -->
                                    <div class="modal fade" id="edit" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Edit Records</h5>
                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <%
                                                        String email = request.getParameter("email");
                                                        String phoneno = request.getParameter("phoneno");
                                                        String button = request.getParameter("button");
                                                        if (button != null && button.length() > 0) {
                                                            try {
                                                                email = email.toLowerCase();
                                                                std.setEmailAddress(email);
                                                                std.setPhoneNo(phoneno);
                                                                sess.updatePUTME(std.getId(), email, phoneno);
                                                                std = sess.getApplicants(std.getId());

                                                            } catch (Exception k) {
                                                            }
                                                        }


                                                    %>
                                                    <div class="alert alert-info">Add your email address and Phone number to receive updates on your admission process</div>
                                                    <form name="edit" method="post" action="">
                                                        <div class="input-group mb-3"><span class="input-group-text">
                                                                Email Address    
                                                            </span>
                                                            <input class="form-control" type="email" required="" value="<%=std.getEmailAddress() != null ? std.getEmailAddress() : ""%>" name="email">
                                                        </div>
                                                        <div class="input-group mb-4"><span class="input-group-text">
                                                                Phone Number   
                                                            </span>
                                                            <input class="form-control" type="number" required="" name="phoneno" value="<%=std.getPhoneNo() != null ? std.getPhoneNo() : ""%>" minlength="11" maxlength="13">
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-6">
                                                                <input type="submit" name="button" class="btn btn-secondary px-4" value="Update Records"/>
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


                                    <%
                                        List<Payments> paychecking = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10137", std.getSession(), "Session");
                                        List<Payments> paycheckingCHS = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10217", std.getSession(), "Session");
                                        paychecking.addAll(paycheckingCHS);
                                        if (paychecking.size() > 0) {
                                    %>
                                    <button name="edit" class="btn btn-primary btn-sm" style="margin-bottom: 10px">View My Admission</button>
                                    <%
                                        List<Payments> acceptance = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10045", std.getSession(), "Session");
                                        List<Payments> acceptanceCHS = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10194", std.getSession(), "Session");
                                        acceptance.addAll(acceptanceCHS);
                                        if (acceptance.size() > 0) {

                                        } else {
                                    %>
                                    <button name="edit" class="btn btn-success btn-sm" style="margin-bottom: 10px">Pay Acceptance Fee</button>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <button name="edit" class="btn btn-success btn-sm" style="margin-bottom: 10px">Pay Admission Checking</button>
                                    <%
                                        }

                                    } else {

                                        String payid = "10046";
                                        if (std.getCourse1().getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
                                            payid = "10195";
                                        }
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

                                                regno = std.getId();
                                                fullname = std.getSurname() + " " + std.getOthernames();
                                                coursename = std.getCourse1().getName();

                                                sch = std.getCourse1().getSchoolProgrammeId().getSchoolId().getId();
                                                prog = std.getCourse1().getSchoolProgrammeId().getProgrammeId().getId() + "";
                                                fac = std.getCourse1().getDepartmentId().getFacultyId().getId();
                                                dept = std.getCourse1().getDepartmentId().getId();
                                                course = std.getCourse1().getId();
                                                feessetup = sess.getFeessetup(payid, std.getSession(), "Session", sch, prog, fac, dept,
                                                        course, level, ind, campus, dfrom, std.getId());
                                                if (feessetup.size() > 0) {
                                                    String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                                                    boolean exist = false;
                                                    if (fgx.equalsIgnoreCase("No")) {
                                                        List<Payments> payl = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), payid, std.getSession(), "Session");
                                                        if (payl.size() > 0) {
                                                            exist = true;
                                                        }

                                                    }
                                                    if (exist) {

                                                    } else {
                                                        String email = std.getEmailAddress();
                                                        double total = feessetup.stream()
                                                                .mapToDouble(Feessetup::getAmount)
                                                                .sum();
                                                        session.setAttribute("FEESSETUP", feessetup);
                                                        session.setAttribute("level", level);
                                                        session.setAttribute("sessions", std.getSession());
                                                        session.setAttribute("feesgroup", payid);
                                                        session.setAttribute("sesssem", "Session");
                                                        session.setAttribute("regno", regno);
                                                        session.setAttribute("fullname", fullname);
                                                        session.setAttribute("coursename", coursename);
                                                        session.setAttribute("phoneno", std.getPhoneNo());
                                                        session.setAttribute("email", email);
                                                        session.setAttribute("id", std.getId());

                                                        Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                                                        Schools schoolId = std.getCourse1().getSchoolProgrammeId().getSchoolId();
                                                        Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                                                total, std.getId(), settings.getCurrentDateTime(), "PENDING", null, std.getSession(), "Session", "", "", "", "", fullname,
                                                                std.getPhoneNo(), email, "", feesGroupId, schoolId);
                                                        pr.setPayerRegistrationIo(regno);
                                                        pr.setCourseId(std.getCourse1().getId());
                                                        pr.setLevel(level);
                                                        sess.newEntry(pr);
                                                        try {
                                                            session.setAttribute("pr", pr);

                                                        } catch (Exception k) {
                                                        }
                                                        String returnurl = "/app_dashboard";
                                                        returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                        try {
                                                            session.setAttribute("return", returnurl);
                                                        } catch (Exception k) {
                                                        }
                                    %>
                                    <a href="/invoice?return="<%=returnurl%>" class="btn btn-success btn-sm" style="margin-bottom: 10px">Pay Post UTME</a>
                                    <%
                                                            //response.sendRedirect("/invoice?return=" + returnurl);
                                                        }

                                                    }
                                                } catch (Exception a) {
                                                }
                                            } catch (Exception k) {
                                            }
                                        }
                                    %>


           



                                    <%                                        }
                                    %>

                                </div> 
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-xl-8" id="content">
                            <%@include file="WEB-INF/jspf/applicant_home.jspf"%>
                        </div>

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