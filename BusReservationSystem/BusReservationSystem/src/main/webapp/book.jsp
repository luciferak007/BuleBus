<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userId") == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Ticket</title>
<style>
.back {
    display:inline-block;
    padding:8px 14px;
    border-radius:8px;
    background:#4e73df;
    color:white;
    text-decoration:none;
    font-size:14px;
    font-weight:600;
    transition:0.3s;
}

.back:hover {
    background:#224abe;
}
</style>

    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="max-width: 500px;">
        <div class="card">
            <h2>Confirm Booking</h2>
            <p>Route: <b><%= request.getParameter("route") %></b></p>
            <p>Price per seat: <b>₹<%= request.getParameter("price") %></b></p>

            <form action="book" method="post">
                <input type="hidden" name="userId" value="<%= session.getAttribute("userId") %>">
                <input type="hidden" name="busId" value="<%= request.getParameter("busId") %>">
                
                <label>Date of Travel:</label>
                <input type="date" name="date" class="form-input" required min="<%= new java.sql.Date(System.currentTimeMillis()) %>">

                <label>Seats:</label>
                <input type="number" name="seats" class="form-input" min="1" max="10" required placeholder="Enter seats">

                <button class="btn" style="width:100%; margin-top:10px;">Pay & Book</button>
            </form>
            <br>
            
        <a href="passengerHome.jsp" class="back">
    ⬅ Back to Dashboard
</a>
        
            
        </div>
    </div>
</body>
</html>