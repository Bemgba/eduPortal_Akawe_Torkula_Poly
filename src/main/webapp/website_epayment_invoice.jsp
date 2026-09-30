<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    String returnurl = request.getParameter("return");

    if (returnurl != null) {
        session.setAttribute("EPayFromUrl", returnurl);
    }

    String xurl = "/epayment";
    try {
        xurl = (String) session.getAttribute("EPayFromUrl");
    } catch (Exception js) {
    }

    if (xurl == null) {
        xurl = "/epayment";
    }

    /* CREDO: InterswitchUtil kept for revert reference
    InterswitchUtil paymentUtil = new InterswitchUtil();
    */
    Paymentreference pr = null;
    String level = "";
    String sessions = null;
    String feesgroup = null;
    String sesssem = null;
    String regno = null;
    String fullname = null;
    String coursename = null;
    String phoneno = null;
    String email = null;
    String id = null;
    Feesgroup fg = null;
    double total = 0;
    try {
        level = (String) session.getAttribute("level");
        pr = (Paymentreference) session.getAttribute("pr");
        sessions = (String) session.getAttribute("sessions");
        feesgroup = (String) session.getAttribute("feesgroup");
        sesssem = (String) session.getAttribute("sesssem");
        regno = (String) session.getAttribute("regno");
        fullname = (String) session.getAttribute("fullname");
        coursename = (String) session.getAttribute("coursename");
        phoneno = (String) session.getAttribute("phoneno");
        email = (String) session.getAttribute("email");
        id = (String) session.getAttribute("id");
        fg = (Feesgroup) sess.getSingleObject(Feesgroup.class, feesgroup);

    } catch (Exception k) {
    }
    if (pr == null || fg == null || (level == null) || (sessions == null) || (feesgroup == null) || (sesssem == null) || (regno == null) || (fullname == null) || (id == null)) {
        response.sendRedirect("/epayment");
    }
    total = pr.getAmount();
%>

<%
    String siteurl = settings.baseurl;
    String redirecturl = siteurl + "/confirmation";
    String xid = settings.encodeUrl(settings.encryptText(pr.getId()));
    String bank = "href=\"/DownloadInvoice?id=" + xid + "\"";

    /* CREDO/Interswitch variables commented out - kept for revert reference
    String quickteller = settings.quickteller_url;
    String productid = settings.product_id;
    String macid = settings.mac_key;
    if (fg.getSchoolId().getId().equalsIgnoreCase("S003")) {
        quickteller = settings.chs_quickteller_url;
        productid = settings.chs_product_id;
        macid = settings.chs_mac_key;
    }
    String hash = "";
    String conc = "";
    String pay_item_id = paymentUtil.pay_item_id;
    String currency = paymentUtil.currency_code;
    try {
        conc = pr.getId() + productid + pay_item_id + (int) (pr.getAmount() * 100) + redirecturl + macid;
        hash = settings.generateHash512(conc);
    } catch (Exception js) {
    }
    Courses cos = sess.getCourses(pr.getCourseId());
    boolean fromchs = false;
    if (cos != null) {
        if (cos.getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")) {
            fromchs = true;
        }
    }
    */
%>


