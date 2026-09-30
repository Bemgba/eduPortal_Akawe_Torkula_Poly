<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <title>BSUM Portal - </title>
    </head>
    <body>
        <div class="sidebar sidebar-fixed border-end" id="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-brand">
                    <img src="assets/img/logo.png" alt="BSUM Logo" style="widows: 32px; height: auto">
                </div>
                <button class="btn-close d-lg-none" type="button" aria-label="Close" onclick="coreui.Sidebar.getInstance(document.querySelector( & amp; quot; #sidebar & amp; quot; )).toggle()"></button>
            </div>
        </div>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <div class="container-fluid px-4">
                    <button class="header-toggler" type="button" onclick="coreui.Sidebar.getInstance(document.querySelector('#sidebar')).toggle()" style="margin-inline-start: -14px">
                        <svg class="icon icon-lg">
                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-menu"></use>
                        </svg>
                    </button>
                    <div><h1>Benue State University Portal</h1></div>
                    <ul class="header-nav d-none d-md-flex ms-auto"></ul>
                    <ul class="header-nav ms-auto ms-md-0"></ul>

                </div>

            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="card mb-4">
                        <div class="card-header"> Message title <em>Date</em> <a href="" class="btn btn-danger float-end">Back</a></div>
                        <div class="card-body">
                            <div class="row">
                            content
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