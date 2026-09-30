<%-- 
    Document   : applicantProfileUpdate
    Created on : January 2025
    Author     : BEMGBA
    Purpose    : Allow applicants to update their profile/biodata information
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Get current applicant using a simpler query to avoid complex joins
    Applicants applicant = null;
    try {
        applicant = (Applicants) sess.getSingleObject(Applicants.class, user.getId());
    } catch (Exception e) {
        System.out.println("DEBUG: Error loading applicant: " + e.getMessage());
        applicant = sess.getApplicants(user.getId());
    }
    
    if (applicant == null) {
        response.sendRedirect("/app_dashboard");
        return;
    }
    
    // Get or create applicant biodata using simpler query
    Applicantsbiodata biodata = null;
    try {
        biodata = (Applicantsbiodata) sess.getSingleObject(Applicantsbiodata.class, user.getId());
    } catch (Exception e) {
        System.out.println("DEBUG: Error loading biodata with getSingleObject: " + e.getMessage());
        biodata = sess.getApplicantsbiodataById(user.getId());
    }
    
    boolean isNewBiodata = (biodata == null);
    
    if (isNewBiodata) {
        biodata = new Applicantsbiodata();
        biodata.setId(user.getId());
        biodata.setSurname(applicant.getSurname());
        biodata.setOthernames(applicant.getOthernames());
        biodata.setGender(applicant.getGender());
        biodata.setDateAdded(new Date());
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Update Profile</title>
        <style>
            .required-field {
                border-left: 4px solid #dc3545;
            }
            .profile-section {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
            }
            .form-floating > .form-control:focus ~ label,
            .form-floating > .form-control:not(:placeholder-shown) ~ label {
                opacity: .65;
                transform: scale(.85) translateY(-0.5rem) translateX(0.15rem);
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="title">Update Profile</h2>
                        <a href="/app_dashboard" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </header>

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    
                    <%
                        // Handle form submission
                        String submitAction = request.getParameter("submitAction");
                        String message = "";
                        String messageType = "";
                        
                        if (submitAction != null && submitAction.length() > 0) {
                            try {
                                // Get form parameters (matching genappDashboard.jsp field names)
                                String surname = request.getParameter("surname");
                                String othernames = request.getParameter("othernames");
                                String phoneno = request.getParameter("phoneno");
                                String email = request.getParameter("email");
                                String dob = request.getParameter("dob");
                                String contactadd = request.getParameter("contactadd");
                                String gender = request.getParameter("gender");
                                String hometown = request.getParameter("hometown");
                                String country = request.getParameter("country");
                                String states = request.getParameter("states");
                                String lgas = request.getParameter("lgas");
                                
                                // Validate required fields
                                if (email == null || email.trim().isEmpty() || 
                                    phoneno == null || phoneno.trim().isEmpty()) {
                                    throw new Exception("Email and Phone Number are required fields");
                                }
                                
                                // Validate name format (matching genappDashboard.jsp validation)
                                if (surname != null) surname = surname.trim().replaceAll("\\s+", " ");
                                if (othernames != null) othernames = othernames.trim().replaceAll("\\s+", " ");
                                
                                boolean validSurname = surname != null && surname.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");
                                boolean validOthernames = othernames != null && othernames.matches("^[A-Za-z]+(\\s[A-Za-z]+)*$");
                                
                                if (!validSurname || !validOthernames) {
                                    throw new Exception("Your full name " + surname + ", " + othernames + " does not look like a person's name. Kindly review and resubmit");
                                }
                                
                                // CORRECTED UPDATE LOGIC: Use direct JPQL updates to avoid complex entity loading
                                
                                // 1. UPDATE USERS TABLE: email column only if no value is present
                                boolean userEmailUpdated = false;
                                if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                                    try {
                                        // Use direct JPQL update to avoid complex entity loading
                                        int updated = sess.updateUserEmailDirect(user.getId(), email.trim().toLowerCase());
                                        if (updated > 0) {
                                            userEmailUpdated = true;
                                            System.out.println("DEBUG: Updated Users.email for user: " + user.getId());
                                        }
                                    } catch (Exception e) {
                                        System.out.println("DEBUG: Error updating Users.email: " + e.getMessage());
                                        // Fallback to entity update
                                        user.setEmail(email.trim().toLowerCase());
                                        sess.updateObject(user);
                                        userEmailUpdated = true;
                                    }
                                } else {
                                    System.out.println("DEBUG: Skipped Users.email update - value exists: " + user.getEmail());
                                }
                                
                                // 2. UPDATE APPLICANTS TABLE: emailAddress & phoneNo only where values are null/empty
                                try {
                                    // Use conditional update that only updates null/empty fields
                                    int updated = sess.updateApplicantContactIfEmpty(user.getId(), email.trim().toLowerCase(), phoneno.trim());
                                    if (updated > 0) {
                                        System.out.println("DEBUG: Successfully updated Applicants table (conditional update)");
                                    } else {
                                        System.out.println("DEBUG: No Applicants table updates needed - values already exist");
                                    }
                                } catch (Exception e) {
                                    System.out.println("DEBUG: Error updating Applicants table: " + e.getMessage());
                                    throw e;
                                }
                                
                                // 3. UPDATE APPLICANTSBIODATA TABLE: all data collected EXCEPT "email"
                                // Note: Phone number is stored in biodata for profile completeness, but primary source is Applicants table
                                biodata.setSurname(surname);
                                biodata.setOthernames(othernames);
                                biodata.setPhoneno(phoneno.trim()); // Store for profile completeness
                                biodata.setDateOfBirth(dob);
                                biodata.setContactAddress(contactadd);
                                biodata.setGender(gender);
                                biodata.setHomeTown(hometown);
                                // Note: Email is NOT stored in biodata as per requirement
                                
                                // Set related entities using getSingleObject (matching genappDashboard.jsp approach)
                                if (country != null && !country.isEmpty()) {
                                    try {
                                        Integer countryId = Integer.valueOf(country);
                                        Countries nationality = (Countries) sess.getSingleObject(Countries.class, countryId);
                                        biodata.setNationality(nationality);
                                    } catch (NumberFormatException e) {
                                        // Handle invalid country ID
                                    }
                                }
                                
                                if (states != null && !states.isEmpty()) {
                                    try {
                                        Integer stateId = Integer.valueOf(states);
                                        States state = (States) sess.getSingleObject(States.class, stateId);
                                        biodata.setState(state);
                                    } catch (NumberFormatException e) {
                                        // Handle invalid state ID
                                    }
                                }
                                
                                if (lgas != null && !lgas.isEmpty()) {
                                    try {
                                        Integer lgaId = Integer.valueOf(lgas);
                                        Lgas lga = (Lgas) sess.getSingleObject(Lgas.class, lgaId);
                                        biodata.setLga(lga);
                                    } catch (NumberFormatException e) {
                                        // Handle invalid LGA ID
                                    }
                                }
                                
                                // Save biodata using appropriate method
                                if (isNewBiodata) {
                                    sess.newEntry(biodata);
                                } else {
                                    sess.updateApplicant(biodata);
                                }
                                
                                message = "Profile updated successfully!";
                                messageType = "success";
                                
                                // Refresh data
                                biodata = sess.getApplicantsbiodataById(user.getId());
                                applicant = sess.getApplicants(user.getId());
                                
                            } catch (Exception e) {
                                message = "Error updating profile: " + e.getMessage();
                                messageType = "danger";
                            }
                        }
                    %>
                    
                    <!-- Success/Error Messages -->
                    <%
                        if (message.length() > 0) {
                    %>
                    <div class="alert alert-<%=messageType%> alert-dismissible fade show" role="alert">
                        <i class="fas fa-<%=messageType.equals("success") ? "check-circle" : "exclamation-triangle"%> me-2"></i>
                        <%=message%>
                        <%
                            String firstLogin = request.getParameter("first_login");
                            if ("success".equals(messageType) && "true".equals(firstLogin)) {
                        %>
                        <div class="mt-2">
                            <a href="/gen_app_dashboard" class="btn btn-success btn-sm">
                                <i class="fas fa-arrow-right me-1"></i>Continue to Dashboard
                            </a>
                        </div>
                        <%
                            }
                        %>
                        <button type="button" class="btn-close" data-coreui-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <%
                        }
                    %>
                    
                    <!-- Profile Update Form -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-user-edit me-2"></i>Personal Information
                                    </h5>
                                    <small class="text-muted">
                                        Fields marked with <span class="text-danger">*</span> are required
                                    </small>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="">
                                        
                                        <!-- Basic Information Section -->
                                        <div class="profile-section">
                                            <h6 class="text-primary mb-3">
                                                <i class="fas fa-id-card me-2"></i>Basic Information
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="text" class="form-control" id="surname" name="surname" 
                                                               value="<%=biodata.getSurname() != null ? biodata.getSurname() : ""%>" 
                                                               placeholder="Surname" minlength="2" required>
                                                        <label for="surname">Surname <span class="text-danger">*</span></label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="text" class="form-control" id="othernames" name="othernames" 
                                                               value="<%=biodata.getOthernames() != null ? biodata.getOthernames() : ""%>" 
                                                               placeholder="Other Names" minlength="2" required>
                                                        <label for="othernames">Other Names <span class="text-danger">*</span></label>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <select class="form-select" id="gender" name="gender" required>
                                                            <option value="">Select Gender</option>
                                                            <option value="Male" <%="Male".equals(biodata.getGender()) ? "selected" : ""%>>Male</option>
                                                            <option value="Female" <%="Female".equals(biodata.getGender()) ? "selected" : ""%>>Female</option>
                                                        </select>
                                                        <label for="gender">Gender <span class="text-danger">*</span></label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="date" class="form-control" id="dob" name="dob" 
                                                               value="<%=biodata.getDateOfBirth() != null ? biodata.getDateOfBirth() : ""%>" 
                                                               min="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 90)%>" 
                                                               max="<%=settings.getDateBefore(settings.getTodaysdate(), 365 * 16)%>"
                                                               placeholder="Date of Birth">
                                                        <label for="dob">Date of Birth</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Contact Information Section -->
                                        <div class="profile-section required-field">
                                            <h6 class="text-danger mb-3">
                                                <i class="fas fa-phone me-2"></i>Contact Information (Required)
                                            </h6>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="email" class="form-control" id="email" name="email" 
                                                               value="<%=applicant.getEmailAddress() != null ? applicant.getEmailAddress() : ""%>" 
                                                               placeholder="Email Address" required>
                                                        <label for="email">Email Address <span class="text-danger">*</span></label>
                                                        <div class="form-text">
                                                            <i class="fas fa-info-circle"></i> 
                                                            This email will be used for admission updates
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="tel" class="form-control" id="phoneno" name="phoneno" 
                                                               value="<%=applicant.getPhoneNo() != null ? applicant.getPhoneNo() : (biodata.getPhoneno() != null ? biodata.getPhoneno() : "")%>" 
                                                               placeholder="Phone Number" required minlength="11" maxlength="13">
                                                        <label for="phoneno">Phone Number <span class="text-danger">*</span></label>
                                                        <div class="form-text">
                                                            <i class="fas fa-info-circle"></i> 
                                                            Format: 2347000000000
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Address Information Section -->
                                        <div class="profile-section">
                                            <h6 class="text-primary mb-3">
                                                <i class="fas fa-map-marker-alt me-2"></i>Address Information
                                            </h6>
                                            <div class="row">
                                                <div class="col-12">
                                                    <div class="form-floating mb-3">
                                                        <textarea class="form-control" id="contactadd" name="contactadd" 
                                                                  style="height: 100px" placeholder="Contact Address"><%=biodata.getContactAddress() != null ? biodata.getContactAddress() : ""%></textarea>
                                                        <label for="contactadd">Contact Address</label>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <input type="text" class="form-control" id="hometown" name="hometown" 
                                                               value="<%=biodata.getHomeTown() != null ? biodata.getHomeTown() : ""%>" 
                                                               placeholder="Home Town">
                                                        <label for="hometown">Home Town</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <select class="form-select" id="country" name="country" onchange="loadStates()">
                                                            <option value="">Select Nationality</option>
                                                            <%
                                                                List<Countries> countries = sess.getAllCountries();
                                                                for (Countries country : countries) {
                                                                    String selected = "";
                                                                    if (biodata.getNationality() != null && 
                                                                        country.getId().equals(biodata.getNationality().getId())) {
                                                                        selected = "selected";
                                                                    } else if (country.getId() == 1173) { // Default to Nigeria
                                                                        selected = "selected";
                                                                    }
                                                            %>
                                                            <option value="<%=country.getId()%>" <%=selected%>><%=country.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                        <label for="country">Nationality</label>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <select class="form-select" id="states" name="states" onchange="loadLgas()">
                                                            <option value="">Select State</option>
                                                            <%
                                                                // Get Nigeria's states (ID 1173 based on genappDashboard.jsp)
                                                                List<States> states = sess.getAllStatesInCountry(1173);
                                                                for (States state : states) {
                                                                    String selected = "";
                                                                    if (biodata.getState() != null && 
                                                                        state.getId().equals(biodata.getState().getId())) {
                                                                        selected = "selected";
                                                                    } else if (state.getId() == 10035) { // Default state from genappDashboard
                                                                        selected = "selected";
                                                                    }
                                                            %>
                                                            <option value="<%=state.getId()%>" <%=selected%>><%=state.getName()%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                        <label for="states">State of Origin</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3">
                                                        <select class="form-select" id="lgas" name="lgas">
                                                            <option value="">Select LGA</option>
                                                            <%
                                                                if (biodata.getState() != null) {
                                                                    List<Lgas> lgas = sess.getAllLgasInStte(biodata.getState().getId());
                                                                    for (Lgas lga : lgas) {
                                                                        String selected = "";
                                                                        if (biodata.getLga() != null && 
                                                                            lga.getId().equals(biodata.getLga().getId())) {
                                                                            selected = "selected";
                                                                        }
                                                            %>
                                                            <option value="<%=lga.getId()%>" <%=selected%>><%=lga.getName()%></option>
                                                            <%
                                                                    }
                                                                } else {
                                                                    // Default LGAs for default state (10035)
                                                                    List<Lgas> lgas = sess.getAllLgasInStte(10035);
                                                                    for (Lgas lga : lgas) {
                                                            %>
                                                            <option value="<%=lga.getId()%>"><%=lga.getName()%></option>
                                                            <%
                                                                    }
                                                                }
                                                            %>
                                                        </select>
                                                        <label for="lgas">Local Government Area</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Submit Button -->
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <small class="text-muted">
                                                    <i class="fas fa-shield-alt me-1"></i>
                                                    Your information is secure and will only be used for admission processing
                                                </small>
                                            </div>
                                            <div>
                                                <button type="submit" name="submitAction" value="update" class="btn btn-primary px-4">
                                                    <i class="fas fa-save me-2"></i>Update Profile
                                                </button>
                                            </div>
                                        </div>
                                    </form>
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
            var req;
            var isIE;

            function initRequest() {
                if (window.XMLHttpRequest) {
                    if (navigator.userAgent.indexOf('MSIE') != -1) {
                        isIE = true;
                    }
                    return new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    isIE = true;
                    return new ActiveXObject("Microsoft.XMLHTTP");
                }
            }

            function loadStates() {
                var sel2 = document.getElementById("country");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadState&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadStates;
                req.send(null);
            }

            function callloadStates() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("states").innerHTML = req.responseText;
                    }
                }
            }

            function loadLgas() {
                var sel2 = document.getElementById("states");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadlga&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadLgas;
                req.send(null);
            }

            function callloadLgas() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("lgas").innerHTML = req.responseText;
                    }
                }
            }
            
            // Form validation
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.querySelector('form');
                const emailInput = document.getElementById('email');
                const phoneInput = document.getElementById('phoneno');
                
                form.addEventListener('submit', function(e) {
                    let isValid = true;
                    
                    // Validate email
                    if (!emailInput.value.trim()) {
                        emailInput.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        emailInput.classList.remove('is-invalid');
                    }
                    
                    // Validate phone
                    if (!phoneInput.value.trim() || phoneInput.value.length < 11) {
                        phoneInput.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        phoneInput.classList.remove('is-invalid');
                    }
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('Please fill in all required fields correctly.');
                    }
                });
            });
        </script>
    </body>
</html>