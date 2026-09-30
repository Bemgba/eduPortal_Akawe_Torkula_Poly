/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.resources;

import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.HeaderParam;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.StringReader;

/**
 *
 * @author 
 */
@Path("admissionsService")
public class AdmissionsService {
    
    @POST
    @Path("process") // Endpoint: /apis/admissionsService/process
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response processUser(@HeaderParam("Authorization") String authorization, String jsonText) {

        // Validate Bearer Token format
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            return Response.status(Response.Status.UNAUTHORIZED)
                           .entity("{\"error\": \"Missing or invalid Bearer token\"}")
                           .build();
        }

        // Extract the actual token (remove "Bearer " prefix)
        String token = authorization.substring(7);

        // Validate token (You can replace this with actual token verification logic)
        if (token.isEmpty()) {
            return Response.status(Response.Status.UNAUTHORIZED)
                           .entity("{\"error\": \"Invalid token\"}")
                           .build();
        }

        // Parse JSON text
        JsonObject json;
        try (JsonReader jsonReader = Json.createReader(new StringReader(jsonText))) {
            json = jsonReader.readObject();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                           .entity("{\"error\": \"Invalid JSON format\"}")
                           .build();
        }

        // Extract a field from JSON (modify as needed)
        String username = json.getString("username", "unknown");

        // Create JSON response
        JsonObject responseJson = Json.createObjectBuilder()
                                      .add("message", "User processed successfully")
                                      .add("username", username)
                                      .add("token", token)
                                      .build();

        return Response.ok(responseJson.toString()).build();
    }
}
