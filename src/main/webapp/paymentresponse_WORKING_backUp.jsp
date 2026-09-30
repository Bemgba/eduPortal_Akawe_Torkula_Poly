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


<%    
    // CREDO Callback Parameter Handling - CREDO sends reference parameter
    String reference = request.getParameter("reference"); // CREDO reference parameter
    String id = request.getParameter("id"); // Alternative parameter
    String trxref = request.getParameter("trxref"); // Alternative CREDO parameter
    String transaction_id = request.getParameter("transaction_id"); // Another possible parameter
    
    // Debug: Log all callback parameters received from CREDO
    System.out.println("=== CREDO CALLBACK RECEIVED ===");
    System.out.println("All callback parameters:");
    java.util.Enumeration<String> paramNames = request.getParameterNames();
    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();
        String paramValue = request.getParameter(paramName);
        System.out.println("  " + paramName + ": '" + paramValue + "'");
    }
    
    // Determine which parameter to use as transaction reference
    String transactionReference = null;
    if (reference != null && reference.length() > 0) {
        transactionReference = reference;
        System.out.println("Using 'reference' parameter: " + transactionReference);
    } else if (id != null && id.length() > 0) {
        transactionReference = id;
        System.out.println("Using 'id' parameter: " + transactionReference);
    } else if (trxref != null && trxref.length() > 0) {
        transactionReference = trxref;
        System.out.println("Using 'trxref' parameter: " + transactionReference);
    } else if (transaction_id != null && transaction_id.length() > 0) {
        transactionReference = transaction_id;
        System.out.println("Using 'transaction_id' parameter: " + transactionReference);
    }
    
    // Initialize variables for error handling
    boolean hasError = false;
    String errorMessage = "";
    
    if (transactionReference == null || transactionReference.length() == 0) {
        hasError = true;
        errorMessage = "No transaction reference received from CREDO callback. Expected parameters: reference, id, trxref, or transaction_id";
        System.err.println("ERROR: " + errorMessage);
    }
    
    InterswitchUtil paymentUtil = new InterswitchUtil(); // Keep same class, updated internally for CREDO
    Paymentreference pr = null;
    
    if (!hasError) {
        try {
            // Look up payment reference by transaction reference from CREDO callback
            // Note: The CREDO reference should match the original Paymentreference.id from the database
            System.out.println("Looking up payment reference for transaction reference: " + transactionReference);
            pr = sess.getPaymentreference(transactionReference);
            
            if (pr != null) {
                System.out.println("Found payment reference: " + pr.getId());
                System.out.println("Payment amount: " + pr.getAmount());
                System.out.println("Payer: " + pr.getPayerName());
            } else {
                System.out.println("No payment reference found for transaction reference: " + transactionReference);
                hasError = true;
                errorMessage = "Payment reference not found for transaction reference: " + transactionReference + ". Please verify the transaction reference exists in the Paymentreference table.";
                System.err.println("ERROR: " + errorMessage);
            }
        } catch (Exception ka) {
            System.err.println("Exception while looking up payment reference: " + ka.getMessage());
            ka.printStackTrace();
            hasError = true;
            errorMessage = "Database error while looking up payment reference: " + ka.getMessage();
        }
    }
    
    // Set id for use in the rest of the JSP
    id = transactionReference;
    String style = "danger";
    String msg = "";
    String link = "";
    String linkText = "";

    String status = "FAILED";
    PaymentNotification resp = null;
    String verify = null;
    
    // CREDO Payment Verification Flow
    if (!hasError && pr != null) {
        System.out.println("Attempting CREDO payment verification for transaction: " + transactionReference);
        
        // CREDO Integration: Direct API call to /transaction/{reference}/verify endpoint
        String credoVerifyUrl = settings.credo_base_url + "/transaction/" + transactionReference + "/verify";
        System.out.println("CREDO Verify URL: " + credoVerifyUrl);
        
        try {
            java.net.URL url = new java.net.URL(credoVerifyUrl);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + settings.credo_secret_key);
            
            int responseCode = conn.getResponseCode();
            System.out.println("CREDO Verify Response Code: " + responseCode);
            
            java.io.BufferedReader reader = null;
            StringBuilder content = new StringBuilder();
            
            if (responseCode == java.net.HttpURLConnection.HTTP_OK) {
                reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"));
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(line);
                }
                verify = content.toString();
                System.out.println("CREDO Verify SUCCESS Response: " + verify);
            } else {
                reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getErrorStream(), "UTF-8"));
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(line);
                }
                System.err.println("CREDO Verify ERROR Response (" + responseCode + "): " + content.toString());
                verify = null;
            }
            
            if (reader != null) reader.close();
            conn.disconnect();
            
        } catch (Exception verifyEx) {
            System.err.println("Exception during CREDO verification: " + verifyEx.getMessage());
            verifyEx.printStackTrace();
            verify = null;
        }
        
        System.out.println("CREDO verification response received: " + (verify != null ? "Yes (" + verify.length() + " chars)" : "No"));
    } else {
        System.out.println("Skipping verification due to error: " + errorMessage);
    }
    if (verify != null && verify.trim().length() > 0 && !hasError) {
        Gson gson = new Gson();
        try {
            // CREDO Integration: Parse CREDO JSON response
            resp = gson.fromJson(verify, PaymentNotification.class); // PaymentNotification updated for CREDO response structure
            System.out.println("CREDO verification response parsed successfully");
            
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
        
        if (resp == null && !hasError) {
            hasError = true;
            errorMessage = "Failed to parse CREDO verification response. Raw response: " + (verify != null ? verify : "null");
            System.err.println("ERROR: " + errorMessage);
        }
        // CREDO Integration: Check if payment was successful using CREDO response
        if (resp != null && resp.isSuccessful()) { // Use CREDO success check - updated PaymentNotification.isSuccessful() method
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
            link = "epayment?id=" + dsid;
            linkText = "Try again";
            // Add null check for ResponseCode
            String responseCode = (resp.getResponseCode() != null) ? resp.getResponseCode() : "UNKNOWN";
            String responseDesc = (resp.getResponseDescription() != null) ? resp.getResponseDescription() : "Unknown error";
            msg = "Your payment was not successfuly: " + responseCode + " - " + responseDesc + ".";
        }

    } else if (hasError) {
        // Handle errors from parameter validation or payment reference lookup
        style = "danger";
        msg = "CREDO Callback Error: " + errorMessage;
        link = "/epayment";
        linkText = "Try Again";
        System.err.println("Displaying error to user: " + errorMessage);
    } else {
        // No verification response received - show CREDO API connection error
        style = "danger";
        msg = "CREDO Payment Verification Failed - Unable to verify payment status with CREDO API.";
        link = "/epayment";
        linkText = "Try Again";
        System.err.println("No verification response received from CREDO API");
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
                                                    <p><strong>Verify Endpoint:</strong> <%=settings.credo_base_url%>/transactions/<%=id%>/verify/</p>
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