<%-- 
    Document   : paymentError
    Created on : Payment Error Page for CREDO Integration
    Author     : BEMGBA
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>

<%    String errorType = (String) request.getAttribute("errorType");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String errorDetails = (String) request.getAttribute("errorDetails");
    String txnRef = (String) request.getAttribute("txnRef");
    String exception2 = (String) request.getAttribute("exception2");

    if (errorType == null) {
        errorType = "UNKNOWN_ERROR";
    }
    if (errorMessage == null) {
        errorMessage = "An unknown error occurred";
    }
    if (errorDetails == null) {
        errorDetails = "No additional details available";
    }
    if (txnRef == null)
        txnRef = "N/A";
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Payment Error</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .error-icon {
                font-size: 4rem;
                color: #dc3545;
            }
            .error-details {
                background-color: #f8f9fa;
                border-left: 4px solid #dc3545;
                padding: 15px;
                margin: 20px 0;
            }
            .technical-info {
                background-color: #e9ecef;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                padding: 15px;
                font-family: monospace;
                font-size: 0.9rem;
            }
        </style>
    </head>

    <body>
        <div class="wrapper d-flex flex-column min-vh-100">
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-10">
                            <div class="card">
                                <div class="card-header d-flex align-items-center">
                                    <span class="error-icon"> 
                                       <i class="fa-solid fa-xmark"></i>
                                    </span>
                                    <strong class="ml-3">Payment Initialization Failed</strong>
                                    <a class="btn btn-sm btn-danger ms-auto me-1 d-print-none" href="/epayment">
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-left"></use>
                                        </svg> Back to Payment
                                    </a>
                                </div>
                                <div class="card-body">

                                    <!-- Main Error Message -->
                                    <div class="alert alert-danger" role="alert">
                                        <h5 class="alert-heading">CREDO Payment System Error</h5>
                                        <p class="mb-0"><%=errorMessage%></p>
                                    </div>

                                    <!-- Error Details -->
                                    <div class="error-details">
                                        <h6><strong>Error Details:</strong></h6>
                                        <p><%=errorDetails%></p>

                                        <% if (txnRef != null && !txnRef.equals("N/A")) {%>
                                        <p><strong>Transaction Reference:</strong> <%=txnRef%></p>
                                        <% } %>

                                        <% if (exception2 != null) {%>
                                        <p><strong>Exception2 Type:</strong> <%=exception2%></p>
                                        <% }%>
                                    </div>

                                    <!-- Technical Information -->
                                    <div class="technical-info">
                                        <h6><strong>Technical Information:</strong></h6>
                                        <p><strong>Error Type:</strong> <%=errorType%></p>
                                        <!-- <p><strong>CREDO API Endpoint:</strong> <%=settings.credo_base_url%>/transaction/initialize</p> -->
                                        <!-- <p><strong>Public Key:</strong> <%=settings.credo_public_key%></p> -->
                                        <!-- <p><strong>Business Code:</strong> <%=settings.credo_business_code%></p> -->
                                        <p><strong>Timestamp:</strong> <%=settings.getTodaysdate()%> <%=settings.getCurrentTime()%></p>
                                    </div>

                                    <!-- Possible Solutions -->
                                    <div class="alert alert-info mt-4" role="alert">
                                        <h6 class="alert-heading">Possible Solutions:</h6>
                                        <ul class="mb-0">
                                            <li><strong>Network Connectivity:</strong> Check if the server can reach <%=settings.credo_base_url%></li>
                                            <!-- <li><strong>API Credentials:</strong> Verify CREDO public key and secret key are correct</li> -->
                                            <!-- <li><strong>API Status:</strong> Check if CREDO API service is currently available</li> -->
                                            <!-- <li><strong>Firewall:</strong> Ensure outbound HTTPS connections are allowed</li> -->
                                            <!-- <li><strong>DNS Resolution:</strong> Verify that api.credodemo.com resolves correctly</li> -->
                                        </ul>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <a href="/epayment" class="btn btn-primary btn-block">
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-reload"></use>
                                                </svg> Try Payment Again
                                            </a>
                                        </div>
                                        <div class="col-md-6">
                                            <a href="/" class="btn btn-secondary btn-block">
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-home"></use>
                                                </svg> Return to Dashboard
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Contact Information -->
                                    <div class="alert alert-warning mt-4" role="alert">
                                        <h6 class="alert-heading">Need Help?</h6>
                                        <p class="mb-0">If this error persists, please contact the system administrator with the transaction reference: <strong><%=txnRef%></strong></p>
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