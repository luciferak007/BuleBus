package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.bus.dao.BookingDAO;

public class CancelServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Get Booking ID safely
            String idStr = request.getParameter("bookingId");
            if (idStr != null && !idStr.isEmpty()) {
                int bookingId = Integer.parseInt(idStr);

                // 2. Perform Cancellation in Database
                BookingDAO dao = new BookingDAO();
                dao.cancelTicket(bookingId);

                // 3. Redirect with Success Message
                response.sendRedirect("passengerHome.jsp?msg=Ticket Cancelled Successfully");
            } else {
                // Handle invalid ID case
                response.sendRedirect("passengerHome.jsp?msg=Error: Invalid Booking ID");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("passengerHome.jsp?msg=Error: Cancellation Failed");
        }
    }
}