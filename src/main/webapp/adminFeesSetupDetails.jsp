<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }


%>

<%    String schools = null;
    String sessions = null;
    String semester = null;
    String item = null;
    try {
        schools = (String) session.getAttribute("schools");
        sessions = (String) session.getAttribute("sessions");
        semester = (String) session.getAttribute("semester");
        item = (String) session.getAttribute("item");
    } catch (Exception k) {
    }
    if (sessions == null || schools == null || semester == null || item == null) {
        response.sendRedirect("/fees_setup");
    }
    Schools sch = sess.getSchools(schools);
    Feesgroup fg = (Feesgroup) sess.getSingleObject(Feesgroup.class, item);
    
    // Auto-create SCHOOL FEES fee group if it doesn't exist
    if (fg == null && item != null && item.equals("SCHOOL_FEES_AUTO")) {
        try {
            // Check if SCHOOL FEES fee group exists for this school
            Feesgroup existingFg = sess.getSchoolFeesId(schools);
            if (existingFg == null) {
                // Create new SCHOOL FEES fee group
                String fgId =  settings.generateId("", 5);
                fg = new Feesgroup(fgId);
                fg.setName("SCHOOL FEES");
                fg.setSchoolId(sch);
                fg.setAccountId((Accounts) sess.getSingleObject(Accounts.class, 100));
                fg.setDescription("School fees for " + sch.getName());
                fg.setSessionSemester("Session");
                fg.setRepeatPayment("No");
                fg.setCategory("Students");
                fg.setVisibility("PUBLIC");
                sess.newEntry(fg);
                
                // Update session attribute with the new fee group ID
                session.setAttribute("item", fgId);
                item = fgId;
            } else {
                fg = existingFg;
                session.setAttribute("item", fg.getId());
                item = fg.getId();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    if (sch == null || fg == null) {
        response.sendRedirect("/fees_setup");
    }
    String msg = "";
    String sty = "warning";
    
    // Check for success message from session (after redirect)
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        msg = successMessage;
        sty = "success";
        session.removeAttribute("successMessage"); // Remove after displaying
    }
    
    String id = request.getParameter("id");
    if (id != null && id.length() > 0) {
        id = settings.decryptText(id);
        id = id.trim();
  
            sess.removeFeessetup(id);
            sty="success";
            msg = "Records has been removed from fees setup";
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Fees Setup Details</title>



    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Fees Setup for <%=fg.getName()%>, <%=sessions%> <%=semester%> Session in <%=sch.getName()%></h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card-body">
                            <div class="alert alert-warning">You can click on any of the scope to add amount. 
                                <p>Note that faculty scope will apply to all the departments and same for department scope</p>
                                <p>Leave the level empty if you want the fee to be applicable to all levers</p>
                                <p>Enter 0 if you want the level to be ignores (<em>For items such as applications</em></p>
                            </div>
                        </div>
                        <div class="card mb-4">
                            <div class="card-header float-end">
                                <a href="/fees_setup" class="btn btn-danger btn-sm float-end">Back</a>
                                <a href="/create_fees_group" class="btn btn-info btn-sm float-end me-2">Manage Fee Groups</a>
                                <a href="#" class="btn btn-secondary btn-sm mb-3 float-end" data-coreui-toggle="modal" data-coreui-target="#facmod">
                                    Faculty Scope
                                </a>
                                <a href="#" class="btn btn-primary btn-sm mb-3 float-end" data-coreui-toggle="modal" data-coreui-target="#depmod">
                                    Department Scope
                                </a>
                                <a href="#" class="btn btn-success btn-sm mb-3 float-end" data-coreui-toggle="modal" data-coreui-target="#coursemod">
                                    Course Scope
                                </a>
                                <div class="modal fade" id="facmod" tabindex="-1" aria-labelledby="facmodlab" aria-hidden="true" style="display: none;">
                                    <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="facmodlab">Add Fees at Faculty Level</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action="" method="post" name="facform">
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Faculty
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="fac" class="form-select" required>
                                                                <option value="None">None (Applicable across all faculties)</option>
                                                                <%
                                                                    try {
                                                                        List<FacultiesDirectorates> facl = sess.getAllFacultiesDirectorates();
                                                                        for (FacultiesDirectorates data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Sub Item
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="facitem" class="form-select" required>
                                                                <option value="">Select Fee Item</option>
                                                                <%
                                                                    try {
                                                                        List<Feesitems> facl = sess.getAllFeesitems();
                                                                        for (Feesitems data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Enter Level
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="faclevel" class="form-control" min="0" maxlength="3" max="900"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Indigene Status
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="facind" class="form-select">
                                                                <option value="">Select One</option>
                                                                <option value="indigene">Indigene</option>
                                                                <option value="non_indigene">non_indigene</option>
                                                                <option value="All">All</option>
                                                                <option value="None">Not applicable</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Effective Date
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="date" name="facdate" class="form-control" min="<%=settings.getTodaysdate()%>"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Amount
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="facamount" class="form-control"  min="300" required=""/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6">
                                                        </div>
                                                        <div class="col-6">
                                                            <input type="submit" name="facbutton" class="btn btn-secondary px-4" value="Add"/>
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
                                <div class="modal fade" id="depmod" tabindex="-1" aria-labelledby="depmodlab" aria-hidden="true" style="display: none;">
                                    <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="depmodlab">Add Fees at Department Level</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action="" method="post" name="depform">
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Department
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="dep" class="form-select" required>
                                                                <option value="None">None (Applicable across all departments)</option>
                                                                <%
                                                                    try {
                                                                        List<Departments> facl = sess.getAllDepartments();
                                                                        for (Departments data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Sub Item
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="depitem" class="form-select" required>
                                                                <option value="">Select Fee Item</option>
                                                                <%
                                                                    try {
                                                                        List<Feesitems> facl = sess.getAllFeesitems();
                                                                        for (Feesitems data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Enter Level
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="deplevel" class="form-control" min="0" maxlength="3" max="900"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Indigene Status
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="depind" class="form-select">
                                                                <option value="">Select One</option>
                                                                <option value="indigene">Indigene</option>
                                                                <option value="non_indigene">non_indigene</option>
                                                                <option value="All">All</option>
                                                                <option value="None">Not applicable</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Effective Date
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="date" name="depdate" class="form-control" min="<%=settings.getTodaysdate()%>"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Amount
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="depamount" class="form-control"  min="300" required=""/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6">
                                                        </div>
                                                        <div class="col-6">
                                                            <input type="submit" name="depbutton" class="btn btn-secondary px-4" value="Add"/>
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
                                <div class="modal fade" id="coursemod" tabindex="-1" aria-labelledby="coursemodlab" aria-hidden="true" style="display: none;">
                                    <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="coursemodlab">Add Fees at Course Level</h5>
                                                <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action="" method="post" name="courseform">
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Course
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="course" class="form-select" required>
                                                                <option value="None">None (Applicable across all courses)</option>
                                                                <%
                                                                    try {
                                                                        List<Courses> facl = sess.getCoursesBySchool(sch.getId());
                                                                        for (Courses data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-4">
                                                            Select Sub Item
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="courseitem" class="form-select" required>
                                                                <option value="">Select Fee Item</option>
                                                                <%
                                                                    try {
                                                                        List<Feesitems> facl = sess.getAllFeesitems();
                                                                        for (Feesitems data : facl) {
                                                                %>
                                                                <option value="<%=data.getId()%>"><%=data.getName()%></option>
                                                                <%
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Enter Level
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="courselevel" class="form-control" min="0" maxlength="3" max="900"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Indigene Status
                                                        </div>
                                                        <div class="col-8">
                                                            <select name="courseind" class="form-select">
                                                                <option value="">Select One</option>
                                                                <option value="indigene">Indigene</option>
                                                                <option value="non_indigene">non_indigene</option>
                                                                <option value="All">All</option>
                                                                <option value="None">Not applicable</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-4">
                                                            Effective Date
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="date" name="coursedate" class="form-control" min="<%=settings.getTodaysdate()%>"/>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-4">
                                                            Amount
                                                        </div>
                                                        <div class="col-8">
                                                            <input type="number" name="courseamount" class="form-control"  min="300" required=""/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6">
                                                        </div>
                                                        <div class="col-6">
                                                            <input type="submit" name="coursebutton" class="btn btn-success px-4" value="Add"/>
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

                            <div class="card-body">
                                <%

                                    String coursebutton = request.getParameter("coursebutton");
                                    String coursedate = request.getParameter("coursedate");
                                    String courseind = request.getParameter("courseind");
                                    String courselevel = request.getParameter("courselevel");
                                    String coursed = request.getParameter("course");
                                    String courseitem = request.getParameter("courseitem");
                                    String courseamount = request.getParameter("courseamount");
                                    if (coursebutton != null && coursebutton.length() > 0 && coursed != null && coursed.length() > 0 
                                        && courseitem != null && courseitem.length() > 0 && courseamount != null && courseamount.length() > 0) {
                                        String tlev = "None";
                                        String idx = settings.getTodaysdate().split("-")[0] + settings.generateId("", 5);
                                        Feessetup sfd = new Feessetup(idx);
                                        sfd.setAccountIt((Accounts) sess.getSingleObject(Accounts.class, 100));
                                        sfd.setAddedBy(user);
                                        try {
                                            sfd.setAmount(Double.parseDouble(courseamount));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid amount entered. Please enter a valid number.";
                                            sty = "danger";
                                        }
                                        sfd.setCourseScope(coursed);
                                        sfd.setDateAdded(settings.getCurrentDateTime());
                                        sfd.setDepartmentScope("None");
                                        String sdate = coursedate + " 00:00:00";
                                        Date parsedDate1 = null;

                                        try {
                                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            parsedDate1 = dateFormat.parse(sdate);
                                        } catch (Exception aa) {
                                        }

                                        sfd.setEffectiveFrom(parsedDate1);
                                        sfd.setFacultyScope("None");
                                        sfd.setFeesGroupId(fg);
                                        try {
                                            sfd.setFeesItemsId((Feesitems) sess.getSingleObject(Feesitems.class, Integer.valueOf(courseitem)));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid course item selected. Please select a valid fee item.";
                                            sty = "danger";
                                        }
                                        sfd.setIndigeneStatusScope(courseind);
                                        if (courselevel == null || courselevel.length() == 0) {
                                            tlev = "All";
                                        }
                                        if (courselevel != null && courselevel.equalsIgnoreCase("0")) {
                                            tlev = "None";
                                        }
                                        if (courselevel != null && courselevel.length() == 3) {
                                            tlev = courselevel;
                                        }
                                        sfd.setLevelScope(tlev);
                                        sfd.setOnCampusScope("None");
                                        sfd.setProgrammeScope("None");
                                        sfd.setSchoolScope("None");

                                        sfd.setSemesterAdded(semester);

                                        sfd.setSessionAdded(sessions);
                                        sfd.setStudentId("None");
                                        sess.newEntry(sfd);
                                        // Set success message in session and redirect to prevent duplicate submission
                                        session.setAttribute("successMessage", "Course scope fee setup added successfully");
                                        response.sendRedirect(request.getRequestURI());
                                        return;
                                    }

                                    String depbutton = request.getParameter("depbutton");
                                    String depdate = request.getParameter("depdate");
                                    String depind = request.getParameter("depind");
                                    String deplevel = request.getParameter("deplevel");
                                    String depd = request.getParameter("dep");
                                    String depitem = request.getParameter("depitem");
                                    String depamount = request.getParameter("depamount");
                                    if (depbutton != null && depbutton.length() > 0 && depd != null && depd.length() > 0 
                                        && depitem != null && depitem.length() > 0 && depamount != null && depamount.length() > 0) {
                                        String idx = settings.getTodaysdate().split("-")[0] + settings.generateId("", 5);
                                        Feessetup sfd = new Feessetup(idx);
                                        sfd.setAccountIt((Accounts) sess.getSingleObject(Accounts.class, 100));
                                        sfd.setAddedBy(user);
                                        try {
                                            sfd.setAmount(Double.parseDouble(depamount));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid amount entered. Please enter a valid number.";
                                            sty = "danger";
                                        }
                                        sfd.setCourseScope("None");
                                        sfd.setDateAdded(settings.getCurrentDateTime());
                                        sfd.setDepartmentScope(depd);
                                        String sdate = depdate + " 00:00:00";
                                        Date parsedDate1 = null;

                                        try {
                                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            parsedDate1 = dateFormat.parse(sdate);
                                        } catch (Exception aa) {
                                        }
                                        sfd.setEffectiveFrom(parsedDate1);
                                        sfd.setFacultyScope("None");
                                        sfd.setFeesGroupId(fg);
                                        try {
                                            sfd.setFeesItemsId((Feesitems) sess.getSingleObject(Feesitems.class, Integer.valueOf(depitem)));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid department item selected. Please select a valid fee item.";
                                            sty = "danger";
                                        }
                                        sfd.setIndigeneStatusScope(depind);
                                        String tlev = "None";
                                        if (deplevel == null || deplevel.length() == 0) {
                                            tlev = "All";
                                        }
                                        if (deplevel != null && deplevel.equalsIgnoreCase("0")) {
                                            tlev = "None";
                                        }
                                        if (deplevel != null && deplevel.length() == 3) {
                                            tlev = deplevel;
                                        }
                                        sfd.setLevelScope(tlev);
                                        sfd.setOnCampusScope("None");
                                        sfd.setProgrammeScope("None");
                                        sfd.setSchoolScope("None");
                                        sfd.setSemesterAdded(semester);
                                        sfd.setSessionAdded(sessions);
                                        sfd.setStudentId("None");
                                        sess.newEntry(sfd);
                                        // Set success message in session and redirect to prevent duplicate submission
                                        session.setAttribute("successMessage", "Department scope fee setup added successfully");
                                        response.sendRedirect(request.getRequestURI());
                                        return;
                                    }

                                    String facbutton = request.getParameter("facbutton");
                                    String facdate = request.getParameter("facdate");
                                    String facind = request.getParameter("facind");
                                    String faclevel = request.getParameter("faclevel");
                                    String facd = request.getParameter("fac");
                                    String facitem = request.getParameter("facitem");
                                    String facamount = request.getParameter("facamount");
                                    if (facbutton != null && facbutton.length() > 0 && facd != null && facd.length() > 0 
                                        && facitem != null && facitem.length() > 0 && facamount != null && facamount.length() > 0) {
                                        String idx = settings.getTodaysdate().split("-")[0] + settings.generateId("", 5);
                                        Feessetup sfd = new Feessetup(idx);
                                        sfd.setAccountIt((Accounts) sess.getSingleObject(Accounts.class, 100));
                                        sfd.setAddedBy(user);
                                        try {
                                            sfd.setAmount(Double.parseDouble(facamount));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid amount entered. Please enter a valid number.";
                                            sty = "danger";
                                        }
                                        sfd.setCourseScope("None");
                                        sfd.setDateAdded(settings.getCurrentDateTime());
                                        sfd.setDepartmentScope("None");
                                        String sdate = facdate + " 00:00:00";
                                        Date parsedDate1 = null;

                                        try {
                                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            parsedDate1 = dateFormat.parse(sdate);
                                        } catch (Exception aa) {
                                        }
                                        sfd.setEffectiveFrom(parsedDate1);
                                        sfd.setFacultyScope(facd);
                                        sfd.setFeesGroupId(fg);
                                        try {
                                            sfd.setFeesItemsId((Feesitems) sess.getSingleObject(Feesitems.class, Integer.valueOf(facitem)));
                                        } catch (NumberFormatException e) {
                                            msg = "Invalid faculty item selected. Please select a valid fee item.";
                                            sty = "danger";
                                        }
                                        sfd.setIndigeneStatusScope(facind);
                                        String tlev = "None";
                                        if (faclevel == null || faclevel.length() == 0) {
                                            tlev = "All";
                                        }
                                        if (faclevel != null && faclevel.equalsIgnoreCase("0")) {
                                            tlev = "None";
                                        }
                                        if (faclevel != null && faclevel.length() == 3) {
                                            tlev = faclevel;
                                        }
                                        sfd.setLevelScope(tlev);
                                        sfd.setOnCampusScope("None");
                                        sfd.setProgrammeScope("None");
                                        sfd.setSchoolScope("None");
                                        sfd.setSemesterAdded(semester);
                                        sfd.setSessionAdded(sessions);
                                        sfd.setStudentId("None");
                                        sess.newEntry(sfd);
                                        // Set success message in session and redirect to prevent duplicate submission
                                        session.setAttribute("successMessage", "Faculty scope fee setup added successfully");
                                        response.sendRedirect(request.getRequestURI());
                                        return;
                                    }
                                %>
                                <%
                                    if (msg.length() > 0) {
                                %>
                                <div class="alert alert-<%=sty%>"><%=msg%></div>
                                <%
                                    }
                                %>
                                <div class="accordion" id="accordionExample">
                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="headingOne">
                                            <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">Faculty Scope</button>
                                        </h2>
                                        <div class="accordion-collapse collapse" id="collapseOne" aria-labelledby="headingOne" data-coreui-parent="#accordionExample" style="">
                                            <div class="accordion-body">
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover" id='dataTablefac'>
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Faculty</th>
                                                                <th>Lever</th>
                                                                <th>Indigene Status</th>
                                                                <th class="right">Amount</th>
                                                                <th>Fees Item</th>
                                                                <th>Delete</th>

                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%                                                int i = 1;
                                                                // Get all fee setup records for this fee group using the original working method
                                                                List<Feessetup> lfs = sess.getFeessetup(fg.getId(), sessions, semester, null, null);
                                                                
                                                                if (lfs == null) {
                                                                    lfs = new ArrayList<>();
                                                                }

                                                                // Faculty scope accordion: show ALL records (including "None" which means applicable to all faculties)
                                                                List<Feessetup> lfsfac = new ArrayList<>(lfs);

                                                                // Department scope accordion: show ALL records (including "None" which means applicable to all departments)
                                                                List<Feessetup> lfsdep = new ArrayList<>(lfs);

                                                                // Course scope accordion: show ALL records (including "None" which means applicable to all courses)
                                                                List<Feessetup> lfscourse = new ArrayList<>(lfs);
                                                                        
                                                                // Debug info (remove after testing)
                                                                // System.out.println("Total records: " + lfs.size() + ", Faculty: " + lfsfac.size() + ", Department: " + lfsdep.size() + ", Course: " + lfscourse.size());

                                                                for (Feessetup data : lfsfac) {
                                                                    String fac = " ";
                                                                    String dep = " ";
                                                                    String course = " ";
                                                                    try {
                                                                        if (!data.getFacultyScope().equalsIgnoreCase("None")) {
                                                                            FacultiesDirectorates dd = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, data.getFacultyScope());
                                                                            if (dd != null) {
                                                                                fac = dd.getName();
                                                                            }
                                                                        }
                                                                        if (!data.getDepartmentScope().equalsIgnoreCase("None")) {
                                                                            Departments dd = (Departments) sess.getSingleObject(Departments.class, data.getDepartmentScope());
                                                                            if (dd != null) {
                                                                                dep = dd.getName();
                                                                            }
                                                                        }
                                                                        if (!data.getCourseScope().equalsIgnoreCase("None")) {
                                                                            Courses dd = (Courses) sess.getSingleObject(Courses.class, data.getCourseScope());
                                                                            if (dd != null) {
                                                                                course = dd.getName();
                                                                            }
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=fac%></td>
                                                                <td><%=data.getLevelScope()%></td>
                                                                <td><%=data.getIndigeneStatusScope()%></td>
                                                                <td class="right"><%=settings.formatno.format(data.getAmount())%></td>
                                                                <td><%=data.getFeesItemsId().getName()%></td>
                                                                <td class="right"><a href="/admin_fees_details?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Delete</a></td>
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

                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="headingTwo">
                                            <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Department Scope</button>
                                        </h2>
                                        <div class="accordion-collapse collapse" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                            <div class="accordion-body">
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover" id='dataTabledep'>
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Department</th>
                                                                <th>Lever</th>
                                                                <th>Indigene Status</th>
                                                                <th class="right">Amount</th>
                                                                <th>Fees Item</th>
                                                                <th>Delete</th>

                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%                                                i = 1;
                                                                for (Feessetup data : lfsdep) {
                                                                    String fac = " ";
                                                                    String dep = " ";
                                                                    String course = " ";
                                                                    try {
                                                                        if (!data.getFacultyScope().equalsIgnoreCase("None")) {
                                                                            FacultiesDirectorates dd = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, data.getFacultyScope());
                                                                            if (dd != null) {
                                                                                fac = dd.getCode();
                                                                            }
                                                                        }
                                                                        if (!data.getDepartmentScope().equalsIgnoreCase("None")) {
                                                                            Departments dd = (Departments) sess.getSingleObject(Departments.class, data.getDepartmentScope());
                                                                            if (dd != null) {
                                                                                dep = dd.getCode();
                                                                            }
                                                                        }
                                                                        if (!data.getCourseScope().equalsIgnoreCase("None")) {
                                                                            Courses dd = (Courses) sess.getSingleObject(Courses.class, data.getCourseScope());
                                                                            if (dd != null) {
                                                                                course = dd.getName();
                                                                            }
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=dep%></td>
                                                                <td><%=data.getLevelScope()%></td>
                                                                <td><%=data.getIndigeneStatusScope()%></td>
                                                                <td class="right"><%=settings.formatno.format(data.getAmount())%></td>
                                                                <td><%=data.getFeesItemsId().getName()%></td>
                                                                <td class="right"><a href="/admin_fees_details?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Delete</a></td>
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

                                    <div class="accordion-item">
                                        <h2 class="accordion-header" id="headingThree">
                                            <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Course Scope</button>
                                        </h2>
                                        <div class="accordion-collapse collapse" id="collapseThree" aria-labelledby="headingThree" data-coreui-parent="#accordionExample" style="">
                                            <div class="accordion-body">
                                                <div class="table-responsive-sm">
                                                    <table class="table table-striped table-hover" id='dataTablecourse'>
                                                        <thead>
                                                            <tr>
                                                                <th class="center">#</th>
                                                                <th>Course</th>
                                                                <th>Lever</th>
                                                                <th>Indigene Status</th>
                                                                <th class="right">Amount</th>
                                                                <th>Fees Item</th>
                                                                <th>Delete</th>

                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%                                                i = 1;
                                                                for (Feessetup data : lfscourse) {
                                                                    String fac = " ";
                                                                    String dep = " ";
                                                                    String course = " ";
                                                                    try {
                                                                        if (!data.getFacultyScope().equalsIgnoreCase("None")) {
                                                                            FacultiesDirectorates dd = (FacultiesDirectorates) sess.getSingleObject(FacultiesDirectorates.class, data.getFacultyScope());
                                                                            if (dd != null) {
                                                                                fac = dd.getCode();
                                                                            }
                                                                        }
                                                                        if (!data.getDepartmentScope().equalsIgnoreCase("None")) {
                                                                            Departments dd = (Departments) sess.getSingleObject(Departments.class, data.getDepartmentScope());
                                                                            if (dd != null) {
                                                                                dep = dd.getCode();
                                                                            }
                                                                        }
                                                                        if (!data.getCourseScope().equalsIgnoreCase("None")) {
                                                                            Courses dd = (Courses) sess.getSingleObject(Courses.class, data.getCourseScope());
                                                                            if (dd != null) {
                                                                                course = dd.getName();
                                                                            }
                                                                        }
                                                                    } catch (Exception k) {
                                                                    }
                                                            %>
                                                            <tr>
                                                                <td class="center"><%=i%></td>
                                                                <td><%=course%></td>
                                                                <td><%=data.getLevelScope()%></td>
                                                                <td><%=data.getIndigeneStatusScope()%></td>
                                                                <td class="right"><%=settings.formatno.format(data.getAmount())%></td>
                                                                <td><%=data.getFeesItemsId().getName()%></td>
                                                                <td class="right"><a href="/admin_fees_details?id=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" class="btn btn-danger btn-sm">Delete</a></td>
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
                new DataTable('#dataTablefac', {
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
                
                new DataTable('#dataTabledep', {
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
                
                new DataTable('#dataTablecourse', {
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