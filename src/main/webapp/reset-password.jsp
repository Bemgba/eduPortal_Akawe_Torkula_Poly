<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mnl.eduportal.sessions.PasswordResetSession"%>
<%@page import="com.mnl.eduportal.entities.Users"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="com.mnl.eduportal.util.Settings"%>

<%
    // Server-side token validation with detailed error information
    String token = request.getParameter("token");
    boolean tokenValid = false;
    String username = "";
    String userEmail = "";
    String validationStatus = "";
    String validationMessage = "";
    
    Settings settings = new Settings();
    
    if (token != null && !token.trim().isEmpty()) {
        try {
            InitialContext ctx = new InitialContext();
            // Use the correct JNDI path based on initialize.jspf pattern
            PasswordResetSession passwordResetSession = (PasswordResetSession) ctx.lookup("java:app/EduPortal-1.0-SNAPSHOT/PasswordResetSession");
            
            // Use the new detailed validation method
            PasswordResetSession.TokenValidationResult result = passwordResetSession.validateResetTokenDetailed(token);
            
            if (result.isValid()) {
                tokenValid = true;
                username = result.getUser().getUsername();
                userEmail = result.getUser().getEmail();
                validationStatus = "VALID";
                validationMessage = result.getMessage();
            } else {
                tokenValid = false;
                validationStatus = result.getStatus();
                validationMessage = result.getMessage();
            }
        } catch (Exception e) {
            validationStatus = "SYSTEM_ERROR";
            validationMessage = "Error validating token: " + e.getMessage();
            System.out.println("Password reset validation error: " + e.getMessage());
        }
    } else {
        validationStatus = "MISSING_TOKEN";
        validationMessage = "No reset token provided";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <base href="./">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <meta name="description" content="Password Reset - <%= settings.fullName %>">
    <meta name="author" content="<%= settings.fullName %>">
    <title>Reset Password - <%= settings.productName %></title>
    
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
        .password-strength {
            height: 4px;
            margin-top: 5px;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        .strength-weak { background-color: #dc3545; }
        .strength-medium { background-color: #ffc107; }
        .strength-strong { background-color: #28a745; }
        .password-requirements {
            font-size: 0.875rem;
            margin-top: 10px;
        }
        .requirement {
            color: #6c757d;
            margin: 2px 0;
        }
        .requirement.met {
            color: #28a745;
        }
        .requirement i {
            width: 16px;
            margin-right: 5px;
        }
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
                                <h2 class="mt-3 mb-2">Reset Password</h2>
                                <p class="text-muted">Enter your new password below</p>
                            </div>
                            
                            <% if (!tokenValid) { %>
                            <!-- Invalid Token State with Specific Messages -->
                            <div class="alert alert-danger text-center">
                                <h5 class="alert-heading">
                                    <% if ("MISSING_TOKEN".equals(validationStatus)) { %>
                                        Missing Reset Token
                                    <% } else if ("EXPIRED_TOKEN".equals(validationStatus)) { %>
                                        Reset Link Expired
                                    <% } else if ("USED_TOKEN".equals(validationStatus)) { %>
                                        Reset Link Already Used
                                    <% } else if ("INVALID_TOKEN".equals(validationStatus)) { %>
                                        Invalid Reset Link
                                    <% } else if ("USER_NOT_FOUND".equals(validationStatus)) { %>
                                        User Account Not Found
                                    <% } else if ("INACTIVE_USER".equals(validationStatus)) { %>
                                        Account Inactive
                                    <% } else { %>
                                        Reset Link Error
                                    <% } %>
                                </h5>
                                <p class="mb-3">
                                    <% if ("MISSING_TOKEN".equals(validationStatus)) { %>
                                        No reset token was provided in the URL. Please use the complete link from your email.
                                    <% } else if ("EXPIRED_TOKEN".equals(validationStatus)) { %>
                                        This password reset link has expired. Reset links are only valid for 30 minutes from the time they were sent.
                                    <% } else if ("USED_TOKEN".equals(validationStatus)) { %>
                                        This password reset link has already been used. Each reset link can only be used once for security reasons.
                                    <% } else if ("INVALID_TOKEN".equals(validationStatus)) { %>
                                        This password reset link is not valid. It may have been corrupted or is not from our system.
                                    <% } else if ("USER_NOT_FOUND".equals(validationStatus)) { %>
                                        The user account associated with this reset link could not be found.
                                    <% } else if ("INACTIVE_USER".equals(validationStatus)) { %>
                                        The user account associated with this reset link is not active. Please contact support.
                                    <% } else { %>
                                        <%= validationMessage %>
                                    <% } %>
                                </p>
                                <a href="/" class="btn btn-primary">Request New Reset Link</a>
                            </div>
                            <% } else { %>
                            
                            <!-- Reset Form -->
                            <form id="resetPasswordForm">
                                <input type="hidden" id="resetToken" value="<%= token %>">
                                
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" value="<%= username %>" readonly>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="newPassword" 
                                               placeholder="Enter new password" required>
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <span id="toggleIcon">👁️</span>
                                        </button>
                                    </div>
                                    <div class="password-strength" id="passwordStrength"></div>
                                    <div class="password-requirements" id="passwordRequirements">
                                        <div class="requirement" id="req-length">
                                            <span>❌</span> At least 6 characters
                                        </div>
                                        <div class="requirement" id="req-letter">
                                            <span>❌</span> Contains letters
                                        </div>
                                        <div class="requirement" id="req-number">
                                            <span>❌</span> Contains numbers (recommended)
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" 
                                           placeholder="Confirm new password" required>
                                    <div class="invalid-feedback" id="confirmPasswordFeedback"></div>
                                </div>
                                
                                <div id="resetMessage" class="alert" style="display: none;"></div>
                                
                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg" id="resetBtn">
                                        Reset Password
                                    </button>
                                    <a href="/" class="btn btn-link">Back to Login</a>
                                </div>
                            </form>
                            
                            <% } %>
                            
                            <!-- Success State (hidden by default) -->
                            <div id="successState" style="display: none;">
                                <div class="alert alert-success text-center">
                                    <h5 class="alert-heading">Password Reset Successful!</h5>
                                    <p class="mb-3">Your password has been reset successfully. You can now log in with your new password.</p>
                                    <a href="/" class="btn btn-success">Go to Login</a>
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
        document.addEventListener('DOMContentLoaded', function() {
            const resetPasswordForm = document.getElementById('resetPasswordForm');
            const successState = document.getElementById('successState');
            const resetMessage = document.getElementById('resetMessage');
            
            // Only initialize if form exists (token is valid)
            if (!resetPasswordForm) {
                return;
            }
            
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const resetBtn = document.getElementById('resetBtn');
            const togglePassword = document.getElementById('togglePassword');
            const toggleIcon = document.getElementById('toggleIcon');
            
            // Password visibility toggle
            togglePassword.addEventListener('click', function() {
                const type = newPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                newPasswordInput.setAttribute('type', type);
                confirmPasswordInput.setAttribute('type', type);
                toggleIcon.textContent = type === 'password' ? '👁️' : '🙈';
            });
            
            // Password strength and validation
            newPasswordInput.addEventListener('input', function() {
                checkPasswordStrength(this.value);
                validatePasswordMatch();
            });
            
            confirmPasswordInput.addEventListener('input', validatePasswordMatch);
            
            // Form submission
            resetPasswordForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                const token = document.getElementById('resetToken').value;
                const password = newPasswordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                if (password !== confirmPassword) {
                    showMessage('Passwords do not match', 'danger');
                    return;
                }
                
                if (password.length < 6) {
                    showMessage('Password must be at least 6 characters long', 'danger');
                    return;
                }
                
                resetPassword(token, password, confirmPassword);
            });
            
            function resetPassword(token, password, confirmPassword) {
                resetBtn.disabled = true;
                resetBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Resetting...';
                
                fetch('/apis/password-reset/reset', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        token: token,
                        password: password,
                        confirmPassword: confirmPassword
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 200 && data.data && data.data.success) {
                        resetPasswordForm.style.display = 'none';
                        successState.style.display = 'block';
                    } else {
                        showMessage(data.message || 'An error occurred. Please try again.', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Network error. Please try again.', 'danger');
                })
                .finally(() => {
                    resetBtn.disabled = false;
                    resetBtn.innerHTML = 'Reset Password';
                });
            }
            
            function checkPasswordStrength(password) {
                const strengthBar = document.getElementById('passwordStrength');
                const requirements = {
                    length: password.length >= 6,
                    letter: /[a-zA-Z]/.test(password),
                    number: /\d/.test(password)
                };
                
                // Update requirement indicators
                updateRequirement('req-length', requirements.length);
                updateRequirement('req-letter', requirements.letter);
                updateRequirement('req-number', requirements.number);
                
                // Calculate strength
                let strength = 0;
                if (requirements.length) strength++;
                if (requirements.letter) strength++;
                if (requirements.number) strength++;
                
                // Update strength bar
                strengthBar.className = 'password-strength';
                if (password.length === 0) {
                    strengthBar.style.width = '0%';
                } else if (strength === 1) {
                    strengthBar.classList.add('strength-weak');
                    strengthBar.style.width = '33%';
                } else if (strength === 2) {
                    strengthBar.classList.add('strength-medium');
                    strengthBar.style.width = '66%';
                } else {
                    strengthBar.classList.add('strength-strong');
                    strengthBar.style.width = '100%';
                }
            }
            
            function updateRequirement(id, met) {
                const element = document.getElementById(id);
                const icon = element.querySelector('span');
                
                if (met) {
                    element.classList.add('met');
                    icon.textContent = '✅';
                } else {
                    element.classList.remove('met');
                    icon.textContent = '❌';
                }
            }
            
            function validatePasswordMatch() {
                const password = newPasswordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                const feedback = document.getElementById('confirmPasswordFeedback');
                
                if (confirmPassword.length > 0) {
                    if (password === confirmPassword) {
                        confirmPasswordInput.classList.remove('is-invalid');
                        confirmPasswordInput.classList.add('is-valid');
                        feedback.style.display = 'none';
                    } else {
                        confirmPasswordInput.classList.remove('is-valid');
                        confirmPasswordInput.classList.add('is-invalid');
                        feedback.textContent = 'Passwords do not match';
                        feedback.style.display = 'block';
                    }
                } else {
                    confirmPasswordInput.classList.remove('is-valid', 'is-invalid');
                    feedback.style.display = 'none';
                }
            }
            
            function showMessage(message, type) {
                resetMessage.textContent = message;
                resetMessage.className = `alert alert-${type}`;
                resetMessage.style.display = 'block';
                
                // Auto-hide success messages
                if (type === 'success') {
                    setTimeout(() => {
                        resetMessage.style.display = 'none';
                    }, 5000);
                }
            }
        });
    </script>
</body>
</html>