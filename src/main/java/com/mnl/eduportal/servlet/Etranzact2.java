/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet;

import com.mnl.eduportal.entities.Users;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Programmes;
import com.mnl.eduportal.entities.Schools;
import com.mnl.eduportal.entities.Schoolprogrammes;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.ServiceCodeUtil;
import jakarta.ejb.EJB;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.GregorianCalendar;
import org.json.JSONObject;

/**
 *
 * @author BDIC
 */
@WebServlet({"/Etranzact2"})
public class Etranzact2 extends HttpServlet {

    private static final long serialVersionUID = 1L;

    Settings settings = new Settings();

    @EJB
    MainSession sess;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Security: Add security headers
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Security: Validate session
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
        
        // Security: Add basic rate limiting check (should be enhanced with proper implementation)
        // TODO: Implement proper rate limiting with database/cache
        
        try {
            // Use CREDO credentials from Settings.java
            String liveBaseUrl = settings.credo_base_url + "/transaction";
            String authKey = settings.credo_public_key; // Try PUBLIC key with direct format
            
            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String phone = request.getParameter("customer_phone");
            String email = request.getParameter("customer_email");
            String servicecharge = request.getParameter("amount");
            String encryptedId = request.getParameter("id");

            // Security: Input validation and sanitization
            if (email == null || email.trim().isEmpty() || email.equals("null")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters");
                return;
            }

            if (phone == null || phone.trim().isEmpty() || phone.equals("null")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters");
                return;
            }
            
            if (servicecharge == null || servicecharge.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters");
                return;
            }
            
            // Security: Validate email format
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters");
                return;
            }
            
            // Security: Validate phone format (basic)
            if (!phone.matches("^[0-9+\\-\\s()]{10,15}$")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request parameters");
                return;
            }
            
            // Security: Sanitize names
            if (firstname != null) {
                firstname = firstname.replaceAll("[^a-zA-Z\\s\\-']", "").trim();
                if (firstname.length() > 50) firstname = firstname.substring(0, 50);
            }
            if (lastname != null) {
                lastname = lastname.replaceAll("[^a-zA-Z\\s\\-']", "").trim();
                if (lastname.length() > 50) lastname = lastname.substring(0, 50);
            }

