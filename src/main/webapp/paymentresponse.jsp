<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>
<%-- CREDO imports commented out - kept for revert reference
<%@page import="com.google.gson.Gson"%>
<%@page import="com.mnl.eduportal.util.CredoVerificationResponse"%>
--%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>

<%
    // ======================================================================
    // X-Card: XCard.java servlet has already verified the payment and
    // recorded it to the DB before forwarding here. Just read the attributes.
    // ======================================================================
    Boolean xcardSuccess = (Boolean) request.getAttribute("xcardIsSuccessful");
    String  xcardError   = (String)  request.getAttribute("xcardError");
    String  id           = (String)  request.getAttribute("xcardTransactionId");

    boolean isSuccessful = xcardSuccess != null && xcardSuccess;

    String style    = isSuccessful ? "success" : "danger";
    String link     = isSuccessful ? "/DownloadReceipt?id=" + id : "/epayment";
    String linkText = isSuccessful ? "Download Receipt" : "Try Again";
    String msg;
    if (xcardError != null) {
        msg = xcardError;
    } else if (isSuccessful) {
        msg = "Payment Successful! Your payment has been processed and verified. Reference: " + id;
    } else {
        String xcardMsg = (String) request.getAttribute("xcardResponseMessage");
        msg = "Payment Failed: " + (xcardMsg != null ? xcardMsg : "Please try again or contact support. Reference: " + id);
    }

    // Load Paymentreference for the display section below (unchanged)
    Paymentreference pr = null;
    String errorMessage = "";
    if (id != null) {
        try {
            pr = sess.getPaymentreference(id);
        } catch (Exception k) {
            errorMessage = "Could not load payment details.";
        }
    }
%>

