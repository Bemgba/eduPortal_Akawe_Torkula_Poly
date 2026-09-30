<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

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
        <title><%=settings.productName%> - My Documents</title>
        
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
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">My Documents</h2>
                </div>
            </header>

            <!-- JavaScript to update the page title -->
            <script>
                // Get the dynamic title from a JSP variable
                var newTitle = "<%= "Documents for " + std.getSurname() + " " + std.getOthernames()%>";
                // Update the page title
                document.title = newTitle;
                
                
            </script>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <%
                        List<Uploadeddocuments> ldocs = sess.getUploadeddocumentsByRegno(std.getId());

                    %>
                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>Total  of <%=ldocs.size()%> Documents found</strong></div>
                            <div class="card-body">

                                <div class="table-responsive-sm">
                                    <table class="table table-striped" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Doc. Name</th>
                                                <th>Preview</th>
                                                <th>Date Added</th>
                                                <th>Added By</th>
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
                                                 <%
                                                    String udate="";
                                                    String uploadedby="Admin";
                                                    try{
                                                    udate = settings.formatDate(data.getDateAdded());
                                                        }catch(Exception k){}
                                                        if(data.getUploadedBy().equalsIgnoreCase(user.getId())){
                                                        uploadedby="Me";
                                                        }
                                                    %>
                                                <td><%=udate%></td>
                                                <td><%=uploadedby%></td>
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
                    <!-- /.row-->
                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

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