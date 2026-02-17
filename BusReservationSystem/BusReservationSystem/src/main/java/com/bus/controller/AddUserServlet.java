package com.bus.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.bus.dao.DBConnection;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // PASSENGER or VENDOR

        try (Connection con = DBConnection.getConnection()) {
            
            // Check if email already exists
            PreparedStatement checkStmt = con.prepareStatement("SELECT user_id FROM user WHERE email = ?");
            checkStmt.setString(1, email);
            if(checkStmt.executeQuery().next()) {
                response.sendRedirect("adminHome.jsp?msg=Error: Email already exists!");
                return;
            }

            // Insert new user
            String sql = "INSERT INTO user (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("adminHome.jsp?msg=" + role + " Added Successfully!");
            } else {
                response.sendRedirect("adminHome.jsp?msg=Error Adding User");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminHome.jsp?msg=Error: " + e.getMessage());
        }
    }
}