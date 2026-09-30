<%-- 
    Document   : updateUser
    Created on : March 10, 2026
    Purpose    : Admin page for updating user details and assigning roles
    Author     : eduportal
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
%>
<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - Update User</title>
    <style>
        .search-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .search-card h3 {
            font-weight: 600;
            margin-bottom: 20px;
        }
        .user-details-card {
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .user-details-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 25px;
        }
        .user-details-header h4 {
            margin: 0;
            font-weight: 600;
        }
        .user-details-header .user-id {
            opacity: 0.9;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        .form-section {
            padding: 30px;
        }
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            padding: 12px 15px;
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .info-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            display: inline-block;
            margin-bottom: 10px;
        }
        .info-badge i {
            margin-right: 5px;
        }
        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s;
        }
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-search {
            background: white;
            color: #667eea;
            border: 2px solid white;
            padding: 10px 30px;
            font-weight: 600;
            border-radius: 25px;
            transition: all 0.3s;
        }
        .btn-search:hover {
            background: transparent;
            color: white;
            border-color: white;
        }
        .password-hint {
            font-size: 0.85rem;
            color: #6c757d;
            font-style: italic;
            margin-top: 5px;
        }
        .role-badge {
            background: #4caf50;
            color: white;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.9rem;
            display: inline-block;
        }
        .no-user-found {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .no-user-found i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <%@include file="WEB-INF/jspf/navigations.jspf"%>

    <div class="wrapper d-flex flex-column min-vh-100">
        <header class="header header-sticky p-0">
            <%@include file="WEB-INF/jspf/header_staff.jspf"%>
            <div class="container-fluid px-4">
                <h2 class="title"><i class="fas fa-user-edit me-2"></i>Update User Details</h2>
            </div>
        </header>
        
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                
                <%
                    // Backend Processing
                    String searchQuery = request.getParameter("searchQuery");
                    String submitUpdate = request.getParameter("submitUpdate");
                    Users targetUser = null;
                    String msg = "";
                    String msgType = "danger";
                    
                    // Handle Update Submission
                    if (submitUpdate != null) {
                        String userId = request.getParameter("userId");
                        String newEmail = request.getParameter("email");
                        String newPassword = request.getParameter("password");
                        String newRoleId = request.getParameter("roleId");
                        
                        try {
                            targetUser = (Users) sess.getSingleObject(Users.class, userId);
                            if (targetUser != null) {
                                boolean updated = false;
                                
                                // Update Email
                                if (newEmail != null && !newEmail.trim().isEmpty()) {
                                    String emailLower = newEmail.trim().toLowerCase();
                                    if (!emailLower.equals(targetUser.getEmail())) {
                                        // Check if email already exists
                                        Users emailCheck = sess.getUsersByEmail(emailLower);
                                        if (emailCheck != null && !emailCheck.getId().equals(userId)) {
                                            msg = "Email address is already in use by another user!";
                                            msgType = "danger";
                                        } else {
                                            sess.updateUserEmailDirect(userId, emailLower);
                                            updated = true;
                                        }
                                    }
                                }
                                
                                // Update Password (only if provided)
                                if (msg.isEmpty() && newPassword != null && !newPassword.trim().isEmpty()) {
                                    sess.updatePassword(userId, newPassword.trim());
                                    updated = true;
                                }
                                
                                // Update Role
                                if (msg.isEmpty() && newRoleId != null && !newRoleId.trim().isEmpty()) {
                                    int roleId = Integer.parseInt(newRoleId);
                                    if (targetUser.getDefaultRole() == null || targetUser.getDefaultRole().getId() != roleId) {
                                        sess.updateUserRole(userId, roleId);
                                        updated = true;
                                    }
                                }
                                
                                if (msg.isEmpty()) {
                                    if (updated) {
                                        msg = "User details updated successfully!";
                                        msgType = "success";
                                        // Reload user to show updated data
                                        targetUser = (Users) sess.getSingleObject(Users.class, userId);
                                    } else {
                                        msg = "No changes were made.";
                                        msgType = "info";
                                    }
                                }
                            }
                        } catch (Exception e) {
                            msg = "Error updating user: " + e.getMessage();
                            msgType = "danger";
                            e.printStackTrace();
                        }
                    }
                    
                    // Handle Search
                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        String query = searchQuery.trim().toLowerCase();
                        
                        // Try to find by username first
                        targetUser = sess.getUsersByUsername(query);
                        
                        // If not found, try by email
                        if (targetUser == null) {
                            targetUser = sess.getUsersByEmail(query);
                        }
                        
                        // If not found, try by ID
                        if (targetUser == null) {
                            try {
                                targetUser = (Users) sess.getSingleObject(Users.class, query);
                            } catch (Exception e) {
                                // Not found by ID either
                            }
                        }
                        
                        if (targetUser == null) {
                            msg = "No user found with username, email, or ID: " + searchQuery;
                            msgType = "warning";
                        }
                    }
                    
                    // Get all roles for dropdown
                    List<Roles> allRoles = sess.getAllRoles();
                %>
                
                <!-- Search Section -->
                <div class="search-card">
                    <h3><i class="fas fa-search me-2"></i>Search User</h3>
                    <p class="mb-4">Enter username, email, or user ID to load user details</p>
                    <form action="" method="POST">
                        <div class="row align-items-end">
                            <div class="col-md-8">
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       name="searchQuery" 
                                       placeholder="Enter username, email, or user ID" 
                                       value="<%= searchQuery != null ? searchQuery : "" %>"
                                       required>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-search btn-lg w-100">
                                    <i class="fas fa-search me-2"></i>Search User
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Messages -->
                <% if (!msg.isEmpty()) { %>
                <div class="alert alert-<%= msgType %> alert-dismissible fade show" role="alert">
                    <i class="fas fa-<%= msgType.equals("success") ? "check-circle" : msgType.equals("warning") ? "exclamation-triangle" : "info-circle" %> me-2"></i>
                    <%= msg %>
                    <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                </div>
                <% } %>
                
                <!-- User Details Section -->
                <% if (targetUser != null) { %>
                <div class="user-details-card">
                    <div class="user-details-header">
                        <h4><i class="fas fa-user-circle me-2"></i><%= targetUser.getUsername() %></h4>
                        <div class="user-id">User ID: <%= targetUser.getId() %></div>
                    </div>
                    
                    <div class="form-section">
                        <form action="" method="POST">
                            <input type="hidden" name="userId" value="<%= targetUser.getId() %>">
                            <input type="hidden" name="searchQuery" value="<%= searchQuery != null ? searchQuery : "" %>">
                            
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <div class="info-badge">
                                        <i class="fas fa-info-circle"></i>
                                        Current Role: 
                                        <span class="role-badge">
                                            <%= targetUser.getDefaultRole() != null ? targetUser.getDefaultRole().getName() : "No Role Assigned" %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <!-- Username (Read-only) -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-user me-2"></i>Username
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           value="<%= targetUser.getUsername() %>" 
                                           readonly 
                                           style="background-color: #f8f9fa;">
                                    <small class="text-muted">Username cannot be changed</small>
                                </div>
                                
                                <!-- Email -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-envelope me-2"></i>Email Address
                                    </label>
                                    <input type="email" 
                                           class="form-control" 
                                           name="email" 
                                           value="<%= targetUser.getEmail() != null ? targetUser.getEmail() : "" %>" 
                                           placeholder="Enter email address">
                                </div>
                                
                                <!-- Role -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-user-tag me-2"></i>Assign Role
                                    </label>
                                    <select class="form-select" name="roleId">
                                        <option value="">-- Select Role --</option>
                                        <% 
                                        for (Roles role : allRoles) {
                                            boolean isSelected = targetUser.getDefaultRole() != null && 
                                                               targetUser.getDefaultRole().getId().equals(role.getId());
                                        %>
                                        <option value="<%= role.getId() %>" <%= isSelected ? "selected" : "" %>>
                                            <%= role.getName() %> 
                                            <% if (role.getDescription() != null && !role.getDescription().isEmpty()) { %>
                                                - <%= role.getDescription() %>
                                            <% } %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <!-- Password -->
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">
                                        <i class="fas fa-lock me-2"></i>New Password
                                    </label>
                                    <input type="password" 
                                           class="form-control" 
                                           name="password" 
                                           placeholder="Enter new password (leave blank to keep current)">
                                    <div class="password-hint">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Leave blank if you don't want to change the password
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Additional Info -->
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <div class="card" style="background: #f8f9fa; border: none;">
                                        <div class="card-body">
                                            <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Additional Information</h6>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <small class="text-muted">Status:</small><br>
                                                    <span class="badge bg-<%= "ACTIVE".equalsIgnoreCase(targetUser.getStatus()) ? "success" : "secondary" %>">
                                                        <%= targetUser.getStatus() != null ? targetUser.getStatus() : "N/A" %>
                                                    </span>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Last Login:</small><br>
                                                    <%= targetUser.getDatelastlogin() != null ? settings.formatDate(targetUser.getDatelastlogin()) : "Never" %>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">Email Verified:</small><br>
                                                    <span class="badge bg-<%= targetUser.isEmailVerified() ? "success" : "warning" %>">
                                                        <%= targetUser.isEmailVerified() ? "Yes" : "No" %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Submit Button -->
                            <div class="row">
                                <div class="col-md-12 text-center">
                                    <button type="submit" name="submitUpdate" class="btn btn-primary btn-update btn-lg">
                                        <i class="fas fa-save me-2"></i>Update User Details
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <% } else if (searchQuery != null && !searchQuery.trim().isEmpty()) { %>
                <!-- No User Found -->
                <div class="user-details-card">
                    <div class="no-user-found">
                        <i class="fas fa-user-slash"></i>
                        <h4>No User Found</h4>
                        <p class="text-muted">Try searching with a different username, email, or user ID</p>
                    </div>
                </div>
                <% } %>
                
            </div>
        </div>
    </div>

    <%@include file="WEB-INF/jspf/footer.jspf"%>
    <%@include file="WEB-INF/jspf/footerjs.jspf"%>
</body>
</html>
