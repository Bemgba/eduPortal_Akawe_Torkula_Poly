<%-- 
    Document   : logout
    Created on : 17 Aug 2024, 01:33:42
    Author     : eaglescan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

    session = request.getSession();
    try {
        if (session == null) {
            session.setAttribute("USER", null);
%>
<jsp:forward page="index.jsp"/>
<%
        }
    } catch (Exception eex) {
    }

    if (session != null) {
        try {
            session.setAttribute("USER", null);

            session.invalidate();


%>
<jsp:forward page="index.jsp"/>
<%} catch (java.lang.IllegalStateException e) {
%>
<jsp:forward page="index.jsp"/>
<%
} catch (Exception ex) {
%>
<jsp:forward page="index.jsp"/>
<%
        }
    }
%>