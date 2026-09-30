<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html lang="en">
    <base href="/" />

    <%        String id = request.getParameter("id");
        if (id != null) {
            id = settings.decryptText(id);
            Sessionmanager smx = (Sessionmanager)sess.getSingleObject(Sessionmanager.class, id);
            if(smx != null){
            session.setAttribute("smx", smx);
            response.sendRedirect("/application_signup");
        }
           

        }
    %>
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - University Applications</title>
    </head>
    <body>


        <div class="wrapper d-flex flex-column min-vh-100">

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="row g-3" style="display: flex">
                                <%
                                    // Only get session manager for the existing school S001
                                    Sessionmanager smmain = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
                                    
                                    String mainst = "danger";
                                    String mainlab = "CLOSED";
                                    String mainlink = "#";
                                    String sessionName = "No Active Session";
                                    
                                    if (smmain != null) {
                                        sessionName = smmain.getName();
                                        if (smmain.getStatus().equalsIgnoreCase("OPEN")) {
                                            mainlink = "/application_home?id=" + settings.encodeUrl(settings.encryptText(smmain.getId()));
                                            mainst = "success";
                                            mainlab = "OPEN > APPLY NOW";
                                        }
                                    }
                                %>
                                <div class="col-12 col-sm-6 col-xl-6 col-xxl-6">
                                    <div class="card text-white bg-primary">
                                        <div class="card-body">
                                            <div class="fs-4 fw-semibold">UNDERGRADUATE PROGRAMME</div>
                                            <div>Apply for undergraduate courses here</div>
                                            <div class="progress progress-white progress-thin my-2">
                                                <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                            <small class="text-white text-opacity-75">The current session for applications is <%=sessionName%></small>
                                            <a class="btn btn-lg btn-<%=mainst%>" href="<%=mainlink%>"><%=mainlab%></a>
                                            <a class="btn btn-lg btn-primary float-end" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("Applicant"))%>">View Courses</a>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12 col-sm-6 col-xl-6 col-xxl-6">
                                    <div class="card text-white bg-info">
                                        <div class="card-body">
                                            <div class="fs-4 fw-semibold">GENERAL INFORMATION</div>
                                            <div>Access general information about applications and requirements</div>
                                            <div class="progress progress-white progress-thin my-2">
                                                <div class="progress-bar" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                            <small class="text-white text-opacity-75">Always available for reference</small>
                                            <a class="btn btn-lg btn-success" href="/gen_app_dashboard">Dashboard</a>
                                            <a class="btn btn-lg btn-primary float-end" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("Applicant"))%>">Make Payment</a>
                                        </div>
                                    </div>
                                </div>
                                <!-- /.col-->
                                <!-- /.col-->
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
        <script>
        </script>

    </body>
</html>