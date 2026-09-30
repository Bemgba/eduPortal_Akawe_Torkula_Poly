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
    InterswitchUtil paymentUtil = new InterswitchUtil();// Keep same class, updated internally for CREDO
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
    String verify = null; // Declare verify variable
    
    // SIMULATION DISABLED: Comment out simulation for testing real CREDO API
    /*
    String simulationStatus = request.getParameter("status");
    if ("simulation".equals(simulationStatus)) {
        // Create a simulated successful payment response for testing
        resp = new PaymentNotification();
        resp.setAmount(pr.getAmount());
        resp.setPaymentReference(pr.getId());
        resp.setResponseDescription("Simulated successful payment for testing");
        resp.setCardNumber("SIMULATION");
        resp.setResponseCode("00"); // Set success response code for simulation
        // Set CREDO success fields for simulation
        resp.setStatus(true);
        resp.setMessage("Payment successful (simulation)");
        resp.setReference(pr.getId());
        resp.setGateway_response("success");
        verify = "simulation_success";
    } else {
    */
        //String verify = paymentUtil.getPaymentNotification(pr.getId(), pr.getAmount());// Interswitch
        // CREDO Integration: Replace Interswitch payment verification with CREDO API call
        verify = paymentUtil.getPaymentNotification(pr.getId(), pr.getAmount()); // Updated internally to call CREDO verify endpoint
    //}
    if (verify != null && verify.trim().length() > 0) {
        Gson gson = new Gson();
        try {
            // SIMULATION DISABLED: Parse CREDO JSON response directly
            //resp = gson.fromJson(verify, PaymentNotification.class);
            // CREDO Integration: Parse CREDO JSON response instead of Interswitch response
            resp = gson.fromJson(verify, PaymentNotification.class); // PaymentNotification updated for CREDO response structure

        } catch (Exception ka) {
            // JSON parsing error - likely invalid CREDO API response
            style = "danger";
            msg = "CREDO API Response Error - Invalid response format received from CREDO payment service. Raw response: " + (verify != null ? verify.substring(0, Math.min(verify.length(), 200)) + "..." : "null");
            link = "/epayment";
            linkText = "Try Again";
            
            // Log the parsing error
            System.err.println("CREDO JSON Parsing Error: " + ka.getMessage());
            System.err.println("Raw CREDO Response: " + verify);
            ka.printStackTrace();
        }
        if (resp == null) {
            response.sendRedirect("/epayment");
        }
        // CREDO Integration: Replace Interswitch success codes with CREDO success condition
        // OLD: if ("10;11;00".contains(resp.getResponseCode())) {
        if (resp.isSuccessful()) { // Use CREDO success check - updated PaymentNotification.isSuccessful() method
            style = "success";
            status = "SUCCESSFUL";

            try {
                // pr.setAmountPaid((float) resp.getAmount());
                String bankCode = "WebPay";
                Banks ban = null;
                try {
                    //bankCode = resp.getPaymentReference().split("\\|")[0];
                    // CREDO Integration: Update bank code extraction for CREDO response format with null check
                    if (resp.getPaymentReference() != null && resp.getPaymentReference().contains("|")) {
                        bankCode = resp.getPaymentReference().split("\\|")[0]; // May need adjustment for CREDO response
                    } else {
                        bankCode = "CREDO"; // Default bank code for CREDO payments
                    }

                } catch (Exception k) {
                    bankCode = "CREDO"; // Fallback bank code
                }
                // CREDO Integration: Set payment reference data with null checks
                pr.setResponseText(resp.getResponseDescription() != null ? resp.getResponseDescription() : "Payment successful");
                pr.setPaymentRef(resp.getPaymentReference() != null ? resp.getPaymentReference() : pr.getId());
                pr.setBankCode(bankCode);
                pr.setBankName(resp.getCardNumber() != null ? resp.getCardNumber() : "CREDO");
                pr.setDatePaid(settings.getCurrentDateTime());
                pr.setPaidStatus("PAID");

//                pr.setResponseText(resp.getResponseDescription());
//                pr.setPaymentRef(resp.getPaymentReference());
//                pr.setBankCode(bankCode);
//                pr.setBankName(resp.getCardNumber());
//                pr.setDatePaid(settings.getCurrentDateTime());
//                pr.setPaidStatus("PAID");
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
//                sess.updatePaymentreference(id, resp.getResponseDescription(), resp.getPaymentReference(), bankCode,
//                resp.getCardNumber(), settings.getCurrentDateTime(), status);
                // CREDO Integration: Update payment reference with CREDO response data (with null checks)
                sess.updatePaymentreference(id, 
                    resp.getResponseDescription() != null ? resp.getResponseDescription() : "Payment successful", 
                    resp.getPaymentReference() != null ? resp.getPaymentReference() : pr.getId(), 
                    bankCode,
                    resp.getCardNumber() != null ? resp.getCardNumber() : "CREDO", 
                    settings.getCurrentDateTime(), 
                    status);

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
                    // PRODUCTION: Add proper error logging for live deployment instead of silent catch
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
        
        // CREDO Integration: Handle error response codes with null checks
        if (resp.getResponseCode() != null) {
            //        if (resp.getResponseCode().equalsIgnoreCase("09")) {
            if (resp.getResponseCode().equalsIgnoreCase("03")) {
                style = "warning";
                String dsid = settings.encryptText(pr.getId());
                dsid = settings.encodeUrl(dsid);
                link = "#";
                linkText = "No action";
                msg = "Your payment was not successfuly: " + resp.getResponseCode() + " - " + (resp.getResponseDescription() != null ? resp.getResponseDescription() : "Unknown error") + ".";
            }
        }
        
        if (status.equalsIgnoreCase("danger")) {
            style = "danger";
            String dsid = settings.encryptText(pr.getId());
            dsid = settings.encodeUrl(dsid);
            link = "epayment.jsp?id=" + dsid;
            linkText = "Try again";
            // Add null check for ResponseCode
            String responseCode = (resp.getResponseCode() != null) ? resp.getResponseCode() : "UNKNOWN";
            String responseDesc = (resp.getResponseDescription() != null) ? resp.getResponseDescription() : "Unknown error";
            msg = "Your payment was not successfuly: " + responseCode + " - " + responseDesc + ".";
        }

    } else {
        // No verification response received - show CREDO API connection error
        style = "danger";
        msg = "CREDO Payment API Connection Failed - Unable to verify payment status. Please check CREDO API connectivity at: " + settings.credo_base_url + "/transaction/verify/" + id;
        link = "/epayment";
        linkText = "Try Again";
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
                                                
                                                <!-- Show CREDO API debugging information for errors -->
                                                <% if (style.equals("danger")) { %>
                                                <div class="mt-3 p-3" style="background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 5px;">
                                                    <h6><strong>CREDO API Debug Information:</strong></h6>
                                                    <p><strong>Base URL:</strong> <%=settings.credo_base_url%></p>
                                                    <p><strong>Verify Endpoint:</strong> <%=settings.credo_base_url%>/transaction/verify/<%=id%></p>
                                                    <!--<p><strong>Public Key:</strong> < %=settings.credo_public_key%></p>-->
                                                    <!--<p><strong>Business Code:</strong> < %=settings.credo_business_code%></p>-->
                                                    <p><strong>Transaction ID:</strong> <%=id%></p>
                                                    <% if (verify != null) { %>
                                                    <p><strong>API Response:</strong> <code><%=verify.length() > 500 ? verify.substring(0, 500) + "..." : verify%></code></p>
                                                    <% } else { %>
                                                    <p><strong>API Response:</strong> <span class="text-danger">No response received</span></p>
                                                    <% } %>
                                                </div>
                                                <% } %>
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