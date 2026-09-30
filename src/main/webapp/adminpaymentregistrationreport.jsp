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
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Payment/Registration Report</title>

        <script>
            
            // Load sessions dynamically when school changes
            async function loadSessions() {
                const schoolSelect = document.getElementById('schools');
                const sessionsSelect = document.getElementById('sessions');
                const schoolId = schoolSelect.value;
                
                if (!schoolId || schoolId === '') {
                    sessionsSelect.innerHTML = '<option value="">Select School First</option>';
                    return;
                }
                
                // Show loading state
                sessionsSelect.innerHTML = '<option value="">Loading sessions...</option>';
                sessionsSelect.disabled = true;
                
                try {
                    const url = "AjaxServlet?action=loadSessions&schoolId=" + encodeURIComponent(schoolId);
                    const response = await fetch(url);
                    
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    
                    const html = await response.text();
                    sessionsSelect.innerHTML = html;
                    sessionsSelect.disabled = false;
                    
                } catch (error) {
                    console.error("Error loading sessions:", error);
                    sessionsSelect.innerHTML = '<option value="">Error loading sessions. Please try again.</option>';
                    sessionsSelect.disabled = false;
                }
            }

            async function viewStudentsa(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsa&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "deta").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }

            async function viewStudentsb(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsb&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detb").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsc(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsc&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detc").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsd(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsd&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detd").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentse(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentse&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "dete").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsf(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsf&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detf").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsg(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsg&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detg").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }


            async function viewStudentsj(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsj&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detj").innerHTML = respText;     // Use `id2` here
                } catch (error) {
                    console.error("Error updating record:", error);
                }
            }
            async function viewStudentsk(details) {
                try {
                    const url = "AjaxServlet?action=viewStudentsk&id2=" + escape(details);
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }
                    const respText = await response.text();
                    document.getElementById(details + "detk").innerHTML = respText;     // Use `id2` here
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
                    <h2 class="title">Payment/Registration Report</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Select query criteria</strong></div>
                            <div class="card-body">
                                <%                                    String schools = request.getParameter("schools");
                                    String fac = request.getParameter("fac");
                                    String sessions = request.getParameter("sessions");
                                    String semester = request.getParameter("semester");
                                    String msg = "";
                                    String sty = "danger";
                                    String submit = request.getParameter("button2");
                                    List<Studentprogression> progression = new ArrayList();
                                    if (submit != null && schools != null && schools.length() > 0) {

                                    }
                                %>
                                <div class="example">
                                    <form name="edit" method="post" action="">
                                        <div class="input-group mb-3"><span class="input-group-text">
                                                Select School   
                                            </span>
                                            <select class="form-select" name="schools" id="schools" onchange="loadSessions()">
                                                <option value="">Select School</option>
                                                <%                                                            try {
                                                        List<Schools> lsch = sess.getAllSchoos();
                                                        for (Schools prod : lsch) {
                                                            String selected = (schools != null && schools.equals(prod.getId())) ? "selected" : "";
                                                %>
                                                <option value="<%=prod.getId()%>" <%=selected%>> <%=prod.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Faculty 
                                            </span>
                                            <select class="form-select" name="fac" id="fac">
                                                <option value="">Select Faculty</option>
                                                <%                                                            try {
                                                        List<FacultiesDirectorates> lsch = sess.getAllFacultiesDirectorates();
                                                        for (FacultiesDirectorates prod : lsch) {
                                                            String selected = (fac != null && fac.equals(prod.getId())) ? "selected" : "";
                                                %>
                                                <option value="<%=prod.getId()%>" <%=selected%>> <%=prod.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>

                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Session
                                            </span>
                                            <select class="form-select" name="sessions" id="sessions">
                                                <option value="">Select School First</option>
                                                <%
                                                    // Dynamic session loading based on selected school
                                                    if (schools != null && !schools.isEmpty()) {
                                                        try {
                                                            Sessionmanager smx = sess.getCurrentSessionManagerBySchoolAndOperation(schools, "REGISTRATION");
                                                            
                                                            if (smx != null) {
                                                                String start = settings.listSession;
                                                                String currsess = smx.getName();
                                                                
                                                                while (currsess.compareToIgnoreCase(start) >= 0) {
                                                                    String selected = (sessions != null && sessions.equals(currsess)) ? "selected" : "";
                                                %>
                                                <option value="<%=currsess%>" <%=selected%>><%=currsess%></option>
                                                <%
                                                                    currsess = settings.getSessionBefore(currsess);
                                                                }
                                                            } else {
                                                %>
                                                <option value="">No sessions available for this school</option>
                                                <%
                                                            }
                                                        } catch (Exception k) {
                                                %>
                                                <option value="">Error loading sessions</option>
                                                <%
                                                            k.printStackTrace();
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4"><span class="input-group-text">
                                                Select Semester
                                            </span>
                                            <select class="form-select" name="semester" id="semester">
                                                <option value="">Select Semester</option>
                                                <%
                                                    String semSelected1 = (semester != null && semester.equals("First")) ? "selected" : "";
                                                    String semSelected2 = (semester != null && semester.equals("Second")) ? "selected" : "";
                                                %>
                                                <option value="First" <%=semSelected1%>>First Semester</option>
                                                <option value="Second" <%=semSelected2%>>Second Semester</option>

                                            </select>
                                        </div>
                                        <div class="row">
                                            <div class="col-6">
                                                <input type="submit" name="button2" class="btn btn-success px-4" value="View Records"/>
                                            </div>
                                        </div>

                                    </form>
                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        if (submit != null && schools != null && schools.length() > 0) {
                            List<StudentStats> studentStats = sess.getAggregatedStudentStats(schools, fac, sessions, semester);
                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header">
                                <strong><%= studentStats.size()%> records found</strong>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive-sm" style="max-height: 400px; overflow-y: auto;">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Department</th>
                                                <th>Course</th>
                                                <th>Level</th>
                                                <th>Total Students</th>
                                                <th>Indigene Students</th>
                                                <th>Non Indigene Students</th>
                                                <th>Paid</th>
                                                <th>Paid Indigene</th>
                                                <th>Paid Non Indigene</th>
                                                <th>Not Paid</th>
                                                <th>Not Paid Indigene</th>
                                                <th>Not Paid Non Indigene</th>
                                                <th>Registered</th>
                                                <th>Not Registered</th>
                                                <th>Per Paid</th>
                                                <th>Per Registered</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int i = 1;
                                                for (StudentStats data : studentStats) {
                                                    double perpaid = 0;
                                                    double perreg = 0;
                                                    try {
                                                        perpaid = (double) data.getPaidStudents() * 100 / data.getTotalStudents();
                                                        perpaid = settings.Round(perpaid, 2);
                                                        perreg = (double) data.getRegisteredStudents() * 100 / data.getTotalStudents();
                                                        perreg = settings.Round(perreg, 2);
                                                    } catch (Exception k) {
                                                    }
                                                    String idu = data.getCourseId() + "_" + data.getLevel() + "_" + sessions.replaceAll("/", "_") + "_" + semester;

                                            %>
                                            <tr>
                                                <td><%= i++%></td>
                                                <td><%= data.getDepartmentName()%></td>
                                                <td><%= data.getCourseName()%></td>
                                                <td><%= data.getLevel()%></td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>a" 
                                                       onclick="viewStudentsa('<%= idu%>')">
                                                        <%= data.getTotalStudents()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>a" tabindex="-1" aria-labelledby="<%=idu%>laba" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>laba">Total Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>deta">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>b" 
                                                       onclick="viewStudentsb('<%= idu%>')">
                                                        <%= data.getIndigeneStudents()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>b" tabindex="-1" aria-labelledby="<%=idu%>labb" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labb">Total Indigene Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detb">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>c" 
                                                       onclick="viewStudentsc('<%= idu%>')">
                                                        <%= data.getNonIndigeneStudents()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>c" tabindex="-1" aria-labelledby="<%=idu%>labc" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labc">Total Non-Indigene Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detc">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>d" 
                                                       onclick="viewStudentsd('<%= idu%>')">
                                                        <%= data.getPaidStudents()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>d" tabindex="-1" aria-labelledby="<%=idu%>labd" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labd">Total Paid Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detd">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>e" 
                                                       onclick="viewStudentse('<%= idu%>')">
                                                        <%= data.getPaidIndigene()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>e" tabindex="-1" aria-labelledby="<%=idu%>labe" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labe">Total Paid Indigene Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>dete">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right"><a href="#" 
                                                                          class="float-end"
                                                                          data-coreui-toggle="modal" 
                                                                          data-coreui-target="#<%=idu%>f" 
                                                                          onclick="viewStudentsf('<%= idu%>')">
                                                        <%= data.getPaidNonIndigene()%>
                                                    </a>

                                                    <div class="modal fade" id="<%=idu%>f" tabindex="-1" aria-labelledby="<%=idu%>labf" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labf">Total Paid Indigene Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detf">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>g" 
                                                       onclick="viewStudentsg('<%= idu%>')" 
                                                       >
                                                        <%= data.getNotPaidStudents()%>
                                                    </a> 

                                                    <div class="modal fade" id="<%=idu%>g" tabindex="-1" aria-labelledby="<%=idu%>labg" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labg">Total Unpaid Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detg">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </td>
                                                <td class="text-right"><%= data.getNotPaidIndigene()%></td>
                                                <td class="text-right"><%= data.getNotPaidNonIndigene()%></td>
                                                <td class="text-right">
                                                    <a href="#" 
                                                       class="float-end"
                                                       data-coreui-toggle="modal" 
                                                       data-coreui-target="#<%=idu%>j" 
                                                       onclick="viewStudentsj('<%= idu%>')" 
                                                       >
                                                        <%= data.getRegisteredStudents()%>
                                                    </a> 

                                                    <div class="modal fade" id="<%=idu%>j" tabindex="-1" aria-labelledby="<%=idu%>labj" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labj">Total Registered Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detj">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-right"><a href="#" 
                                                                          class="float-end"
                                                                          data-coreui-toggle="modal" 
                                                                          data-coreui-target="#<%=idu%>k" 
                                                                          onclick="viewStudentsk('<%= idu%>')" 
                                                                          >
                                                        <%= data.getNotRegisteredStudents()%>
                                                    </a> 

                                                    <div class="modal fade" id="<%=idu%>k" tabindex="-1" aria-labelledby="<%=idu%>labk" aria-hidden="true">
                                                        <div class="modal-dialog modal-xl modal-dialog-scrollable">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title" id="<%=idu%>labk">Total Non-Registered Students in <%= data.getCourseName()%> <%=data.getLevel()%> Level</h5>
                                                                    <button type="button" class="btn-close" data-coreui-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body">

                                                                    <div id="<%=idu%>detk">Loading...</div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-danger" data-coreui-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </td>
                                                <td class="text-right"><%= perpaid%></td>
                                                <td class="text-right"><%= perreg%></td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% }%>


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