<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Change Password</title>
    </head>
    <body>
        <div class="sidebar sidebar-fixed border-end" id="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-brand">
                    <img src="assets/img/logo.png" alt="BSUM Logo" style="widows: 32px; height: auto">
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
                                <%
                                    String id = request.getParameter("id");
                                    String userid="";
                                    if (id != null && id.length() > 0) {
                                        id = settings.decryptText(id);
                                        if (id.contains("::")) {
                                            String split[] = id.split("::");
                                            userid = split[0];
                                            String xdate = split[1];
                                            Users usdx = sess.getUsers(userid);
                                            Date xdatue = null;
                                            try {
                                                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                                xdatue = dateFormat.parse(xdate);
                                            } catch (Exception k) {
                                            }
                                            if (usdx != null && xdatue != null) {


                                %>
                                <div class="card col-md-7 p-4 mb-0">
                                    <div class="card-body">
                                        <h1>Password Reset</h1>
                                        <%                                            String pw1 = request.getParameter("pw1");
                                            String pw2 = request.getParameter("pw2");
                                            String id2 = request.getParameter("id");
                                            String button = request.getParameter("button");
                                            String idx="";
                                            if (button != null && pw1 != null && pw1.trim().length() > 0 && pw2 != null) {
                                                pw1 = pw1.trim(); // DO NOT convert to lowercase - preserve case for security
                                                pw2 = pw2.trim(); // DO NOT convert to lowercase - preserve case for security
                                                idx = settings.encodeUrl(settings.encryptText(userid + "::" + settings.getTodaysdate() + " " + settings.getCurrentTime()));
                                                if (pw1.equals(pw2)) {
                                                    usdx.setPassword(pw1);

                                                    String msgd = "Dear " + usdx.getUsername() + ",<br/>"
                                                            + "Your password has been successcully reset via your registered email address.<br/><br/>";
                                                    msgd = settings.generateEmailBody(msgd);
                                                    MailClient mc = new MailClient();
                                                    try {
                                                        String te = mc.sendEmailWithAttachment(usdx.getEmail(), null, null, "ATpoly Password Reset Confirmation", msgd, "ATpoly Password Reset");
                                                    } catch (Exception kw) {
                                                    }

                                        %>
                                        <div class="alert alert-success">Success: password has been changed successfully.  Click <a href="/">here</a> to login</div>
                                        <%                                } else {
                                        %>
                                        <div class="alert alert-danger">Error: Password must match confirmed password</div>
                                        <%
                                                }
                                            }

                                        %>

                                        <form action="" method="POST" role="form">
                                            <p class="text-body-secondary">Kindly enter your new password for <strong><%=usdx.getEmail()%></strong> here</p>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                                                    </svg></span>
                                                <input class="form-control" type="password" required="" name="pw1" placeholder="New Password">
                                            </div>
                                             <div class="input-group mb-4"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                                                    </svg></span>
                                                <input class="form-control" type="password" required="" name="pw2" placeholder="Confirm Password">
                                                <input class="form-control" type="hidden" value="<%=idx%>" name="id2">
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
                                            <p>Kindly enter your new password and confirm it to be able to change your password</p>
                                            <p>Your new password will take effect on next login</p>

                                        </div>
                                    </div>
                                </div>
                                <%                                } else {
                                %>
                                <div class="alert alert-danger">Invalid page entry. Click <a href="/recover">here</a> to retry</div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="alert alert-danger">Invalid page entry, wrong data provided. Click <a href="/recover">here</a> to retry</div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="alert alert-danger">Invalid page entry, no data provided. Click <a href="/recover">here</a> to retry</div>
                                <%
                                    }
                                %>
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