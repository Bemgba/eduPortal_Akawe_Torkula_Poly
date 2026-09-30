<%-- 
    Document   : student_private_payment
    Created on : 19 Dec 2024
    Author     : BEMGBA
    Purpose    : Private fee group payments for authenticated students
--%>

<%@page import="java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>

<%-- Authentication check - redirect to login if not authenticated --%>
<%    
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    
    // Ensure student object is available

%>

<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>

        

        <title><%=settings.productName%> - Private Payment</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Private Payments</h2>
                </div>
            </header>

            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            
                            <%-- Student Information Card --%>
                            <div class="card">
                                <div class="card-header d-flex align-items-center">
                                    <strong>Payment for <%=std.getSurname() + " " + std.getOthernames()%></strong>
                                    <a class="btn btn-sm btn-secondary ms-auto" href="/std_dashboard">
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-left"></use>
                                        </svg> Back to Dashboard
                                    </a>
                                </div>
                                <div class="card-body">
                                    <%
                                        String sessions = request.getParameter("sessions");
                                        String feesgroup = request.getParameter("feesgroup");
                                        String sesssem = request.getParameter("sesssem");
                                        String generate = request.getParameter("generate");
                                        List<Feessetup> feessetup = new ArrayList();
                                        
                                        // Handle payment generation
                                        if (generate != null && generate.length() > 0) {
                                            try {
                                                PaymentreferenceDetail prd = sess.createStudentsPayments(std.getId(), feesgroup, sessions, sesssem);
                                                if (prd.getPayref().length() > 0) {
                                                    String email = std.getUniversityEmail() == null ? std.getPersonalEmail() : std.getUniversityEmail();
                                                    String regno = std.getMatricNo() != null ? std.getMatricNo() : std.getRegistrationNo();
                                                    String coursename = std.getCourseId().getName();
                                                    String fullname = std.getSurname() + " " + std.getOthernames();
                                                    String level = "None";
                                                    
                                                    // Get student level for selected session
                                                    Collection<Studentprogression> cl2 = std.getStudentprogressionCollection();
                                                    for (Studentprogression sp : cl2) {
                                                        if (sp.getSessionAdded().equalsIgnoreCase(sessions)) {
                                                            level = sp.getLevelAdded();
                                                            break;
                                                        }
                                                    }

                                                    // Store payment context in session
                                                    session.setAttribute("FEESSETUP", feessetup);
                                                    session.setAttribute("STDY", std);
                                                    session.setAttribute("level", level);
                                                    session.setAttribute("sessions", sessions);
                                                    session.setAttribute("feesgroup", feesgroup);
                                                    session.setAttribute("sesssem", sesssem);
                                                    session.setAttribute("regno", regno);
                                                    session.setAttribute("fullname", fullname);
                                                    session.setAttribute("coursename", coursename);
                                                    session.setAttribute("phoneno", std.getPhoneNo());
                                                    session.setAttribute("email", email);
                                                    session.setAttribute("id", std.getId());

                                                    try {
                                                        Paymentreference prx = sess.getPaymentreference(prd.getPayref());
                                                        session.setAttribute("pr", prx);
                                                    } catch (Exception k) {
                                                    }
                                                    
                                                    String returnurl = "/private_payment";
                                                    returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                    response.sendRedirect("/invoice?return=" + returnurl);

                                                } else {
                                    %>
                                    <div class="alert alert-warning"><%=prd.getRefdescription()%></div>
                                    <%
                                                }

                                            } catch (Exception k) {
                                                k.printStackTrace();
                                    %>
                                    <div class="alert alert-danger">Error processing payment request. Please try again.</div>
                                    <%
                                            }
                                        }
                                    %>
                                    
                                    <form action="" method="post" name="privatepayment">
                                        <div class="table-responsive-sm">
                                            <table class="table table-striped">
                                                <tbody>
                                                    <tr>
                                                        <td class="left"><strong>Full Name</strong></td>
                                                        <td class="left"><%=std.getSurname() + " " + std.getOthernames()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Student ID</strong></td>
                                                        <td class="left"><%=std.getMatricNo() == null ? std.getRegistrationNo() : std.getMatricNo()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>School</strong></td>
                                                        <td class="left"><%=std.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Course</strong></td>
                                                        <td class="left"><%=std.getCourseId().getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Current Level</strong></td>
                                                        <td class="left"><%=std.getCurrentClass()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Select Session</strong></td>
                                                        <td class="left">
                                                            <select class="form-select" name='sessions' required>
                                                                <option value="">Select Session</option>
                                                                <%
                                                                    try {
                                                                        Collection<Studentprogression> cl = std.getStudentprogressionCollection();
                                                                        List<String> sessionsx = new ArrayList();
                                                                        for (Studentprogression sp : cl) {
                                                                            if (!sessionsx.contains(sp.getSessionAdded())) {
                                                                                sessionsx.add(sp.getSessionAdded());
                                                                            }
                                                                        }

                                                                        Collections.sort(sessionsx, Collections.reverseOrder());
                                                                        for (String sess : sessionsx) {
                                                                %>
                                                                <option value="<%=sess%>" <%=sess.equals(sessions) ? "selected" : ""%>><%=sess%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    
                                                    <%-- Information about public fees --%>
                                                    <%
                                                        List<Feesgroup> feesgpublic = sess.getFeesgroupBySchoolAndCategory(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "Students","PUBLIC");
                                                        if(!feesgpublic.isEmpty()){
                                                    %>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div class="alert alert-info">
                                                                <strong>Note:</strong> For public payments (School Fees, etc.), please use the 
                                                                <a href="/std_payment" class="btn btn-sm btn-primary">Public Payment Page</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                    
                                                    <tr>
                                                        <td class="left"><strong>Select Private Payment</strong></td>
                                                        <td class="left">
                                                            <select class="form-select" name="feesgroup" id='feesgroup' onchange="loadSesssem()" required>
                                                                <option value="">Select Payment Type</option>
                                                                <%
                                                                    try {
                                                                        List<Feesgroup> feesg = sess.getFeesgroupBySchoolAndCategory(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "Students","PRIVATE");
                                                                        for (Feesgroup fg : feesg) {
                                                                %>
                                                                <option value="<%=fg.getId()%>" <%=fg.getId().equals(feesgroup) ? "selected" : ""%>><%=fg.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Select Session/Semester</strong></td>
                                                        <td class="left">
                                                            <select class="form-select" name="sesssem" id='sesssem' required>
                                                                <option value="">Select Session/Semester</option>
                                                            </select>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td class="left"></td>
                                                        <td class="left">
                                                            <input type="submit" class="btn btn-lg btn-success" name="generate" value="Generate Invoice"/>
                                                        </td>
                                                    </tr>

                                                </tbody>
                                            </table>
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
            function loadSesssem() {
                const sel2 = document.getElementById("feesgroup");
                const catval = sel2.value;
                const url = "AjaxServlet?action=loadsesssem&id=" + escape(catval);

                fetch(url)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Network response was not ok");
                            }
                            return response.text();
                        })
                        .then(data => {
                            document.getElementById("sesssem").innerHTML = data;
                        })
                        .catch(error => console.error("Fetch error:", error));
            }
        </script>
        <!-- Plugins and scripts required by this view-->
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

    </body>
</html>