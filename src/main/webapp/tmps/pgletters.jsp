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
        <title>Generate PG Admission Letter</title>
    </head>
    <body>
        <h1>Generate PG Admission Letter</h1>
        <%  
            sess.pgAdmissionLetters();
        %>
        Generated successfully.
       


    </body>
</html>
