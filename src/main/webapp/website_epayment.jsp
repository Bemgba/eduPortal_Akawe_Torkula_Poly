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
            if (id.equalsIgnoreCase("Student")) {
                response.sendRedirect("/std_payment");
            }
             if (id.equalsIgnoreCase("Applicant")) {
                response.sendRedirect("/app_payment");
            }
            
            if (id.equalsIgnoreCase("Makeup")) {
                response.sendRedirect("/makeup_payment");
            }
            
            
        }      
    %>
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - E_Payment</title>
    </head>
    <body>


        <div class="wrapper d-flex flex-column min-vh-100">

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="row g-3" style="display: flex">
                                
                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-4">
                                        <div class="card text-white bg-primary">
                                            <div class="card-body">
                                                <div class="fs-4 fw-semibold">APPLICANTS</div>
                                                <div>All applicants payments</div>
                                                <div class="progress progress-white progress-thin my-2">
                                                    <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div><small class="text-white text-opacity-75">All payments relating to processing of admission</small>
                                                <a class="btn btn-lg btn-success" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("Applicant"))%>">Proceed</a>
                                            </div>
                                        </div>
                                    </div>
                                

                                <!-- /.col-->
                                
                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-4">
                                        <div class="card text-white bg-info">
                                            <div class="card-body">
                                                <div class="fs-4 fw-semibold">STUDENTS</div>
                                                <div>Students and Alumni payments</div>
                                                <div class="progress progress-white progress-thin my-2">
                                                    <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div><small class="text-white text-opacity-75">All payments as you became a student including alimni, certificate and transcript payments</small>
                                                <a class="btn btn-lg btn-success" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("Student"))%>">Proceed</a>
                                            </div>
                                        </div>
                                    </div>
                                 <div class="col-12 col-sm-6 col-xl-4 col-xxl-4">
                                        <div class="card text-white bg-danger">
                                            <div class="card-body">
                                                <div class="fs-4 fw-semibold">PAYMENT MAKE-UP</div>
                                                <div>To add up wrong payments</div>
                                                <div class="progress progress-white progress-thin my-2">
                                                    <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div><small class="text-white text-opacity-75">This is used to make-up payments that have been wrongly paid for. This can be due to wrong payment setup</small>
                                                <a class="btn btn-lg btn-success" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("Makeup"))%>">Proceed</a>
                                            </div>
                                        </div>
                                    </div>

                                <!-- /.col-->
                                
<!--                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-4">
                                        <div class="card text-white bg-warning">
                                            <div class="card-body">
                                                <div class="fs-4 fw-semibold">OTHERS</div>
                                                <div>For contractors</div>
                                                <div class="progress progress-white progress-thin my-2">
                                                    <div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                                                </div><small class="text-white text-opacity-75">This is for general payments that does not relate to students or applicants profile.</small>
                                                <a class="btn btn-lg btn-success" href="/epayment?id=<%=settings.encodeUrl(settings.encryptText("General"))%>">Proceed</a>
                                            </div>
                                        </div>
                                    </div>-->
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