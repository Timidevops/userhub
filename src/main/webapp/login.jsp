<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5" style="max-width: 640px;">
  <h2 class="mb-4">Welcome back</h2>
  <%
    String err = request.getParameter("error");
    String reg = request.getParameter("registered");
    if ("1".equals(reg)) {
  %>
  <div class="alert alert-success">Registered successfully. Please log in.</div>
  <% } else if ("1".equals(err)) { %>
  <div class="alert alert-danger">Invalid username or password.</div>
  <% } %>
  <form method="post" action="login">
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input class="form-control" name="username" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" class="form-control" name="password" required>
    </div>
    <button class="btn btn-primary">Log in</button>
    <a href="index.jsp" class="btn btn-link">Back</a>
  </form>
</div>
</body>
</html>
