<%--
  Created by IntelliJ IDEA.
  User: ymg
  Date: 21/01/25
  Time: 3:09 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quiz Result</title>
</head>
<body>
<h1>Quiz Completed!</h1>
<h2>Your Score: <%= request.getAttribute("score") %> / 5</h2>
<button onclick="window.location.reload()">Play Again</button>
</body>
</html>
