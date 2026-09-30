<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - DE Applicants</title>
        <script>
        function checkStatus(fileId) {
            fetch(`/status?fileId=${fileId}`)
                .then(response => response.json())
                .then(data => {
                    document.getElementById("status").innerText = `File ID: ${data.fileId}, Status: ${data.status}`;
                    if (data.status === "Processing") {
                        setTimeout(() => checkStatus(fileId), 2000); // Poll every 2 seconds
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    </script>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">DE Applicants</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>This page allows you to export the DE applicants list directly from the JAMB CAPS platform into the University portal.</p>
                                        <p>You are expected to save the file as a .xls (Microsoft Excel 97-2003 workbook) format</p>
                                        <p>Verify that the file complies with the original format as can be seen from this template <a href="templates/applicants_list_de.xls">Download now</a></p>
                                        <p>Also remember to verify with the report that is generated after the file upload for entries that are successful and those that are not</p>
                                        <%                                        Sessionmanager sessmanx = sess.getCurrentSessionManagerBySchoolAndOperation("S001", "APPLICATION");
                                            if (sessmanx != null) {
                                        %>
                                        <p>Applicants will be uploaded against the <strong><%=sessmanx.getName()%></strong> academic session. Note that only current session for application can be treated.</p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                            </div>
                            <div class="card-body">

                                <div class="example">
                                    <div id="status"></div>
                                    <%
                                        String msg2 = request.getParameter("msg2");
                                        if (msg2 != null && msg2.length() > 0) {
                                    %>
                                    <div class="alert alert-success"><%=msg2%></div>
                                    <%
                                        }
                                    %>
                                    <form action='UploadDEApplicants?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Applicants File</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list" type="file" name="list" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="example">
                                    <form action='UploadUTMEPassports?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify2" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select Passports Folder</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list2" type="file" name="list2" required="" multiple="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit2" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="example">
                                    <%
                                        String msg = request.getParameter("msg");
                                        if (msg != null && msg.length() > 0) {
                                    %>
                                    <div class="alert alert-success"><%=msg%></div>
                                    <%
                                        }
                                    %>
                                    <form action='UploadUTMEOLevel?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>' method='post' name="verify3" enctype="multipart/form-data">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Select O-level Folder</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="list3" type="file" name="list3" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit3" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (sessmanx != null) {
                            Long size = sess.countApplicantsBySessionAndType(sessmanx.getName(), "DE");
                            Long si = size / 2000;
                            int index = 0;
                            try {
                                String h = request.getParameter("index");
                                if (h != null) {
                                    index = Integer.parseInt(h);
                                }
                            } catch (Exception k) {
                            }

                            List<Object[]> appl = sess.getApplicantsBySessionAndType(sessmanx.getName(), "DE", 2000, index);
                            //if (appl.size() == 0) {
                            if (sessmanx == null) {
                    %>
                    <div class='alert alert-warning'>No DE applicant found for <strong><%=sessmanx.getName()%></strong> application session</div>
                    <%
                    } else {

                    %>
                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong><%=appl.size()%></strong> records on page <%=index + 1%> from <%=size%>  DE applicants found for <strong><%=sessmanx.getName()%></strong> application session
                                <p class="float-end">
                                    <%                                for (int ind = 0; ind <= si; ind++) {
                                            int x = ind * 2000;
                                            String styl = "warning";
                                            if (index == x) {
                                                styl = "secondary";
                                            }
                                    %>
                                    <a class="btn btn-<%=styl%> btn-sm" href="/app_de_adm_upload?index=<%=x%>">Page <%=ind + 1%></a> &nbsp;
                                    <%
                                        }
                                    %>
                                </p>
                            </div>

                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>DE No</th>
                                                <th>Full Name</th>
                                                <th>Course</th>
                                                <th>Gender</th>
                                                <th>State</th>
                                                <th class="center">More</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (Object[] pay : appl) {

                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=pay[0].toString().toUpperCase()%></td>
                                                <td><%=pay[1] + " " + pay[2]%></td>
                                                <td><%=pay[3]%></td>
                                                <td><%=pay[4]%></td>
                                                <td><%=pay[5]%></td>
                                                <td class="center"><a class="btn btn-primary btn-sm" href="/app_de_adm_upload?id=<%=settings.encodeUrl(settings.encryptText(pay[0].toString()))%>">View</a></td>
                                            </tr>
                                            <%
                                                    i++;
                                                }
                                            %>


                                        </tbody>
                                    </table>
                                </div>

                            </div>
                        </div>
                    </div>


                    <%
                            }
                        }
                    %>


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
         <script>
        // Extract fileId from the response after form submission
        document.querySelector("form").addEventListener("submit", function(event) {
            event.preventDefault();

            const formData = new FormData(event.target);
            fetch(event.target.action, {
                method: "POST",
                body: formData
            })
                .then(response => response.text())
                .then(responseText => {
                    const fileId = responseText.split(":")[1].trim(); // Extract fileId
                    document.getElementById("status").innerText = "File uploaded. Checking status...";
                    checkStatus(fileId);
                });
        });
    </script>
        
    </body>
</html>