<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../WEB-INF/db.jsp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String bookingId = request.getParameter("id");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newDate   = request.getParameter("new_date");
        String newSeatId = request.getParameter("new_room_id");
        String times     = request.getParameter("times");

        if (bookingId == null || bookingId.isEmpty() || newDate == null || newSeatId == null || times == null || times.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reservation.jsp");
            return;
        }

        String[] slotArr = times.split(",");

        int minStart = 24;
        int maxEnd   = 0;

        for (String s : slotArr) {
            s = s.trim();
            if (s.isEmpty()) continue;
            String[] parts = s.split("-");
            String startStr = parts[0]; // "HH:MM"
            String endStr   = parts[1]; // "HH:MM"

            int sh = Integer.parseInt(startStr.substring(0, 2));
            int eh = Integer.parseInt(endStr.substring(0, 2));

            if (eh == 0 && endStr.equals("00:00") && sh == 23) {
                eh = 24;
            }

            if (sh < minStart) minStart = sh;
            if (eh > maxEnd)   maxEnd   = eh;
        }

        if (minStart >= maxEnd || minStart < 0 || maxEnd > 24) {
            session.setAttribute("success_message", "Failed to change order (invalid time range).");
            response.sendRedirect(request.getContextPath() + "/reservation.jsp");
            return;
        }

        String startTime = String.format("%02d:00:00", minStart);
        String endTime   = String.format("%02d:00:00", maxEnd);

        PreparedStatement up = null;
        try {
            up = existingConn.prepareStatement(
                    "UPDATE bookings SET date=?, start_time=?, end_time=?, room_id=? WHERE id=?");
            up.setString(1, newDate);
            up.setString(2, startTime);
            up.setString(3, endTime);
            up.setString(4, newSeatId);
            up.setString(5, bookingId);
            up.executeUpdate();

            session.setAttribute("success_message", "Your order changed successfully!");

        } catch (Exception e) {
            session.setAttribute("success_message", "Failed to change order: " + e.getMessage());
        } finally {
            try { if (up != null) up.close(); } catch (Exception ex) {}
        }

        response.sendRedirect(request.getContextPath() + "/reservation.jsp");
        return;
    }

    if (bookingId == null || bookingId.isEmpty()) {
%>
    <h2 style="text-align:center;margin-top:80px;">Invalid Request</h2>
<%
        return;
    }

    PreparedStatement ps = null;
    ResultSet rs = null;

    String roomNumber = "";
    String oldDate    = "";
    String oldStart   = "";
    String oldEnd     = "";
    int currentRoomId = 0;
    int roomTypeId    = 0;
    int duration      = 0;

    try {
        ps = existingConn.prepareStatement(
            "SELECT b.*, r.room_number, r.room_type_id " +
            "FROM bookings b JOIN rooms r ON b.room_id = r.id WHERE b.id=?"
        );
        ps.setString(1, bookingId);
        rs = ps.executeQuery();

        if (!rs.next()) {
%>
    <h2 style="text-align:center;margin-top:80px;">Booking Not Found</h2>
<%
            return;
        }

        roomNumber    = rs.getString("room_number");
        oldDate       = rs.getString("date");
        oldStart      = rs.getString("start_time");
        oldEnd        = rs.getString("end_time");
        currentRoomId = rs.getInt("room_id");
        roomTypeId    = rs.getInt("room_type_id");

        int startH = Integer.parseInt(oldStart.substring(0,2));
        int endH   = Integer.parseInt(oldEnd.substring(0,2));
        duration   = endH - startH;
        if (duration <= 0) duration = 1;

    } catch (Exception e) {
        out.println("ERROR: " + e.getMessage());
        return;
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception ex){}
        try { if (ps != null) ps.close(); } catch(Exception ex){}
    }

    List<Map<String,Object>> seats = new ArrayList<>();
    PreparedStatement psSeats = null;
    ResultSet rsSeats = null;

    try {
        psSeats = existingConn.prepareStatement(
            "SELECT id, room_number FROM rooms WHERE room_type_id=? ORDER BY room_number"
        );
        psSeats.setInt(1, roomTypeId);
        rsSeats = psSeats.executeQuery();
        while (rsSeats.next()) {
            Map<String,Object> s = new HashMap<>();
            s.put("id", rsSeats.getInt("id"));
            s.put("room_number", rsSeats.getString("room_number"));
            seats.add(s);
        }
    } catch (Exception e) {
        out.println("ERROR seat: " + e.getMessage());
    } finally {
        try { if (rsSeats != null) rsSeats.close(); } catch(Exception ex){}
        try { if (psSeats != null) psSeats.close(); } catch(Exception ex){}
    }

    boolean[] bookedHour = new boolean[24];
    PreparedStatement psBooked = null;
    ResultSet rsBooked = null;

    try {
        psBooked = existingConn.prepareStatement(
            "SELECT start_time, end_time FROM bookings " +
            "WHERE room_id = ? AND date = ? AND status <> 'cancelled' AND id <> ?"
        );
        psBooked.setInt(1, currentRoomId);
        psBooked.setString(2, oldDate);
        psBooked.setString(3, bookingId);
        rsBooked = psBooked.executeQuery();

        while (rsBooked.next()) {
            String st = rsBooked.getString("start_time"); // HH:MM:SS
            String et = rsBooked.getString("end_time");
            int sh = Integer.parseInt(st.substring(0,2));
            int eh = Integer.parseInt(et.substring(0,2));

            if (eh == 0 && et.startsWith("00")) {
                eh = 24;
            }

            for (int h = sh; h < eh && h < 24; h++) {
                bookedHour[h] = true;
            }
        }
    } catch (Exception e) {
        out.println("ERROR booked slots: " + e.getMessage());
    } finally {
        try { if (rsBooked != null) rsBooked.close(); } catch(Exception ex){}
        try { if (psBooked != null) psBooked.close(); } catch(Exception ex){}
    }

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking – ITStudy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#fff8f3; padding-top:90px; font-family:Poppins; }
        .wrapper { max-width:1100px; margin:auto; padding:25px; }
        .box { background:white; padding:30px; border-radius:25px; box-shadow:0 6px 18px rgba(0,0,0,0.12); }

        .time-btn {
            border:2px solid #4b1f0e;
            border-radius:25px;
            padding:10px 18px;
            margin:5px;
            background:white;
            color:#4b1f0e;
            font-weight:600;
            min-width:130px;
            transition:.2s;
        }
        .time-btn.active {
            background:#0d6efd;
            color:white;
            border-color:#0d6efd;
        }
        .time-btn.disabled-slot {
            background:#dddddd;
            border-color:#bbbbbb;
            color:#777;
            cursor:not-allowed;
            pointer-events:none;
        }

        .seat-btn {
            border:2px solid #4b1f0e;
            border-radius:20px;
            margin:4px;
            padding:8px 14px;
            min-width:75px;
            background:white;
            color:#4b1f0e;
            font-weight:600;
            transition:.2s;
        }
        .seat-btn.active-seat {
            background:#4b1f0e;
            color:white;
        }

        .btn-brown {
            background:#4b1f0e; color:white;
            padding:10px 30px;
            border-radius:30px;
            font-weight:600;
        }
        .btn-brown:disabled { opacity:0.6; }
    </style>
