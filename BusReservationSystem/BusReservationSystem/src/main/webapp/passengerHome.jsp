<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.bus.model.Bus, com.bus.dao.BusDAO, com.bus.model.Booking, com.bus.dao.BookingDAO" %>
<%
    // 1. Security Check
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    if(userId == null) { response.sendRedirect("login.jsp"); return; }
    
    // 2. Fetch Data
    BusDAO busDAO = new BusDAO();
    List<Bus> buses = busDAO.getAllBuses();
    
    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> myBookings = bookingDAO.getBookingsByUserId(userId);
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"> <title>Dashboard - Bus Reservation</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <div class="navbar">
        <a href="#" class="logo">BlueBus</a>
        <div class="nav-links">
            <span>Welcome, <b><%= username %></b></span>
            <a href="LogoutServlet" class="btn btn-danger" style="margin-left:15px;">Logout</a>
        </div>
    </div>

    <div class="container">
        <% if(msg != null) { %>
            <div class="alert alert-success" style="text-align: center; margin-bottom: 20px; padding: 10px; background: #d4edda; color: #155724; border-radius: 5px;">
                <%= msg %>
            </div>
        <% } %>

        <div class="dashboard-card">
            <h3>Available Buses</h3>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Route</th>
                            <th>Type</th>
                            <th>Timing</th>
                            <th>Seats</th>
                            <th>Price</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (buses != null && !buses.isEmpty()) { 
                            for (Bus b : buses) { %>
                        <tr>
                            <td>
                                <b><%= b.getRoute() %></b><br>
                                <small style="color:#666;">ID: <%= b.getBusId() %></small>
                            </td>
                            <td><%= b.getType() %> / <%= b.getSeatType() %></td>
                            <td><%= b.getDepartureTime() %> - <%= b.getArrivalTime() %></td>
                            <td><%= b.getSeatsAvailable() %></td>
                            <td>₹ <%= b.getPrice() %></td>
                            <td>
                                <form action="book.jsp" method="get" style="display:inline;">
                                    <input type="hidden" name="busId" value="<%= b.getBusId() %>">
                                    <input type="hidden" name="price" value="<%= b.getPrice() %>">
                                    <input type="hidden" name="route" value="<%= b.getRoute() %>">
                                    <button type="submit" class="btn">Book Now</button>
                                </form>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" style="text-align:center;">No buses available.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

       <div class="dashboard-card">
            <h3>My Bookings</h3>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 100px;">Booking ID</th> <th>Bus Details</th>
                            <th>Seats</th>
                            <th>Travel Date</th>
                            <th>Total Fare</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (myBookings != null && !myBookings.isEmpty()) {
                            for (Booking bk : myBookings) { 
                                Bus bookedBus = busDAO.getBusById(bk.getBusId());
                        %>
                        <tr>
                            <td style="font-weight: bold; color: #4e73df;">
                                #<%= bk.getBookingId() %>
                            </td>

                            <td>
                                <% if(bookedBus != null) { %>
                                    <div style="line-height: 1.5;">
                                        <span style="font-size: 1.1em; font-weight: bold;"><%= bookedBus.getRoute() %></span><br>
                                        
                                        <span style="color: #555;">
                                            <%= (bookedBus.getType() != null) ? bookedBus.getType() : "N/A" %> 
                                            (<%= (bookedBus.getSeatType() != null) ? bookedBus.getSeatType() : "N/A" %>)
                                        </span><br>
                                        
                                        <span style="color: #888; font-size: 0.9em;">
                                            Dep: <%= (bookedBus.getDepartureTime() != null) ? bookedBus.getDepartureTime() : "--:--" %>
                                        </span>
                                    </div>
                                <% } else { %>
                                    <span style="color:red;">Bus details not found (ID: <%= bk.getBusId() %>)</span>
                                <% } %>
                            </td>

                            <td><%= bk.getSeatsBooked() %></td>
                            <td><%= bk.getTravelDate() %></td>
                            <td>&#8377; <%= bk.getTotalFare() %></td>
                            <td>
                                <form action="cancelTicket" method="post" onsubmit="return confirm('Are you sure you want to cancel?');">
                                    <input type="hidden" name="bookingId" value="<%= bk.getBookingId() %>">
                                    <button type="submit" class="btn btn-danger">Cancel</button>
                                </form>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="6" style="text-align:center; padding: 20px;">No bookings found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        </div>
    </div>

</body>
</html>