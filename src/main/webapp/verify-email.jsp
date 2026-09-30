<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mnl.eduportal.sessions.EmailVerificationSession"%>
<%@page import="com.mnl.eduportal.entities.Users"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="com.mnl.eduportal.util.Settings"%>

<%
    // Server-side email verification with detailed error information
    String token = request.getParameter("token");
    boolean verificationSuccessful = false;
    String verificationStatus = "";
    String verificationMessage = "";
    String username = "";
    
    Settings settings = new Settings();
    
    if (token != null && !token.trim().isEmpty()) {
        try {
            InitialContext ctx = new InitialContext();
            EmailVerificationSession emailVerificationSession = (EmailVerificationSession) ctx.lookup("java:app/EduPortal-1.0-SNAPSHOT/EmailVerificationSession");
            
            // Validate and verify the token
            EmailVerificationSession.VerificationResult result = emailVerificationSession.validateVerificationToken(token);
            
            if (result.isValid()) {
                // Proceed with verification
                String verifyResult = emailVerificationSession.verifyEmail(token);
                if (verifyResult.contains("successfully")) {
                    verificationSuccessful = true;
                    verificationStatus = "SUCCESS";
                    verificationMessage = verifyResult;
                    username = result.getUser().getUsername();
                } else {
                    verificationStatus = "VERIFICATION_FAILED";
                    verificationMessage = verifyResult;
                }
            } else {
                verificationStatus = result.getStatus();
                verificationMessage = result.getMessage();
                if (result.getUser() != null) {
                    username = result.getUser().getUsername();
                }
            }
        } catch (Exception e) {
            verificationStatus = "SYSTEM_ERROR";
            verificationMessage = "Error processing verification: " + e.getMessage();
            System.out.println("Email verification error: " + e.getMessage());
        }
    } else {
        verificationStatus = "MISSING_TOKEN";
        verificationMessage = "No verification token provided";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <base href="./">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <meta name="description" content="Email Verification - <%= settings.fullName %>">
    <meta name="author" content="<%= settings.fullName %>">
    <title>Email Verification - <%= settings.productName %></title>
    
    <!-- Favicon -->
    <link rel="apple-touch-icon" sizes="57x57" href="assets/favicon/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="assets/favicon/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="assets/favicon/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="assets/favicon/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="assets/favicon/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="assets/favicon/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="assets/favicon/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="assets/favicon/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="assets/favicon/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="assets/favicon/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="assets/favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="assets/favicon/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="assets/favicon/favicon-16x16.png">
    <link rel="manifest" href="assets/favicon/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="assets/favicon/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">
    
    <!-- Vendors styles-->
    <link rel="stylesheet" href="vendors/simplebar/css/simplebar.css">
    <!-- Main styles for this application-->
    <link href="css/style.css" rel="stylesheet">
    <script src="js/config.js"></script>
    <script src="js/color-modes.js"></script>
    
    <style>
        .verification-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        .success-icon { color: #28a745; }
        .error-icon { color: #dc3545; }
        .warning-icon { color: #ffc107; }
        .info-icon { color: #17a2b8; }
    </style>
</head>

<body>
    <div class="min-vh-100 d-flex flex-row align-items-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="card shadow-lg">
                        <div class="card-body p-5">
                            <div class="text-center mb-4">
                                <img src="assets/img/Akawe.png" alt="<%= settings.productName %> Logo" style="height: 60px; width: auto;">
                                <h2 class="mt-3 mb-2">Email Verification</h2>
                            </div>
                            
                            <% if (verificationSuccessful) { %>
                            <!-- Success State -->
                            <div class="text-center">
                                <div class="verification-icon success-icon">✅</div>
                                <h4 class="text-success mb-3">Email Verified Successfully!</h4>
                                <p class="mb-4">
                                    Welcome <strong><%= username %></strong>! Your email address has been verified successfully. 
                                    You can now log in to your ATPOLY Portal account.
                                </p>
                                <div class="d-grid gap-2">
                                    <a href="/" class="btn btn-success btn-lg">Go to Login</a>
                                </div>
                            </div>
                            
                            <% } else { %>
                            <!-- Error States -->
                            <div class="text-center">
                                <% if ("MISSING_TOKEN".equals(verificationStatus)) { %>
                                    <div class="verification-icon error-icon">❌</div>
                                    <h4 class="text-danger mb-3">Missing Verification Token</h4>
                                    <p class="mb-4">
                                        No verification token was provided in the URL. Please use the complete link from your verification email.
                                    </p>
                                    
                                <% } else if ("EXPIRED_TOKEN".equals(verificationStatus)) { %>
                                    <div class="verification-icon warning-icon">⏰</div>
                                    <h4 class="text-warning mb-3">Verification Link Expired</h4>
                                    <p class="mb-4">
                                        This verification link has expired. Verification links are only valid for 24 hours from the time they were sent.
                                    </p>
                                    
                                <% } else if ("ALREADY_VERIFIED".equals(verificationStatus)) { %>
                                    <div class="verification-icon info-icon">ℹ️</div>
                                    <h4 class="text-info mb-3">Email Already Verified</h4>
                                    <p class="mb-4">
                                        <% if (!username.isEmpty()) { %>
                                            <strong><%= username %></strong>, your email address is already verified. You can log in to your account.
                                        <% } else { %>
                                            This email address is already verified. You can log in to your account.
                                        <% } %>
                                    </p>
                                    
                                <% } else if ("INVALID_TOKEN".equals(verificationStatus)) { %>
                                    <div class="verification-icon error-icon">🚫</div>
                                    <h4 class="text-danger mb-3">Invalid Verification Link</h4>
                                    <p class="mb-4">
                                        This verification link is not valid. It may have been corrupted or is not from our system.
                                    </p>
                                    
                                <% } else if ("DELETED_USER".equals(verificationStatus)) { %>
                                    <div class="verification-icon error-icon">❌</div>
                                    <h4 class="text-danger mb-3">Account Not Found</h4>
                                    <p class="mb-4">
                                        The user account associated with this verification link could not be found or has been deleted.
                                    </p>
                                    
                                <% } else { %>
                                    <div class="verification-icon error-icon">⚠️</div>
                                    <h4 class="text-danger mb-3">Verification Error</h4>
                                    <p class="mb-4">
                                        <%= verificationMessage %>
                                    </p>
                                <% } %>
                                
                                <div class="d-grid gap-2">
                                    <% if ("ALREADY_VERIFIED".equals(verificationStatus)) { %>
                                        <a href="/" class="btn btn-primary btn-lg">Go to Login</a>
                                    <% } else { %>
                                        <a href="/" class="btn btn-primary btn-lg">Back to Login</a>
                                        <button type="button" class="btn btn-outline-secondary" onclick="requestNewVerification()">
                                            Request New Verification Email
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                            
                            <!-- Additional Information -->
                            <div class="mt-4 pt-4 border-top">
                                <div class="text-center">
                                    <small class="text-muted">
                                        <strong>Need Help?</strong><br>
                                        If you continue to have issues with email verification, please contact our support team @08135837501.
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CoreUI and necessary plugins-->
    <script src="vendors/@coreui/coreui-pro/js/coreui.bundle.min.js"></script>
    <script src="vendors/simplebar/js/simplebar.min.js"></script>
    
    <script>
        function requestNewVerification() {
            // This could redirect to a page where user can request new verification
            // or show a modal to enter email address
            alert('Please contact support or try registering again to receive a new verification email.');
        }
        
        // Auto-redirect to login after successful verification (optional)
        <% if (verificationSuccessful) { %>
        setTimeout(function() {
            // Uncomment the line below to auto-redirect after 5 seconds
            // window.location.href = '/';
        }, 5000);
        <% } %>
    </script>
</body>
</html>