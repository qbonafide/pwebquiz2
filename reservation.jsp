<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.util.Locale, java.util.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    int userId = (Integer) session.getAttribute("userId");
    String ctx = request.getContextPath();

    String successMessage = (String) session.getAttribute("success_message");
    if (successMessage != null) {
        session.removeAttribute("success_message");
    }
%>

<%@ include file="WEB-INF/db.jsp" %>

<%
    PreparedStatement pst = null;
    ResultSet rs = null;

    List<Map<String, String>> reservations = new ArrayList<>();

    try {
        String sql =
            "SELECT b.id, rt.name AS room_type, r.room_number, b.date, b.start_time, b.end_time, " +
            "b.total_price, b.status " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN room_types rt ON r.room_type_id = rt.id " +
            "WHERE b.user_id = ? " +
            "ORDER BY b.id DESC";

        pst = existingConn.prepareStatement(sql);
        pst.setInt(1, userId);
        rs = pst.executeQuery();

        while (rs.next()) {
            Map<String, String> row = new HashMap<>();

            java.sql.Date sqlDate = rs.getDate("date");
            java.util.Date dateObj = new java.util.Date(sqlDate.getTime());
            String formattedDate = new java.text.SimpleDateFormat("EEEE, dd MMM yyyy", Locale.ENGLISH)
                                    .format(dateObj);

            String timeRange = rs.getString("start_time") + " - " + rs.getString("end_time");

            row.put("id", rs.getString("id"));
            row.put("room_type", rs.getString("room_type"));
            row.put("room_number", rs.getString("room_number"));
            row.put("date", formattedDate);
            row.put("time", timeRange);
            row.put("total_price", rs.getString("total_price"));
            row.put("status", rs.getString("status"));

            reservations.add(row);
        }

    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception ex){}
        try { if (pst != null) pst.close(); } catch(Exception ex){}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Reservations — ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#fff8f3; padding-top:90px; font-family:Poppins; }

        .wrapper { max-width:1100px; margin:auto; }

        .card-box {
            background:white;
            padding:25px;
            border-radius:20px;
            border:1px solid #e7d7c8;
            box-shadow:0 5px 15px rgba(0,0,0,0.1);
            margin-bottom:25px;
        }

        .badge-status { padding:6px 12px; font-weight:600; border-radius:20px; }
        .confirmed { background:#4CAF50; color:white; }
        .pending { background:#ff9800; color:white; }
        .cancelled { background:#f44336; color:white; }

        .btn-cancel {
            background:#d9534f;
            padding:8px 30px;
            color:white;
            border:none;
            border-radius:25px;
            font-weight:600;
        }

        .btn-change {
            background:#ffca2c;
            padding:8px 30px;
            color:#4b1f0e;
            border:none;
            border-radius:25px;
            font-weight:600;
        }
    </style>
</head>
<body>

<%@ include file="layouts/navbar.jsp" %>

<div class="wrapper">

    <h2 class="text-center fw-bold mb-4">My Reservations</h2>

    <% if (successMessage != null) { %>
        <div class="alert alert-success text-center rounded-pill shadow-sm" style="max-width:600px; margin:auto;">
            <%= successMessage %>
        </div>
    <% } %>

    <% if (reservations.size() == 0) { %>

        <p class="text-center mt-5">You have no reservations yet.</p>

    <% } else { 
        for (Map<String,String> r : reservations) {

            String status = r.get("status");
            String badgeClass = status.equals("confirmed") ? "confirmed"
                                 : status.equals("cancelled") ? "cancelled"
                                 : "pending";
    %>

        <div class="card-box">

            <div class="d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0">Reservation #<%= r.get("id") %></h5>

                <span class="badge-status <%= badgeClass %>">
                    <%= status.substring(0,1).toUpperCase() + status.substring(1) %>
                </span>
            </div>

            <table class="table mt-3 mb-0">
                <tr><td><b>Room Type</b></td><td><%= r.get("room_type") %></td></tr>
                <tr><td><b>Desk Number</b></td><td><%= r.get("room_number") %></td></tr>
                <tr><td><b>Date</b></td><td><%= r.get("date") %></td></tr>
                <tr><td><b>Time</b></td><td><%= r.get("time") %></td></tr>
                <tr><td><b>Total Price</b></td><td>Rp<%= r.get("total_price") %></td></tr>
            </table>

            <div class="mt-4 text-center">

                <form action="<%= ctx %>/booking/cancelBooking.jsp" method="post" style="display:inline-block;">
                    <input type="hidden" name="id" value="<%= r.get("id") %>">
                    <button class="btn-cancel">Cancel</button>
                </form>


                <form action="<%= ctx %>/booking/updateBooking.jsp" method="get" style="display:inline-block;">
                    <input type="hidden" name="id" value="<%= r.get("id") %>">
                    <button class="btn-change ms-2">Change</button>
                </form>


            </div>

        </div>

    <% } } %>

</div>

</body>
</html>
