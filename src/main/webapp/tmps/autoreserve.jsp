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
        <title>Auto Reserve Rooms</title>
    </head>
    <body>
        <h1>Auto Reserve Rooms</h1>
        <%            String id = request.getParameter("id");
            System.out.println("hhhhhh " + id);
            if (id != null && id.length() > 0) {
                id = id.toLowerCase();
                System.out.println("aaaaaaaaa " + id);
                Students std = sess.getStudentsById(id);
                System.out.println("bbbbbbbbb " + std);
                if (std != null) {
                    Hostelapplication all = sess.getHostelapplication(std.getId(), "2024/2025");
                    System.out.println("cccccccccccc " + all);
                    if (all != null) {
                        System.out.println("ddddddddddddd " + all.getApplicationStatus());
                        if (all.getApplicationStatus().equalsIgnoreCase("PENDING")) {
                            String com = sess.reserveRoom(all.getId());
                            System.out.println("eeeeeeee " + com);
                        }
                    }
                }
            } else {
                sess.autoReserveRooms();
            }

        %>



    </body>
</html>