            // Security: Validate amount range
            double value;
            try {
                String cleanAmount = servicecharge.replace(",", "");
                value = Double.parseDouble(cleanAmount);
                
                // Security: Validate amount is reasonable (between 100 and 10,000,000 Naira)
                if (value < 100.0 || value > 10000000.0) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount range");
                    return;
                }
            } catch (NumberFormatException numEx) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount format");
                return;
            }

            // Security: Decrypt and validate payment ID
            String id = null;
            try {
                id = this.settings.decryptText(encryptedId);
                // Security: Validate decrypted ID format
                if (id == null || id.trim().isEmpty() || !id.matches("^[a-zA-Z0-9]{10,50}$")) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payment reference");
                    return;
                }
            } catch (Exception decryptEx) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payment reference");
                return;
            }
            String ref = id;
            
            // Determine school ID from programme and get appropriate CREDO service code
            String schoolId = null;
            String serviceCode = null;
            
            try {
                // Try to get school ID from payment reference and programme relationships
                Paymentreference payRef = (Paymentreference) sess.getSingleObject(Paymentreference.class, ref);
                if (payRef != null) {
                    // Method 1: Get school ID directly from payment reference if available
                    if (payRef.getSchoolId() != null) {
                        schoolId = payRef.getSchoolId().getId();
                        System.out.println("Etranzact2: Found school ID from payment reference: " + schoolId);
                    }
                    
                    // Method 2: Get school ID from programme via schoolprogrammes relationship
                    if (schoolId == null) {
                        // Check session for programme ID (common for applicant payments)
                        Object sessionProgrammeId = request.getSession().getAttribute("PROGRAMME_ID");
                        if (sessionProgrammeId != null) {
                            try {
                                // Find schoolprogrammes that matches the programme
                                String programmeIdStr = sessionProgrammeId.toString();
                                System.out.println("Etranzact2: Looking for school via programme ID: " + programmeIdStr);
                                
                                // Query to find school from programme via schoolprogrammes
                                // This assumes you have a method in MainSession to find schoolprogrammes by programme
                                // For now, we'll use a direct query approach
                                String queryStr = "SELECT sp FROM Schoolprogrammes sp WHERE sp.programmeId.id = :programmeId";
                                Schoolprogrammes schoolProg = (Schoolprogrammes) sess.getEntityManager()
                                    .createQuery(queryStr)
                                    .setParameter("programmeId", Integer.valueOf(programmeIdStr))
                                    .setMaxResults(1)
                                    .getSingleResult();
                                
                                if (schoolProg != null && schoolProg.getSchoolId() != null) {
                                    schoolId = schoolProg.getSchoolId().getId();
                                    System.out.println("Etranzact2: Found school ID via programme relationship: " + schoolId);
                                }
                                
                            } catch (Exception e) {
                                System.err.println("Etranzact2: Error finding school from programme: " + e.getMessage());
                            }
                        }
                    }
                    
                    // Method 3: Check session for direct school ID
                    if (schoolId == null) {
                        Object sessionSchoolId = request.getSession().getAttribute("SCHOOL_ID");
                        if (sessionSchoolId != null) {
                            schoolId = sessionSchoolId.toString();
                            System.out.println("Etranzact2: Found school ID in session: " + schoolId);
                        }
                    }
                }
                
                // Get service code using school-based hardcoded logic
                serviceCode = ServiceCodeUtil.getServiceCodeForSchool(schoolId);
                
                // Update payment reference with appropriate bank information based on service code
                if (payRef != null) {
                    String bankId = ServiceCodeUtil.getBankIdForSchool(schoolId);
                    payRef.setBankId(bankId);
                    payRef.setBankCode(bankId);
                    
                    // Set bank name based on school type
                    if (ServiceCodeUtil.isSpecialSchool(schoolId)) {
                        payRef.setBankName("Special School Account (Full Time)");
                    } else {
                        payRef.setBankName("General Schools Account (Consultacy Service)");
                    }
                    
                    sess.updateObject(payRef);
                    System.out.println("Etranzact2: " + ServiceCodeUtil.getServiceCodeDescription(schoolId));
                }
                
            } catch (Exception e) {
                System.err.println("Etranzact2: Error determining school service code: " + e.getMessage());
                // Use default service code if error occurs
                serviceCode = ServiceCodeUtil.getServiceCodeForSchool(null);
            }
            
            // Generate date for logging
            GregorianCalendar cal = new GregorianCalendar();
            cal.setTime(new Date());
            int year = cal.get(1);
            int month = cal.get(2) + 1;
            int day = cal.get(5);
            String date = String.format("%04d-%02d-%02d", new Object[]{year, month, day});
        Users user = (Users) request.getSession().getAttribute("USER");
        Users owner = (Users) request.getSession().getAttribute("owner");
            double finalAmount = value;
            Object applicantSession = request.getSession().getAttribute("APPX");
            if (applicantSession != null) {
                //This is an applicant payment - add 12% surcharge
                double surchargeRate = 0.12; // 12%
                double surchargeAmount = value * surchargeRate;
                finalAmount = value + surchargeAmount;
                System.out.println("Etranzact2: Applicant payment detected. Original: ₦" + value + ", Surcharge (12%): ₦" + surchargeAmount + ", Final: ₦" + finalAmount);
            }
            
            // Convert final amount to kobo (CREDO expects amount in kobo)
            double amount = finalAmount * 100.0D;
            
            // Generate callback URL
            String callbackUrl;
            if (request.getServerPort() == 80 || request.getServerPort() == 443) {
                callbackUrl = request.getScheme() + "://" + request.getServerName() + "/confirmation";
            } else {
                callbackUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/confirmation";
            }
            
            String narration = "Payment Processing ";
            //Create CREDO payment request JSON with service code
            JSONObject data = new JSONObject();
            data.put("amount", amount);
            data.put("currency", "NGN");
            data.put("reference", ref);
            data.put("callback_url", callbackUrl);
            data.put("email", email);
            
            // Add CREDO service code for programme-specific bank routing
            if (serviceCode != null && !serviceCode.trim().isEmpty()) {
                data.put("service_code", serviceCode);
                System.out.println("Etranzact2: Using CREDO service code: " + serviceCode + " for payment reference: " + ref);
            } else {
                System.out.println("Etranzact2: No service code determined for payment reference: " + ref);
            }

            // Customer information
            JSONObject customer = new JSONObject();
            String fullName = firstname + " " + lastname;
            customer.put("name", fullName);
            customer.put("email", email);
            customer.put("phone", phone);
            data.put("customer", customer);

            // Customization
            JSONObject customization = new JSONObject();
            customization.put("title", "Payment for atpoly");
            customization.put("description", narration);
            data.put("customization", customization);

        
        HttpURLConnection conn = null;
        OutputStream os = null;
        BufferedReader reader = null;
        
        try {
            // Create connection
            String fullUrl = liveBaseUrl + "/initialize";
            System.out.println("Etranzact2: Connecting to CREDO API: " + fullUrl);
            System.out.println("Etranzact2: Request payload: " + data.toString());
            System.out.println("Etranzact2: Authorization header: " + authKey);
            
            URL url = new URL(fullUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", authKey);
            conn.setRequestProperty("Content-Type", "application/json");
            // Performance & Security: Set connection timeouts and limits
            conn.setConnectTimeout(15000); // 15 seconds
            conn.setReadTimeout(30000);    // 30 seconds
            conn.setRequestProperty("User-Agent", "ATPOLY-Payment-System/1.0");
            
            System.out.println("Etranzact2: Connection configured successfully");
            
            // Security: Limit request size
            byte[] requestBytes = data.toString().getBytes("UTF-8");
            System.out.println("Etranzact2: Request size: " + requestBytes.length + " bytes");
            
            if (requestBytes.length > 8192) { // 8KB limit
                System.err.println("Etranzact2: Request too large: " + requestBytes.length + " bytes");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Request too large");
                return;
            }
            
            conn.setDoOutput(true);
            System.out.println("Etranzact2: Sending request to CREDO...");
            
            // Send request
            os = conn.getOutputStream();
            os.write(requestBytes);
            os.flush();
            System.out.println("Etranzact2: Request sent successfully to CREDO");
            
            // Get response code
            int responseCode = conn.getResponseCode();
            System.out.println("Etranzact2: CREDO API response code: " + responseCode);
            
            // Performance: Limit response size
            final int MAX_RESPONSE_SIZE = 16384; // 16KB limit
            
            // Read response based on status code
            StringBuilder content = new StringBuilder();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("Etranzact2: Reading successful response from CREDO...");
                // Success response
                reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
                String inputLine;
                int totalSize = 0;
                while ((inputLine = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) {
                    content.append(inputLine);
                    totalSize += inputLine.length();
                }
                
                System.out.println("Etranzact2: CREDO response received (" + content.length() + " chars): " + content.toString());
                
                // Parse successful response
                try {
                    JSONObject responseData = new JSONObject(content.toString());
                    System.out.println("Etranzact2: JSON parsing successful");
                    
                    if (responseData.has("status")) {
                        int statusCode = responseData.getInt("status");
                        boolean isSuccess = (statusCode == 200);
                        System.out.println("Etranzact2: CREDO status code: " + statusCode + ", isSuccess: " + isSuccess);
                        
                        if (isSuccess && responseData.has("data")) {
                            JSONObject dataObj = responseData.getJSONObject("data");
                            System.out.println("Etranzact2: Data object found in response");
                            
                            if (dataObj.has("authorizationUrl")) {
                                String authorizationUrl = dataObj.getString("authorizationUrl");
                                System.out.println("Etranzact2: Authorization URL received: " + authorizationUrl);
                                
                                // Security: Validate authorization URL
                                if (!authorizationUrl.startsWith("https://")) {
                                    System.err.println("Etranzact2: Security error - Invalid authorization URL: " + authorizationUrl);
                                    response.sendError(500, "Security error: Invalid authorization URL");
                                    return;
                                }
                                
                                // Success - redirect to CREDO payment page
                                System.out.println("Etranzact2: Redirecting to CREDO payment page: " + authorizationUrl);
                                request.getSession().setAttribute("authorizationUrl", authorizationUrl);
                                response.sendRedirect(authorizationUrl);
                                return;
                            } else {
                                System.err.println("Etranzact2: No authorizationUrl in CREDO response data");
                                System.err.println("Etranzact2: Available data keys: " + dataObj.keys().toString());
                                response.sendError(500, "Payment service error - No authorization URL");
                                return;
                            }
                        } else {
                            System.err.println("Etranzact2: CREDO API returned unsuccessful status or no data object");
                            System.err.println("Etranzact2: Status: " + statusCode + ", Has data: " + responseData.has("data"));
                            if (responseData.has("message")) {
                                System.err.println("Etranzact2: CREDO message: " + responseData.getString("message"));
                            }
                            // Security: Don't expose internal error details
                            response.sendError(500, "Payment initialization failed");
                            return;
                        }
                    } else {
                        System.err.println("Etranzact2: No status field in CREDO response");
                        System.err.println("Etranzact2: Available response keys: " + responseData.keys().toString());
                        response.sendError(500, "Payment service error - Invalid response format");
                        return;
                    }
                } catch (Exception jsonEx) {
                    System.err.println("Etranzact2: JSON parsing error: " + jsonEx.getMessage());
                    System.err.println("Etranzact2: Raw response: " + content.toString());
                    jsonEx.printStackTrace();
                    response.sendError(500, "Payment service error - Invalid response format");
                    return;
                }
                
            } else {
                System.err.println("Etranzact2: CREDO API returned error response code: " + responseCode);
                // Error response - don't expose internal details
                try {
                    reader = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
                    String errorLine;
                    int totalSize = 0;
                    while ((errorLine = reader.readLine()) != null && totalSize < MAX_RESPONSE_SIZE) {
                        content.append(errorLine);
                        totalSize += errorLine.length();
                    }
                    System.err.println("Etranzact2: CREDO error response: " + content.toString());
                } catch (Exception errorReadEx) {
                    System.err.println("Etranzact2: Error reading error response: " + errorReadEx.getMessage());
                    // Ignore error reading errors
                }
                
                // Security: Don't expose detailed error information
                System.err.println("Etranzact2: Sending 500 error to client");
                response.sendError(500, "Payment service temporarily unavailable");
                return;
            }
            
        } catch (Exception ex) {
            // Security: Don't expose internal error details
            System.err.println("Etranzact2: Exception during CREDO API call: " + ex.getClass().getSimpleName() + " - " + ex.getMessage());
            ex.printStackTrace();
            response.sendError(500, "Payment service error");
            return;
            
        } finally {
            System.out.println("Etranzact2: Cleaning up resources...");
            // Clean up resources
            if (reader != null) {
                try {
                    reader.close();
                    System.out.println("Etranzact2: Reader closed");
                } catch (IOException e) {
                    System.err.println("Etranzact2: Error closing reader: " + e.getMessage());
                    // Ignore cleanup errors
                }
            }
            
            if (os != null) {
                try {
                    os.close();
                    System.out.println("Etranzact2: OutputStream closed");
                } catch (IOException e) {
                    System.err.println("Etranzact2: Error closing OutputStream: " + e.getMessage());
                    // Ignore cleanup errors
                }
            }
            
            if (conn != null) {
                try {
                    conn.disconnect();
                    System.out.println("Etranzact2: Connection disconnected");
                } catch (Exception e) {
                    System.err.println("Etranzact2: Error disconnecting: " + e.getMessage());
                    // Ignore cleanup errors
                }
            }
        }
        
        } catch (Exception mainEx) {
            // Security: Don't expose internal error details
            System.err.println("Etranzact2: Main exception caught: " + mainEx.getClass().getSimpleName() + " - " + mainEx.getMessage());
            mainEx.printStackTrace();
            try {
                if (!response.isCommitted()) {
                    response.sendError(500, "Internal server error");
                }
            } catch (Exception responseEx) {
                System.err.println("Etranzact2: Error sending error response: " + responseEx.getMessage());
                // Ignore response errors
            }
        }
        
        System.out.println("Etranzact2: Method execution completed");
    }
}
