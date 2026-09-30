<%-- 
    Document   : adminUtmeSubjects
    Created on : January 2025
    Author     : BEMGBA
--%>

<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    String msg = "";
    String sty = "danger";
    
    // Handle form submissions
    String action = request.getParameter("action");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String abbreviation = request.getParameter("abbreviation");
    String status = request.getParameter("status");
    
    if (action != null) {
        if (action.equals("add") && name != null && name.trim().length() > 0) {
            try {
                Utmesubjects subject = new Utmesubjects();
                subject.setId(id.trim().toUpperCase());
                subject.setName(name.trim().toUpperCase());
                subject.setAbbreviation(abbreviation != null ? abbreviation.trim().toUpperCase() : "");
                subject.setStatus(status != null ? status : "ACTIVE");
                
                String result = sess.saveUtmeSubject(subject);
                if (result.equals("Success")) {
                    msg = "UTME Subject added successfully";
                    sty = "success";
                } else {
                    msg = result;
                    sty = "danger";
                }
            } catch (Exception e) {
                msg = "Error adding subject: " + e.getMessage();
                sty = "danger";
            }
        } else if (action.equals("update") && id != null && name != null) {
            try {
                Utmesubjects subject = new Utmesubjects();
                subject.setId(id.trim().toUpperCase());
                subject.setName(name.trim().toUpperCase());
                subject.setAbbreviation(abbreviation != null ? abbreviation.trim().toUpperCase() : "");
                subject.setStatus(status != null ? status : "ACTIVE");
                
                String result = sess.updateUtmeSubject(subject);
                if (result.equals("Success")) {
                    msg = "UTME Subject updated successfully";
                    sty = "success";
                } else {
                    msg = result;
                    sty = "danger";
                }
            } catch (Exception e) {
                msg = "Error updating subject: " + e.getMessage();
                sty = "danger";
            }
        } else if (action.equals("delete") && id != null) {
            try {
                String result = sess.deleteUtmeSubject(id);
                if (result.equals("Success")) {
                    msg = "UTME Subject deleted successfully";
                    sty = "success";
                } else {
                    msg = result;
                    sty = "danger";
                }
            } catch (Exception e) {
                msg = "Error deleting subject: " + e.getMessage();
                sty = "danger";
            }
        }
    }
    
    // Get all UTME subjects
    List<Utmesubjects> allSubjects = sess.getAlUtmesubjects("ACTIVE");
    List<Utmesubjects> inactiveSubjects = sess.getAlUtmesubjects("INACTIVE");
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - UTME Subjects Management</title>
        <style>
            .subject-card {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            .subject-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .subject-id {
                font-family: 'Courier New', monospace;
                font-weight: bold;
                color: #0d6efd;
            }
            .btn-group-sm .btn {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">UTME Subjects Management</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <!-- Success/Error Messages -->
                    <%
                        if (msg.length() > 0) {
                    %>
                    <div class="alert alert-<%=sty%> alert-dismissible fade show" role="alert">
                        <strong><%=sty.equals("success") ? "Success!" : "Error!"%></strong> <%=msg%>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                    %>
                    
                    <!-- Add New Subject Form -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5><i class="fas fa-plus me-2"></i>Add New UTME Subject</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="">
                                <input type="hidden" name="action" value="add">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="id" class="form-label">Subject ID <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="id" name="id" required 
                                                   placeholder="e.g., MAT, PHY, CHE" maxlength="10" style="text-transform: uppercase;">
                                            <small class="form-text text-muted">Short unique identifier (3-10 characters)</small>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="name" class="form-label">Subject Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="name" name="name" required 
                                                   placeholder="e.g., MATHEMATICS" maxlength="150" style="text-transform: uppercase;">
                                            <small class="form-text text-muted">Full subject name as it appears in JAMB</small>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="abbreviation" class="form-label">Abbreviation</label>
                                            <input type="text" class="form-control" id="abbreviation" name="abbreviation" 
                                                   placeholder="e.g., MATH" maxlength="50" style="text-transform: uppercase;">
                                            <small class="form-text text-muted">Optional short form</small>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="mb-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select class="form-select" id="status" name="status">
                                                <option value="ACTIVE">ACTIVE</option>
                                                <option value="INACTIVE">INACTIVE</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-plus me-1"></i>Add Subject
                                </button>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Active Subjects -->
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-list me-2"></i>Active UTME Subjects (<%=allSubjects.size()%>)</h5>
                            <span class="badge bg-success">Active</span>
                        </div>
                        <div class="card-body">
                            <%
                                if (allSubjects.isEmpty()) {
                            %>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                No UTME subjects found. Add subjects above to enable UTME applicant uploads.
                            </div>
                            <%
                                } else {
                            %>
                            <div class="row">
                                <%
                                    for (Utmesubjects subject : allSubjects) {
                                %>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="card subject-card h-100">
                                        <div class="card-body">
                                            <h6 class="card-title">
                                                <span class="subject-id"><%=subject.getId()%></span>
                                                <span class="badge bg-success ms-2"><%=subject.getStatus()%></span>
                                            </h6>
                                            <p class="card-text">
                                                <strong><%=subject.getName()%></strong><br>
                                                <%
                                                    if (subject.getAbbreviation() != null && !subject.getAbbreviation().trim().isEmpty()) {
                                                %>
                                                <small class="text-muted">Abbrev: <%=subject.getAbbreviation()%></small>
                                                <%
                                                    }
                                                %>
                                            </p>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <button type="button" class="btn btn-outline-primary" 
                                                        onclick="editSubject('<%=subject.getId()%>', '<%=subject.getName()%>', '<%=subject.getAbbreviation() != null ? subject.getAbbreviation() : ""%>', '<%=subject.getStatus()%>')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button type="button" class="btn btn-outline-danger" 
                                                        onclick="deleteSubject('<%=subject.getId()%>', '<%=subject.getName()%>')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    
                    <!-- Inactive Subjects (if any) -->
                    <%
                        if (!inactiveSubjects.isEmpty()) {
                    %>
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5><i class="fas fa-archive me-2"></i>Inactive UTME Subjects (<%=inactiveSubjects.size()%>)</h5>
                            <span class="badge bg-secondary">Inactive</span>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <%
                                    for (Utmesubjects subject : inactiveSubjects) {
                                %>
                                <div class="col-md-6 col-lg-4 mb-3">
                                    <div class="card subject-card h-100 border-secondary">
                                        <div class="card-body">
                                            <h6 class="card-title">
                                                <span class="subject-id text-muted"><%=subject.getId()%></span>
                                                <span class="badge bg-secondary ms-2"><%=subject.getStatus()%></span>
                                            </h6>
                                            <p class="card-text text-muted">
                                                <strong><%=subject.getName()%></strong><br>
                                                <%
                                                    if (subject.getAbbreviation() != null && !subject.getAbbreviation().trim().isEmpty()) {
                                                %>
                                                <small>Abbrev: <%=subject.getAbbreviation()%></small>
                                                <%
                                                    }
                                                %>
                                            </p>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <button type="button" class="btn btn-outline-primary" 
                                                        onclick="editSubject('<%=subject.getId()%>', '<%=subject.getName()%>', '<%=subject.getAbbreviation() != null ? subject.getAbbreviation() : ""%>', '<%=subject.getStatus()%>')">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button type="button" class="btn btn-outline-danger" 
                                                        onclick="deleteSubject('<%=subject.getId()%>', '<%=subject.getName()%>')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                    
                    <!-- Usage Information -->
                    <div class="card">
                        <div class="card-header">
                            <h5><i class="fas fa-info-circle me-2"></i>Important Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6>Subject Requirements:</h6>
                                    <ul class="list-unstyled">
                                        <li><i class="fas fa-check text-success me-2"></i>Subject ID must be unique (3-10 characters)</li>
                                        <li><i class="fas fa-check text-success me-2"></i>Subject name must match JAMB naming exactly</li>
                                        <li><i class="fas fa-check text-success me-2"></i>Use UPPERCASE for consistency</li>
                                        <li><i class="fas fa-check text-success me-2"></i>Only ACTIVE subjects are used in uploads</li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6>Common UTME Subjects:</h6>
                                    <div class="row">
                                        <div class="col-6">
                                            <small class="text-muted">
                                                • MATHEMATICS<br>
                                                • PHYSICS<br>
                                                • CHEMISTRY<br>
                                                • BIOLOGY<br>
                                                • ENGLISH LANGUAGE
                                            </small>
                                        </div>
                                        <div class="col-6">
                                            <small class="text-muted">
                                                • ECONOMICS<br>
                                                • GEOGRAPHY<br>
                                                • GOVERNMENT<br>
                                                • LITERATURE IN ENGLISH<br>
                                                • AGRICULTURAL SCIENCE
                                            </small>
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
        
        <!-- Edit Subject Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Edit UTME Subject</h5>
                        <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="">
                        <input type="hidden" name="action" value="update">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editId" class="form-label">Subject ID</label>
                                <input type="text" class="form-control" id="editId" name="id" readonly>
                                <small class="form-text text-muted">Subject ID cannot be changed</small>
                            </div>
                            <div class="mb-3">
                                <label for="editName" class="form-label">Subject Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="editName" name="name" required maxlength="150" style="text-transform: uppercase;">
                            </div>
                            <div class="mb-3">
                                <label for="editAbbreviation" class="form-label">Abbreviation</label>
                                <input type="text" class="form-control" id="editAbbreviation" name="abbreviation" maxlength="50" style="text-transform: uppercase;">
                            </div>
                            <div class="mb-3">
                                <label for="editStatus" class="form-label">Status</label>
                                <select class="form-select" id="editStatus" name="status">
                                    <option value="ACTIVE">ACTIVE</option>
                                    <option value="INACTIVE">INACTIVE</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-coreui-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Subject</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="post" action="">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteId" name="id">
                        <div class="modal-body">
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Are you sure you want to delete the UTME subject <strong id="deleteSubjectName"></strong>?
                            </div>
                            <p class="text-muted">This action cannot be undone. The subject will only be deleted if it's not being used by any applicants.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-coreui-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Delete Subject</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        
        <script>
            function editSubject(id, name, abbreviation, status) {
                document.getElementById('editId').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editAbbreviation').value = abbreviation;
                document.getElementById('editStatus').value = status;
                
                var editModal = new coreui.Modal(document.getElementById('editModal'));
                editModal.show();
            }
            
            function deleteSubject(id, name) {
                document.getElementById('deleteId').value = id;
                document.getElementById('deleteSubjectName').textContent = name;
                
                var deleteModal = new coreui.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }
            
            // Auto-uppercase input fields
            document.addEventListener('DOMContentLoaded', function() {
                const uppercaseInputs = document.querySelectorAll('input[style*="text-transform: uppercase"]');
                uppercaseInputs.forEach(input => {
                    input.addEventListener('input', function() {
                        this.value = this.value.toUpperCase();
                    });
                });
            });
        </script>
    </body>
</html>