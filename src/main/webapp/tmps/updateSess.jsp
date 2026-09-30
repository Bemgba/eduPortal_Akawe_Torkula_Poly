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
        <%    String id = request.getParameter("id");
            if (id != null && id.length()>0) {
                id = id.toLowerCase();
                Students std = sess.getStudentsById(id);
                sess.updateStudentProgression(std);
        %>
        Record for <%=std.getSurname() + " " + std.getOthernames()%> has been updated
        <%
        } else {
            List<Students> stdl = sess.updateStudentsProgressionAll();
        %>
        <%=stdl.size()%> records updated;
        <%
            }
        %>


    </body>
</html>
