<%-- 
    Document   : changeofsession_improved
    Created on : 4th/3/2026 (Improved Session Manager with Real-time Progress)
    Author     : BEMGBA
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<%    if (user == null) {
        response.sendRedirect("/");
    }
%>
<html lang="en">
    <head>
        <%@include file="WEB-INF/jspf/headmeta.jspf"%>
        <link href="css/buttons.dataTables.css" rel="stylesheet">
        <link href="css/dataTables.dataTables.css" rel="stylesheet">
        <title><%=settings.productName%> - Session Manager</title>
        <style>
            .progress-container {
                display: none;
                margin-top: 20px;
            }
            .progress {
                height: 30px;
                font-size: 14px;
            }
            .progress-bar {
                transition: width 0.3s ease;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }
            .stat-card {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border-left: 4px solid #0d6efd;
            }
            .stat-card h6 {
                margin: 0 0 5px 0;
                color: #6c757d;
                font-size: 12px;
                text-transform: uppercase;
            }
            .stat-card .value {
                font-size: 24px;
                font-weight: bold;
                color: #212529;
            }
            .action-buttons {
                margin-top: 15px;
            }
            .session-needs-progression {
                border-left: 4px solid #ffc107;
                background-color: #fff3cd;
            }
            .session-completed {
                border-left: 4px solid #198754;
                background-color: #d1e7dd;
            }
            .log-output {
                max-height: 300px;
                overflow-y: auto;
                background: #f8f9fa;
                padding: 10px;
                border-radius: 4px;
                font-family: monospace;
                font-size: 12px;
                margin-top: 10px;
            }
            .log-entry {
                padding: 2px 0;
            }
            .log-error {
                color: #dc3545;
            }
            .log-success {
                color: #198754;
            }
            .log-info {
                color: #0d6efd;
            }
        </style>
    </head>
    <body>
        <%@include file="WEB-INF/jspf/navigations.jspf"%>

        <div class="wrapper d-flex flex-column min-vh-100">
            <header class="header header-sticky p-0">
                <%@include file="WEB-INF/jspf/header_staff.jspf"%>
                <div class="container-fluid px-4">
                    <h2 class="title">Session Manager</h2>
                </div>
            </header>
            <%                    
                String idx = request.getParameter("idx");
                if (idx != null && idx.length() > 0) {
                    idx = settings.decryptText(idx);
                    Sessionmanager smu = sess.getSessionmanager(idx);
                    if (smu != null) {
                        String newst = "OPEN";
                        if (smu.getStatus().equalsIgnoreCase("OPEN")) {
                            newst = "CLOSED";
                        }
                        smu.setStatus(newst);
                        sess.updateSessionmanager(smu);
                    }
                }
            %>
            <div class="body flex-grow-1">
                <div class="container-lg px-4">
                    <div class="col-12">
                        <div class="card mb-4">
                            <p>
                                <button class="btn btn-primary" type="button" data-coreui-toggle="collapse" data-coreui-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">
                                    <i class="fas fa-info-circle"></i> View Instructions
                                </button>
                            </p>
                            <div class="collapse" id="collapseExample">
                                <div class="alert alert-warning">
                                    <h5><i class="fas fa-exclamation-triangle"></i> Important Guidelines</h5>
                                    <ul>
                                        <li>This operation should be performed with high level of care as it cannot be reversed thereafter.</li>
                                        <li>The change of session operation should be performed after due verification from the University Management.</li>
                                        <li>This operation is available for both APPLICATION and REGISTRATION.</li>
                                        <li>If it is a total change of session for REGISTRATION, students' classes will be promoted alongside other operations.</li>
                                        <li><strong>New:</strong> Real-time progress tracking with ability to monitor batch processing.</li>
                                        <li><strong>New:</strong> Pause/Cancel capability during progression processing.</li>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-header"><strong>Create New Session</strong></div>
                            <div class="card-body">
                                <%    
                                    String sessiond = request.getParameter("sessiond");
                                    String semester = request.getParameter("semester");
                                    String schools = request.getParameter("schools");
                                    String operation = request.getParameter("operation");
                                    String button = request.getParameter("button");

                                    List<Sessionmanager> sessionlist = sess.getAllSessionmanager();
                                    String createdSessionId = null;
                                    
                                    // Handle session creation
                                    if (button != null && sessiond != null && sessiond.length() > 0) {
                                        List<Sessionmanager> sublist = sessionlist.stream()
                                                .filter(d -> d.getName().equalsIgnoreCase(sessiond) && d.getOperation().equalsIgnoreCase(operation)
                                                && d.getSemester().equalsIgnoreCase(semester) && d.getSchoolId().getId().equalsIgnoreCase(schools))
                                                .toList();
                                        if (sublist.size() > 0) {
                                %>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle"></i> This session already exists
                                </div>
                                <%
                                        } else {
                                            String id = sessiond.split("/")[0] + settings.generateId("", 4);
                                            Sessionmanager smu = new Sessionmanager(id);
                                            smu.setName(sessiond);
                                            smu.setOperation(operation);
                                            Schools sch = sess.getSchools(schools);
                                            smu.setSchoolId(sch);
                                            smu.setSemester(semester);
                                            smu.setStartDate(settings.getCurrentDateTime());
                                            smu.setStatus("OPEN");
                                            
                                            sess.newSessionmanager(smu);
                                            createdSessionId = id;
                                            
                                            sessionlist = sess.getAllSessionmanager();
                                %>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i> 
                                    <strong>Session Created Successfully!</strong><br>
                                    Session: <strong><%=sessiond%></strong>, Semester: <strong><%=semester%></strong>, Operation: <strong><%=operation%></strong>
                                </div>
                                <%
                                        }
                                    }
                                %>
                                <div class="example">
                                    <form action='' method='post' name="verify">
                                        <div class="input-group mb-4">
                                            <span class="input-group-text">Select Session</span>
                                            <%                                               
                                                Sessionmanager smx = sess.getLatestSession();
                                                String latestsess = settings.getSessionAfter(smx.getName());
                                                List<String> smxx = settings.getSessionsBefore(latestsess, 5);
                                            %>
                                            <select class="form-select" name="sessiond" id="sessiond" required>
                                                <option value="">Select One</option>
                                                <%                                                    
                                                    try {
                                                        for (String data : smxx) {
                                                %>
                                                <option value="<%=data%>"><%=data%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4">
                                            <span class="input-group-text">Semester</span>
                                            <select class="form-select" name="semester" id="semester" required>
                                                <option value="">Select One</option>
                                                <option value="First">First</option>
                                                <option value="Second">Second</option>
                                                <option value="Session">Session</option>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4">
                                            <span class="input-group-text">Select School</span>
                                            <%                                                
                                                List<Schools> schl = sess.getAllSchoos();
                                            %>
                                            <select class="form-select" name="schools" id="schools" required>
                                                <option value="">Select One</option>
                                                <%
                                                    try {
                                                        for (Schools sch : schl) {
                                                %>
                                                <option value="<%=sch.getId()%>"><%=sch.getName()%></option>
                                                <%
                                                        }
                                                    } catch (Exception k) {
                                                    }
                                                %>
                                            </select>
                                        </div>
                                        <div class="input-group mb-4">
                                            <span class="input-group-text">Operation</span>
                                            <select class="form-select" name="operation" id="operation" required>
                                                <option value="">Select One</option>
                                                <option value="APPLICATION">APPLICATION</option>
                                                <option value="REGISTRATION">REGISTRATION</option>
                                            </select>
                                        </div>
                                        <div class="row">
                                            <div class="col-12">
                                                <button type="submit" name="button" class="btn btn-primary px-4" value="Create">
                                                    <i class="fas fa-plus-circle"></i> Create Session
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%
                        if (sessionlist.size() == 0) {
                    %>
                    <div class='alert alert-warning'>
                        <i class="fas fa-info-circle"></i> No session manager records found!
                    </div>
                    <%
                    } else {
                    %>

                    <div class="col-12">
                        <div class="card mb-4">
                            <div class="card-header"><strong>List of Session Managers</strong></div>
                            <div class="card-body">
                                <div class="table-responsive-sm">
                                    <table class="table table-striped table-hover" id='dataTable'>
                                        <thead>
                                            <tr>
                                                <th class="center">#</th>
                                                <th>School</th>
                                                <th>Session</th>
                                                <th>Semester</th>
                                                <th>Operation</th>
                                                <th>Opened</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                                
                                                int i = 1;
                                                for (Sessionmanager data : sessionlist) {
                                                    // Check if this session needs progression
                                                    boolean needsProgression = data.getOperation().equalsIgnoreCase("REGISTRATION");
                                                    String rowClass = needsProgression ? "session-needs-progression" : "";
                                            %>
                                            <tr class="<%=rowClass%>">
                                                <td class="center"><%=i%></td>
                                                <td><%=data.getSchoolId().getName()%></td>
                                                <td><%=data.getName()%></td>
                                                <td><%=data.getSemester()%></td>
                                                <td>
                                                    <span class="badge bg-<%=data.getOperation().equalsIgnoreCase("REGISTRATION") ? "primary" : "info"%>">
                                                        <%=data.getOperation()%>
                                                    </span>
                                                </td>
                                                <%
                                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                    String formattedDate = "";
                                                    try{
                                                        formattedDate=sdf.format(data.getStartDate());
                                                    }catch(Exception k){}
                                                %>
                                                <td><%=formattedDate%></td>
                                                <%
                                                    String st = data.getStatus();
                                                    String sty = "danger";
                                                    if (st.equalsIgnoreCase("OPEN")) {
                                                        sty = "success";
                                                    }
                                                %>
                                                <td>
                                                    <a href="/session_change?idx=<%=settings.encodeUrl(settings.encryptText(data.getId()))%>" 
                                                       class="btn btn-<%=sty%> btn-sm">
                                                        <%=data.getStatus()%>
                                                    </a>
                                                </td>
                                                <td>
                                                    <%
                                                        if (needsProgression) {
                                                    %>
                                                    <button class="btn btn-warning btn-sm process-progression-btn" 
                                                            data-session-id="<%=data.getId()%>"
                                                            data-session-name="<%=data.getName()%>"
                                                            data-school-name="<%=data.getSchoolId().getName()%>">
                                                        <i class="fas fa-cogs"></i> Process Progression
                                                    </button>
                                                    <%
                                                        }
                                                    %>
                                                </td>
                                            </tr>
                                            <%
                                                    i++;
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%
                        }
                    %>

                    <!-- Progress Modal -->
                    <div class="modal fade" id="progressModal" tabindex="-1" aria-labelledby="progressModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false" data-coreui-backdrop="static" data-coreui-keyboard="false">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="progressModalLabel">
                                        <i class="fas fa-cogs"></i> Processing Student Progression
                                    </h5>
                                </div>
                                <div class="modal-body">
                                    <div id="sessionInfo" class="alert alert-info">
                                        <strong>Session:</strong> <span id="sessionName"></span><br>
                                        <strong>School:</strong> <span id="schoolName"></span>
                                    </div>
                                    
                                    <div class="progress-container" id="progressContainer">
                                        <div class="progress">
                                            <div class="progress-bar progress-bar-striped progress-bar-animated" 
                                                 role="progressbar" 
                                                 id="progressBar" 
                                                 style="width: 0%">
                                                0%
                                            </div>
                                        </div>
                                        
                                        <div class="stats-grid" id="statsGrid">
                                            <div class="stat-card">
                                                <h6>Total Students</h6>
                                                <div class="value" id="totalStudents">-</div>
                                            </div>
                                            <div class="stat-card">
                                                <h6>Processed</h6>
                                                <div class="value text-success" id="processedStudents">0</div>
                                            </div>
                                            <div class="stat-card">
                                                <h6>Failed</h6>
                                                <div class="value text-danger" id="failedStudents">0</div>
                                            </div>
                                            <div class="stat-card">
                                                <h6>Current Batch</h6>
                                                <div class="value" id="currentBatch">-</div>
                                            </div>
                                            <div class="stat-card">
                                                <h6>Elapsed Time</h6>
                                                <div class="value" id="elapsedTime">0s</div>
                                            </div>
                                            <div class="stat-card">
                                                <h6>Est. Remaining</h6>
                                                <div class="value" id="estimatedTime">-</div>
                                            </div>
                                        </div>
                                        
                                        <div class="log-output" id="logOutput">
                                            <div class="log-entry log-info">Waiting to start...</div>
                                        </div>
                                    </div>
                                    
                                    <div id="completionMessage" style="display: none;"></div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-danger" id="cancelBtn" style="display: none;">
                                        <i class="fas fa-stop"></i> Cancel Processing
                                    </button>
                                    <button type="button" class="btn btn-warning" id="pauseBtn" style="display: none;">
                                        <i class="fas fa-pause"></i> Pause
                                    </button>
                                    <button type="button" class="btn btn-primary" id="startBtn">
                                        <i class="fas fa-play"></i> Start Processing
                                    </button>
                                    <button type="button" class="btn btn-secondary" id="closeBtn" data-bs-dismiss="modal" data-coreui-dismiss="modal">
                                        Close
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <%@include file="WEB-INF/jspf/footer.jspf"%>
        </div>
        <%@include file="WEB-INF/jspf/footerjs.jspf"%>

        <script src="vendors/jquery/js/jquery.min.js"></script>
        <script src="vendors/datatables.net/js/dataTables.min.js"></script>
        <script src="vendors/datatables.net-bs5/js/dataTables.bootstrap5.min.js"></script>
        <script src="js/datatables.js"></script>
        <script src="js/dataTables.js"></script>
        <script src="js/dataTables.buttons.js"></script>
        <script src="js/buttons.dataTables.js"></script>
        <script src="js/jszip.min.js"></script>
        <script src="js/pdfmake.min.js"></script>
        <script src="js/vfs_fonts.js"></script>
        <script src="js/buttons.html5.min.js"></script>
        <script src="js/buttons.print.min.js"></script>
        <script src="js/jquery-3.7.1.js"></script>
        <script src="vendors/chart.js/js/chart.umd.js"></script>
        <script src="vendors/@coreui/chartjs/js/coreui-chartjs.js"></script>
        <script src="vendors/@coreui/utils/js/index.js"></script>
        <script src="js/main.js"></script>

        <script>
            $(document).ready(function () {
                // Initialize DataTable
                new DataTable('#dataTable', {
                    responsive: true,
                    "info": true,
                    "pageLength": 25,
                    "lengthMenu": [25, 50, 100, 200, 500],
                    "dom": 'lBfrtip',
                    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                    layout: {
                        topStart: 'buttons'
                    }
                });
                
                let currentSessionId = null;
                let pollingInterval = null;
                let startTime = null;
                let isPaused = false;
                
                // IMPORTANT: Use event delegation for buttons inside DataTable
                // This ensures the handler works even after DataTable manipulates the DOM
                $(document).on('click', '.process-progression-btn', function(e) {
                    e.preventDefault();
                    console.log('Process Progression button clicked!'); // Debug log
                    
                    currentSessionId = $(this).data('session-id');
                    const sessionName = $(this).data('session-name');
                    const schoolName = $(this).data('school-name');
                    
                    console.log('Session ID:', currentSessionId); // Debug log
                    console.log('Session Name:', sessionName); // Debug log
                    
                    $('#sessionName').text(sessionName);
                    $('#schoolName').text(schoolName);
                    $('#progressContainer').hide();
                    $('#completionMessage').hide();
                    $('#startBtn').show();
                    $('#cancelBtn').hide();
                    $('#pauseBtn').hide();
                    $('#closeBtn').prop('disabled', false);
                    
                    // Reset progress
                    resetProgress();
                    
                    // Show modal - try both Bootstrap and CoreUI
                    try {
                        console.log('Attempting to show modal...'); // Debug log
                        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                            console.log('Using Bootstrap Modal'); // Debug log
                            const modal = new bootstrap.Modal(document.getElementById('progressModal'));
                            modal.show();
                        } else if (typeof coreui !== 'undefined' && coreui.Modal) {
                            console.log('Using CoreUI Modal'); // Debug log
                            const modal = new coreui.Modal(document.getElementById('progressModal'));
                            modal.show();
                        } else {
                            console.log('Using jQuery modal fallback'); // Debug log
                            $('#progressModal').modal('show');
                        }
                    } catch (err) {
                        console.error('Modal error:', err);
                        // Fallback to jQuery
                        $('#progressModal').modal('show');
                    }
                });
                
                // Start processing
                $('#startBtn').on('click', function() {
                    if (!currentSessionId) return;
                    
                    if (confirm('This process may take several minutes. Do you want to continue?')) {
                        startProcessing();
                    }
                });
                
                // Cancel processing
                $('#cancelBtn').on('click', function() {
                    if (confirm('Are you sure you want to cancel the progression processing?')) {
                        cancelProcessing();
                    }
                });
                
                // Pause processing
                $('#pauseBtn').on('click', function() {
                    if (isPaused) {
                        resumeProcessing();
                    } else {
                        pauseProcessing();
                    }
                });
                
                function startProcessing() {
                    $('#startBtn').hide();
                    $('#cancelBtn').show();
                    $('#pauseBtn').show();
                    $('#closeBtn').prop('disabled', true);
                    $('#progressContainer').show();
                    
                    startTime = Date.now();
                    
                    addLog('Starting progression processing...', 'info');
                    
                    // Start the processing on server
                    $.ajax({
                        url: 'api/session-progression/start',
                        method: 'POST',
                        data: { sessionId: currentSessionId },
                        success: function(response) {
                            if (response.success) {
                                addLog('Processing started successfully', 'success');
                                startPolling();
                            } else {
                                addLog('Failed to start processing: ' + response.message, 'error');
                                resetButtons();
                            }
                        },
                        error: function() {
                            addLog('Error starting processing', 'error');
                            resetButtons();
                        }
                    });
                }
                
                function startPolling() {
                    pollingInterval = setInterval(function() {
                        if (isPaused) return;
                        
                        $.ajax({
                            url: 'api/session-progression/status',
                            method: 'GET',
                            data: { sessionId: currentSessionId },
                            success: function(response) {
                                updateProgress(response);
                                
                                if (response.completed) {
                                    stopPolling();
                                    showCompletion(response);
                                }
                            },
                            error: function() {
                                addLog('Error fetching progress', 'error');
                            }
                        });
                    }, 2000); // Poll every 2 seconds
                }
                
                function stopPolling() {
                    if (pollingInterval) {
                        clearInterval(pollingInterval);
                        pollingInterval = null;
                    }
                }
                
                function updateProgress(data) {
                    const percentage = data.totalStudents > 0 
                        ? Math.round((data.processedStudents / data.totalStudents) * 100) 
                        : 0;
                    
                    $('#progressBar').css('width', percentage + '%').text(percentage + '%');
                    $('#totalStudents').text(data.totalStudents || '-');
                    $('#processedStudents').text(data.processedStudents || 0);
                    $('#failedStudents').text(data.failedStudents || 0);
                    $('#currentBatch').text(data.currentBatch + '/' + data.totalBatches);
                    
                    // Update elapsed time
                    const elapsed = Math.floor((Date.now() - startTime) / 1000);
                    $('#elapsedTime').text(formatTime(elapsed));
                    
                    // Estimate remaining time
                    if (data.processedStudents > 0 && data.totalStudents > 0) {
                        const rate = data.processedStudents / elapsed;
                        const remaining = (data.totalStudents - data.processedStudents) / rate;
                        $('#estimatedTime').text(formatTime(Math.floor(remaining)));
                    }
                    
                    // Add log entries for new messages
                    if (data.messages && data.messages.length > 0) {
                        data.messages.forEach(function(msg) {
                            addLog(msg.text, msg.type);
                        });
                    }
                }
                
                function showCompletion(data) {
                    $('#progressBar').removeClass('progress-bar-animated');
                    $('#cancelBtn').hide();
                    $('#pauseBtn').hide();
                    $('#closeBtn').prop('disabled', false);
                    
                    const alertClass = data.failedStudents === 0 ? 'alert-success' : 'alert-warning';
                    const icon = data.failedStudents === 0 ? 'fa-check-circle' : 'fa-exclamation-triangle';
                    
                    const totalTime = formatTime(Math.floor((Date.now() - startTime) / 1000));
                    
                    const message = '<div class="alert ' + alertClass + '">' +
                        '<h5><i class="fas ' + icon + '"></i> Processing Completed</h5>' +
                        '<hr>' +
                        '<p><strong>Total Students:</strong> ' + data.totalStudents + '</p>' +
                        '<p><strong>Successfully Processed:</strong> ' + data.processedStudents + '</p>' +
                        '<p><strong>Failed:</strong> ' + data.failedStudents + '</p>' +
                        '<p><strong>Total Time:</strong> ' + totalTime + '</p>' +
                        '</div>';
                    
                    $('#completionMessage').html(message).show();
                    addLog('Processing completed!', data.failedStudents === 0 ? 'success' : 'error');
                }
                
                function cancelProcessing() {
                    $.ajax({
                        url: 'api/session-progression/cancel',
                        method: 'POST',
                        data: { sessionId: currentSessionId },
                        success: function(response) {
                            stopPolling();
                            addLog('Processing cancelled by user', 'error');
                            resetButtons();
                        }
                    });
                }
                
                function pauseProcessing() {
                    isPaused = true;
                    $('#pauseBtn').html('<i class="fas fa-play"></i> Resume');
                    addLog('Processing paused', 'info');
                }
                
                function resumeProcessing() {
                    isPaused = false;
                    $('#pauseBtn').html('<i class="fas fa-pause"></i> Pause');
                    addLog('Processing resumed', 'info');
                }
                
                function resetButtons() {
                    $('#startBtn').show();
                    $('#cancelBtn').hide();
                    $('#pauseBtn').hide();
                    $('#closeBtn').prop('disabled', false);
                }
                
                function resetProgress() {
                    $('#progressBar').css('width', '0%').text('0%').addClass('progress-bar-animated');
                    $('#totalStudents').text('-');
                    $('#processedStudents').text('0');
                    $('#failedStudents').text('0');
                    $('#currentBatch').text('-');
                    $('#elapsedTime').text('0s');
                    $('#estimatedTime').text('-');
                    $('#logOutput').html('<div class="log-entry log-info">Waiting to start...</div>');
                }
                
                function addLog(message, type) {
                    const logClass = 'log-' + (type === 'success' ? 'success' : type === 'error' ? 'error' : 'info');
                    const timestamp = new Date().toLocaleTimeString();
                    const entry = '<div class="log-entry ' + logClass + '">[' + timestamp + '] ' + message + '</div>';
                    $('#logOutput').append(entry);
                    $('#logOutput').scrollTop($('#logOutput')[0].scrollHeight);
                }
                
                function formatTime(seconds) {
                    if (seconds < 60) return seconds + 's';
                    const minutes = Math.floor(seconds / 60);
                    const secs = seconds % 60;
                    return minutes + 'm ' + secs + 's';
                }
                
                // Cleanup on modal close - works with both Bootstrap and CoreUI
                $('#progressModal').on('hidden.bs.modal hidden.coreui.modal', function() {
                    stopPolling();
                    currentSessionId = null;
                    isPaused = false;
                });
            });
        </script>
    </body>
</html>
