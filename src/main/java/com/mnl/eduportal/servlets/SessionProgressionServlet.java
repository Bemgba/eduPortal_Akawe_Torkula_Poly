package com.mnl.eduportal.servlets;

import com.google.gson.Gson;
import com.mnl.eduportal.sessions.MainSession;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * Servlet for handling real-time session progression with AJAX polling
 * Provides endpoints for starting, monitoring, pausing, and cancelling progression
 * 
 * @author Kiro AI Assistant
 */
@WebServlet(name = "SessionProgressionServlet", urlPatterns = {"/api/session-progression/*"})
public class SessionProgressionServlet extends HttpServlet {

    @EJB
    private MainSession mainSession;
    
    private static final ExecutorService executorService = Executors.newCachedThreadPool();
    private static final Map<String, ProgressionTask> activeTasks = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    
    /**
     * Inner class to track progression task state
     */
    private static class ProgressionTask {
        String sessionId;
        Future<?> future;
        ProgressionStatus status;
        long startTime;
        volatile boolean cancelled = false;
        volatile boolean paused = false;
        
        public ProgressionTask(String sessionId, Future<?> future) {
            this.sessionId = sessionId;
            this.future = future;
            this.status = new ProgressionStatus();
            this.startTime = System.currentTimeMillis();
        }
    }
    
    /**
     * Inner class to hold progression status
     */
    private static class ProgressionStatus {
        volatile int totalStudents = 0;
        volatile int processedStudents = 0;
        volatile int failedStudents = 0;
        volatile int currentBatch = 0;
        volatile int totalBatches = 0;
        volatile boolean completed = false;
        List<LogMessage> messages = new ArrayList<>();
        
        public synchronized void addMessage(String text, String type) {
            messages.add(new LogMessage(text, type));
            // Keep only last 50 messages
            if (messages.size() > 50) {
                messages.remove(0);
            }
        }
        
        public synchronized void updateProgress(int total, int processed, int failed, int batch, int totalBatch) {
            this.totalStudents = total;
            this.processedStudents = processed;
            this.failedStudents = failed;
            this.currentBatch = batch;
            this.totalBatches = totalBatch;
        }
    }
    
    /**
     * Inner class for log messages
     */
    private static class LogMessage {
        String text;
        String type;
        long timestamp;
        
        public LogMessage(String text, String type) {
            this.text = text;
            this.type = type;
            this.timestamp = System.currentTimeMillis();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/status".equals(pathInfo)) {
            handleStatusRequest(request, response);
        } else {
            sendError(response, "Invalid endpoint");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/start".equals(pathInfo)) {
            handleStartRequest(request, response);
        } else if ("/cancel".equals(pathInfo)) {
            handleCancelRequest(request, response);
        } else if ("/pause".equals(pathInfo)) {
            handlePauseRequest(request, response);
        } else if ("/resume".equals(pathInfo)) {
            handleResumeRequest(request, response);
        } else {
            sendError(response, "Invalid endpoint");
        }
    }
    
