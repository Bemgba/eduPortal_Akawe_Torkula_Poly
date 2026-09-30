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
        <title>Auto Clear Applicants</title>
    </head>
    <body>
        <h1>Auto Clear Applicants</h1>
        <%            String id = request.getParameter("id");
            if (id != null && id.length() > 0) {
                sess.clearApplicant(id, sess.getUsers("s202410818"));
            } else {
                sess.autoScreen("S001", 1001);
            }
        %>



    </body>
</html>
