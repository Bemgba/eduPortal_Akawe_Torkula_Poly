/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mnl.eduportal.servlet;

import com.mnl.eduportal.entities.Courses;
import com.mnl.eduportal.entities.Paymentnotification;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Paymenttrash;
import com.mnl.eduportal.entities.Remotelogin;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.Random;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 *
 * @author eaglescan
 */
public class Interswitch_backUP extends HttpServlet {

    @Inject
    private MainSession sess;

    Settings settings = new Settings();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ProductGroupCode = "";
        String PaymentLogId = "";
        String PaymentCustReference = "";//CustReference
        String AlternateCustReference = "";
        String Amount = "";
        String PaymentStatus = "";
        String PaymentMethod = "";
        String PaymentReferenceInt = "";
        String ChannelName = "";
        String Location = "";
        String IsReversal = "";
        String PaymentDate = "";
        String SettlementDate = "";
        String InstitutionId = "";
        String InstitutionName = "";
        String BranchName = "";
        String CustomerName = "";
        String OtherCustomerInfo = "";
        String ReceiptNo = "";
        String CollectionsAccount = "";
        String ThirdPartyCode = "";
        String ItemName = "";
        String ItemCode = "";
        String ItemAmount = "";
        String LeadBankCode = "";
        String LeadBankCbnCode = "";
        String LeadBankName = "";
        String BankCode = "";
        String CustomerPhoneNumber = "";
        String DepositorName = "";
        String DepositSlipNumber = "";
        String PaymentCurrency = "";
        String PaymentStatusMsg = "";
        //endregion

        //region Variable Decleration (Customer validation Nofication)
        String MerchantReference = "";
        String CustReference = "";
        //endregion

        String xmlHeader = "<?xml version='1.0' encoding='utf-8' ?>";

