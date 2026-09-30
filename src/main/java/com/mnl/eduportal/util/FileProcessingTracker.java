/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import java.util.concurrent.ConcurrentHashMap;

/**
 *
 * @author eaglescan
 */
public class FileProcessingTracker {

    private static final ConcurrentHashMap<String, String> statusMap = new ConcurrentHashMap<>();

    public static void updateStatus(String fileId, String status) {
        statusMap.put(fileId, status);
    }

    public static String getStatus(String fileId) {
        return statusMap.getOrDefault(fileId, "Unknown");
    }
}