</head>
<body>

<%@ include file="../layouts/navbar.jsp" %>

<div class="wrapper">
    <div class="box">

        <h3 class="fw-bold text-center mb-3">Change Your Schedule</h3>

        <p class="text-center"><b>Room:</b> <%= roomNumber %></p>
        <p class="text-center"><b>Old Date:</b> <%= oldDate %></p>
        <p class="text-center"><b>Old Time:</b> <%= oldStart %> - <%= oldEnd %></p>
        <p class="text-center"><b>Duration:</b> <%= duration %> hour(s)</p>

        <hr>

        <!-- DATE -->
        <div class="text-center mb-4">
            <label class="fw-semibold">Pick New Date:</label>
            <input type="date" id="newDate"
                   class="form-control"
                   value="<%= oldDate %>"
                   style="max-width:260px; margin:auto;">
        </div>

        <!-- TIME SLOT -->
        <h5 class="fw-bold text-center mb-2">Pick New Time Slots</h5>
        <p class="text-center text-muted">You must choose exactly <b><%= duration %></b> slots.</p>

        <%
            String[] slots = {
                "00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00",
                "04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00",
                "08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00",
                "12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00",
                "16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00",
                "20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"
            };
        %>

        <div class="text-center mb-4">
            <%
                for (int i = 0; i < slots.length; i++) {
                    boolean disabled = bookedHour[i]; // i = jam mulai
                    String cls = "time-btn" + (disabled ? " disabled-slot" : "");
            %>
                <button type="button" class="<%= cls %>"><%= slots[i] %></button>
            <% } %>
        </div>

        <!-- SEAT -->
        <h5 class="fw-bold text-center">Pick Seat (Same Room Type)</h5>
        <div class="text-center mb-3">
            <% for (Map<String,Object> seat : seats) {
                int sid = (Integer) seat.get("id");
                String sname = (String) seat.get("room_number");
                String cl = (sid == currentRoomId) ? "seat-btn active-seat" : "seat-btn";
            %>
                <button type="button" class="<%= cl %>" data-seat="<%= sid %>"><%= sname %></button>
            <% } %>
        </div>

        <!-- FORM -->
        <form method="post" id="updateForm" class="mt-3 text-end">
            <input type="hidden" name="id" value="<%= bookingId %>">
            <input type="hidden" name="new_date" id="sendDate">
            <input type="hidden" name="new_room_id" id="sendSeatId" value="<%= currentRoomId %>">
            <input type="hidden" name="times" id="selectedTimes">

            <button type="submit" id="confirmBtn" class="btn-brown" disabled>
                Confirm Change →
            </button>
        </form>

    </div>
