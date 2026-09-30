/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet;

import com.mnl.eduportal.util.Settings;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

/**
 * CREDO Payment Initialization Servlet
 * Handles server-side CREDO payment initialization to avoid CORS issues
 * 
 * @author BEMGBA
 */
@WebServlet(name = "CredoPaymentInit", urlPatterns = {"/CredoPaymentInit"})
public class CredoPaymentInit extends HttpServlet {

    private Settings settings = new Settings();

    /**
     * Handles the HTTP POST method for CREDO payment initialization.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Extract payment parameters from request
            String txnRef = request.getParameter("txn_ref");
            String amountStr = request.getParameter("amount");
            String currency = request.getParameter("currency");
            String redirectUrl = request.getParameter("redirect_url");
            String customerName = request.getParameter("customer_name");
            String customerEmail = request.getParameter("customer_email");
            String customerPhone = request.getParameter("customer_phone");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            
            // Validate required parameters
            if (txnRef == null || amountStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters: txnRef or amount");
                return;
            }
            
            // Validate customer email is not null or empty
            if (customerEmail == null || customerEmail.trim().isEmpty() || customerEmail.equals("null")) {
                request.setAttribute("errorType", "VALIDATION_ERROR");
                request.setAttribute("errorMessage", "Customer email is required for CREDO payment");
                request.setAttribute("errorDetails", "Email received: '" + customerEmail + "'. Please ensure customer has a valid email address.");
                request.setAttribute("txnRef", txnRef);
                request.getRequestDispatcher("/paymentError").forward(request, response);
                return;
            }
            
            double amount = Double.parseDouble(amountStr);
            
            // Create CREDO payment initialization request
            Map<String, Object> credoRequest = new HashMap<>();
            credoRequest.put("amount", amount);
            credoRequest.put("currency", currency != null ? currency : "NGN");
            credoRequest.put("reference", txnRef);
            credoRequest.put("callback_url", redirectUrl);
            
            // Customer information
            Map<String, String> customer = new HashMap<>();
            customer.put("name", customerName != null ? customerName : "Customer");
            customer.put("email", customerEmail);
            customer.put("phone", customerPhone != null ? customerPhone : "08000000000");
            credoRequest.put("customer", customer);
            
            // Customization
            Map<String, String> customization = new HashMap<>();
            customization.put("title", title != null ? title : "Payment");
            customization.put("description", description != null ? description : "Payment for services");
            credoRequest.put("customization", customization);
            
            // Convert to JSON
            Gson gson = new Gson();
            String jsonRequest = gson.toJson(credoRequest);
            
            // Make API call to CREDO
            String credoResponse = makeCredoApiCall(jsonRequest);
            
            if (credoResponse != null) {
                // Parse CREDO response
                Map<String, Object> responseMap = gson.fromJson(credoResponse, Map.class);
                
                if (responseMap.get("status").equals(true) && responseMap.get("data") != null) {
                    Map<String, Object> data = (Map<String, Object>) responseMap.get("data");
                    String authorizationUrl = (String) data.get("authorization_url");
                    
                    if (authorizationUrl != null) {
                        // Redirect to CREDO payment page
                        response.sendRedirect(authorizationUrl);
                        return;
                    }
                }
            }
            
            // If we reach here, payment initialization failed
            // SIMULATION DISABLED: Show actual CREDO API error instead of simulation
            /*
            // Fallback simulation for testing when CREDO API is unavailable
            String simulationUrl = request.getContextPath() + "/paymentresponse.jsp?id=" + txnRef + "&status=simulation";
            response.sendRedirect(simulationUrl);
            */
            
            // Show actual CREDO API connection error
            request.setAttribute("errorType", "CREDO_API_FAILED");
            request.setAttribute("errorMessage", "CREDO Payment API is not accessible at: " + settings.credo_base_url + "/transaction/initialize");
            request.setAttribute("errorDetails", "Please check CREDO API configuration and network connectivity.");
            request.setAttribute("txnRef", txnRef);
            request.getRequestDispatcher("/paymentError").forward(request, response);
            
        } catch (Exception e) {
            // PRODUCTION: Replace printStackTrace with proper error logging for live deployment
            e.printStackTrace();
            
            // SIMULATION DISABLED: Show actual error details
            /*
            // Fallback simulation for testing when there's an error
            try {
                String txnRef = request.getParameter("txn_ref");
                if (txnRef != null) {
                    String simulationUrl = request.getContextPath() + "/paymentresponse.jsp?id=" + txnRef + "&status=simulation";
                    response.sendRedirect(simulationUrl);
                    return;
                }
            } catch (Exception ex) {
                // Ignore simulation error
            }
            */
            
            // Show detailed error information
            String txnRef = request.getParameter("txn_ref");
            request.setAttribute("errorType", "CREDO_EXCEPTION");
            request.setAttribute("errorMessage", "Exception occurred while connecting to CREDO API: " + e.getMessage());
            request.setAttribute("errorDetails", "URL: " + settings.credo_base_url + "/transaction/initialize");
            request.setAttribute("txnRef", txnRef);
            request.setAttribute("exception", e.getClass().getSimpleName());
            request.getRequestDispatcher("/cpaymentError").forward(request, response);
        }
    }
    
    /**
     * Makes API call to CREDO payment initialization endpoint
     * 
     * @param jsonRequest JSON request body
     * @return CREDO API response as JSON string
     */
    private String makeCredoApiCall(String jsonRequest) {
        HttpURLConnection connection = null;
        BufferedReader reader = null;
        
        try {
            // CREDO API endpoint
            URL url = new URL(settings.credo_base_url + "/transaction/initialize");
            connection = (HttpURLConnection) url.openConnection();
            
            // Set request properties
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Authorization", settings.credo_public_key);
            connection.setDoOutput(true);
            
            // Send request body
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonRequest.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = connection.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                String responseStr = response.toString();
                return responseStr;
            } else {
                // Handle error response
                reader = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
                StringBuilder errorResponse = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    errorResponse.append(line);
                }
                
                // PRODUCTION: Replace System.err.println with proper error logging for live deployment
                System.err.println("CREDO API Error: " + responseCode + " - " + errorResponse.toString());
            }
            
        } catch (Exception e) {
            // PRODUCTION: Replace printStackTrace with proper error logging for live deployment
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    // PRODUCTION: Replace printStackTrace with proper error logging for live deployment
                    e.printStackTrace();
                }
            }
            if (connection != null) {
                connection.disconnect();
            }
        }
        
        return null;
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "CREDO Payment Initialization Servlet";
    }
}