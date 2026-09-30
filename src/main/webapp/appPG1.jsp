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
        response.sendRedirect("/gen_app_dashboard");
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
        <title><%=settings.productName%> - PG Application</title>

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
                    <h2 class="title">PG Application</h2>
                </div>
            </header>


            <div class="body flex-grow-1">
                <div class="container-lg px-4">

                    <%                        if (std != null) {

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

                            <%
                                String refereename = request.getParameter("refereename");
                                String refemail = request.getParameter("refemail");
                                String refphone = request.getParameter("refphone");
                                String refcontactadd = request.getParameter("refcontactadd");
                                String refrank = request.getParameter("refrank");
                                String button4c = request.getParameter("button4c");
                                if (button4c != null && button4c.length() > 0 && refereename != null && refereename.length() > 0 && refemail != null && refemail.length() > 0) {
                                    try {
                                        List<Applicantsreferees> contains = lref.stream()
                                                .filter(data -> data.getEmailAddress().equalsIgnoreCase(refemail)
                                                || data.getName().equalsIgnoreCase(refereename))
                                                .collect(Collectors.toList());

                                        if (!contains.isEmpty()) {
                            %>
                            <div class="alert alert-danger">This Referee has already been added</div>
                            <%
                            } else {
                                String id = genapp.getId() + settings.generateId("", 4);
                                Applicantsreferees scha = new Applicantsreferees(id);
                                scha.setApplicantsId(genapp);
                                scha.setContactAddress(refcontactadd);
                                scha.setEmailAddress(refemail);
                                scha.setName(refereename);
                                scha.setPhoneNo(refphone);
                                scha.setRank(refrank);
                                sess.newEntry(scha);
                            %>
                            <div class="alert alert-success">Record has been added successfully</div>
                            <%
                                        }

                                        lref = sess.getApplicantsrefereesByRegno(genapp.getId());

                                    } catch (Exception k) {
                                        k.printStackTrace();
                                    }
                                }
                            %>


                            <%                String docname = null;
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

                            <%      String maritalstatus = request.getParameter("maritalstatus");
                                String guardianname = request.getParameter("guardianname");
                                String guardianadd = request.getParameter("guardianadd");
                                String sponsorphone = request.getParameter("sponsor_phone");
                                String training = request.getParameter("training");
                                String quali = request.getParameter("quali");
                                String fieldstudy = request.getParameter("fieldstudy");
                                String research = request.getParameter("research");
                                String empstatus = request.getParameter("empstatus");
                                String button4k = request.getParameter("button4k");
                                if (button4k != null && button4k.length() > 0 && maritalstatus != null) {
                                    try {
                                        sess.updateApplicantsothers(genapp.getId(), "POST GRADUATE", training, empstatus, fieldstudy, research);
                                        //genapp.setApplicantsothers(others);
                                        sess.updateApplicants(genapp.getId(), guardianname, guardianadd, sponsorphone, quali, maritalstatus);
                                        try {
                                            Applicantsothers dd = (Applicantsothers) sess.getSingleObject(Applicantsothers.class, genapp.getId());
                                            if (dd != null) {
                                                sess.updateApplicantsothers(genapp.getId(), "POST GRADUATE", training, empstatus, fieldstudy, research);
                                            } else {
                                                Applicantsothers others = new Applicantsothers(genapp.getId());
                                                others.setApplicationType("POST GRADUATE");
                                                others.setCurrentlyTraining(training);
                                                others.setEmploymentStatus(empstatus);
                                                others.setFieldOfStudy(fieldstudy);
                                                others.setResearchExperience(research);
                                                sess.newEntry(others);
                                            }
                                            genapp = sess.getApplicants(genapp.getId());

                                        } catch (Exception k) {
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
                                    List<Payments> payutme = sess.getPaymentsByRegnoSessSemFeesgroup(std.getId(), "10004", genapp.getSession(), "Session");
                                    if (payutme.size() > 0) {
                            %>


                            <div class="accordion" id="accordionExample">
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingOne">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">Additional Details</button>
                                    </h2>
                                    <div class="accordion-collapse collapse show" id="collapseOne" aria-labelledby="headingOne" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                Applicantsothers others = genapp.getApplicantsothers();
                                            %>
                                            <form action="" method="POST" role="form" name="addnew">

                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Marital Status  
                                                    </span>
                                                    <select class="form-select" name="maritalstatus">
                                                        <%
                                                            String marsta = genapp.getMaritalStatus();
                                                        %>
                                                        <option value="<%=marsta != null ? marsta : ""%>" selected=""><%=marsta != null ? marsta : "Select One"%></option>
                                                        <option value="Single">Single</option>
                                                        <option value="Married">Married</option>
                                                        <option value="Divorced">Divorced</option>
                                                        <option value="Widowed">Widowed</option>
                                                        <option value="Separated">Separated</option>
                                                    </select>

                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Guardian Name
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=genapp.getGuardianName() != null ? genapp.getGuardianName() : ""%>" minlength="2" required="" name="guardianname">
                                                </div>
                                                <div class="input-group mb-3"><span class="input-group-text">
                                                        Guardian Address    
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=genapp.getGuardianAddress() != null ? genapp.getGuardianAddress() : ""%>" name="guardianadd" minlength="2">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Currently in Training 
                                                    </span>
                                                    <input class="form-control" type="text" name="training" value="<%=others != null ? others.getCurrentlyTraining() : ""%>">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Qualification  
                                                    </span>
                                                    <input class="form-control" type="text" name="quali" value="<%=genapp.getQualification() != null ? genapp.getQualification() : ""%>">
                                                </div>


                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Field of Study 
                                                    </span>
                                                    <input class="form-control" type="text" value="<%=others != null ? others.getFieldOfStudy() : ""%>" name="fieldstudy" >
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Research Experience    
                                                    </span>
                                                    <input class="form-control" type="text"  name="research" value="<%=others != null ? others.getResearchExperience() : ""%>">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Employment Status 
                                                    </span>
                                                    <select class="form-select" name="empstatus">
                                                        <%
                                                            if (others != null) {
                                                        %>
                                                        <option value="<%=others.getEmploymentStatus()%>" selected=""><%=others.getEmploymentStatus()%></option>
                                                        <%
                                                            }
                                                        %>
                                                        <option value="Employed">Employed</option>
                                                        <option value="Self-Employed<">Self-Employed</option>
                                                        <option value="Un-Employed">Un-Employed</option>
                                                    </select>
                                                </div>



                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="button4k" class="btn btn-primary px-4" value="<%=others != null ? "Update Records" : "Add Records"%>"/>
                                                    </div>

                                                </div>

                                            </form>

                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header" id="headingSix">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseSix" aria-expanded="false" aria-controls="collapseSix">Institutions Attended (<%=lschatt.size()%> added)</button>
                                    </h2>
                                    <div class="accordion-collapse collapse" id="collapseSix" aria-labelledby="headingSix" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">

                                            <form action='' method='post' name="institutions">
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Name of Institution    
                                                    </span>
                                                    <input class="form-control" type="text"  name="instname" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Start date    
                                                    </span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="inststartdate" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        End Date    
                                                    </span>
                                                    <input class="form-control" type="date" max="<%=settings.getTodaysdate()%>" name="instenddate">
                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Year Certificate Awarded    
                                                    </span>
                                                    <input class="form-control" type="number" max="<%=settings.getTodaysdate().split("-")[0]%>"  name="instcertyear">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Results   
                                                    </span>
                                                    <input class="form-control" type="text"  name="instresults">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Registration Number   
                                                    </span>
                                                    <input class="form-control" type="text"  name="instregno">
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
                                                        <th>Name</th>
                                                        <th>From</th>
                                                        <th>To</th>
                                                        <th>Certificate</th>
                                                        <th>Remove</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (Schoolsattended data : lschatt) {
                                                    %>
                                                    <tr>
                                                        <td><%=data.getName()%></td>
                                                        <td><%=sdf.format(data.getStartDate())%></td>
                                                        <td><%=sdf.format(data.getEndDate())%></td>
                                                        <td><%=data.getQualification()%></td>
                                                        <td><a href="/application_pg1?id2=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
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
                                    <h2 class="accordion-header" id="headingThree">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Referees <%=lref.size()%> of 2</button>
                                    </h2>
                                    <div class="accordion-collapse collapse" id="collapseThree" aria-labelledby="headingThree" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <%
                                                if (lref.size() < 3) {
                                            %>
                                            <form action='' method='post' name="referees">
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Full Name    
                                                    </span>
                                                    <input class="form-control" type="text"  name="refereename" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Email Address    
                                                    </span>
                                                    <input class="form-control" type="email"  name="refemail" required="">
                                                </div>

                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Phone Number    
                                                    </span>
                                                    <input class="form-control" type="text" maxlength="13" minlength="10"  name="refphone" required="">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Contact Address    
                                                    </span>
                                                    <input class="form-control" type="text"  name="refcontactadd">
                                                </div>
                                                <div class="input-group mb-4"><span class="input-group-text">
                                                        Rank    
                                                    </span>
                                                    <input class="form-control" type="text"  name="refrank">
                                                </div>



                                                <div class="row">
                                                    <div class="col-12">
                                                        <input type="submit" name="button4c" class="btn btn-primary px-4" value="Add Record"/>
                                                    </div>

                                                </div>
                                            </form>
                                            <%
                                                }
                                            %>
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Name</th>
                                                        <th>Email</th>
                                                        <th>Phone Number</th>
                                                        <th>Rank</th>
                                                        <th>Remove</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (Applicantsreferees data : lref) {
                                                    %>
                                                    <tr>
                                                        <td><%=data.getName()%></td>
                                                        <td><%=data.getEmailAddress()%></td>
                                                        <td><%=data.getPhoneNo()%></td>
                                                        <td><%=data.getRank()%></td>
                                                        <td><a href="/application_pg1?id3=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Remove</a></td>
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
                                    <h2 class="accordion-header" id="headingFour">
                                        <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseFour" aria-expanded="false" aria-controls="collapseThree">Transcript Details</button>
                                    </h2>
                                    <div class="accordion-collapse collapse" id="collapseFour" aria-labelledby="headingFour" data-coreui-parent="#accordionExample" style="">
                                        <div class="accordion-body">
                                            <a href="#" class="btn btn-secondary btn-sm float-end" onclick="printTable('printable');">Print Form</a>
                                            <table class="table table-hover" id="printable">

                                                <tbody>
                                                    <tr>
                                                        <td class="center"><img src="<%=settings.logo%>" style="height:132px; width: auto" /></td>
                                                    </tr>
                                                    <tr>
                                                        <th class="center">POSTGRADUATE SCHOOL</th>
                                                    </tr>
                                                    <tr>
                                                        <th class="center">Benue State University, Makurdi</th>
                                                    </tr>
                                                    <tr>
                                                        <th class="center">Transcript Form </th>
                                                    </tr>
                                                    <tr>
                                                        <td class="center">
                                                            <table class="table table-striped table-hover">
                                                                <tr>
                                                                    <th>Application No:</th>
                                                                    <td><%=genapp.getId()%></td>
                                                                </tr>
                                                                <tr>
                                                                    <th>Full Name:</th>
                                                                    <td><%=std.getSurname() + " " + std.getOthernames()%></td>
                                                                </tr>
                                                                <tr>
                                                                    <th>Course applied for:</th>
                                                                    <td><%=genapp.getCourse1().getName()%></td>
                                                                </tr>
                                                                <tr>
                                                                    <th>Department:</th>
                                                                    <td><%=genapp.getCourse1().getDepartmentId().getName()%></td>
                                                                </tr>
                                                                <tr>
                                                                    <th>Faculty:</th>
                                                                    <td><%=genapp.getCourse1().getDepartmentId().getFacultyId().getName()%></td>
                                                                </tr>

                                                                <tr>
                                                                    <td colspan="2">
                                                                        <div class="alert alert-info">
                                                                            Note: TO THE ACADEMIC RECORDS OFFICE OF APPLICANTS ALMAMATER (THE UNIVERSITY AND/OR OTHER HIGHER INSTITUTION(S) ATTENDED)
                                                                            <br/><bbr/>
                                                                            <strong>This form and transcript should be mailed urgently to:</strong>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                    <td><strong>THE SECRETARY, <br/>
                                                                            POSTGRADUATE SCHOOL,<br/>
                                                                            BENUE STATE UNIVERSITY,<br/>
                                                                            MAKURDI - NIGERIA.</strong>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
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
                                <p>A referee form will be sent to your referee's email address to fill online and submit.</p>
                                <p>Kindly ensure your transcript gets to the Post-graduate school on time to avoid denying your application.</p>
                                <p>Download Documents:
                                    <a href="/DownloadTranscriptForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-secondary btn-sm float-end">Transcript Form</a> 
                                    <a href="/DownloadPGAppForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-warning btn-sm float-end">Application Form</a> 
                                </p>
                            </div>
                            <%
                                }
                                if (genapp.getStatus().equalsIgnoreCase("ADMITTED")) {
                            %>
                            <div class="alert alert-info">
                                <p>Your application has been processed successfully, Kindly download your admission letter from the list of documents, follow the instruction of it to complete your admission process</p>
                                <p>Kindly ensure your transcript gets to the Post-graduate school on time to enable successful screening.</p>
                                <p>Download Documents:
                                    <a href="/DownloadTranscriptForm?id=<%=settings.encodeUrl(settings.encryptText(genapp.getId()))%>" target="_blank" class="btn btn-secondary btn-sm float-end">Transcript Form</a> 
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