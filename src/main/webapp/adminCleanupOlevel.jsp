<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%
    // Use same authentication as staff dashboard - just check if user exists
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
%>

<%
    String action = request.getParameter("action");
    String userId = request.getParameter("userId");
    String message = "";
    String messageType = "info";
    
    if ("cleanup".equals(action) && userId != null && !userId.trim().isEmpty()) {
        try {
            sess.cleanupDuplicateOlevelSittings(userId.trim());
            message = "Successfully cleaned up duplicate O-level sittings for user: " + userId;
            messageType = "success";
        } catch (Exception e) {
            message = "Error cleaning up data: " + e.getMessage();
            messageType = "danger";
        }
    }
%>

<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - O-Level Cleanup Utility</title>
</head>
<body>
    <%@include file="WEB-INF/jspf/navigations.jspf"%>
    
    <div class="wrapper d-flex flex-column min-vh-100">
        <header class="header header-sticky p-0">
            <%@include file="WEB-INF/jspf/header_staff.jspf"%>
            <div class="container-fluid px-4">
                <h2 class="title">O-Level Data Cleanup Utility</h2>
            </div>
        </header>
        
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                
                <% if (!message.isEmpty()) { %>
                <div class="alert alert-<%=messageType%>">
                    <%=message%>
                </div>
                <% } %>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <h5>Cleanup Duplicate O-Level Sittings</h5>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-warning">
                            <strong>Warning:</strong> This utility will clean up duplicate sitting records for a user.
                            It will keep only one record per sitting type (First/Second) and delete duplicates.
                            <br><strong>Use with caution - this action cannot be undone!</strong>
                        </div>
                        
                        <form method="post" action="">
                            <input type="hidden" name="action" value="cleanup">
                            
                            <div class="mb-3">
                                <label for="userId" class="form-label">User/Applicant ID:</label>
                                <input type="text" class="form-control" id="userId" name="userId" 
                                       placeholder="Enter user ID (e.g., main2517082)" required>
                                <div class="form-text">
                                    Enter the User ID or Applicant ID that has duplicate O-level sitting records.
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-danger" 
                                    onclick="return confirm('Are you sure you want to cleanup duplicate O-level sittings for this user? This action cannot be undone!')">
                                <svg class="icon me-1">
                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-broom"></use>
                                </svg>
                                Cleanup Duplicates
                            </button>
                        </form>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5>How It Works</h5>
                    </div>
                    <div class="card-body">
                        <ol>
                            <li>The utility finds all O-level result records for the specified user</li>
                            <li>Groups them by sitting type (First/Second)</li>
                            <li>For each sitting type with duplicates:
                                <ul>
                                    <li>Keeps the earliest record (by date added)</li>
                                    <li>Deletes all associated subject items for duplicate records</li>
                                    <li>Deletes the duplicate sitting records</li>
                                </ul>
                            </li>
                            <li>Result: Maximum 2 sitting records per user (one First, one Second)</li>
                        </ol>
                        
                        <div class="alert alert-info mt-3">
                            <strong>Note:</strong> After cleanup, users will be able to properly add subjects to their existing sittings
                            without creating new duplicate sitting records.
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