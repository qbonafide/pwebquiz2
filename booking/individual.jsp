<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Individual Desk – ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        body { background:#faf8f6; padding-top:100px; font-family:'Poppins'; }

        .text-brown { color:#4b1f0e; }

        .border-brown { border-color:#4b1f0e !important; }

        .seat-btn {
            border:2px solid #5c2e00;
            color:#5c2e00;
            background:#fff;
            border-radius:25px;
            margin:5px;
            padding:6px 20px;
            font-weight:600;
            transition:.2s;
        }
        .seat-btn:hover { background:#5c2e00; color:white; }
        .seat-btn.active { background:#0d6efd; border-color:#0d6efd; color:white; }

        .btn-brown {
            background:#4b1f0e !important;
            color:white !important;
            border-radius:25px;
            padding:10px 30px;
            font-weight:600;
            border:none;
            transition:.2s;
        }
        .btn-brown:hover { background:#6b2f1b !important; }
        .btn-brown:disabled { opacity:0.5; cursor:not-allowed; }

    </style>
</head>

<body>

<%@ include file="../layouts/navbar.jsp" %>

<div class="container my-5">

    <div class="card shadow-sm border-0 p-4" style="background:#faf8f6;">

        <div class="mb-3">
            <a href="<%= ctx %>/booking" class="text-decoration-none text-brown fw-semibold">
                <i class="bi bi-arrow-left"></i> Prev
            </a>
        </div>

        <div class="row align-items-center">

            <div class="col-md-4 text-center">
                <img src="<%= ctx %>/img/booking/individual-desk.jpg"
                     class="img-fluid rounded shadow-sm mb-3"
                     style="max-height:400px;object-fit:cover;">
                <h6 class="fw-semibold text-brown">Individual Desk</h6>
                <p class="fw-bold text-brown mb-0">Rp15.000 / hour</p>
            </div>

            <div class="col-md-8">

                <div class="bg-white p-4 rounded shadow-sm border border-brown text-center">

                    <div class="text-center mb-4">
                        <label class="form-label fw-semibold text-brown">
                            <i class="bi bi-calendar-week"></i> Choose Date
                        </label>

                        <input type="date" id="bookingDate"
                               class="form-control text-center border-2 border-brown mx-auto"
                               style="max-width:250px;border-radius:25px;cursor:pointer;">
                    </div>

                    <div class="text-center" id="seatGrid">
                        <% for (int i=1; i<=30; i++) { %>
                            <button type="button" class="seat-btn">A<%=i%></button>
                            <% if (i % 7 == 0) { %><br><% } %>
                        <% } %>
                    </div>
                </div>

                <form action="<%= ctx %>/booking/time" method="post" class="text-end mt-3">
                    <input type="hidden" name="room_type" value="Individual Desk">
                    <input type="hidden" name="desk_number" id="desk_number">
                    <input type="hidden" name="date" id="selected_date">
                    <input type="hidden" name="price" value="15000">

                    <button id="nextButton" type="submit" class="btn btn-brown" disabled>
                        Next →
                    </button>
                </form>

            </div>
        </div>

    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const dateInput = document.getElementById("bookingDate");
    const selectedDateInput = document.getElementById("selected_date");
    const seatButtons = document.querySelectorAll(".seat-btn");
    const deskInput = document.getElementById("desk_number");
    const nextButton = document.getElementById("nextButton");

    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, "0");
    const dd = String(today.getDate()).padStart(2, "0");
    const todayStr = `${yyyy}-${mm}-${dd}`;

    dateInput.value = todayStr;
    selectedDateInput.value = todayStr;

    dateInput.addEventListener("change", function () {
        selectedDateInput.value = this.value;
        checkNextAvailability();
    });

    seatButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            seatButtons.forEach(b => b.classList.remove("active"));
            this.classList.add("active");
            deskInput.value = this.textContent.trim();
            checkNextAvailability();
        });
    });

    function checkNextAvailability() {
        nextButton.disabled = !(deskInput.value && selectedDateInput.value);
    }

});
</script>

</body>
</html>
