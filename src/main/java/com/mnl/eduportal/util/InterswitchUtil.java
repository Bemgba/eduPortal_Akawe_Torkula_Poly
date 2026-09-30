/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import com.mnl.eduportal.util.CredoVerificationResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 *
 * @author eaglescan
 */
public class InterswitchUtil {

    //CHS
    //customized for CHS
    public String chsName = "Akawe Torkula PolyTechnic, Makurdi.";
    public String chs_merchant_code = "MX135184";
    public String chs_pay_item_id = "9557917";
    public String chs_product_id = "6207";
    // public String chs_quickteller_url="https://www.quickteller.com/chsbsu";
    public String chs_mac_key = "CEF793CBBE838AA0CBB29B74D571113B4EA6586D3BA77E7CFA0B95E278364EFC4526ED7BD255A366CDDE11F1F607F0F844B09D93B16F7CFE87563B2272007AB3";
//API/SDK Integration
public String CHS_clientID = "IKIA07CABF2CF1511A34997DE64E398C3A0C0C5097DF";
public String CHS_secretkey = "IUWbKttATZwH08wgHpKJJULuhBWfoUBHO7SU09jYFgQ=";
 //public String CHS_clientID = "0PUB1712z6bdFg2fM9ra7zR5QLJwc0yE"; // Demo public key
 //public String CHS_secretkey = "0PRI1712yqS1kE2Py2yxJBy75CpEqMdu"; // Demo secret key
 public String CHS_QRMerchantID = "40375312363920";
    //end of CHS
Settings settings = new Settings();
   
    public String merchant_code = settings.credo_business_code;
    public String interswitch_query_url = settings.credo_base_url + "/transaction/";
    public String pay_item_id = settings.credo_public_key;
    public String product_id = settings.credo_public_key;
    public String MacKey = settings.credo_secret_key;
    public String interswitch_url = settings.credo_base_url + "/transaction/initialize";
    public String currency_code = "NGN"; // CREDO uses NGN currency
    public String mode = "LIVE"; // CREDO mode

    

    public InterswitchUtil() {
    }
    // CREDO API Implementation: Complete payment verification method
    public String getPaymentNotification(String payref, double amount) {
        String JsonResponse = null;
        try {
            HttpURLConnection urlConnection = null;
            BufferedReader reader = null;
            try {
                // CREDO verification endpoint - construct correct URL format
                // CREDO expects: baseurl/transaction/{reference}/verify
                String verifyUrl = settings.credo_base_url + "/transaction/" + payref + "/verify";
                
                URL url = new URL(verifyUrl);
                urlConnection = (HttpURLConnection) url.openConnection();
                urlConnection.setRequestMethod("GET");
                urlConnection.setRequestProperty("Content-Type", "application/json");
                //CREDO Authentication: Add Bearer token with secret key
               urlConnection.setRequestProperty("Authorization", "Bearer" + this.MacKey);//LIVE
                //urlConnection.setRequestProperty("Authorization",this.MacKey);//DEMO
                
                int responseCode = urlConnection.getResponseCode();
                
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    // Read successful response
                    reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
                    StringBuilder buffer = new StringBuilder();
                    String inputLine;
                    while ((inputLine = reader.readLine()) != null) {
                        buffer.append(inputLine).append("\n");
                    }
                    if (buffer.length() > 0) {
                        JsonResponse = buffer.toString();
                    }
                } else {
                    // Handle error response from CREDO
                    reader = new BufferedReader(new InputStreamReader(urlConnection.getErrorStream()));
                    StringBuilder errorBuffer = new StringBuilder();
                    String errorLine;
                    while ((errorLine = reader.readLine()) != null) {
                        errorBuffer.append(errorLine).append("\n");
                    }
                    // PRODUCTION: Replace System.err.println with proper error logging for live deployment
                    System.err.println("CREDO API Error: " + responseCode + " - " + errorBuffer.toString());
                    
                    // Return detailed error information instead of null
                    JsonResponse = "{\"error\":true,\"status\":false,\"message\":\"CREDO API Error\",\"details\":\"HTTP " + responseCode + ": " + errorBuffer.toString() + "\",\"endpoint\":\"" + verifyUrl + "\"}";
                }
                
            } catch (IOException e) {
                // PRODUCTION: Replace System.err.println and printStackTrace with proper error logging for live deployment
                System.err.println("Error connecting to CREDO API: " + e.getMessage());
                e.printStackTrace();
                
                // Return detailed connection error information
                JsonResponse = "{\"error\":true,\"status\":false,\"message\":\"Connection Error\",\"details\":\"" + e.getMessage() + "\",\"endpoint\":\"" + this.interswitch_query_url + "/" + payref + "\",\"exception\":\"" + e.getClass().getSimpleName() + "\"}";
            } finally {
                if (urlConnection != null) {
                    urlConnection.disconnect();
                }
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (final IOException e) {
                        // PRODUCTION: Replace System.err.println with proper error logging for live deployment
                        System.err.println("Error closing reader: " + e.getMessage());
                    }
                }
            }
        } catch (Exception k) {
            // PRODUCTION: Replace System.err.println and printStackTrace with proper error logging for live deployment
            System.err.println("Unexpected error in CREDO payment verification: " + k.getMessage());
            k.printStackTrace();
            
            // Return detailed exception information
            JsonResponse = "{\"error\":true,\"status\":false,\"message\":\"Unexpected Error\",\"details\":\"" + k.getMessage() + "\",\"exception\":\"" + k.getClass().getSimpleName() + "\"}";
        }
        
        return JsonResponse;
    }
}
