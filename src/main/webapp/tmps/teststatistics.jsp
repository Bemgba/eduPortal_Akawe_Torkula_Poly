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
        <title>Update Payments</title>
    </head>
    <body>
        <h1>Update Payments</h1>
        <%    
            List<StudentStatisticsDTO> stdl = reportsess.getStudentStatistics("S001", "2023/2024", "Second");
        %>
        <%=stdl.size()%> records updated;
        <%
            for(StudentStatisticsDTO pay : stdl){
            %>
        <%=pay.getFacultyName()%><br/>
        <%
            }
        %>


    </body>
</html>
