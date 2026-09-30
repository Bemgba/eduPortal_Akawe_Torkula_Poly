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
    List<Feessetup> feessetup = new ArrayList();
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
        feessetup = (List<Feessetup>) session.getAttribute("FEESSETUP");
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
    if (pr == null || fg == null || (feessetup.size() == 0) || (level == null) || (sessions == null) || (feesgroup == null) || (sesssem == null) || (regno == null) || (fullname == null) || (id == null)) {
        response.sendRedirect("/epayment");
    }
    total = feessetup.stream()
            .mapToDouble(Feessetup::getAmount)
            .sum();

%>

<%     
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
            // CREDO Payment Integration: Use only Etranzact2.java servlet
            
            // OLD Interswitch checkout function - commented out for CREDO integration
//            function checkout() {
//                var merchantCode = '< %=paymentUtil.merchant_code%>';
//                var payItemId = '< %=paymentUtil.pay_item_id%>';
//                var transRef = '< %=pr.getId()%>';
//                var paymentRequest = {
//                    merchant_code: merchantCode,
//                    pay_item_id: payItemId,
//                    txn_ref: transRef,
//                    amount: '< %=(int) (pr.getAmount() * 100)%>',
//                    cust_id: '< %=pr.getPayerId()%>',
//                    currency: '< %=paymentUtil.currency_code%>',
//                    site_redirect_url: window.location.origin,
//                    onComplete: paymentCallback,
//                    mode: '< %=paymentUtil.mode%>'
//                };
//                window.webpayCheckout(paymentRequest);
//            }

            // JAVASCRIPT API CALLS COMMENTED OUT - Using only Etranzact2.java servlet
            /*
            // CREDO Payment Integration: Single consolidated CREDO checkout function
            function credoCheckout() {
                // *** PRODUCTION: Remove this debug log for live deployment ***
                console.log('Initializing CREDO payment...');
                
                // CREDO payment initialization data
                var credoData = {
                    amount: < %=(int)(pr.getAmount() * 100)%>, // Convert to kobo for CREDO
                    email: '< %=email%>', // CREDO requires email (from session)
                    phone: '< %=phoneno%>', // CREDO requires phone (from session)
                    reference: '< %=pr.getId()%>', // Payment reference ID
                    callback_url: '< %=redirecturl%>', // Callback URL for CREDO
                    currency: 'NGN' // CREDO currency
                };
                
                // CREDO API call to initialize payment
                fetch('<%=settings.credo_base_url%>/transaction/initialize', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': '<%=settings.credo_public_key%>'
                    },
                    body: JSON.stringify(credoData)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.status === true && data.data && data.data.authorization_url) {
                        window.location.href = data.data.authorization_url;
                    } else {
                        throw new Error(data.message || 'Invalid response from CREDO API');
                    }
                })
                .catch(error => {
                    console.error('CREDO Payment Error:', error);
                    alert('Payment initialization failed. Please try again or contact support.');
                });
            }
            */
            
            // MINIMAL VALIDATION ONLY - No CREDO API calls, pure form validation
            function validateCredoPayment() {
                // Get email and phone from Paymentreference object (more reliable)
                var email = '<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>';
                var phone = '<%=pr.getPhoneNo() != null ? pr.getPhoneNo() : ""%>';
                
                console.log('Validating CREDO payment - Email: "' + email + '", Phone: "' + phone + '"');
                
                if (!email || email === 'null' || email === '' || email.trim() === '') {
                    alert('Email address is required for CREDO payment.\n\nReceived email: "' + email + '"\n\nPlease ensure the payment reference has a valid email address.');
                    return false;
                }
                
                if (!phone || phone === 'null' || phone === '' || phone.trim() === '') {
                    alert('Phone number is required for CREDO payment.\n\nReceived phone: "' + phone + '"\n\nPlease ensure the payment reference has a valid phone number.');
                    return false;
                }
                
                // Basic email format validation
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    alert('Invalid email format: "' + email + '"\n\nPlease provide a valid email address.');
                    return false;
                }
                
                // Validation passed - form will submit to Etranzact2 servlet
                return true;
            }

            // OLD Interswitch callback function - commented out for CREDO integration
//            function paymentCallback(response) {
//                if (response != null) {
//                    console.log(response);
//                    var txnrefx = response.txnref;
//                    window.location.href = "paymentresponse.jsp?id=" + txnrefx;
//                }
//            }

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
                                    <div class="table-responsive-sm">
                                        <table class="table table-striped">
                                            <thead>
                                                <tr>
                                                    <th class="center">#</th>
                                                    <th>Item</th>
                                                    <th class="right">Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    
                                                    int i = 1;
                                                    for (Feessetup fss : feessetup) {
                                                %>
                                                <tr>
                                                    <td class="center"><%=i%></td>
                                                    <td class="left"><%=fss.getFeesItemsId().getName()%></td>
                                                    <td class="right">N<%=settings.formatno.format(fss.getAmount())%></td>
                                                </tr>
                                                <%
                                                        i++;
                                                    }
                                                %>

                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- CREDO Payment Form - Direct submission to Etranzact2 servlet -->
                                    <form id="credoPaymentForm" method="POST" action="/Etranzact2" onsubmit="return validateCredoPayment();" style="display: none;">
                                        <!-- Fields for Etranzact2.java servlet -->
                                        <input type="hidden" name="id" value="<%=settings.encryptText(pr.getId())%>"/>
                                        <input type="hidden" name="amount" value="<%=pr.getAmount()%>"/>
                                        <input type="hidden" name="firstname" value="<%=fullname%>"/>
                                        <input type="hidden" name="lastname" value="<%=fullname%>"/>
                                        <input type="hidden" name="customer_email" value="<%=pr.getEmailAddress() != null ? pr.getEmailAddress() : ""%>"/>
                                        <input type="hidden" name="customer_phone" value="<%=pr.getPhoneNo() != null ? pr.getPhoneNo() : ""%>"/>
                                    </form>
                                    

                                    <!-- OLD Interswitch hidden fields - commented out for CREDO integration -->
                                    <!--
                                    <input type="hidden"  name='amount' value="< %=(int) (pr.getAmount() % 100)%>"/>
                                    <input type="hidden"  name='currency' value="566"/>
                                    <input type="hidden" name='txn_ref' id="tranRef"/>
                                    <input type="hidden"  name='merchant_code'/>
                                    <input type="hidden"  name='pay_item_id'/>
                                    <input type="hidden"  name='site_redirect_url'/>
                                    <input type="hidden"  name='display_mode' value='PAGE'/>
                                    -->

                                    <div class="text-right">
                                        <!-- DIRECT FORM SUBMISSION - No JavaScript required -->
                                        <button type="submit" form="credoPaymentForm" class="btn btn-lg btn-primary float-right">Pay Now with CREDO</button>
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