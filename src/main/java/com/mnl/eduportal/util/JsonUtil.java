/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;
import jakarta.servlet.http.HttpServletResponse; // or javax.servlet if Java EE
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;

public class JsonUtil {
    private static final Gson GSON = new Gson();

    public static String toJson(Object obj) {
        return GSON.toJson(obj);
    }

    public static void writeJson(HttpServletResponse resp, int status, Object body) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        try (PrintWriter writer = resp.getWriter()) {
            writer.write(GSON.toJson(body));
        }
    }
}


