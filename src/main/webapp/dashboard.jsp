<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
  <h2>Dashboard</h2>
  <p class="lead">Hello, <%= request.getParameter("user") != null ? request.getParameter("user") : "Guest" %>!</p>
  <a href="index.jsp" class="btn btn-secondary">Home</a>
</div>
</body>
</html>