        //region HTTP GET Elements
        //Page.Response.ContentType = "text/xml";
        // Read XML posted via HTTP
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;
        try {
            InputStream inputStream = request.getInputStream();

            if (inputStream != null) {
                bufferedReader = new BufferedReader(new InputStreamReader(inputStream));

                char[] charBuffer = new char[1024];
                int bytesRead = -1;

                while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
                    stringBuilder.append(charBuffer, 0, bytesRead);
                }
            } else {
                stringBuilder.append("");
            }
        } catch (IOException ex) {
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException ex) {
                }
            }
        }

        String body = stringBuilder.toString();

        //endregion
        /**
         * XML reader that READ/PROCESS the get elements. READ -> Read through
         * the coming request. PROCESS -> This determines is the request if for
         * payment notification request.
         *
         */
        Random rab = new Random();
        long lo = rab.nextLong();
        String txid = Long.toHexString(lo);
        String remarks = "User login";
        String remoteip = request.getHeader("X-FORWARDED-FOR");
        String remotecontext = "";
        String remotemethod = "";
        String pathinfo = "";
        String remoteprotocol = "";
        String querystring = "";
        String remotehost = "";
        String remoteuser = "";
        String messagesent = body;
        if (remoteip == null) {
            remoteip = request.getRemoteAddr();
            remotecontext = request.getContextPath();
            remotemethod = request.getMethod();
            pathinfo = request.getPathInfo();
            remoteprotocol = request.getProtocol();
            querystring = request.getQueryString();
            remotehost = request.getRemoteHost();
            remoteuser = request.getRemoteUser();

        }
        
        Remotelogin rll = new Remotelogin(txid);
        rll.setRemoteip(remoteip);
        rll.setDateAccessed(settings.getCurrentDateTime());
        rll.setRemarks(remarks);
        rll.setRemoteContext(remotecontext);
        rll.setRemoteMethod(remotemethod);
        rll.setPathInfo(pathinfo);
        rll.setRemoteProtocol(remoteprotocol);
        rll.setQueryString(querystring);
        rll.setRemoteHost(remotehost);
        rll.setRemoteUser(remoteuser);
        rll.setMessageSent(messagesent);
        sess.newEntry(rll);

        if (body == null || body.length() == 0 || body.equals("")) {
            //send a black response
            String BadResponseValue = "You have not XML  post results request to work with";
            String Babsresponse = xmlHeader;
            Babsresponse += "<BadResponse>";
            Babsresponse += BadResponseValue;
            Babsresponse += "</BadResponse>";
            response.setContentType("text/xml");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(Babsresponse);

        } else {
            String ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null) {
                ipAddress = request.getRemoteAddr();
            }
            
            if (!settings.INterswitchIPs().contains(ipAddress)) {
                String BadResponseValue = "Unautorized client " + ipAddress + "cannot call this service";
                String Babsresponse = xmlHeader;
                Babsresponse += "<BadResponse>";
                Babsresponse += BadResponseValue;
                Babsresponse += "</BadResponse>";
                response.setContentType("text/xml");
                response.setHeader("Cache-Control", "no-cache");
                response.getWriter().write(Babsresponse);
            } else {
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                Document document;
                try {
                    DocumentBuilder builder = factory.newDocumentBuilder();
                    document = builder.parse(new InputSource(new StringReader(body)));
                    Element rootElement = document.getDocumentElement();
                    String ReaderRoot = rootElement.getNodeName();
                    //check the root header of the sent packet to know if the request is a customer validation or payment notification
                    if (ReaderRoot.contains("PaymentNotificationRequest")) //This handles payment Notification Request
                    {
                        try {
                            PaymentLogId = ((Element) rootElement.getElementsByTagName("PaymentLogId").item(0)).getTextContent();
                            PaymentCustReference = ((Element) rootElement.getElementsByTagName("CustReference").item(0)).getTextContent();
                            Amount = ((Element) rootElement.getElementsByTagName("Amount").item(0)).getTextContent();
                            PaymentStatus = ((Element) rootElement.getElementsByTagName("PaymentStatus").item(0)).getTextContent();
                            PaymentReferenceInt = ((Element) rootElement.getElementsByTagName("PaymentReference").item(0)).getTextContent();
                            IsReversal = ((Element) rootElement.getElementsByTagName("IsReversal").item(0)).getTextContent();

                            try {
                                ProductGroupCode = ((Element) rootElement.getElementsByTagName("ProductGroupCode").item(0)).getTextContent();
                                AlternateCustReference = ((Element) rootElement.getElementsByTagName("AlternateCustReference").item(0)).getTextContent();
                                PaymentMethod = ((Element) rootElement.getElementsByTagName("PaymentMethod").item(0)).getTextContent();
                                ChannelName = ((Element) rootElement.getElementsByTagName("ChannelName").item(0)).getTextContent();
                                Location = ((Element) rootElement.getElementsByTagName("Location").item(0)).getTextContent();
                                PaymentDate = ((Element) rootElement.getElementsByTagName("PaymentDate").item(0)).getTextContent();
                                SettlementDate = ((Element) rootElement.getElementsByTagName("SettlementDate").item(0)).getTextContent();
                                InstitutionId = ((Element) rootElement.getElementsByTagName("InstitutionId").item(0)).getTextContent();
                                InstitutionName = ((Element) rootElement.getElementsByTagName("InstitutionName").item(0)).getTextContent();
                                BranchName = ((Element) rootElement.getElementsByTagName("BranchName").item(0)).getTextContent();
                                CustomerName = ((Element) rootElement.getElementsByTagName("CustomerName").item(0)).getTextContent();
                                OtherCustomerInfo = ((Element) rootElement.getElementsByTagName("OtherCustomerInfo").item(0)).getTextContent();
                                ReceiptNo = ((Element) rootElement.getElementsByTagName("ReceiptNo").item(0)).getTextContent();
                                CollectionsAccount = ((Element) rootElement.getElementsByTagName("CollectionsAccount").item(0)).getTextContent();
                                ThirdPartyCode = ((Element) rootElement.getElementsByTagName("ThirdPartyCode").item(0)).getTextContent();
                                ItemName = ((Element) rootElement.getElementsByTagName("ItemName").item(0)).getTextContent();
                                ItemCode = ((Element) rootElement.getElementsByTagName("ItemCode").item(0)).getTextContent();
                                ItemAmount = ((Element) rootElement.getElementsByTagName("ItemAmount").item(0)).getTextContent();

                                LeadBankCode = ((Element) rootElement.getElementsByTagName("LeadBankCode").item(0)).getTextContent();
                                LeadBankCbnCode = ((Element) rootElement.getElementsByTagName("LeadBankCbnCode").item(0)).getTextContent();

                                LeadBankName = ((Element) rootElement.getElementsByTagName("LeadBankName").item(0)).getTextContent();
                                BankCode = ((Element) rootElement.getElementsByTagName("BankCode").item(0)).getTextContent();
                                CustomerPhoneNumber = ((Element) rootElement.getElementsByTagName("CustomerPhoneNumber").item(0)).getTextContent();
                                DepositorName = ((Element) rootElement.getElementsByTagName("DepositorName").item(0)).getTextContent();
                                DepositSlipNumber = ((Element) rootElement.getElementsByTagName("DepositSlipNumber").item(0)).getTextContent();
                                PaymentCurrency = ((Element) rootElement.getElementsByTagName("PaymentCurrency").item(0)).getTextContent();
                            } catch (DOMException js) {
                            }
                        } catch (DOMException e) {
                        }
                        boolean bitReversal;
                        bitReversal = IsReversal.equalsIgnoreCase("True");
                        int inthouseStatus = 0;
                        String inhouseStatus = Integer.toString(inthouseStatus);
                        if (!"".equals(PaymentLogId) && !"".equals(PaymentCustReference) && !"".equals(Amount)) {
                            Paymentreference dd = sess.getPaymentreference(PaymentCustReference);
                            if (dd != null) {
                                Courses cos = sess.getCourses(dd.getCourseId());
                                    boolean fromchs = false;
                                    if(cos != null){
                                        if(cos.getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")){
                                            fromchs = true;
                                        }
                                    }
                                    if (!fromchs) {
                                    //region Check if a  dupulicate already exist on the system
                                    //DatabaseUtility dbUtility = new DatabaseUtility();
                                    double insideamnt = 0.0;
                                    double outsideamnt = 0.0;
                                    try {
                                        insideamnt = dd.getAmount();
                                        outsideamnt = Double.parseDouble(Amount);
                                    } catch (NumberFormatException j) {
                                    }
                                    boolean dublicateCheck = sess.checkPaymentNotification(PaymentLogId, Amount, PaymentCustReference, PaymentReferenceInt, bitReversal);
                                    if (insideamnt == 0.0 || insideamnt != outsideamnt) {
                                        inthouseStatus = 1;
                                    }
                                    inhouseStatus = Integer.toString(inthouseStatus);
                                    //normal scinerio
                                    if (dublicateCheck == false && insideamnt == Math.abs(outsideamnt)) {
                                        //Case of Reversal
                                        if (outsideamnt < 0 && bitReversal == true) {

                                            String transid = PaymentLogId + Amount;
                                            Paymentnotification pn = new Paymentnotification(transid);
                                            pn.setPaymentLogId(PaymentLogId);
                                            pn.setProductGroupCode(ProductGroupCode);
                                            pn.setCustReference(PaymentCustReference);
                                            pn.setAlternateCustReference(AlternateCustReference);
                                            pn.setAmount(Double.valueOf(Amount));
                                            pn.setPaymentStatus(PaymentStatus);
                                            pn.setPaymentMethod(PaymentMethod);
                                            pn.setPaymentReference(PaymentReferenceInt);
                                            pn.setChannelName(ChannelName);
                                            pn.setLocation(Location);
                                            pn.setIsReversal(IsReversal);
                                            pn.setPaymentDate(PaymentDate);
                                            pn.setSettlementDate(SettlementDate);
                                            pn.setInstitutionId(InstitutionId);
                                            pn.setInstitutionName(InstitutionName);
                                            pn.setBranchName(BranchName);
                                            pn.setCustomerName(CustomerName);
                                            pn.setOtherCustomerInfo(OtherCustomerInfo);
                                            pn.setReceiptNo(ReceiptNo);
                                            pn.setCollectionAccount(CollectionsAccount);
                                            pn.setThirdPartyCode(ThirdPartyCode);
                                            pn.setItemName(ItemName);
                                            pn.setItemCode(ItemCode);
                                            pn.setItemAmount(ItemAmount);
                                            pn.setLeadBankCode(LeadBankCode);
                                            pn.setLeadBankCbnCode(LeadBankCbnCode);
                                            pn.setLeadBankName(LeadBankName);
                                            pn.setBankCode(BankCode);
                                            pn.setCustomerPhoneNumber(CustomerPhoneNumber);
                                            pn.setDepositorName(DepositorName);
                                            pn.setDepositSlipNumber(DepositSlipNumber);
                                            pn.setPaymentCurrency(PaymentCurrency);
                                            pn.setPaymentStatusMsg(PaymentStatusMsg);
                                            pn.setInHouseStatus(inhouseStatus);
                                            try {
                                                sess.newEntry(pn);
                                                sess.updatePaymentreference(PaymentCustReference, PaymentStatusMsg, PaymentReferenceInt, BankCode,BankCode, settings.getCurrentDateTime(), "REVERSED");
                                                inhouseStatus = "0";
                                                PaymentStatusMsg = "Payment Reversal Received";
                                                try {
                                                    Paymenttrash trash = new Paymenttrash(PaymentCustReference);
                                                    trash.setComment("auto deleted");
                                                    trash.setDateTrashed(settings.getCurrentDateTime());
                                                    Payments pad = sess.getPayments(PaymentCustReference);
                                                    trash.setPayments(pad);
                                                    trash.setTrashedBy(pad.getPayerId());
                                                    sess.newEntry(trash);
                                                } catch (Exception m) {
                                                }

                                            } catch (Exception js) {
                                                inhouseStatus = "1";
                                                PaymentStatusMsg = "Payment Reversal in error";
                                            }
                                        } else if (outsideamnt > 0 && bitReversal == false) {
                                            //Normal Condition
                                            String transid = PaymentLogId + Amount;
                                            Paymentnotification pn = new Paymentnotification(transid);
                                            pn.setPaymentLogId(PaymentLogId);
                                            pn.setProductGroupCode(ProductGroupCode);
                                            pn.setCustReference(PaymentCustReference);
                                            pn.setAlternateCustReference(AlternateCustReference);
                                            pn.setAmount(Double.valueOf(Amount));
                                            pn.setPaymentStatus(PaymentStatus);
                                            pn.setPaymentMethod(PaymentMethod);
                                            pn.setPaymentReference(PaymentReferenceInt);
                                            pn.setChannelName(ChannelName);
                                            pn.setLocation(Location);
                                            pn.setIsReversal(IsReversal);
                                            pn.setPaymentDate(PaymentDate);
                                            pn.setSettlementDate(SettlementDate);
                                            pn.setInstitutionId(InstitutionId);
                                            pn.setInstitutionName(InstitutionName);
                                            pn.setBranchName(BranchName);
                                            pn.setCustomerName(CustomerName);
                                            pn.setOtherCustomerInfo(OtherCustomerInfo);
                                            pn.setReceiptNo(ReceiptNo);
                                            pn.setCollectionAccount(CollectionsAccount);
                                            pn.setThirdPartyCode(ThirdPartyCode);
                                            pn.setItemName(ItemName);
                                            pn.setItemCode(ItemCode);
                                            pn.setItemAmount(ItemAmount);
                                            pn.setLeadBankCode(LeadBankCode);
                                            pn.setLeadBankCbnCode(LeadBankCbnCode);
                                            pn.setLeadBankName(LeadBankName);
                                            pn.setBankCode(BankCode);
                                            pn.setCustomerPhoneNumber(CustomerPhoneNumber);
                                            pn.setDepositorName(DepositorName);
                                            pn.setDepositSlipNumber(DepositSlipNumber);
                                            pn.setPaymentCurrency(PaymentCurrency);
                                            pn.setPaymentStatusMsg(PaymentStatusMsg);
                                            pn.setInHouseStatus(inhouseStatus);

                                            try {
                                                sess.newEntry(pn);
                                                sess.updatePaymentreference(PaymentCustReference, PaymentStatusMsg, PaymentReferenceInt, BankCode,BankCode, settings.getCurrentDateTime(), "PAID");
                                                inhouseStatus = "0";
                                                PaymentStatusMsg = "Payment Received";
                                                try {
                                                    sess.addToPayment(PaymentCustReference, Double.parseDouble(Amount),dd.getPayerId(), dd.getPayerRegistrationIo(),
                                                            dd.getPayerName(), dd.getSession(), dd.getSemester(), dd.getCourseId(), dd.getFeesGroupId().getId(),
                                                            dd.getLevel(), BankCode);
                                                   
                                                } catch (NumberFormatException m) {
                                                }
                                            } catch (Exception js) {
                                                inhouseStatus = "1";
                                                PaymentStatusMsg = "Payment in error";
                                            }
                                        }

                                        //newDbUtitlity.InsertPaymentNotification(PaymentLogId, Amount, CustReference, PaymentReferenceInt, PaymentDate, SettlementDate, RecieptNo, DepositSlipNumber, bitReversal);
                                    }
                                    //incorrect amount
                                    if (dublicateCheck == false && Math.abs(insideamnt) != Math.abs(outsideamnt)) {
                                        inhouseStatus = "1";
                                        PaymentStatusMsg = "Incorrect amount supplied";
                                    }
                                    //Invalid refernce
                                    if (dublicateCheck == false && insideamnt == 0.0) {
                                        PaymentStatusMsg = "Invalid Payment Reference";
                                        inhouseStatus = "1";
                                    }
                                    //Case of Duplicate Posting
                                    if (dublicateCheck == true) {
                                        if (insideamnt == 0.0) {
                                            PaymentStatusMsg = "Invalid Payment Reference";
                                        } else {
                                            if (bitReversal == true) {
                                                PaymentStatusMsg = "Payment Reversal Received Duplicate";
                                                inhouseStatus = "0";
                                            } else {
                                                PaymentStatusMsg = "Payment Received Duplicate";
                                                inhouseStatus = "0";
                                            }
                                        }
                                    }
                                } else {
                                    inhouseStatus = "1";
                                    PaymentStatusMsg = "Payment Reference is for CHS ";
                                }
                            } else {
                                inhouseStatus = "1";
                                PaymentStatusMsg = "Invalid Payment Reference " + PaymentCustReference;
                            }
                        } else {
                            inhouseStatus = "1";
                            PaymentStatusMsg = "Incomplete Data Supplied";
                        }
                        //endregion

                        ///region Payment Response XML (HTTP_POST)
                        //using String  Approach
                        String PaymentNotPacket = xmlHeader;
                        PaymentNotPacket += "<PaymentNotificationResponse>";
                        PaymentNotPacket += "<Payments>";
                        PaymentNotPacket += "<Payment>";
                        PaymentNotPacket += "<PaymentLogId>";
                        PaymentNotPacket += PaymentLogId;
                        PaymentNotPacket += "</PaymentLogId>";
                        PaymentNotPacket += "<Status>";
                        PaymentNotPacket += inhouseStatus;
                        PaymentNotPacket += "</Status>";
                        PaymentNotPacket += "<StatusMessage>";
                        PaymentNotPacket += PaymentStatusMsg;
                        PaymentNotPacket += "</StatusMessage>";
                        PaymentNotPacket += "</Payment>";
                        PaymentNotPacket += "</Payments>";
                        PaymentNotPacket += "</PaymentNotificationResponse>";
                        //endregion //send packets response to the HTTP posting agent. The commented section is activated when you need to use the String approach
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(PaymentNotPacket);

                    } else if (ReaderRoot.equalsIgnoreCase("CustomerInformationRequest")) //This handles the Customer Validation Request
                    {
                        //region using HTTP_POST Approach (Customer Validation Nofication)
                        try {
                            try {
                                MerchantReference = ((Element) rootElement.getElementsByTagName("MerchantReference").item(0)).getTextContent();
                                CustReference = ((Element) rootElement.getElementsByTagName("CustReference").item(0)).getTextContent();
                            } catch (DOMException ja) {
                            }

                            //region This checks the database for existing customer  record and  assign 
                            //information to the variables that is sent as a response.DatabaseUtility dbcustUtility = new DatabaseUtility();
                            if (!CustReference.equals("")) {
                                Paymentreference CustomerDetails = sess.getPaymentreference(CustReference);
                                String custst = "1";
                                if (CustomerDetails != null) {
                                    String CustStatus = CustomerDetails.getPaidStatus();
                                    if(CustStatus.equals("PENDING")){
                                    custst = "0";    
                                    }
                                    if(CustStatus.equals("PAID")){
                                    custst = "2";    
                                    }
                                    if(CustStatus.equals("REVERSED")){
                                    custst = "1";    
                                    }
                                    
                                    String[] names;
                                    String FirstName="";
                                    String OtherName="";
                                    String LastName="";
                                    try{
                                    if(CustomerDetails.getPayerName().contains(" ")){
                                        names = CustomerDetails.getPayerName().split(" ");
                                        try{
                                            LastName = names[0];
                                        }catch(Exception g){}
                                         try{
                                            FirstName = names[1];
                                        }catch(Exception g){}
                                          try{
                                            OtherName = names[2];
                                        }catch(Exception g){}
                                    }
                                    }catch(Exception k){}
                                    String Email = CustomerDetails.getEmailAddress();
                                    String Phone = CustomerDetails.getPhoneNo();
                                    Courses cos = sess.getCourses(CustomerDetails.getCourseId());
                                    boolean fromchs = false;
                                    if(cos != null){
                                        if(cos.getSchoolProgrammeId().getSchoolId().getId().equalsIgnoreCase("S003")){
                                            fromchs = true;
                                        }
                                    }
                                    if (!fromchs) {
                                        if (custst.equalsIgnoreCase("0")) {
                                            String custValPacket = xmlHeader;
                                            custValPacket += "<CustomerInformationResponse>";
                                            custValPacket += "<MerchantReference>";
                                            custValPacket += MerchantReference;
                                            custValPacket += "</MerchantReference>";
                                            custValPacket += "<Customers>";
                                            custValPacket += "<Customer>";
                                            custValPacket += "<Status>";
                                            custValPacket += custst;
                                            custValPacket += "</Status>";
                                            custValPacket += "<CustReference>";
                                            custValPacket += CustReference;
                                            custValPacket += "</CustReference>";
                                            custValPacket += "<CustomerReferenceAlternate></CustomerReferenceAlternate>";
                                            custValPacket += "<CustomerReferenceDescription>" + CustomerDetails.getFeesGroupId().getDescription()+ "</CustomerReferenceDescription>";
                                            custValPacket += "<FirstName>" + FirstName + "</FirstName>";
                                            custValPacket += "<LastName>" + LastName + "</LastName>";
                                            custValPacket += "<OtherName>" + OtherName + "</OtherName>";
                                            custValPacket += "<Email>" + Email + "</Email>";
                                            custValPacket += "<Phone>" + Phone + "</Phone>";
                                            custValPacket += "<ThirdPartyCode></ThirdPartyCode>";
                                            custValPacket += "<Amount>" + CustomerDetails.getAmount() + "</Amount>";
                                            custValPacket += "<PaymentItems>";
                                            custValPacket += "<Item>";
                                            custValPacket += "<ProductName>" + CustomerDetails.getFeesGroupId().getName() + "</ProductName>";
                                            custValPacket += "<ProductCode>" + CustomerDetails.getFeesGroupId().getId()+ "</ProductCode>";
                                            custValPacket += "<Quantity>1</Quantity>";
                                            custValPacket += "<Price>" + CustomerDetails.getAmount() + "</Price>";
                                            custValPacket += "<Subtotal>" + CustomerDetails.getAmount() + "</Subtotal>";
                                            custValPacket += "<Tax>0</Tax>";
                                            custValPacket += "<Total>" + CustomerDetails.getAmount() + "</Total>";
                                            custValPacket += "</Item>";
                                            custValPacket += "</PaymentItems>";
                                            custValPacket += "</Customer>";
                                            custValPacket += "</Customers>";
                                            custValPacket += "</CustomerInformationResponse>";

                                            response.setContentType("text/xml");
                                            response.setHeader("Cache-Control", "no-cache");
                                            response.getWriter().write(custValPacket);
                                        }
                                    } else {
                                        String custValPacket = xmlHeader;
                                        custValPacket += "<CustomerInformationResponse>";
                                        custValPacket += "<MerchantReference>";
                                        custValPacket += MerchantReference;
                                        custValPacket += "</MerchantReference>";
                                        custValPacket += "<Customers>";
                                        custValPacket += "<Customer>";
                                        custValPacket += "<Status>1</Status>";
                                        custValPacket += "<CustReference>";
                                        custValPacket += CustReference;
                                        custValPacket += "</CustReference>";
                                        custValPacket += "</Customer>";
                                        custValPacket += "</Customers>";
                                        custValPacket += "</CustomerInformationResponse>";
                                        response.setContentType("text/xml");
                                        response.setHeader("Cache-Control", "no-cache");
                                        response.getWriter().write(custValPacket);
                                    }
                                }
                                if (custst.equalsIgnoreCase("1") || custst.equalsIgnoreCase("2")) {

                                    String custValPacket = xmlHeader;
                                    custValPacket += "<CustomerInformationResponse>";
                                    custValPacket += "<MerchantReference>";
                                    custValPacket += MerchantReference;
                                    custValPacket += "</MerchantReference>";
                                    custValPacket += "<Customers>";
                                    custValPacket += "<Customer>";
                                    custValPacket += "<Status>" + custst + "</Status>";
                                    custValPacket += "<CustReference>";

                                    custValPacket += CustReference;
                                    custValPacket += "</CustReference>";
                                    custValPacket += "</Customer>";
                                    custValPacket += "</Customers>";
                                    custValPacket += "</CustomerInformationResponse>";
                                    response.setContentType("text/xml");
                                    response.setHeader("Cache-Control", "no-cache");
                                    response.getWriter().write(custValPacket);
                                }
                            } else {
                                String custValPacket = xmlHeader;
                                custValPacket += "<CustomerInformationResponse>";
                                custValPacket += "<MerchantReference>";
                                custValPacket += MerchantReference;
                                custValPacket += "</MerchantReference>";
                                custValPacket += "<Customers>";
                                custValPacket += "<Customer>";
                                custValPacket += "<Status>1</Status>";
                                custValPacket += "<CustReference>";
                                custValPacket += CustReference;
                                custValPacket += "</CustReference>";
                                custValPacket += "</Customer>";
                                custValPacket += "</Customers>";
                                custValPacket += "</CustomerInformationResponse>";
                                response.setContentType("text/xml");
                                response.setHeader("Cache-Control", "no-cache");
                                response.getWriter().write(custValPacket);
                            }
                        } catch (IOException c) {
                            String custValPacket = xmlHeader;
                            custValPacket += "<CustomerInformationResponse>";
                            custValPacket += "<MerchantReference>";
                            custValPacket += MerchantReference;
                            custValPacket += "</MerchantReference>";
                            custValPacket += "<Customers>";
                            custValPacket += "<Customer>";
                            custValPacket += "<Status>1</Status>";
                            custValPacket += "<CustReference>";

                            custValPacket += CustReference;
                            custValPacket += "</CustReference>";
                            custValPacket += "</Customer>";
                            custValPacket += "</Customers>";
                            custValPacket += "</CustomerInformationResponse>";
                            response.setContentType("text/xml");
                            response.setHeader("Cache-Control", "no-cache");
                            response.getWriter().write(custValPacket);
                        }

                    } else {
                        String BadResponseValue = "Unrecognized Request";
                        String Babsresponse = xmlHeader;
                        Babsresponse += "<BadResponse>";
                        Babsresponse += BadResponseValue;
                        Babsresponse += "</BadResponse>";
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(Babsresponse);
                    }

                } catch (ParserConfigurationException | SAXException | IOException ex) {
                    String BadResponseValue = "Malformed XML Request - " + ex.getMessage();
                    String Babsresponse = xmlHeader;
                    Babsresponse += "<BadResponse>";
                    Babsresponse += BadResponseValue;
                    Babsresponse += "</BadResponse>";
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write(Babsresponse);
                }
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
