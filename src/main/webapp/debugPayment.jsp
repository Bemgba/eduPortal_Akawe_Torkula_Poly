<%@page import="com.mnl.eduportal.util.Settings"%>
<%@page import="com.mnl.eduportal.util.ServiceCodeUtil"%>
<%@page import="com.mnl.eduportal.util.CredoVerificationResponse"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CREDO Payment Debug Tool</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .debug-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .success { background-color: #e8f5e8; }
        .error { background-color: #ffe8e8; }
        .info { background-color: #e8f0ff; }
        .code { font-family: monospace; background-color: #f5f5f5; padding: 2px 5px; }
        .log { background-color: #f0f0f0; padding: 10px; margin: 10px 0; font-family: monospace; white-space: pre-wrap; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>CREDO Payment System Debug Tool</h1>
    
    <%
        Settings settings = new Settings();
        String testReference = request.getParameter("testRef");
        String testSchool = request.getParameter("testSchool");
        
        if (testReference == null) testReference = "2026012633494";
        if (testSchool == null) testSchool = "S001";
    %>
    
    <div class="debug-section info">
        <h3>Configuration Check</h3>
        <table>
            <tr><th>Setting</th><th>Value</th><th>Status</th></tr>
            <tr>
                <td>CREDO Base URL</td>
                <td><span class="code"><%=settings.credo_base_url%></span></td>
                <td><%=settings.credo_base_url.contains("demo") ? "DEMO" : "LIVE"%></td>
            </tr>
            <tr>
                <td>CREDO Public Key</td>
                <td><span class="code"><%=settings.credo_public_key%></span></td>
                <td><%=settings.credo_public_key.length() > 10 ? "OK" : "INVALID"%></td>
            </tr>
            <tr>
                <td>CREDO Secret Key</td>
                <td><span class="code"><%=settings.credo_secret_key.substring(0, 8)%>...</span></td>
                <td><%=settings.credo_secret_key.length() > 10 ? "OK" : "INVALID"%></td>
            </tr>
        </table>
    </div>
    
    <div class="debug-section info">
        <h3>Service Code Logic Test</h3>
        <form method="get">
            <label>Test School ID: <input type="text" name="testSchool" value="<%=testSchool%>" /></label>
            <input type="hidden" name="testRef" value="<%=testReference%>" />
            <input type="submit" value="Test Service Code" />
        </form>
        
        <table>
            <tr><th>School ID</th><th>Service Code</th><th>Bank ID</th><th>Is Special</th></tr>
            <tr>
                <td><%=testSchool%></td>
                <td><span class="code"><%=ServiceCodeUtil.getServiceCodeForSchool(testSchool)%></span></td>
                <td><span class="code"><%=ServiceCodeUtil.getBankIdForSchool(testSchool)%></span></td>
                <td><%=ServiceCodeUtil.isSpecialSchool(testSchool)%></td>
            </tr>
        </table>
        <p><strong>Description:</strong> <%=ServiceCodeUtil.getServiceCodeDescription(testSchool)%></p>
    </div>
    
    <div class="debug-section info">
        <h3>Payment Verification Test</h3>
        <form method="get">
            <label>Test Reference: <input type="text" name="testRef" value="<%=testReference%>" /></label>
            <input type="hidden" name="testSchool" value="<%=testSchool%>" />
            <input type="submit" value="Test Verification" />
        </form>
        
        <%
            if (request.getParameter("testRef") != null) {
                String verifyUrl = settings.credo_base_url + "/transaction/" + testReference + "/verify";
                String verifyResponse = null;
                String errorMessage = null;
                int responseCode = 0;
                
                try {
                    java.net.URL url = new java.net.URL(verifyUrl);
                    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setRequestProperty("Content-Type", "application/json");
                    conn.setRequestProperty("Authorization", settings.credo_secret_key);
                    conn.setConnectTimeout(15000);
                    conn.setReadTimeout(30000);
                    
                    responseCode = conn.getResponseCode();
                    
                    java.io.BufferedReader reader = null;
                    StringBuilder content = new StringBuilder();
                    
                    if (responseCode == java.net.HttpURLConnection.HTTP_OK) {
                        reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"));
                    } else {
                        reader = new java.io.BufferedReader(new java.io.InputStreamReader(conn.getErrorStream(), "UTF-8"));
                    }
                    
                    String line;
                    while ((line = reader.readLine()) != null) {
                        content.append(line);
                    }
                    verifyResponse = content.toString();
                    
                    if (reader != null) reader.close();
                    conn.disconnect();
                    
                } catch (Exception e) {
                    errorMessage = e.getMessage();
                }
        %>
        
        <table>
            <tr><th>Property</th><th>Value</th></tr>
            <tr><td>Verify URL</td><td><span class="code"><%=verifyUrl%></span></td></tr>
            <tr><td>Response Code</td><td><span class="code"><%=responseCode%></span></td></tr>
            <tr><td>Error</td><td><span class="code"><%=errorMessage != null ? errorMessage : "None"%></span></td></tr>
        </table>
        
        <% if (verifyResponse != null) { %>
        <h4>Raw Response:</h4>
        <div class="log"><%=verifyResponse%></div>
        
        <% 
            try {
                Gson gson = new Gson();
                CredoVerificationResponse resp = gson.fromJson(verifyResponse, CredoVerificationResponse.class);
        %>
        <h4>Parsed Response:</h4>
        <table>
            <tr><th>Property</th><th>Value</th></tr>
            <tr><td>Status</td><td><span class="code"><%=resp.getStatus()%></span></td></tr>
            <tr><td>Message</td><td><span class="code"><%=resp.getMessage()%></span></td></tr>
            <tr><td>Is Successful</td><td><span class="code"><%=resp.isSuccessful()%></span></td></tr>
            <tr><td>Payment Status</td><td><span class="code"><%=resp.getPaymentStatus()%></span></td></tr>
            <tr><td>Payment Reference</td><td><span class="code"><%=resp.getPaymentReference()%></span></td></tr>
            <tr><td>CREDO Reference</td><td><span class="code"><%=resp.getCredoReference()%></span></td></tr>
            <tr><td>Response Code</td><td><span class="code"><%=resp.getResponseCode()%></span></td></tr>
            <tr><td>Response Description</td><td><span class="code"><%=resp.getResponseDescription()%></span></td></tr>
        </table>
        <%
            } catch (Exception e) {
        %>
        <h4>JSON Parsing Error:</h4>
        <div class="log"><%=e.getMessage()%></div>
        <%
            }
        %>
        <% } %>
        <% } %>
    </div>
    
    <div class="debug-section info">
        <h3>Payment Flow Endpoints</h3>
        <table>
            <tr><th>Endpoint</th><th>URL</th><th>Purpose</th></tr>
            <tr>
                <td>Initialize Payment</td>
                <td><span class="code"><%=settings.credo_base_url%>/transaction/initialize</span></td>
                <td>Start payment process</td>
            </tr>
            <tr>
                <td>Verify Payment</td>
                <td><span class="code"><%=settings.credo_base_url%>/transaction/{reference}/verify</span></td>
                <td>Check payment status</td>
            </tr>
            <tr>
                <td>Callback URL</td>
                <td><span class="code"><%=request.getScheme()%>://<%=request.getServerName()%>:<%=request.getServerPort()%>/confirmation</span></td>
                <td>CREDO callback endpoint</td>
            </tr>
        </table>
    </div>
    
    <div class="debug-section info">
        <h3>Common Issues & Solutions</h3>
        <ul>
            <li><strong>400 Bad Request:</strong> Invalid service code or request format</li>
            <li><strong>401 Unauthorized:</strong> Invalid API credentials</li>
            <li><strong>404 Not Found:</strong> Invalid reference or endpoint URL</li>
            <li><strong>Callback not received:</strong> CREDO cannot reach localhost URLs</li>
            <li><strong>JSON parsing error:</strong> Response format doesn't match expected structure</li>
        </ul>
    </div>
    
    <div class="debug-section info">
        <h3>Next Steps for LIVE Deployment</h3>
        <ol>
            <li>Update Settings.java with LIVE CREDO credentials</li>
            <li>Change callback URL to public domain (not localhost)</li>
            <li>Get valid LIVE service codes from CREDO support</li>
            <li>Test with small amounts first</li>
            <li>Monitor logs for any issues</li>
        </ol>
    </div>
    
    <p><a href="/epayment">← Back to Payment Page</a></p>
</body>
</html>