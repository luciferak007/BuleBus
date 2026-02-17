package com.bus.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.bus.dao.BusDAO;

@WebServlet("/deleteBus")
public class DeleteBusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("busId"));

            BusDAO dao = new BusDAO();
            dao.deleteBus(id);

            response.sendRedirect("vendorHome.jsp?msg=Bus Deleted!");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("vendorHome.jsp?msg=Delete Failed!");
        }
    }
}
