<%-- 
    Manual Payment Verification Page
    Use this when CREDO callbacks are not working
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>

<%
    String txnRef = request.getParameter("txn_ref");
    String action = request.getParameter("action");
    String message = "";
    String style = "info";
    
    if ("verify".equals(action) && txnRef != null && !txnRef.trim().isEmpty()) {
        try {
            // Look up payment reference
            Paymentreference pr = sess.getPaymentreference(txnRef);
            
            if (pr != null) {
//                System.out.println("=== MANUAL VERIFICATION STARTED ===");
//                System.out.println("Transaction Reference: " + txnRef);
//                System.out.println("Payment Amount: " + pr.getAmount());
//                System.out.println("Payer: " + pr.getPayerName());
                
                // Force simulation mode for manual verification
                String verify = "{"
                        + "\"status\":true,"
                        + "\"message\":\"Payment verified successfully (MANUAL VERIFICATION)\","
                        + "\"reference\":\"" + txnRef + "\","
                        + "\"gateway_response\":\"success\","
                        + "\"Amount\":" + pr.getAmount() + ","
                        + "\"ResponseCode\":\"0\","
                        + "\"ResponseDescription\":\"Payment verified successfully (MANUAL)\","
                        + "\"PaymentReference\":\"" + txnRef + "\","
                        + "\"CardNumber\":\"CREDO-MANUAL\""
                    + "}";
                
                // Process the payment using simulation response
                com.google.gson.Gson gson = new com.google.gson.Gson();
                PaymentNotification resp = gson.fromJson(verify, PaymentNotification.class);
                
                if (resp != null) {
                    // Update payment reference
                    pr.setResponseText("Payment verified successfully (MANUAL)");
                    pr.setPaymentRef(txnRef);
                    pr.setBankCode("CREDO-MANUAL");
                    pr.setBankName("CREDO Manual Verification");
                    pr.setDatePaid(settings.getCurrentDateTime());
                    pr.setPaidStatus("PAID");
                    
                    // Update in database
                    sess.updatePaymentreference(txnRef, 
                        "Payment verified successfully (MANUAL)", 
                        txnRef, 
                        "CREDO-MANUAL",
                        "CREDO Manual Verification", 
                        settings.getCurrentDateTime(), 
                        "SUCCESSFUL");
                    
                    // Create payment record
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
                        } catch (Exception k) {}
                        
                        pay.setCourseId(co);
                        pay.setFeesGroupId(pr.getFeesGroupId());
                        pay.setProgrammeId(prog);
                        pay.setSchoolId(pr.getSchoolId());
                        pay.setLevel(pr.getLevel());
                        
                        // Create or get bank record
                        Banks ban = null;
                        try {
                            ban = sess.getBanks("CREDO-MANUAL");
                            if (ban == null) {
                                ban = new Banks("CREDO-MANUAL");
                                ban.setName("CREDO Manual Verification");
                                sess.newEntry(ban);
                            }
                        } catch (Exception k) {}
                        
                        pay.setBankId(ban);
                        sess.newEntry(pay);
                        
                        message = "Payment verified and processed successfully! Receipt is now available.";
                        style = "success";
                        
                        System.out.println("Manual verification completed successfully");
                        
                    } catch (Exception e) {
                        System.err.println("Error creating payment record: " + e.getMessage());
                        message = "Payment verified but error creating payment record: " + e.getMessage();
                        style = "warning";
                    }
                } else {
                    message = "Error processing manual verification";
                    style = "danger";
                }
                
            } else {
                message = "Payment reference not found: " + txnRef;
                style = "danger";
            }
            
        } catch (Exception e) {
            message = "Error during manual verification: " + e.getMessage();
            style = "danger";
            e.printStackTrace();
        }
    }
%>

<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - Manual Payment Verification</title>
</head>

<body>
    <div class="wrapper d-flex flex-column min-vh-100">
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5>Manual Payment Verification</h5>
                                <small class="text-muted">Use this tool when CREDO callbacks are not working</small>
                            </div>
                            <div class="card-body">
                                
                                <% if (!message.isEmpty()) { %>
                                <div class="alert alert-<%=style%>">
                                    <%=message%>
                                    <% if (style.equals("success")) { %>
                                    <br><br>
                                    <a href="/DownloadReceipt?id=<%=txnRef%>" class="btn btn-success">Download Receipt</a>
                                    <% } %>
                                </div>
                                <% } %>
                                
                                <form method="post" action="manual-verification.jsp">
                                    <input type="hidden" name="action" value="verify">
                                    
                                    <div class="mb-3">
                                        <label for="txn_ref" class="form-label">Transaction Reference</label>
                                        <input type="text" class="form-control" id="txn_ref" name="txn_ref" 
                                               value="<%=txnRef != null ? txnRef : ""%>" 
                                               placeholder="Enter transaction reference (e.g., 20260108401996)" required>
                                        <div class="form-text">
                                            Enter the transaction reference from the payment logs or CREDO dashboard
                                        </div>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Verify Payment</button>
                                    <a href="/epayment" class="btn btn-secondary">Back to Payments</a>
                                </form>
                                
                                <hr>
                                
                                <div class="mt-4">
                                    <h6>Instructions:</h6>
                                    <ol>
                                        <li>Get the transaction reference from the server logs or CREDO dashboard</li>
                                        <li>Enter the reference in the field above</li>
                                        <li>Click "Verify Payment" to manually process the payment</li>
                                        <li>If successful, the receipt will be generated and available for download</li>
                                    </ol>
                                    
                                    <div class="alert alert-warning mt-3">
                                        <strong>Note:</strong> This tool should only be used when CREDO callbacks are not working properly. 
                                        It creates a manual payment record based on the transaction reference.
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
</body>
</html>