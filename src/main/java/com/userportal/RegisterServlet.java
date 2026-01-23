package com.userportal;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

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
        String email = request.getParameter("email");
        String password = request.getParameter("password"); // demo only

        try (Connection conn = getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(
                    "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "username VARCHAR(100) UNIQUE, " +
                    "email VARCHAR(200), " +
                    "password VARCHAR(255))")) {
                stmt.executeUpdate();
            }
            try (PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO users(username,email,password) VALUES(?,?,?)")) {
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, password);
                stmt.executeUpdate();
            }
            response.sendRedirect("login.jsp?registered=1");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
