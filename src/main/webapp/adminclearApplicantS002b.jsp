<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>

<%
    String sessiond = null;
    Courses cos = null;
    try {
        sessiond = (String) session.getAttribute("sessions");
        cos = (Courses) session.getAttribute("cos");
    } catch (Exception k) {
    }
    if (sessiond == null || cos == null) {
        response.sendRedirect("/applicant_pg_clearance");
    }

%>
<%    String idu = request.getParameter("idu");
    if (idu != null && idu.length() > 0) {
        idu = settings.decryptText(idu);

        Admissions adm = sess.getAdmissions(idu);
        if (adm != null) {
            try {
                sess.changeApplicantStatus(idu, "PAID");
                sess.deleteAdmissions(idu);
            } catch (Exception k) {
            }
        }
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Clear PG Applicant</title>

        <script>

            async function clearApplicant(appid) {
                try {
                    const url = "AjaxServlet?action=clearApplicant&id2=" + escape(appid);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    var spliter = respText.split("_");
                    var sty = spliter[0];
                    var stat = spliter[1];
                    var lab = spliter[2];
                    var sty2 = spliter[3];
                    var idx = appid.split("_")[0];
                    document.getElementById(idx + "a").innerHTML = stat; // Use `id` here
                    document.getElementById(idx + "a").className = "alert alert-" + sty; // Use `id` here
                    document.getElementById(idx + "c").innerHTML = lab; // Use `id` here
                    document.getElementById(idx + "c").className = "btn btn-sm btn-" + sty2; // Use `id` here
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
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">

                    <h2 class="title">List of PG Applicant not cleared for <%=sessiond%> in <%=cos.getName()%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <a href="/applicant_pg_clearance" class="btn btn-danger">Back</a>
                                </p>
                            </div>
                        </div>
                    </div>


                    <div class="col-12">
                        <div class="card mb-4">


                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>REG NO</th>
                                                <th>SURNAME</th>
                                                <th>OTHER NAMES</th>
                                                <th>DATE OF BIRTH</th>
                                                <th>STATE OF ORIGIN</th>
                                                <th>LGA</th>
                                                <th>MOE</th>
                                                <th>MERIT TYPE</th>
                                                <th>STATUS</th>
                                                <th>DETAILS</th>
                                                <th>ACTION</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                try {
                                                    int i = 1;
                                                    List<Admissions> appl = sess.getAdmissionsByCourseStatus(cos.getId(), sessiond, "ALL", "ALL", "S002", 1002);
                                                    appl.addAll(sess.getAdmissionsByCourseStatus(cos.getId(), sessiond, "ALL", "ALL", "S002", 1004));
                                                    appl.addAll(sess.getAdmissionsByCourseStatus(cos.getId(), sessiond, "ALL", "ALL", "S002", 1005));
                                                    for (Admissions data : appl) {
                                            %>
                                            <tr>
                                                <td><%=i%></td>
                                                <td><%=data.getId().toUpperCase()%></td>
                                                <td><%=data.getSurname()%></td>
                                                <td><%=data.getOthernames()%></td>
                                                <td><%=data.getDateOfBirth()%></td>
                                                <%
                                                    String state = "";
                                                    String lga = "";
                                                    String status = data.getAdmissionStatus();
                                                    String sty = "danger";
                                                    String sty2 = "success";
                                                    String com = "CLEAR";
                                                    if (status.equalsIgnoreCase("CLEARED")) {
                                                        sty = "success";
                                                        sty2 = "warning";
                                                        com = "UNCLEAR";
                                                    }
                                                    try {
                                                        state = data.getStateOfOriginId().getName();
                                                        lga = data.getLgaId().getName();
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                                <td><%=state%></td>
                                                <td><%=lga%></td>
                                                <td><%=data.getModeOfEntry()%></td>
                                                <td><%=data.getMeritType()%></td>
                                                <td><span id="<%=data.getId()%>a" class="alert alert-<%=sty%>"><%=status%></span></td>
                                                <td>
                                                    <button type="button" class="btn btn-primary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#<%=data.getId()%>b">
                                                        View
                                                    </button>

                                                    <div class="modal fade" id="<%=data.getId()%>b" tabindex="-1" aria-labelledby="<%=data.getId()%>bLabel" aria-hidden="true">
                                                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=data.getId()%>bLabel"><%=data.getId().toUpperCase()%>'s Details</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="tab-content rounded-bottom">
                                                                        <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1000">
                                                                            <div class="accordion" id="accordionExample">
                                                                                <div class="accordion-item">
                                                                                    <h2 class="accordion-header" id="headingOne">
                                                                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">Personal Details</button>
                                                                                    </h2>
                                                                                    <div class="accordion-collapse collapse show" id="collapseOne" aria-labelledby="headingOne" data-coreui-parent="#accordionExample" style="">
                                                                                        <div class="accordion-body">
                                                                                            <%
                                                                                                try {
                                                                                            %>
                                                                                            <table class="table table-striped">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <th width="35%">Registration Number</th>
                                                                                                        <td width="40%"><%=data.getId().toUpperCase()%></td>
                                                                                                        <td width="25%" rowspan="4">
                                                                                                            <%
                                                                                                                String imgurl = "assets/img/noperson.png";
                                                                                                                try {
                                                                                                                    Passports pp = sess.getPassports(data.getId());
                                                                                                                    if (pp != null) {
                                                                                                                        File imageFile = new File(settings.documentroot + "/" + pp.getUrl());
                                                                                                                        byte[] imageBytes = Files.readAllBytes(imageFile.toPath());

                                                                                                                        // Encode the byte array to a Base64 string
                                                                                                                        imgurl = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);

                                                                                                                        // Create the HTML <img> tag
                                                                                                                    }

                                                                                                                } catch (Exception hc) {
                                                                                                                }
                                                                                                            %>
                                                                                                            <img src="<%=imgurl%>" style="height: 150px; width: auto" />
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Full Name</th>
                                                                                                        <td><%=data.getSurname().toUpperCase() + " " + data.getOthernames().toUpperCase()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Date of Birth</th>
                                                                                                        <td><%=data.getDateOfBirth()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Gender</th>
                                                                                                        <td><%=data.getGender()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        try {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <th>State of Origin</th>
                                                                                                        <td colspan="2"><%=data.getStateOfOriginId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Local Government</th>
                                                                                                        <td colspan="2"><%=data.getLgaId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        } catch (Exception k) {
                                                                                                        }
                                                                                                    %>
                                                                                                    <%
                                                                                                        String email = "";
                                                                                                        String phone = "";
                                                                                                        try {
                                                                                                            Applicants appx = sess.getApplicants(data.getId());
                                                                                                            if (appx != null) {
                                                                                                                email = appx.getEmailAddress();
                                                                                                                phone = appx.getPhoneNo();
                                                                                                            }
                                                                                                        } catch (Exception k) {
                                                                                                        }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <th>Email Address</th>
                                                                                                        <td colspan="2"><%=email%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Phone Number</th>
                                                                                                        <td colspan="2"><%=phone%></td>
                                                                                                    </tr>


                                                                                                </tbody>
                                                                                            </table>
                                                                                            <%
                                                                                                } catch (Exception k) {
                                                                                                }
                                                                                            %>

                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="accordion-item">
                                                                                    <h2 class="accordion-header" id="headingTwo">
                                                                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Application Details</button>
                                                                                    </h2>
                                                                                    <div class="accordion-collapse collapse" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                                                                        <div class="accordion-body">
                                                                                            <%
                                                                                                try {
                                                                                            %>
                                                                                            <table class="table table-striped">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <th>Course of Study</th>
                                                                                                        <td><%=data.getCourseId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Department</th>
                                                                                                        <td><%=data.getCourseId().getDepartmentId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Programme</th>
                                                                                                        <td><%=data.getCourseId().getSchoolProgrammeId().getProgrammeId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>School</th>
                                                                                                        <td><%=data.getCourseId().getSchoolProgrammeId().getSchoolId().getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <th>Programme Duration</th>
                                                                                                        <td><%=data.getCourseId().getDefaultDuration()%> Semesters</td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <%
                                                                                                } catch (Exception k) {
                                                                                                }
                                                                                            %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <%
                                                                                    List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(data.getId());
                                                                                    if (ldocs.size() > 0) {
                                                                                %>
                                                                                <div class="accordion-item">
                                                                                    <h2 class="accordion-header" id="headingNine">
                                                                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseNine" aria-expanded="false" aria-controls="collapseNine">Documents</button>
                                                                                    </h2>
                                                                                    <div class="accordion-collapse collapse" id="collapseNine" aria-labelledby="headingNine" data-coreui-parent="#accordionExample" style="">
                                                                                        <div class="accordion-body">
                                                                                            <%
                                                                                                try {
                                                                                            %>
                                                                                            <table class="table table-striped">
                                                                                                <thead>
                                                                                                    <tr>
                                                                                                        <th>Document Name</th>
                                                                                                        <th>URL</th>
                                                                                                    </tr>
                                                                                                </thead>
                                                                                                <tbody>
                                                                                                    <%
                                                                                                        for (Uploadeddocuments docd : ldocs) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td><%=docd.getName()%></td>
                                                                                                        <%
                                                                                                            String urld = settings.docUrl + "/" + docd.getUrl();
                                                                                                        %>
                                                                                                        <td> <a href="<%=urld%>" target="_blank" class="btn btn-primary btn-sm float-end"><%=docd.getName()%></a>  </td>
                                                                                                        <%
                                                                                                        %>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        }
                                                                                                    %>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <%
                                                                                                } catch (Exception k) {
                                                                                                }
                                                                                            %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <%
                                                                                    }
                                                                                %>

                                                                                <div class="accordion-item">
                                                                                    <h2 class="accordion-header" id="headingThree">
                                                                                        <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseThree" aria-expanded="true" aria-controls="collapseThree">Payment History</button>
                                                                                    </h2>
                                                                                    <div class="accordion-collapse collapse" id="collapseThree" aria-labelledby="headingThree" data-coreui-parent="#accordionExample" style="">
                                                                                        <div class="accordion-body">
                                                                                            <%
                                                                                                try {
                                                                                            %>
                                                                                            <table class="table table-striped table-hover">
                                                                                                <thead>
                                                                                                <th class="center">SNO</th>
                                                                                                <th>Payment Type</th>
                                                                                                <th>Date Paid</th>
                                                                                                <th>Amount</th>
                                                                                                <th class="right">Download Receipt</th>
                                                                                                </thead>
                                                                                                <tbody>
                                                                                                    <%
                                                                                                        String idx = data.getId();
                                                                                                        Applicants app = sess.getApplicantsById(data.getId());
                                                                                                        if (app != null) {
                                                                                                            Users usx = sess.getUsersByEmail(app.getEmailAddress());
                                                                                                            if (usx != null) {
                                                                                                                idx = usx.getId();
                                                                                                            }
                                                                                                        }

                                                                                                        List<Payments> payments = sess.getPaymentsByRegno(idx);
                                                                                                        int sn = 1;
                                                                                                        for (Payments pay : payments) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="center"><%=sn%></td>
                                                                                                        <td><%=pay.getFeesGroupId().getName()%></td>
                                                                                                        <td><%=settings.formatDate(pay.getDatePaid())%></td>
                                                                                                        <td class="right"><%=settings.formatno.format(pay.getAmount())%></td>
                                                                                                        <td><a href="/DownloadReceipt?id=<%=pay.getId()%>" target="_blank">Download</a></td>
                                                                                                    </tr>
                                                                                                    <%

                                                                                                            sn++;
                                                                                                        }
                                                                                                    %>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <%
                                                                                                } catch (Exception k) {
                                                                                                }
                                                                                            %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </td>
                                                <td>
                                                    <%
                                                        Feesgroup check = sess.getFeesgroupByNameAndSchool(settings.admissionChecking, data.getSchoolId().getId());
                                                        Feesgroup accep = sess.getFeesgroupByNameAndSchool(settings.acceptanceLetter, data.getSchoolId().getId());
                                                        List<Payments> pay1 = sess.getPaymentsByRegnoSessSemFeesgroup(data.getId(), check.getId(), data.getSession(), "Session");
                                                        List<Payments> pay2 = sess.getPaymentsByRegnoSessSemFeesgroup(data.getId(), accep.getId(), data.getSession(), "Session");
                                                        if (pay1.size() > 0 && pay2.size() > 0) {
                                                    %>
                                                    <span id='<%=data.getId()%>c'<a href="#" onclick="event.preventDefault();clearApplicant('<%=data.getId() + "_" + user.getId()%>')" class="btn btn-sm btn-<%=sty2%>"><%=com%></a></span>
                                                        <%
                                                        } else {
                                                        %>

                                                No Checking and/or acceptance<%
                                                    }
                                                %>
                                                </td>
                                            </tr>
                                            <%
                                                        i++;
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>

                                        </tbody>
                                    </table>
                                </div>

                            </div>

                        </div>
                    </div>




                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>
        <!-- Plugins and scripts required by this view-->

        <script src="vendors/jquery/js/jquery.min.js"></script>
        <script src="vendors/datatables.net/js/dataTables.min.js"></script>
        <script src="vendors/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
        <script src="js/datatables.js"></script>

        <script src="js/dataTables.js"></script>
        <script src="js/dataTables.buttons.js"></script>
        <script src="js/buttons.dataTables.js"></script>
        <script src="js/jszip.min.js"></script>
        <script src="js/pdfmake.min.js"></script>
        <script src="js/vfs_fonts.js"></script>
        <script src="js/buttons.html5.min.js"></script>
        <script src="js/buttons.print.min.js"></script>
        <script src="js/jquery-3.7.1.js"></script>


        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>




        <script>

                                                        $(document).ready(function () {
                                                            new DataTable('#dataTable', {
                                                                responsive: true,
                                                                "info": true,
                                                                "pageLength": 25,
                                                                "lengthMenu": [25, 50, 100, 200, 500],
                                                                "dom": 'lBfrtip',
                                                                buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                                                                layout: {
                                                                    topStart: 'buttons'
                                                                }
                                                            });

                                                        });
        </script>
    </body>
</html>