<%--
    ======================================================================
    CREDO verification block - commented out, kept for revert reference.
    To revert to CREDO:
      1. Remove the X-Card scriptlet block above
      2. Uncomment the two imports at the top of this file
      3. Uncomment this entire block and close it with %>
    ======================================================================

    String reference = request.getParameter("reference");
    String id = request.getParameter("id");
    String trxref = request.getParameter("trxref");
    String transRef = request.getParameter("transRef");
    String transaction_id = request.getParameter("transaction_id");
    System.out.println("Callback parameters received:");
    System.out.println("- reference: " + reference);
    System.out.println("- id: " + id);
    System.out.println("- trxref: " + trxref);
    System.out.println("- transRef: " + transRef);
    System.out.println("- transaction_id: " + transaction_id);
    System.out.println("- status: " + request.getParameter("status"));
    System.out.println("- errorMessage: " + request.getParameter("errorMessage"));

    boolean hasValidParameters = (reference != null && reference.length() > 0) ||
                                (id != null && id.length() > 0) ||
                                (trxref != null && trxref.length() > 0) ||
                                (transRef != null && transRef.length() > 0) ||
                                (transaction_id != null && transaction_id.length() > 0);

    String transactionReference = null;
    if (reference != null && reference.length() > 0) {
        transactionReference = reference.replaceAll("[^a-zA-Z0-9\\-_]", "").substring(0, Math.min(reference.length(), 50));
    } else if (transRef != null && transRef.length() > 0) {
        transactionReference = transRef.replaceAll("[^a-zA-Z0-9\\-_]", "").substring(0, Math.min(transRef.length(), 50));
    } else if (id != null && id.length() > 0) {
        transactionReference = id.replaceAll("[^a-zA-Z0-9\\-_]", "").substring(0, Math.min(id.length(), 50));
    } else if (trxref != null && trxref.length() > 0) {
        transactionReference = trxref.replaceAll("[^a-zA-Z0-9\\-_]", "").substring(0, Math.min(trxref.length(), 50));
    } else if (transaction_id != null && transaction_id.length() > 0) {
        transactionReference = transaction_id.replaceAll("[^a-zA-Z0-9\\-_]", "").substring(0, Math.min(transaction_id.length(), 50));
    }

    System.out.println("Final transaction reference: " + transactionReference);

    String clientIP = request.getRemoteAddr();
    String userAgent = request.getHeader("User-Agent");

    boolean hasError = false;
    String errorMessage = "";

    String callbackStatus = request.getParameter("status");
    String callbackErrorMessage = request.getParameter("errorMessage");
    boolean callbackSuccess = false;

    if (callbackStatus != null) {
        callbackSuccess = "0".equals(callbackStatus) && "AUTHENTICATION_SUCCESSFUL".equals(callbackErrorMessage);
    }

    if (transactionReference == null || transactionReference.length() == 0) {
        hasError = true;
        errorMessage = "No transaction reference received from CREDO callback.";
    }

    InterswitchUtil paymentUtil = new InterswitchUtil();
    Paymentreference pr = null;

    if (!hasError) {
        try {
            pr = sess.getPaymentreference(transactionReference);
            if (pr == null) {
                hasError = true;
                errorMessage = "Payment reference not found for transaction reference: " + transactionReference;
            }
        } catch (Exception ka) {
            hasError = true;
            errorMessage = "Database error while looking up payment reference: " + ka.getMessage();
        }
    }

    id = transactionReference;
    String style = "danger";
    String msg = "";
    String link = "";
    String linkText = "";
    String status = "FAILED";
    CredoVerificationResponse resp = null;
    String verify = null;

    if (!hasError && pr != null) {
        String credoVerifyUrl = settings.credo_base_url + "/transaction/" + transactionReference + "/verify";
        try {
            java.net.URL url = new java.net.URL(credoVerifyUrl);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + settings.credo_secret_key);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);
            int responseCode = conn.getResponseCode();
            java.io.BufferedReader reader = null;
            StringBuilder content = new StringBuilder();
            final int MAX_RESPONSE_SIZE = 10240;
            if (responseCode == java.net.HttpURLConnection.HTTP_OK) {
                reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"));
                String line; int totalSize = 0;
                while ((line = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) { content.append(line); totalSize += line.length(); }
                verify = content.toString();
            } else {
                reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getErrorStream(), "UTF-8"));
                String line; int totalSize = 0;
                while ((line = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) { content.append(line); totalSize += line.length(); }
                verify = null;
            }
            if (reader != null) reader.close();
            conn.disconnect();
        } catch (Exception verifyEx) { verify = null; }
    }

    if (verify != null && verify.trim().length() > 0 && !hasError) {
        Gson gson = new Gson();
        try {
            resp = gson.fromJson(verify, CredoVerificationResponse.class);
        } catch (Exception ka) {
            hasError = true; style = "danger";
            msg = "Payment verification failed - Invalid response format received from payment service.";
            link = "/epayment"; linkText = "Try Again";
        }
        if (!hasError && resp != null) {
            boolean verificationSuccess = resp.isSuccessful();
            boolean finalSuccess = false;
            String successReason = "";
            if (verificationSuccess) { finalSuccess = true; successReason = "API verification successful"; }
            else if (callbackSuccess && resp.getStatus() == 200) { finalSuccess = true; successReason = "Callback indicates success with valid API response"; }
            else if (callbackSuccess && resp == null) { finalSuccess = true; successReason = "Callback indicates success (API verification unavailable)"; }

            if (finalSuccess) {
                style = "success"; status = "SUCCESSFUL";
                try {
                    String bankCode = "CREDO"; Banks ban = null;
                    pr.setResponseText(callbackSuccess ? "AUTHENTICATION_SUCCESSFUL" : resp.getResponseDescription());
                    pr.setPaymentRef(resp.getCredoReference() != null ? resp.getCredoReference() : resp.getPaymentReference());
                    pr.setBankCode(bankCode); pr.setBankName("CREDO");
                    pr.setDatePaid(settings.getCurrentDateTime()); pr.setPaidStatus("PAID");
                    try { ban = sess.getBanks(bankCode); if (ban == null) { ban = new Banks(bankCode); ban.setName("CREDO Payment Gateway"); sess.newEntry(ban); } } catch (Exception kw) {}
                    sess.updatePaymentreference(id, callbackSuccess ? "AUTHENTICATION_SUCCESSFUL" : resp.getResponseDescription(),
                        resp.getCredoReference() != null ? resp.getCredoReference() : resp.getPaymentReference(), bankCode, "CREDO", settings.getCurrentDateTime(), status);
                    try {
                        Payments pay = new Payments(pr.getId());
                        pay.setAmount(pr.getAmount()); pay.setDatePaid(settings.getCurrentDateTime());
                        pay.setPayerId(pr.getPayerId()); pay.setPayerRegistrationNo(pr.getPayerRegistrationIo());
                        pay.setPayerFullname(pr.getPayerName()); pay.setSessionPaid(pr.getSession());
                        pay.setSemesterPaid(pr.getSemester());
                        Courses co = null; Programmes prog = null;
                        try { co = sess.getCourses(pr.getCourseId()); if (co != null) { prog = co.getSchoolProgrammeId().getProgrammeId(); } } catch (Exception k) {}
                        pay.setCourseId(co); pay.setFeesGroupId(pr.getFeesGroupId()); pay.setProgrammeId(prog);
                        pay.setSchoolId(pr.getSchoolId()); pay.setLevel(pr.getLevel()); pay.setBankId(ban);
                        sess.newEntry(pay);
                    } catch (Exception k) {}
                } catch (Exception k) {}
                link = "/DownloadReceipt?id=" + id; linkText = "Download Receipt";
                msg = "Payment Successful! Your payment has been processed and verified successfully. " + successReason + ".";
            } else {
                style = "danger"; status = "FAILED";
                link = "/epayment?id=" + settings.encodeUrl(settings.encryptText(pr.getId())); linkText = "Try again";
                String responseCode = "FAILED"; String responseDesc = "Payment was not successful";
                if (!callbackSuccess && callbackErrorMessage != null && !callbackErrorMessage.equals("AUTHENTICATION_SUCCESSFUL")) {
                    responseDesc = callbackErrorMessage; responseCode = "CALLBACK_ERROR";
                } else if (resp != null) { responseCode = resp.getResponseCode(); responseDesc = resp.getResponseDescription(); }
                msg = "Payment Failed: " + responseCode + " - " + responseDesc + ".";
            }
            if (resp != null && resp.getResponseCode() != null && resp.getResponseCode().equalsIgnoreCase("03")) {
                style = "warning"; link = "#"; linkText = "No action";
                msg = "Your payment was not successful: " + resp.getResponseCode() + " - " + resp.getResponseDescription() + ".";
            }
        }
    } else if (hasError) {
        style = "danger";
        msg = "Payment callback error occurred. Please contact support if this persists.";
        link = "/epayment"; linkText = "Try Again";
    } else {
        style = "danger";
        if (callbackSuccess) {
            style = "success"; status = "SUCCESSFUL";
            msg = "Payment Successful! Verification completed via callback.";
            if (pr != null) {
                try {
                    sess.updatePaymentreference(id, "AUTHENTICATION_SUCCESSFUL", transactionReference, "CREDO", "CREDO", settings.getCurrentDateTime(), "SUCCESSFUL");
                    link = "/DownloadReceipt?id=" + id; linkText = "Download Receipt";
                } catch (Exception e) {}
            }
        } else {
            msg = "Payment Verification Failed - Unable to verify with CREDO API. Reference: " + transactionReference;
            link = "/epayment"; linkText = "Try Again";
        }
    }
