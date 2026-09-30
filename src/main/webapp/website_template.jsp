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
        <title><%=settings.productName%> - Login</title>
    </head>
    <body>
        

        <div class="wrapper d-flex flex-column min-vh-100">
           
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="card-group d-block d-md-flex row">
                                <div class="card col-md-7 p-4 mb-0">
                                    <div class="card-body">
                                        <h1>Login</h1>
                                        <%
                                            String username = request.getParameter("username");
                                            String password = request.getParameter("password");
                                            String button = request.getParameter("button");
                                            if (button != null && username != null && password != null && username.trim().length() > 0) {
                                                // password = settings.getMD5(password);
                                                String ipAddress = request.getHeader("X-FORWARDED-FOR");
                                                String mac = "";
                                                if (ipAddress == null) {
                                                    ipAddress = request.getRemoteAddr();
                                                }

                                                String agent = "";
                                                Enumeration<String> heads = request.getHeaderNames();
                                                while (heads.hasMoreElements()) {
                                                    String head = heads.nextElement();
                                                    if (!head.equalsIgnoreCase("accept")
                                                            && !head.equalsIgnoreCase("Accept-Language")
                                                            && !head.equalsIgnoreCase("Accept-Encoding")
                                                            && !head.equalsIgnoreCase("referer")
                                                            && !head.equalsIgnoreCase("content-type")
                                                            && !head.equalsIgnoreCase("cookie")
                                                            && !head.equalsIgnoreCase("host")
                                                            && !head.equalsIgnoreCase("Upgrade-Insecure-Requests")
                                                            && !head.equalsIgnoreCase("connection")
                                                            && !head.equalsIgnoreCase("content-length")) {
                                                        String headerValue = request.getHeader(head);
                                                        if (headerValue != null) {
                                                            agent += headerValue + ", ";
                                                        }
                                                    }

                                                }

                                                Users userd = sess.login(username, password, ipAddress, agent);
                                                if (userd != null) {
                                                    try {
                                                        String pagesd = sess.getPagesString(userd.getId());
                                                        String menud = sess.getDesignedMenu(userd.getId());

                                                        session.setAttribute("USER", userd);
                                                        session.setAttribute("PAGES", pagesd);
                                                        session.setAttribute("MENU", menud);
                                                        String landingpage = userd.getDefaultRole().getDefaulthome().getAlias();
                                                        response.sendRedirect("/" + landingpage);
                                                    } catch (Exception d) {
                                                    }
                                                } else {
                                        %>
                                        <div class="alert alert-danger">Error: you entered invalid username or password!</div>
                                        <%
                                                }
                                            }

                                        %>

                                        <form action="" method="POST" role="form">
                                            <p class="text-body-secondary">Sign In to your account</p>
                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                                                    </svg></span>
                                                <input class="form-control" type="text" required="" name="username" placeholder="Username">
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-lock-locked"></use>
                                                    </svg></span>
                                                <input class="form-control" type="password" required="" name="password" placeholder="Password">
                                            </div>
                                            <div class="row">
                                                <div class="col-6">
                                                    <input type="submit" name="button" class="btn btn-primary px-4" value="Login"/>
                                                </div>
                                                <div class="col-6 text-end">
                                                    <button class="btn btn-link px-0" type="button">Forgot password?</button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Portal News</h2>
                                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
                                            <button class="btn btn-lg btn-outline-light mt-3" type="button">Read More</button>
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