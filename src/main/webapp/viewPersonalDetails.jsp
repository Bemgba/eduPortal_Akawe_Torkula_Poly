<%-- 
    Document   : viewPersonalDetails
    Created on : January 2025
    Author     : System Generated
    Purpose    : Display applicant biodata details in read-only format
--%>

<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    // Security checks - same pattern as other applicant pages
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Check if user has proper role setup
    if (user.getDefaultRole() == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Check if role has proper default home page
    if (user.getDefaultRole().getDefaulthome() == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Get applicant biodata - use same method as header_applicant_gen.jspf
    Applicantsbiodata biodata = sess.getApplicantsbiodataById(user.getId());
    System.out.println("DEBUG: viewPersonalDetails - Loading biodata for user " + user.getId() + ": " + (biodata != null ? "Found" : "Not found"));
    
    // If no biodata exists, redirect to dashboard to create it
    if (biodata == null) {
        System.out.println("DEBUG: viewPersonalDetails - No biodata found, redirecting to dashboard");
        response.sendRedirect("/gen_app_dashboard?error=no_biodata");
        return;
    }
    
    // Debug output for biodata fields
    System.out.println("DEBUG: viewPersonalDetails - Biodata details:");
    System.out.println("  - Surname: " + (biodata.getSurname() != null ? biodata.getSurname() : "NULL"));
    System.out.println("  - Other names: " + (biodata.getOthernames() != null ? biodata.getOthernames() : "NULL"));
    System.out.println("  - Gender: " + (biodata.getGender() != null ? biodata.getGender() : "NULL"));
    System.out.println("  - Phone: " + (biodata.getPhoneno() != null ? biodata.getPhoneno() : "NULL"));
    
    // Format date for display
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
    String formattedDOB = "";
    if (biodata.getDateOfBirth() != null && !biodata.getDateOfBirth().trim().isEmpty()) {
        try {
            // Assuming date is stored as string in YYYY-MM-DD format
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dob = inputFormat.parse(biodata.getDateOfBirth());
            formattedDOB = dateFormat.format(dob);
        } catch (Exception e) {
            formattedDOB = biodata.getDateOfBirth(); // Use as-is if parsing fails
        }
    }
%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Personal Details</title>
        
        <style>
            .personal-details-container {
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 2rem;
            }
            
            .details-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                text-align: center;
                position: relative;
            }
            
            .details-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                pointer-events: none;
            }
            
            .details-header h2 {
                margin: 0 0 0.5rem 0;
                font-size: 2rem;
                font-weight: 600;
                position: relative;
                z-index: 1;
            }
            
            .details-header p {
                margin: 0;
                opacity: 0.9;
                font-size: 1.1rem;
                position: relative;
                z-index: 1;
            }
            
            .passport-section {
                text-align: center;
                padding: 2rem;
                background: #f8f9fa;
                border-bottom: 1px solid #e9ecef;
            }
            
            .passport-photo {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid #fff;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                margin-bottom: 1rem;
            }
            
            .passport-placeholder {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem;
                border: 5px solid #fff;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            
            .details-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 2rem;
                padding: 2rem;
            }
            
            .detail-card {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 1.5rem;
                border-left: 4px solid #667eea;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            
            .detail-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            }
            
            .detail-label {
                font-size: 0.9rem;
                font-weight: 600;
                color: #6c757d;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.5rem;
            }
            
            .detail-value {
                font-size: 1.1rem;
                color: #495057;
                font-weight: 500;
                word-wrap: break-word;
            }
            
            .detail-value.empty {
                color: #adb5bd;
                font-style: italic;
            }
            
            .section-divider {
                height: 1px;
                background: linear-gradient(to right, transparent, #dee2e6, transparent);
                margin: 2rem 0;
            }
            
            .action-buttons {
                text-align: center;
                padding: 2rem;
                background: #f8f9fa;
                border-top: 1px solid #e9ecef;
            }
            
            .btn-update {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 12px 30px;
                border-radius: 6px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }
            
            .btn-update:hover {
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }
            
            .btn-back {
                background: #6c757d;
                color: white;
                border: none;
                padding: 12px 30px;
                border-radius: 6px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                margin-right: 1rem;
                transition: background-color 0.2s ease;
            }
            
            .btn-back:hover {
                background: #5a6268;
                color: white;
            }
            
            @media (max-width: 768px) {
                .details-grid {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                    padding: 1rem;
                }
                
                .details-header {
                    padding: 1.5rem;
                }
                
                .details-header h2 {
                    font-size: 1.5rem;
                }
                
                .passport-photo,
                .passport-placeholder {
                    width: 120px;
                    height: 120px;
                }
            }
        </style>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/applicant_navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <h2 class="title">Personal Details</h2>
                        <a href="/gen_app_dashboard" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </header>

            <div class="body flex-grow-1">
                <div class="container-lg px-4 py-4">
                    
                    <div class="personal-details-container">
                        <!-- Header Section -->
                        <div class="details-header">
                            <h2><i class="fas fa-user-circle me-2"></i>Personal Information</h2>
                            <p>Complete overview of your registered details</p>
                        </div>
                        
                        <!-- Passport Photo Section -->
                        <div class="passport-section">
                            <%
                                String passportImageSrc = null;
                                try {
                                    Passports passport = sess.getPassports(biodata.getId());
                                    if (passport != null && passport.getUrl() != null) {
                                        File imageFile = new File(settings.documentroot + "/" + passport.getUrl());
                                        if (imageFile.exists()) {
                                            byte[] imageBytes = Files.readAllBytes(imageFile.toPath());
                                            passportImageSrc = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);
                                        }
                                    }
                                } catch (Exception e) {
                                    System.out.println("DEBUG: Error loading passport photo: " + e.getMessage());
                                }
                            %>
                            
                            <% if (passportImageSrc != null) { %>
                                <img src="<%=passportImageSrc%>" alt="Passport Photo" class="passport-photo">
                            <% } else { %>
                                <div class="passport-placeholder">
                                    <i class="fas fa-user fa-3x text-muted"></i>
                                </div>
                            <% } %>
                            
                            <h4 class="mb-0"><%=biodata.getSurname()%> <%=biodata.getOthernames()%></h4>
                            <p class="text-muted">Applicant ID: <%=biodata.getId()%></p>
                        </div>
                        
                        <!-- Personal Details Grid -->
                        <div class="details-grid">
                            <!-- Basic Information -->
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-signature me-1"></i>Surname
                                </div>
                                <div class="detail-value">
                                    <%=biodata.getSurname() != null ? biodata.getSurname() : ""%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-user me-1"></i>Other Names
                                </div>
                                <div class="detail-value">
                                    <%=biodata.getOthernames() != null ? biodata.getOthernames() : ""%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-venus-mars me-1"></i>Gender
                                </div>
                                <div class="detail-value">
                                    <%=biodata.getGender() != null ? biodata.getGender() : ""%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-birthday-cake me-1"></i>Date of Birth
                                </div>
                                <div class="detail-value">
                                    <%=formattedDOB.length() > 0 ? formattedDOB : "Not specified"%>
                                </div>
                            </div>
                            
                            <!-- Contact Information -->
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-phone me-1"></i>Phone Number
                                </div>
                                <div class="detail-value">
                                    <%=biodata.getPhoneno() != null && !biodata.getPhoneno().trim().isEmpty() ? biodata.getPhoneno() : "Not provided"%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-home me-1"></i>Home Town
                                </div>
                                <div class="detail-value">
                                    <%=biodata.getHomeTown() != null && !biodata.getHomeTown().trim().isEmpty() ? biodata.getHomeTown() : "Not specified"%>
                                </div>
                            </div>
                            
                            <!-- Location Information -->
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-flag me-1"></i>Country
                                </div>
                                <div class="detail-value">
                                    <%
                                        String countryName = "Not specified";
                                        try {
                                            if (biodata.getNationality() != null) {
                                                countryName = biodata.getNationality().getName();
                                            }
                                        } catch (Exception e) {
                                            // Use default value
                                        }
                                    %>
                                    <%=countryName%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-map-marker-alt me-1"></i>State of Origin
                                </div>
                                <div class="detail-value">
                                    <%
                                        String stateName = "Not specified";
                                        try {
                                            if (biodata.getState() != null) {
                                                stateName = biodata.getState().getName();
                                            }
                                        } catch (Exception e) {
                                            // Use default value
                                        }
                                    %>
                                    <%=stateName%>
                                </div>
                            </div>
                            
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-location-arrow me-1"></i>Local Government Area
                                </div>
                                <div class="detail-value">
                                    <%
                                        String lgaName = "Not specified";
                                        try {
                                            if (biodata.getLga() != null) {
                                                lgaName = biodata.getLga().getName();
                                            }
                                        } catch (Exception e) {
                                            // Use default value
                                        }
                                    %>
                                    <%=lgaName%>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Contact Address Section -->
                        <div class="section-divider"></div>
                        
                        <div style="padding: 0 2rem;">
                            <div class="detail-card">
                                <div class="detail-label">
                                    <i class="fas fa-address-card me-1"></i>Contact Address
                                </div>
                                <div class="detail-value">
                                    <%
                                        String contactAddress = biodata.getContactAddress();
                                        if (contactAddress != null && !contactAddress.trim().isEmpty()) {
                                            // Replace line breaks with <br> for proper display
                                            contactAddress = contactAddress.replace("\n", "<br>").replace("\r\n", "<br>");
                                        } else {
                                            contactAddress = "Not provided";
                                        }
                                    %>
                                    <%=contactAddress%>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="/gen_app_dashboard" class="btn-back">
                                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                            </a>
                            <a href="/profile_update" class="btn-update">
                                <i class="fas fa-edit me-2"></i>Update Information
                            </a>
                        </div>
                    </div>
                    
                </div>
            </div>

            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>

        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
    </body>
</html>