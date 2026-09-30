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
                                        <h1>Student's e-Payment Page</h1>
                                        <%
                                            String studentid = request.getParameter("studentid");
                                            String button = request.getParameter("button");
                                            if (button != null && studentid != null && studentid.trim().length() > 0) {
                                                // password = settings.getMD5(password);
                                                studentid = studentid.toLowerCase();
                                                studentid = studentid.trim();
                                                Students stdx = sess.getStudentsById(studentid);
                                                if (stdx != null) {
                                                    try {

                                                        session.setAttribute("STDX", stdx);
                                                    } catch (Exception d) {
                                                    }
                                                } else {
                                        %>
                                        <div class="alert alert-danger">Error: ID <%=studentid%> does not match either or students registration number or matric number of university email. Kindly confirm and reenter student's ID</div>
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
                                                <input class="form-control" type="text" required="" name="studentid" placeholder="Student ID">
                                            </div>

                                            <div class="row">
                                                <div class="col-12">
                                                    <input type="submit" name="button" class="btn btn-primary px-4" value="Confirm Details"/>
                                                </div>
                                                <div class="col-12 text-start">
                                                    <a href='/epayment' class="btn btn-link px-0">Not a student? Go back</a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Confirm your details</h2>
                                            <p>Student's ID is any of UTME registration number, Application number, University Matriculation number or University email address. You can use it to verify your identity before proceeding to make payment. </p>
                                            <p>Kindly note that payments are non-transferable. By confirming your details we assume that verified your details to be correct before proceeding.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%                                            Students stdy = (Students) session.getAttribute("STDX");
                                if (stdy != null) {
                            %>

                            <div class="card" style="margin-top:20px" id="student-details-card">
                                <div class="card-header d-flex align-items-center">Payment for <strong<%=stdy.getSurname() + " " + stdy.getOthernames()%></strong>
                                </div>
                                <div class="card-body">
                                    <%
                                        String sessions = request.getParameter("sessions");
                                        String feesgroup = request.getParameter("feesgroup");
                                        String sesssem = request.getParameter("sesssem");
                                        String generate = request.getParameter("generate");
                                        List<Feessetup> feessetup = new ArrayList();
                                        if (generate != null && generate.length() > 0) {
                                            try {

                                                PaymentreferenceDetail prd = sess.createStudentsPayments(stdy.getId(), feesgroup, sessions, sesssem);
                                                if (prd.getPayref().length() > 0) {
                                                    String email = stdy.getUniversityEmail() == null ? stdy.getPersonalEmail() : stdy.getUniversityEmail();
                                                    String regno = stdy.getMatricNo() != null ? stdy.getMatricNo() : stdy.getRegistrationNo();
                                                    String coursename = stdy.getCourseId().getName();
                                                    String fullname = stdy.getSurname() + " " + stdy.getOthernames();
                                                    String level = "None";
                                                    Collection<Studentprogression> cl2 = stdy.getStudentprogressionCollection();

                                                    for (Studentprogression sp : cl2) {
                                                        if (sp.getSessionAdded().equalsIgnoreCase(sessions)) {
                                                            level = sp.getLevelAdded();
                                                            break;
                                                        }
                                                    }

                                                    double total = feessetup.stream()
                                                            .mapToDouble(Feessetup::getAmount)
                                                            .sum();
                                                    session.setAttribute("FEESSETUP", feessetup);
                                                    session.setAttribute("STDY", stdy);
                                                    session.setAttribute("level", level);
                                                    session.setAttribute("sessions", sessions);
                                                    session.setAttribute("feesgroup", feesgroup);
                                                    session.setAttribute("sesssem", sesssem);
                                                    session.setAttribute("regno", regno);
                                                    session.setAttribute("fullname", fullname);
                                                    session.setAttribute("coursename", coursename);
                                                    session.setAttribute("phoneno", stdy.getPhoneNo());
                                                    session.setAttribute("email", email);
                                                    session.setAttribute("id", stdy.getId());

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
                                                        <td class="left"><%=stdy.getSurname() + " " + stdy.getOthernames()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Student ID</strong></td>
                                                        <td class="left"><%=stdy.getMatricNo() == null ? stdy.getRegistrationNo() : stdy.getMatricNo()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>School</strong></td>
                                                        <td class="left"><%=stdy.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Course</strong></td>
                                                        <td class="left"><%=stdy.getCourseId().getName()%></td>
                                                    </tr>

                                                    <tr>
                                                        <td class="left"><strong>Current Level</strong></td>
                                                        <td class="left"><%=stdy.getCurrentClass()%></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Select Session</strong></td>
                                                        <td class="left"><select class="form-select" name='sessions'>
                                                                <%
                                                                    try {
                                                                        Collection<Studentprogression> cl = stdy.getStudentprogressionCollection();

                                                                        // List<Studentprogression> col = sess.getStudentprogression(stdy.getId());
                                                                        List<String> sessionsx = new ArrayList();
                                                                        for (Studentprogression sp : cl) {
                                                                            if (!sessionsx.contains(sp.getSessionAdded())) {
                                                                                sessionsx.add(sp.getSessionAdded());
                                                                            }
                                                                        }

                                                                        Collections.sort(sessionsx, Collections.reverseOrder());
                                                                        for (String sess : sessionsx) {
                                                                %>
                                                                <option value="<%=sess%>"><%=sess%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select></td>
                                                    </tr>
                                                                  <%
                                                    List<Feesgroup> feesgprivate = sess.getFeesgroupBySchoolAndCategory(stdy.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "Students","PRIVATE");
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
                                                                <strong>To pay for these items, please login to your student account:</strong>
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
                                                            <select class="form-select" name="feesgroup" id='feesgroup' onchange="loadSesssem()">
                                                                <option value="">Select One</option>
                                                                <%
                                                                    try {
                                                                        String schoolId = stdy.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                                                                        List<Feesgroup> feesg = sess.getFeesgroupBySchoolAndCategory(schoolId, "Students","PUBLIC");
                                                                        for (Feesgroup fg : feesg) {
                                                                %>
                                                                <option value="<%=fg.getId()%>"><%=fg.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                        k.printStackTrace();
                                                                    }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="left"><strong>Select Session/Semester</strong></td>
                                                        <td class="left">
                                                            <select class="form-select" name="sesssem" id='sesssem'>
                                                            </select>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td class="left"><strong></td>
                                                        <td class="left">
                                                            <input type="submit" class="btn btn-lg btn-success" name="generate" value="Generate invoice"/>
                                                        </td>
                                                    </tr>

                                                </tbody>
                                            </table>
                                        </div>
                                    </form> 
                                </div>

                            </div>
                            <%
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
            // Auto-scroll to student details when confirmed
            window.addEventListener('DOMContentLoaded', function() {
                const detailsCard = document.getElementById('student-details-card');
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