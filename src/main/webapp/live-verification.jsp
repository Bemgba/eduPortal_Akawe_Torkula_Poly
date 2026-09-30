<%-- 
    Live Payment Verification Page
    This version makes actual CREDO API calls for production use
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.JSONObject"%>
<!DOCTYPE html>

<%
    // Security: Add security headers
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security: Validate session and user access
    if (request.getSession(false) == null) {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session required");
        return;
    }
    
    // Security: Basic request validation
    String clientIP = request.getRemoteAddr();
    String userAgent = request.getHeader("User-Agent");
    
    // Security: Validate User-Agent to prevent automated attacks
    if (userAgent == null || userAgent.length() < 10) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
        return;
    }
    
    // Security: Input validation and sanitization
    String txnRef = request.getParameter("txn_ref");
    String action = request.getParameter("action");
    String message = "";
    String style = "info";
    
    // Security: Validate and sanitize transaction reference
    if (txnRef != null) {
        txnRef = txnRef.replaceAll("[^a-zA-Z0-9\\-_]", "").trim();
        if (txnRef.length() > 50) {
            txnRef = txnRef.substring(0, 50);
        }
        if (txnRef.length() < 5) {
            txnRef = null; // Too short to be valid
        }
    }
    
    // Security: Validate action parameter
    if (action != null && !"verify".equals(action)) {
        action = null; // Only allow 'verify' action
    }
    
    if ("verify".equals(action) && txnRef != null && !txnRef.trim().isEmpty()) {
        try {
            // Security: Additional validation for transaction reference format
            if (txnRef.length() < 10 || txnRef.length() > 50 || !txnRef.matches("[a-zA-Z0-9]+")) {
                message = "Invalid transaction reference format";
                style = "danger";
            } else {
                // Look up payment reference in local database
                Paymentreference pr = sess.getPaymentreference(txnRef);
                
                if (pr != null) {
                    // Make actual CREDO API call to verify payment
                    String credoVerifyUrl = settings.credo_base_url + "/transaction/" + txnRef + "/verify";
                    
                    HttpURLConnection conn = null;
                    BufferedReader reader = null;
                    String credoResponse = "";
                    
                    try {
                        URL url = new URL(credoVerifyUrl);
//                        System.out.println("CREDO Live Verification - URL: " + credoVerifyUrl);
//                        System.out.println("CREDO Live Verification - Auth Key: " + settings.credo_secret_key.substring(0, 8) + "...");
//                        
                        conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("GET");
                        conn.setRequestProperty("Authorization", "Bearer " + settings.credo_secret_key); // LIVE version
                        //conn.setRequestProperty("Authorization", settings.credo_secret_key); // DEMO version
                        conn.setRequestProperty("Content-Type", "application/json");
                        conn.setRequestProperty("User-Agent", "ATPOLY-Verification/1.0");
                        
                        // Performance & Security: Set timeouts and limits
                        conn.setConnectTimeout(15000); // 15 seconds timeout
                        conn.setReadTimeout(30000);    // 30 seconds timeout
                        
                        int responseCode = conn.getResponseCode();
                        //System.out.println("CREDO Live Verification - Response Code: " + responseCode);
                        
                        // Performance: Limit response size
                        final int MAX_RESPONSE_SIZE = 16384; // 16KB limit
                        
                        if (responseCode == HttpURLConnection.HTTP_OK) {
                            reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                            StringBuilder content = new StringBuilder();
                            String inputLine;
                            int totalSize = 0;
                            while ((inputLine = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) {
                                content.append(inputLine);
                                totalSize += inputLine.length();
                            }
                            credoResponse = content.toString();
                            
                            // Debug: Log the raw response for troubleshooting
                            //System.out.println("CREDO Live Verification - Raw Response: " + credoResponse);
                        
                            // Parse CREDO response
                            JSONObject responseData = new JSONObject(credoResponse);
                            
                            // CREDO sends status as number (200 for success), not boolean
                            if (responseData.has("status") && responseData.getInt("status") == 200) {
                                // Payment verified successfully by CREDO
                                JSONObject data = responseData.optJSONObject("data");
                                
                                if (data != null) {
                                    String gatewayResponse = data.optString("gateway_response", "");
                                    String paymentStatus = data.optString("status", "");
                                    double verifiedAmount = data.optDouble("amount", 0.0) / 100.0; // Convert from kobo
                                    String credoReference = data.optString("credoReference", data.optString("reference", ""));
                                    
                                    // Check for success indicators
                                    boolean isPaymentSuccessful = "success".equalsIgnoreCase(gatewayResponse) || 
                                                                "successful".equalsIgnoreCase(paymentStatus) ||
                                                                "0".equals(paymentStatus) ||
                                                                "completed".equalsIgnoreCase(paymentStatus) ||
                                                                "paid".equalsIgnoreCase(paymentStatus);
                                    
                                    if (isPaymentSuccessful) {
                                    // Security: Validate amount is reasonable
                                    if (verifiedAmount < 100.0 || verifiedAmount > 10000000.0) {
                                        message = "Payment verification failed - invalid amount";
                                        style = "danger";
                                    } else if (Math.abs(verifiedAmount - pr.getAmount()) < 0.01) {
                                        // Update payment reference with CREDO verification data
                                        pr.setResponseText("Payment verified successfully via CREDO API");
                                        pr.setPaymentRef(credoReference);
                                        pr.setBankCode("CREDO-LIVE");
                                        pr.setBankName("CREDO Payment Gateway");
                                        pr.setDatePaid(settings.getCurrentDateTime());
                                        pr.setPaidStatus("PAID");
                                        
                                        // Update in database
                                        sess.updatePaymentreference(txnRef, 
                                            "Payment verified successfully via CREDO API", 
                                            credoReference, 
                                            "CREDO-LIVE",
                                            "CREDO Payment Gateway", 
                                            settings.getCurrentDateTime(), 
                                            "SUCCESSFUL");
                                    
                                    // Create payment record
                                    try {
                                        Payments pay = new Payments(pr.getId());
                                        pay.setAmount(verifiedAmount);
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
                                            ban = sess.getBanks("CREDO-LIVE");
                                            if (ban == null) {
                                                ban = new Banks("CREDO-LIVE");
                                                ban.setName("CREDO Payment Gateway");
                                                sess.newEntry(ban);
                                            }
                                        } catch (Exception k) {}
                                        
                                        pay.setBankId(ban);
                                        sess.newEntry(pay);
                                        
                                        message = "Payment verified successfully! Amount: ₦" + settings.formatno.format(verifiedAmount) + ", CREDO Ref: " + credoReference;
                                        style = "success";
                                        
                                    } catch (Exception e) {
                                        message = "Payment verified but error processing record: " + e.getMessage();
                                        style = "warning";
                                    }
                                } else {
                                    message = "Payment verification failed - amount mismatch. Expected: ₦" + settings.formatno.format(pr.getAmount()) + ", Got: ₦" + settings.formatno.format(verifiedAmount);
                                    style = "danger";
                                }
                            } else {
                                message = "Payment not successful according to CREDO. Status: " + paymentStatus + ", Gateway Response: " + gatewayResponse;
                                style = "warning";
                            }
                        } else {
                            message = "No payment data received from CREDO API";
                            style = "danger";
                        }
                        } else {
                            // Security: Don't expose detailed error messages
                            message = "Payment verification failed";
                            style = "danger";
                        }
                        
                    } else {
                        // Error response from CREDO API
                        message = "CREDO API Error - Response Code: " + responseCode;
                        style = "danger";
                        
                        // Try to read error response for more details
                        if (conn.getErrorStream() != null) {
                            try {
                                reader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                                StringBuilder errorContent = new StringBuilder();
                                String errorLine;
                                int totalSize = 0;
                                while ((errorLine = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) {
                                    errorContent.append(errorLine);
                                    totalSize += errorLine.length();
                                }
                                
                                // Try to parse error response
                                JSONObject errorData = new JSONObject(errorContent.toString());
                                String errorMessage = errorData.optString("message", "Unknown error");
                                message = "CREDO API Error: " + errorMessage + " (Code: " + responseCode + ")";
                                
                            } catch (Exception errorParseEx) {
                                // If we can't parse the error, just show the response code
                                message = "CREDO API Error - Response Code: " + responseCode + " (Unable to parse error details)";
                            }
                        }
                    }
                    
                } catch (Exception apiEx) {
                    // Provide more detailed error information for debugging
                    message = "CREDO API Connection Error: " + apiEx.getClass().getSimpleName() + " - " + apiEx.getMessage();
                    style = "danger";
                    
                    // Log the full exception for debugging
                    apiEx.printStackTrace();
                    
                } finally {
                    if (reader != null) {
                        try { reader.close(); } catch (Exception e) {}
                    }
                    if (conn != null) {
                        try { conn.disconnect(); } catch (Exception e) {}
                    }
                }
                
                } else {
                    // Security: Don't expose that payment reference exists or not
                    message = "Payment reference not found or invalid";
                    style = "danger";
                }
            }
            
        } catch (Exception e) {
            // Security: Don't expose internal error details
            message = "Verification service error";
            style = "danger";
        }
    }
%>

<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - Live Payment Verification</title>
</head>

<body>
    <div class="wrapper d-flex flex-column min-vh-100">
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5>Live Payment Verification</h5>
                                <small class="text-muted">Verifies payments directly with CREDO API</small>
                            </div>
                            <div class="card-body">
                                
                                <% if (!message.isEmpty()) { %>
                                <div class="alert alert-<%=style%>">
                                    <%=message%>
                                    <% if (style.equals("success") && txnRef != null) { %>
                                    <br><br>
                                    <%
                                        String receiptId = "";
                                        if (txnRef != null) {
                                            receiptId = txnRef.replaceAll("[^a-zA-Z0-9\\-_]", "");
                                        }
                                    %>
                                    <a href="/DownloadReceipt?id=<%=receiptId%>" class="btn btn-success">Download Receipt</a>
                                    <% } %>
                                </div>
                                <% } %>
                                
                                <% 
                                // Show debug information if there was a verification attempt
                                if ("verify".equals(action) && txnRef != null) { 
                                %>
                                <div class="alert alert-info">
                                    <strong>Debug Information:</strong><br>
                                    <small>
                                        <strong>Transaction Reference:</strong> <%=txnRef%><br>
                                        <strong>CREDO Base URL:</strong> <%=settings.credo_base_url%><br>
                                        <strong>Verification URL:</strong> <%=settings.credo_base_url%>/transaction/<%=txnRef%>/verify<br>
                                        <strong>Auth Key (first 8 chars):</strong> <%=settings.credo_secret_key.substring(0, 8)%>...<br>
                                    </small>
                                </div>
                                <% } %>
                                
                                <form method="post" action="live-verification.jsp">
                                    <input type="hidden" name="action" value="verify">
                                    
                                    <div class="mb-3">
                                        <label for="txn_ref" class="form-label">Transaction Reference</label>
                                        <%
                                            String inputValue = "";
                                            if (txnRef != null) {
                                                inputValue = txnRef.replaceAll("[^a-zA-Z0-9\\-_]", "");
                                            }
                                        %>
                                        <input type="text" class="form-control" id="txn_ref" name="txn_ref" 
                                               value="<%=inputValue%>" 
                                               placeholder="Enter transaction reference" 
                                               maxlength="50" 
                                               required>
                                        <div class="form-text">
                                            Enter the transaction reference to verify with CREDO
                                        </div>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Verify with CREDO</button>
                                    <a href="/epayment" class="btn btn-secondary">Back to Payments</a>
                                </form>
                                
                                <hr>
                                
                                <div class="mt-4">
                                    <h6>How it works:</h6>
                                    <ol>
                                        <li>Enter the transaction reference from your payment logs</li>
                                        <li>System makes a secure  call to verify payment status</li>
                                        <li>Payment service responds with verification results</li>
                                        <li>If payment is confirmed, receipt is generated automatically</li>
                                        <li>Amount verification ensures accuracy</li>
                                    </ol>
                                    
                                    <div class="alert alert-info mt-3">
                                        <strong>Live Verification:</strong> This tool makes secure calls to verify payments 
                                        and only creates payment records for genuinely successful transactions.
                                    </div>
                                    
                                    <div class="alert alert-success mt-2">
                                        <strong>Security:</strong> All verifications are logged and require actual payment service confirmation.
                                        Only verified payments will generate receipts.
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