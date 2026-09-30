<%-- 
    Document   : adminCreateFeesitem
    Created on : Fee Items Management (CRUD)
    Author     : Kiro AI Assistant
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    // Comprehensive user session validation
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Additional safety checks
    if (user.getDefaultRole() == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Verify session is still valid
    try {
        String userId = user.getId();
        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect("/");
            return;
        }
    } catch (Exception e) {
        response.sendRedirect("/");
        return;
    }
%>

<%
    String msg = "";
    String sty = "info";
    
    // Handle CREATE
    String createButton = request.getParameter("createButton");
    String feesItemName = request.getParameter("feesItemName");
    String feesItemDetails = request.getParameter("feesItemDetails");
    
    if (createButton != null && feesItemName != null && feesItemName.length() > 0) {
        try {
            // Check if fee item already exists
            List<Feesitems> allItems = sess.getAllFeesitems();
            boolean exists = allItems.stream().anyMatch(fi -> fi.getName().equalsIgnoreCase(feesItemName));
            
            if (!exists) {
                // Generate ID - find max ID and increment
                int maxId = 0;
                for (Feesitems item : allItems) {
                    if (item.getId() != null && item.getId() > maxId) {
                        maxId = item.getId();
                    }
                }
                int newId = maxId + 1;
                
                Feesitems fi = new Feesitems(newId);
                fi.setName(feesItemName.toUpperCase());
                fi.setDetails(feesItemDetails != null && feesItemDetails.length() > 0 ? feesItemDetails : null);
                sess.newEntry(fi);
                
                msg = "Fee item '" + feesItemName + "' created successfully with ID: " + newId;
                sty = "success";
            } else {
                msg = "Fee item '" + feesItemName + "' already exists";
                sty = "warning";
            }
        } catch (Exception e) {
            msg = "Error creating fee item: " + e.getMessage();
            sty = "danger";
            e.printStackTrace();
        }
    }
    
    // Handle UPDATE
    String updateButton = request.getParameter("updateButton");
    String updateId = request.getParameter("updateId");
    String updateName = request.getParameter("updateName");
    String updateDetails = request.getParameter("updateDetails");
    
    if (updateButton != null && updateId != null && updateId.length() > 0) {
        try {
            Integer id = Integer.parseInt(updateId);
            sess.updateFeesitems(id, updateName.toUpperCase(), updateDetails);
            
            msg = "Fee item updated successfully";
            sty = "success";
        } catch (Exception e) {
            msg = "Error updating fee item: " + e.getMessage();
            sty = "danger";
            e.printStackTrace();
        }
    }
    
    // Handle DELETE
    String deleteId = request.getParameter("deleteId");
    System.out.println("DEBUG: deleteId parameter = " + deleteId);
    if (deleteId != null && deleteId.length() > 0) {
        try {
            Integer id = Integer.parseInt(deleteId);
            System.out.println("DEBUG: Parsed ID = " + id);
            Feesitems fi = (Feesitems) sess.getSingleObject(Feesitems.class, id);
            System.out.println("DEBUG: Found Feesitems = " + (fi != null ? fi.getName() : "null"));
            if (fi != null) {
                String itemName = fi.getName(); // Store name before deletion
                
                // Check if fee item is in use
                if (sess.isFeesitemInUse(id)) {
                    msg = "Cannot delete fee item '" + itemName + "' because it is currently being used in fee setup. Please remove it from all fee setups first.";
                    sty = "warning";
                    System.out.println("DEBUG: Fee item is in use, cannot delete");
                } else {
                    System.out.println("DEBUG: About to delete fee item: " + itemName);
                    // Use the dedicated delete method
                    sess.deleteFeesitems(id);
                    System.out.println("DEBUG: Delete method completed");
                    msg = "Fee item '" + itemName + "' deleted successfully";
                    sty = "success";
                }
            } else {
                msg = "Fee item not found";
                sty = "danger";
            }
        } catch (Exception e) {
            msg = "Error deleting fee item: " + e.getMessage();
            sty = "danger";
            e.printStackTrace();
            System.out.println("DEBUG: Exception during delete: " + e.getMessage());
        }
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Fee Items Management</title>
        <style>
            .action-buttons {
                display: flex;
                gap: 5px;
            }
            .edit-row {
                background-color: #fff3cd;
            }
            .stat-card {
                transition: transform 0.2s;
            }
            .stat-card:hover {
                transform: translateY(-5px);
            }
        </style>
    </head>
    <body>
        <%
        try {
        %>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">
                        <i class="fas fa-list-alt me-2"></i>Fee Items Management
                    </h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <!-- Statistics Cards -->
                    <%
                        List<Feesitems> allFeesItems = sess.getAllFeesitems();
                        int totalItems = allFeesItems.size();
                        int itemsWithDetails = 0;
                        int itemsWithoutDetails = 0;
                        
                        for (Feesitems item : allFeesItems) {
                            if (item.getDetails() != null && item.getDetails().length() > 0) {
                                itemsWithDetails++;
                            } else {
                                itemsWithoutDetails++;
                            }
                        }
                    %>
                    
                    <div class="row mb-4">
                        <div class="col-sm-6 col-xl-4">
                            <div class="card text-white bg-primary stat-card">
                                <div class="card-body">
                                    <div class="fs-4 fw-semibold"><%=totalItems%></div>
                                    <div><i class="fas fa-list me-1"></i>Total Fee Items</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <div class="card text-white bg-success stat-card">
                                <div class="card-body">
                                    <div class="fs-4 fw-semibold"><%=itemsWithDetails%></div>
                                    <div><i class="fas fa-check-circle me-1"></i>With Details</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <div class="card text-white bg-warning stat-card">
                                <div class="card-body">
                                    <div class="fs-4 fw-semibold"><%=itemsWithoutDetails%></div>
                                    <div><i class="fas fa-exclamation-triangle me-1"></i>Without Details</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Create New Fee Item Card -->
                    <div class="col-12">
                        <div class="card mb-4 border-primary">
                            <div class="card-header bg-primary text-white">
                                <strong><i class="fas fa-plus-circle me-2"></i>Create New Fee Item</strong>
                                <a href="/fees_setup" class="btn btn-light btn-sm float-end">
                                    <i class="fas fa-arrow-left me-1"></i>Back to Fees Setup
                                </a>
                            </div>
                            <div class="card-body">
                                <%
                                    if (msg.length() > 0) {
                                %>
                                <div class="alert alert-<%=sty%> alert-dismissible fade show">
                                    <i class="fas fa-<%=sty.equals("success") ? "check-circle" : sty.equals("danger") ? "times-circle" : "info-circle"%> me-2"></i>
                                    <%=msg%>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <%
                                    }
                                %>
                                
                                <form action="" method="post" name="createFeeItem">
                                    <div class="row">
                                        <div class="col-md-5">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">
                                                    <i class="fas fa-tag"></i>
                                                </span>
                                                <input type="text" class="form-control" name="feesItemName" 
                                                       placeholder="Fee Item Name (e.g., TUITION FEE)" 
                                                       required>
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="input-group mb-3">
                                                <span class="input-group-text">
                                                    <i class="fas fa-info-circle"></i>
                                                </span>
                                                <input type="text" class="form-control" name="feesItemDetails" 
                                                       placeholder="Details (Optional)">
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" name="createButton" class="btn btn-success w-100">
                                                <i class="fas fa-plus me-1"></i>Create
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Fee Items List -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong><i class="fas fa-table me-2"></i>Fee Items List (<%=totalItems%> items)</strong>
                            </div>
                            <div class="card-body">
                                <%
                                    if (totalItems == 0) {
                                %>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No fee items found. Create your first fee item using the form above.
                                </div>
                                <%
                                    } else {
                                %>
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="text-center" style="width: 80px;">ID</th>
                                                <th>Fee Item Name</th>
                                                <th>Details</th>
                                                <th class="text-center" style="width: 150px;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                for (Feesitems item : allFeesItems) {
                                            %>
                                            <tr>
                                                <td class="text-center">
                                                    <span class="badge bg-secondary"><%=item.getId()%></span>
                                                </td>
                                                <td>
                                                    <strong><%=item.getName()%></strong>
                                                </td>
                                                <td>
                                                    <%
                                                        if (item.getDetails() != null && item.getDetails().length() > 0) {
                                                    %>
                                                    <span class="text-muted"><%=item.getDetails()%></span>
                                                    <%
                                                        } else {
                                                    %>
                                                    <em class="text-muted">No details</em>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                                <td class="text-center">
                                                    <div class="action-buttons justify-content-center">
                                                        <button type="button" 
                                                                class="btn btn-warning btn-sm edit-btn" 
                                                                data-id="<%=item.getId()%>"
                                                                data-name="<%=item.getName()%>"
                                                                data-details="<%=item.getDetails() != null ? item.getDetails() : ""%>"
                                                                title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button type="button"
                                                                class="btn btn-danger btn-sm delete-btn" 
                                                                data-id="<%=item.getId()%>"
                                                                data-name="<%=item.getName()%>"
                                                                title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        
                        <!-- Quick Reference Card -->
                        <div class="card mb-4 border-info">
                            <div class="card-header bg-info text-white">
                                <strong><i class="fas fa-lightbulb me-2"></i>Quick Reference</strong>
                            </div>
                            <div class="card-body">
                                <h6>Common Fee Items:</h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check text-success me-2"></i>TUITION FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>ACCEPTANCE FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>REGISTRATION FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>LIBRARY FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>LABORATORY FEE</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check text-success me-2"></i>HOSTEL FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>MEDICAL FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>SPORTS FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>EXAMINATION FEE</li>
                                            <li><i class="fas fa-check text-success me-2"></i>DEVELOPMENT LEVY</li>
                                        </ul>
                                    </div>
                                </div>
                                <hr>
                                <p class="mb-0 text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    <strong>Note:</strong> Fee items are used in fee setup to define specific charges for students. 
                                    Make sure to create all necessary fee items before setting up fees.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        
        <!-- Edit Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-warning text-white">
                        <h5 class="modal-title" id="editModalLabel">
                            <i class="fas fa-edit me-2"></i>Edit Fee Item
                        </h5>
                        <button type="button" class="btn-close btn-close-white close-modal" aria-label="Close"></button>
                    </div>
                    <form action="" method="post" id="editForm">
                        <div class="modal-body">
                            <input type="hidden" name="updateId" id="editId">
                            
                            <div class="mb-3">
                                <label for="editName" class="form-label">
                                    <i class="fas fa-tag me-1"></i>Fee Item Name
                                </label>
                                <input type="text" class="form-control" name="updateName" id="editName" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="editDetails" class="form-label">
                                    <i class="fas fa-info-circle me-1"></i>Details (Optional)
                                </label>
                                <textarea class="form-control" name="updateDetails" id="editDetails" rows="3"></textarea>
                            </div>
                            
                            <div class="alert alert-info mb-0">
                                <i class="fas fa-lightbulb me-1"></i>
                                <small>Changes will be saved immediately after clicking Update.</small>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary close-modal">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                            <button type="submit" name="updateButton" class="btn btn-success">
                                <i class="fas fa-save me-1"></i>Update Fee Item
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="" method="post" id="deleteForm">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title" id="deleteModalLabel">
                                <i class="fas fa-exclamation-triangle me-2"></i>Confirm Delete
                            </h5>
                            <button type="button" class="btn-close btn-close-white close-modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="deleteId" id="deleteIdInput">
                            
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <strong>Warning:</strong> This action cannot be undone!
                            </div>
                            
                            <p class="mb-0">
                                Are you sure you want to delete the fee item: 
                                <strong id="deleteItemName" class="text-danger"></strong>?
                            </p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary close-modal">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-1"></i>Yes, Delete It
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

        <script src="vendors/jquery/js/jquery.min.js"></script>
        <script src="vendors/datatables.net/js/dataTables.min.js"></script>
        <script src="vendors/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
        <script src="js/datatables.js"></script>
        <script src="js/dataTables.js"></script>
        <script src="js/dataTables.buttons.js"></script>
        <script src="js/buttons.dataTables.js"></script>
        <script src="js/jszip.min.js"></script>
        <script src="js/pdfmake.min.js"></script>
        <script src="js/vfs_fonts.js"></script>
        <script src="js/buttons.html5.min.js"></script>
        <script src="js/buttons.print.min.js"></script>
        <script src="js/jquery-3.7.1.js"></script>
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

        <script>
            $(document).ready(function () {
                console.log('Page loaded, initializing...');
                
                // Initialize DataTable
                new DataTable('#dataTable', {
                    responsive: true,
                    "info": true,
                    "pageLength": 25,
                    "lengthMenu": [10, 25, 50, 100],
                    "dom": 'lBfrtip',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    layout: {
                        topStart: 'buttons'
                    },
                    "order": [[0, "asc"]] // Sort by ID ascending
                });
                
                // Auto-dismiss alerts after 5 seconds
                setTimeout(function() {
                    $('.alert').fadeOut('slow');
                }, 5000);
                
                // Modal close functionality
                $(document).on('click', '.close-modal', function(e) {
                    e.preventDefault();
                    console.log('Close button clicked');
                    
                    // Close edit modal
                    if ($('#editModal').hasClass('show')) {
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            const editModal = bootstrap.Modal.getInstance(document.getElementById('editModal'));
                            if (editModal) {
                                editModal.hide();
                            }
                        } else {
                            $('#editModal').modal('hide');
                        }
                    }
                    
                    // Close delete modal
                    if ($('#deleteModal').hasClass('show')) {
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            const deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteModal'));
                            if (deleteModal) {
                                deleteModal.hide();
                            }
                        } else {
                            $('#deleteModal').modal('hide');
                        }
                    }
                });
                
                // Handle Edit button click
                $(document).on('click', '.edit-btn', function(e) {
                    e.preventDefault();
                    console.log('Edit button clicked');
                    
                    const id = $(this).data('id');
                    const name = $(this).data('name');
                    const details = $(this).data('details');
                    
                    console.log('Edit data:', id, name, details);
                    
                    // Populate modal fields
                    $('#editId').val(id);
                    $('#editName').val(name);
                    $('#editDetails').val(details);
                    
                    // Show modal - try multiple methods
                    try {
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            console.log('Using Bootstrap 5 Modal');
                            const editModal = new bootstrap.Modal(document.getElementById('editModal'));
                            editModal.show();
                        } else if (typeof $.fn.modal !== 'undefined') {
                            console.log('Using jQuery Modal');
                            $('#editModal').modal('show');
                        } else {
                            console.error('No modal library found');
                            alert('Modal library not loaded. Please refresh the page.');
                        }
                    } catch (err) {
                        console.error('Modal error:', err);
                        $('#editModal').modal('show');
                    }
                });
                
                // Handle Delete button click
                $(document).on('click', '.delete-btn', function(e) {
                    e.preventDefault();
                    console.log('Delete button clicked');
                    
                    const id = $(this).data('id');
                    const name = $(this).data('name');
                    
                    console.log('Delete data - ID:', id, 'Name:', name);
                    
                    // Store delete ID in hidden form input
                    $('#deleteIdInput').val(id);
                    $('#deleteItemName').text(name);
                    
                    console.log('Hidden input value set to:', $('#deleteIdInput').val());
                    
                    // Show modal - try multiple methods
                    try {
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            console.log('Using Bootstrap 5 Modal');
                            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                            deleteModal.show();
                        } else if (typeof $.fn.modal !== 'undefined') {
                            console.log('Using jQuery Modal');
                            $('#deleteModal').modal('show');
                        } else {
                            console.error('No modal library found');
                            alert('Modal library not loaded. Please refresh the page.');
                        }
                    } catch (err) {
                        console.error('Modal error:', err);
                        $('#deleteModal').modal('show');
                    }
                });
                
                // Add form submit handler to verify data
                $('#deleteForm').on('submit', function(e) {
                    const deleteIdValue = $('#deleteIdInput').val();
                    console.log('Form submitting with deleteId:', deleteIdValue);
                    
                    if (!deleteIdValue || deleteIdValue === '') {
                        e.preventDefault();
                        alert('Error: No delete ID found. Please try again.');
                        return false;
                    }
                    
                    console.log('Form submission proceeding...');
                    return true;
                });
                
                console.log('Event handlers attached');
            });
        </script>
        <%
        } catch (Exception e) {
            // Handle any null pointer exceptions gracefully
            out.println("<div class='container-lg px-4'>");
            out.println("<div class='alert alert-danger'>");
            out.println("<h4>Session Error</h4>");
            out.println("<p>Your session has expired or there was an authentication error. Please <a href='/'>login again</a>.</p>");
            out.println("</div>");
            out.println("</div>");
            e.printStackTrace();
        }
        %>
    </body>
</html>
