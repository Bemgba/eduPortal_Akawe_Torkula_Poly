<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>


<%    String id = request.getParameter("id");
    InterswitchUtil paymentUtil = new InterswitchUtil();
    if (id != null && id.length() > 0) {

    } else {
        response.sendRedirect("/epayment");
    }

    Paymentreference pr = null;
    try {
        pr = sess.getPaymentreference(id);
    } catch (Exception ka) {
    }
    if (pr == null) {
        response.sendRedirect("/epayment");
    }
    String style = "danger";
    String msg = "";
    String link = "";
    String linkText = "";

    String status = "FAILED";
    PaymentNotification resp = null;

    String verify = paymentUtil.getPaymentNotification(pr.getId(), pr.getAmount());
    if (verify != null && verify.trim().length() > 0) {
        Gson gson = new Gson();
        try {
            resp = gson.fromJson(verify, PaymentNotification.class);
        } catch (Exception ka) {
        }
        if (resp == null) {
            response.sendRedirect("/epayment");
        }
        if ("10;11;00".contains(resp.getResponseCode())) {
            style = "success";
            status = "SUCCESSFUL";
            try {
                // pr.setAmountPaid((float) resp.getAmount());
                String bankCode = "WebPay";
                Banks ban = null;
                try {
                    bankCode = resp.getPaymentReference().split("\\|")[0];
                } catch (Exception k) {
                }
                pr.setResponseText(resp.getResponseDescription());
                pr.setPaymentRef(resp.getPaymentReference());
                pr.setBankCode(bankCode);
                pr.setBankName(resp.getCardNumber());
                pr.setDatePaid(settings.getCurrentDateTime());
                pr.setPaidStatus("PAID");

                try {
                    ban = sess.getBanks(bankCode);
                    if (ban == null) {
                        ban = new Banks(bankCode);
                        ban.setName(bankCode);;
                        sess.newEntry(ban);;
                    }
                } catch (Exception kw) {
                    kw.printStackTrace();
                }
                sess.updatePaymentreference(id, resp.getResponseDescription(), resp.getPaymentReference(), bankCode,
                        resp.getCardNumber(), settings.getCurrentDateTime(), status);

                // sess.updateRecord(pr);
                try {
                    Payments pay = new Payments(pr.getId());
                    pay.setAmount(pr.getAmount());
                    pay.setDatePaid(settings.getCurrentDateTime());
                    pay.setPayerId(pr.getPayerId());
                    pay.setPayerRegistrationNo(pr.getPayerRegistrationIo());
                    pay.setPayerFullname(pr.getPayerName());
                    pay.setSessionPaid(pr.getSession());
                    pay.setSemesterPaid(pr.getSemester());
                    Courses co = null;
                    Programmes prog = null;
                    try {
                        co = sess.getCourses(pr.getCourseId());
                        if (co != null) {
                            prog = co.getSchoolProgrammeId().getProgrammeId();
                        }
                    } catch (Exception k) {
                    }
                    pay.setCourseId(co);
                    pay.setFeesGroupId(pr.getFeesGroupId());
                    pay.setProgrammeId(prog);
                    pay.setSchoolId(pr.getSchoolId());
                    pay.setLevel(pr.getLevel());
                    pay.setBankId(ban);

                    sess.newEntry(pay);
                } catch (Exception k) {
                }

            } catch (Exception k) {
            }
            style = "success";
            String dsid = settings.encryptText(id);
            dsid = settings.encodeUrl(dsid);
            link = "/DownloadReceipt?id=" + id;
            linkText = "Download Receipt";
            msg = "Your payment has been processed successfully.";

        }
        if (resp.getResponseCode().equalsIgnoreCase("09")) {
            style = "warning";
            String dsid = settings.encryptText(pr.getId());
            dsid = settings.encodeUrl(dsid);
            link = "#";
            linkText = "No action";
            msg = "Your payment was not successfuly: " + resp.getResponseCode() + " - " + resp.getResponseDescription() + ".";
        }
        if (status.equalsIgnoreCase("danger")) {
            style = "danger";
            String dsid = settings.encryptText(pr.getId());
            dsid = settings.encodeUrl(dsid);
            link = "epayment.jsp?id=" + dsid;
            linkText = "Try again";
            msg = "Your payment was not successfuly: " + resp.getResponseCode() + " - " + resp.getResponseDescription() + ".";
        }

    } else {
        response.sendRedirect("/epayment");
    }


%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Payment Confirmation</title>


    </head>


    <body>

        <div class="wrapper d-flex flex-column min-vh-100">

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="card">
                                <div class="card-header d-flex align-items-center">Payment confirmation for <strong><%=id%></strong>
                                    <a class="btn btn-sm btn-danger ms-auto me-1 d-print-none float-right" href="/epayment" >
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use>
                                        </svg> Back</a>
                                    &nbsp;
                                    <a class="btn btn-sm btn-secondary ms-auto me-1 d-print-none" href="/invoice" onclick="javascript:window.print();">
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use>
                                        </svg> Print</a>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-12">
                                        <div class="col-sm-6">
                                            <h6 class="mb-3">Payment Description</h6>
                                            <div><strong><%=pr.getFeesGroupId().getName()%></strong></div>
                                            <div><%=pr.getSession()%></div>
                                            <div><%=pr.getSemester()%></div>
                                            <div>N<%=settings.formatno.format(pr.getAmount())%></div>
                                            <%
                                                String inwords = pr.getAmount() + "";
                                                ConvertNumberToWord words = new ConvertNumberToWord();
                                                try {
                                                    inwords = words.convertAmount(pr.getAmount());
                                                } catch (Exception k) {
                                                }
                                            %>
                                            <div><%=inwords%></div>
                                        </div>
                                        <!-- /.col-->
                                        <div class="col-sm-6">
                                            <h6 class="mb-3">Payer's Details</h6>
                                            <div><strong><%=pr.getPayerName()%></strong></div>
                                            <div><%=pr.getPayerRegistrationIo()%></div>
                                            <div><%=pr.getLevel()%></div>
                                            <%
                                                String cname = "None";
                                                try {
                                                    Courses cl = sess.getCourses(pr.getCourseId());
                                                    if (cl != null) {
                                                        cname = cl.getName();
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>
                                            <div><%=cname%></div>
                                        </div>

                                    </div>


                                    <div class="row">
                                        <div class="col-lg-12 col-sm-5 ms-auto">
                                            <div class="alert alert-<%=style%> alert-dismissable">
                                                <%=msg%> 
                                                <a class="btn btn-<%=style%> btn-lg float-right" href="<%=link%>">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-download"></use>
                                                    </svg> <%=linkText%></a>

                                                <p/>
                                                <a href="/epayment" class="btn btn-sm btn-primary float-right">Make another payment</a>
                                            </div>


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


    </body>
</html>