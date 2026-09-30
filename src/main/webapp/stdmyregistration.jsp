<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Comparator"%>
<%@page import="java.util.Optional"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
        return;
    }
%>


<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - My Registrations</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">My Registrations</h2>
                </div>
            </header>

            <%                    String id = request.getParameter("id");
                if (id != null && id.length() > 0) {
                    final String sid = settings.decryptText(id);
                    Studentprogression sp = null;
                    try {
                        Optional<Studentprogression> rego = prograssion.stream()
                                .filter(person -> person.getId().equalsIgnoreCase(sid))
                                .findFirst();
                        sp = rego.get();
                    } catch (Exception k) {
                        k.printStackTrace();
                    }
                    if (sp != null) {
                        try {
                            session.setAttribute("sp", sp);
                            response.sendRedirect("/std_registration");
                            return;
                        } catch (Exception k) {
            %>
            <script>
                window.location.href = '/std_registration';
            </script>
            <%
                        }
                    }
                }
            %>
            <script>
                // Get the dynamic title from a JSP variable
                var newTitle = "<%= std != null ? ("Registration history for " + std.getSurname() + " " + std.getOthernames()) : "Registration History"%>";
                // Update the page title
                document.title = newTitle;
            </script>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <%
                        String lab = "";

                        Map<String, Long> regitems = prograssion.stream()
                                .collect(Collectors.groupingBy(Studentprogression::getRegistrationStatus, Collectors.counting()));

                        // Print the result
                        for (Map.Entry<String, Long> entry : regitems.entrySet()) {
                            lab += settings.getRegistrationStatusLabel(entry.getKey()) + " (" + entry.getValue() + ") , ";
                        }
                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong><%=lab%></strong></div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id="dataTable">
                                        <thead>
                                        <th class="center">SNO</th>
                                        <th>Session</th>
                                        <th>Semester</th>
                                        <th>Level</th>
                                        <th>Registration Status</th>
                                        <th>Date Registered</th>
                                        <th>Details</th>
                                        </thead>
                                        <tbody>
                                            <%
                                                int sn = 1;
                                                List<Studentprogression> prograssionSorted = prograssion.stream()
                                                        .sorted(Comparator.comparing(Studentprogression::getSessionAdded)
                                                                .thenComparing(Studentprogression::getSemesterAdded)
                                                                .reversed())
                                                        .collect(Collectors.toList());

                                                for (Studentprogression progress : prograssionSorted) {
                                            %>
                                            <tr>
                                                <td class="center"><%=sn%></td>
                                                <td><%=progress.getSessionAdded()%></td>
                                                <td><%=progress.getSemesterAdded()%></td>
                                                <td><%=progress.getLevelAdded()%></td>
                                                <td><%=settings.getRegistrationStatusLabel(progress.getRegistrationStatus())%></td>
                                                <td><%=settings.formatDate(progress.getDateRegistered())%></td>
                                                <td><a class="btn btn-primary btn-sm" href="/my_reg?id=<%=settings.encodeUrl(settings.encryptText(progress.getId()))%>">More</a></td>
                                            </tr>
                                            <%

                                                    sn++;
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div> 
                    <!-- /.row-->
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
        <script>
        </script>

    </body>
</html>