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

        <title><%=settings.productName%> - EPayment Make-Up</title>
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
                                        <h1>e-Payment Make-Up  Page</h1>
                                        <%
                                            String studentid = request.getParameter("studentid");
                                            String button = request.getParameter("button");
                                            if (button != null && studentid != null && studentid.trim().length() > 0) {
                                                // password = settings.getMD5(password);
                                                studentid = studentid.toLowerCase();
                                                studentid = studentid.trim();
                                                String mainid = null;
                                                Students stdx = sess.getStudentsById(studentid);
                                                if (stdx != null) {
                                                    try {
                                                        mainid = stdx.getId();
                                                        
                                                    } catch (Exception d) {
                                                    }
                                                } else {
                                                    Applicants app = sess.getApplicants(studentid);
                                                    if (app != null) {
                                                        mainid = app.getId();
                                                    }
                                                }
                                                if (mainid == null) {
                                        %>
                                        <div class="alert alert-danger">Error: ID <%=studentid%> does not match either or students registration number or matric number of university email. Kindly confirm and reenter student's ID</div>
                                        <%
                                                } else {
                                                    try {
                                                        session.setAttribute("mainid", mainid);
                                                    } catch (Exception ka) {
                                                    }
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
                                            </div>
                                        </form>
                                    </div>
                                </div>

                            </div>

                            <%                                            String mainid = (String) session.getAttribute("mainid");
                                if (mainid != null) {
                            %>

                            <div class="card" style="margin-top:20px">
                                <div class="card col-md-5 text-white bg-primary py-5">
                                    <div class="card-body text-center">
                                        <div>
                                            <h2>Confirm your payment details</h2>
                                            <p>The following payments were not paid correctly. Kindly click on make-up payment to proceed. </p>
                                        </div>
                                    </div>
                                </div>
                                <%        
                                    List<Payments> payl = sess.getPaymentsByRegno(mainid);
                                    if (payl.size() > 0) {
                                        List<PaymentDetails> pdet = sess.aggregatePayments(payl);
                                        List<PaymentDetails> tomakeup = new ArrayList();
                                        if (pdet.size() > 0) {
                                            for (PaymentDetails data : pdet) {
                                                Paymentreference prx = sess.getPaymentreferenceingle(data.getFeesgroup(), mainid, data.getSessions(), data.getSemester());
                                                if (prx != null) {
                                                    Courses cos = (Courses) sess.getSingleObject(Courses.class, prx.getCourseId());
                                                    Feesgroup fg = prx.getFeesGroupId();
                                                    if (cos != null) {
                                                        String level = "None";
                                                        String ind = "None";
                                                        String campus = "None";
                                                        if (fg.getCategory().equalsIgnoreCase("Students")) {
                                                            Students stdz = sess.getStudentsById(mainid);
                                                            if (stdz != null) {
                                                                Collection<Studentprogression> cl2 = stdz.getStudentprogressionCollection();
                                                                level = stdz.getCurrentClass();
                                                                for (Studentprogression sp : cl2) {
                                                                    if (sp.getSessionAdded().equalsIgnoreCase(data.getSessions())) {
                                                                        level = sp.getLevelAdded();
                                                                        break;
                                                                    }
                                                                }
                                                                ind = "non_indigene";
                                                                if (stdz.getStateOfOrigin() != null && stdz.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                                                                    ind = "indigene";
                                                                }
                                                            }
                                                        }
                                                        List<Feessetup> feessetup = sess.getFeessetup(data.getFeesgroup(),
                                                                data.getSessions(), data.getSemester(),
                                                                cos.getSchoolProgrammeId().getSchoolId().getId(),
                                                                cos.getSchoolProgrammeId().getProgrammeId().getId() + "",
                                                                cos.getDepartmentId().getFacultyId().getId(),
                                                                cos.getDepartmentId().getId(),
                                                                prx.getCourseId(), level, ind, campus, settings.getCurrentDateTime(),
                                                                mainid);
                                                        
                                                        double total = feessetup.stream()
                                                                .mapToDouble(Feessetup::getAmount)
                                                                .sum();
                                                        if (data.getAmount() < total) {
                                                            data.setRealamt(total);
                                                            tomakeup.add(data);
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        if (tomakeup.size() > 0) {
                                %>
                                <div class="alert alert-info"><%=tomakeup.size()%> Items were paid wrongly. Kindly click on each to makeup</div>
                                <div class="card-body">
                                    <div class="table-responsive-sm">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th>Payment Item</th>
                                                    <th>Session</th>
                                                    <th>Semester</th>
                                                    <th>Amount Paid</th>
                                                    <th>Real Amount</th>
                                                    <th>Balance to Pay</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    for (PaymentDetails datax : tomakeup) {
                                                        Feesgroup fgx = (Feesgroup) sess.getSingleObject(Feesgroup.class, datax.getFeesgroup());
                                                        if (fgx != null) {
                                                %>
                                                <tr>
                                                    <td><%=fgx.getName()%></td>
                                                    <td><%=datax.getSessions()%></td>
                                                    <td><%=datax.getSemester()%></td>
                                                    <td><%=settings.formatno.format(datax.getAmount())%></td>
                                                    <td><%=settings.formatno.format(datax.getRealamt())%></td>
                                                    <td><%=settings.formatno.format(datax.getRealamt() - datax.getAmount())%></td>
                                                    <td><a href="/" class="btn btn-success btn-sm">Make-Up Now</a></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>





                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <%                                    
                                } else {
                                %>                                    
                                <div class="alert alert-warning">We could not find any Payment Item to make-up. <%=pdet.size()%> payments found were paid correctly</div>
                                <%
                                    }
                                } else {
                                %>
                                <div class="alert alert-danger">No Payment Record found for this user</div>
                                <%        
                                    }
                                %>



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
        </script>

    </body>
</html>