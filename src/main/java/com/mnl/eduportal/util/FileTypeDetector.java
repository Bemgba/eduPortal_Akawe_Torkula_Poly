/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import java.util.HashMap;
import java.util.Map;

public class FileTypeDetector {
    private static final Map<String, String> mimeTypes = new HashMap<>();

    static {
        mimeTypes.put("pdf", "application/pdf");
        mimeTypes.put("jpg", "image/jpeg");
        mimeTypes.put("jpeg", "image/jpeg");
        mimeTypes.put("png", "image/png");
        mimeTypes.put("doc", "application/msword");
        mimeTypes.put("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        mimeTypes.put("xls", "application/vnd.ms-excel");
        mimeTypes.put("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        mimeTypes.put("txt", "text/plain");
        mimeTypes.put("csv", "text/csv");
        mimeTypes.put("mp4", "video/mp4");
        mimeTypes.put("mp3", "audio/mpeg");
    }

    public static String getMimeType(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "application/octet-stream"; // Default unknown type
        }
        String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        return mimeTypes.getOrDefault(ext, "application/octet-stream");
    }

    public static void main(String[] args) {
        String fileType = getMimeType(".pdf");
        System.out.println("MIME Type: " + fileType);
    }
}