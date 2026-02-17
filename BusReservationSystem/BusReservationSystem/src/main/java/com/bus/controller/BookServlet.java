package com.bus.controller;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import com.bus.dao.BookingDAO;
import com.bus.dao.DBConnection;
import com.bus.model.Booking;

public class BookServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Retrieve parameters
            int userId = Integer.parseInt(request.getParameter("userId"));
            int busId = Integer.parseInt(request.getParameter("busId"));
            int seatsBooked = Integer.parseInt(request.getParameter("seats"));
            String dateStr = request.getParameter("date");

            double pricePerSeat = 0;
            int seatsAvailable = 0;

            // 2. Check Availability (Read-Only)
            try (Connection con = DBConnection.getConnection()) {
                // Using correct column 'seats_available'
                String sql = "SELECT price, seats_available FROM bus WHERE bus_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, busId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    pricePerSeat = rs.getDouble("price");
                    seatsAvailable = rs.getInt("seats_available");
                } else {
                    response.sendRedirect("passengerHome.jsp?msg=Error: Bus not found!");
                    return;
                }
            } // Connection automatically closes here

            // 3. Validation
            if (seatsBooked > seatsAvailable) {
                response.sendRedirect("passengerHome.jsp?msg=Error: Not enough seats available!");
                return;
            }

            // 4. Calculate Total Fare
            double totalFare = pricePerSeat * seatsBooked;

            // 5. Create Booking Object
            Booking booking = new Booking();
            booking.setUserId(userId);
            booking.setBusId(busId);
            booking.setSeatsBooked(seatsBooked);
            booking.setTravelDate(java.sql.Date.valueOf(dateStr));
            booking.setTotalFare(totalFare);

            // 6. Save to DB (DAO handles insertion AND seat deduction)
            new BookingDAO().bookTicket(booking);

            // 7. Success Redirect
            response.sendRedirect("passengerHome.jsp?msg=Booking Successful! Total Fare: " + totalFare);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("passengerHome.jsp?msg=Error: " + e.getMessage());
        }
    }
}