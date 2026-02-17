<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*,com.bus.dao.DBConnection" %>
<%@ page import="java.text.NumberFormat" %>

<%
    // 1. SECURITY CHECK
    if (session.getAttribute("username") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Check for messages
    String msg = request.getParameter("msg");
    
    NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body { font-family:'Segoe UI',sans-serif; background:#f4f6f9; display:flex; }

    /* ===== Sidebar ===== */
    .sidebar { width:250px; height:100vh; background:linear-gradient(180deg,#4e73df,#224abe); padding-top:30px; position:fixed; color:white; }
    .sidebar h2 { text-align:center; margin-bottom:30px; letter-spacing: 1px; }
    .sidebar a { display:block; color:rgba(255,255,255,0.8); padding:15px 25px; text-decoration:none; transition:0.3s; border-left: 5px solid transparent; }
    .sidebar a:hover, .sidebar a.active { background:rgba(255,255,255,0.1); border-left: 5px solid white; color:white; font-weight: bold; }

    /* ===== Main Content ===== */
    .main { margin-left:250px; width:100%; padding:30px; }

    /* Top Bar */
    .topbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:25px; }
    .logout { background:#e74a3b; color:white; padding:8px 20px; border-radius:6px; text-decoration:none; font-weight:bold; box-shadow: 0 2px 5px rgba(231,74,59,0.3); }

    /* Cards */
    .card { background:white; padding:25px; border-radius:12px; box-shadow:0 5px 15px rgba(0,0,0,0.05); margin-bottom:30px; display:none; }
    .card.active { display:block; animation: fadeIn 0.5s; }

    /* Tables */
    table { width:100%; border-collapse:collapse; margin-top:15px; }
    th { background:#f8f9fc; color:#4e73df; padding:15px; text-align:left; border-bottom: 2px solid #e3e6f0; }
    td { padding:15px; border-bottom:1px solid #eee; color: #555; }
    tr:hover { background:#fafafa; }

    /* Status Badges */
    .badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
    .badge-passenger { background: #e2e6ea; color: #4e73df; }
    .badge-vendor { background: #d4edda; color: #155724; }
    
    /* Buttons */
    .btn { background:#4e73df; color:white; border:none; padding:8px 14px; border-radius:6px; cursor:pointer; font-weight:600; text-decoration:none; display:inline-block; transition:0.3s; }
    .btn:hover { background:#2e59d9; }
    .btn-danger { background:#e74a3b; }
    .btn-danger:hover { background:#c0392b; }
    .btn-success { background:#1cc88a; } 
    .btn-success:hover { background:#17a673; }

    /* Total Boxes */
    .stats-container { display:flex; justify-content:space-between; align-items:center; margin-bottom: 15px; }
    .total-box { font-weight:bold; color:#4e73df; font-size: 1.1rem; }
    .revenue-box { color: #1cc88a; font-size: 1.2rem; font-weight: bold; }
    
    /* Message Alert */
    .alert { padding: 10px; background-color: #d4edda; color: #155724; border-radius: 5px; margin-bottom: 20px; }

    /* ===== MODAL POPUP STYLES ===== */
    .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
    .modal-content { background-color: white; margin: 10% auto; padding: 25px; border-radius: 10px; width: 350px; box-shadow: 0 4px 10px rgba(0,0,0,0.2); animation: fadeIn 0.3s; }
    .modal h3 { text-align: center; margin-bottom: 20px; color: #4e73df; }
    .modal input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; }
    .modal-actions { display: flex; justify-content: space-between; margin-top: 15px; }
    .close-btn { background: #858796; }
    .close-btn:hover { background: #60616f; }

    @keyframes fadeIn { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }
</style>
</head>

<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <a href="#" onclick="showSection('bookings', this)" class="active">All Bookings</a>
    <a href="#" onclick="showSection('passengers', this)">Manage Passengers</a>
    <a href="#" onclick="showSection('vendors', this)">Manage Vendors</a>
</div>

<div class="main">

    <div class="topbar">
        <h2>Welcome, <%= session.getAttribute("username") %></h2>
        <a href="LogoutServlet" class="logout">Logout</a>
    </div>

    <% if(msg != null) { %>
        <div class="alert"><%= msg %></div>
    <% } %>

    <div id="bookings" class="card active">
        <h3>All Bookings</h3>

        <%
            double grandTotal = 0.0;
            try(Connection con = DBConnection.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT SUM(total_fare) FROM booking")) {
                if(rs.next()){ grandTotal = rs.getDouble(1); }
            } catch(Exception e) {}
        %>

        <div class="stats-container">
            <div class="total-box revenue-box">
                Total Revenue: <%= currency.format(grandTotal) %>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>S.No</th> <th>Passenger</th>
                    <th>Bus Route</th>
                    <th>Date</th>
                    <th>Seats</th>
                    <th>Total Fare</th>
                </tr>
            </thead>
            <tbody>
            <%
            int bookingCount = 1; // COUNTER INITIALIZED
            try (Connection con = DBConnection.getConnection();
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(
                    "SELECT b.booking_id, u.name, bus.route, b.travel_date, " +
                    "b.seats_booked, b.total_fare " +
                    "FROM booking b " +
                    "JOIN user u ON b.user_id = u.user_id " +
                    "JOIN bus ON b.bus_id = bus.bus_id " +
                    "ORDER BY b.booking_id DESC")) {

                while(rs.next()) {
            %>
            <tr>
                <td><%= bookingCount++ %></td> <td><b><%= rs.getString("name") %></b></td>
                <td><%= rs.getString("route") %></td>
                <td><%= rs.getDate("travel_date") %></td>
                <td><%= rs.getInt("seats_booked") %></td>
                <td style="color:#28a745;font-weight:bold;">&#8377; <%= rs.getDouble("total_fare") %></td>
            </tr>
            <%
                }
            } catch(Exception e) {
            %>
            <tr><td colspan="6" style="color:red;">Error: <%= e.getMessage() %></td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div id="passengers" class="card">
        <h3>Passenger List</h3>

        <%
        int totalPassengers = 0;
        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM user WHERE role='PASSENGER'")){
            if(rs.next()){ totalPassengers = rs.getInt(1); }
        }
        %>
        
        <div class="stats-container">
            <div class="total-box">Total Passengers: <%= totalPassengers %></div>
            <button class="btn btn-success" onclick="openModal('passengerModal')">+ Add Passenger</button>
        </div>

        <table>
            <thead>
                <tr>
                    <th>S.No</th> <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
            int passCount = 1; // COUNTER INITIALIZED
            try (Connection con = DBConnection.getConnection();
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM user WHERE role='PASSENGER' ORDER BY user_id DESC")) {

                while(rs.next()) {
            %>
            <tr>
                <td><%= passCount++ %></td> <td><b><%= rs.getString("name") %></b></td>
                <td><%= rs.getString("email") %></td>
                <td><span class="badge badge-passenger">Passenger</span></td>
                <td>
                    <form action="deleteUser" method="post" onsubmit="return confirm('Delete this passenger?');">
                        <input type="hidden" name="userId" value="<%= rs.getInt("user_id") %>">
                        <button class="btn btn-danger">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                }
            } catch(Exception e) {
            %>
            <tr><td colspan="5" style="color:red;">Error: <%= e.getMessage() %></td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <div id="vendors" class="card">
        <h3>Registered Vendors</h3>

        <%
        int totalVendors = 0;
        try(Connection con = DBConnection.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM user WHERE role='VENDOR'")){
            if(rs.next()){ totalVendors = rs.getInt(1); }
        }
        %>
        
        <div class="stats-container">
            <div class="total-box">Total Vendors: <%= totalVendors %></div>
            <button class="btn btn-success" onclick="openModal('vendorModal')">+ Add Vendor</button>
        </div>

        <table>
            <thead>
                <tr>
                    <th>S.No</th> <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th> 
                </tr>
            </thead>
            <tbody>
            <%
            int vendCount = 1; // COUNTER INITIALIZED
            try (Connection con = DBConnection.getConnection();
                 Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT * FROM user WHERE role='VENDOR' ORDER BY user_id DESC")) {

                while(rs.next()) {
            %>
            <tr>
                <td><%= vendCount++ %></td> <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><span class="badge badge-vendor">Vendor</span></td>
                <td>
                    <form action="deleteUser" method="post" onsubmit="return confirm('Delete this vendor?');">
                        <input type="hidden" name="userId" value="<%= rs.getInt("user_id") %>">
                        <button class="btn btn-danger">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            }
            %>
            </tbody>
        </table>
    </div>

</div>

<div id="passengerModal" class="modal">
    <div class="modal-content">
        <h3>Add New Passenger</h3>
        <form action="addUser" method="post">
            <input type="hidden" name="role" value="PASSENGER">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <div class="modal-actions">
                <button type="button" class="btn close-btn" onclick="closeModal('passengerModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Save</button>
            </div>
        </form>
    </div>
</div>

<div id="vendorModal" class="modal">
    <div class="modal-content">
        <h3>Add New Vendor</h3>
        <form action="addUser" method="post">
            <input type="hidden" name="role" value="VENDOR">
            <input type="text" name="name" placeholder="Vendor Name" required>
            <input type="email" name="email" placeholder="Email Address" required>
            <input type="password" name="password" placeholder="Password" required>
            <div class="modal-actions">
                <button type="button" class="btn close-btn" onclick="closeModal('vendorModal')">Cancel</button>
                <button type="submit" class="btn btn-success">Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showSection(id, element) {
        document.querySelectorAll('.card').forEach(card => card.classList.remove('active'));
        document.getElementById(id).classList.add('active');
        document.querySelectorAll('.sidebar a').forEach(link => link.classList.remove('active'));
        element.classList.add('active');
    }

    // Modal Functions
    function openModal(modalId) {
        document.getElementById(modalId).style.display = "block";
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
    }

    // Close modal if clicked outside
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = "none";
        }
    }
</script>

</body>
</html>