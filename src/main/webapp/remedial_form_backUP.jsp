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
    Applicants genapp = null;
    try {
        genapp = (Applicants) session.getAttribute("app");
    } catch (Exception x) {
    }
    if (genapp == null) {
        response.sendRedirect("/remedialApplication");
    }

%>

<%    String id2 = request.getParameter("id2");
    if (id2 != null && id2.length() > 0) {
        id2 = settings.decryptText(id2);
        Schoolsattended dd = (Schoolsattended) sess.getSingleObject(Schoolsattended.class, id2);
        if (dd != null) {
            sess.deleteObject("Schoolsattended", dd.getId());
        }
    }

    String id3 = request.getParameter("id3");
    if (id3 != null && id3.length() > 0) {
        id3 = settings.decryptText(id3);
        Applicantsreferees dd = (Applicantsreferees) sess.getSingleObject(Applicantsreferees.class, id3);
        if (dd != null) {
            sess.deleteObject("Applicantsreferees", dd.getId());
        }
    }

    String id4 = request.getParameter("id4");
    if (id4 != null && id4.length() > 0) {
        id4 = settings.decryptText(id4);
        Uploadeddocuments dd = (Uploadeddocuments) sess.getSingleObject(Uploadeddocuments.class, id4);
        if (dd != null) {
            try {
                String fpath = settings.documentroot + "/" + dd.getUrl();
                File storeFile = new File(fpath);
                if (storeFile.exists()) {
                    storeFile.delete();
                }
            } catch (Exception h) {
            }
            sess.deleteObject("Uploadeddocuments", dd.getId());
        }
    }


%>

