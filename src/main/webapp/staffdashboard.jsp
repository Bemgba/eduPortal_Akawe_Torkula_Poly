<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%   
 if (user == null) {
        response.sendRedirect("/");
    }    
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title><%=settings.productName%> - Dashboard</title>
        
         <script>
        function filterCards() {
            let input = document.getElementById('cardSearchInput').value.toLowerCase();
            let cards = document.querySelectorAll('.col-12');
            
            cards.forEach(card => {
                let text = card.textContent.toLowerCase();
                if (text.includes(input)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // Show login success toast
        function showLoginSuccessToast() {
            // Check if this is a fresh login (not a page refresh)
            const urlParams = new URLSearchParams(window.location.search);
            const loginSuccess = urlParams.get('login_success');
            
            if (loginSuccess === 'true') {
                // Create and show toast
                const toastHtml = `
                    <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="loginSuccessToast">
                        <div class="d-flex">
                            <div class="toast-body">
                                <i class="fas fa-check-circle me-2"></i>
                                Welcome back! Login successful.
                            </div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-coreui-dismiss="toast" aria-label="Close"></button>
                        </div>
                    </div>
                `;
                
                // Add toast to page
                let toastContainer = document.getElementById('toast-container');
                if (!toastContainer) {
                    toastContainer = document.createElement('div');
                    toastContainer.id = 'toast-container';
                    toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
                    toastContainer.style.zIndex = '1055';
                    document.body.appendChild(toastContainer);
                }
                
                toastContainer.innerHTML = toastHtml;
                
                // Show toast using CoreUI
                const toastElement = document.getElementById('loginSuccessToast');
                const toast = new coreui.Toast(toastElement, {
                    autohide: true,
                    delay: 4000
                });
                toast.show();
                
                // Clean up URL to remove login_success parameter
                const newUrl = window.location.pathname;
                window.history.replaceState({}, document.title, newUrl);
            }
        }
        
        // Run when page loads
        document.addEventListener('DOMContentLoaded', showLoginSuccessToast);
    </script>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>


        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Dashboard</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="card">
                        <div class="row g-0">
                            <div class="col-md-4"><img class="card-img" src="assets/img/full.jpg" alt=""></div>
                            <div class="col-md-8">
                                <div class="card-body">
                                    <%                                   
                                        String logins = "No previos Login";
                                        String deptd = "Not assigned";
                                        String rank="";
                                        
                                        try {
                                            rank = stf.getPositionId().getName();
                                             deptd = stf.getDepartmentId().getName();
                                        } catch (Exception k) {
                                        }
                                        try {
                                            List<Userlogins> logn = sess.getUserlogins(user.getId());
                                            if (logn.size() > 1) {
                                                Userlogins lg = logn.get(1);
                                                logins = lg.getDatelogin() + " (" + lg.getIplogin() + ")";
                                            }
                                        } catch (Exception k) {
                                            k.printStackTrace();
                                        }
                                        String title = stf.getTitle() == null ? "" : stf.getTitle();
                                    %>
                                    <h5 class="card-title">Welcome  <%=title + " " + stf.getSurname() + " " + stf.getOthernames()%></h5>
                                    <p class="card-text">Department: <%=deptd%></p>
                                    <p class="card-text">Role: <%=user != null && user.getDefaultRole() != null ? user.getDefaultRole().getName() : "Unknown"%></p>

                                    <p class="card-text"><small class="text-body-secondary">Last Login: <%=logins%></small></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="height: 20px"></div>

                    <div class="card mb-3">
                        <div class="card-header">Pages</div>
                        <div class="card-body">
                            <blockquote class="blockquote mb-0">
                                        <input class="form-control mb-3" type="search" id="cardSearchInput" onkeyup="filterCards()" placeholder="Search cards" aria-label="Search">

                                <div class="row g-4">
                                    <%
                                        List<Pages> pagel = new ArrayList();
                                        if (user != null && user.getDefaultRole() != null) {
                                            pagel = sess.getAllPagesforRole(user.getDefaultRole().getId() + "");
                                        }
                                        for (Pages pg : pagel) {
                                    %>

                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-3">
                                        <div class="card overflow-hidden">
                                            <div class="card-body p-0 d-flex align-items-center">
                                                <div class="bg-primary text-white p-4 me-3">
                                                    <svg class="icon icon-xl">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-settings"></use>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="fs-6 fw-semibold text-primary"><a href="/<%=pg.getAlias()%>"><%=pg.getDescription()%></a></div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <%
                                        }
                                        
                                        // Add O-Level Cleanup utility for staff users
                                        // Uses same authentication as staff dashboard (user != null)
                                    %>
                                    
<!--                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-3">
                                        <div class="card overflow-hidden border-warning">
                                            <div class="card-body p-0 d-flex align-items-center">
                                                <div class="bg-warning text-dark p-4 me-3">
                                                    <svg class="icon icon-xl">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-broom"></use>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="fs-6 fw-semibold text-warning">
                                                        <a href="#" class="text-decoration-none text-warning">
                                                            O-Level Cleanup
                                                        </a>
                                                    </div>
                                                    <small class="text-muted">System Utility</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>-->
                                    
                                    <!-- UTME Subjects Management -->
<!--                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-3">
                                        <div class="card overflow-hidden border-info">
                                            <div class="card-body p-0 d-flex align-items-center">
                                                <div class="bg-info text-white p-4 me-3">
                                                    <svg class="icon icon-xl">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-education"></use>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="fs-6 fw-semibold text-info">
                                                        <a href="/utme_subjects" class="text-decoration-none text-info">
                                                            UTME Subjects
                                                        </a>
                                                    </div>
                                                    <small class="text-muted">Manage UTME Subjects</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>-->
                                    
                                    <!-- Download Complete Applications -->
                                    <div class="col-12 col-sm-6 col-xl-4 col-xxl-3">
                                        <div class="card overflow-hidden border-success">
                                            <div class="card-body p-0 d-flex align-items-center">
                                                <div class="bg-success text-white p-4 me-3">
                                                    <svg class="icon icon-xl">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-cloud-download"></use>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="fs-6 fw-semibold text-success">
                                                        <a href="/DownloadCompleteApplications?id=<%=settings.encodeUrl(settings.encryptText(user.getId()))%>" class="text-decoration-none text-success">
                                                            Complete ND Applications
                                                        </a>
                                                    </div>
                                                    <small class="text-muted">Download for Admission</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <%
                                        // Remove the old admin-only sections
                                    %>
                                </div>

                            </blockquote>
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