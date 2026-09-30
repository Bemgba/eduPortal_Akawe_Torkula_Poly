<%-- 
    Document   : updateStaff
    Created on : March 2, 2026
    Purpose    : Admin page for updating staff member information
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mnl.eduportal.entities.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Get staff_no parameter
    String searchStaffNo = request.getParameter("staff_no");
    Staff existingStaff = null;
    Users staffUser = null;
    
    if (searchStaffNo != null && !searchStaffNo.trim().isEmpty()) {
        existingStaff = sess.getStaffByStaffNo(searchStaffNo.trim().toUpperCase());
        if (existingStaff != null) {
            staffUser = (Users) sess.getSingleObject(Users.class, existingStaff.getId());
        }
    }
%>
<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - Update Staff</title>
    <style>
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .form-section-title {
            color: #0c4f24;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #1b9e3e;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .search-section {
            background: #e8f5e9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #1b9e3e;
        }
        .staff-info-badge {
            background: #0c4f24;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            display: inline-block;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <%@include file="WEB-INF/jspf/navigations.jspf"%>

    <div class="wrapper d-flex flex-column min-vh-100">
        <header class="header header-sticky p-0">
            <%@include file="WEB-INF/jspf/header_staff.jspf"%>
            <div class="container-fluid px-4">
                <h2 class="title">Update Staff Information</h2>
            </div>
        </header>
        
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                
                <%
                    // Backend Processing for Staff Update
                    String submitUpdate = request.getParameter("submitUpdate");
                    String msg = "";
                    String msgType = "danger";
                    
                    if (submitUpdate != null && existingStaff != null) {
                        try {
                            boolean updated = false;
                            
                            // Get form parameters
                            String title = request.getParameter("title");
                            String gender = request.getParameter("gender");
                            String surname = request.getParameter("surname");
                            String othernames = request.getParameter("othernames");
                            String dateOfBirth = request.getParameter("dateOfBirth");
                            String maritalStatus = request.getParameter("maritalStatus");
                            String maidenName = request.getParameter("maidenName");
                            String personalEmail = request.getParameter("personalEmail");
                            String officialEmail = request.getParameter("officialEmail");
                            String phoneNo = request.getParameter("phoneNo");
                            String currentQualification = request.getParameter("currentQualification");
                            String areaOfStudy = request.getParameter("areaOfStudy");
                            String serviceStatus = request.getParameter("serviceStatus");
                            
                            // Update only changed fields
                            if (title != null && !title.equals(existingStaff.getTitle() != null ? existingStaff.getTitle() : "")) {
                                existingStaff.setTitle(title.trim().isEmpty() ? null : title.trim());
                                updated = true;
                            }
                            
                            if (gender != null && !gender.equals(existingStaff.getGender() != null ? existingStaff.getGender() : "")) {
                                existingStaff.setGender(gender.trim().isEmpty() ? null : gender);
                                updated = true;
                            }
                            
                            if (surname != null && !surname.trim().isEmpty() && !surname.equals(existingStaff.getSurname())) {
                                existingStaff.setSurname(surname.trim());
                                updated = true;
                            }
                            
                            if (othernames != null && !othernames.trim().isEmpty() && !othernames.equals(existingStaff.getOthernames())) {
                                existingStaff.setOthernames(othernames.trim());
                                updated = true;
                            }
                            
                            if (dateOfBirth != null && !dateOfBirth.equals(existingStaff.getDateOfBirth() != null ? existingStaff.getDateOfBirth() : "")) {
                                existingStaff.setDateOfBirth(dateOfBirth.trim().isEmpty() ? null : dateOfBirth);
                                updated = true;
                            }
                            
                            if (maritalStatus != null && !maritalStatus.equals(existingStaff.getMaritalStatus() != null ? existingStaff.getMaritalStatus() : "")) {
                                existingStaff.setMaritalStatus(maritalStatus.trim().isEmpty() ? null : maritalStatus);
                                updated = true;
                            }
                            
                            if (maidenName != null && !maidenName.equals(existingStaff.getMaidenName() != null ? existingStaff.getMaidenName() : "")) {
                                existingStaff.setMaidenName(maidenName.trim().isEmpty() ? null : maidenName.trim());
                                updated = true;
                            }
                            
                            if (personalEmail != null && !personalEmail.trim().isEmpty() && !personalEmail.equalsIgnoreCase(existingStaff.getPersonalEmailAddress())) {
                                // Check if new email already exists
                                Users emailCheck = sess.getUsersByEmail(personalEmail.trim().toLowerCase());
                                if (emailCheck != null && !emailCheck.getId().equals(existingStaff.getId())) {
                                    msg = "Email address " + personalEmail + " is already registered to another user!";
                                    msgType = "danger";
                                } else {
                                    existingStaff.setPersonalEmailAddress(personalEmail.trim().toLowerCase());
                                    if (staffUser != null) {
                                        staffUser.setEmail(personalEmail.trim().toLowerCase());
                                    }
                                    updated = true;
                                }
                            }
                            
                            if (officialEmail != null && !officialEmail.equals(existingStaff.getOfficialEmailAddress() != null ? existingStaff.getOfficialEmailAddress() : "")) {
                                existingStaff.setOfficialEmailAddress(officialEmail.trim().isEmpty() ? null : officialEmail.trim().toLowerCase());
                                updated = true;
                            }
                            
                            if (phoneNo != null && !phoneNo.trim().isEmpty() && !phoneNo.equals(existingStaff.getPhoneNo())) {
                                existingStaff.setPhoneNo(phoneNo.trim());
                                updated = true;
                            }
                            
                            if (currentQualification != null && !currentQualification.equals(existingStaff.getCurrentQualification() != null ? existingStaff.getCurrentQualification() : "")) {
                                existingStaff.setCurrentQualification(currentQualification.trim().isEmpty() ? null : currentQualification.trim());
                                updated = true;
                            }
                            
                            if (areaOfStudy != null && !areaOfStudy.equals(existingStaff.getAreaOfStudy() != null ? existingStaff.getAreaOfStudy() : "")) {
                                existingStaff.setAreaOfStudy(areaOfStudy.trim().isEmpty() ? null : areaOfStudy.trim());
                                updated = true;
                            }
                            
                            if (serviceStatus != null && !serviceStatus.equals(existingStaff.getServiceStatus() != null ? existingStaff.getServiceStatus() : "")) {
                                existingStaff.setServiceStatus(serviceStatus.trim().isEmpty() ? null : serviceStatus);
                                updated = true;
                            }
                            
                            // Handle foreign key relationships
                            String nationalityId = request.getParameter("nationalityId");
                            String departmentId = request.getParameter("departmentId");
                            String facultyId = request.getParameter("facultyId");
                            String stateId = request.getParameter("stateId");
                            String lgaId = request.getParameter("lgaId");
                            String positionId = request.getParameter("positionId");
                            String unitId = request.getParameter("unitId");
                            
                            if (nationalityId != null && nationalityId.matches("\\d+")) {
                                int natId = Integer.parseInt(nationalityId);
                                if (existingStaff.getNationalityId() == null || existingStaff.getNationalityId().getId() != natId) {
                                    Countries country = (Countries) sess.getSingleObject(Countries.class, natId);
                                    if (country != null) {
                                        existingStaff.setNationalityId(country);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (departmentId != null && !departmentId.isEmpty()) {
                                if (existingStaff.getDepartmentId() == null || !existingStaff.getDepartmentId().getId().equals(departmentId)) {
                                    Departments dept = (Departments) sess.getSingleObject(Departments.class, departmentId);
                                    if (dept != null) {
                                        existingStaff.setDepartmentId(dept);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (facultyId != null && !facultyId.isEmpty()) {
                                if (existingStaff.getFacultyDirectorateId() == null || !existingStaff.getFacultyDirectorateId().getId().equals(facultyId)) {
                                    FacultiesDirectorates faculty = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, facultyId);
                                    if (faculty != null) {
                                        existingStaff.setFacultyDirectorateId(faculty);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (stateId != null && stateId.matches("\\d+")) {
                                int sId = Integer.parseInt(stateId);
                                if (existingStaff.getStateOfOriginId() == null || existingStaff.getStateOfOriginId().getId() != sId) {
                                    States state = (States) sess.getSingleObject(States.class, sId);
                                    if (state != null) {
                                        existingStaff.setStateOfOriginId(state);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (lgaId != null && lgaId.matches("\\d+")) {
                                int lId = Integer.parseInt(lgaId);
                                if (existingStaff.getLgaId() == null || existingStaff.getLgaId().getId() != lId) {
                                    Lgas lga = (Lgas) sess.getSingleObject(Lgas.class, lId);
                                    if (lga != null) {
                                        existingStaff.setLgaId(lga);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (positionId != null && !positionId.isEmpty()) {
                                if (existingStaff.getPositionId() == null || !existingStaff.getPositionId().getId().equals(positionId)) {
                                    Positions position = (Positions) sess.getSingleObject(Positions.class, positionId);
                                    if (position != null) {
                                        existingStaff.setPositionId(position);
                                        updated = true;
                                    }
                                }
                            }
                            
                            if (unitId != null && !unitId.isEmpty()) {
                                if (existingStaff.getUnitId() == null || !existingStaff.getUnitId().getId().equals(unitId)) {
                                    Units unit = (Units) sess.getSingleObject(Units.class, unitId);
                                    if (unit != null) {
                                        existingStaff.setUnitId(unit);
                                        updated = true;
                                    }
                                }
                            }
                            
                            // Save updates if any changes were made
                            if (updated && msg.isEmpty()) {
                                try {
                                    if (staffUser != null) {
                                        sess.updateObject(staffUser);
                                    }
                                    sess.updateObject(existingStaff);
                                    
                                    msg = "Staff information for " + existingStaff.getStaffNo() + " (" + existingStaff.getSurname() + " " + existingStaff.getOthernames() + ") updated successfully!";
                                    msgType = "success";
                                    
                                    // Reload the updated staff data
                                    existingStaff = sess.getStaffByStaffNo(existingStaff.getStaffNo());
                                    if (existingStaff != null) {
                                        staffUser = (Users) sess.getSingleObject(Users.class, existingStaff.getId());
                                    }
                                } catch (Exception saveEx) {
                                    msg = "Error updating staff: " + saveEx.getMessage();
                                    msgType = "danger";
                                    saveEx.printStackTrace();
                                }
                            } else if (!updated && msg.isEmpty()) {
                                msg = "No changes detected. Please modify at least one field to update.";
                                msgType = "info";
                            }
                        } catch (Exception e) {
                            msg = "Error: " + e.getMessage();
                            msgType = "danger";
                            e.printStackTrace();
                        }
                    }
                %>
                
                <!-- Display Message -->
                <% if (!msg.isEmpty()) { %>
                <div class="alert alert-<%=msgType%> alert-dismissible fade show" role="alert">
                    <strong><%= msgType.equals("success") ? "✓" : msgType.equals("info") ? "ℹ" : "✗" %></strong> <%=msg%>
                    <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                </div>
                <% } %>
                
                <!-- Search Section -->
                <div class="search-section">
                    <h5 class="mb-3"><i class="fas fa-search me-2"></i>Search Staff Member</h5>
                    <form action="" method="GET" class="row g-3">
                        <div class="col-md-8">
                            <input type="text" class="form-control" name="staff_no" 
                                   placeholder="Enter Staff Number (e.g., ATPM/REG/PER-001)" 
                                   value="<%=searchStaffNo != null ? searchStaffNo : ""%>" required>
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-2"></i>Search
                            </button>
                        </div>
                    </form>
                </div>
                
                <% if (existingStaff != null) { %>
                <!-- Staff Update Form -->
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Update Staff Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="staff-info-badge">
                            <i class="fas fa-id-badge me-2"></i>
                            <strong>Staff Number:</strong> <%=existingStaff.getStaffNo()%> | 
                            <strong>Name:</strong> <%=existingStaff.getSurname()%> <%=existingStaff.getOthernames()%>
                        </div>
                        
                        <form action="" method="POST">
                            <input type="hidden" name="staff_no" value="<%=existingStaff.getStaffNo()%>">
                            
                            <!-- Basic Information Section -->
                            <div class="form-section">
                                <h5 class="form-section-title">Basic Information</h5>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Title</label>
                                        <select class="form-select" name="title">
                                            <option value="">Select Title</option>
                                            <option value="Mr" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Mr") ? "selected" : ""%>>Mr</option>
                                            <option value="Mrs" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Mrs") ? "selected" : ""%>>Mrs</option>
                                            <option value="Miss" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Miss") ? "selected" : ""%>>Miss</option>
                                            <option value="Dr" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Dr") ? "selected" : ""%>>Dr</option>
                                            <option value="Prof" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Prof") ? "selected" : ""%>>Prof</option>
                                            <option value="Engr" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Engr") ? "selected" : ""%>>Engr</option>
                                            <option value="Arc" <%=existingStaff.getTitle() != null && existingStaff.getTitle().equals("Arc") ? "selected" : ""%>>Arc</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Gender</label>
                                        <select class="form-select" name="gender">
                                            <option value="">Select Gender</option>
                                            <option value="Male" <%=existingStaff.getGender() != null && existingStaff.getGender().equals("Male") ? "selected" : ""%>>Male</option>
                                            <option value="Female" <%=existingStaff.getGender() != null && existingStaff.getGender().equals("Female") ? "selected" : ""%>>Female</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Date of Birth</label>
                                        <input type="date" class="form-control" name="dateOfBirth" 
                                               value="<%=existingStaff.getDateOfBirth() != null ? existingStaff.getDateOfBirth() : ""%>">
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label required-field">Surname</label>
                                        <input type="text" class="form-control" name="surname" required 
                                               value="<%=existingStaff.getSurname()%>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label required-field">Other Names</label>
                                        <input type="text" class="form-control" name="othernames" required 
                                               value="<%=existingStaff.getOthernames()%>">
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Marital Status</label>
                                        <select class="form-select" name="maritalStatus">
                                            <option value="">Select Status</option>
                                            <option value="Single" <%=existingStaff.getMaritalStatus() != null && existingStaff.getMaritalStatus().equals("Single") ? "selected" : ""%>>Single</option>
                                            <option value="Married" <%=existingStaff.getMaritalStatus() != null && existingStaff.getMaritalStatus().equals("Married") ? "selected" : ""%>>Married</option>
                                            <option value="Divorced" <%=existingStaff.getMaritalStatus() != null && existingStaff.getMaritalStatus().equals("Divorced") ? "selected" : ""%>>Divorced</option>
                                            <option value="Widowed" <%=existingStaff.getMaritalStatus() != null && existingStaff.getMaritalStatus().equals("Widowed") ? "selected" : ""%>>Widowed</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Maiden Name</label>
                                        <input type="text" class="form-control" name="maidenName" 
                                               value="<%=existingStaff.getMaidenName() != null ? existingStaff.getMaidenName() : ""%>">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Contact Information Section -->
                            <div class="form-section">
                                <h5 class="form-section-title">Contact Information</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label required-field">Personal Email</label>
                                        <input type="email" class="form-control" name="personalEmail" required 
                                               value="<%=existingStaff.getPersonalEmailAddress()%>">
                                        <small class="text-muted">Used for login</small>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Official Email</label>
                                        <input type="email" class="form-control" name="officialEmail" 
                                               value="<%=existingStaff.getOfficialEmailAddress() != null ? existingStaff.getOfficialEmailAddress() : ""%>">
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label required-field">Phone Number</label>
                                        <input type="tel" class="form-control" name="phoneNo" required 
                                               value="<%=existingStaff.getPhoneNo()%>">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Academic/Professional Information Section -->
                            <div class="form-section">
                                <h5 class="form-section-title">Academic & Professional Information</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Current Qualification</label>
                                        <select class="form-select" name="currentQualification">
                                            <option value="">Select Qualification</option>
                                            <option value="SSCE" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("SSCE") ? "selected" : ""%>>SSCE</option>
                                            <option value="OND" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("OND") ? "selected" : ""%>>OND</option>
                                            <option value="NCE" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("NCE") ? "selected" : ""%>>NCE</option>
                                            <option value="HND" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("HND") ? "selected" : ""%>>HND</option>
                                            <option value="B.Sc" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("B.Sc") ? "selected" : ""%>>B.Sc</option>
                                            <option value="B.A" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("B.A") ? "selected" : ""%>>B.A</option>
                                            <option value="B.Ed" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("B.Ed") ? "selected" : ""%>>B.Ed</option>
                                            <option value="M.Sc" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("M.Sc") ? "selected" : ""%>>M.Sc</option>
                                            <option value="M.A" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("M.A") ? "selected" : ""%>>M.A</option>
                                            <option value="M.Ed" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("M.Ed") ? "selected" : ""%>>M.Ed</option>
                                            <option value="Ph.D" <%=existingStaff.getCurrentQualification() != null && existingStaff.getCurrentQualification().equals("Ph.D") ? "selected" : ""%>>Ph.D</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Area of Study</label>
                                        <input type="text" class="form-control" name="areaOfStudy" 
                                               value="<%=existingStaff.getAreaOfStudy() != null ? existingStaff.getAreaOfStudy() : ""%>">
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Service Status</label>
                                        <select class="form-select" name="serviceStatus">
                                            <option value="">Select Status</option>
                                            <option value="Active" <%=existingStaff.getServiceStatus() != null && existingStaff.getServiceStatus().equals("Active") ? "selected" : ""%>>Active</option>
                                            <option value="On Leave" <%=existingStaff.getServiceStatus() != null && existingStaff.getServiceStatus().equals("On Leave") ? "selected" : ""%>>On Leave</option>
                                            <option value="Suspended" <%=existingStaff.getServiceStatus() != null && existingStaff.getServiceStatus().equals("Suspended") ? "selected" : ""%>>Suspended</option>
                                            <option value="Retired" <%=existingStaff.getServiceStatus() != null && existingStaff.getServiceStatus().equals("Retired") ? "selected" : ""%>>Retired</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Organizational Information Section -->
                            <div class="form-section">
                                <h5 class="form-section-title">Organizational Information</h5>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Faculty/Directorate</label>
                                        <select class="form-select" name="facultyId">
                                            <option value="">Select Faculty/Directorate</option>
                                            <%
                                                try {
                                                    List<FacultiesDirectorates> faculties = sess.getAllFacultiesDirectorates();
                                                    for (FacultiesDirectorates fac : faculties) {
                                                        boolean selected = existingStaff.getFacultyDirectorateId() != null && 
                                                                         existingStaff.getFacultyDirectorateId().getId().equals(fac.getId());
                                            %>
                                            <option value="<%=fac.getId()%>" <%=selected ? "selected" : ""%>><%=fac.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Department</label>
                                        <select class="form-select" name="departmentId">
                                            <option value="">Select Department</option>
                                            <%
                                                try {
                                                    List<Departments> departments = sess.getAllDepartments();
                                                    for (Departments dept : departments) {
                                                        boolean selected = existingStaff.getDepartmentId() != null && 
                                                                         existingStaff.getDepartmentId().getId().equals(dept.getId());
                                            %>
                                            <option value="<%=dept.getId()%>" <%=selected ? "selected" : ""%>><%=dept.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Position</label>
                                        <select class="form-select" name="positionId">
                                            <option value="">Select Position</option>
                                            <%
                                                try {
                                                    List<Positions> positions = sess.getAllPositions();
                                                    for (Positions pos : positions) {
                                                        boolean selected = existingStaff.getPositionId() != null && 
                                                                         existingStaff.getPositionId().getId() == pos.getId();
                                            %>
                                            <option value="<%=pos.getId()%>" <%=selected ? "selected" : ""%>><%=pos.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Unit</label>
                                        <select class="form-select" name="unitId">
                                            <option value="">Select Unit</option>
                                            <%
                                                try {
                                                    java.util.List unitsList = sess.getAllUnits();
                                                    for (Object obj : unitsList) {
                                                        Units unit = (Units) obj;
                                                        boolean selected = existingStaff.getUnitId() != null && 
                                                                         existingStaff.getUnitId().getId() == unit.getId();
                                            %>
                                            <option value="<%=unit.getId()%>" <%=selected ? "selected" : ""%>><%=unit.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Location Information Section -->
                            <div class="form-section">
                                <h5 class="form-section-title">Location Information</h5>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Nationality</label>
                                        <select class="form-select" name="nationalityId">
                                            <option value="">Select Country</option>
                                            <%
                                                try {
                                                    List<Countries> countries = sess.getAllCountries();
                                                    for (Countries country : countries) {
                                                        boolean selected = existingStaff.getNationalityId() != null && 
                                                                         existingStaff.getNationalityId().getId() == country.getId();
                                            %>
                                            <option value="<%=country.getId()%>" <%=selected ? "selected" : ""%>><%=country.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                    
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Country (for State/LGA)</label>
                                        <select class="form-select" name="countryForLocation" id="countrySelect" onchange="loadStates();">
                                            <option value="">Select Country</option>
                                            <%
                                                try {
                                                    List<Countries> countries2 = sess.getAllCountries();
                                                    // Determine which country to select based on existing state
                                                    Integer selectedCountryId = 160; // Default to Nigeria
                                                    if (existingStaff.getStateOfOriginId() != null && 
                                                        existingStaff.getStateOfOriginId().getCountryId() != null) {
                                                        selectedCountryId = existingStaff.getStateOfOriginId().getCountryId().getId();
                                                    }
                                                    
                                                    for (Countries country : countries2) {
                                                        boolean isSelected = country.getId().equals(selectedCountryId);
                                            %>
                                            <option value="<%=country.getId()%>" <%=isSelected ? "selected" : ""%>><%=country.getName()%></option>
                                            <%
                                                    }
                                                } catch (Exception e) {}
                                            %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">State of Origin</label>
                                        <select class="form-select" name="stateId" id="stateSelect" onchange="loadLgas();"
                                                data-selected-state="<%=existingStaff.getStateOfOriginId() != null ? existingStaff.getStateOfOriginId().getId() : ""%>">
                                            <option value="">Select State</option>
                                            <%
                                                if (existingStaff.getStateOfOriginId() != null) {
                                            %>
                                            <option value="<%=existingStaff.getStateOfOriginId().getId()%>" selected><%=existingStaff.getStateOfOriginId().getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">LGA</label>
                                        <select class="form-select" name="lgaId" id="lgaSelect"
                                                data-selected-lga="<%=existingStaff.getLgaId() != null ? existingStaff.getLgaId().getId() : ""%>">
                                            <option value="">Select LGA</option>
                                            <%
                                                if (existingStaff.getLgaId() != null) {
                                            %>
                                            <option value="<%=existingStaff.getLgaId().getId()%>" selected><%=existingStaff.getLgaId().getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Submit Buttons -->
                            <div class="text-end mt-4">
                                <a href="updateStaff.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <button type="submit" name="submitUpdate" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Update Staff Information
                                </button>
                            </div>
                            
                            <div class="alert alert-info mt-3">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Note:</strong> Only modified fields will be updated. Unchanged fields will retain their existing values.
                            </div>
                        </form>
                    </div>
                </div>
                <% } else if (searchStaffNo != null && !searchStaffNo.trim().isEmpty()) { %>
                <!-- Staff Not Found Message -->
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Staff Not Found!</strong> No staff member found with Staff Number: <strong><%=searchStaffNo%></strong>
                    <br><small>Please verify the staff number and try again.</small>
                </div>
                <% } else { %>
                <!-- Initial Instructions -->
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    <strong>Welcome to Staff Update!</strong> Enter a staff number in the search box above to load and update staff information.
                </div>
                <% } %>
                
            </div>
        </div>
        
        <%@include file="WEB-INF/jspf/footer.jspf"%>
    </div>
    
    <%@include file="WEB-INF/jspf/footerjs.jspf"%>
    
    <script>
        // AJAX request initialization
        var req;
        
        function initRequest() {
            if (window.XMLHttpRequest) {
                return new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                return new ActiveXObject("Microsoft.XMLHTTP");
            }
        }
        
        // Load States based on selected country
        function loadStates() {
            var countrySelect = document.getElementById("countrySelect");
            if (!countrySelect) {
                console.error("Country select element not found");
                return;
            }
            
            var countryId = countrySelect.value;
            
            if (!countryId || countryId === "") {
                document.getElementById("stateSelect").innerHTML = '<option value="">Select State</option>';
                document.getElementById("lgaSelect").innerHTML = '<option value="">Select LGA</option>';
                return;
            }
            
            var url = "AjaxServlet?action=loadState&id=" + encodeURIComponent(countryId);
            req = initRequest();
            req.open("GET", url, true);
            req.onreadystatechange = callloadStates;
            req.send(null);
        }
        
        function callloadStates() {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    var stateSelect = document.getElementById("stateSelect");
                    if (stateSelect) {
                        var currentStateId = stateSelect.getAttribute('data-selected-state');
                        stateSelect.innerHTML = req.responseText;
                        
                        // Re-select the previously selected state if exists
                        if (currentStateId) {
                            stateSelect.value = currentStateId;
                            // Load LGAs for the selected state
                            loadLgas();
                        }
                    }
                } else {
                    console.error("Error loading States: " + req.status);
                }
            }
        }
        
        // Load LGAs based on selected state
        function loadLgas() {
            var stateSelect = document.getElementById("stateSelect");
            if (!stateSelect) {
                console.error("State select element not found");
                return;
            }
            
            var stateId = stateSelect.value;
            
            if (!stateId || stateId === "") {
                document.getElementById("lgaSelect").innerHTML = '<option value="">Select LGA</option>';
                return;
            }
            
            var url = "AjaxServlet?action=loadlga&id=" + encodeURIComponent(stateId);
            req = initRequest();
            req.open("GET", url, true);
            req.onreadystatechange = callloadLgas;
            req.send(null);
        }
        
        function callloadLgas() {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    var lgaSelect = document.getElementById("lgaSelect");
                    if (lgaSelect) {
                        var currentLgaId = lgaSelect.getAttribute('data-selected-lga');
                        lgaSelect.innerHTML = req.responseText;
                        
                        // Re-select the previously selected LGA if exists
                        if (currentLgaId) {
                            lgaSelect.value = currentLgaId;
                        }
                    }
                } else {
                    console.error("Error loading LGAs: " + req.status);
                }
            }
        }
        
        // Auto-load states on page load
        document.addEventListener('DOMContentLoaded', function() {
            var countrySelect = document.getElementById("countrySelect");
            if (countrySelect && countrySelect.value) {
                loadStates();
            }
        });
    </script>
    
</body>
</html>
