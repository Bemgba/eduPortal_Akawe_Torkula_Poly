<%-- 
    Document   : template
    author: BEMGBA
    Updated    : 9 Sept 2025
    Purpose    : Center logo on top & redesign login/register page layout
--%>

<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mnl.eduportal.sessions.EmailVerificationSession"%>
<%@page import="javax.naming.InitialContext"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <style>
        body {
            background: #f9f9f9;
        }
        .logo-container {
            text-align: center;
            margin-top: 30px;
            margin-bottom: 10px;
        }
        .logo-container img {
            max-height: 100px;
            width: auto;
        }
        .auth-card {
            margin-top: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .auth-header {
            text-align: center;
            margin-bottom: 15px;
        }
        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            background: none;
            border: none;
            font-size: 18px;
        }
    </style>
    <title><%=settings.productName%> - Authentication</title>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Top Centered Logo -->
    <div class="logo-container">
        <img src="assets/img/Akawe.png" alt="Logo">
        <h2 class="mt-2"><%=settings.fullName%></h2>
    </div>

    <div class="container d-flex justify-content-center align-items-center flex-grow-1">
        <div class="row w-100 justify-content-center">
            
            <!-- Authentication Card -->
            <div class="col-md-6">
                <div class="card auth-card p-4">
                    <div class="auth-header">
                        <h3>Welcome Back</h3>
                        <p class="text-muted">Please login to continue</p>
                    </div>

                    <%  
                        // Display message parameter (for resend email feedback) - ALWAYS CHECK
                        String message = request.getParameter("message");
                        if (message != null && !message.trim().isEmpty()) {
                    %>
                        <div class="alert alert-info">
                            <%= message %>
                        </div>
                    <%  
                        }
                        
                        String error = request.getParameter("error");
                        if (error != null) {
                            String errorMessage = "";
                            if (error.equals("session_expired")) {
                                errorMessage = "Your session has expired. Please log in again.";
                            } else if (error.equals("role_not_assigned")) {
                                errorMessage = "Your account does not have proper permissions assigned. Please contact support.";
                            } else if (error.equals("home_page_not_configured")) {
                                errorMessage = "Your account configuration is incomplete. Please contact support.";
                            }
                            
                            if (!errorMessage.isEmpty()) {
                    %>
                        <div class="alert alert-warning">
                            <%=errorMessage%>
                        </div>
                    <%  
                            }
                        }
                        
                        String username = request.getParameter("username");
                        String password = request.getParameter("password");
                        String button   = request.getParameter("button");

                        if (button != null && username != null && password != null && username.trim().length() > 0) {
                            System.out.println("=== LOGIN FORM SUBMITTED ===");
                            System.out.println("Raw username from form: " + username);
                            System.out.println("Raw password length: " + password.length());
                            
                            username = username.trim().toLowerCase();
                            password = password.trim(); // DO NOT convert to lowercase - preserve case for security
                            
                            System.out.println("Processed username (lowercase): " + username);
                            System.out.println("Processed password length: " + password.length());
                            System.out.println("Calling sess.login()...");

                            String ipAddress = request.getHeader("X-FORWARDED-FOR");
                            if (ipAddress == null) {
                                ipAddress = request.getRemoteAddr();
                            }

                            String agent = "";
                            Enumeration<String> heads = request.getHeaderNames();
                            while (heads.hasMoreElements()) {
                                String head = heads.nextElement();
                                if (!head.equalsIgnoreCase("accept") && !head.equalsIgnoreCase("Accept-Language")
                                        && !head.equalsIgnoreCase("Accept-Encoding") && !head.equalsIgnoreCase("referer")
                                        && !head.equalsIgnoreCase("content-type") && !head.equalsIgnoreCase("cookie")
                                        && !head.equalsIgnoreCase("host") && !head.equalsIgnoreCase("Upgrade-Insecure-Requests")
                                        && !head.equalsIgnoreCase("connection") && !head.equalsIgnoreCase("content-length")) {
                                    String headerValue = request.getHeader(head);
                                    if (headerValue != null) {
                                        agent += headerValue + ", ";
                                    }
                                }
                            }
                            agent = agent.length() > 190 ? agent.substring(0,190) : agent;

                            Users userd = sess.login(username, password, ipAddress, agent);
                            
                            System.out.println("Login method returned: " + (userd != null ? "User object (SUCCESS)" : "NULL (FAILED)"));
                            if (userd != null) {
                                System.out.println("  - User ID: " + userd.getId());
                                System.out.println("  - Email: " + userd.getEmail());
                                System.out.println("  - Has role: " + (userd.getDefaultRole() != null));
                            }

                            if (userd != null) {
                                // STEP 2: Check if email is NULL or EMPTY (NEW CHECK)
                                if (userd.getEmail() == null || userd.getEmail().trim().isEmpty()) {
                                    System.out.println("EMAIL CHECK: User has no email - showing email collection modal");
                                    // Store username in request scope to pass to modal
                                    request.setAttribute("requireEmail", true);
                                    request.setAttribute("loginUsername", username);
                    %>
                        <script>
                            // Auto-show email collection modal on page load
                            document.addEventListener('DOMContentLoaded', function() {
                                const emailModal = new coreui.Modal(document.getElementById('emailCollectionModal'));
                                emailModal.show();
                            });
                        </script>
                    <%
                                    // Don't proceed with login - wait for email to be provided
                                } else {
                                    // Email exists - proceed with existing verification checks
                                    // Check email verification status before allowing login
                                    try {
                                        InitialContext ctx = new InitialContext();
                                        EmailVerificationSession emailVerificationSession = (EmailVerificationSession) ctx.lookup("java:app/EduPortal-1.0-SNAPSHOT/EmailVerificationSession");
                                        
                                        EmailVerificationSession.LoginEligibilityResult eligibility = emailVerificationSession.checkLoginEligibility(userd);
                                        
                                        if (!eligibility.isEligible()) {
                                            // Record failed login attempt for security
                                            emailVerificationSession.recordFailedLoginAttempt(userd.getId());
                                            
                                            String errorMessage = "";
                                            if (eligibility.isEmailNotVerified()) {
                                                errorMessage = "Email not verified. Please check your email and click the verification link before logging in.";
                                            } else if (eligibility.isAccountLocked()) {
                                                errorMessage = "Account temporarily locked due to multiple failed login attempts. Please try again later.";
                                            } else {
                                                errorMessage = eligibility.getMessage();
                                            }
                    %>
                        <div class="alert alert-warning">
                            <%= errorMessage %>
                            <% if (eligibility.isEmailNotVerified()) { %>
                            <br><small>Didn't receive the verification email? 
                                <a href="/apis/email-verification/resend/<%= java.net.URLEncoder.encode(userd.getEmail(), "UTF-8") %>" 
                                   class="btn btn-link btn-sm p-0" style="text-decoration: underline; vertical-align: baseline;">
                                    Resend verification email
                                </a>
                            </small>
                            <% } %>
                        </div>
                    <%
                                            return; // Stop processing login
                                        }
                                        
                                        // Reset failed login attempts on successful verification check
                                        emailVerificationSession.resetFailedLoginAttempts(userd.getId());
                                        
                                    } catch (Exception e) {
                                        System.out.println("ERROR checking email verification: " + e.getMessage());
                                        // Continue with login if verification check fails (fallback)
                                    }
                                    
                                    // Validate user configuration before proceeding
                                    boolean isValid = sess.validateApplicantUser(userd.getEmail());
                                    if (!isValid) {
                                        System.out.println("WARNING: User " + userd.getEmail() + " has configuration issues");
                                    }
                                    
                                    try {
                                        String pagesd = sess.getPagesString(userd.getId());
                                        String menud  = sess.getDesignedMenu(userd.getId());

                                        session.setAttribute("USER", userd);
                                        session.setAttribute("PAGES", pagesd);
                                        session.setAttribute("MENU", menud);

                                        String landingpage = userd.getDefaultRole().getDefaulthome().getAlias();
                                        // Add login success parameter to show toast notification
                                        response.sendRedirect("/" + landingpage + "?login_success=true");
                                    } catch (Exception d) { 
                                        System.out.println("ERROR during login redirect: " + d.getMessage());
                                        d.printStackTrace();
                                    }
                                }
                            } else {
                    %>
                        <div class="alert alert-danger">
                            Invalid username or password!
                        </div>
                    <%  
                            }
                        } 
                    %>

                    <!-- Login Form -->
                    <form action="" method="POST">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input class="form-control" type="text" required name="username" placeholder="Enter username">
                        </div>

                        <div class="mb-3 position-relative">
                            <label class="form-label">Password</label>
                            <input class="form-control" id="passwordInput" type="password" required name="password" placeholder="Enter password">
                            <button class="toggle-password" 
                                    onclick="event.preventDefault();" 
                                    onmousedown="showPassword()" 
                                    onmouseup="hidePassword()" 
                                    onmouseleave="hidePassword()">👁️</button>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <input type="submit" name="button" class="btn btn-primary" value="Login"/>
                            <button type="button" class="small text-decoration-none btn btn-link p-0" data-coreui-toggle="modal" data-coreui-target="#forgotPasswordModal">Forgot password?</button>
                        </div>

                        <div class="text-center">
                            <p class="mb-2">New Applications?</p>
                            <a href="/application_signup" class="btn btn-outline-primary">Register to Apply</a>
                            
                            <hr class="my-3">
                            
                            <p class="mb-2 text-muted small">Already have Invoice?</p>
                            <a href="/epayment" class="btn btn-success"  style="color:white">
                                <i class="cil-credit-card me-1"</i> Proceed to Payment
                            </a>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <!-- Email Collection Modal (for users without email) -->
    <div class="modal fade" id="emailCollectionModal" tabindex="-1" aria-labelledby="emailCollectionModalLabel" aria-hidden="true" data-coreui-backdrop="static" data-coreui-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="emailCollectionModalLabel">
                        <i class="cil-envelope-closed me-2"></i>Email Address Required
                    </h5>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info mb-3">
                        <i class="cil-info me-2"></i>
                        <strong>Important:</strong> Your account needs an email address for verification and communication purposes.
                    </div>
                    
                    <form id="emailCollectionForm">
                        <div class="mb-3">
                            <label for="userEmail" class="form-label">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control form-control-lg" id="userEmail" required 
                                   placeholder="Enter your email address (e.g., user@example.com)">
                            <div class="form-text">Please provide a valid email address. A verification link will be sent to this email.</div>
                        </div>
                        <div id="emailUpdateMessage" class="alert" style="display: none;"></div>
                        <input type="hidden" id="hiddenUsername" value="<%= request.getAttribute("loginUsername") != null ? request.getAttribute("loginUsername") : "" %>">
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-lg w-100" id="submitEmailBtn">
                        <i class="cil-check me-2"></i>Submit Email Address
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Forgot Password Modal -->
    <div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="forgotPasswordModalLabel">Reset Password</h5>
                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="forgotPasswordForm">
                        <div class="mb-3">
                            <label for="resetEmail" class="form-label">Email Address</label>
                            <input type="email" class="form-control" id="resetEmail" required 
                                   placeholder="Enter your registered email address">
                            <div class="form-text">We'll send you a link to reset your password.</div>
                        </div>
                        <div id="resetMessage" class="alert" style="display: none;"></div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-coreui-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="sendResetBtn">Send Reset Link</button>
                </div>
            </div>
        </div>
    </div>

    <%@include file="WEB-INF/jspf/footer.jspf"%>
    <%@include file="WEB-INF/jspf/footerjs.jspf"%>

    <script>
        const passwordInput = document.getElementById("passwordInput");
        function showPassword() { passwordInput.type = "text"; }
        function hidePassword() { passwordInput.type = "password"; }
        
        // Global email validation function (used by both modals)
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        // Email Collection Modal functionality
        document.addEventListener('DOMContentLoaded', function() {
            const submitEmailBtn = document.getElementById('submitEmailBtn');
            const userEmailInput = document.getElementById('userEmail');
            const emailUpdateMessage = document.getElementById('emailUpdateMessage');
            const hiddenUsername = document.getElementById('hiddenUsername');
            
            if (submitEmailBtn) {
                submitEmailBtn.addEventListener('click', function() {
                    const email = userEmailInput.value.trim();
                    const username = hiddenUsername.value;
                    
                    console.log('Submit button clicked');
                    console.log('Email:', email);
                    console.log('Username:', username);
                    
                    // Clear previous messages
                    emailUpdateMessage.style.display = 'none';
                    emailUpdateMessage.className = 'alert';
                    
                    // Validate email
                    if (!email) {
                        showEmailMessage('Please enter your email address', 'danger');
                        return;
                    }
                    
                    if (!isValidEmail(email)) {
                        showEmailMessage('Please enter a valid email address', 'danger');
                        return;
                    }
                    
                    if (!username) {
                        showEmailMessage('Username not found. Please refresh and try again.', 'danger');
                        return;
                    }
                    
                    console.log('Validation passed, sending request...');
                    
                    // Disable button and show loading
                    submitEmailBtn.disabled = true;
                    submitEmailBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating...';
                    
                    // Send email update request
                    fetch('/apis/user-email/update', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ 
                            username: username,
                            email: email 
                        })
                    })
                    .then(response => {
                        console.log('Response status:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('Response data:', data);
                        if (data.status === 200 && data.data && data.data.success) {
                            showEmailMessage(data.data.message, 'success');
                            userEmailInput.value = '';
                            // Redirect to login page after 2 seconds
                            setTimeout(() => {
                                window.location.href = '/?message=' + encodeURIComponent('Email updated successfully. Please login again.');
                            }, 2000);
                        } else {
                            showEmailMessage(data.message || 'An error occurred. Please try again.', 'danger');
                            // Re-enable button
                            submitEmailBtn.disabled = false;
                            submitEmailBtn.innerHTML = '<i class="cil-check me-2"></i>Submit Email Address';
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showEmailMessage('Network error. Please check your connection and try again.', 'danger');
                        // Re-enable button
                        submitEmailBtn.disabled = false;
                        submitEmailBtn.innerHTML = '<i class="cil-check me-2"></i>Submit Email Address';
                    });
                });
                
                // Allow Enter key to submit
                userEmailInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        submitEmailBtn.click();
                    }
                });
            }
            
            function showEmailMessage(message, type) {
                emailUpdateMessage.textContent = message;
                emailUpdateMessage.className = `alert alert-${type}`;
                emailUpdateMessage.style.display = 'block';
            }
        });
        
        // Forgot Password functionality
        document.addEventListener('DOMContentLoaded', function() {
            const sendResetBtn = document.getElementById('sendResetBtn');
            const resetEmailInput = document.getElementById('resetEmail');
            const resetMessage = document.getElementById('resetMessage');
            const forgotPasswordForm = document.getElementById('forgotPasswordForm');
            
            sendResetBtn.addEventListener('click', function() {
                const email = resetEmailInput.value.trim();
                
                // Clear previous messages
                resetMessage.style.display = 'none';
                resetMessage.className = 'alert';
                
                // Validate email
                if (!email) {
                    showMessage('Please enter your email address', 'danger');
                    return;
                }
                
                if (!isValidEmail(email)) {
                    showMessage('Please enter a valid email address', 'danger');
                    return;
                }
                
                // Disable button and show loading
                sendResetBtn.disabled = true;
                sendResetBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Sending...';
                
                // Send reset request
                fetch('/apis/password-reset/request', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ email: email })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 200 && data.data && data.data.success) {
                        showMessage(data.data.message, 'success');
                        resetEmailInput.value = '';
                        // Auto-close modal after 3 seconds
                        setTimeout(() => {
                            const modal = coreui.Modal.getInstance(document.getElementById('forgotPasswordModal'));
                            if (modal) modal.hide();
                        }, 3000);
                    } else {
                        showMessage(data.message || 'An error occurred. Please try again.', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Network error. Please check your connection and try again.', 'danger');
                })
                .finally(() => {
                    // Re-enable button
                    sendResetBtn.disabled = false;
                    sendResetBtn.innerHTML = 'Send Reset Link';
                });
            });
            
            // Allow Enter key to submit
            resetEmailInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendResetBtn.click();
                }
            });
            
            // Clear message when modal is closed
            document.getElementById('forgotPasswordModal').addEventListener('hidden.coreui.modal', function() {
                resetMessage.style.display = 'none';
                resetEmailInput.value = '';
                sendResetBtn.disabled = false;
                sendResetBtn.innerHTML = 'Send Reset Link';
            });
            
            function showMessage(message, type) {
                resetMessage.textContent = message;
                resetMessage.className = `alert alert-${type}`;
                resetMessage.style.display = 'block';
            }
        });
    </script>
</body>
</html>
