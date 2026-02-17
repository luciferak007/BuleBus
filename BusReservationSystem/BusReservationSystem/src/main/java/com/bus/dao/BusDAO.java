package com.bus.dao;

import java.sql.*;
import java.util.*;
import com.bus.model.Bus;

public class BusDAO {

    // ✅ ADD BUS (With Automatic Connection Closing)
    public void addBus(Bus bus) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO bus(bus_id, route, type, seat_type, seats_available, price, arrival_time, departure_time) VALUES(?,?,?,?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bus.getBusId());
            ps.setString(2, bus.getRoute());
            ps.setString(3, bus.getType());
            ps.setString(4, bus.getSeatType());
            ps.setInt(5, bus.getSeatsAvailable());
            ps.setDouble(6, bus.getPrice());
            ps.setString(7, bus.getArrivalTime());
            ps.setString(8, bus.getDepartureTime());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e; // Throw error so Servlet can handle it
        }
    }
    public void deleteBus(int busId) {

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("DELETE FROM bus WHERE bus_id=?");

            ps.setInt(1, busId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ GET ALL BUSES
    public List<Bus> getAllBuses() {
        List<Bus> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM bus");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Bus bus = new Bus();
                bus.setBusId(rs.getInt("bus_id"));
                bus.setRoute(rs.getString("route"));
                bus.setType(rs.getString("type"));
                bus.setSeatType(rs.getString("seat_type"));
                bus.setSeatsAvailable(rs.getInt("seats_available"));
                bus.setPrice(rs.getDouble("price"));
                bus.setArrivalTime(rs.getString("arrival_time"));
                bus.setDepartureTime(rs.getString("departure_time"));
                list.add(bus);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ GET BUS BY ID
    public Bus getBusById(int busId) {
        Bus bus = null;
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM bus WHERE bus_id=?");
            ps.setInt(1, busId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                bus = new Bus();
                bus.setBusId(rs.getInt("bus_id"));
                bus.setRoute(rs.getString("route"));
                bus.setType(rs.getString("type"));
                bus.setSeatType(rs.getString("seat_type"));
                bus.setSeatsAvailable(rs.getInt("seats_available"));
                bus.setPrice(rs.getDouble("price"));
                bus.setArrivalTime(rs.getString("arrival_time"));
                bus.setDepartureTime(rs.getString("departure_time"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bus;
    }
}