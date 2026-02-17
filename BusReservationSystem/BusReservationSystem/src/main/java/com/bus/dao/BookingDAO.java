package com.bus.dao;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.bus.model.Booking;

public class BookingDAO {

    public void bookTicket(Booking booking) {
        // Try-with-resources ensures Connection closes automatically
        try (Connection con = DBConnection.getConnection()) {

            // 1. Insert Booking
            String sqlInsert = "INSERT INTO booking(user_id, bus_id, seats_booked, travel_date, total_fare) VALUES(?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sqlInsert);

            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getBusId());
            ps.setInt(3, booking.getSeatsBooked());
            ps.setDate(4, new java.sql.Date(booking.getTravelDate().getTime()));
            ps.setDouble(5, booking.getTotalFare());

            ps.executeUpdate();

            // 2. Update Bus Seats
            String sqlUpdate = "UPDATE bus SET seats_available = seats_available - ? WHERE bus_id=?";
            PreparedStatement updateSeats = con.prepareStatement(sqlUpdate);

            updateSeats.setInt(1, booking.getSeatsBooked());
            updateSeats.setInt(2, booking.getBusId());
            updateSeats.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cancelTicket(int bookingId) {
        try (Connection con = DBConnection.getConnection()) {

            // 1. Get Booking Details (to restore seats)
            PreparedStatement ps = con.prepareStatement("SELECT bus_id, seats_booked FROM booking WHERE booking_id=?");
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int busId = rs.getInt("bus_id");
                int seats = rs.getInt("seats_booked");

                // 2. Add Seats Back to Bus
                PreparedStatement update = con.prepareStatement("UPDATE bus SET seats_available = seats_available + ? WHERE bus_id=?");
                update.setInt(1, seats);
                update.setInt(2, busId);
                update.executeUpdate();
            }

            // 3. Delete Booking
            PreparedStatement delete = con.prepareStatement("DELETE FROM booking WHERE booking_id=?");
            delete.setInt(1, bookingId);
            delete.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps = con.prepareStatement("SELECT * FROM booking WHERE user_id = ?");
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setBusId(rs.getInt("bus_id"));
                b.setSeatsBooked(rs.getInt("seats_booked"));
                b.setTravelDate(rs.getDate("travel_date"));
                b.setTotalFare(rs.getDouble("total_fare"));

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}