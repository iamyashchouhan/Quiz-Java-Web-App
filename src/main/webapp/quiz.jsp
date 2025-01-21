<%--
  Created by IntelliJ IDEA.
  User: ymg
  Date: 21/01/25
  Time: 3:09 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="mypackage.Question" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Java Quiz</title>
  <script>
    function submitQuiz() {
      document.getElementById('quizForm').submit();
    }
  </script>
</head>
<body>

<h1>Java Quiz</h1>
<form id="quizForm" method="post">
  <%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    for (int i = 0; i < questions.size(); i++) {
      Question q = questions.get(i);
  %>
  <div>
    <h2><%= q.getQuestion() %></h2>
    <input type="radio" name="answer<%= i+1 %>" value="A"> <%= q.getOptions()[0] %><br>
    <input type="radio" name="answer<%= i+1 %>" value="B"> <%= q.getOptions()[1] %><br>
    <input type="radio" name="answer<%= i+1 %>" value="C"> <%= q.getOptions()[2] %><br>
    <input type="radio" name="answer<%= i+1 %>" value="D"> <%= q.getOptions()[3] %><br>
  </div>
  <% } %>
  <button type="button" onclick="submitQuiz()">Submit</button>
</form>
</body>
</html>
