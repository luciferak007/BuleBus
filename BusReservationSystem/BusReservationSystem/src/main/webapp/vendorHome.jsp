<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bus.dao.BusDAO, com.bus.model.Bus, java.util.List" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>

<%!
    // ✅ HELPER METHOD: Converts "23:00" -> "11:00 PM"
    public String formatTime(String time) {
        try {
            if (time == null || time.isEmpty()) return "--";
            // Input format from <input type="time"> is usually HH:mm (24-hour)
            SimpleDateFormat inputFormat = new SimpleDateFormat("HH:mm");
            // Output format we want
            SimpleDateFormat outputFormat = new SimpleDateFormat("hh:mm a");
            Date date = inputFormat.parse(time);
            return outputFormat.format(date);
        } catch (Exception e) {
            return time; // If it's already formatted or weird, just show it as is
        }
    }
%>

<%
    // Security Check
    if(!"VENDOR".equals(session.getAttribute("role"))) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }

    List<Bus> buses = new BusDAO().getAllBuses();
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vendor Panel</title>
<link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="navbar">
    <a href="#" class="logo">BlueBus Vendor</a>
    <div class="nav-links">
        <span>Vendor: <b><%= session.getAttribute("username") %></b></span>
        <a href="LogoutServlet" class="btn btn-danger" style="margin-left:15px;">Logout</a>
    </div>
</div>

<div class="container">

    <% if(msg != null) { %>
        <div class="alert alert-success"
             style="background:#d4edda;color:#155724;padding:10px;margin-bottom:15px;border-radius:5px;text-align:center;">
            <%= msg %>
        </div>
    <% } %>

    <div class="dashboard-card">
        <h3>Add New Bus</h3>

        <form action="addBus" method="post" style="display:grid; grid-template-columns: 1fr 1fr; gap:15px;">

            <input name="busId" type="number" placeholder="Bus ID (Unique)" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">
            <input name="route" placeholder="Route (e.g. Chennai - Bangalore)" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">

            <select name="type" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">
                <option value="" disabled selected>Select Bus Type</option>
                <option value="AC">AC</option>
                <option value="Non-AC">Non-AC</option>
            </select>

            <select name="seatType" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">
                <option value="" disabled selected>Select Seat Type</option>
                <option value="Sleeper">Sleeper</option>
                <option value="Seater">Seater</option>
            </select>

            <input name="seats" type="number" placeholder="Total Seats" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">
            <input name="price" type="number" placeholder="Price per Seat" required style="padding:10px; border:1px solid #ccc; border-radius:4px;">

            <div>
                <label style="font-size:12px; font-weight:bold; color:#555;">Departure Time</label>
                <input type="time" name="departure" required style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px;">
            </div>

            <div>
                <label style="font-size:12px; font-weight:bold; color:#555;">Arrival Time</label>
                <input type="time" name="arrival" required style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px;">
            </div>

            <button style="grid-column:span 2; margin-top:10px;" type="submit" class="btn">
                Add Bus
            </button>
        </form>
    </div>


    <div class="dashboard-card">
        <h3>Your Fleet</h3>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
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
                        <td style="font-weight:bold; color:#4e73df;">#<%= b.getBusId() %></td>
                        <td><b><%= b.getRoute() %></b></td>
                        <td><%= b.getType() %> / <%= b.getSeatType() %></td>
                        
                        <td style="font-size:0.9em; color:#555;">
                            <%= formatTime(b.getDepartureTime()) %> - <%= formatTime(b.getArrivalTime()) %>
                        </td>
                        
                        <td><%= b.getSeatsAvailable() %></td>
                        <td>&#8377; <%= b.getPrice() %></td>

                        <td>
                            <form action="deleteBus" method="post" onsubmit="return confirm('Permanently delete Bus #<%= b.getBusId() %>?');">
                                <input type="hidden" name="busId" value="<%= b.getBusId() %>">
                                <button type="submit" class="btn btn-danger" style="padding:5px 10px; font-size:12px;">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr>
                        <td colspan="7" style="text-align:center; padding:20px;">
                            No buses found.
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div> 

</div>

</body>
</html>