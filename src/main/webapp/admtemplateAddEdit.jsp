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
    Courses course = null;
    String sessions = null;
    try {
        course = (Courses) session.getAttribute("cou");
        sessions = (String) session.getAttribute("sessd");
    } catch (Exception k) {
    }
    if (course == null || sessions == null) {
        response.sendRedirect("/app_adm_temp");
    }

    Admissiontemplate admtd = sess.getAdmissiontemplate(course.getId(), sessions);
%>


<%
    String comp = request.getParameter("comp");
    String oth = request.getParameter("oth");
    String perutme = request.getParameter("perutme");
    String perol = request.getParameter("perol");
    String perputme = request.getParameter("perputme");
    String compU = request.getParameter("compU");
    String othU = request.getParameter("othU");
    String noMerit = request.getParameter("nomerit");
    String natMerit = request.getParameter("natmerit");
    String staMerit = request.getParameter("stamerit");
    String lgaMerit = request.getParameter("lgamerit");

    String button = request.getParameter("button");
    if (button != null && button.length() > 0) {
        if (admtd != null) {
            try {
                admtd.setAptitudePer(Integer.parseInt(perputme));
                admtd.setCompulsorySubjects(Integer.parseInt(comp));
                admtd.setOlevelPer(Integer.parseInt(perol));
                admtd.setOtherSubjects(Integer.parseInt(oth));
                admtd.setUtmePer(Integer.parseInt(perutme));
                admtd.setCompulsoryUtme(Integer.parseInt(compU));
                admtd.setOtherUtme(Integer.parseInt(othU));
                admtd.setTotalMerit(Integer.parseInt(noMerit));
                admtd.setNationalMerit(Double.parseDouble(natMerit));
                admtd.setStateMerit(Double.parseDouble(staMerit));
                admtd.setLgaMerit(Double.parseDouble(lgaMerit));
                sess.updateAdmissiontemplate(admtd);

            } catch (Exception k) {
            }
        } else {
            try {
                String id = settings.generateId(settings.getTodaysdate().split("-")[0], 10);
                admtd = new Admissiontemplate(id);
                admtd.setAptitudePer(Integer.parseInt(perputme));
                admtd.setCompulsorySubjects(Integer.parseInt(comp));
                admtd.setOlevelPer(Integer.parseInt(perol));
                admtd.setOtherSubjects(Integer.parseInt(oth));
                admtd.setUtmePer(Integer.parseInt(perutme));
                admtd.setCourse(course);
                admtd.setSession(sessions);
                admtd.setCompulsoryUtme(Integer.parseInt(compU));
                admtd.setOtherUtme(Integer.parseInt(othU));
                admtd.setTotalMerit(Integer.parseInt(noMerit));
                admtd.setNationalMerit(Double.parseDouble(natMerit));
                admtd.setStateMerit(Double.parseDouble(staMerit));
                admtd.setLgaMerit(Double.parseDouble(lgaMerit));
                sess.newEntry(admtd);

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
        <title><%=settings.productName%> - <%=sessions%> Admission Templates <%=course.getName()%></title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">

                    <h2 class="title"><%=sessions%> Admission Templates <%=course.getName()%></h2>
                </div>
            </header>
            <%

                String id2 = request.getParameter("id2");
                if (id2 != null && id2.length() > 0) {
                    id2 = settings.decryptText(id2);
                    Admissiontemplateolevel adk = sess.getOlevelresultsitem(id2);
                    if (adk != null) {
                        sess.deleteAdmissiontemplateolevel(id2);
                    }
                }

                String subjc = request.getParameter("subjc");
                String submitC = request.getParameter("submitC");
                if (subjc != null && submitC != null && subjc.length() > 0) {
                    try {
                        String idc = admtd.getId() + settings.generateId("", 4);
                        Admissiontemplateolevel admc = new Admissiontemplateolevel(idc);
                        admc.setAdmissionTemplate(admtd);
                        admc.setOlevelSubject(sess.getOlevelsubjects(subjc));
                        admc.setOlevelType("C");
                        sess.newEntry(admc);
                    } catch (Exception k) {
                    }
                }

                String subjo = request.getParameter("subjo");
                String submitO = request.getParameter("submitO");
                if (subjo != null && submitO != null && subjo.length() > 0) {
                    try {
                        String idc = admtd.getId() + settings.generateId("", 4);
                        Admissiontemplateolevel admc = new Admissiontemplateolevel(idc);
                        admc.setAdmissionTemplate(admtd);
                        admc.setOlevelSubject(sess.getOlevelsubjects(subjo));
                        admc.setOlevelType("O");
                        sess.newEntry(admc);
                    } catch (Exception k) {
                    }
                }
            %>

            <%
                String id2U = request.getParameter("id2U");
                if (id2U != null && id2U.length() > 0) {
                    id2U = settings.decryptText(id2U);
                    Admissiontemplateutme adk = sess.getOlevelresultsitemUtme(id2U);
                    if (adk != null) {
                        sess.deleteAdmissiontemplateutme(id2U);
                    }
                }

                String subjcU = request.getParameter("subjcU");
                String submitCU = request.getParameter("submitCU");
                if (subjcU != null && submitCU != null && subjcU.length() > 0) {
                    try {
                        String idc = admtd.getId() + settings.generateId("", 4);
                        Admissiontemplateutme admc = new Admissiontemplateutme(idc);
                        admc.setAdmissionTemplate(admtd);
                        admc.setUtmesubjects(sess.getUtmesubjects(subjcU));
                        admc.setUtmeType("C");
                        sess.newEntry(admc);
                    } catch (Exception k) {
                    }
                }

                String subjoU = request.getParameter("subjoU");
                String submitOU = request.getParameter("submitOU");
                if (subjoU != null && submitOU != null && subjoU.length() > 0) {
                    try {
                        String idc = admtd.getId() + settings.generateId("", 4);
                        Admissiontemplateutme admc = new Admissiontemplateutme(idc);
                        admc.setAdmissionTemplate(admtd);
                        admc.setUtmesubjects(sess.getUtmesubjects(subjoU));
                        admc.setUtmeType("O");
                        sess.newEntry(admc);
                    } catch (Exception k) {
                    }
                }
            %>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <p>
                                    <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">View instructions</button>

                                    <a href='/app_adm_temp' class="btn btn-danger btn-sm send-right">Back</a>
                                </p>
                                <div class="collapse" id="collapseExample" style="">
                                    <div class="alert alert-info">
                                        <p>Admission template is used to process admission for ND applicants </p>
                                        <p>Always remember to cross-check before proceeding to generate admission template list. Only applicants that have PAID and updated their records will be visible for preparation of admission template list</p>

                                    </div>
                                </div>

                            </div>
                            <div class="card-body">

                                <form action="" method="POST" role="form">
                                    <%
                                        String lab = "New Entry";

                                        if (admtd != null) {
                                            lab = "Update Entry";
                                        }
                                    %>
                                    <p class="text-body-secondary"><%=lab%></p>
                                    <div class="input-group mb-3"><span class="input-group-text">
                                            No. of Compulsory Subjects    
                                        </span>
                                        <input class="form-control" type="number" value="<%=admtd != null ? admtd.getCompulsorySubjects() : "2"%>" min="2" max="5" required="" onchange="updateRecord();" name="comp" id="comp">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            No. of Other Subjects    
                                        </span>
                                        <input class="form-control" type="number" value="<%=admtd != null ? admtd.getOtherSubjects() : "3"%>" min="0" max="5" required="" name="oth" id="oth">
                                    </div>
                                    <div class="input-group mb-3"><span class="input-group-text">
                                            No. of Compulsory UTME    
                                        </span>
                                        <input class="form-control" type="number" value="<%=admtd != null ? admtd.getCompulsoryUtme() : "1"%>" min="1" max="4" required="" onchange=updateRecordU();" name="compU" id="compU">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            No. of Other UTME    
                                        </span>
                                        <input class="form-control" type="number" value="<%=admtd != null ? admtd.getOtherUtme() : "0"%>" min="0" max="4" required="" name="othU" id="othU">
                                    </div>

                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. UTME    
                                        </span>
                                        <input class="form-control" type="number" value="<%=admtd != null ? admtd.getUtmePer() : ""%>" min="0" max="100" required="" name="perutme">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. O-Level    
                                        </span>
                                        <input class="form-control" type="number" min="0" value="<%=admtd != null ? admtd.getOlevelPer() : ""%>" max="100" required="" name="perol">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. Aptitude Test    
                                        </span>
                                        <input class="form-control" type="number" min="0" value="<%=admtd != null ? admtd.getAptitudePer() : "0"%>" max="100" required="" name="perputme">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            No. on Merit   
                                        </span>
                                        <input class="form-control" type="number" min="0" value="<%=admtd != null ? admtd.getTotalMerit() : "0"%>" required="" name="nomerit">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. National Merit    
                                        </span>
                                        <input class="form-control" type="number" step="0.01" min="0" value="<%=admtd != null ? admtd.getNationalMerit() : "0"%>" max="100" required="" name="natmerit">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. State Merit    
                                        </span>
                                        <input class="form-control" type="number" step="0.01" min="0" value="<%=admtd != null ? admtd.getStateMerit() : "0"%>" max="100" required="" name="stamerit">
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Per. LGA Equality   
                                        </span>
                                        <input class="form-control" type="number" step="0.01" min="0" value="<%=admtd != null ? admtd.getLgaMerit() : "0"%>" max="100" required="" name="lgamerit">
                                    </div>

                                    <div class="row">
                                        <div class="col-12">
                                            <input type="submit" name="button" class="btn btn-primary px-4" value="<%=lab%>"/>
                                        </div>

                                    </div>

                                </form>

                            </div>
                        </div>
                    </div>

                    <%
                        //Collection<Admissiontemplateolevel> listx = admtd.getAdmissiontemplateolevelCollection();
                        admtd = sess.getAdmissiontemplate(course.getId(), sessions);
                        if (admtd != null) {
                        List<Admissiontemplateolevel> admtl = sess.getAdmissiontemplateolevel(admtd.getId());
                        List<Admissiontemplateutme> admtlU = sess.getAdmissiontemplateutme(admtd.getId());

                        List<Admissiontemplateolevel> listoc = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("C"))
                                .collect(Collectors.toList());
                        List<Admissiontemplateolevel> listoo = admtl.stream().filter(oltype -> oltype.getOlevelType().equalsIgnoreCase("O"))
                                .collect(Collectors.toList());

                        List<Admissiontemplateutme> listocU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("C"))
                                .collect(Collectors.toList());
                        List<Admissiontemplateutme> listooU = admtlU.stream().filter(oltype -> oltype.getUtmeType().equalsIgnoreCase("O"))
                                .collect(Collectors.toList());

                        if (admtl.size() == 0) {


                    %>
                    <div class='alert alert-warning'>No subject added</div>
                    <%                    }

                    %>
                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header">Compulsory Subjects <%=listoc.size()%> of <%=admtd.getCompulsorySubjects()%>

                            </div>

                            <div class="card-body">
                                <%
                                    if (listoc.size() < admtd.getCompulsorySubjects()) {
                                %>
                                <form action="" method='post' name="comp">
                                    <div class="tab-content rounded-bottom">
                                        <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                            <div class="mb-3 row">
                                                <label class="col-sm-2 col-form-label" for="payerno">Select Subject</label>
                                                <div class="col-sm-7">
                                                    <select name="subjc" id="subjc" class="form-select">
                                                        <%
                                                            List<Olevelsubjects> olsl = sess.getAllOlevelsubjects("ACTIVE");
                                                            for (Olevelsubjects ols : olsl) {
                                                                boolean found = admtl.stream().anyMatch(subj -> ols.getId().equals(subj.getOlevelSubject().getId()));
                                                                if (!found) {
                                                        %>
                                                        <option value="<%=ols.getId()%>"><%=ols.getName()%></option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select> 
                                                </div>
                                                <div class="col-sm-3">

                                                    <button name="submitC" class="btn btn-primary mb-3" type="submit">Add</button>                       
                                                </div></div>
                                        </div>
                                    </div>
                                </form>
                                <%
                                    }
                                %>

                                <table class="table table-striped table-hover" id='dataTableC'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Subject</th>
                                            <th>Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int i = 1;
                                            for (Admissiontemplateolevel com : listoc) {

                                        %>
                                        <tr>
                                            <td class="center"><%=i%></td>
                                            <td><%=com.getOlevelSubject().getName()%></td>
                                            <td class="center">
                                                <a class="btn btn-warning btn-sm" href="/adm_temp_addedit?id2=<%=settings.encodeUrl(settings.encryptText(com.getId()))%>">Remove</a>

                                            </td>
                                        </tr>
                                        <%
                                                i++;
                                            }
                                        %>


                                    </tbody>
                                </table>

                            </div>

                            <div class="card-header">Other Subjects <%=listoo.size()%> of <%=admtd.getOtherSubjects()%>

                            </div>

                            <div class="card-body">

                                <form action="" method='post' name="comp">
                                    <div class="tab-content rounded-bottom">
                                        <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                            <div class="mb-3 row">
                                                <label class="col-sm-2 col-form-label" for="payerno">Select Subject</label>
                                                <div class="col-sm-7">
                                                    <select name="subjo" id="subjo" class="form-select">
                                                        <%
                                                            List<Olevelsubjects> olsl = sess.getAllOlevelsubjects("ACTIVE");
                                                            for (Olevelsubjects ols : olsl) {
                                                                boolean found = admtl.stream().anyMatch(subj -> ols.getId().equals(subj.getOlevelSubject().getId()));
                                                                if (!found) {
                                                        %>
                                                        <option value="<%=ols.getId()%>"><%=ols.getName()%></option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select> 
                                                </div>
                                                <div class="col-sm-3">

                                                    <button name="submitO" class="btn btn-primary mb-3" type="submit">Add</button>                       
                                                </div></div>
                                        </div>
                                    </div>
                                </form>


                                <table class="table table-striped table-hover" id='dataTableC'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Subject</th>
                                            <th>Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int j = 1;
                                            for (Admissiontemplateolevel com : listoo) {

                                        %>
                                        <tr>
                                            <td class="center"><%=j%></td>
                                            <td><%=com.getOlevelSubject().getName()%></td>
                                            <td class="center">
                                                <a class="btn btn-warning btn-sm" href="/adm_temp_addedit?id2=<%=settings.encodeUrl(settings.encryptText(com.getId()))%>">Remove</a>

                                            </td>
                                        </tr>
                                        <%
                                                j++;
                                            }
                                        %>


                                    </tbody>
                                </table>

                            </div>
                                        
                                        
                                        
                                         <div class="card-header">Compulsory UTME <%=listocU.size()%> of <%=admtd.getCompulsoryUtme()%>

                            </div>

                            <div class="card-body">
                                <%
                                    if (listocU.size() < admtd.getCompulsoryUtme()) {
                                %>
                                <form action="" method='post' name="comp">
                                    <div class="tab-content rounded-bottom">
                                        <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                            <div class="mb-3 row">
                                                <label class="col-sm-2 col-form-label" for="payerno">Select Subject</label>
                                                <div class="col-sm-7">
                                                    <select name="subjcU" id="subjcU" class="form-select">
                                                        <%
                                                            List<Utmesubjects> olslU = sess.getAlUtmesubjects("ACTIVE");
                                                            for (Utmesubjects ols : olslU) {
                                                                boolean found = admtlU.stream().anyMatch(subj -> ols.getId().equals(subj.getUtmesubjects().getId()));
                                                                if (!found) {
                                                        %>
                                                        <option value="<%=ols.getId()%>"><%=ols.getName()%></option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select> 
                                                </div>
                                                <div class="col-sm-3">

                                                    <button name="submitCU" class="btn btn-primary mb-3" type="submit">Add</button>                       
                                                </div></div>
                                        </div>
                                    </div>
                                </form>
                                <%
                                    }
                                %>

                                <table class="table table-striped table-hover" id='dataTableC'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Subject</th>
                                            <th>Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            i = 1;
                                            for (Admissiontemplateutme com : listocU) {

                                        %>
                                        <tr>
                                            <td class="center"><%=i%></td>
                                            <td><%=com.getUtmesubjects().getName()%></td>
                                            <td class="center">
                                                <a class="btn btn-warning btn-sm" href="/adm_temp_addedit?id2U=<%=settings.encodeUrl(settings.encryptText(com.getId()))%>">Remove</a>

                                            </td>
                                        </tr>
                                        <%
                                                i++;
                                            }
                                        %>


                                    </tbody>
                                </table>

                            </div>

                            <div class="card-header">Other UTME Subjects <%=listooU.size()%> of <%=admtd.getOtherUtme()%>

                            </div>

                            <div class="card-body">

                                <form action="" method='post' name="comp">
                                    <div class="tab-content rounded-bottom">
                                        <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                            <div class="mb-3 row">
                                                <label class="col-sm-2 col-form-label" for="payerno">Select Subject</label>
                                                <div class="col-sm-7">
                                                    <select name="subjoU" id="subjoU" class="form-select">
                                                        <%
                                                            List<Utmesubjects> olslU = sess.getAlUtmesubjects("ACTIVE");
                                                            for (Utmesubjects ols : olslU) {
                                                                boolean found = admtlU.stream().anyMatch(subj -> ols.getId().equals(subj.getUtmesubjects().getId()));
                                                                if (!found) {
                                                        %>
                                                        <option value="<%=ols.getId()%>"><%=ols.getName()%></option>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </select> 
                                                </div>
                                                <div class="col-sm-3">

                                                    <button name="submitOU" class="btn btn-primary mb-3" type="submit">Add</button>                       
                                                </div></div>
                                        </div>
                                    </div>
                                </form>


                                <table class="table table-striped table-hover" id='dataTableC'>
                                    <thead>
                                        <tr>
                                            <th class="center">#</th>
                                            <th>Subject</th>
                                            <th>Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            j = 1;
                                            for (Admissiontemplateutme com : listooU) {

                                        %>
                                        <tr>
                                            <td class="center"><%=j%></td>
                                            <td><%=com.getUtmesubjects().getName()%></td>
                                            <td class="center">
                                                <a class="btn btn-warning btn-sm" href="/adm_temp_addedit?id2U=<%=settings.encodeUrl(settings.encryptText(com.getId()))%>">Remove</a>

                                            </td>
                                        </tr>
                                        <%
                                                j++;
                                            }
                                        %>


                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div>
                    <%
                        } else {
                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="alert alert-warning">
                                    <strong>No Template Found!</strong><br/>
                                    No admission template has been configured for this course and session yet. 
                                    Please fill in the form above to create one.
                                </div>
                            </div>
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

            function updateRecord() {
                var comp = document.getElementById("comp").value; // Get the value of the input
                comp = parseFloat(comp) || 0; // Convert the value to a number (default to 0 if invalid)
                var diff = 5 - comp; // Calculate the difference
                document.getElementById("oth").value = diff;
            }

            function updateRecordU() {
                var comp = document.getElementById("compU").value; // Get the value of the input
                comp = parseFloat(comp) || 0; // Convert the value to a number (default to 0 if invalid)
                var diff = 4 - comp; // Calculate the difference
                document.getElementById("othU").value = diff;
            }
        </script>
    </body>
</html>