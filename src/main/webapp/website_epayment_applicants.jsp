<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>

<!DOCTYPE html>
<html lang="en">
    
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - EPayment</title>
    </head>
    
    <body>
        <div class="wrapper d-flex flex-column min-vh-100">
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card-group d-block d-md-flex row">
                                <div class="card col-md-7 p-4 mb-0">
                                    <div class="card-body">
                                        
                                        <h1>Applicants's e-Payment Page</h1>
                                        
                                        <%
                                            // Security: Input validation and sanitization
                                            String encryptedId = request.getParameter("id");
                                            String appid = request.getParameter("appid");
                                            String button = request.getParameter("button");
                                            
                                            // Security: Validate and sanitize inputs
                                            if (appid != null) {
                                                appid = appid.replaceAll("[^a-zA-Z0-9/\\-_]", "").trim().toLowerCase();
                                                if (appid.length() > 50) {
                                                    appid = appid.substring(0, 50);
                                                }
                                            }
                                            
                                            if (button != null && !button.matches("^[a-zA-Z\\-_ ]{1,30}$")) {
                                                button = null; // Invalid button value
                                            }
                                            
                                            // If encrypted ID is provided, decrypt it and auto-confirm
                                            if (encryptedId != null && encryptedId.trim().length() > 0) {
                                                try {
                                                    String decryptedId = settings.decryptText(encryptedId);
                                                    Applicants stdx = sess.getApplicants(decryptedId);
                                                    if (stdx != null) {
                                                        session.setAttribute("APPX", stdx);
                                                        // Set button to simulate form submission
                                                        button = "auto-confirm";
                                                        appid = decryptedId;
                                                    }
                                                } catch (Exception e) {
                                                    // If decryption fails, fall back to manual entry
                                                }
                                            }
                                            
                                            if (button != null && appid != null && appid.trim().length() > 0) {
                                                // password = settings.getMD5(password);
                                                appid = appid.toLowerCase();
                                                appid = appid.trim();
                                                Applicants stdx = sess.getApplicants(appid);
                                                if (stdx != null) {
                                                    try {

                                                        session.setAttribute("APPX", stdx);
                                                    } catch (Exception d) {
                                                    }
                                                } else {
                                        %>
                                        <div class="alert alert-danger">Error: Invalid applicant ID format. Please check and re-enter your Applicant ID</div>
                                        <%
                                                }
                                            }

                                        %>

                                        <form action="" method="POST" role="form">
                                            <p class="text-body-secondary">Verify your details</p>
                                            <div class="input-group mb-3"><span class="input-group-text">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                                                    </svg></span>
                                                <input class="form-control" type="text" required="" name="appid" placeholder="Applicant ID" 
                                                       value="<%=(appid != null) ? appid.replaceAll("[<>\"'&]", "") : ""%>" 
                                                       pattern="[a-zA-Z0-9/\\-_]{5,50}" 
                                                       maxlength="50">
                                            </div>

                                            <div class="row">
                                                <div class="col-12">
                                                    <input type="submit" name="button" class="btn btn-primary px-4" value="Confirm Details"/>
                                                </div>
                                                <div class="col-12 text-start">
                                                    <a href='/epayment' class="btn btn-link px-0">Not an applicant? Go back</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Confirm your details</h2>
                                            <p>Applicant's ID could be any of UTME registration number of Application number as the case may be. This payment page is for all prospective students such as UTME, Direct Entry, Post Graduate, Part-time, Sandwich, Remedial, etc. You can use it to verify your identity before proceeding to make payment. </p>
                                            <p>If you have not initiated an application and obtained an application number, kindly do so from the relevant page before visiting this page.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%                                            
                                Applicants appx = (Applicants) session.getAttribute("APPX");
                                if (appx != null) {
                                    // DEBUG: Log applicant details
                                    System.out.println("=== APPLICANT DETAILS ===");
                                    System.out.println("Applicant ID: " + appx.getId());
                                    System.out.println("Applicant Session: " + appx.getSession());
                                    System.out.println("School ID: " + appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId());
                                    System.out.println("School Name: " + appx.getCourse1().getSchoolProgrammeId().getSchoolId().getName());
                                    
                                    // Get the SessionManager that matches the applicant's session
                                    Sessionmanager sm = null;
                                    
                                    if (appx.getSession() != null && !appx.getSession().trim().isEmpty()) {
                                        // Use applicant's session to find the matching SessionManager
                                        sm = sess.getSessionManagerBySchoolSessionAndOperation(
                                            appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), 
                                            appx.getSession(),
                                            "APPLICATION"
                                        );
                                    }
                                    
                                    // Validate that the session exists and is OPEN
                                    boolean sessionClosed = false;
                                    String closedMessage = "";
                                    
                                    if (sm != null) {
                                        // Check if the session is OPEN
                                        if (!sm.getStatus().equalsIgnoreCase("OPEN")) {
                                            sessionClosed = true;
                                            closedMessage = "Your application session (" + appx.getSession() + ") is currently CLOSED. Please contact the admissions office for assistance.";
                                        }
                                    }
                                    
                                    if (sm != null && !sessionClosed) {
                            %>

                            <div class="card" style="margin-top:20px" id="applicant-details-card">
                                <div class="card-header d-flex align-items-center">Payment for <strong><%=(appx.getSurname() + " " + appx.getOthernames()).replaceAll("[<>\"'&]", "")%></strong>
                                </div>
                                <div class="card-body">
                                    
                                    <%
                                        String feesgroup = request.getParameter("feesgroup");
                                        String generate = request.getParameter("generate");
                                        List<Feessetup> feessetup = new ArrayList();
                                        if (generate != null && generate.length() > 0) {
                                            try {
                                                PaymentreferenceDetail prd = sess.createApplicantsPayments(appx.getId(), feesgroup, sm.getName(), "Session");
                                                if (prd.getPayref().length() > 0) {
                                                    String email = appx.getEmailAddress();
                                                    double total = feessetup.stream()
                                                            .mapToDouble(Feessetup::getAmount)
                                                            .sum();
                                                    session.setAttribute("FEESSETUP", feessetup);
                                                    session.setAttribute("level", "None");
                                                    session.setAttribute("sessions", sm.getName());
                                                    session.setAttribute("feesgroup", feesgroup);
                                                    session.setAttribute("sesssem", "Session");
                                                    session.setAttribute("regno", appx.getId());
                                                    session.setAttribute("fullname", appx.getSurname() + " " + appx.getOthernames());
                                                    session.setAttribute("coursename", appx.getCourse1().getName());
                                                    session.setAttribute("phoneno", appx.getPhoneNo());
                                                    session.setAttribute("email", email);
                                                    session.setAttribute("id", appx.getId());
                                                    try {
                                                    Paymentreference prx = sess.getPaymentreference(prd.getPayref());
                                                        session.setAttribute("pr", prx);
                                                    } catch (Exception k) {
                                                    }
                                                    String returnurl = "/epayment";
                                                    returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                    response.sendRedirect("/invoice?return=" + returnurl);
                                                } else {
                                    %>
                                    <div class="alert alert-warning"><%=prd.getRefdescription()%></div>
                                    <%
                                                }
                                            } catch (Exception k) {
                                            }
                                        }
                                    %>
                                    <form action="" method="post" name="epayment">
                                        <div class="table-responsive-sm">
                                            <table class="table table-striped">

                                                <tbody>
                                                    <tr>
                                                        <td class="left"><strong>Full Name</strong></td>
                                                        <td class="left"><%=appx.getSurname() + " " + appx.getOthernames()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Applicant ID</strong></td>
                                                        <td class="left"><%=appx.getId()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>School</strong></td>
                                                        <td class="left"><%=appx.getCourse1().getSchoolProgrammeId().getSchoolId().getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Course</strong></td>
                                                        <td class="left"><%=appx.getCourse1().getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Application Session</strong></td>
                                                        <td class="left"><%=appx.getSession() != null ? appx.getSession() : "Not Set"%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Current Session</strong></td>
                                                        <td class="left"><%=sm.getName()%></td>
                                                    </tr>

                                                    <%
                                                        if (sm.getStatus().equalsIgnoreCase("OPEN")) {
                                                    %>
                                                    <%
                                                    List<Feesgroup> feesgprivate = sess.getFeesgroupBySchoolAndCategory(appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), "Applicants","PRIVATE");
                                                    if(!feesgprivate.isEmpty()){
                                                    %>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div class="alert alert-warning">
                                                                <strong>Private Payments Available:</strong> 
                                                                <% 
                                                                for(Feesgroup data : feesgprivate){
                                                                %>
                                                                <%=data.getName()%>, 
                                                                <%
                                                                }
                                                                %>
                                                                <br/><br/>
                                                                <strong>To pay for these items, please login to your applicant account:</strong>
                                                                <a href="/" class="btn btn-primary btn-sm">Login Here</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                    

                                                    <tr>
                                                        <td class="left"><strong>Select Payment</strong></td>
                                                        <td class="left">
                                                            <select class="form-select" name="feesgroup" id='feesgroup'>
                                                                <option value="">Select One</option>
                                                                <%
                                                                    try {
                                                                        List<Feesgroup> feesg = sess.getFeesgroupBySchoolAndCategory(appx.getCourse1().getSchoolProgrammeId().getSchoolId().getId(), "Applicants","PUBLIC");
                                                                        for (Feesgroup fg : feesg) {
                                                                %>
                                                                <option value="<%=fg.getId()%>"><%=fg.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </tr>


                                                    <tr>
                                                        <td class="left"><strong></td>
                                                        <td class="left">
                                                            <input type="submit" class="btn btn-lg btn-success" name="generate" value="Generate invoice"/>
                                                        </td>
                                                    </tr>
                                                    <%
                                                    } else {
                                                    %>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div class="alert alert-warning">Sorry, session <%=sm.getName()%> is marked closed hence no payment can be made on it. Kindly check back later to see if a new session is opened</div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>


                                                </tbody>
                                            </table>
                                        </div>
                                    </form> 
                                </div>

                            </div>
                            <%
                            } else if (sessionClosed) {
                            %>
                            <div class="card" style="margin-top:20px">
                                <div class="card-header bg-warning text-dark">
                                    <strong>Session Closed</strong>
                                </div>
                                <div class="card-body">
                                    <div class="alert alert-warning">
                                        <h5><i class="fas fa-exclamation-triangle"></i> Session Currently Closed</h5>
                                        <p><%=closedMessage%></p>
                                        <hr/>
                                        <table class="table table-sm">
                                            <tr>
                                                <td><strong>Your Application Session:</strong></td>
                                                <td><%=appx.getSession()%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Session Status:</strong></td>
                                                <td><span class="badge bg-danger">CLOSED</span></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Your School:</strong></td>
                                                <td><%=appx.getCourse1().getSchoolProgrammeId().getSchoolId().getName()%></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Your Course:</strong></td>
                                                <td><%=appx.getCourse1().getName()%></td>
                                            </tr>
                                        </table>
                                        <p class="mb-0"><strong>Note:</strong> This session is currently closed for payments. Please contact the admissions office if you need to make a payment.</p>
                                    </div>
                                </div>
                            </div>
                            <%
                            } else {
                            %>
                            <div class="alert alert-warning">Your session has not been set by the institution management. Kindly check back later.</div>
                            <%
                                    }
                                }
                            %>

                        </div>
                    </div>

                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>
        <script>
            // Auto-scroll to applicant details when confirmed
            window.addEventListener('DOMContentLoaded', function() {
                const detailsCard = document.getElementById('applicant-details-card');
                if (detailsCard) {
                    // Add a small delay to ensure page is fully loaded
                    setTimeout(function() {
                        detailsCard.scrollIntoView({ 
                            behavior: 'smooth', 
                            block: 'start' 
                        });
                        
                        // Add a subtle highlight effect
                        detailsCard.style.boxShadow = '0 0 20px rgba(0, 123, 255, 0.3)';
                        detailsCard.style.transition = 'box-shadow 0.3s ease-in-out';
                        
                        // Remove highlight after 3 seconds
                        setTimeout(function() {
                            detailsCard.style.boxShadow = '';
                        }, 3000);
                    }, 500);
                }
            });
        </script>

    </body>
</html>
