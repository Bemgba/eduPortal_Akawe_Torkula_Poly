package com.mnl.eduportal.resources;

import com.google.gson.Gson;
import com.mnl.eduportal.sessions.MainSession;
import com.mnl.eduportal.util.Settings;
import jakarta.inject.Inject;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

/**
 *
 * @author
 */
@Path("general")
public class JakartaEE11Resource {

    @Inject
    private MainSession sess;
    private Settings settings = new Settings();

    @GET
    public Response ping() {
        return Response
                .ok("ping Jakarta EE")
                .build();
    }

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
                        String returnurl = "yoururl";
                        JsonObject responseJson = Json.createObjectBuilder()
                                .add("status", "SUCCESS")
                                .add("message", "Your record will be processed")
                                .add("body", returnurl)
                                .build();
                        responseBody = Response.status(Response.Status.UNAUTHORIZED)
                                .entity(responseJson.toString())
                                .build();
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
