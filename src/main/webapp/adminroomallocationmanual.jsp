<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="com.mnl.bsum.bsuportal.entities.Hostelrooms"%>
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
        <title><%=settings.productName%> - Manual Rool Allocation</title>

        <script>
            var req;
            var isIE;
            var country;
            var states;
            var countryval;
            var statesval;
            var lga;

            function init() {

            }
            function initRequest() {
                if (window.XMLHttpRequest) {
                    if (navigator.userAgent.indexOf('MSIE') != -1) {
                        isIE = true;
                    }
                    return new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    isIE = true;
                    return new ActiveXObject("Microsoft.XMLHTTP");
                }
            }

            function loadStates() {
                var sel2 = document.getElementById("country");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadState&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadStates;
                req.send(null);
            }

            function callloadStates() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("states").innerHTML = req.responseText;
                    }
                }
            }

            function loadLgas() {
                var sel2 = document.getElementById("states");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadlga&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadLgas;
                req.send(null);
            }

            function callloadLgas() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("lgas").innerHTML = req.responseText;
                    }
                }
            }

            function loadStatesEdit() {
                var sel2 = document.getElementById("countryedit");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadState&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadStatesEdit;
                req.send(null);
            }

            function callloadStatesEdit() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("statesedit").innerHTML = req.responseText;
                    }
                }
            }

            function loadLgasEdit() {
                var sel2 = document.getElementById("statesedit");
                var countryval = sel2.options[sel2.selectedIndex].value;

                var url = "AjaxServlet?action=loadlga&id=" + escape(countryval);
                req = initRequest();
                req.open("GET", url, true);
                req.onreadystatechange = callloadLgasEdit;
                req.send(null);
            }

            function callloadLgasEdit() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        document.getElementById("lgasedit").innerHTML = req.responseText;
                    }
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
                    <h2 class="title">Manual Room Allocation</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>Enter Student number</strong></div>
                            <div class="card-body">
                                <%    String stdno = request.getParameter("regno");
                                    Students prd = null;
                                    String submit = request.getParameter("submit");
                                    if (submit != null && stdno != null && stdno.length() > 0) {
                                        stdno = stdno.toLowerCase();
                                        prd = sess.getStudentsById(stdno);
                                        if (prd != null) {
                                            session.setAttribute("stdc", prd);

                                        } else {
                                            session.setAttribute("stdc", null);
                                %>
                                <div class="alert alert-danger">No student record found matching <%=stdno%></div>
                                <%
                                        }
                                    }
                                %>

                                <%
                                    String roomno = request.getParameter("roomno");
                                    String stdid = request.getParameter("stdid");
                                    String sessiond = request.getParameter("sessiond");
                                    String submit2 = request.getParameter("button");
                                    if (submit2 != null && roomno != null && roomno.length() > 0 && stdid != null && stdid.length() > 0) {
                                        Students stz = sess.getStudentsById(stdid);
                                        if (stz != null) {
                                            sess.reserveRoomSingle(stdid, sessiond, roomno);

                                %>
                                <div class="alert alert-success">Student has been successfully allocated</div>
                                <%                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify2">
                                        <div class="tab-content rounded-bottom">
                                            <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1004">

                                                <div class="mb-3 row">
                                                    <label class="col-sm-2 col-form-label" for="payerno">Student's Number</label>
                                                    <div class="col-sm-7">
                                                        <input class="form-control" id="regno" type="text" name="regno" required="">
                                                    </div>
                                                    <div class="col-sm-3">

                                                        <button name="submit" class="btn btn-success mb-3" type="submit">View</button>                       
                                                    </div></div>
                                            </div>
                                        </div>
                                    </form>



                                </div>

                            </div>
                        </div>
                    </div>

                    <%
                        Students stdk = null;
                        try {
                            stdk = (Students) session.getAttribute("stdc");
                        } catch (Exception k) {
                        }
                        if (stdk != null) {
                            String regno = stdk.getMatricNo() != null ? stdk.getMatricNo() : stdk.getReligion();
                            regno = regno.toUpperCase();
                    %>

                    <div class="col-12">
                        <div class="card mb-4">

                            <div class="card-header"><strong>Room Allocation For <%=regno%></strong></div>
                            <div class="card-body">
                                <form action='' method='post' name="verify">
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Reg No
                                        </span>
                                        <input type="text" class="form-control" readonly="" name="surname" value="<%=regno%>"/>

                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Full Name
                                        </span>
                                        <input type="text" class="form-control" readonly="" name="othernames" value="<%=stdk.getSurname() + " " + stdk.getOthernames()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Course
                                        </span>
                                        <input type="text" class="form-control" readonly="" name="personalemail" value="<%=stdk.getCourseId().getName()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Level
                                        </span>
                                        <input type="email" class="form-control" name="uniemail" value="<%=stdk.getCurrentClass()%>"/>
                                    </div>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            State of Origin
                                        </span>
                                        <input type="text" class="form-control" readonly="" name="phoneno" value="<%=stdk.getStateOfOrigin() != null ? stdk.getStateOfOrigin().getName() : ""%>"/>
                                    </div>
                                    <%

                                        Sessionmanager sm = sess.getCurrentSessionManagerBySchoolAndOperation(stdk.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
                                        if (sm != null) {
                                            List<Payments> li = sess.getPaymentsByRegnoSessSemFeesgroup(stdk.getId(), "10160", sm.getName(), "Session");
                                            if (!li.isEmpty()) {
                                                Hostelallocation all = sess.getHostelallocation(stdk.getId(), sm.getName());
                                                if (all == null) {
                                                    Hostelapplication app = sess.getHostelapplication(stdk.getId(), sm.getName());
                                                    if (app != null) {

                                    %>
                                    <input type="hidden" name="stdid" value="<%=stdk.getId()%>"/>
                                    <input type="hidden" name="sessiond" value="<%=sm.getName()%>"/>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Select Room
                                        </span>
                                        <select class="form-select" name="roomno" id="roomno">
                                            <%
                                                List<Hostelallocation> datal = sess.getEmptyReservedRooms(sm.getName(), stdk.getGender());
                                                for (Hostelallocation data : datal) {
                                            %>
                                            <option value="<%=data.getId()%>"><%=data.getHostelRoomId().getRoomNo()%> of <%=data.getHostelRoomId().getHostelId().getName()%></option>
                                            <%

                                                }
                                            %>


                                        </select>
                                    </div>


                                    <div class="row">
                                        <div class="col-12">
                                            <input type="submit" name="button" class="btn btn-primary px-4" value="Allocate"/>
                                        </div>

                                    </div>  
                                    <%
                                        }
                                    } else {
                                        if (all.getStatus().equalsIgnoreCase("RESERVED")) {
                                    %>
                                    <div class="alert alert-warning">This Student has already been reserved <%=all.getHostelRoomId().getRoomNo()%> of <%=all.getHostelRoomId().getHostelId().getName()%>. Payment should be made to complete allocation.
                                        <p>You can however go ahead and manually change reservation room here</p></div>

                                    <input type="hidden" name="stdid" value="<%=stdk.getId()%>"/>
                                    <input type="hidden" name="sessiond" value="<%=sm.getName()%>"/>
                                    <div class="input-group mb-4"><span class="input-group-text">
                                            Select Room
                                        </span>
                                        <select class="form-select" name="roomno" id="roomno">
                                            <%
                                                List<Hostelallocation> datal = sess.getEmptyReservedRooms(sm.getName(), stdk.getGender());
                                                for (Hostelallocation data : datal) {
                                            %>
                                            <option value="<%=data.getId()%>"><%=data.getHostelRoomId().getRoomNo()%> of <%=data.getHostelRoomId().getHostelId().getName()%></option>
                                            <%

                                                }
                                            %>


                                        </select>
                                    </div>


                                    <div class="row">
                                        <div class="col-12">
                                            <input type="submit" name="button" class="btn btn-primary px-4" value="Allocate"/>
                                        </div>

                                    </div>  

                                    <%
                                        }
                                        if (all.getStatus().equalsIgnoreCase("ALLOCATED")) {
                                    %>
                                    <div class="alert alert-danger">This Student has already been allocated <%=all.getHostelRoomId().getRoomNo()%> of <%=all.getHostelRoomId().getHostelId().getName()%></div>
                                    <%
                                            }
                                        }
                                    } else {
                                    %>
                                    <div class="alert alert-danger">No Hostel Application payment found!</div>
                                    <%
                                            }
                                        }
                                    %>



                                </form>

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
        </script>
    </body>
</html>