</div>

<script>
    const maxSlots    = <%= duration %>;
    const chosen      = new Set();
    const timeBtns    = document.querySelectorAll(".time-btn");
    const seatBtns    = document.querySelectorAll(".seat-btn");
    const sendSeat    = document.getElementById("sendSeatId");
    const confirmBtn  = document.getElementById("confirmBtn");
    const selectedInp = document.getElementById("selectedTimes");

    // TIME SLOT SELECT
    timeBtns.forEach(btn => {
        btn.onclick = () => {
            if (btn.classList.contains("disabled-slot")) {
                return;
            }
            const label = btn.textContent.trim();
            if (btn.classList.contains("active")) {
                btn.classList.remove("active");
                chosen.delete(label);
            } else {
                if (chosen.size >= maxSlots) {
                    alert("You must choose exactly " + maxSlots + " slots.");
                    return;
                }
                btn.classList.add("active");
                chosen.add(label);
            }
            selectedInp.value = Array.from(chosen).join(",");
            confirmBtn.disabled = (chosen.size !== maxSlots);
        };
    });

    // SEAT SELECT
    seatBtns.forEach(btn => {
        btn.onclick = () => {
            seatBtns.forEach(b => b.classList.remove("active-seat"));
            btn.classList.add("active-seat");
            sendSeat.value = btn.dataset.seat;
        };
    });

    // SUBMIT
    document.getElementById("updateForm").onsubmit = e => {
        const d = document.getElementById("newDate").value;
        if (!d) {
            alert("Please choose a date.");
            e.preventDefault();
            return;
        }
        if (chosen.size !== maxSlots) {
            alert("Please choose exactly " + maxSlots + " slots.");
            e.preventDefault();
            return;
        }
        document.getElementById("sendDate").value = d;
    };
</script>

</body>
</html>
