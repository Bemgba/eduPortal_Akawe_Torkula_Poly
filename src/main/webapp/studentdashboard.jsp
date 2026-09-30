<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

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
        <title><%=settings.productName%> - Dashboard</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Dashboard</h2>
                </div>
            </header>

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row g-4 mb-4">
                        <div class="col-sm-6 col-xl-4">
                            <%    String ssty = "danger";
                                String smsg = "Not Found";
                                try {
                                    if (sessman.getStatus().equalsIgnoreCase("OPEN")) {
                                        ssty = "success";
                                    }
                                } catch (Exception l) {
                                }
                                

                            %>
                            <div class="card text-white bg-<%=ssty%>-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Current Session </div>
                                        <div data-coreui-i18n="users"><%=sessman.getName()%> <%=sessman.getSemester()%> Semester (<%=sessman.getStatus()%>)</div>
                                    </div>
                                </div>                             
                            </div>
                            <div style="height:10px"></div>
                            <%

                                String psty = "danger";
                                String msg = "Not Paid";
                                try {
                                    // Check payments for the default school fees group only
                                    Feesgroup fg = sess.getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                                    if (fg != null) {
                                        List<Payments> pay = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fg.getId(), sessman.getName(), sessman.getSemester());
                                        if (pay.size() > 0) {
                                            psty = "success";
                                            msg = "PAID N" + settings.formatno.format(pay.get(0).getAmount());
                                        }
                                    }
                                } catch (Exception k) {
                                }
                            %>
                            <div class="card text-white bg-<%=psty%>-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Payment Status </div>
                                        <div data-coreui-i18n="users"><%=msg%></div>
                                    </div>
                                </div>  
                            </div>

                            <div style="height:10px"></div>
                            <%

                                String rsty = "danger";
                                String rmsg = "No Record";
                                try {
                                    if (reg != null) {
                                        if (!reg.getRegistrationStatus().equalsIgnoreCase("0")) {
                                            rsty = "success";
                                            rmsg = "REGISTERED" + " " + settings.formatDate(reg.getDateRegistered());
                                        } else {
                                            rmsg = "NOT REGISTERED";
                                        }
                                    }
                                } catch (Exception k) {
                                }
                            %>

                            <div class="card text-white bg-<%=rsty%>-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">Registration Status </div>
                                        <div data-coreui-i18n="users"><%=rmsg%></div>
                                    </div>

                                </div>  

                            </div>


                            <div style="height:10px"></div>
                            <div class="row">
                                <div class="col-sm-12 col-xl-12">
                                    <%
                                        List<Pages> pagel = sess.getAllPagesforRole(user.getDefaultRole().getId() + "");
                                        for (Pages pg : pagel) {

                                    %>
                                    <button name="page<%=pg.getId()%>" onclick="window.location.replace('/<%=pg.getAlias()%>')" class="btn btn-primary btn-sm" style="margin-bottom: 10px"><%=pg.getDescription()%></button>



                                    <%                                        }

                                    %>

                                </div> 
                            </div>
                            
                            <div style="height:10px"></div>
                            <!-- Payment Options Section -->
                            <div class="card">
                                <div class="card-header">
                                    <strong>Payment Options</strong>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 mb-2">
                                            <a href="/std_payment" class="btn btn-info btn-sm w-100">
                                                <svg class="icon me-2">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-credit-card"></use>
                                                </svg>
                                                Public Payments (School Fees, etc.)
                                            </a>
                                        </div>
                                        <div class="col-12 mb-2">
                                            <a href="/private_payment" class="btn btn-success btn-sm w-100">
                                                <svg class="icon me-2">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                                                </svg>
                                                Private Payments (Transcript, Certificate, etc.)
                                            </a>
                                        </div>
                                        <div class="col-12">
                                            <a href="/payment_hist" class="btn btn-secondary btn-sm w-100">
                                                <svg class="icon me-2">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-history"></use>
                                                </svg>
                                                Payment History
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-xl-8" id="content">
                            <%@include file="WEB-INF/jspf/student_home.jspf"%>
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
        <script>
        </script>

    </body>
</html>