    /**
     * Start progression processing in background thread
     */
    private void handleStartRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sendError(response, "Session ID is required");
            return;
        }
        
        // Check if already processing
        if (activeTasks.containsKey(sessionId)) {
            sendError(response, "Progression already in progress for this session");
            return;
        }
        
        // Create task and add to active tasks first
        ProgressionTask task = new ProgressionTask(sessionId, null);
        activeTasks.put(sessionId, task);
        
        // Start processing in background
        Future<?> future = executorService.submit(() -> {
            ProgressionTask currentTask = activeTasks.get(sessionId);
            if (currentTask == null) return;
            
            try {
                currentTask.status.addMessage("Initializing progression processing...", "info");
                
                // Call the batched progression method
                Map<String, Object> result = mainSession.createSessionProgressionBatched(sessionId);
                
                // Extract results
                Integer totalStudents = (Integer) result.get("totalStudents");
                Integer processedStudents = (Integer) result.get("processedStudents");
                Integer failedStudents = (Integer) result.get("failedStudents");
                Integer totalBatches = (Integer) result.get("totalBatches");
                
                // Update final status
                if (totalStudents != null) {
                    currentTask.status.updateProgress(
                        totalStudents,
                        processedStudents != null ? processedStudents : 0,
                        failedStudents != null ? failedStudents : 0,
                        totalBatches != null ? totalBatches : 0,
                        totalBatches != null ? totalBatches : 0
                    );
                }
                
                currentTask.status.completed = true;
                
                Boolean success = (Boolean) result.get("success");
                if (success != null && success) {
                    currentTask.status.addMessage("Progression completed successfully!", "success");
                } else {
                    currentTask.status.addMessage("Progression completed with errors", "error");
                    
                    @SuppressWarnings("unchecked")
                    List<String> errors = (List<String>) result.get("errors");
                    if (errors != null) {
                        for (String error : errors) {
                            currentTask.status.addMessage(error, "error");
                        }
                    }
                }
                
            } catch (Exception e) {
                currentTask.status.addMessage("Error during processing: " + e.getMessage(), "error");
                currentTask.status.completed = true;
                e.printStackTrace();
            }
        });
        
        task.future = future;
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Processing started");
        
        sendJson(response, responseData);
    }
    
    /**
     * Get current status of progression
     */
    private void handleStatusRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sendError(response, "Session ID is required");
            return;
        }
        
        ProgressionTask task = activeTasks.get(sessionId);
        
        if (task == null) {
            sendError(response, "No active progression found for this session");
            return;
        }
        
        // Get real-time progress from MainSession
        com.mnl.eduportal.sessions.MainSession.ProgressionProgress liveProgress = 
            mainSession.getProgressionProgress(sessionId);
        
        Map<String, Object> responseData = new HashMap<>();
        
        if (liveProgress != null) {
            // Use live progress data from MainSession
            responseData.put("totalStudents", liveProgress.totalStudents);
            responseData.put("processedStudents", liveProgress.processedStudents);
            responseData.put("failedStudents", liveProgress.failedStudents);
            responseData.put("currentBatch", liveProgress.currentBatch);
            responseData.put("totalBatches", liveProgress.totalBatches);
            responseData.put("completed", liveProgress.completed);
            
            // Update task status with live data
            task.status.updateProgress(
                liveProgress.totalStudents,
                liveProgress.processedStudents,
                liveProgress.failedStudents,
                liveProgress.currentBatch,
                liveProgress.totalBatches
            );
            task.status.completed = liveProgress.completed;
        } else {
            // Fallback to task status
            responseData.put("totalStudents", task.status.totalStudents);
            responseData.put("processedStudents", task.status.processedStudents);
            responseData.put("failedStudents", task.status.failedStudents);
            responseData.put("currentBatch", task.status.currentBatch);
            responseData.put("totalBatches", task.status.totalBatches);
            responseData.put("completed", task.status.completed);
        }
        
        responseData.put("cancelled", task.cancelled);
        responseData.put("paused", task.paused);
        responseData.put("messages", task.status.messages);
        responseData.put("elapsedTime", (System.currentTimeMillis() - task.startTime) / 1000);
        
        // Clean up completed tasks
        if (task.status.completed) {
            activeTasks.remove(sessionId);
            // Clean up progress tracking in MainSession
            if (liveProgress != null) {
                mainSession.clearProgressionProgress(sessionId);
            }
        }
        
        sendJson(response, responseData);
    }
    
    /**
     * Cancel progression processing
     */
    private void handleCancelRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sendError(response, "Session ID is required");
            return;
        }
        
        ProgressionTask task = activeTasks.get(sessionId);
        
        if (task == null) {
            sendError(response, "No active progression found for this session");
            return;
        }
        
        task.cancelled = true;
        task.future.cancel(true);
        task.status.completed = true;
        task.status.addMessage("Processing cancelled by user", "error");
        
        activeTasks.remove(sessionId);
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Processing cancelled");
        
        sendJson(response, responseData);
    }
    
    /**
     * Pause progression processing
     */
    private void handlePauseRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sendError(response, "Session ID is required");
            return;
        }
        
        ProgressionTask task = activeTasks.get(sessionId);
        
        if (task == null) {
            sendError(response, "No active progression found for this session");
            return;
        }
        
        task.paused = true;
        task.status.addMessage("Processing paused", "info");
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Processing paused");
        
        sendJson(response, responseData);
    }
    
    /**
     * Resume progression processing
     */
    private void handleResumeRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String sessionId = request.getParameter("sessionId");
        
        if (sessionId == null || sessionId.trim().isEmpty()) {
            sendError(response, "Session ID is required");
            return;
        }
        
        ProgressionTask task = activeTasks.get(sessionId);
        
        if (task == null) {
            sendError(response, "No active progression found for this session");
            return;
        }
        
        task.paused = false;
        task.status.addMessage("Processing resumed", "info");
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("success", true);
        responseData.put("message", "Processing resumed");
        
        sendJson(response, responseData);
    }
    
    /**
     * Send JSON response
     */
    private void sendJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    
    /**
     * Send error response
     */
    private void sendError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorData = new HashMap<>();
        errorData.put("success", false);
        errorData.put("message", message);
        sendJson(response, errorData);
    }
    
    @Override
    public void destroy() {
        executorService.shutdown();
        super.destroy();
    }
}
