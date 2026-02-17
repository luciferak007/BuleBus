package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.bus.dao.UserDAO;
import com.bus.model.User;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Create User Object
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));
        user.setRole(request.getParameter("role"));

        // 2. Call DAO
        UserDAO dao = new UserDAO();

        // FIX: The method in UserDAO is named 'register', not 'registerUser'
        if (dao.registerUser(user)) {
            // Success: Go to login
            response.sendRedirect("login.jsp?msg=Registration Successful! Please Login.");
        } else {
            // Failure: Stay on register page with error
            request.setAttribute("error", "Registration Failed! Email might already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}