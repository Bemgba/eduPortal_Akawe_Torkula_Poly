<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="java.util.Optional"%>
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

        <title><%=settings.productName%> - School Fees Waiver</title>
    </head>

    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">School Fees Waiver</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">

                        <%                String semester = null;
                            String stdno = null;
                            String comment = null;
                            // byte[] doc = null;
                            FileItem doc = null;
                            String docext = "";
                            String button2 = null;

                            String UPLOAD_DIRECTORY = settings.documentroot + "/docs";

                            String msg = "";
                            String sty = "danger";
                            if (ServletFileUpload.isMultipartContent(request)) {
                                try {
                                    ServletFileUpload upload = new ServletFileUpload(new DiskFileItemFactory());
                                    List<FileItem> formItems = upload.parseRequest(request);
                                    for (FileItem item : formItems) {
                                        if (!item.isFormField()) {
                                            String fileName = new File(item.getName()).getName();
                                            String fieldName = item.getFieldName();
                                            if (fieldName.equalsIgnoreCase("doc")) {
                                                try {
                                                    docext = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                                } catch (Exception d) {
                                                }
                                                doc = item;
                                            }

                                        } else {
                                      
                                            String fieldName = item.getFieldName();
                                            String fieldValue = item.getString();
                                            if (fieldName.equalsIgnoreCase("semester")) {
                                                semester = fieldValue;
                                            }
                                            if (fieldName.equalsIgnoreCase("stdno")) {
                                                stdno = fieldValue;
                                            }
                                            if (fieldName.equalsIgnoreCase("comment")) {
                                                comment = fieldValue;
                                            }
                                            if (fieldName.equalsIgnoreCase("button2")) {
                                                button2 = fieldValue;
                                            }

                                        }
                                    }

                                } catch (Exception ex) {
                                }
                            }
                            if (button2 != null && doc != null && stdno != null && stdno.length() > 0 && semester != null && semester.length() > 0) {
                                stdno = stdno.trim().toLowerCase();
                                Students stdx = sess.getStudentsById(stdno);
                                if (stdx != null) {
                                    Sessionmanager sessman = sess.getCurrentSessionManagerBySchoolAndOperation(stdx.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
                                    if (sessman != null) {
                                        Collection<Studentprogression> prograssion = stdx.getStudentprogressionCollection();
                                        Studentprogression regd = null;
                                        try {
                                            final String sem = semester;
                                            Optional<Studentprogression> rego = prograssion.stream()
                                                    .filter(person -> person.getSessionAdded().equals(sessman.getName())
                                                    && person.getSemesterAdded().equals(sem))
                                                    .findFirst();
                                            regd = rego.get();
                                        } catch (Exception k) {
                                        }
                                        if (regd != null) {
                                            Feesgroup fg = sess.getSchoolFeesId(stdx.getCourseId().getSchoolProgrammeId().getSchoolId().getId());
                                            if (fg != null) {
                                                List<Payments> payl = sess.getPaymentsByRegnoSessSemFeesgroup(stdx.getId(), fg.getId(), sessman.getName(), semester);
                                                if (payl.size() > 0) {
                        %>
                        <div class="alert alert-danger">Student already has payment record for this session and semester. No need for further waiver</div>
                        <%
                        } else {
                            String id = settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14);

                            File uploadDir = new File(UPLOAD_DIRECTORY);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdir();
                            }
                            String filePath = UPLOAD_DIRECTORY + File.separator + id + docext;
                            File storeFile = new File(filePath);
                            doc.write(storeFile); // Save file to disk

                            String url = "docs/" + id + docext;

                            Feeswaiver fw = new Feeswaiver(id);
                            fw.setAddedBy(user);
                            fw.setDateAdded(settings.getCurrentDateTime());
                            fw.setDocUrl(url);
                            fw.setNote(comment);
                            fw.setSemesterAdded(semester);
                            fw.setSessionAdded(sessman.getName());
                            fw.setStudentId(stdx);
                            sess.newEntry(fw);

Payments pay = sess.getPayments(id);
        if (pay == null) {
            try {
                pay = new Payments(id);
                pay.setAmount(0);
                pay.setDatePaid(settings.getCurrentDateTime());
                pay.setPayerId(stdx.getId());
                pay.setPayerRegistrationNo(stdx.getRegistrationNo());
                pay.setPayerFullname(stdx.getSurname() + " " + stdx.getOthernames());
                pay.setSessionPaid(sessman.getName());
                pay.setSemesterPaid(semester);
                Courses co = null;
                Programmes prog = null;
                Schools sch = null;
                Banks bank = null;
                try {
                    co = stdx.getCourseId();
                    if (co != null) {
                        prog = co.getSchoolProgrammeId().getProgrammeId();
                        sch = co.getSchoolProgrammeId().getSchoolId();
                    }
                    bank = (Banks) sess.getSingleObject(Banks.class, "Nil");
                } catch (Exception k) {
                }
                pay.setCourseId(co);
                pay.setFeesGroupId(fg);
                pay.setProgrammeId(prog);
                pay.setSchoolId(sch);
                pay.setLevel(regd.getLevelAdded());
                pay.setBankId(bank);

                sess.newEntry(pay);
}catch(Exception j){}

}
                        %>
                        <div class="alert alert-success">Student has been added to fees waiver for the current session and selected semester</div>
                        <%
                                }
                            }
                        } else {
                        %>
                        <div class="alert alert-danger">Student is not on current session progression</div>
                        <%
                                }
                            }
                        } else {
                        %>
                        <div class="alert alert-danger">Student with number <%=stdno%> does not exist</div>
                        <%
                                }
                            }

                        %>

                        <div class="card mb-4">
                            <div class="card-header"><strong>This module allows for allowing students to register for courses with out making school fees payments. It is used for issues like scholarships etc.</strong>
                                <p>We will only process in the current session of the student. You are required to add for subsequent years if the student has a perpetual waiver</p></div>
                            <div class="card-body">

                                <button type="button" class="btn btn-success btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#newapp">
                                    Add New
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="newapp" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Add New Fees Waiver</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">


                                                <div class="alert alert-info">Kindly enter student and waiver details with supporting document to proceed</div>
                                                <form name="edit" method="post" action="" enctype="multipart/form-data">
                                                    <div class="input-group mb-3"><span class="input-group-text">
                                                            Select Semester   
                                                        </span>

                                                        <select class="form-select" name="semester" id="semester">
                                                            <option value="">Select One</option>
                                                            <option value="First">First</option>
                                                            <option value="Second">Second</option>
                                                        </select>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Enter Student Number 
                                                        </span>
                                                        <input type="text" class="form-control" name="stdno" minlength="3" required=""/>
                                                    </div>
                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Enter Waiving Comment 
                                                        </span>
                                                        <input type="text" class="form-control" name="comment" minlength="3" required=""/>
                                                    </div>


                                                    <div class="input-group mb-4"><span class="input-group-text">
                                                            Supporting Document 
                                                        </span>
                                                        <input type="file" name="doc" class="form-control" required=""/>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-6">
                                                            <input type="submit" name="button2" class="btn btn-success px-4" value="Add Now"/>
                                                        </div>
                                                    </div>

                                                </form>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-body">
                                <form name="view" method="post" action="">
                                    <div class="input-group mb-3"><span class="input-group-text">
                                            Select Session   
                                        </span>

                                        <select name="sessions" class="form-select">
                                            <option value="">Select One</option>

                                            <%                                                List<Sessionmanager> sml = sess.getAllSessionmanager("S001", "REGISTRATION", "First");
                                                for (Sessionmanager smd : sml) {
                                            %>
                                            <option value="<%=smd.getName()%>"><%=smd.getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>


                                    <div class="row">
                                        <div class="col-6">
                                            <input type="submit" name="button" class="btn btn-success px-4" value="View Records"/>
                                        </div>
                                    </div>

                                </form>
                                <%
                                    String sessions = request.getParameter("sessions");
                                    if (sessions != null && sessions.length() > 0) {


                                %>
                                <div class="alert alert-info">
                                    School fees waivers for the <%=sessions%> Academic session
                                </div>
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>Registration No</th>
                                                <th>Full Name</th>
                                                <th>Course</th>
                                                <th>Level</th>
                                                <th>Semester</th>
                                                <th>Note</th>
                                                <th>Document</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                List<Feeswaiver> ldata = sess.getFeeswaiverBySession(sessions);
                                                for (Feeswaiver data : ldata) {
                                                    Students st = data.getStudentId();
                                                    if (st != null) {
                                                        String rno = st.getMatricNo() != null ? st.getMatricNo() : st.getRegistrationNo();
                                                        String level = "";
                                                        Collection<Studentprogression> prograssion = st.getStudentprogressionCollection();
                                                        Studentprogression regd = null;
                                                        try {
                                                            final String sem = semester;
                                                            Optional<Studentprogression> rego = prograssion.stream()
                                                                    .filter(person -> person.getSessionAdded().equals(data.getSessionAdded())
                                                                    && person.getSemesterAdded().equals(data.getSemesterAdded()))
                                                                    .findFirst();
                                                            regd = rego.get();
                                                            level = regd.getLevelAdded();
                                                        } catch (Exception k) {
                                                        }

                                                        String urld = settings.docUrl + "/" + data.getDocUrl();
                                            %>
                                            <tr>
                                                <td class="center"><%=i%></td>
                                                <td><%=rno.toUpperCase()%></td>
                                                <td><%=st.getSurname() + " " + st.getOthernames()%></td>
                                                <td><%=st.getCourseId().getName()%></td>
                                                <td><%=level%></td>
                                                <td><%=data.getSemesterAdded()%></td>
                                                <td><%=data.getNote()%></td>
                                                <td><a href="<%=urld%>" target="_blank" class="btn btn-primary btn-sm float-end">Document</a> </td>
                                            </tr>
                                            <%
                                                        i++;
                                                    }
                                                }
                                            %>


                                        </tbody>
                                    </table>
                                </div>
                                <%
                                    }
                                %>

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