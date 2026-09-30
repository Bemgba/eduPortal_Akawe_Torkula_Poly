<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Date"%>
<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>


<%
    Summerschoolapplication genapp = null;
    try {
        genapp = (Summerschoolapplication) session.getAttribute("app");
    } catch (Exception x) {
    }
    if (genapp == null) {
        response.sendRedirect("/std_summer_app");
    }

%>

<%    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        Summerschoolregistration dd = (Summerschoolregistration) sess.getSingleObject(Summerschoolregistration.class, id2);
        if (dd != null) {
            sess.deleteObject("Summerschoolregistration", dd.getId());
        }
    }


%>

<%     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    List<Summerschoolregistration> lschatt = sess.getSummerschoolregistrationByStudent(genapp.getId());
%>   
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Summer School Application</title>

        <script>

            async function loadDocument(id) {
                try {
                    const url = "AjaxServlet?action=loadDodument&id2=" + escape(id);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById("det").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
        </script>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Summer School Application</h2>
                </div>
            </header>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <%                        if (std != null) {
                            String payitem = "10167";
                            String payitemreg = "";
                            try {
                                Feesgroup fg = sess.getFeesgroupByNameAndSchool(settings.summerscholappFee, std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                                if (fg != null) {
                                    payitem = fg.getId();
                                }

                                Feesgroup fg2 = sess.getFeesgroupByNameAndSchool(settings.summerscholregFee, std.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                                if (fg2 != null) {
                                    payitemreg = fg2.getId();
                                }
                            } catch (Exception ka) {
                            }

                            List<Payments> payl = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), payitem, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session");
                            List<Payments> paylreg = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), payitemreg, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session");
                            if (payl.size() > 0) {
                                if (genapp.getApplicationStatus().equals("PENDING")) {
                                    sess.updateSummerschoolapplicationStatus(genapp.getId(), "PAID");
                                    genapp = sess.getSummerschoolapplicationById(genapp.getId());
                                }
                            }

                            if (paylreg.size() > 0 && !genapp.getApplicationStatus().equals("PENDING")) {
                                sess.updateSummerschoolapplicationStatus(genapp.getId(), "REGISTERED");
                                genapp = sess.getSummerschoolapplicationById(genapp.getId());
                            }

                    %>

                    <div class="card mb-4">

                        <div class="card-header">
                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>
                            <a href="/std_summer_app" class="btn btn-danger btn-sm float-end">Back</a>
                        </div>



                        <div class="card-body">  
                            <%
                                String id3 = request.getParameter("id3");
                                if (id3 != null && id3.length() > 0) {
                                    id3 = settings.decryptText(id3);
                                    if (id3.equalsIgnoreCase("Pay")) {

                                    }
                                }
                            %>

                            <%
                                String semcourses = request.getParameter("semcourses");
                                String button4a = request.getParameter("button4a");
                                if (semcourses != null && semcourses.length() > 0 && button4a != null && button4a.length() > 0) {
                                    try {
                                        // Filter using final variables
                                        List<Summerschoolregistration> contains = lschatt.stream()
                                                .filter(data -> data.getSemesterCourseId().getId().equalsIgnoreCase(semcourses))
                                                .collect(Collectors.toList());
                                        if (!contains.isEmpty()) {
                            %>
                            <div class="alert alert-danger">This Course has already been added</div>
                            <%
                            } else {
                                String id = genapp.getId() + settings.generateId("", 4);
                                Summerschoolregistration scha = new Summerschoolregistration(id);
                                scha.setApplicationId(genapp);
                                Semestercourses semd = (Semestercourses) sess.getSingleObject(Semestercourses.class, semcourses);
                                scha.setSemesterCourseId(semd);
                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }

                                        lschatt = sess.getSummerschoolregistrationByStudent(genapp.getId());
                                    } catch (Exception ks) {
                                    }
                                }
                            %>

                            <strong>Your application status is <%=genapp.getApplicationStatus()%></strong>

                            <%
                                if (genapp.getApplicationStatus().equalsIgnoreCase("PENDING")
                                        || genapp.getApplicationStatus().equalsIgnoreCase("PAID")) {
                                    if (payl.size() > 0) {
                            %>

                            <div class="card mb-4">

                                <div class="card-header">
                                    Application Details
                                </div>

                                <div class="card-body"> 
                                    <div class="alert alert-info">
                                        <p>Kindly note that you can not add additional courses after payment. Always make sure you add all your desired courses before making payment</p>

                                    </div>
                                    <table class="table table-striped">
                                        <tr>
                                            <th>Summer School Session</th>
                                            <td><%=genapp.getSummerSchoolStatusId().getSessionStarted()%></td>
                                        </tr>
                                        <tr>
                                            <th>Date Opened</th>
                                            <td><%=settings.formatDate(genapp.getSummerSchoolStatusId().getDateOpened())%></td>
                                        </tr>
                                        <tr>
                                            <th>Courses Selected</th>
                                                <%
                                                    int nocourses = lschatt.size();
                                                %>
                                            <td><%=nocourses%></td> 
                                        </tr>
                                        <tr>
                                            <th>Amount to Pay</th>
                                                <%
                                                    String fee = "Not Set";
                                                    try {
                                                        String payid = sess.getFeesgroupByNameAndSchool(settings.summerscholregFee, std.getCourseId().getSchoolProgrammeId().getSchoolId().getId()).getId();
                                                        List<Feessetup> feessetup = new ArrayList();
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
                                                            feessetup = sess.getFeessetup(payid, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session", sch, prog, fac, dept,
                                                                    course, level, ind, campus, dfrom, std.getId());
                                                            if (feessetup.size() > 0) {
                                                                double total = feessetup.stream()
                                                                        .mapToDouble(Feessetup::getAmount)
                                                                        .sum();
                                                                fee = "N " + settings.formatno.format(total * nocourses);
                                                            }
                                                        } catch (Exception k) {
                                                        }
                                                    } catch (Exception k) {
                                                    }

                                                %>
                                            <td><%=fee%></td>
                                        </tr>
                                        <tr>
                                            <th>Pay for Courses</th>
                                                <%
                                                    String payid = sess.getFeesgroupByNameAndSchool(settings.summerscholregFee, std.getCourseId().getSchoolProgrammeId().getSchoolId().getId()).getId();
                                                    List<Feessetup> feessetup = new ArrayList();
                                                    try {
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
                                                            feessetup = sess.getFeessetup(payid, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session", sch, prog, fac, dept,
                                                                    course, level, ind, campus, dfrom, std.getId());
                                                            if (feessetup.size() > 0) {
                                                                String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                                                                boolean exist = false;
                                                                if (fgx.equalsIgnoreCase("No")) {
                                                                    if (paylreg.size() > 0) {
                                                                        exist = true;
                                                                    }

                                                                }
                                                                if (exist) {

                                                                } else {
                                                                    String email = std.getUniversityEmail() != null ? std.getUniversityEmail() : std.getPersonalEmail();
                                                                    double total = feessetup.stream()
                                                                            .mapToDouble(Feessetup::getAmount)
                                                                            .sum();
                                                                    total = total * nocourses;
                                                                    session.setAttribute("FEESSETUP", feessetup);
                                                                    session.setAttribute("level", level);
                                                                    session.setAttribute("sessions", genapp.getSummerSchoolStatusId().getSessionStarted());
                                                                    session.setAttribute("feesgroup", payid);
                                                                    session.setAttribute("sesssem", "Session");
                                                                    session.setAttribute("regno", regno);
                                                                    session.setAttribute("fullname", fullname);
                                                                    session.setAttribute("coursename", coursename);
                                                                    session.setAttribute("phoneno", std.getPhoneNo());
                                                                    session.setAttribute("email", email);
                                                                    session.setAttribute("id", std.getId());

                                                                    Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                                                                    Schools schoolId = std.getCourseId().getSchoolProgrammeId().getSchoolId();
                                                                    Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                                                            total, std.getId(), settings.getCurrentDateTime(), "PENDING", null, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session", "", "", "", "", fullname,
                                                                            std.getPhoneNo(), email, "", feesGroupId, schoolId);
                                                                    pr.setPayerRegistrationIo(regno);
                                                                    pr.setCourseId(std.getCourseId().getId());
                                                                    pr.setLevel(level);
                                                                    sess.newEntry(pr);
                                                                    try {
                                                                        session.setAttribute("pr", pr);

                                                                    } catch (Exception k) {
                                                                    }
                                                                    String returnurl = "/summer_app1";
                                                                    returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                                    try {
                                                                        session.setAttribute("return", returnurl);
                                                                    } catch (Exception k) {
                                                                    }
                                                %>
                                            <td><a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-sm">Pay for Courses</a>
                                                <%
                                                                    //response.sendRedirect("/invoice?return=" + returnurl);
                                                                }

                                                            }
                                                        } catch (Exception a) {
                                                            a.printStackTrace();
                                                        }
                                                    } catch (Exception k) {
                                                        k.printStackTrace();
                                                    }
                                                %>

                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <div class="card mb-4">

                                <div class="card-header">
                                    Semester Courses
                                </div>

                                <div class="card-body">               
                                    <form action='' method='post' name="institutions">
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Semester Course   
                                            </span>
                                            <select class="form-select" name="semcourses">
                                                <option value="">Select One</option>
                                                <%                                                    List<Semestercourses> listp = sess.getSemesterCoursesForSummerReg(std.getId());
                                                    for (Semestercourses semc : listp) {
                                                        boolean exist = false;
                                                        for (Summerschoolregistration dd : lschatt) {
                                                            if (semc.getId().equals(dd.getSemesterCourseId().getId())) {
                                                                exist = true;
                                                                break;
                                                            }
                                                        }
                                                        if (!exist) {
                                                %>
                                                <option value="<%=semc.getId()%>"><%=semc.getCode() + " : " + semc.getName()%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>


                                        <div class="row">
                                            <div class="col-12">
                                                <input type="submit" name="button4a" class="btn btn-primary px-4" value="Add Record"/>
                                            </div>

                                        </div>
                                    </form>

                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Course Code</th>
                                                <th>Course Name</th>
                                                <th>Semester</th>
                                                <th>Credit Unit</th>
                                                <th>Remove</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                for (Summerschoolregistration data : lschatt) {
                                            %>
                                            <tr>
                                                <td><%=data.getSemesterCourseId().getCode()%></td>
                                                <td><%=data.getSemesterCourseId().getName()%></td>
                                                <td><%=data.getSemesterCourseId().getSemester()%></td>
                                                <td><%=data.getSemesterCourseId().getCreditUnit()%></td>
                                                <td><a href="/summer_app1?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>

                                </div>
                            </div>


                            <%
                            } else {
                                String payid = payitem;
                                List<Feessetup> feessetup = new ArrayList();
                                try {
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
                                        feessetup = sess.getFeessetup(payid, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session", sch, prog, fac, dept,
                                                course, level, ind, campus, dfrom, std.getId());
                                        if (feessetup.size() > 0) {
                                            String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                                            boolean exist = false;
                                            if (fgx.equalsIgnoreCase("No")) {
                                                if (payl.size() > 0) {
                                                    exist = true;
                                                }

                                            }
                                            if (exist) {

                                            } else {
                                                String email = std.getUniversityEmail() != null ? std.getUniversityEmail() : std.getPersonalEmail();
                                                double total = feessetup.stream()
                                                        .mapToDouble(Feessetup::getAmount)
                                                        .sum();
                                                session.setAttribute("FEESSETUP", feessetup);
                                                session.setAttribute("level", level);
                                                session.setAttribute("sessions", genapp.getSummerSchoolStatusId().getSessionStarted());
                                                session.setAttribute("feesgroup", payid);
                                                session.setAttribute("sesssem", "Session");
                                                session.setAttribute("regno", regno);
                                                session.setAttribute("fullname", fullname);
                                                session.setAttribute("coursename", coursename);
                                                session.setAttribute("phoneno", std.getPhoneNo());
                                                session.setAttribute("email", email);
                                                session.setAttribute("id", std.getId());

                                                Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                                                Schools schoolId = std.getCourseId().getSchoolProgrammeId().getSchoolId();
                                                Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                                        total, std.getId(), settings.getCurrentDateTime(), "PENDING", null, genapp.getSummerSchoolStatusId().getSessionStarted(), "Session", "", "", "", "", fullname,
                                                        std.getPhoneNo(), email, "", feesGroupId, schoolId);
                                                pr.setPayerRegistrationIo(regno);
                                                pr.setCourseId(std.getCourseId().getId());
                                                pr.setLevel(level);
                                                sess.newEntry(pr);
                                                try {
                                                    session.setAttribute("pr", pr);

                                                } catch (Exception k) {
                                                }
                                                String returnurl = "/summer_app1";
                                                returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                try {
                                                    session.setAttribute("return", returnurl);
                                                } catch (Exception k) {
                                                }
                            %>
                            <a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-lg" style="margin-bottom: 10px">Pay Summer Application and Continue</a>
                            <%
                                                        //response.sendRedirect("/invoice?return=" + returnurl);
                                                    }

                                                }
                                            } catch (Exception a) {
                                            }
                                        } catch (Exception k) {
                                        }
                                    }
                                }
                                if (genapp.getApplicationStatus().equalsIgnoreCase("REGISTERED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your summer school application has been completed. </p>
                                <p>Download Documents:
                                    <a href="/DownloadSummerForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-secondary btn-sm float-end">Download Registration Form</a> 
                                </p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <%
                        }
                    %>
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

        <script src="js/popovers.js"></script>

        <script>
            function printTable(tableId) {
                // Get the table element by ID
                const table = document.getElementById(tableId);

                if (!table) {
                    alert("Table not found!");
                    return;
                }

                // Create a new window for printing
                const printWindow = window.open('', '_blank');

                if (!printWindow) {
                    alert("Failed to open print window. Please check your browser settings.");
                    return;
                }

                // Build the content for the print window
                const htmlContent = `
        <html>
        <head>
            <title>Transcript Form</title>
            <style>
                table {
                    border-collapse: collapse;
                    width: 100%;
                }
                table, th, td {
                    border: 1px solid black;
                }
                th, td {
                    padding: 8px;
                    text-align: left;
                }
                .center {
                    text-align: center;
                }
                .alert {
                    margin: 10px 0;
                    padding: 10px;
                    background-color: #d9edf7;
                    border: 1px solid #bce8f1;
                    border-radius: 4px;
                    color: #31708f;
                }
            </style>
        </head>
        <body>
            ${table.outerHTML}
        </body>
        </html>
    `;

                // Write the content to the new window
                printWindow.document.open();
                printWindow.document.write(htmlContent);
                printWindow.document.close();

                // Print the content and close the window after printing
                printWindow.onload = function () {
                    printWindow.print();
                    setTimeout(() => printWindow.close(), 1000); // Wait to ensure print completes before closing
                };
            }
        </script>     
        <script>
        </script>

    </body>
</html>