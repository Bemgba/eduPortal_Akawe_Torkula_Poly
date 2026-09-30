<%-- 
    Document   : updatePayments
    Created on : 29 Dec 2024, 07:54:24
    Author     : eaglescan
--%>

<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%            List<Paymentreference> list = sess.getPaymentreferenceByStatus("PENDING");
        %>
        <%=list.size()%> records
        <%
            for (Paymentreference pr : list) {
                String status = "FAILED";
                PaymentNotification resp = null;
                InterswitchUtil paymentUtil = new InterswitchUtil();
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
        %>
        <%=pr.getId()%> | <%=pr.getPayerRegistrationIo()%> | <%=pr.getPayerId()%> | <%=resp.getResponseCode()%><br/>
        <%
                    if ("10;11;00".contains(resp.getResponseCode())) {
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
                            sess.updatePaymentreference(pr.getId(), resp.getResponseDescription(), resp.getPaymentReference(), bankCode,
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

                    }

                }
            }
        %>
    </body>
</html>
