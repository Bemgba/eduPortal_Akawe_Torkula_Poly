/*
 * CREDO Payment Platform Integration Utility
 * Replaces InterswitchUtil.java for CREDO payment processing
 */
package com.mnl.eduportal.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * CREDO Payment Platform Integration Utility
 * @author eaglescan
 */
public class CredoUtil {
    
    // CREDO Configuration - Update these with your CREDO credentials
    public String merchant_id = "YOUR_CREDO_MERCHANT_ID";
    public String api_key = "YOUR_CREDO_API_KEY";
    public String secret_key = "YOUR_CREDO_SECRET_KEY";
    public String base_url = "https://api.credocentral.com"; // CREDO API base URL
    public String verify_url = base_url + "/transaction/verify";
    public String initialize_url = base_url + "/transaction/initialize";
    public String currency_code = "NGN";
    public String mode = "LIVE"; // or "TEST"
    
    Settings settings = new Settings();

    public CredoUtil() {
    }

    /**
     * Verify payment status with CREDO
     * @param payref Payment reference
     * @param amount Expected amount
     * @return JSON response from CREDO API
     */
    public String getPaymentNotification(String payref, double amount) {
        String jsonResponse = null;
        try {
            HttpURLConnection urlConnection = null;
            BufferedReader reader = null;
            try {
                // CREDO verification endpoint
                String verifyUrl = this.verify_url + "/" + payref;
                
                URL url = new URL(verifyUrl);
                urlConnection = (HttpURLConnection) url.openConnection();
                urlConnection.setRequestMethod("GET");
                urlConnection.setRequestProperty("Content-Type", "application/json");
                urlConnection.setRequestProperty("Authorization", "Bearer" + this.secret_key);
                //urlConnection.setRequestProperty("Authorization", this.secret_key);//DEMO
                
                int responseCode = urlConnection.getResponseCode();
                
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
                    StringBuilder buffer = new StringBuilder();
                    String inputLine;
                    
                    while ((inputLine = reader.readLine()) != null) {
                        buffer.append(inputLine).append("\n");
                    }
                    
                    if (buffer.length() > 0) {
                        jsonResponse = buffer.toString();
                    }
                } else {
                    // Handle error response
                    reader = new BufferedReader(new InputStreamReader(urlConnection.getErrorStream()));
                    StringBuilder errorBuffer = new StringBuilder();
                    String errorLine;
                    
                    while ((errorLine = reader.readLine()) != null) {
                        errorBuffer.append(errorLine).append("\n");
                    }
                    
                    System.err.println("CREDO API Error: " + responseCode + " - " + errorBuffer.toString());
                }
                
            } catch (IOException e) {
                System.err.println("Error connecting to CREDO API: " + e.getMessage());
                e.printStackTrace();
            } finally {
                if (urlConnection != null) {
                    urlConnection.disconnect();
                }
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (final IOException e) {
                        System.err.println("Error closing reader: " + e.getMessage());
                    }
                }
            }

        } catch (Exception k) {
            System.err.println("Unexpected error in CREDO payment verification: " + k.getMessage());
            k.printStackTrace();
        }

        return jsonResponse;
    }
    
    /**
     * Initialize payment with CREDO
     * @param amount Payment amount
     * @param email Customer email
     * @param reference Payment reference
     * @param callbackUrl Callback URL
     * @return JSON response with payment URL
     */
    public String initializePayment(double amount, String email, String reference, String callbackUrl) {
        String jsonResponse = null;
        try {
            HttpURLConnection urlConnection = null;
            
            // Prepare request body
            String requestBody = String.format(
                "{\"amount\":%d,\"email\": \"%s\",\"reference\": \"%s\",\"callback_url\": \"%s\",\"currency\": \"%s\"}",
                (int)(amount * 100), // Convert to kobo
                email,
                reference,
                callbackUrl,
                currency_code
            );
            
            URL url = new URL(initialize_url);
            urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setRequestMethod("POST");
            urlConnection.setRequestProperty("Content-Type", "application/json");
            urlConnection.setRequestProperty("Authorization", "Bearer " + this.secret_key);
            urlConnection.setDoOutput(true);
            
            // Send request
            try (OutputStream os = urlConnection.getOutputStream()) {
                byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = urlConnection.getResponseCode();
            BufferedReader reader;
            
            if (responseCode == HttpURLConnection.HTTP_OK || responseCode == HttpURLConnection.HTTP_CREATED) {
                reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
            } else {
                reader = new BufferedReader(new InputStreamReader(urlConnection.getErrorStream()));
            }
            
            StringBuilder buffer = new StringBuilder();
            String inputLine;
            
            while ((inputLine = reader.readLine()) != null) {
                buffer.append(inputLine).append("\n");
            }
            
            jsonResponse = buffer.toString();
            reader.close();
            urlConnection.disconnect();
            
        } catch (Exception e) {
            System.err.println("Error initializing CREDO payment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return jsonResponse;
    }
    
    /**
     * Generate HMAC signature for webhook verification
     * @param payload Webhook payload
     * @return HMAC signature
     */
    public String generateSignature(String payload) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(secret_key.getBytes(), "HmacSHA512");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(payload.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            System.err.println("Error generating CREDO signature: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Verify webhook signature
     * @param payload Webhook payload
     * @param signature Received signature
     * @return true if signature is valid
     */
    public boolean verifySignature(String payload, String signature) {
        String expectedSignature = generateSignature(payload);
        return expectedSignature != null && expectedSignature.equals(signature);
    }
}