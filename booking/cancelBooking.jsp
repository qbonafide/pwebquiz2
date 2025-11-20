<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String bookingId = request.getParameter("id");
    String ctx = request.getContextPath();

    if (bookingId == null) {
        response.sendRedirect(ctx + "/reservation");
        return;
    }
%>

<%@ include file="../WEB-INF/db.jsp" %>

<%
    try {
        PreparedStatement ps = existingConn.prepareStatement(
            "DELETE FROM bookings WHERE id=?"
        );
        ps.setInt(1, Integer.parseInt(bookingId));
        ps.executeUpdate();
        ps.close();

        session.setAttribute("success_message", "Booking deleted successfully!");

    } catch(Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Failed to delete booking!");
    }

    response.sendRedirect(ctx + "/reservation");
%>
