/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import com.google.gson.Gson;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 *
 * @author nguuma-ayua
 */
public class ExamWS {

    public String baseurl = "https://bsum-ug.com";

    public ExamWS() {
    }

    public static void main(String[] a) {
        ExamWS man = new ExamWS();
        ExamWSCourseRegistrationResquestRequest data = new ExamWSCourseRegistrationResquestRequest(
                "202440208331af", "C52295", "2024/2025", "100"
        );
        ExamWSCourseRegistrationResquestResponse result = man.CourseRegistrationResquest(data);
        Gson gson = new Gson();
        String rest = gson.toJson(result);
        System.out.println(rest);
    }

    public ExamWSCourseRegistrationResquestResponse CourseRegistrationResquest(ExamWSCourseRegistrationResquestRequest myrequest) {
        ExamWSCourseRegistrationResquestResponse result = null;
        try {
            Gson gson = new Gson();
            String payload = gson.toJson(myrequest);
            URL url = new URL(baseurl + "/CourseRegistrationResquest");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; utf-8");
            conn.setRequestProperty("Accept", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            InputStream is = (code < HttpURLConnection.HTTP_BAD_REQUEST)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            BufferedReader br = new BufferedReader(new InputStreamReader(is, "utf-8"));
            StringBuilder response = new StringBuilder();
            String responseLine;

            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }

            String responseText = response.toString();
            result = gson.fromJson(responseText, ExamWSCourseRegistrationResquestResponse.class);
        } catch (Exception d) {
        }
        return result;
    }
}
