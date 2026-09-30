/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.resources;

import com.google.gson.Gson;
import com.mnl.eduportal.entities.Feesgroup;
import com.mnl.eduportal.entities.Paymentreference;
import com.mnl.eduportal.entities.Payments;
import com.mnl.eduportal.entities.Students;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.PaymentreferenceDetail;
import com.mnl.eduportal.util.Settings;
import com.mnl.eduportal.util.apis.PaymentRequestRequest;
import com.mnl.eduportal.util.apis.sendPaymentRequest;
import jakarta.inject.Inject;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

/**
 *
 * @author nguuma-ayua
 */
@Path("payments")
public class EPayment {

    @Inject
    private MainSession sess;
    private Settings settings = new Settings();

    @POST
    @Path("getPaymentRequest")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response validatePaymentReference(@HeaderParam("Authorization") String authorization, String jsonText) {
        Response responseBody = null;
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            JsonObject responseJson = Json.createObjectBuilder()
                    .add("status", "ERROR")
                    .add("message", "Missig or invalid Bearer token")
                    .add("body", "")
                    .build();
            responseBody = Response.status(Response.Status.UNAUTHORIZED)
                    .entity(responseJson.toString())
                    .build();
        } else {
            String token = authorization.substring(7);
            if (token.isEmpty()) {
                JsonObject responseJson = Json.createObjectBuilder()
                        .add("status", "ERROR")
                        .add("message", "No Bearer token provided")
                        .add("body", "")
                        .build();
                responseBody = Response.status(Response.Status.UNAUTHORIZED)
                        .entity(responseJson.toString())
                        .build();
            } else {
                boolean valid = sess.validateToken(token);
                if (valid) {
                    Gson gson = new Gson();
                    try {
                        PaymentRequestRequest preq = gson.fromJson(jsonText, PaymentRequestRequest.class);
                        if (preq.getRegno() != null && preq.getFeesGroupId() != null) {
                            Feesgroup fg = (Feesgroup) sess.getSingleObject(Feesgroup.class, preq.getFeesGroupId());
                            if (fg != null) {
                                String cat = fg.getCategory();
                                if (cat.equalsIgnoreCase("Applicants")) {

                                }
                                if (cat.equalsIgnoreCase("Students")) {
                                    Paymentreference pr = new Paymentreference(preq.getId(),
                                            preq.getTotal(), preq.getRegno(), settings.getCurrentDateTime(), "PENDING", null,
                                            preq.getSessions(), preq.getSemester(), "", "", "", "", preq.getFullName(),
                                            preq.getPhoneNo(), preq.getEmail(), "", fg,
                                            sess.getSchools(preq.getSchoolId()));
                                    pr.setPayerRegistrationIo(preq.getRegno());
                                    pr.setCourseId(preq.getCourse());
                                    pr.setLevel(preq.getLevel());
                                    sess.newEntry(pr);
                                }
                                String quickteller = settings.quickteller_url;
                                if (fg.getSchoolId().getId().equalsIgnoreCase("S003")) {
                                    quickteller = settings.chs_quickteller_url;
                                }
                                String returnurl = quickteller;
                                JsonObject responseJson = Json.createObjectBuilder()
                                        .add("status", "SUCCESS")
                                        .add("message", "Your record will be processed")
                                        .add("body", returnurl)
                                        .build();
                                responseBody = Response.status(Response.Status.UNAUTHORIZED)
                                        .entity(responseJson.toString())
                                        .build();
                            }

                        }
                    } catch (Exception k) {
                    }
                } else {
                    JsonObject responseJson = Json.createObjectBuilder()
                            .add("status", "ERROR")
                            .add("message", "Invalid Bearer token")
                            .add("body", "")
                            .build();
                    responseBody = Response.status(Response.Status.UNAUTHORIZED)
                            .entity(responseJson.toString())
                            .build();
                }
            }
        }
        return responseBody;
    }

    @POST
    @Path("sendPayment")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPaymentDetails(@HeaderParam("Authorization") String authorization, String jsonText) {
        Response responseBody = null;
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            JsonObject responseJson = Json.createObjectBuilder()
                    .add("status", "ERROR")
                    .add("message", "Missig or invalid Bearer token")
                    .add("body", "")
                    .build();
            responseBody = Response.status(Response.Status.UNAUTHORIZED)
                    .entity(responseJson.toString())
                    .build();
        } else {
            String token = authorization.substring(7);
            if (token.isEmpty()) {
                JsonObject responseJson = Json.createObjectBuilder()
                        .add("status", "ERROR")
                        .add("message", "No Bearer token provided")
                        .add("body", "")
                        .build();
                responseBody = Response.status(Response.Status.UNAUTHORIZED)
                        .entity(responseJson.toString())
                        .build();
            } else {
                boolean valid = sess.validateToken(token);
                if (valid) {
                    Gson gson = new Gson();
                    try {
                         sendPaymentRequest preq = gson.fromJson(jsonText, sendPaymentRequest.class);
                        if (preq.getRefno()!= null) {
                            Payments pay = sess.getPayments(preq.getRefno());
                            boolean bo = false;
                            if(pay != null){
                                bo = true;
                            }
                            settings.postPaymentStatus(preq.getRefno(), bo);;
                              String returnurl = "{\"paymentRef\":\"" + preq.getRefno() + "\",\"status\":"+bo+"}";
                        JsonObject responseJson = Json.createObjectBuilder()
                                .add("status", "SUCCESS")
                                .add("message", "Your record will be processed")
                                .add("body", returnurl)
                                .build();
                        responseBody = Response.status(Response.Status.UNAUTHORIZED)
                                .entity(responseJson.toString())
                                .build();
                        }
                       
                    } catch (Exception k) {
                    }
                } else {
                    JsonObject responseJson = Json.createObjectBuilder()
                            .add("status", "ERROR")
                            .add("message", "Invalid Bearer token")
                            .add("body", "")
                            .build();
                    responseBody = Response.status(Response.Status.UNAUTHORIZED)
                            .entity(responseJson.toString())
                            .build();
                }
            }
        }
        return responseBody;
    }
}
