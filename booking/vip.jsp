<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String ctx = request.getContextPath();
    String today = LocalDate.now().toString();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>VIP Room – ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            background:#fff8f3;
            padding-top:90px;
            font-family:'Poppins';
        }
        .page-box {
            background:white;
            padding:35px;
            border-radius:22px;
            box-shadow:0 5px 25px rgba(0,0,0,0.12);
            max-width:1100px;
            margin:auto;
        }
        .prev-link { color:#4b1f0e; font-weight:600; text-decoration:none; }
        .prev-link:hover { color:#6b2f1b; }
        .rounded-card { border:2px solid #4b1f0e; padding:28px; border-radius:25px; }
        .seat-btn {
            border:2px solid #4b1f0e;
            color:#4b1f0e;
            background:white;
            border-radius:25px;
            margin:6px;
            padding:10px 24px;
            font-weight:600;
            transition:.2s;
        }
        .seat-btn:hover,
        .seat-btn.active {
            background:#4b1f0e;
            color:white;
        }
        .btn-brown {
            background:#4b1f0e !important;
            color:#fff !important;
            border-radius:25px;
            padding:10px 28px;
            font-weight:600;
            border:none;
        }
        .btn-brown:disabled { opacity:0.6; }
        .text-brown { color:#4b1f0e; }
    </style>
</head>

<body>

<%@ include file="../layouts/navbar.jsp" %>

<div class="container my-4">

    <div class="page-box">

        <a href="<%= ctx %>/booking" class="prev-link d-inline-block mb-3">← Prev</a>

        <div class="row align-items-center">

            <div class="col-md-4 text-center">
                <img src="<%= ctx %>/img/booking/vip-room.jpg"
                     class="img-fluid rounded shadow mb-3"
                     style="max-height:400px;object-fit:cover;">
                <h5 class="fw-bold text-brown mt-2">VIP Room</h5>
                <p class="fw-bold text-brown">Rp50.000 / hour</p>
            </div>

            <div class="col-md-8">
                <div class="rounded-card text-center">

                    <label class="fw-semibold text-brown mb-2">
                        <i class="bi bi-calendar-week"></i> Choose Date
                    </label>

                    <input id="dateInput" type="date"
                           class="form-control text-center mx-auto mb-4"
                           style="max-width:240px; border-radius:25px; border:2px solid #4b1f0e;">

                    <div class="text-center mt-2">
                        <button type="button" class="seat-btn" data-seat="M1">VIP 1</button>
                        <button type="button" class="seat-btn" data-seat="M2">VIP 2</button>
                        <button type="button" class="seat-btn" data-seat="M3">VIP 3</button>
                        <button type="button" class="seat-btn" data-seat="M4">VIP 4</button>
                        <button type="button" class="seat-btn" data-seat="M5">VIP 5</button>
                    </div>
                </div>

                <form action="<%= ctx %>/booking/time" method="post" class="text-end mt-3">
                    <input type="hidden" name="room_type" value="VIP Room">
                    <input type="hidden" name="desk_number" id="desk_number">
                    <input type="hidden" name="date" id="selected_date">
                    <input type="hidden" name="price" value="50000">

                    <button id="nextBtn" type="submit" class="btn btn-brown" disabled>
                        Next →
                    </button>
                </form>

            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {

    let today = new Date();
    let yyyy = today.getFullYear();
    let mm = String(today.getMonth() + 1).padStart(2, '0');
    let dd = String(today.getDate()).padStart(2, '0');
    let todayStr = `${yyyy}-${mm}-${dd}`;

    const dateInput = document.getElementById("dateInput");
    const selectedDate = document.getElementById("selected_date");
    const deskInput = document.getElementById("desk_number");
    const nextBtn = document.getElementById("nextBtn");
    const seatBtns = document.querySelectorAll(".seat-btn");

    dateInput.value = todayStr;
    selectedDate.value = todayStr;

    dateInput.addEventListener("change", function() {
        selectedDate.value = this.value;
        checkNext();
    });

    seatBtns.forEach(btn => {
        btn.addEventListener("click", function() {
            seatBtns.forEach(b => b.classList.remove("active"));

            this.classList.add("active");

            deskInput.value = this.dataset.seat;

            checkNext();
        });
    });

    function checkNext() {
        nextBtn.disabled = !(deskInput.value && selectedDate.value);
    }
});
</script>

</body>
</html>
