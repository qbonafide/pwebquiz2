<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    String bookingId = request.getParameter("booking_id");
    if(bookingId==null || bookingId.trim().isEmpty()){
        bookingId = (String) session.getAttribute("last_booking_id");
    }

    if(bookingId==null || bookingId.trim().isEmpty()){
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Upload Proof – Error</title>
<style>body { font-family:Poppins,sans-serif; text-align:center; margin-top:50px; }</style>
</head>
<body>
<h2 style="color:red;">ERROR: booking_id is missing!</h2>
<p>Please go back to <a href="<%= ctx %>/booking/booking.jsp">Booking</a> and try again.</p>
<hr>
<p><b>Debug:</b> booking_id parameter = <%= request.getParameter("booking_id") %></p>
<p><b>Debug:</b> last_booking_id session = <%= session.getAttribute("last_booking_id") %></p>
</body>
</html>
<%
        return;
    }

    session.setAttribute("last_booking_id", bookingId);
    session.setAttribute("success_message",
        "Payment proof uploaded successfully.<br>" +
        "<b>Please chat Admin via WhatsApp to get your booking ticket.</b>"
    );

    response.sendRedirect(ctx + "/reservation.jsp");
%>
