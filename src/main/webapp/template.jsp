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
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Title</h2>
                </div>
            </header>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row g-4 mb-4">
                        <div class="col-sm-6 col-xl-3">
                            <div class="card text-white bg-primary-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">26K <span class="fs-6 fw-normal">(-12.4%
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-bottom"></use>
                                                </svg>)</span></div>
                                        <div data-coreui-i18n="users">Users</div>
                                    </div>
                                    <div class="dropdown">
                                        <button class="btn btn-transparent text-white p-0" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <svg class="icon">
                                            <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                            </svg>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="action">Action</a><a class="dropdown-item" href="#" data-coreui-i18n="anotherAction">Another action</a><a class="dropdown-item" href="#" data-coreui-i18n="somethingElseHere">Something else here</a></div>
                                    </div>
                                </div>
                                <div class="c-chart-wrapper mt-3 mx-3" style="height:70px;">
                                    <canvas class="chart" id="card-chart1" height="70"></canvas>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-xl-3">
                            <div class="card text-white bg-info-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">$6.200 <span class="fs-6 fw-normal">(40.9%
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-top"></use>
                                                </svg>)</span></div>
                                        <div data-coreui-i18n="income">Income</div>
                                    </div>
                                    <div class="dropdown">
                                        <button class="btn btn-transparent text-white p-0" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <svg class="icon">
                                            <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                            </svg>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="action">Action</a><a class="dropdown-item" href="#" data-coreui-i18n="anotherAction">Another action</a><a class="dropdown-item" href="#" data-coreui-i18n="somethingElseHere">Something else here</a></div>
                                    </div>
                                </div>
                                <div class="c-chart-wrapper mt-3 mx-3" style="height:70px;">
                                    <canvas class="chart" id="card-chart2" height="70"></canvas>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-xl-3">
                            <div class="card text-white bg-warning-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">2.49% <span class="fs-6 fw-normal">(84.7%
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-top"></use>
                                                </svg>)</span></div>
                                        <div data-coreui-i18n="conversionRate">Conversion Rate</div>
                                    </div>
                                    <div class="dropdown">
                                        <button class="btn btn-transparent text-white p-0" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <svg class="icon">
                                            <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                            </svg>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="action">Action</a><a class="dropdown-item" href="#" data-coreui-i18n="anotherAction">Another action</a><a class="dropdown-item" href="#" data-coreui-i18n="somethingElseHere">Something else here</a></div>
                                    </div>
                                </div>
                                <div class="c-chart-wrapper mt-3" style="height:70px;">
                                    <canvas class="chart" id="card-chart3" height="70"></canvas>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-xl-3">
                            <div class="card text-white bg-danger-gradient">
                                <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                                    <div>
                                        <div class="fs-4 fw-semibold">44K <span class="fs-6 fw-normal">(-23.6%
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-bottom"></use>
                                                </svg>)</span></div>
                                        <div data-coreui-i18n="sessions">Sessions</div>
                                    </div>
                                    <div class="dropdown">
                                        <button class="btn btn-transparent text-white p-0" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <svg class="icon">
                                            <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                            </svg>
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="action">Action</a><a class="dropdown-item" href="#" data-coreui-i18n="anotherAction">Another action</a><a class="dropdown-item" href="#" data-coreui-i18n="somethingElseHere">Something else here</a></div>
                                    </div>
                                </div>
                                <div class="c-chart-wrapper mt-3 mx-3" style="height:70px;">
                                    <canvas class="chart" id="card-chart4" height="70"></canvas>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                    </div>
                    <!-- /.row-->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <h4 class="card-title mb-0" data-coreui-i18n="traffic">Traffic</h4>
                                    <div class="small text-body-secondary"><span data-coreui-i18n-date="dateOnlyMonthName, { date: '2023, 1, 1'}">January</span> - <span data-coreui-i18n-date="dateOnlyMonthName, { 'date': '2023, 6, 30'}">July</span> 2023</div>
                                </div>
                                <div class="btn-toolbar d-none d-md-block" role="toolbar" aria-label="Toolbar with buttons">
                                    <div class="btn-group btn-group-toggle mx-3" data-coreui-toggle="buttons">
                                        <input class="btn-check" id="option1" type="radio" name="options" autocomplete="off">
                                        <label class="btn btn-outline-secondary" data-coreui-i18n="day">Day</label>
                                        <input class="btn-check" id="option2" type="radio" name="options" autocomplete="off" checked="">
                                        <label class="btn btn-outline-secondary active" data-coreui-i18n="month">Month</label>
                                        <input class="btn-check" id="option3" type="radio" name="options" autocomplete="off">
                                        <label class="btn btn-outline-secondary" data-coreui-i18n="year">Year</label>
                                    </div>
                                    <button class="btn btn-primary" type="button">
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-cloud-download"></use>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <div class="c-chart-wrapper" style="height:300px;margin-top:40px;">
                                <canvas class="chart" id="main-chart" height="300"></canvas>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-4 row-cols-xl-5 g-4 mb-2 text-center">
                                <div class="col">
                                    <div class="text-body-secondary" data-coreui-i18n="visits">Visits</div>
                                    <div class="fw-semibold text-truncate"><span data-coreui-i18n="usersCounter, { 'counter': '29.703' }">29.703 Users</span> (40%)</div>
                                    <div class="progress progress-thin mt-2">
                                        <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="text-body-secondary" data-coreui-i18n="unique">Unique</div>
                                    <div class="fw-semibold text-truncate"><span data-coreui-i18n="usersCounter, { 'counter': '24.093' }">24.093 Users</span> (20%)</div>
                                    <div class="progress progress-thin mt-2">
                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="text-body-secondary" data-coreui-i18n="pageviews">Pageviews</div>
                                    <div class="fw-semibold text-truncate"><span data-coreui-i18n="viewsCounter, { 'counter': '78.706' }">78.706 Views</span> (60%)</div>
                                    <div class="progress progress-thin mt-2">
                                        <div class="progress-bar bg-warning-gradient" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col">
                                    <div class="text-body-secondary" data-coreui-i18n="newUsers">New Users</div>
                                    <div class="fw-semibold text-truncate"><span data-coreui-i18n="usersCounter, { 'counter': '22.123' }">22.123 Users</span>(80%)</div>
                                    <div class="progress progress-thin mt-2">
                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 80%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <div class="col d-none d-xl-block">
                                    <div class="text-body-secondary" data-coreui-i18n="bounceRate">Bounce Rate</div>
                                    <div class="fw-semibold text-truncate">40.15%</div>
                                    <div class="progress progress-thin mt-2">
                                        <div class="progress-bar" role="progressbar" style="width: 40%" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.card.mb-4-->
                    <div class="row g-4 mb-4">
                        <div class="col-sm-6 col-lg-4">
                            <div class="card" style="--cui-card-cap-bg: #3b5998">
                                <div class="card-header position-relative d-flex justify-content-center align-items-center">
                                    <svg class="icon icon-3xl text-white my-4">
                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-facebook-f"></use>
                                    </svg>
                                    <div class="chart-wrapper position-absolute top-0 start-0 w-100 h-100">
                                        <canvas id="social-box-chart-1" height="90"></canvas>
                                    </div>
                                </div>
                                <div class="card-body row text-center">
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">89k</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="friends">friends</div>
                                    </div>
                                    <div class="vr"></div>
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">459</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="feeds">feeds</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-lg-4">
                            <div class="card" style="--cui-card-cap-bg: #00aced">
                                <div class="card-header position-relative d-flex justify-content-center align-items-center">
                                    <svg class="icon icon-3xl text-white my-4">
                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-twitter"></use>
                                    </svg>
                                    <div class="chart-wrapper position-absolute top-0 start-0 w-100 h-100">
                                        <canvas id="social-box-chart-2" height="90"></canvas>
                                    </div>
                                </div>
                                <div class="card-body row text-center">
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">973k</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="followers">followers</div>
                                    </div>
                                    <div class="vr"></div>
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">1.792</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="tweets">tweets</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                        <div class="col-sm-6 col-lg-4">
                            <div class="card" style="--cui-card-cap-bg: #4875b4">
                                <div class="card-header position-relative d-flex justify-content-center align-items-center">
                                    <svg class="icon icon-3xl text-white my-4">
                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-linkedin"></use>
                                    </svg>
                                    <div class="chart-wrapper position-absolute top-0 start-0 w-100 h-100">
                                        <canvas id="social-box-chart-3" height="90"></canvas>
                                    </div>
                                </div>
                                <div class="card-body row text-center">
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">500+</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="contacts">contacts</div>
                                    </div>
                                    <div class="vr"></div>
                                    <div class="col">
                                        <div class="fs-5 fw-semibold">292</div>
                                        <div class="text-uppercase text-body-secondary small" data-coreui-i18n="feeds">feeds</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
                    </div>
                    <!-- /.row-->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card mb-4">
                                <div class="card-header" data-coreui-i18n="trafficAndSales">Traffic &amp; Sales</div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="border-start border-start-4 border-start-info px-3 mb-3">
                                                        <div class="small text-body-secondary text-truncate" data-coreui-i18n="newClients">New Clients</div>
                                                        <div class="fs-5 fw-semibold">9.123</div>
                                                    </div>
                                                </div>
                                                <!-- /.col-->
                                                <div class="col-6">
                                                    <div class="border-start border-start-4 border-start-danger px-3 mb-3">
                                                        <div class="small text-body-secondary text-truncate" data-coreui-i18n="recurringClients">Recuring Clients</div>
                                                        <div class="fs-5 fw-semibold">22.643</div>
                                                    </div>
                                                </div>
                                                <!-- /.col-->
                                            </div>
                                            <!-- /.row-->
                                            <hr class="mt-0">
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="monday">Monday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 34%" aria-valuenow="34" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 78%" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="tuesday">Tuesday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 56%" aria-valuenow="56" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 94%" aria-valuenow="94" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="wednesday">Wednesday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 12%" aria-valuenow="12" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 67%" aria-valuenow="67" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="thursday">Thursday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 43%" aria-valuenow="43" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 91%" aria-valuenow="91" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="friday">Friday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 22%" aria-valuenow="22" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 73%" aria-valuenow="73" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="saturday">Saturday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 53%" aria-valuenow="53" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 82%" aria-valuenow="82" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-4">
                                                <div class="progress-group-prepend"><span class="text-body-secondary small" data-coreui-i18n="sunday">Sunday</span></div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 9%" aria-valuenow="9" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 69%" aria-valuenow="69" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /.col-->
                                        <div class="col-sm-6">
                                            <div class="row">
                                                <div class="col-6">
                                                    <div class="border-start border-start-4 border-start-warning px-3 mb-3">
                                                        <div class="small text-body-secondary text-truncate" data-coreui-i18n="pageviews">Pageviews</div>
                                                        <div class="fs-5 fw-semibold">78.623</div>
                                                    </div>
                                                </div>
                                                <!-- /.col-->
                                                <div class="col-6">
                                                    <div class="border-start border-start-4 border-start-success px-3 mb-3">
                                                        <div class="small text-body-secondary text-truncate" data-coreui-i18n="organic">Organic</div>
                                                        <div class="fs-5 fw-semibold">49.123</div>
                                                    </div>
                                                </div>
                                                <!-- /.col-->
                                            </div>
                                            <!-- /.row-->
                                            <hr class="mt-0">
                                            <div class="progress-group">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
                                                    </svg>
                                                    <div data-coreui-i18n="male">Male</div>
                                                    <div class="ms-auto fw-semibold">43%</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-warning-gradient" role="progressbar" style="width: 43%" aria-valuenow="43" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group mb-5">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user-female"></use>
                                                    </svg>
                                                    <div data-coreui-i18n="female">Female</div>
                                                    <div class="ms-auto fw-semibold">37%</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-warning-gradient" role="progressbar" style="width: 43%" aria-valuenow="43" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-google"></use>
                                                    </svg>
                                                    <div data-coreui-i18n="organicSearch">Organic Search</div>
                                                    <div class="ms-auto fw-semibold me-2">191.235</div>
                                                    <div class="text-body-secondary small">(56%)</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 56%" aria-valuenow="56" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-facebook-f"></use>
                                                    </svg>
                                                    <div>Facebook</div>
                                                    <div class="ms-auto fw-semibold me-2">51.223</div>
                                                    <div class="text-body-secondary small">(15%)</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 15%" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-twitter"></use>
                                                    </svg>
                                                    <div>Twitter</div>
                                                    <div class="ms-auto fw-semibold me-2">37.564</div>
                                                    <div class="text-body-secondary small">(11%)</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 11%" aria-valuenow="11" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="progress-group">
                                                <div class="progress-group-header">
                                                    <svg class="icon icon-lg me-2">
                                                    <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-linkedin"></use>
                                                    </svg>
                                                    <div>LinkedIn</div>
                                                    <div class="ms-auto fw-semibold me-2">27.319</div>
                                                    <div class="text-body-secondary small">(8%)</div>
                                                </div>
                                                <div class="progress-group-bars">
                                                    <div class="progress progress-thin">
                                                        <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 8%" aria-valuenow="8" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /.col-->
                                    </div>
                                    <!-- /.row--><br>
                                    <div class="table-responsive">
                                        <table class="table border mb-0">
                                            <thead class="fw-semibold text-nowrap">
                                                <tr class="align-middle">
                                                    <th class="bg-body-secondary text-center">
                                                        <svg class="icon">
                                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-people"></use>
                                                        </svg>
                                                    </th>
                                                    <th class="bg-body-secondary" data-coreui-i18n="user">User</th>
                                                    <th class="bg-body-secondary text-center" data-coreui-i18n="country">Country</th>
                                                    <th class="bg-body-secondary" data-coreui-i18n="usage">Usage</th>
                                                    <th class="bg-body-secondary text-center" data-coreui-i18n="paymentMethod">Payment Method</th>
                                                    <th class="bg-body-secondary" data-coreui-i18n="activity">Activity</th>
                                                    <th class="bg-body-secondary"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/1.jpg" alt="user@email.com"><span class="avatar-status bg-success"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Yiorgos Avraamu</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="new">New</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-us"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">50%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 10'}"> </span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 50%" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-mastercard"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -10, 'range': 'seconds' }">10 sec ago</div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/2.jpg" alt="user@email.com"><span class="avatar-status bg-danger-gradient"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Avram Tarasios</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="recurring">Recurring</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-br"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">10%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 10'}"> </span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 10%" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-visa"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -5, 'range': 'minutes' }">5 minutes ago</div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/3.jpg" alt="user@email.com"><span class="avatar-status bg-warning-gradient"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Quintin Ed</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="new">New</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-in"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">74%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 10'}"> </span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-warning-gradient" role="progressbar" style="width: 74%" aria-valuenow="74" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-stripe"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -1, 'range': 'hours' }">1 hour ago</div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/4.jpg" alt="user@email.com"><span class="avatar-status bg-secondary-gradient"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Enéas Kwadwo</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="new">New</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-fr"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">98%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 10'}"> </span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-danger-gradient" role="progressbar" style="width: 98%" aria-valuenow="98" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-paypal"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -1, 'range': 'weeks' }">Last week</div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/5.jpg" alt="user@email.com"><span class="avatar-status bg-success"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Agapetus Tadeáš</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="new">New</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-es"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">22%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 18'}"> </span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-info-gradient" role="progressbar" style="width: 22%" aria-valuenow="22" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-apple-pay"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -3, 'range': 'months' }"></div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown dropup">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr class="align-middle">
                                                    <td class="text-center">
                                                        <div class="avatar avatar-md"><img class="avatar-img" src="assets/img/avatars/6.jpg" alt="user@email.com"><span class="avatar-status bg-danger-gradient"></span></div>
                                                    </td>
                                                    <td>
                                                        <div class="text-nowrap">Friderik Dávid</div>
                                                        <div class="small text-body-secondary text-nowrap"><span data-coreui-i18n="new">New</span> | <span data-coreui-i18n="registered">Registered: </span><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 1, 10'}">Jan 1, 2023</span></div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/flag.svg#cif-pl"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex justify-content-between align-items-baseline">
                                                            <div class="fw-semibold">43%</div>
                                                            <div class="text-nowrap small text-body-secondary ms-3"><span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 6, 11'}"></span> - <span data-coreui-i18n-date="dateShortMonthName, { 'date': '2023, 7, 10'}"></span></div>
                                                        </div>
                                                        <div class="progress progress-thin">
                                                            <div class="progress-bar bg-success-gradient" role="progressbar" style="width: 43%" aria-valuenow="43" aria-valuemin="0" aria-valuemax="100"></div>
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <svg class="icon icon-xl">
                                                        <use xlink:href="vendors/@coreui/icons/svg/brand.svg#cib-cc-amex"></use>
                                                        </svg>
                                                    </td>
                                                    <td>
                                                        <div class="small text-body-secondary" data-coreui-i18n="lastLogin">Last login</div>
                                                        <div class="fw-semibold text-nowrap" data-coreui-i18n="relativeTime, { 'val': -1, 'range': 'years' }"></div>
                                                    </td>
                                                    <td>
                                                        <div class="dropdown dropup">
                                                            <button class="btn btn-transparent p-0 dark:text-high-emphasis" type="button" data-coreui-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                <svg class="icon">
                                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-options"></use>
                                                                </svg>
                                                            </button>
                                                            <div class="dropdown-menu dropdown-menu-end"><a class="dropdown-item" href="#" data-coreui-i18n="info">Info</a><a class="dropdown-item" href="#" data-coreui-i18n="edit">Edit</a><a class="dropdown-item text-danger" href="#" data-coreui-i18n="delete">Delete</a></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /.col-->
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