<%     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    List<Schoolsattended> lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
    List<Applicantsreferees> lref = sess.getApplicantsrefereesByRegno(genapp.getId());
    List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Remedial Application</title>

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
                <%@include file="WEB-INF/jspf/header_applicant_gen.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Remedial Application</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <%     if (std != null) {

                            List<Payments> payl = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                            if (payl.size() > 0) {
                                if (genapp.getStatus().equals("PENDING")) {
                                    genapp.setStatus("PAID");
                                    sess.updateRecord(genapp);
                                }
                            }

                    %>

                    <div class="card mb-4">

                        <div class="card-header">
                            Welcome <%=std.getSurname() + ", " + std.getOthernames()%>
                            <a href="/gen_app_dashboard" class="btn btn-danger btn-sm float-end">Back</a>
                            <button type="button" class="btn btn-primary btn-sm float-end" data-coreui-toggle="modal" data-coreui-target="#sessions">
                                View Bio-Data
                            </button>

                            <div class="modal fade" id="sessions" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">Bio-Data</h5>
                                            <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="table-responsive-sm">
                                                <table class="table table-striped">
                                                    <tbody>
                                                        <tr>
                                                            <td>Email Address</td>
                                                            <td><%=genapp.getEmailAddress()%></td>
                                                            <td rowspan="5">
                                                                <%
                                                                    String imgurl = "assets/img/noperson.png";
                                                                    try {
                                                                        Passports pp = sess.getPassports(std.getId());
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
                                                            <th>Surname</th>
                                                            <td><%=std.getSurname()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Other Names</th>
                                                            <td><%=std.getOthernames()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Gender</th>
                                                            <td><%=std.getGender()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Date of Birth </th>
                                                            <td><%=std.getDateOfBirth()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Phone Number</th>
                                                            <td colspan="2"><%=std.getPhoneno()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Contact Address</th>
                                                            <td colspan="2"><%=std.getContactAddress()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Home Town </th>
                                                            <td colspan="2"><%=std.getHomeTown()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Country</th>
                                                            <td colspan="2"><%=std.getNationality().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>State of Origin </th>
                                                            <td colspan="2"><%=std.getState().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Local Government Area </th>
                                                            <td colspan="2"><%=std.getLga().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="3">Application Details</th>
                                                        </tr>
                                                        <tr>
                                                            <th>Session</th>
                                                            <td colspan="2"><%=genapp.getSession()%></td>
                                                        </tr>

                                                        <tr>
                                                            <th>Application Number</th>
                                                            <td colspan="2"><%=genapp.getId()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Course of Study</th>
                                                            <td colspan="2"><%=genapp.getCourse1().getName()%></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Faculty</th>
                                                            <td colspan="2"><%=genapp.getCourse1().getDepartmentId().getFacultyId().getName()%></td>
                                                        </tr>


                                                    </tbody>
                                                </table>
                                            </div>



                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>



                        </div>



                        <div class="card-body">

                            <%
                                String instname = request.getParameter("instname");
                                String inststartdate = request.getParameter("inststartdate");
                                String instenddate = request.getParameter("instenddate");
                                String instcertyear = request.getParameter("instcertyear");
                                String instresults = request.getParameter("instresults");
                                String instregno = request.getParameter("instregno");
                                String button4a = request.getParameter("button4a");
                                if (instname != null && instname.length() > 0 && button4a != null && button4a.length() > 0) {
                                    try {
                                        String sdate = inststartdate + " 00:00:00";
                                        String edate = instenddate + " 23:59:59";

                                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                                        // Define final variables
                                        final Date sdated = dateFormat.parse(sdate);
                                        final Date edated = dateFormat.parse(edate);

                                        // Filter using final variables
                                        List<Schoolsattended> contains = lschatt.stream()
                                                .filter(data -> data.getName().equalsIgnoreCase(instname)
                                                && data.getStartDate().compareTo(sdated) == 0)
                                                .collect(Collectors.toList());
                                        if (!contains.isEmpty()) {
                            %>
                            <div class="alert alert-danger">This institution has already been added</div>
                            <%
                            } else {
                                String id = genapp.getId() + settings.generateId("", 4);
                                Schoolsattended scha = new Schoolsattended(id);
                                scha.setEndDate(edated);
                                scha.setName(instname);
                                scha.setQualification(instresults);
                                scha.setRegNo(instregno);
                                scha.setStartDate(sdated);
                                scha.setYearOfAward(Integer.valueOf(instcertyear));
                                scha.setAppId(genapp.getId());
                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }

                                        lschatt = sess.getSchoolsattendedByRegno(genapp.getId());
                                    } catch (Exception ks) {
                                    }
                                }
                            %>




                            <%  String docname = null;
                                String file2 = null;
                                String submit4d = null;
                                byte[] fileedit = null;
                                String url = null;
                                String ext = "";
                                String id = genapp.getId() + settings.generateId("", 4);

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
                                                if (fieldName.equalsIgnoreCase("file2")) {
                                                    try {
                                                        ext = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                                    } catch (Exception d) {
                                                    }
                                                    fileedit = item.get();

                                                    try {
                                                        if (!ext.matches("\\.(pdf|jpg|png|docx?)")) {

                                                        } else {

                                                            File uploadDir = new File(UPLOAD_DIRECTORY);
                                                            if (!uploadDir.exists()) {
                                                                uploadDir.mkdir();
                                                            }

                                                            String filePath = UPLOAD_DIRECTORY + File.separator + id + ext;
                                                            File storeFile = new File(filePath);
                                                            item.write(storeFile); // Save file to disk

                                                            url = "docs/" + id + ext;
                                                        }
                                                    } catch (Exception xs) {
                                                    }
                                                }

                                            } else {
                                                String fieldName = item.getFieldName();
                                                String fieldValue = item.getString();

                                                if (fieldName.equalsIgnoreCase("docname")) {
                                                    docname = fieldValue;
                                                }
                                                if (fieldName.equalsIgnoreCase("submit4d")) {
                                                    submit4d = fieldValue;
                                                }
                                            }
                                        }

                                    } catch (Exception ex) {
                                    }
                                }

                                if (submit4d != null && fileedit != null && docname != null && docname.length() > 0) {
                                    final String finalDocName = docname.trim();
                                    try {
                                        // Check if document already exists
                                        boolean exists = ldocs.stream()
                                                .anyMatch(data -> data.getName().equalsIgnoreCase(finalDocName));

                                        if (exists) {
                            %>
                            <div class="alert alert-danger">This Document has already been added</div>
                            <%
                            } else {
                                // Create new document entry
                                Uploadeddocuments scha = new Uploadeddocuments(id);
                                scha.setDateAdded(settings.getCurrentDateTime());
                                scha.setGroupId(genapp.getId());
                                scha.setName(docname);
                                scha.setUploadedBy(user.getId());
                                scha.setUrl(url);

                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }
                                        // Refresh list
                                        ldocs = sess.getUploadeddocumentsByRegno(genapp.getId());

                                    } catch (Exception k) {
                                    }

                                }

                            %>

                            <%                                Olevelresults result = new Olevelresults();
                                String idu = settings.generateId("", 10);
                                result.setId(idu);
                                String name = request.getParameter("name");
                                String regnou = request.getParameter("registrationNo");
                                String sitting = request.getParameter("sitting");
                                String examDate = request.getParameter("examDate");
                                result.setName(name);
                                String resultType = request.getParameter("resultType");
                                result.setResultType(resultType);
                                result.setRegistrationNo(regnou);
                                result.setUserId(genapp.getId());
                                result.setExamDate(examDate);
                                result.setSitting(sitting);
                                result.setDateAdded(settings.getCurrentDateTime());
                                result.setVerificationStatus("Pending");
                                if (name != null && resultType != null && examDate != null && sitting != null) {
                                    sess.newEntry(result);
                                }

                                // Children (all submitted subjects/grades)
                                String[] subjectIds = request.getParameterValues("subject[]");
                                String[] gradeIds = request.getParameterValues("grade[]");

                                if (subjectIds != null && gradeIds != null) {
                                    for (int i = 0; i < subjectIds.length; i++) {
                                        String subjId = subjectIds[i];
                                        String gradeId = gradeIds[i];

                                        if (subjId != null && gradeId != null) {
                                            Olevelsubjects subjEntity = (Olevelsubjects) sess.getSingleObject(Olevelsubjects.class, subjId);
                                            Olevelgrades gradeEntity = (Olevelgrades) sess.getSingleObject(Olevelgrades.class, gradeId);

                                            Olevelresultsitems item = new Olevelresultsitems();
                                            String olid = settings.generateId(idu, 4);
                                            item.setId(olid);
                                            item.setOlevelResultsId(result);

                                            // Save subject name string instead of entity
                                            if (subjEntity != null) {
                                                item.setSubject(subjEntity.getName());
                                            } else {
                                                item.setSubject(subjId); // fallback
                                            }

                                            item.setGrade(gradeEntity);
                                            item.setDateAdded(new Date());
                                            item.setVerificationStatus("Pending");

                                            sess.newEntry(item);
                                        }
                                    }
                                }

                                String utmeno = request.getParameter("utmeno");
                                String engsc = request.getParameter("engsc");
                                String subj2 = request.getParameter("subj2");
                                String subj2sc = request.getParameter("subj2sc");
                                String subj3 = request.getParameter("subj3");
                                String subj3sc = request.getParameter("subj3sc");
                                String subj4 = request.getParameter("subj4");
                                String subj4sc = request.getParameter("subj4sc");
                                String button4k = request.getParameter("button4k");

                                List<Olevelgrades> gradesList = sess.getAllOlevelgrades();
                                List<Olevelsubjects> subjectsList = sess.getAllOlevelsubjects("ACTIVE");
                                System.out.println("ssssss " + subjectsList.size());

                                String training = request.getParameter("training");
                                String empstatus = request.getParameter("empstatus");
                                String fieldstudy = request.getParameter("fieldstudy");
                                String research = request.getParameter("research");
                                String guardianname = request.getParameter("guardianname");
                                String guardianadd = request.getParameter("guardianadd");
                                String quali = request.getParameter("quali");
                                String maritalstatus = request.getParameter("maritalstatus");
                                if (button4k != null && button4k.length() > 0 && utmeno != null) {
                                    try {

                                        try {

                                        } catch (Exception ex) {
                                            ex.printStackTrace();
                                        }

                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%                                    } catch (Exception v) {
                                    }
                                }
                            %>


                            <%
                                String attestationbox = request.getParameter("attestationbox");
                                String submit6 = request.getParameter("submit6");
                                if (submit6 != null && submit6.length() > 0) {
                                    if (attestationbox != null) {
                                        try {
                                            sess.completeApplicantStatus(genapp.getId());
                                            genapp = sess.getApplicants(genapp.getId());
                            %>
                            <div class="alert alert-success">Congratulations!, Your application has been completed successfully. You will be notified via email on next action and application progress</div>
                            <%
                                        } catch (Exception k) {
                                        }
                                    }
                                }
                            %>
                            <strong>Your application status is <%=genapp.getStatus()%></strong>

                            <%                                if (genapp.getStatus().equalsIgnoreCase("NOT COMPLETED")) {
                                    //List<Payments> payutme = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                                    //if (payutme.size() > 0) {
                                    int i = 1;
                                    if (i == 1) {
                            %>


                            <div class="accordion" id="accordionExample">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOne">
                                        <button class="accordion-button collapsed" type="button" 
                                                data-coreui-toggle="collapse" data-coreui-target="#collapseOne" 
                                                aria-expanded="true" aria-controls="collapseOne">
                                            Additional Details
                                        </button>
                                    </h2>
                                    <div class="accordion-collapse collapse show" id="collapseOne" 
                                         aria-labelledby="headingOne" data-coreui-parent="#accordionExample">
                                        <div class="accordion-body">

                                            <div class="form-container">
                                                <h2>Enter O-Level Result</h2>
                                                <form method="post" action="">

                                                    <!-- Hidden applicant ID -->
                                                    <input type="hidden" name="userId" value="<%= genapp.getId()%>" />

                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Name</span>
                                                        <input type="text" class="form-control" id="name" name="name" required />
                                                    </div>

                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Result Type</span>
                                                        <select id="resultType" name="resultType" class="form-select" required>
                                                            <option value="">-- Select Result Type --</option>
                                                            <option value="waec">WAEC</option>
                                                            <option value="neco">NECO</option>
                                                            <option value="nabteb">NABTEB</option>
                                                            <option value="gce">GCE</option>
                                                        </select>
                                                    </div>

                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Registration No</span>
                                                        <input type="text" class="form-control" id="registrationNo" name="registrationNo" />
                                                    </div>

                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Exam Date</span>
                                                        <input type="date" class="form-control" id="examDate" name="examDate" required />
                                                    </div>

                                                    <div class="input-group mb-3">
                                                        <span class="input-group-text">Sitting</span>
                                                        <select id="sitting" name="sitting" class="form-select" required>
                                                            <option value="First">First</option>
                                                            <option value="Second">Second</option>
                                                        </select>
                                                    </div>

                                                    <h4>Subjects & Grades</h4>
                                                    <table id="subjectTable" class="table">
                                                        <thead>
                                                            <tr>
                                                                <th>Subject</th>
                                                                <th>Grade</th>
                                                                <th>Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <select name="subject[]" class="form-select" required>
                                                                        <% if (subjectsList != null) {
                                                            for (Olevelsubjects subj : subjectsList) {%>
                                                                        <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                                                                        <% }
                                                        } %>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <select name="grade[]" class="form-select" required>
                                                                        <% if (gradesList != null) {
                                                            for (Olevelgrades g : gradesList) {%>
                                                                        <option value="<%=g.getId()%>"><%=g.getId()%></option>
                                                                        <% }
                                                        } %>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <button type="button" class="btn btn-danger btn-sm removeRow">Remove</button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>

                                                    <button type="button" id="addRow" class="btn btn-primary">Add Subject</button>

                                                    <script>
                                                        document.addEventListener("DOMContentLoaded", function () {
                                                            const tableBody = document.querySelector("#subjectTable tbody");
                                                            const addBtn = document.getElementById("addRow");

                                                            // Function to reindex all rows
                                                            function reindexRows() {
                                                                const rows = tableBody.querySelectorAll("tr");
                                                                rows.forEach((row, rowIndex) => {
                                                                    const subjectSelect = row.querySelector("select[name^='subject']");
                                                                    const gradeSelect = row.querySelector("select[name^='grade']");
                                                                    if (subjectSelect)
                                                                        subjectSelect.name = `subject[${rowIndex}]`;
                                                                    if (gradeSelect)
                                                                        gradeSelect.name = `grade[${rowIndex}]`;
                                                                });
                                                            }

                                                            // Function to create a new row
                                                            function createRow() {
                                                                const newRow = document.createElement("tr");
                                                                newRow.innerHTML = `
                 <td>
                     <select name="subject[]" class="form-select" required>
                                                        <% if (subjectsList != null) {
                                 for (Olevelsubjects subj : subjectsList) {%>
                             <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                                                        <% }
                             } %>
                     </select>
                 </td>
                 <td>
                     <select name="grade[]" class="form-select" required>
                                                        <% if (gradesList != null) {
                                 for (Olevelgrades g : gradesList) {%>
                             <option value="<%=g.getId()%>"><%=g.getId()%></option>
                                                        <% }
                             }%>
                     </select>
                 </td>
                 <td>
                     <button type="button" class="btn btn-danger btn-sm removeRow">Remove</button>
                 </td>
             `;
                                                                return newRow;
                                                            }

                                                            // Add new subject row
                                                            addBtn.addEventListener("click", function () {
                                                                const newRow = createRow();
                                                                tableBody.appendChild(newRow);
                                                                reindexRows();
                                                            });

                                                            // Remove subject row (event delegation)
                                                            tableBody.addEventListener("click", function (e) {
                                                                if (e.target.classList.contains("removeRow")) {
                                                                    e.target.closest("tr").remove();
                                                                    reindexRows();
                                                                }
                                                            });

                                                            // Initial reindex on page load
                                                            reindexRows();
                                                        });
                                                    </script>


                                                    <br/><br/>
                                                    <input type="submit" class="btn btn-primary px-4"  value="Submit"/>
                                                </form>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingTwo">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Supporting Documents (<%=ldocs.size()%> added)</button>
                                    </h2>
                                    <div class="accordion-collapse collapse" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <form action='' method='post' name="uploaddocs" enctype="multipart/form-data">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                        <div class="mb-3 row">
                                                            <label class="col-sm-3 col-form-label" for="payerno">Document Name</label>
                                                            <div class="col-sm-4">
                                                                <input class="form-control" name="docname" type="text" required="">
                                                            </div>
                                                            <div class="col-sm-3">
                                                                <input class="form-control" type="file"  accept=".pdf, .png, .jpg" name="file2" required="">
                                                            </div>
                                                            <div class="col-sm-2">

                                                                <button name="submit4d" class="btn btn-primary mb-3" type="submit">Upload</button>                       
                                                            </div></div>
                                                    </div>
                                                </div>
                                            </form>

                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Doc. Name</th>
                                                        <th>Preview</th>
                                                        <th>Remove</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (Uploadeddocuments data : ldocs) {
                                                    %>
                                                    <tr>
                                                        <td><%=data.getName()%></td>
                                                        <td>
                                                            <div class="col-sm-2">
                                                                <a href="#" 
                                                                   class="btn btn-secondary mb-3"
                                                                   data-coreui-toggle="modal" 
                                                                   data-coreui-target="#details" 
                                                                   onclick="loadDocument('<%=data.getId()%>')" 
                                                                   >
                                                                    Preview
                                                                </a>

                                                                <div class="modal fade" id="details" tabindex="-1" aria-labelledby="detailslab" aria-hidden="true">
                                                                    <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <h5 class="modal-title" id="detailslab"><%=data.getName()%></h5>
                                                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                            </div>
                                                                            <div class="modal-body">

                                                                                <div id="det">Loading...</div>
                                                                            </div>
                                                                            <div class="modal-footer">
                                                                                <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                        </td>
                                                        <td><a href="/application_pg1?id4=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>

                                                </tbody>
                                            </table>

                                        </div>
                                    </div>
                                </div> 

                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingFive">
                                        <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseFive" aria-expanded="true" aria-controls="collapseThree">Confirm and Submit</button>
                                    </h2>
                                    <div class="accordion-collapse collapse show" id="collapseFive" aria-labelledby="headingFive" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <div class="alert alert-warning">
                                                Note that by confirming your application, you are agreeing that you have gone through your application and have satisfied that every needed information is provided correctly. 
                                                Any modification after this action will not be permitted.
                                                <p>However, this action marks the completion of your application process and it is after this that your application will be received by the school for processing.</p>
                                            </div>
                                            <form action='' method='post' name="attestation">
                                                <div class="tab-content rounded-bottom">
                                                    <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                        <div class="mb-3 row">
                                                            <div class="col-sm-1">
                                                                <input class="form-check-input" name="attestationbox" type="checkbox"  required="">
                                                            </div>
                                                            <label class="col-sm-9 form-check-label" for="attestationbox"><strong>Declaration:</strong> I <%=std.getSurname() + " " + std.getOthernames()%>, hereby declare that the information stated above is to the best of my knowledge and belief, accurate in every detail.</label>

                                                            <div class="col-sm-2">

                                                                <button name="submit6"  value="Submit" class="btn btn-primary mb-3" type="submit">Submit</button>                       
                                                            </div></div>
                                                    </div>
                                                </div>
                                            </form>



                                        </div>
                                    </div>
                                </div>
                            </div>






                            <%
                            } else {
                                String payid = "10004";

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
                                        coursename = genapp.getCourse1().getName();

                                        sch = genapp.getCourse1().getSchoolProgrammeId().getSchoolId().getId();
                                        prog = genapp.getCourse1().getSchoolProgrammeId().getProgrammeId().getId() + "";
                                        fac = genapp.getCourse1().getDepartmentId().getFacultyId().getId();
                                        dept = genapp.getCourse1().getDepartmentId().getId();
                                        course = genapp.getCourse1().getId();
                                        feessetup = sess.getFeessetup(payid, genapp.getSession(), "Session", sch, prog, fac, dept,
                                                course, level, ind, campus, dfrom, std.getId());
                                        if (feessetup.size() > 0) {
                                            String fgx = feessetup.get(0).getFeesGroupId().getRepeatPayment();
                                            boolean exist = false;
                                            if (fgx.equalsIgnoreCase("No")) {
                                                List<Payments> payl2 = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), payid, genapp.getSession(), "Session");
                                                if (payl2.size() > 0) {
                                                    exist = true;
                                                }

                                            }
                                            if (exist) {

                                            } else {
                                                String email = genapp.getEmailAddress();
                                                double total = feessetup.stream()
                                                        .mapToDouble(Feessetup::getAmount)
                                                        .sum();
                                                session.setAttribute("FEESSETUP", feessetup);
                                                session.setAttribute("level", level);
                                                session.setAttribute("sessions", genapp.getSession());
                                                session.setAttribute("feesgroup", payid);
                                                session.setAttribute("sesssem", "Session");
                                                session.setAttribute("regno", regno);
                                                session.setAttribute("fullname", fullname);
                                                session.setAttribute("coursename", coursename);
                                                session.setAttribute("phoneno", genapp.getPhoneNo());
                                                session.setAttribute("email", email);
                                                session.setAttribute("id", std.getId());

                                                Feesgroup feesGroupId = feessetup.get(0).getFeesGroupId();
                                                Schools schoolId = genapp.getCourse1().getSchoolProgrammeId().getSchoolId();
                                                Paymentreference pr = new Paymentreference(settings.generateId(settings.getTodaysdate().replaceAll("-", ""), 14),
                                                        total, std.getId(), settings.getCurrentDateTime(), "PENDING", null, genapp.getSession(), "Session", "", "", "", "", fullname,
                                                        genapp.getPhoneNo(), email, "", feesGroupId, schoolId);
                                                pr.setPayerRegistrationIo(regno);
                                                pr.setCourseId(genapp.getCourse1().getId());
                                                pr.setLevel(level);
                                                sess.newEntry(pr);
                                                try {
                                                    session.setAttribute("pr", pr);

                                                } catch (Exception k) {
                                                }
                                                String returnurl = "/application_pg1";
                                                returnurl = settings.encodeUrl(settings.encryptText(returnurl));
                                                try {
                                                    session.setAttribute("return", returnurl);
                                                } catch (Exception k) {
                                                }
                            %>
                            <a href="/invoice?return=<%=returnurl%>" class="btn btn-success btn-lg" style="margin-bottom: 10px">Pay PG Application and Continue</a>
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
                                if (genapp.getStatus().equalsIgnoreCase("COMPLETED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your application has been received. You will be notified via email and on this platform for the next action.</p>
                                <p>Download Documents:
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-warning btn-sm float-end">Application Form</a>
                                </p>
                            </div>
                            <%
                                }
                                if (genapp.getStatus().equalsIgnoreCase("ADMITTED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your application has been processed successfully, Kindly download your admission letter from the list of documents, follow the instruction of it to complete your admission process</p>
                                <p>Download Documents:
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-warning btn-sm float-end">Application Form</a>
                                    <%
                                        try {
                                            List<Uploadeddocuments> uploads = sess.getUploadeddocumentsByRegno(genapp.getId());
                                            for (Uploadeddocuments data : uploads) {
                                                String urld = settings.docUrl + "/" + data.getUrl();
                                    %>
                                    <a href="<%=urld%>" target="_blank" class="btn btn-primary btn-sm float-end"><%=data.getName()%></a>
                                    <%
                                            }
                                        } catch (Exception n) {
                                        }
                                    %>
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
        </script>

    </body>
</html>