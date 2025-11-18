<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5" style="max-width: 640px;">
  <h2 class="mb-4">Create account</h2>
  <%
    String err = request.getParameter("error");
    if ("1".equals(err)) {
  %>
  <div class="alert alert-danger">Registration failed. Try a different username.</div>
  <% } %>
  <form method="post" action="register">
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input class="form-control" name="username" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Email</label>
      <input type="email" class="form-control" name="email" required>
    </div>
    <div class="mb-3">
      <label class="form-label">Password</label>
      <input type="password" class="form-control" name="password" required>
    </div>
    <button class="btn btn-primary">Register</button>
    <a href="index.jsp" class="btn btn-link">Back</a>
  </form>
</div>
</body>
</html>
