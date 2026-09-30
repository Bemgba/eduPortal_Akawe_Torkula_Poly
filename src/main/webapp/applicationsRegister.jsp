<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Enumeration"%>
<%@page import="com.mnl.eduportal.sessions.EmailVerificationSession"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Register</title>
        
        <style>
            .password-strength-meter {
                height: 8px;
                background-color: #e9ecef;
                border-radius: 4px;
                overflow: hidden;
                margin-bottom: 5px;
            }
            
            .password-strength-bar {
                height: 100%;
                transition: all 0.3s ease;
                border-radius: 4px;
            }
            
            .strength-weak {
                background-color: #dc3545;
                width: 25%;
            }
            
            .strength-fair {
                background-color: #fd7e14;
                width: 50%;
            }
            
            .strength-good {
                background-color: #ffc107;
                width: 75%;
            }
            
            .strength-strong {
                background-color: #198754;
                width: 100%;
            }
            
            .password-requirements {
                font-size: 0.875rem;
                margin-top: 0.5rem;
            }
            
            .requirement {
                display: flex;
                align-items: center;
                margin-bottom: 0.25rem;
            }
            
            .requirement-icon {
                width: 16px;
                height: 16px;
                margin-right: 0.5rem;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.75rem;
            }
            
            .requirement-met {
                background-color: #198754;
                color: white;
            }
            
            .requirement-unmet {
                background-color: #dc3545;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="sidebar sidebar-fixed border-end" id="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-brand">
                    <img src="assets/img/CAPS.jpg" alt="Logo" style="widows: 32px; height: auto">
                </div>
                <button class="btn-close d-lg-none" type="button" aria-label="Close" onclick="coreui.Sidebar.getInstance(document.querySelector('#sidebar')).toggle()"></button>
            </div>
        </div>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <div class="container-fluid px-4">
                    <button class="header-toggler" type="button" onclick="coreui.Sidebar.getInstance(document.querySelector('#sidebar')).toggle()" style="margin-inline-start: -14px">
                        <svg class="icon icon-lg">
                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-menu"></use>
                        </svg>
                    </button>
                    <div><h1><%=settings.fullName%></h1></div>
                    <ul class="header-nav d-none d-md-flex ms-auto"></ul>
                    <ul class="header-nav ms-auto ms-md-0"></ul>

                </div>

            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card-group d-block d-md-flex row">
                                <div class="card col-md-7 p-4 mb-0">
                                    <div class="card-body">
                                        <h1>Create an Account</h1>
                                        <%
                                            String emailadd = request.getParameter("emailadd");
                                            String password = request.getParameter("password");
                                            String password2 = request.getParameter("password2");
                                            String button = request.getParameter("button");
                                            if (button != null && emailadd != null && password != null && password.trim().length() > 0 && password2 != null) {
                                                emailadd = emailadd.toLowerCase();
                                                
                                                // Server-side password strength validation
                                                boolean isPasswordValid = true;
                                                String passwordError = "";
                                                
                                                // Check password length
                                                if (password.length() < 6) {
                                                    isPasswordValid = false;
                                                    passwordError += "Password must be at least 6 characters long. ";
                                                }
                                                
                                                // Check for uppercase letter
                                                if (!password.matches(".*[A-Z].*")) {
                                                    isPasswordValid = false;
                                                    passwordError += "Password must contain at least one uppercase letter. ";
                                                }
                                                
                                                // Check for lowercase letter
                                                if (!password.matches(".*[a-z].*")) {
                                                    isPasswordValid = false;
                                                    passwordError += "Password must contain at least one lowercase letter. ";
                                                }
                                                
                                                // Check for number
                                                if (!password.matches(".*\\d.*")) {
                                                    isPasswordValid = false;
                                                    passwordError += "Password must contain at least one number. ";
                                                }
                                                
                                                // Check for special character
                                                if (!password.matches(".*[@$!%*?&].*")) {
                                                    isPasswordValid = false;
                                                    passwordError += "Password must contain at least one special character (@$!%*?&). ";
                                                }
                                                
                                                if (!isPasswordValid) {
                                        %>
                                        <div class="alert alert-danger">
                                            <strong>Password Requirements Not Met:</strong><br>
                                            <%=passwordError%>
                                        </div>
                                        <%
                                                } else if (password.equals(password2)) {
                                                    Users usdx = sess.getUsersByEmail(emailadd);
                                                    if (usdx != null) {
                                        %>
                                        <div class="alert alert-danger">
                                            <strong>❌ Email Already Registered</strong><br>
                                            An account with email address <strong><%=emailadd%></strong> already exists.<br>
                                            <small>If this is your account, please <a href="/" class="btn btn-success btn-sm mt-2">Login here</a> to continue your application.</small><br>
                                            <small>Forgot your password? <a href="/?showForgotPassword=true" class="btn btn-link btn-sm">Reset it here</a></small>
                                        </div>
                                        <%
                                        } else {
                                            try {
                                                String ipAddress = request.getHeader("X-FORWARDED-FOR");
                                                String mac = "";
                                                if (ipAddress == null) {
                                                    ipAddress = request.getRemoteAddr();
                                                }

                                                String agent = "";
                                                Enumeration<String> heads = request.getHeaderNames();
                                                while (heads.hasMoreElements()) {
                                                    String head = heads.nextElement();
                                                    if (!head.equalsIgnoreCase("accept")
                                                            && !head.equalsIgnoreCase("Accept-Language")
                                                            && !head.equalsIgnoreCase("Accept-Encoding")
                                                            && !head.equalsIgnoreCase("referer")
                                                            && !head.equalsIgnoreCase("content-type")
                                                            && !head.equalsIgnoreCase("cookie")
                                                            && !head.equalsIgnoreCase("host")
                                                            && !head.equalsIgnoreCase("Upgrade-Insecure-Requests")
                                                            && !head.equalsIgnoreCase("connection")
                                                            && !head.equalsIgnoreCase("content-length")) {
                                                        String headerValue = request.getHeader(head);
                                                        if (headerValue != null) {
                                                            agent += headerValue + ", ";
                                                        }
                                                    }
                                                }
                                                
                                                if (agent.length() > 190) {
                                                    agent = agent.substring(0, 190);
                                                }
                                                
                                                // DO NOT convert password to lowercase - preserve original case for security
                                                String id = settings.generateId(settings.getTodaysdate().split("-")[0], 10);
                                                usdx = new Users(id);
                                                usdx.setUsername(emailadd);
                                                usdx.setPassword(password);
                                                usdx.setEmail(emailadd);
                                                usdx.setDefaultRole(sess.getRoles(1064));
                                                usdx.setStatus("ACTIVE");
                                                
                                                // Set audit fields for new user
                                                Date now = new Date();
                                                usdx.setCreatedAt(now);
                                                usdx.setUpdatedAt(now);
                                                usdx.setCreatedBy("SYSTEM");
                                                usdx.setFailedLoginAttempts(0);
                                                usdx.setDeleted(false);
                                                // Note: email_verified_at is left NULL - user must verify email
                                                
                                                sess.newEntry(usdx);
                                                
                                                // Send verification email after account creation
                                                boolean verificationEmailSent = false;
                                                String verificationMessage = "";
                                                
                                                try {
                                                    InitialContext ctx = new InitialContext();
                                                    EmailVerificationSession emailVerificationSession = (EmailVerificationSession) ctx.lookup("java:app/EduPortal-1.0-SNAPSHOT/EmailVerificationSession");
                                                    
                                                    String emailResult = emailVerificationSession.sendVerificationEmail(id);
                                                    if (emailResult.contains("sent")) {
                                                        verificationEmailSent = true;
                                                        verificationMessage = "A verification email has been sent to " + emailadd + ". Please check your email and click the verification link before logging in.";
                                                    } else {
                                                        verificationMessage = "Account created but verification email could not be sent. Please contact support.";
                                                    }
                                                } catch (Exception e) {
                                                    System.out.println("Error sending verification email: " + e.getMessage());
                                                    e.printStackTrace();
                                                    verificationMessage = "Account created but verification email could not be sent. Please contact support.";
                                                }
                                                
                                                // Validate that the user was created properly
                                                boolean isValid = sess.validateApplicantUser(emailadd);
                                                if (!isValid) {
                                                    System.out.println("WARNING: Applicant user " + emailadd + " was not properly configured");
                                                }
                                                
                                                System.out.print("Applicant saved");
                                        %>
                                        <div class="alert alert-success">
                                            <h5>✅ Account Created Successfully!</h5>
                                            <p>Your account has been created successfully.</p>
                                            <% if (verificationEmailSent) { %>
                                                <p><strong>📧 Verification Required:</strong> <%= verificationMessage %></p>
                                                <p><small>Didn't receive the email? Check your spam folder or <a href="/apis/email-verification/resend/<%= java.net.URLEncoder.encode(emailadd, "UTF-8") %>" class="btn btn-link btn-sm p-0">resend verification email</a>.</small></p>
                                            <% } else { %>
                                            
                                                <p class="text-warning"><strong>⚠️ Email Issue:</strong> <%= verificationMessage %></p>
                                            <% } %>
                                            <p>You can <a href="/" class="btn btn-primary btn-sm">Login</a> after verifying your email address.</p>
                                        </div>
                                        <%
                                            } catch (Exception e) {
                                                // Catch any database or system errors during registration
                                                System.out.println("Error during user registration: " + e.getMessage());
                                                e.printStackTrace();
                                                
                                                String errorMessage = "An error occurred while creating your account. ";
                                                
                                                // Provide specific error messages based on exception type
                                                if (e.getMessage() != null) {
                                                    if (e.getMessage().contains("duplicate") || e.getMessage().contains("unique constraint")) {
                                                        errorMessage = "This email address is already registered. Please use a different email or login with your existing account.";
                                                    } else if (e.getMessage().contains("database") || e.getMessage().contains("connection")) {
                                                        errorMessage = "Database connection error. Please try again later or contact support.";
                                                    } else if (e.getMessage().contains("timeout")) {
                                                        errorMessage = "Request timeout. Please try again.";
                                                    } else {
                                                        errorMessage += "Please try again or contact support if the problem persists.";
                                                    }
                                                }
                                        %>
                                        <div class="alert alert-danger">
                                            <strong>❌ Registration Failed</strong><br>
                                            <%= errorMessage %><br>
                                            <small class="text-muted">If you continue to experience issues, please contact support with error details.</small>
                                        </div>
                                        <%
                                            }
                                        }
                                                } else {
                                        %>
                                        <div class="alert alert-danger">
                                            <strong>❌ Password Mismatch</strong><br>
                                            The passwords you entered do not match. Please ensure both password fields contain the same value.
                                        </div>
                                        <%
                                                }
                                            }
                                        %>

                                        <form action="" method="POST" role="form">

                                            <p class="text-body-secondary">Create an account here</p>

                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    Email Address   
                                                </span>
                                                <input class="form-control" id="emailadd" type="email" required="" name="emailadd">
                                            </div>
                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Choose Password    
                                                </span>
                                                <input class="form-control" type="password" required="" name="password" id="password" 
                                                       minlength="6" 
                                                       pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$"
                                                       title="Password must be at least 6 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character">
                                                <div class="invalid-feedback" id="passwordFeedback">
                                                    Password must be at least 6 characters with uppercase, lowercase, number, and special character.
                                                </div>
                                            </div>
                                            
                                            <!-- Password strength indicator -->
                                            <div class="mb-3">
                                                <div class="password-strength-meter">
                                                    <div class="password-strength-bar" id="passwordStrengthBar"></div>
                                                </div>
                                                <small class="text-muted" id="passwordStrengthText">Password strength will appear here</small>
                                                
                                                <!-- Password requirements checklist -->
                                                <div class="password-requirements mt-2" id="passwordRequirements" style="display: none;">
                                                    <div class="requirement" id="lengthReq">
                                                        <span class="requirement-icon requirement-unmet">✗</span>
                                                        <span>At least 6 characters</span>
                                                    </div>
                                                    <div class="requirement" id="uppercaseReq">
                                                        <span class="requirement-icon requirement-unmet">✗</span>
                                                        <span>One uppercase letter</span>
                                                    </div>
                                                    <div class="requirement" id="lowercaseReq">
                                                        <span class="requirement-icon requirement-unmet">✗</span>
                                                        <span>One lowercase letter</span>
                                                    </div>
                                                    <div class="requirement" id="numberReq">
                                                        <span class="requirement-icon requirement-unmet">✗</span>
                                                        <span>One number</span>
                                                    </div>
                                                    <div class="requirement" id="specialReq">
                                                        <span class="requirement-icon requirement-unmet">✗</span>
                                                        <span>One special character (@$!%*?&)</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="input-group mb-4"><span class="input-group-text">
                                                    Retype Password    
                                                </span>
                                                <input class="form-control" type="password" required="" name="password2" id="password2">
                                                <div class="invalid-feedback" id="password2Feedback">
                                                    Passwords do not match.
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12">
                                                    <input type="submit" name="button" class="btn btn-primary px-4" value="Create Account"/>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-12 text-end">
                                                    <a href="/" class="btn btn-link px-0" type="button">Already have account? Login here</a>
                                                </div>
                                            </div>


                                        </form>
                                    </div>
                                </div>
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Registration Instructions</h2>
                                            <p>Are you an applicant that wants to registers for either Diploma course or IJMBE programme? login username is any of the following:
                                            <p>All applicants are required to create account on the Polytechnic platform for ease of application and tracking.</p>
                                            <p>If you have already created an account, <a href="/" class="btn btn-success btn-sm">Login here</a></p>
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
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const passwordInput = document.getElementById('password');
                const password2Input = document.getElementById('password2');
                const strengthBar = document.getElementById('passwordStrengthBar');
                const strengthText = document.getElementById('passwordStrengthText');
                const requirementsDiv = document.getElementById('passwordRequirements');
                
                // Password strength checking function
                function checkPasswordStrength(password) {
                    let score = 0;
                    let feedback = [];
                    
                    // Length check
                    const lengthReq = document.getElementById('lengthReq');
                    const lengthIcon = lengthReq.querySelector('.requirement-icon');
                    if (password.length >= 6) {
                        score += 1;
                        lengthIcon.className = 'requirement-icon requirement-met';
                        lengthIcon.textContent = '✓';
                    } else {
                        lengthIcon.className = 'requirement-icon requirement-unmet';
                        lengthIcon.textContent = '✗';
                        feedback.push('at least 6 characters');
                    }
                    
                    // Uppercase check
                    const uppercaseReq = document.getElementById('uppercaseReq');
                    const uppercaseIcon = uppercaseReq.querySelector('.requirement-icon');
                    if (/[A-Z]/.test(password)) {
                        score += 1;
                        uppercaseIcon.className = 'requirement-icon requirement-met';
                        uppercaseIcon.textContent = '✓';
                    } else {
                        uppercaseIcon.className = 'requirement-icon requirement-unmet';
                        uppercaseIcon.textContent = '✗';
                        feedback.push('uppercase letter');
                    }
                    
                    // Lowercase check
                    const lowercaseReq = document.getElementById('lowercaseReq');
                    const lowercaseIcon = lowercaseReq.querySelector('.requirement-icon');
                    if (/[a-z]/.test(password)) {
                        score += 1;
                        lowercaseIcon.className = 'requirement-icon requirement-met';
                        lowercaseIcon.textContent = '✓';
                    } else {
                        lowercaseIcon.className = 'requirement-icon requirement-unmet';
                        lowercaseIcon.textContent = '✗';
                        feedback.push('lowercase letter');
                    }
                    
                    // Number check
                    const numberReq = document.getElementById('numberReq');
                    const numberIcon = numberReq.querySelector('.requirement-icon');
                    if (/\d/.test(password)) {
                        score += 1;
                        numberIcon.className = 'requirement-icon requirement-met';
                        numberIcon.textContent = '✓';
                    } else {
                        numberIcon.className = 'requirement-icon requirement-unmet';
                        numberIcon.textContent = '✗';
                        feedback.push('number');
                    }
                    
                    // Special character check
                    const specialReq = document.getElementById('specialReq');
                    const specialIcon = specialReq.querySelector('.requirement-icon');
                    if (/[@$!%*?&]/.test(password)) {
                        score += 1;
                        specialIcon.className = 'requirement-icon requirement-met';
                        specialIcon.textContent = '✓';
                    } else {
                        specialIcon.className = 'requirement-icon requirement-unmet';
                        specialIcon.textContent = '✗';
                        feedback.push('special character');
                    }
                    
                    return { score, feedback };
                }
                
                // Update password strength display
                function updatePasswordStrength(password) {
                    if (password.length === 0) {
                        strengthBar.className = 'password-strength-bar';
                        strengthText.textContent = 'Password strength will appear here';
                        requirementsDiv.style.display = 'none';
                        return;
                    }
                    
                    requirementsDiv.style.display = 'block';
                    const result = checkPasswordStrength(password);
                    
                    // Update strength bar and text
                    strengthBar.className = 'password-strength-bar';
                    
                    if (result.score <= 1) {
                        strengthBar.classList.add('strength-weak');
                        strengthText.textContent = 'Weak password';
                        strengthText.className = 'text-danger';
                    } else if (result.score <= 2) {
                        strengthBar.classList.add('strength-fair');
                        strengthText.textContent = 'Fair password';
                        strengthText.className = 'text-warning';
                    } else if (result.score <= 4) {
                        strengthBar.classList.add('strength-good');
                        strengthText.textContent = 'Good password';
                        strengthText.className = 'text-info';
                    } else {
                        strengthBar.classList.add('strength-strong');
                        strengthText.textContent = 'Strong password';
                        strengthText.className = 'text-success';
                    }
                    
                    // Update form validation
                    if (result.score === 5) {
                        passwordInput.setCustomValidity('');
                        passwordInput.classList.remove('is-invalid');
                        passwordInput.classList.add('is-valid');
                    } else {
                        passwordInput.setCustomValidity('Password must meet all requirements');
                        passwordInput.classList.remove('is-valid');
                        passwordInput.classList.add('is-invalid');
                    }
                }
                
                // Check password match
                function checkPasswordMatch() {
                    const password = passwordInput.value;
                    const password2 = password2Input.value;
                    
                    if (password2.length === 0) {
                        password2Input.setCustomValidity('');
                        password2Input.classList.remove('is-invalid', 'is-valid');
                        return;
                    }
                    
                    if (password === password2) {
                        password2Input.setCustomValidity('');
                        password2Input.classList.remove('is-invalid');
                        password2Input.classList.add('is-valid');
                    } else {
                        password2Input.setCustomValidity('Passwords do not match');
                        password2Input.classList.remove('is-valid');
                        password2Input.classList.add('is-invalid');
                    }
                }
                
                // Event listeners
                passwordInput.addEventListener('input', function() {
                    updatePasswordStrength(this.value);
                    checkPasswordMatch();
                });
                
                password2Input.addEventListener('input', checkPasswordMatch);
                
                // Form submission validation
                const form = document.querySelector('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const password = passwordInput.value;
                        const result = checkPasswordStrength(password);
                        
                        if (result.score < 5) {
                            e.preventDefault();
                            alert('Please ensure your password meets all requirements before submitting.');
                            return false;
                        }
                        
                        if (passwordInput.value !== password2Input.value) {
                            e.preventDefault();
                            alert('Passwords do not match. Please check and try again.');
                            return false;
                        }
                    });
                }
            });
        </script>
        
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
        <script>
        </script>
    </body>
</html>