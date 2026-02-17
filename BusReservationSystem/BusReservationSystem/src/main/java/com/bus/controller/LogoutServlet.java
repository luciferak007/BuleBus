package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Fetch the current session (do not create a new one)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. Destroy the session
            session.invalidate(); 
        }
        
        // 3. Prevent Browser Caching (Fixes "Back Button" security issue)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // 4. Redirect to login page
        response.sendRedirect("login.jsp");
    }
}