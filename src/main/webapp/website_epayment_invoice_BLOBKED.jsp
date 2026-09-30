<%-- 
    Document   : template
    Created on : 6 Oct 2024, 15:48:36
    Author     : eaglescan
--%>

<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    
    InterswitchUtil paymentUtil = new InterswitchUtil();
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

<%    String fromUrl = "/epayment";
    try {
        String h = (String) session.getAttribute("return");
        if (h != null && h.length() > 0) {
            h = settings.decryptText(h);
            if (h.startsWith("/")) {
                fromUrl = h;
            }
        }
    } catch (Exception k) {
    }
    String siteurl = settings.baseurl;
    String redirecturl = siteurl + "/confirmation";

    String hash = "";
    String conc = "";
    String pay_item_id = paymentUtil.pay_item_id;
    String currency = paymentUtil.currency_code;
    String macid = paymentUtil.MacKey;
    String productid = paymentUtil.product_id;//dd.getCustReference() + setting.getPincodes(5);
    String merchant_code = paymentUtil.merchant_code;

    try {
        conc = pr.getId() + productid + pay_item_id + (int) (pr.getAmount() * 100) + redirecturl + macid;
        hash = settings.generateHash512(conc);
    } catch (Exception js) {
    }
%>
<html lang="en">
    <head>
        <link href="css/style.css" rel="stylesheet">
        <title><%=settings.productName%> - Invoice</title>

        <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/checkout/">

        <!-- Bootstrap core CSS -->
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">


        <script type="text/javascript">
            //load isw payment page
            function checkout() {
                var merchantCode = '<%=paymentUtil.merchant_code%>';
                var payItemId = '<%=paymentUtil.pay_item_id%>';
                var transRef = '<%=pr.getId()%>';
                var paymentRequest = {
                    merchant_code: merchantCode,
                    pay_item_id: payItemId,
                    txn_ref: transRef,
                    amount: '<%=(int) (pr.getAmount() * 100)%>',
                    cust_id: '<%=pr.getPayerId()%>',
                    cust_id_desc: '<%=regno%>',
                    currency: '<%=paymentUtil.currency_code%>',
                    site_redirect_url: window.location.origin,
                    hash: '<%=hash%>',
                    product_id: '<%=paymentUtil.product_id%>',
                    cust_name: '<%=fullname%>',
                    onComplete: paymentCallback,
                    mode: '<%=paymentUtil.mode%>'

                };
                window.webpayCheckout(paymentRequest);
            }



            //callback function that gets triggered on payment success or failure
            function paymentCallback(response) {
                if (response != null) {
                    console.log(response);
                    var txnrefx = response.txnref;
                    window.location.href = "<%=redirecturl%>?id=" + txnrefx;
                }

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
                                    <a class="btn btn-sm btn-danger ms-auto me-1 d-print-none" href="<%=fromUrl%>" >
                                        <svg class="icon">
                                        <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-arrow-left"></use>
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
                                   

                                    <input type="hidden"  name='amount' value="<%=(int) (pr.getAmount() % 100)%>"/>
                                    <input type="hidden"  name='currency' value="566"/>
                                    <input type="hidden" name='txn_ref' id="tranRef"/>
                                    <input type="hidden"  name='merchant_code'/>
                                    <input type="hidden"  name='pay_item_id'/>
                                    <input name="site_redirect_url" type="hidden" value="<%=redirecturl%>" />
                                    <input name="cust_id_desc" type="hidden" value="<%=regno%>" />
                                    <input name="cust_name" type="hidden" value="<%=fullname%>" />
                                    <input type="hidden"  name='display_mode' value='PAGE'/>





                                    <div class="row">
                                        <div class="col-lg-12 col-sm-5 ms-auto">
                                            <a class="btn btn-success btn-lg float-right" href="#" onclick="checkout()">
                                                <svg class="icon">
                                                <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-money"></use>
                                                </svg> Proceed to Pay N<%=settings.formatno.format(total)%></a>
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
        <!--<script src="https://newwebpay.qa.interswitchng.com/inline-checkout.js"></script>-->
        <script src="https://newwebpay.interswitchng.com/inline-checkout.js"></script>


    </body>
</html>