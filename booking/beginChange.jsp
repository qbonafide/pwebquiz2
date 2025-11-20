<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String ctx = request.getContextPath();
    String id = request.getParameter("id");

    if (id == null) {
        response.sendRedirect(ctx + "/reservation");
        return;
    }
%>

<%
Connection conn = null;
%>
<%@ include file="../WEB-INF/db.jsp" %>

<%
    String roomType = "";
    String roomNumber = "";
    String date = "";
    String price = "0";

    try {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT rt.name AS room_type, r.room_number, b.date, rt.price_per_hour " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.id " +
            "JOIN room_types rt ON r.room_type_id = rt.id " +
            "WHERE b.id=?"
        );
        ps.setInt(1, Integer.parseInt(id));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            roomType   = rs.getString("room_type");
            roomNumber = rs.getString("room_number");
            date       = rs.getString("date");
            price      = rs.getString("price_per_hour");
        }

        rs.close();
        ps.close();

    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect(ctx + "/reservation");
        return;
    }

    String route = roomType.startsWith("Individual") ? "/booking/individual"
                 : roomType.startsWith("Group") ? "/booking/group"
                 : "/booking/vip";

    response.sendRedirect(
        ctx + route +
        "?room_type=" + roomType +
        "&desk_number=" + roomNumber +
        "&date=" + date +
        "&price=" + price +
        "&change_id=" + id
    );
%>
