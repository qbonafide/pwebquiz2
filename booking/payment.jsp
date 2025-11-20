<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>

<jsp:include page="/WEB-INF/db.jsp" />

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();

    String roomType   = request.getParameter("room_type");
    String deskNumber = request.getParameter("desk_number");
    String date       = request.getParameter("date");
    String priceStr   = request.getParameter("price");
    String times      = request.getParameter("times");

    if (roomType == null || deskNumber == null || date == null ||
        priceStr == null || times == null ||
        roomType.trim().isEmpty() || deskNumber.trim().isEmpty() ||
        date.trim().isEmpty() || priceStr.trim().isEmpty() ||
        times.trim().isEmpty()) {

%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Payment Error</title></head>
<body style="text-align:center;margin-top:50px;color:red;">
    ERROR: Missing booking data from previous page.<br>
    Please go back to <a href="<%= ctx %>/booking/booking.jsp">Booking</a> and try again.
</body>
</html>
<%
        return;
    }

    int pricePerHour = 0;
    try { pricePerHour = Integer.parseInt(priceStr); } catch(Exception e) { pricePerHour=0; }

    String[] slotArr = times.split(",");
    List<String> slots = new ArrayList<>();
    for(String s: slotArr) { if(!s.trim().isEmpty()) slots.add(s.trim()); }
    int hours = slots.size();
    if(hours==0) { out.println("No time slots selected."); return; }

    String startTime = slots.get(0).contains("-")? slots.get(0).split("-")[0] : slots.get(0);
    String endTime   = slots.get(slots.size()-1).contains("-")? slots.get(slots.size()-1).split("-")[1] : slots.get(slots.size()-1);

    int totalPrice = pricePerHour * hours;
    int userId = (Integer) session.getAttribute("userId");
    Connection conn = (Connection) application.getAttribute("conn");
    if(conn==null) { out.println("Database error"); return; }

    int bookingId = 0;
    String errorMsg = null;
    try {
        int roomTypeId = "Individual Desk".equals(roomType)?1:"Group Desk".equals(roomType)?2:"VIP Room".equals(roomType)?3:0;
        if(roomTypeId==0) errorMsg="Unknown room type: "+roomType;
        else {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id FROM rooms WHERE room_type_id=? AND room_number=? LIMIT 1"
            );
            ps.setInt(1, roomTypeId);
            ps.setString(2, deskNumber);
            ResultSet rs = ps.executeQuery();
            int roomId = 0;
            if(rs.next()) roomId = rs.getInt("id");
            rs.close(); ps.close();

            if(roomId==0) errorMsg="Room not found for "+roomType+" - "+deskNumber;
            else {
                ps = conn.prepareStatement(
                    "INSERT INTO bookings(user_id, room_id, date, start_time, end_time, total_price, status) VALUES(?,?,?,?,?,?,'pending')",
                    Statement.RETURN_GENERATED_KEYS
                );
                ps.setInt(1,userId); ps.setInt(2,roomId); ps.setString(3,date);
                ps.setString(4,startTime); ps.setString(5,endTime); ps.setInt(6,totalPrice);
                int affected = ps.executeUpdate();
                if(affected>0) {
                    rs = ps.getGeneratedKeys();
                    if(rs.next()) bookingId = rs.getInt(1);
                    rs.close();
                } else errorMsg="Insert booking failed.";
                ps.close();
            }
        }
    } catch(Exception e){ e.printStackTrace(); errorMsg=e.getMessage(); }

    if(bookingId==0) {
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Payment Error</title></head>
<body style="text-align:center;margin-top:50px;color:red;">
    <h2>Booking failed!</h2>
    <p>Reason: <%= (errorMsg==null?"Unknown":errorMsg) %></p>
    <p>Debug: roomType=<%=roomType%> deskNumber=<%=deskNumber%> date=<%=date%> times=<%=times%></p>
    <p>Go back to <a href="<%= ctx %>/booking/booking.jsp">Booking</a></p>
</body>
</html>
<%
        return;
    }

    session.setAttribute("last_booking_id", String.valueOf(bookingId));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Payment – ITStudy</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#fff8f3; font-family:Poppins; padding-top:90px; }
.wrapper { max-width:1000px; margin:40px auto; background:white; padding:30px; border-radius:20px; }
.btn-brown { background:#4b1f0e;color:white;border-radius:30px;padding:10px 22px;font-weight:600; }
.btn-brown:hover { background:#6b2f1b; }
</style>
</head>
<body>
<%@ include file="../layouts/navbar.jsp" %>
<div class="wrapper shadow-sm">
<h3 class="text-center fw-bold mb-4">ITStudy</h3>
<div class="row g-4">
    <div class="col-md-6 text-center">
        <img src="<%= ctx %>/img/payment/qr-code.png" style="max-width:220px;" alt="QR">
        <p class="mt-3 text-muted">Upload your payment proof and wait for confirmation.</p>
        <form action="<%= ctx %>/booking/uploadProof.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="booking_id" value="<%= bookingId %>">
            <input type="file" name="payment_image" class="form-control mb-3" required>
            <button type="submit" class="btn-brown w-100">Done Payment</button>
        </form>
    </div>
    <div class="col-md-6">
        <div class="bg-light p-4 rounded shadow-sm">
            <h5 class="fw-bold mb-3">Your Order</h5>
            <p><b>Room Type:</b> <%= roomType %></p>
            <p><b>Desk Number:</b> <%= deskNumber %></p>
            <p><b>Date:</b> <%= date %></p>
            <p><b>Time:</b> <%= times %></p>
            <hr>
            <p>Price/hour: Rp<%= pricePerHour %></p>
            <p>Total hours: <%= hours %></p>
            <h5 class="fw-bold">Total price: Rp<%= totalPrice %></h5>
        </div>
    </div>
</div>
</div>
</body>
</html>
