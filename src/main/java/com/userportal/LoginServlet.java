package com.userportal;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet {

    private Connection getConnection() throws SQLException {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        throw new SQLException("MySQL Driver not found", e);
    }

    String url = System.getenv("DB_URL");
    String user = System.getenv("DB_USER");
    String pass = System.getenv("DB_PASS");
    return DriverManager.getConnection(url, user, pass);
}


    private String getenvOrInit(String key) {
        String v = System.getenv(key);
        if (v != null && !v.isEmpty()) return v;
        return getServletContext().getInitParameter(key);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean success = false;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT 1 FROM users WHERE username=? AND password=?")) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                success = rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (success) {
            response.sendRedirect("dashboard.jsp?user=" + username);
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
