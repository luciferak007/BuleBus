package com.bus.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.bus.dao.DBConnection;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("userId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("adminHome.jsp?msg=Invalid User ID");
            return;
        }

        int userId = Integer.parseInt(idStr);
        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Begin Transaction to ensure safety

            // ----------------------------------------------------------------
            // 1. GET USER ROLE
            // ----------------------------------------------------------------
            String role = "";
            try (PreparedStatement psRole = con.prepareStatement("SELECT role FROM user WHERE user_id=?")) {
                psRole.setInt(1, userId);
                try (ResultSet rs = psRole.executeQuery()) {
                    if (rs.next()) {
                        role = rs.getString("role");
                    }
                }
            }

            // ----------------------------------------------------------------
            // 2. DELETE BOOKINGS (Passenger Logic)
            // ----------------------------------------------------------------
            // This deletes bookings made by the user (Passenger side)
            try (PreparedStatement psBooking = con.prepareStatement("DELETE FROM booking WHERE user_id=?")) {
                psBooking.setInt(1, userId);
                psBooking.executeUpdate();
            }

            // ----------------------------------------------------------------
            // 3. VENDOR DELETION LOGIC (The Critical Fix)
            // ----------------------------------------------------------------
            if ("VENDOR".equalsIgnoreCase(role)) {
                
                // === FIX: We use 'user_id' because your database doesn't have 'vendor_id' ===
                String linkColumn = "user_id"; 
                
                // A. Get Bus IDs owned by this vendor
                List<Integer> busIds = new ArrayList<>();
                String getBusesSql = "SELECT bus_id FROM bus WHERE " + linkColumn + "=?";
                
                try (PreparedStatement psGetBuses = con.prepareStatement(getBusesSql)) {
                    psGetBuses.setInt(1, userId);
                    try (ResultSet rsBus = psGetBuses.executeQuery()) {
                        while (rsBus.next()) {
                            busIds.add(rsBus.getInt("bus_id"));
                        }
                    }
                }

                // B. Delete Bookings for those buses (Clean up before deleting buses)
                if (!busIds.isEmpty()) {
                    StringBuilder idList = new StringBuilder();
                    for (int i = 0; i < busIds.size(); i++) {
                        idList.append(busIds.get(i));
                        if (i < busIds.size() - 1) idList.append(",");
                    }
                    
                    String deleteBusBookingsQuery = "DELETE FROM booking WHERE bus_id IN (" + idList.toString() + ")";
                    try (PreparedStatement psDelBusBookings = con.prepareStatement(deleteBusBookingsQuery)) {
                        psDelBusBookings.executeUpdate();
                    }
                }

                // C. Delete the Buses
                String deleteBusesSql = "DELETE FROM bus WHERE " + linkColumn + "=?";
                try (PreparedStatement psDelBuses = con.prepareStatement(deleteBusesSql)) {
                    psDelBuses.setInt(1, userId);
                    psDelBuses.executeUpdate();
                }
            }

            // ----------------------------------------------------------------
            // 4. DELETE THE USER ACCOUNT
            // ----------------------------------------------------------------
            int rows;
            try (PreparedStatement psDelUser = con.prepareStatement("DELETE FROM user WHERE user_id=?")) {
                psDelUser.setInt(1, userId);
                rows = psDelUser.executeUpdate();
            }

            con.commit(); // Commit all changes if everything worked

            if (rows > 0) {
                response.sendRedirect("adminHome.jsp?msg=User Deleted Successfully");
            } else {
                response.sendRedirect("adminHome.jsp?msg=User Not Found");
            }

        } catch (Exception e) {
            // If error, undo everything
            if (con != null) try { con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("adminHome.jsp?msg=Error: " + e.getMessage());
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (Exception ex) { ex.printStackTrace(); }
        }
    }
}