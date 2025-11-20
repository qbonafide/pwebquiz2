<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../WEB-INF/db.jsp" %>

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
    String changeId   = request.getParameter("change_id"); // NULL jika booking biasa

    if (roomType == null || deskNumber == null || date == null || priceStr == null) {
        response.sendRedirect(ctx + "/booking");
        return;
    }

    int roomId = -1;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        ps = existingConn.prepareStatement(
            "SELECT id FROM rooms WHERE room_number = ? LIMIT 1"
        );
        ps.setString(1, deskNumber);
        rs = ps.executeQuery();
        if (rs.next()) {
            roomId = rs.getInt("id");
        }
    } catch (Exception e) {
        out.println("ERROR room: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ex) {}
        try { if (ps != null) ps.close(); } catch (Exception ex) {}
    }

    boolean[] bookedHour = new boolean[24];
    if (roomId != -1) {
        PreparedStatement ps2 = null;
        ResultSet rs2 = null;
        try {
            ps2 = existingConn.prepareStatement(
                "SELECT start_time, end_time FROM bookings " +
                "WHERE room_id = ? AND date = ? AND status <> 'cancelled'"
            );
            ps2.setInt(1, roomId);
            ps2.setString(2, date);
            rs2 = ps2.executeQuery();
            while (rs2.next()) {
                String st = rs2.getString("start_time"); // HH:MM:SS
                String et = rs2.getString("end_time");
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
            out.println("ERROR availability: " + e.getMessage());
        } finally {
            try { if (rs2 != null) rs2.close(); } catch (Exception ex) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception ex) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Choose Time – ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#fff8f3; padding-top:90px; font-family:Poppins; }
        .wrapper { max-width:1100px; margin:auto; padding:25px; }
        .time-btn {
            border:2px solid #4b1f0e;
            border-radius:25px;
            padding:10px 18px;
            margin:5px;
            background:white;
            color:#4b1f0e;
            font-weight:600;
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
        .btn-brown {
            background:#4b1f0e;
            color:white;
            border-radius:25px;
            padding:10px 28px;
            font-weight:600;
        }
        .btn-brown:disabled { opacity:.5; }
    </style>
</head>

<body>

<%@ include file="../layouts/navbar.jsp" %>

<div class="wrapper">

    <h4 class="fw-bold text-center">Choose Time (<%= date %>)</h4>

    <div class="text-center my-4">
        <img src="<%= ctx %>/img/booking/<%= roomType.startsWith("Group") ? "group-desk.jpg" : (roomType.startsWith("VIP") ? "vip-room.jpg" : "individual-desk.jpg") %>"
             class="img-fluid rounded shadow" style="max-height:300px;object-fit:cover;">
        <h5 class="mt-3"><%= roomType %></h5>
        <p class="fw-bold">Desk: <%= deskNumber %></p>
        <p>Rp<%= priceStr %> / hour</p>
    </div>

    <div class="bg-white shadow p-4 rounded">
        <div class="text-center">
            <%
                String[] slots = {
                    "00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00",
                    "04:00-05:00","05:00-06:00","06:00-07:00","07:00-08:00",
                    "08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00",
                    "12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00",
                    "16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00",
                    "20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00"
                };
                for (int i = 0; i < slots.length; i++) {
                    boolean disabled = bookedHour[i];
                    String cls = "time-btn" + (disabled ? " disabled-slot" : "");
            %>
                <button type="button" class="<%= cls %>"><%= slots[i] %></button>
            <% } %>
        </div>
    </div>

    <form action="<%= ctx %>/booking/payment.jsp" method="post" class="mt-4 text-end">
        <input type="hidden" name="room_type" value="<%= roomType %>">
        <input type="hidden" name="desk_number" value="<%= deskNumber %>">
        <input type="hidden" name="date" value="<%= date %>">
        <input type="hidden" name="price" value="<%= priceStr %>">
        <input type="hidden" name="change_id" value="<%= changeId == null ? "" : changeId %>">
        <input type="hidden" name="times" id="selectedTimes">

        <button id="nextBtn" class="btn-brown" disabled>Next →</button>
    </form>

</div>

<script>
    const timeButtons   = document.querySelectorAll('.time-btn');
    const selectedTimes = document.getElementById('selectedTimes');
    const nextBtn       = document.getElementById('nextBtn');

    const chosen = new Set();

    timeButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            if (btn.classList.contains("disabled-slot")) return;

            const t = btn.textContent.trim();
            if (chosen.has(t)) {
                chosen.delete(t);
                btn.classList.remove("active");
            } else {
                chosen.add(t);
                btn.classList.add("active");
            }
            selectedTimes.value = Array.from(chosen).join(",");
            nextBtn.disabled = chosen.size === 0;
        });
    });
</script>

</body>
</html>
