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
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Password Reset</title>
    </head>
    <body>
        <div class="sidebar sidebar-fixed border-end" id="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-brand">
                    <img src="assets/img/Akawe.png" alt="at Logo" style="widows: 32px; height: auto">
                </div>
                <button class="btn-close d-lg-none" type="button" aria-label="Close" onclick="coreui.Sidebar.getInstance(document.querySelector( & amp; quot; #sidebar & amp; quot; )).toggle()"></button>
            </div>
        </div>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <div class="container-fluid px-4">
                    <button class="header-toggler" type="button" onclick="coreui.Sidebar.getInstance(document.querySelector('#sidebar')).toggle()" style="margin-inline-start: -14px">
                        <svg class="icon icon-lg">
                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-menu"></use>
                        </svg>
                    </button>
                    <div><h1><%=settings.fullName%></h1></div>
                    <ul class="header-nav d-none d-md-flex ms-auto"></ul>
                    <ul class="header-nav ms-auto ms-md-0"></ul>

                </div>

            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card-group d-block d-md-flex row">
                                <div class="card col-md-7 p-4 mb-0">
                                    <div class="card-body">
                                        <h1>Password Reset</h1>
                                        <%
                                            String emailadd = request.getParameter("emailadd");
                                            String button = request.getParameter("button");
                                            if (button != null && emailadd != null && emailadd.trim().length() > 0) {
                                                emailadd = emailadd.trim().toLowerCase();
                                                Users usdx = sess.getUsersByEmail(emailadd);
                                                if (usdx != null) {
                                                    String id = settings.encodeUrl(settings.encryptText(usdx.getId() + "::" + settings.getTodaysdate() + " " + settings.getCurrentTime()));
                                                    String link = settings.baseurl + "/changepw?id=" + id;
                                                    String msgd = "Dear " + usdx.getUsername() + ",<br/>"
                                                            + "Kindly click on the link below to reset your password<br/><br/>"
                                                            + "<a href=\"" + link + "\">Reset Password</a>";
                                                    msgd = settings.generateEmailBody(msgd);
                                                    MailClient mc = new MailClient();
                                                    try {
                                                        String te = mc.sendEmailWithAttachment(emailadd, null, null, "AT Password Reset", msgd, "AT Password Reset");
                                                        if (te.equalsIgnoreCase("Yes")) {
                                        %>
                                        <div class="alert alert-success">Success: Your reset link has been sent to <%=emailadd%>. Kindly login to the email and clickon the reset link to be able to change your password</div>
                                        <%
                                        } else {
                                        %>
                                        <div class="alert alert-danger">Error: resetting password: <%=te%></div>
                                        <%
                                                }
                                            } catch (Exception k) {
                                            }

                                        } else {
                                        %>
                                        <div class="alert alert-danger">Error: email address <%=emailadd%> is not attached to any login details</div>
                                        <%
                                                }
                                            }

                                        %>

                                        <form action="" method="POST" role="form">
                                            <p class="text-body-secondary">Enter your registered email to recover password</p>
                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                                                    </svg></span>
                                                <input class="form-control" type="email" required="" name="emailadd" placeholder="Email Address">
                                            </div>

                                            <div class="row">
                                                <div class="col-6">
                                                    <input type="submit" name="button" class="btn btn-primary px-4" value="Reset Password"/>
                                                </div>
                                                <div class="col-6 text-end">
                                                    <a href="/" class="btn btn-link px-0">Login</a>
                                                </div>
                                            </div>

                                        </form>
                                    </div>
                                </div>
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Reset Instruction</h2>
                                            <p>Your registered email is the email that is added to your account. We will send a reset link through this email so you can use it to change your password to a preferred one</p>
                                            <p>If you have not linked an email to your account, kindly contact the Directorate of ICT to help you do so</p>

                                        </div>
                                    </div>
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
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
        <script>
        </script>

    </body>
</html>