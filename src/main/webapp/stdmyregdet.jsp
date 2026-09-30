<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    Studentprogression sp = null;
    try {
        sp = (Studentprogression) session.getAttribute("sp");
    } catch (Exception k) {
        k.printStackTrace();
    }
    if (sp == null) {
        response.sendRedirect("/my_reg");
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    List<Feessetup> feessetup = new ArrayList();
    String fgi = "";
    Semesterregistrationcucontrol minmax = sess.getSemesterregistrationcucontrol(sp.getCourseId().getId(), sp.getLevelAdded(), sp.getSemesterAdded());
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - My Registrations</title>
        <style>
            .course-row {
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .course-row:hover {
                transform: translateX(2px);
            }
            .course-selected {
                background-color: #d4edda !important;
                border-left: 4px solid #28a745 !important;
            }
            .credit-summary-card {
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                border-radius: 8px;
            }
            .progress {
                border-radius: 10px;
            }
            .course-category-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-weight: bold;
            }
            .submit-section {
                background-color: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">My Registration Details</h2>
                </div>
            </header>

            <%                try {
                    Feesgroup gfg = sess.getSchoolFeesId(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                    if (gfg != null) {
                        fgi = gfg.getId();
                    }
                } catch (Exception k) {
                    k.printStackTrace();
                }
                String ind = "None";
                String sch = "None";
                String prog = "None";
                String fac = "None";
                String dept = "None";
                String course = "None";
                String level = "None";
                String campus = "None";

                String regno = "";
                String fullname = "";
                String coursename = "";
                Date dfrom = settings.getCurrentDateTime();
                try {

                    regno = std.getId();
                    fullname = std.getSurname() + " " + std.getOthernames();
                    coursename = std.getCourseId().getName();

                    sch = std.getCourseId().getSchoolProgrammeId().getSchoolId().getId();
                    prog = std.getCourseId().getSchoolProgrammeId().getProgrammeId().getId() + "";
                    fac = std.getCourseId().getDepartmentId().getFacultyId().getId();
                    dept = std.getCourseId().getDepartmentId().getId();
                    course = std.getCourseId().getId();
                    if (std.getStateOfOrigin().getId() == settings.indigeneStateCode) {
                        ind = "indigene";
                    } else {
                        ind = "non_indigene";
                    }
                    level = sp.getLevelAdded();
                    
                    feessetup = sess.getFeessetup(fgi, sp.getSessionAdded(), sp.getSemesterAdded(), sch, prog, fac, dept,
                            course, level, ind, campus, dfrom, std.getId());

                } catch (Exception a) {
                }

            %>

            <%                 String[] selectedcourses = request.getParameterValues("coursecode");
                String submit = request.getParameter("submit");
                String msd = "";
                String sty = "danger";
                
                if (submit != null && submit.length() > 0 && selectedcourses != null && selectedcourses.length > 0) {
                    List<String> ids = new ArrayList();
                    int totalcu = 0;
                    boolean reset = false;
                    for (String d : selectedcourses) {
                        if (d.contains("_")) {
                            String[] split = d.split("_");
                            ids.add(split[0]);
                            try {
                                totalcu += Integer.valueOf(split[1]);
                            } catch (Exception k) {
                            }
                        }
                    }
                    try {
                        if (minmax != null) {
                            if (totalcu >= minmax.getMincu() && totalcu <= minmax.getMaxcu()) {
                                reset = true;
                            } else {
                                msd = "Error registering courses. Total credit units selected " + totalcu + " is out of allowable range (" + minmax.getMincu() + " and " + minmax.getMaxcu() + ")";
                            }
                        } else {
                            reset = true;
                        }
                        if (reset) {
                            sess.registerSemesterCourses(sp, ids);
                            msd = ids.size() + " courses totaling " + totalcu + " Credit units has been registered successfully";
                            sty = "success";
                            sp = (Studentprogression) sess.getSingleObject(Studentprogression.class, sp.getId());
                        }
                    } catch (Exception k) {
                    }
                }

                List<Semesterregistration> smreg = sess.getSemesterRegistrationByStudentsSessionAndSemester(sp.getStudentsId().getId(), sp.getSessionAdded(), sp.getSemesterAdded());
                int totalcu = 0;
                try {
                    totalcu = smreg.stream()
                            .mapToInt(Semesterregistration::getCreditUnit)
                            .sum();
                } catch (Exception k) {
                }
            %>
            <script>
                // Get the dynamic title from a JSP variable
                var newTitle = "Registration details for <%=std.getSurname()%> <%=std.getOthernames()%>";
                // Update the page title
                document.title = newTitle;
            </script>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong>Registration Details for <%=sp.getSessionAdded()%>, <%=sp.getSemesterAdded()%> Semester</strong> 
                                <a href="/my_reg" class="btn btn-danger btn-sm float-right">Back</a>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover">

                                        <tbody>
                                            <tr>
                                                <th>Level</th>
                                                <td><%=sp.getLevelAdded()%></td>
                                            </tr>
                                            <tr>
                                                <th>Date Added</th>
                                                    <%
                                                        String dateadded = "";
                                                        try {
                                                            dateadded = sdf.format(sp.getDateAdded());
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><%=dateadded%></td>
                                            </tr>
                                            <tr>
                                                <th>School Fees</th>
                                                    <%
                                                        String schfees = "No Setup Yet";
                                                        String paidStatus = "Not Paid";
                                                        String paidsty = "danger";
                                                        String regsty = "danger";
                                                        String regstatus = "NOT REGISTERED";
                                                        try {

                                                            if (feessetup.size() > 0) {
                                                                double total = feessetup.stream()
                                                                        .mapToDouble(Feessetup::getAmount)
                                                                        .sum();
                                                                schfees = "N" + settings.formatno.format(total);

                                                            }

                                                            if (sp.getRegistrationStatus().equalsIgnoreCase("1")) {
                                                                regsty = "success";
                                                                regstatus = "REGISTERED";
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><%=schfees%></td>
                                            </tr>
                                            <tr>
                                                <th>Payment Status</th>
                                                    <%

                                                        try {
                                                            List<Payments> li = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), fgi, sp.getSessionAdded(), sp.getSemesterAdded());
                                                            if (li.size() > 0) {
                                                                double total = li.stream()
                                                                        .mapToDouble(Payments::getAmount)
                                                                        .sum();
                                                                paidStatus = "Paid N" + settings.formatno.format(total);
                                                                paidsty = "success";
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><span class="alert alert-<%=paidsty%>"><%=paidStatus%></span></td>
                                            </tr>
                                            <tr>
                                                <th>Registration Status</th>
                                                <td><span class="alert alert-<%=regsty%>"><%=regstatus%></span>
                                                    <%
                                                        if (regstatus.equalsIgnoreCase("REGISTERED")) {
                                                            String idu = settings.encodeUrl(settings.encryptText(sp.getId()));
                                                            if (sp.getSessionAdded().equalsIgnoreCase(sessman.getName())) {
                                                    %>
                                                    <a href="/DownloadExamCard?id=<%=idu%>" target="_blank" class="btn btn-secondary btn-lg float-end">Download Exam Card</a>
                                                    <%
                                                        }
                                                    %>

                                                    <a href="/DownloadRegistrationForm?id=<%=idu%>" target="_blank" class="btn btn-primary btn-lg float-end">Download Registration Form</a>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>Date Registered</th>
                                                    <%
                                                        String datereg = "Not Registered";
                                                        try {
                                                            if (sp.getDateRegistered() != null) {

                                                                datereg = sdf.format(sp.getDateRegistered());
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    %>
                                                <td><%=datereg%></td>
                                            </tr>
                                            <tr>
                                                <th>Allowed Minimum Credits</th>
                                                <td><%=minmax != null ? minmax.getMincu() : "Not Set"%></td>
                                            </tr>

                                            <tr>
                                                <th>Allowed Maximum Credits</th>
                                                <td><%=minmax != null ? minmax.getMaxcu() : "Not Set"%></td>
                                            </tr>
                                            <tr>
                                                <th>Total Credit Units Registered</th>
                                                <td><%=totalcu%></td>
                                            </tr>
                                            <tr>
                                                <th>Total Courses Registered</th>
                                                <td><%=smreg.size()%></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div style="height: 10px"></div>
                        <%
                            if (paidStatus.equalsIgnoreCase("Not Paid")) {
                                //make payment
                                String payid = fgi;

                                PaymentreferenceDetail prd = sess.createSchoolFeesPayments(std.getId(), sp.getSessionAdded(), sp.getSemesterAdded());
                                if (prd.getPayref().length() > 0) {
                                    String email = std.getUniversityEmail() != null ? std.getUniversityEmail() : std.getPersonalEmail();
                                    double total = feessetup.stream()
                                            .mapToDouble(Feessetup::getAmount)
                                            .sum();
                                    session.setAttribute("FEESSETUP", feessetup);
                                    session.setAttribute("level", level);
                                    session.setAttribute("sessions", sp.getSessionAdded());
                                    session.setAttribute("feesgroup", payid);
                                    session.setAttribute("sesssem", sp.getSemesterAdded());
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
                                    String returnurl = "/my_reg_det";
                                    returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                    try {
                                        session.setAttribute("return", returnurl);
                                    } catch (Exception k) {
                                    }
                        %>
                        <a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-lg" style="margin-bottom: 10px">Pay and Proceed</a>
                        <%

                            } else {

                            }

                        } else {
                            if (sp.getRegistrationStatus().equalsIgnoreCase("0") || sp.getRegistrationStatus().equalsIgnoreCase("1")) {
                                //register
                        %>
                        <div class="card mb-4">
                            <div class="card-header">
                                Register/Edit Registration
                            </div>
                            <div class="card-body">

                                <%
                                    if (msd.length() > 0) {
                                %>
                                <div class="alert alert-<%=sty%>"><%=msd%></div>
                                <%
                                    }
                                %>

                                <form action="" method="post" name="semregistration">
                                    <!-- Hidden inputs for JavaScript -->
                                    <input type="hidden" id="minCreditsValue" value="<%=minmax != null ? minmax.getMincu() : 0%>">
                                    <input type="hidden" id="maxCreditsValue" value="<%=minmax != null ? minmax.getMaxcu() : 999%>">
                                    
                                    <!-- Credit Unit Summary Card -->
                                    <div class="card mb-3 border-info">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h5 class="text-info">Selected Credits</h5>
                                                        <h2 id="selectedCreditsDisplay" class="text-primary">0</h2>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h6 class="text-muted">Minimum Required</h6>
                                                        <h4 class="text-warning"><%=minmax != null ? minmax.getMincu() : "Not Set"%></h4>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h6 class="text-muted">Maximum Allowed</h6>
                                                        <h4 class="text-danger"><%=minmax != null ? minmax.getMaxcu() : "Not Set"%></h4>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="text-center">
                                                        <h6 class="text-muted">Status</h6>
                                                        <span id="statusIndicator" class="badge bg-secondary">Not Started</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="mt-2">
                                                <div class="progress" style="height: 8px;">
                                                    <div id="creditProgress" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="table-responsive-sm"></div>
                                        <table class="table table-striped table-hover">
                                            <thead>
                                            <th>SELECT OP</th>
                                            <th>COURSE CODE</th>
                                            <th>COURSE NAME</th>
                                            <th>CREDIT UNIT</th>
                                            </thead>
                                            <%
                                                // Use local database only - no ExamWS dependency
                                                List<Semesterregistrationcourses> regcourses = sess.getSemesterRegistrationCourses(sp.getCourseId().getId(), sp.getLevelAdded(), sp.getSemesterAdded(), "ACTIVE");
                                                
                                                List<Semesterregistrationcourses> coursesCO = regcourses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("CARRY OVER"))
                                                        .collect(Collectors.toList());
                                                List<Semesterregistrationcourses> coursesCORE = regcourses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("CORE"))
                                                        .collect(Collectors.toList());
                                                List<Semesterregistrationcourses> coursesGST = regcourses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("GST"))
                                                        .collect(Collectors.toList());
                                                List<Semesterregistrationcourses> coursesELECTIVE = regcourses.stream()
                                                        .filter(oltype -> oltype.getCourseType().equalsIgnoreCase("ELECTIVE"))
                                                        .collect(Collectors.toList());

                                            %>
                                            <tbody>
                                                <tr class="course-category-header">
                                                    <th colspan="4"><i class="fas fa-redo"></i> Carry-Over Courses</th>
                                                </tr>
                                                <%                                                if (coursesCO.size() == 0) {
                                                %>
                                                <tr>
                                                    <td colspan="4"><div class="alert alert-warning">No carry-over course found</div></td>
                                                </tr>
                                                <%
                                                } else {
                                                    for (Semesterregistrationcourses sm : coursesCO) {
                                                        String chk = "";
                                                        boolean checkreg = sess.checkSemesterregistration(std.getId(), sm.getId(), sp.getSessionAdded());
                                                        if (checkreg) {
                                                            chk = "checked=\"\"";
                                                        }
                                                %>
                                                <tr>
                                                    <td><input <%=chk%> class="form-check-input" name="coursecode" value="<%=sm.getId()%>_<%=sm.getCreditUnit()%>" type="checkbox"></td>
                                                    <td><%=sm.getSemesterCourseId().getCode()%></td>
                                                    <td><%=sm.getSemesterCourseId().getName()%></td>
                                                    <td><%=sm.getCreditUnit()%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>

                                                <%                                                if (coursesGST.size() > 0) {
                                                %>
                                                <tr class="course-category-header">
                                                    <th colspan="4"><i class="fas fa-graduation-cap"></i> GST/EPS Courses</th>
                                                </tr>
                                                <%
                                                    for (Semesterregistrationcourses sm : coursesGST) {
                                                        String chk = "";
                                                        boolean checkreg = sess.checkSemesterregistration(std.getId(), sm.getId(), sp.getSessionAdded());
                                                        if (checkreg) {
                                                            chk = "checked=\"\"";
                                                        }
                                                %>
                                                <tr>
                                                    <td><input <%=chk%> class="form-check-input" name="coursecode" value="<%=sm.getId()%>_<%=sm.getCreditUnit()%>" type="checkbox"></td>
                                                    <td><%=sm.getSemesterCourseId().getCode()%></td>
                                                    <td><%=sm.getSemesterCourseId().getName()%></td>
                                                    <td><%=sm.getCreditUnit()%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>

                                                <%                                                if (coursesCORE.size() > 0) {
                                                %>
                                                <tr class="course-category-header">
                                                    <th colspan="4"><i class="fas fa-star"></i> Core Courses</th>
                                                </tr>
                                                <%
                                                    for (Semesterregistrationcourses sm : coursesCORE) {
                                                        String chk = "";
                                                        boolean checkreg = sess.checkSemesterregistration(std.getId(), sm.getId(), sp.getSessionAdded());
                                                        if (checkreg) {
                                                            chk = "checked=\"\"";
                                                        }
                                                %>
                                                <tr>
                                                    <td><input <%=chk%> class="form-check-input" name="coursecode" value="<%=sm.getId()%>_<%=sm.getCreditUnit()%>" type="checkbox"></td>
                                                    <td><%=sm.getSemesterCourseId().getCode()%></td>
                                                    <td><%=sm.getSemesterCourseId().getName()%></td>
                                                    <td><%=sm.getCreditUnit()%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>


                                                <%                                                if (coursesELECTIVE.size() > 0) {
                                                %>
                                                <tr class="course-category-header">
                                                    <th colspan="4"><i class="fas fa-list-ul"></i> Elective Courses</th>
                                                </tr>
                                                <%
                                                    for (Semesterregistrationcourses sm : coursesELECTIVE) {
                                                        String chk = "";
                                                        boolean checkreg = sess.checkSemesterregistration(std.getId(), sm.getId(), sp.getSessionAdded());
                                                        if (checkreg) {
                                                            chk = "checked=\"\"";
                                                        }
                                                %>
                                                <tr>
                                                    <td><input <%=chk%> class="form-check-input" name="coursecode" value="<%=sm.getId()%>_<%=sm.getCreditUnit()%>" type="checkbox"></td>
                                                    <td><%=sm.getSemesterCourseId().getCode()%></td>
                                                    <td><%=sm.getSemesterCourseId().getName()%></td>
                                                    <td><%=sm.getCreditUnit()%></td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                %>
                                                <tr>
                                                    <td colspan="4" class="submit-section">
                                                        <div class="row align-items-center">
                                                            <div class="col-md-6">
                                                                <h5 class="mb-0">Total Selected Credit Units: <span id="totalCredits" class="badge bg-primary">0</span></h5>
                                                            </div>
                                                            <div class="col-md-6 text-end">
                                                                <div id="creditValidation" class="mb-2"></div>
                                                                <input type="submit" name="submit" value="Submit Registration" class="btn btn-primary btn-lg" id="submitBtn"/>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>

                                            </tbody>
                                        </table>
                                    </div>
                                </form>


                            </div>
                        </div>
                        <%
                            } else {
                                //view result
                            }
                        }
                        %>

                    </div> 
                    <!-- /.row-->
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
            // Credit unit validation and real-time calculation
            var minCredits, maxCredits;
            
            // Add event listeners when page loads
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize credit limits from hidden inputs
                minCredits = parseInt(document.getElementById('minCreditsValue').value);
                maxCredits = parseInt(document.getElementById('maxCreditsValue').value);
                
                const checkboxes = document.querySelectorAll('input[name="coursecode"]');
                checkboxes.forEach(function(checkbox) {
                    checkbox.addEventListener('change', updateCreditUnits);
                });
                
                // Add row effects
                addCourseRowEffects();
                
                // Initial calculation
                updateCreditUnits();
                
                // Form submission validation
                document.querySelector('form[name="semregistration"]').addEventListener('submit', function(e) {
                    const totalCredits = parseInt(document.getElementById('totalCredits').textContent);
                    
                    if (totalCredits === 0) {
                        e.preventDefault();
                        alert('Please select at least one course to register.');
                        return false;
                    }
                    
                    if (totalCredits < minCredits || totalCredits > maxCredits) {
                        e.preventDefault();
                        alert('Please select courses within the allowed credit unit range (' + minCredits + '-' + maxCredits + ' units).');
                        return false;
                    }
                    
                    // Show loading state
                    const submitBtn = document.getElementById('submitBtn');
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                    submitBtn.disabled = true;
                    
                    return true;
                });
            });
            
            function updateCreditUnits() {
                const checkboxes = document.querySelectorAll('input[name="coursecode"]:checked');
                let totalCredits = 0;
                
                checkboxes.forEach(function(checkbox) {
                    const value = checkbox.value;
                    if (value.includes('_')) {
                        const credits = parseInt(value.split('_')[1]);
                        if (!isNaN(credits)) {
                            totalCredits += credits;
                        }
                    }
                });
                
                // Update total display
                document.getElementById('totalCredits').textContent = totalCredits;
                document.getElementById('selectedCreditsDisplay').textContent = totalCredits;
                
                // Update progress bar
                const progressBar = document.getElementById('creditProgress');
                const statusIndicator = document.getElementById('statusIndicator');
                const progressPercentage = Math.min((totalCredits / maxCredits) * 100, 100);
                progressBar.style.width = progressPercentage + '%';
                
                // Validate and show feedback
                const validationDiv = document.getElementById('creditValidation');
                const submitBtn = document.getElementById('submitBtn');
                
                if (totalCredits === 0) {
                    validationDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> Please select courses to register</div>';
                    submitBtn.disabled = true;
                    submitBtn.classList.remove('btn-success');
                    submitBtn.classList.add('btn-primary');
                    statusIndicator.textContent = 'Not Started';
                    statusIndicator.className = 'badge bg-secondary';
                    progressBar.className = 'progress-bar bg-secondary';
                } else if (totalCredits < minCredits) {
                    validationDiv.innerHTML = '<div class="alert alert-warning"><i class="fas fa-exclamation-triangle"></i> You need at least <strong>' + minCredits + '</strong> credit units. Currently selected: <strong>' + totalCredits + '</strong></div>';
                    submitBtn.disabled = true;
                    submitBtn.classList.remove('btn-success');
                    submitBtn.classList.add('btn-warning');
                    statusIndicator.textContent = 'Below Minimum';
                    statusIndicator.className = 'badge bg-warning';
                    progressBar.className = 'progress-bar bg-warning';
                } else if (totalCredits > maxCredits) {
                    validationDiv.innerHTML = '<div class="alert alert-danger"><i class="fas fa-times-circle"></i> Maximum allowed is <strong>' + maxCredits + '</strong> credit units. Currently selected: <strong>' + totalCredits + '</strong></div>';
                    submitBtn.disabled = true;
                    submitBtn.classList.remove('btn-success');
                    submitBtn.classList.add('btn-danger');
                    statusIndicator.textContent = 'Exceeds Maximum';
                    statusIndicator.className = 'badge bg-danger';
                    progressBar.className = 'progress-bar bg-danger';
                } else {
                    validationDiv.innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Perfect! <strong>' + totalCredits + '</strong> credit units selected (Range: ' + minCredits + '-' + maxCredits + ')</div>';
                    submitBtn.disabled = false;
                    submitBtn.classList.remove('btn-primary', 'btn-warning', 'btn-danger');
                    submitBtn.classList.add('btn-success');
                    statusIndicator.textContent = 'Ready to Submit';
                    statusIndicator.className = 'badge bg-success';
                    progressBar.className = 'progress-bar bg-success';
                }
                
                // Update badge color based on status
                const badge = document.getElementById('totalCredits');
                badge.className = 'badge ';
                if (totalCredits === 0) {
                    badge.className += 'bg-secondary';
                } else if (totalCredits < minCredits) {
                    badge.className += 'bg-warning';
                } else if (totalCredits > maxCredits) {
                    badge.className += 'bg-danger';
                } else {
                    badge.className += 'bg-success';
                }
            }
            
            // Add hover effects for course rows
            function addCourseRowEffects() {
                const courseRows = document.querySelectorAll('tr:has(input[name="coursecode"])');
                courseRows.forEach(function(row) {
                    const checkbox = row.querySelector('input[name="coursecode"]');
                    
                    if (checkbox) {
                        row.addEventListener('mouseenter', function() {
                            if (!checkbox.checked) {
                                row.style.backgroundColor = '#f8f9fa';
                            }
                        });
                        
                        row.addEventListener('mouseleave', function() {
                            if (!checkbox.checked) {
                                row.style.backgroundColor = '';
                            }
                        });
                        
                        // Click anywhere on row to toggle checkbox
                        row.addEventListener('click', function(e) {
                            if (e.target.type !== 'checkbox') {
                                checkbox.checked = !checkbox.checked;
                                updateRowStyle(row, checkbox.checked);
                                updateCreditUnits();
                            }
                        });
                        
                        // Update row style when checkbox changes
                        checkbox.addEventListener('change', function() {
                            updateRowStyle(row, this.checked);
                        });
                        
                        // Initial row style
                        updateRowStyle(row, checkbox.checked);
                    }
                });
            }
            
            function updateRowStyle(row, isChecked) {
                if (isChecked) {
                    row.style.backgroundColor = '#d4edda';
                    row.style.borderLeft = '4px solid #28a745';
                } else {
                    row.style.backgroundColor = '';
                    row.style.borderLeft = '';
                }
            }
        </script>

    </body>
</html>