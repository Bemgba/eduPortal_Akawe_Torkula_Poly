<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Success</title></head>
<body>
<h2>Result Saved Successfully!</h2>
<p>Name: ${result.name}</p>
<p>Result Type: ${result.resultType}</p>
<p>Sitting: ${result.sitting}</p>

<h3>Subjects:</h3>
<ul>
    <c:forEach var="item" items="${items}">
        <li>${item.subject} - ${item.grade.id}</li>
    </c:forEach>
</ul>

<a href="olevelForm.jsp">Enter Another</a>
</body>
</html>
