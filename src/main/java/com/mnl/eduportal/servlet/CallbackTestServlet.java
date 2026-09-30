/*
 * Test servlet to verify callback URL accessibility
 */
package com.mnl.eduportal.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Enumeration;

/**
 * Test servlet to verify callback URL is accessible from external sources
 * Access via: http://your-domain/callback-test
 */
@WebServlet(name = "CallbackTestServlet", urlPatterns = {"/callback-test"})
public class CallbackTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Log the callback test request
        System.out.println("=== CALLBACK TEST REQUEST RECEIVED ===");
        System.out.println("Timestamp: " + new Date());
        System.out.println("Method: " + request.getMethod());
        System.out.println("URL: " + request.getRequestURL());
        System.out.println("Query String: " + request.getQueryString());
        System.out.println("Remote Address: " + request.getRemoteAddr());
        System.out.println("User Agent: " + request.getHeader("User-Agent"));
        
        // Log all parameters
        System.out.println("Parameters received:");
        Enumeration<String> paramNames = request.getParameterNames();
        boolean hasParams = false;
        while (paramNames.hasMoreElements()) {
            hasParams = true;
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + ": '" + paramValue + "'");
        }
        if (!hasParams) {
            System.out.println("  No parameters received");
        }
        
        // Send response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.println("{");
        out.println("  \"status\": \"success\",");
        out.println("  \"message\": \"Callback test endpoint is accessible\",");
        out.println("  \"timestamp\": \"" + new Date() + "\",");
        out.println("  \"method\": \"" + request.getMethod() + "\",");
        out.println("  \"remote_address\": \"" + request.getRemoteAddr() + "\",");
        out.println("  \"parameters_count\": " + request.getParameterMap().size());
        out.println("}");
        
        System.out.println("Callback test response sent successfully");
    }
}