<%-- 
    Document   : updateSession
    Created on : 15 Jan 2025, 07:05:59
    Author     : eaglescan
--%>

<%@page import="java.util.Optional"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../WEB-INF/jspf/initialize.jspf"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Students sessions</title>
    </head>
    <body>
        <h1>Update Students Sessions</h1>
        <%            String id = request.getParameter("id");
            if (id != null) {
                id = id.toLowerCase();
                Students std = sess.getStudentsById(id);

                Sessionmanager sessman = sess.getCurrentSessionManagerBySchoolAndOperation(std.getCourseId().getSchoolProgrammeId().getSchoolId().getId(), "REGISTRATION");
                Collection<Studentprogression> prograssion = std.getStudentprogressionCollection();

                if (std != null) {
        %>
        <h2>Before update</h2>
        <%
            for (Studentprogression dd : prograssion) {
        %>
        <%=dd.getSessionAdded() + " " + dd.getSemesterAdded() + " " + dd.getLevelAdded()%><br/>
        <%
            }
        %>

        <%
            try {
                String sessadm = std.getSessionAdmitted();
                String classadm = std.getClassAdmitted();
                String currsess = sessman.getName();
                String currsem = sessman.getSemester();
                String tmpsess = sessadm;
                int cadm = 100;
                int maxclass = 100;
                int maxspill = 1;
                int i1 = 100;
                int i2 = 0;

                try {
                    cadm = Integer.parseInt(classadm);
                    maxclass = std.getCourseId().getDefaultMaxLevel();
                    maxspill = std.getCourseId().getDefaultMaxSpill();
                    maxspill = maxspill / 2;
                } catch (Exception f) {
                    // Handle the exception gracefully (e.g., log the error)
                }

                while (tmpsess.compareToIgnoreCase(currsess) <= 0 && i2 <= maxspill) {
                    if (tmpsess.equalsIgnoreCase("2021/2022")) {
                    } else {
                        if (i1 <= maxclass) {
                            // ... (Code for creating progression records for First and Second semesters as before) ...
                            Studentprogression proggFirst = null;
                            try {
                                for (Studentprogression person : prograssion) {
                                    if (person.getSessionAdded().equals(tmpsess) && person.getSemesterAdded().equals("First")) {
                                        proggFirst = person;
                                        break;
                                    }
                                }
                            } catch (Exception k) {
                                // Handle the exception gracefully (e.g., log the error)
                            }

                            if (proggFirst == null) {
                                String idd = tmpsess.split("/")[0] + std.getId() + settings.generateId("", 4);
                                proggFirst = new Studentprogression(idd);
                                proggFirst.setCourseId(std.getCourseId());
                                proggFirst.setDateAdded(settings.getCurrentDateTime());
                                proggFirst.setLevelAdded(cadm + "");
                                proggFirst.setRegistrationStatus("0");
                                proggFirst.setSemesterAdded("First");
                                proggFirst.setSessionAdded(tmpsess);
                                proggFirst.setStatus(std.getMatricNo());
                                proggFirst.setStudentsId(std);
                                sess.newEntry(proggFirst);
                            }

                            Studentprogression proggSecond = null;
                            try {
                                for (Studentprogression person : prograssion) {
                                    if (person.getSessionAdded().equals(tmpsess) && person.getSemesterAdded().equals("Second")) {
                                        proggSecond = person;
                                        break;
                                    }
                                }
                            } catch (Exception k) {
                                // Handle the exception gracefully (e.g., log the error)
                            }

                            if (proggSecond == null) {
                                String idd = tmpsess.split("/")[0] + std.getId() + settings.generateId("", 4);
                                proggSecond = new Studentprogression(idd);
                                proggSecond.setCourseId(std.getCourseId());
                                proggSecond.setDateAdded(settings.getCurrentDateTime());
                                proggSecond.setLevelAdded(cadm + "");
                                proggSecond.setRegistrationStatus("0");
                                proggSecond.setSemesterAdded("Second");
                                proggSecond.setSessionAdded(tmpsess);
                                proggSecond.setStatus(std.getMatricNo());
                                proggSecond.setStudentsId(std);
                                sess.newEntry(proggSecond);
                            }
                            if (i1 < maxclass) {
                                cadm += 100;
                                i1 += 100;
                            } else {
                                i2++;
                            }
                        } else {
                            // Student has reached maximum class levels, no need to proceed further
                            break;
                        }
                    }

                    tmpsess = settings.getSessionAfter(tmpsess);
                }

// Check if the student has exceeded the maximum spillover 
                if (i2 > maxspill) {
                    std.setExitComment("Auto suspension. Exhausted maximum spillover levels");
                    std.setExitType("SUSPENDED");
                    std.setSessionExited(tmpsess);
                    sess.updateRecord(std);
                }
            } catch (Exception k) {
            }

            List<Studentprogression> prograssion2 = sess.getStudentprogression(std.getId());
        %>
        <h2>After update</h2>
        <%
            for (Studentprogression dd : prograssion2) {
        %>
        <%=dd.getSessionAdded() + " " + dd.getSemesterAdded() + " " + dd.getLevelAdded()%><br/>
        <%
                    }

                }
            }
        %>



    </body>
</html>
