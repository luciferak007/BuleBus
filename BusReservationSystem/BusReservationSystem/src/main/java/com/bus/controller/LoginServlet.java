package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.bus.dao.UserDAO;
import com.bus.model.User;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User user = dao.login(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getName());
                session.setAttribute("role", user.getRole()); // Essential for security checks

                // Role based redirect
                String role = user.getRole().toUpperCase();

                if ("ADMIN".equals(role)) {
                    // ✅ Redirects Admins to the Admin Dashboard
                    response.sendRedirect("adminHome.jsp");
                } 
                else if ("VENDOR".equals(role)) {
                    // Redirects Vendors
                    response.sendRedirect("vendorHome.jsp");
                } 
                else {
                    // Default to Passenger
                    response.sendRedirect("passengerHome.jsp");
                }

            } else {
                // Error Handling: Send back to login page with message
                request.setAttribute("error", "Invalid Email or Password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?msg=Login Error");
        }
    }
}