--%>

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
                                    <a class="btn btn-sm btn-danger ms-auto me-1 d-print-none float-right" href="/epayment">
                                        <svg class="icon"><use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use></svg> Back</a>
                                    &nbsp;
                                    <a class="btn btn-sm btn-secondary ms-auto me-1 d-print-none" href="/invoice" onclick="javascript:window.print();">
                                        <svg class="icon"><use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use></svg> Print</a>
                                </div>
                                <div class="card-body">
                                    <% if (pr != null) { %>
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
                                                try { inwords = words.convertAmount(pr.getAmount()); } catch (Exception k) {}
                                            %>
                                            <div><%=inwords%></div>
                                        </div>
                                        <div class="col-sm-6">
                                            <h6 class="mb-3">Payer's Details</h6>
                                            <div><strong><%=pr.getPayerName()%></strong></div>
                                            <div><%=pr.getPayerRegistrationIo()%></div>
                                            <div><%=pr.getLevel()%></div>
                                            <%
                                                String cname = "None";
                                                try {
                                                    Courses cl = sess.getCourses(pr.getCourseId());
                                                    if (cl != null) { cname = cl.getName(); }
                                                } catch (Exception k) {}
                                            %>
                                            <div><%=cname%></div>
                                        </div>
                                    </div>
                                    <% } else { %>
                                    <div class="row mb-12">
                                        <div class="col-sm-12">
                                            <h6 class="mb-3">Transaction Details</h6>
                                            <div><strong>Transaction ID:</strong> <%=id != null ? id : "Unknown"%></div>
                                            <div><strong>Status:</strong> Unable to retrieve payment details</div>
                                            <div><strong>Reason:</strong> <%=errorMessage%></div>
                                        </div>
                                    </div>
                                    <% } %>

                                    <div class="row">
                                        <div class="col-lg-12 col-sm-5 ms-auto">
                                            <div class="alert alert-<%=style%> alert-dismissable">
                                                <%=msg.replaceAll("<script[^>]*>.*?</script>", "")%>
                                                <a class="btn btn-<%=style%> btn-lg float-right" href="<%=link%>">
                                                    <svg class="icon"><use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-download"></use></svg> <%=linkText%></a>
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
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>
