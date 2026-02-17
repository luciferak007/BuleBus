package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.bus.dao.BusDAO;
import com.bus.model.Bus;

@WebServlet("/addBus")
public class AddBusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Bus bus = new Bus();

            int busId = Integer.parseInt(request.getParameter("busId"));
            int seats = Integer.parseInt(request.getParameter("seats"));
            double price = Double.parseDouble(request.getParameter("price"));

            bus.setBusId(busId);
            bus.setRoute(request.getParameter("route"));
            bus.setType(request.getParameter("type"));
            bus.setSeatType(request.getParameter("seatType"));
            bus.setSeatsAvailable(seats);
            bus.setPrice(price);
            bus.setArrivalTime(request.getParameter("arrival"));
            bus.setDepartureTime(request.getParameter("departure"));

            BusDAO dao = new BusDAO();
            dao.addBus(bus);

            System.out.println("✅ Bus Added Successfully");

            response.sendRedirect("vendorHome.jsp?msg=Bus Added Successfully!");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("vendorHome.jsp?msg=Error Adding Bus!");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("vendorHome.jsp");
    }
}