<html lang="en">
    <head>
        <link href="css/style.css" rel="stylesheet">
        <title><%=settings.productName%> - Invoice</title>

        <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/checkout/">

        <!-- Bootstrap core CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">


        <script type="text/javascript">
            /* CREDO checkout() function commented out - kept for revert reference
            function checkout() {
                var email = '<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>';
                var phone = '<%=pr.getPhoneNo() != null ? pr.getPhoneNo() : ""%>';
                console.log('Validating CREDO payment - Email: "' + email + '", Phone: "' + phone + '"');
                if (!email || email === 'null' || email === '' || email.trim() === '') {
                    alert('Email address is required for CREDO payment.');
                    return false;
                }
                if (!phone || phone === 'null' || phone === '' || phone.trim() === '') {
                    alert('Phone number is required for CREDO payment.');
                    return false;
                }
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Invalid email format.');
                    return false;
                }
                document.getElementById('credoPaymentForm').submit();
                return true;
            }
            */

            // X-Card payment validation
            function checkout() {
                var email = '<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>';
                if (!email || email === 'null' || email.trim() === '') {
                    alert('Email address is required for payment. Please ensure your account has a valid email address.');
                    return false;
                }
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Invalid email format: "' + email + '". Please provide a valid email address.');
                    return false;
                }
                document.getElementById('xcardPaymentForm').submit();
                return true;
            }
        </script>




    </head>


    <body>
        <div class="wrapper d-flex flex-column min-vh-100">
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="row justify-content-center">
                        <div class="col-lg-12">
                            <div class="card">
                                <div class="card-header d-flex align-items-center">Invoice for <strong><%=fullname%></strong>
                                    <a class="btn btn-sm btn-danger ms-auto me-1 d-print-none" href="/epayment" >
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use>
                                        </svg> Back</a>
                                    &nbsp;
                                    <a class="btn btn-sm btn-secondary ms-auto me-1 d-print-none" href="/invoice" onclick="javascript:window.print();">
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-print"></use>
                                        </svg> Print</a>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-12">
                                        <div class="col-sm-6">
                                            <h6 class="mb-3">Payment Description</h6>
                                            <div><strong><%=fg.getName()%></strong></div>
                                            <div><%=sessions%></div>
                                            <div><%=sesssem%></div>
                                            <div>N<%=settings.formatno.format(total)%></div>
                                            <%
                                                String inwords = total + "";
                                                ConvertNumberToWord words = new ConvertNumberToWord();
                                                try {
                                                    inwords = words.convertAmount(total);
                                                } catch (Exception k) {
                                                }
                                            %>
                                            <div><%=inwords%></div>
                                        </div>
                                        <!-- /.col-->
                                        <div class="col-sm-6">
                                            <h6 class="mb-3">Payer's Details</h6>
                                            <div><strong><%=fullname%></strong></div>
                                            <div><%=regno%></div>
                                            <div><%=level%></div>
                                            <div><%=coursename%></div>
                                        </div>

                                    </div>
                                    <!-- /.row-->
                                    <%-- CREDO/Interswitch legacy hidden fields commented out - kept for revert reference
                                    <input type="hidden"  name='amount' value="<%=(int) (pr.getAmount() % 100)%>"/>
                                    <input type="hidden"  name='currency' value="566"/>
                                    <input type="hidden" name='txn_ref' id="tranRef"/>
                                    <input type="hidden"  name='merchant_code'/>
                                    <input type="hidden"  name='pay_item_id'/>
                                    <input name="site_redirect_url" type="hidden" value="<%=redirecturl%>" />
                                    <input name="cust_id_desc" type="hidden" value="<%=regno%>" />
                                    <input name="cust_name" type="hidden" value="<%=fullname%>" />
                                    <input type="hidden"  name='display_mode' value='PAGE'/>
                                    --%>





                                    <div class="row">
                                        <div class="col-lg-12 col-sm-5 ms-auto">
                                            <%
                                                try {
                                                    Payments pa = sess.getPayments(pr.getId());
                                                    if (pa != null) {

                                            %>
                                            <div class="alert alert-warning">
                                                Already paid. 
                                                <%                                                    String dsid = settings.encryptText(pr.getId());
                                                    dsid = settings.encodeUrl(dsid);
                                                    String link = "/DownloadReceipt?id=" + pr.getId();
                                                %>
                                                <a class="btn btn-success btn-lg float-right" href="<%=link%>">
                                                    <svg class="icon">
                                                    <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-download"></use>
                                                    </svg> Download Receipt</a>
                                            </div> 
                                            <%
                                            } else {
                                            %>
                                            <p style="height:5px"/>
                                            <%-- CREDO info banner commented out - kept for revert reference
                                            <div class="alert alert-info">
                                                <%
                                                if(fromchs){
                                                %>
                                                This payment is to be processed on the CREDO payment platform for College of Health Science
                                                <%
                                                    }else{
                                                   %>
                                                This payment is to be processed on the CREDO payment platform for Main University
                                                <%  
                                                    }
                                                %>
                                            </div>
                                            --%>
                                            <!-- X-Card info banner -->
                                            <div class="alert alert-info">
                                                This payment is to be processed on the X-Card payment platform (Resident Fintech).
                                            </div>

                                            <div class="card">
                                                <div class="card-header d-flex align-items-center"><strong>Pay at Bank Branch</strong>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row mb-12">
                                                        <div class="alert alert-info">
                                                            <a <%=bank%>><img src="assets/img/bankbranch.jpeg" align="left" height="90px" width="90px"/> </a>
                                                            This method of payment allows the payer to print a payment reference and take to the bank with the 
                                                            stipulated amount for payment. After your payment has been captured, you can come back to the portal and 
                                                            continue with the requested service. Please kindly click the bank logo to print your Payment Reference.<br/>
                                                            <a <%=bank%> class="btn btn-secondary btn-sm">Pay Cash at the Bank</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <p style="height:10px"/>

                                            <%-- CREDO online payment card commented out - kept for revert reference
                                            <div class="card">
                                                <div class="card-header d-flex align-items-center"><strong>Pay Online with CREDO</strong>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row mb-12">
                                                        <div class="alert alert-info">
                                                            <a href="#" onclick="checkout()"><img src="assets/img/credo-logo.png" align="left" style="height:60px; width:auto;" onerror="this.style.display='none'"/> </a>
                                                            This method allows you to pay securely online using CREDO payment platform. You can pay with your debit card, bank transfer, or other supported payment methods. 
                                                            Payment reference: <strong><%=pr.getId()%></strong>. After successful payment, you will be redirected back to complete your transaction. <br/>
                                                            <a href="#" onclick="checkout()" class="btn btn-success btn-sm">Pay Now with CREDO</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            --%>

                                            <!-- X-Card online payment card -->
                                            <div class="card">
                                                <div class="card-header d-flex align-items-center"><strong>Pay Online with X-Card</strong>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row mb-12">
                                                        <div class="alert alert-info">
                                                            <a href="#" onclick="checkout()"><img src="assets/img/xcard-logo.png" align="left" style="height:60px; width:auto;" onerror="this.style.display='none'"/> </a>
                                                            This method allows you to pay securely online using the X-Card payment platform. You can pay with your debit card, bank transfer, or other supported payment methods.
                                                            Payment reference: <strong><%=pr.getId()%></strong>. After successful payment, you will be redirected back to complete your transaction. <br/>
                                                            <a href="#" onclick="checkout()" class="btn btn-success btn-sm">Pay Now with X-Card</a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <%-- CREDO payment form commented out - kept for revert reference
                                            <form id="credoPaymentForm" method="POST" action="/Etranzact2" style="display: none;">
                                                <input type="hidden" name="id" value="<%=settings.encryptText(pr.getId())%>"/>
                                                <input type="hidden" name="amount" value="<%=pr.getAmount()%>"/>
                                                <input type="hidden" name="firstname" value="<%=fullname%>"/>
                                                <input type="hidden" name="lastname" value="<%=fullname%>"/>
                                                <input type="hidden" name="customer_email" value="<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>"/>
                                                <input type="hidden" name="customer_phone" value="<%=pr.getPhoneNo() != null ? pr.getPhoneNo() : ""%>"/>
                                            </form>
                                            --%>

                                            <!-- X-Card payment form - submits to XCard servlet -->
                                            <form id="xcardPaymentForm" method="POST" action="/XCard?action=init" style="display: none;">
                                                <input type="hidden" name="id" value="<%=settings.encryptText(pr.getId())%>"/>
                                                <input type="hidden" name="amount" value="<%=pr.getAmount()%>"/>
                                                <input type="hidden" name="customer_email" value="<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>"/>
                                            </form>


                                            <%
                                                    }
                                                } catch (Exception k) {
                                                }
                                            %>


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


        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
                integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
        crossorigin="anonymous"></script>
        <!-- CREDO Integration: Interswitch JavaScript libraries commented out -->
        <!--<script src="https://newwebpay.qa.interswitchng.com/inline-checkout.js"></script>-->
        <!--<script src="https://newwebpay.interswitchng.com/inline-checkout.js"></script>-->
        
        <!-- CREDO Integration: No external JavaScript library needed - using native fetch API -->


    </body>
</html>