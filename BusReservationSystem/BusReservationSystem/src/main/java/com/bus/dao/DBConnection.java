package com.bus.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static String url = "jdbc:mysql://localhost:3306/bus_reservation";
    private static String username = "root";
    private static String password = "root";

    public static Connection getConnection() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}