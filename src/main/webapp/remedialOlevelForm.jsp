<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mnl.eduportal.entities.*" %>
<%@page import="java.util.*" %>
<%@include file="WEB-INF/jspf/initialize.jspf"%>

<%
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    Applicants genapp = (Applicants) session.getAttribute("app");
    if (genapp == null) {
        response.sendRedirect("/remedialApplication");
        return;
    }
    String userId = genapp.getId();

    List<Olevelgrades> gradesList = (List<Olevelgrades>) request.getAttribute("grades");
    
    List<Olevelsubjects> subjectsList = (List<Olevelsubjects>) request.getAttribute("subjects");
%>

<!DOCTYPE html>
<html>
<head>
    <title>O-Level Result Entry</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
        .form-container { background: #fff; padding: 20px; border-radius: 10px; max-width: 800px; margin: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Enter O-Level Result</h2>
    <form method="post" action="OlevelResultServlet">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required /><br/>

<label for="resultType">Result Type:</label>
<select id="resultType" name="resultType" required>
    <option value="">-- Select Result Type --</option>
    <option value="waec">WAEC</option>
    <option value="neco">NECO</option>
    <option value="nabteb">NABTEB</option>
    <option value="gce">GCE</option>
</select><br/>


        <label for="registrationNo">Registration No:</label>
        <input type="text" id="registrationNo" name="registrationNo" /><br/>

        <!-- hidden userId -->
        <input type="hidden" name="userId" value="<%= userId %>" />

        <label for="examDate">Exam Date:</label>
        <input type="date" id="examDate" name="examDate" required /><br/>

        <label for="sitting">Sitting:</label>
        <select id="sitting" name="sitting" required>
            <option value="First">First</option>
            <option value="Second">Second</option>
        </select><br/>

        <h3>Subjects</h3>
        <table id="subjectsTable">
            <tr><th>Subject</th><th>Grade</th></tr>
            <tr>
                <td>
                    <select name="subject[0]" required>
                        <% if (subjectsList != null) {
                               for (Olevelsubjects subj : subjectsList) { %>
                            <option value="<%=subj.getId()%>"><%=subj.getName()%></option>
                        <%   }
                           } %>
                    </select>
                </td>
                <td>
                    <select name="grade[0]" required>
                        <% if (gradesList != null) {
                               for (Olevelgrades g : gradesList) { %>
                            <option value="<%=g.getId()%>">
                                <%=g.getId()%> (Score: <%=g.getScore()%>)
                            </option>
                        <%   }
                           } %>
                    </select>
                </td>
            </tr>
        </table>

        <button type="button" onclick="addRow()">Add Subject</button><br/><br/>
        <input type="submit" value="Submit"/>
    </form>
</div>

<script>
let rowIndex = 1;
function addRow() {
  const table = document.getElementById("subjectsTable");
  const newRow = table.insertRow(-1);
  newRow.innerHTML = `
    <td>
      <select name="subject[${rowIndex}]" required>
        ${document.querySelector("select[name='subject[0]']").innerHTML}
      </select>
    </td>
    <td>
      <select name="grade[${rowIndex}]" required>
        ${document.querySelector("select[name='grade[0]']").innerHTML}
      </select>
    </td>`;
  rowIndex++;
}
</script>
</body>
</html>
