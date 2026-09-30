<%-- 
    Document   : adminAddStaff
    Created on : March 2, 2026
    Purpose    : Admin page for adding staff members (single or bulk)
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
%>
<html lang="en">
<head>
    <%@include file="WEB-INF/jspf/headmeta.jspf"%>
    <title><%=settings.productName%> - Add Staff</title>
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
        .tab-content {
            padding: 20px;
        }
        .nav-tabs .nav-link.active {
            background-color: #0c4f24;
            color: white;
        }
    </style>
</head>
<body>
    <%@include file="WEB-INF/jspf/navigations.jspf"%>

    <div class="wrapper d-flex flex-column min-vh-100">
        <header class="header header-sticky p-0">
            <%@include file="WEB-INF/jspf/header_staff.jspf"%>
            <div class="container-fluid px-4">
                <h2 class="title">Add New Staff</h2>
            </div>
        </header>
        
        <div class="body flex-grow-1">
            <div class="container-lg px-4">
                
                <%
                    // Backend Processing for Single Staff Addition
                    String submitSingle = request.getParameter("submitSingle");
                    String msg = "";
                    String msgType = "danger";
                    
                    if (submitSingle != null) {
                        try {
                            // Get required fields
                            String staffNo = request.getParameter("staffNo");
                            String surname = request.getParameter("surname");
                            String othernames = request.getParameter("othernames");
                            String personalEmail = request.getParameter("personalEmail");
                            String phoneNo = request.getParameter("phoneNo");
                            
                            // Validate required fields
                            if (staffNo == null || staffNo.trim().isEmpty() ||
                                surname == null || surname.trim().isEmpty() ||
                                othernames == null || othernames.trim().isEmpty() ||
                                personalEmail == null || personalEmail.trim().isEmpty() ||
                                phoneNo == null || phoneNo.trim().isEmpty()) {
                                
                                msg = "All required fields must be filled!";
                                msgType = "danger";
                            } else {
                                // Clean and format data
                                staffNo = staffNo.trim().toUpperCase();
                                surname = surname.trim();
                                othernames = othernames.trim();
                                personalEmail = personalEmail.trim().toLowerCase();
                                phoneNo = phoneNo.trim();
                                
                                // Check if staff number already exists
                                Staff existingStaff = sess.getStaffByStaffNo(staffNo);
                                if (existingStaff != null) {
                                    msg = "Staff Number " + staffNo + " already exists!";
                                    msgType = "danger";
                                } else {
                                    // Check if email already exists
                                    Users existingUser = sess.getUsersByEmail(personalEmail);
                                    if (existingUser != null) {
                                        msg = "Email address " + personalEmail + " is already registered!";
                                        msgType = "danger";
                                    } else {
                                        // Generate unique ID
                                        String userId = settings.generateId(settings.getTodaysdate().split("-")[0], 10);
                                        
                                        // Step 1: Create Users record first
                                        Users newUser = new Users(userId);
                                        newUser.setUsername(staffNo.toLowerCase()); // staffNo as username
                                        newUser.setPassword(staffNo); // staffNo as initial password
                                        newUser.setEmail(personalEmail);
                                        newUser.setDefaultRole(sess.getRoles(1057)); // Staff role
                                        newUser.setStatus("ACTIVE");
                                        
                                        // Set audit fields
                                        Date now = new Date();
                                        newUser.setCreatedAt(now);
                                        newUser.setUpdatedAt(now);
                                        newUser.setCreatedBy(user.getUsername());
                                        newUser.setFailedLoginAttempts(0);
                                        newUser.setDeleted(false);
                                        
                                        // Step 2: Create Staff record with same ID
                                        Staff newStaff = new Staff(userId);
                                        newStaff.setStaffNo(staffNo);
                                        newStaff.setSurname(surname);
                                        newStaff.setOthernames(othernames);
                                        newStaff.setPersonalEmailAddress(personalEmail);
                                        newStaff.setPhoneNo(phoneNo);
                                        
                                        // Get optional fields
                                        String title = request.getParameter("title");
                                        String gender = request.getParameter("gender");
                                        String dateOfBirth = request.getParameter("dateOfBirth");
                                        String maritalStatus = request.getParameter("maritalStatus");
                                        String maidenName = request.getParameter("maidenName");
                                        String officialEmail = request.getParameter("officialEmail");
                                        String currentQualification = request.getParameter("currentQualification");
                                        String areaOfStudy = request.getParameter("areaOfStudy");
                                        String serviceStatus = request.getParameter("serviceStatus");
                                        
                                        // Set optional fields if provided
                                        if (title != null && !title.trim().isEmpty()) newStaff.setTitle(title.trim());
                                        if (gender != null && !gender.trim().isEmpty()) newStaff.setGender(gender);
                                        if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) newStaff.setDateOfBirth(dateOfBirth);
                                        if (maritalStatus != null && !maritalStatus.trim().isEmpty()) newStaff.setMaritalStatus(maritalStatus);
                                        if (maidenName != null && !maidenName.trim().isEmpty()) newStaff.setMaidenName(maidenName.trim());
                                        if (officialEmail != null && !officialEmail.trim().isEmpty()) newStaff.setOfficialEmailAddress(officialEmail.trim().toLowerCase());
                                        if (currentQualification != null && !currentQualification.trim().isEmpty()) newStaff.setCurrentQualification(currentQualification.trim());
                                        if (areaOfStudy != null && !areaOfStudy.trim().isEmpty()) newStaff.setAreaOfStudy(areaOfStudy.trim());
                                        if (serviceStatus != null && !serviceStatus.trim().isEmpty()) newStaff.setServiceStatus(serviceStatus);
                                        
                                        newStaff.setDateAdded(now);
                                        
                                        // Handle foreign key relationships
                                        String nationalityId = request.getParameter("nationalityId");
                                        String departmentId = request.getParameter("departmentId");
                                        String facultyId = request.getParameter("facultyId");
                                        String stateId = request.getParameter("stateId");
                                        String lgaId = request.getParameter("lgaId");
                                        String positionId = request.getParameter("positionId");
                                        String unitId = request.getParameter("unitId");
                                        
                                        if (nationalityId != null && !nationalityId.isEmpty() && nationalityId.matches("\\d+")) {
                                            Countries country = (Countries) sess.getSingleObject(Countries.class, Integer.parseInt(nationalityId));
                                            if (country != null) newStaff.setNationalityId(country);
                                        }
                                        
                                        if (departmentId != null && !departmentId.isEmpty()) {
                                            Departments dept = (Departments) sess.getSingleObject(Departments.class, departmentId);
                                            if (dept != null) newStaff.setDepartmentId(dept);
                                        }
                                        
                                        if (facultyId != null && !facultyId.isEmpty()) {
                                            FacultiesDirectorates faculty = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, facultyId);
                                            if (faculty != null) newStaff.setFacultyDirectorateId(faculty);
                                        }
                                        
                                        if (stateId != null && !stateId.isEmpty() && stateId.matches("\\d+")) {
                                            States state = (States) sess.getSingleObject(States.class, Integer.parseInt(stateId));
                                            if (state != null) newStaff.setStateOfOriginId(state);
                                        }
                                        
                                        if (lgaId != null && !lgaId.isEmpty() && lgaId.matches("\\d+")) {
                                            Lgas lga = (Lgas) sess.getSingleObject(Lgas.class, Integer.parseInt(lgaId));
                                            if (lga != null) newStaff.setLgaId(lga);
                                        }
                                        
                                        if (positionId != null && !positionId.isEmpty() && positionId.matches("\\d+")) {
                                            Positions position = (Positions) sess.getSingleObject(Positions.class, Integer.parseInt(positionId));
                                            if (position != null) newStaff.setPositionId(position);
                                        }
                                        
                                        if (unitId != null && !unitId.isEmpty() && unitId.matches("\\d+")) {
                                            Units unit = (Units) sess.getSingleObject(Units.class, Integer.parseInt(unitId));
                                            if (unit != null) newStaff.setUnitId(unit);
                                        }
                                        
                                        // Save Users record first
                                        try {
                                            sess.newEntry(newUser);
                                            
                                            // Then save Staff record
                                            sess.newEntry(newStaff);
                                            
                                            msg = "Staff member " + staffNo + " (" + surname + " " + othernames + ") created successfully! Username: " + staffNo.toLowerCase() + ", Default password: " + staffNo;
                                            msgType = "success";
                                        } catch (Exception saveEx) {
                                            msg = "Error creating staff: " + saveEx.getMessage();
                                            msgType = "danger";
                                            saveEx.printStackTrace();
                                        }
                                    }
                                }
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
                    <strong><%= msgType.equals("success") ? "✓" : "✗" %></strong> <%=msg%>
                    <button type="button" class="btn-close" data-coreui-dismiss="alert"></button>
                </div>
                <% } %>
                
                <!-- Tab Navigation -->
                <div class="card">
                    <div class="card-header">
                        <ul class="nav nav-tabs card-header-tabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-coreui-toggle="tab" href="#singleStaff" role="tab">
                                    <i class="fas fa-user-plus me-2"></i>Add Single Staff
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-coreui-toggle="tab" href="#bulkUpload" role="tab">
                                    <i class="fas fa-users me-2"></i>Bulk Upload
                                </a>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="card-body">
                        <div class="tab-content">
                            
                            <!-- Single Staff Addition Tab -->
                            <div class="tab-pane fade show active" id="singleStaff" role="tabpanel">
                                <form action="" method="POST">
                                    
                                    <!-- Basic Information Section -->
                                    <div class="form-section">
                                        <h5 class="form-section-title">Basic Information</h5>
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label required-field">Staff Number</label>
                                                <input type="text" class="form-control" name="staffNo" required 
                                                       placeholder="e.g., ATPM/REG/PER-001" pattern="[A-Za-z0-9/\-]+" 
                                                       title="Alphanumeric characters, slashes, and hyphens allowed">
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Title</label>
                                                <select class="form-select" name="title">
                                                    <option value="">Select Title</option>
                                                    <option value="Mr">Mr</option>
                                                    <option value="Mrs">Mrs</option>
                                                    <option value="Miss">Miss</option>
                                                    <option value="Dr">Dr</option>
                                                    <option value="Prof">Prof</option>
                                                    <option value="Engr">Engr</option>
                                                    <option value="Arc">Arc</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Gender</label>
                                                <select class="form-select" name="gender">
                                                    <option value="">Select Gender</option>
                                                    <option value="Male">Male</option>
                                                    <option value="Female">Female</option>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label required-field">Surname</label>
                                                <input type="text" class="form-control" name="surname" required 
                                                       placeholder="Enter surname">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label required-field">Other Names</label>
                                                <input type="text" class="form-control" name="othernames" required 
                                                       placeholder="Enter other names">
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Date of Birth</label>
                                                <input type="date" class="form-control" name="dateOfBirth">
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Marital Status</label>
                                                <select class="form-select" name="maritalStatus">
                                                    <option value="">Select Status</option>
                                                    <option value="Single">Single</option>
                                                    <option value="Married">Married</option>
                                                    <option value="Divorced">Divorced</option>
                                                    <option value="Widowed">Widowed</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Maiden Name</label>
                                                <input type="text" class="form-control" name="maidenName" 
                                                       placeholder="If applicable">
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
                                                       placeholder="personal@example.com">
                                                <small class="text-muted">This will be used for login</small>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Official Email</label>
                                                <input type="email" class="form-control" name="officialEmail" 
                                                       placeholder="staff@institution.edu">
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label required-field">Phone Number</label>
                                                <input type="tel" class="form-control" name="phoneNo" required 
                                                       placeholder="08012345678" pattern="[0-9]{11}" 
                                                       title="11-digit phone number">
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
                                                    <option value="SSCE">SSCE</option>
                                                    <option value="OND">OND</option>
                                                    <option value="NCE">NCE</option>
                                                    <option value="HND">HND</option>
                                                    <option value="B.Sc">B.Sc</option>
                                                    <option value="B.A">B.A</option>
                                                    <option value="B.Ed">B.Ed</option>
                                                    <option value="M.Sc">M.Sc</option>
                                                    <option value="M.A">M.A</option>
                                                    <option value="M.Ed">M.Ed</option>
                                                    <option value="Ph.D">Ph.D</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Area of Study</label>
                                                <input type="text" class="form-control" name="areaOfStudy" 
                                                       placeholder="e.g., Computer Science">
                                            </div>
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Service Status</label>
                                                <select class="form-select" name="serviceStatus">
                                                    <option value="">Select Status</option>
                                                    <option value="Active">Active</option>
                                                    <option value="On Leave">On Leave</option>
                                                    <option value="Suspended">Suspended</option>
                                                    <option value="Retired">Retired</option>
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
                                                <select class="form-select" name="facultyId" id="facultySelect">
                                                    <option value="">Select Faculty/Directorate</option>
                                                    <%
                                                        try {
                                                            List<FacultiesDirectorates> faculties = sess.getAllFacultiesDirectorates();
                                                            for (FacultiesDirectorates fac : faculties) {
                                                    %>
                                                    <option value="<%=fac.getId()%>"><%=fac.getName()%></option>
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
                                                    %>
                                                    <option value="<%=dept.getId()%>"><%=dept.getName()%></option>
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
                                                    %>
                                                    <option value="<%=pos.getId()%>"><%=pos.getName()%></option>
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
                                                    %>
                                                    <option value="<%=unit.getId()%>"><%=unit.getName()%></option>
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
                                                    %>
                                                    <option value="<%=country.getId()%>"><%=country.getName()%></option>
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
                                                            for (Countries country : countries2) {
                                                                // Auto-select Nigeria (ID 160)
                                                                boolean isNigeria = country.getId() == 160;
                                                    %>
                                                    <option value="<%=country.getId()%>" <%=isNigeria ? "selected" : ""%>><%=country.getName()%></option>
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
                                                <select class="form-select" name="stateId" id="stateSelect" onchange="loadLgas();">
                                                    <option value="">Select State</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">LGA</label>
                                                <select class="form-select" name="lgaId" id="lgaSelect">
                                                    <option value="">Select LGA</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Submit Button -->
                                    <div class="text-end">
                                        <button type="reset" class="btn btn-secondary">
                                            <i class="fas fa-undo me-2"></i>Reset Form
                                        </button>
                                        <button type="submit" name="submitSingle" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>Create Staff Member
                                        </button>
                                    </div>
                                    
                                    <div class="alert alert-info mt-3">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Note:</strong> The staff number will be used as both the username and initial password. 
                                        Staff members should change their password after first login.
                                    </div>
                                </form>
                            </div>
                            
                            <!-- Bulk Upload Tab -->
                            <div class="tab-pane fade" id="bulkUpload" role="tabpanel">
                                <div class="alert alert-info">
                                    <h5><i class="fas fa-info-circle me-2"></i>Bulk Upload Instructions</h5>
                                    <ol>
                                        <li>Download the Excel template below</li>
                                        <li>Fill in the staff details following the format</li>
                                        <li>Save the file and upload it using the form below</li>
                                        <li>Required fields: Staff Number, Surname, Other Names, Personal Email, Phone Number</li>
                                    </ol>
                                </div>
                                
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <i class="fas fa-download fa-3x text-success mb-3"></i>
                                                <h5>Download Template</h5>
                                                <p class="text-muted">Get the Excel template for bulk staff upload</p>
                                                <a href="DownloadStaffTemplate" class="btn btn-success">
                                                    <i class="fas fa-file-excel me-2"></i>Download Template
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-body text-center">
                                                <i class="fas fa-question-circle fa-3x text-primary mb-3"></i>
                                                <h5>Need Help?</h5>
                                                <p class="text-muted">View the user guide for bulk upload</p>
                                                <a href="#" class="btn btn-primary">
                                                    <i class="fas fa-book me-2"></i>View Guide
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <form action="UploadStaff?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>" method="POST" enctype="multipart/form-data">
                                    <div class="form-section">
                                        <h5 class="form-section-title">Upload Staff Data</h5>
                                        <div class="mb-3">
                                            <label class="form-label required-field">Select Excel File</label>
                                            <input type="file" class="form-control" name="bulkFile" 
                                                   accept=".xlsx,.xls" required>
                                            <small class="text-muted">Accepted formats: .xlsx, .xls (Max size: 5MB)</small>
                                        </div>
                                        
                                        <div class="text-end">
                                            <button type="submit" name="submitBulk" class="btn btn-primary">
                                                <i class="fas fa-upload me-2"></i>Upload and Process
                                            </button>
                                        </div>
                                    </div>
                                </form>
                                
                                <div class="alert alert-warning mt-3">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Important:</strong> 
                                    <ul class="mb-0 mt-2">
                                        <li>Duplicate staff numbers will be skipped</li>
                                        <li>Duplicate email addresses will be skipped</li>
                                        <li>Invalid data will be reported in the results</li>
                                        <li>All staff will have their staff number as initial password</li>
                                    </ul>
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
                        stateSelect.innerHTML = req.responseText;
                    }
                    // Clear LGA when states change
                    document.getElementById("lgaSelect").innerHTML = '<option value="">Select LGA</option>';
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
                        lgaSelect.innerHTML = req.responseText;
                    }
                } else {
                    console.error("Error loading LGAs: " + req.status);
                }
            }
        }
        
        // Auto-load states on page load (Nigeria is pre-selected)
        document.addEventListener('DOMContentLoaded', function() {
            loadStates();
        });
    </script>
    
</body>
</html>
