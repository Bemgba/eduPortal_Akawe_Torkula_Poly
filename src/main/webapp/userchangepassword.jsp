<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="jakarta.fileupload.FileItem"%>
<%@page import="jakarta.fileupload.disk.DiskFileItemFactory"%>
<%@page import="jakarta.fileupload.servlet.ServletFileUpload"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
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
        <title><%=settings.productName%> - Settings</title>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>


        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%
                    if (user.getDefaultRole().getRoleType().equalsIgnoreCase("STAFF_PUBLIC")) {
                %>
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <%                } else if (user.getDefaultRole().getRoleType().equalsIgnoreCase("STUDENTS")) {
                %>
                <%@include file="WEB-INF/jspf/header_student.jspf"%>
                <%                } else if (user.getDefaultRole().getRoleType().equalsIgnoreCase("APPLICANTS")) {
                %>
                <%@include file="WEB-INF/jspf/header_applicant.jspf"%>
                <%                    } else {

                    }
                %>

                <div class="container-fluid px-4">
                    <h2 class="title">Settings</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="card">
                        <div class="row g-0">
                            <div class="col-md-4">
                                <%
                                    String imgurl = "assets/img/noperson.png";
                                    Passports pp = null;
                                    try {
                                        pp = sess.getPassports(user.getId());
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
                                <img class="card-img"  src="<%=imgurl%>" style="height: 250px; width: auto" alt=""/>
                            </div>
                            <div class="col-md-8">
                                <div class="card-body">
                                    <%
                                        try {
                                    %>
                                    <table class="table table-striped">
                                        <tbody>
                                            <tr>
                                                <th width="40%">Username</th>
                                                <td width="60%"><%=user.getUsername()%></td>

                                            </tr>
                                            <tr>
                                                <th>Login Email</th>
                                                <td><%=user.getEmail()%></td>
                                            </tr>
                                            <tr>
                                                <th>Role</th>
                                                <td><%=user.getDefaultRole().getName()%></td>
                                            </tr>
                                            <tr>
                                                <th>Full Name</th>
                                                <td><%=sess.getFullname(user)%></td>
                                            </tr>



                                        </tbody>
                                    </table>
                                    <%
                                        } catch (Exception k) {
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="height: 20px"></div>


                    <div class="card mb-3">
                        <%                
                            byte[] file = null;
                            String button = null;
                            String ext = "";

                            String UPLOAD_DIRECTORY = settings.documentroot;

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
                                            if (fieldName.equalsIgnoreCase("passportedit")) {
                                                try {
                                                    ext = fileName.substring(fileName.lastIndexOf("."), fileName.length());
                                                } catch (Exception d) {
                                                }
                                                file = item.get();
                                            }
                                        } else {
                                            String fieldName = item.getFieldName();
                                            String fieldValue = item.getString();

                                            if (fieldName.equalsIgnoreCase("passportbutton")) {
                                                button = fieldValue;
                                            }
                                        }
                                    }

                                } catch (Exception ex) {
                                }
                            }
                            if (button != null && file != null) {
                                if ((ext.contains(".jpg") || ext.contains(".jpeg") || ext.contains(".png"))) {
                                    String filePath = UPLOAD_DIRECTORY + File.separator + user.getId() + ext;
                                    settings.resizeImage(file, settings.PASSPORT_WIDTH, settings.PASSPORT_HEIGHT, filePath);
                                    sess.savePassport(user.getId(), "passports/" + user.getId() + ext);
                                    //item.delete();
                                    msg = "Passport has been added successfully";
                                    sty = "success";
                                } else {
                                    sty = "danger";
                                    msg = "No registration Number or specified image format";
                                }

                            }

                        %>

                        <%                            String oldpw = request.getParameter("oldpw");
                            String newpw1 = request.getParameter("newpw1");
                            String newpw2 = request.getParameter("newpw2");
                            String butt2 = request.getParameter("passwordchangebottun");
                            if (butt2 != null && oldpw != null && newpw1 != null && newpw2 != null) {
                                try {
                                    oldpw = oldpw.toLowerCase();
                                    newpw1 = newpw1.toLowerCase();
                                    newpw2 = newpw2.toLowerCase();
                                    if (user.getPassword().equals(oldpw)) {
                                        if (newpw1.equals(newpw2)) {
                                            user.setPassword(newpw2);
                                            sess.updatePassword(user.getId(), newpw1);
                                            sty = "success";
                                            msg = "The new password has been updated successfully";
                                        } else {
                                            sty = "danger";
                                            msg = "The new password did not match the confirm one. Kindly reprocess your operation";
                                        }
                                    } else {
                                        sty = "danger";
                                        msg = "Old password did not match the existing one. If you have your email setup, you can use the 'Forgot Password' link on the login page or you can visit the Directorate of ICT for assistance";
                                    }
                                } catch (Exception ka) {
                                }
                            }
                        %>

                        <%                if (msg.length() > 0) {
                        %>
                        <div class="alert alert-<%=sty%>"><%=msg%></div>
                        <%
                            }
                        %>

                        <div class="card-header">Edit Settings</div>
                        <div class="card-body">
                            <div class="tab-content rounded-bottom">
                                <div class="tab-pane p-3 active preview" role="tabpanel" id="preview-1000">
                                    <div class="accordion" id="accordionExample">

                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="headingOne">
                                                <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">Change Passport</button>
                                            </h2>
                                            <div class="accordion-collapse collapse" id="collapseOne" aria-labelledby="headingOne" data-coreui-parent="#accordionExample" style="">
                                                <div class="accordion-body">
                                                    <%
                                                        if (pp != null && user.getDefaultRole().getRoleType().equalsIgnoreCase("STUDENTS")) {
                                                    %>
                                                    <div class="alert alert-warning">You are not allowed to edit your passport. If you must do this kindly contact the Directorate of ICT</div>
                                                    <%
                                                    } else {
                                                    %>
                                                    <form action="" method="POST" role="form" name="uploadpassport" enctype="multipart/form-data">
                                                        <div class="input-group mb-3"><span class="input-group-text">
                                                                Select Passport  
                                                            </span>
                                                            <input class="form-control" type="file" name="passportedit" required="" accept=".jpg, .png, .jpeg">
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-12">
                                                                <input type="submit" name="passportbutton" class="btn btn-primary px-4" value="Upload"/>
                                                            </div>
                                                        </div>
                                                    </form>
                                                    <%
                                                        }
                                                    %>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="headingTwo">
                                                <button class="accordion-button collapsed" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Change Password</button>
                                            </h2>
                                            <div class="accordion-collapse collapse" id="collapseTwo" aria-labelledby="headingTwo" data-coreui-parent="#accordionExample" style="">
                                                <div class="accordion-body">
                                                    <form action="" method="POST" role="form" name="changepasswordform">
                                                        <div class="input-group mb-4"><span class="input-group-text">
                                                                Old Password
                                                            </span>
                                                            <input class="form-control" type="password" required="" name="oldpw">
                                                        </div>
                                                        <div class="input-group mb-4"><span class="input-group-text">
                                                                New Password
                                                            </span>
                                                            <input class="form-control" type="password" minlength="8" required="" name="newpw1">
                                                        </div>
                                                        <div class="input-group mb-4"><span class="input-group-text">
                                                                Confirm Password
                                                            </span>
                                                            <input class="form-control" type="password" minlength="8" required="" name="newpw2" >
                                                        </div>

                                                        <div class="row">
                                                            <div class="col-12">
                                                                <input type="submit" name="passwordchangebottun" class="btn btn-primary px-4" value="Update"/>
                                                            </div>

                                                        </div>

                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="headingThree">
                                                <button class="accordion-button" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseThree" aria-expanded="true" aria-controls="collapseThree">Change Login Email</button>
                                            </h2>
                                            <div class="accordion-collapse collapse" id="collapseThree" aria-labelledby="headingThree" data-coreui-parent="#accordionExample" style="">
                                                <div class="accordion-body">
                                                    <div class="alert alert-warning">
                                                        This features has been disabled for security reasons. You can however contact the Directorate of ICT to have your login username changed to your preferred email address
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