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
    <title>Group Desk – ITStudy</title>

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

        .prev-link {
            color:#4b1f0e;
            font-weight:600;
            text-decoration:none;
        }
        .prev-link:hover {
            color:#6b2f1b;
        }

        .rounded-card {
            border:2px solid #4b1f0e;
            padding:28px;
            border-radius:25px;
        }

        .seat-btn {
            border:2px solid #4b1f0e;
            color:#4b1f0e;
            background:white;
            border-radius:25px;
            margin:6px;
            padding:6px 22px;
            font-weight:600;
            transition:.2s;
        }
        .seat-btn:hover { background:#4b1f0e; color:white; }
        .seat-btn.active { background:#4b1f0e; color:white; }

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

        <a href="<%= ctx %>/booking" class="prev-link d-inline-block mb-3">
            ← Prev
        </a>

        <div class="row align-items-center">

            <div class="col-md-4 text-center">
                <img src="<%= ctx %>/img/booking/group-desk.jpg"
                     class="img-fluid rounded shadow mb-3"
                     style="max-height:400px;object-fit:cover;">
                <h5 class="fw-bold text-brown mt-2">Group Desk</h5>
                <p class="fw-bold text-brown">Rp35.000 / hour</p>
            </div>

            <div class="col-md-8">
                <div class="rounded-card text-center">

                    <label class="fw-semibold text-brown mb-2">
                        <i class="bi bi-calendar-week"></i> Choose Date
                    </label>

                    <input id="dateInput" type="date"
                           class="form-control text-center mx-auto mb-4"
                           style="max-width:240px; border-radius:25px; border:2px solid #4b1f0e;">

                    <div class="text-center" id="seatContainer">
                        <% for (int i=1; i<=12; i++) { %>
                            <button type="button" class="seat-btn" data-seat="B<%=i%>">B<%=i%></button>
                        <% } %>
                    </div>
                </div>

                <form action="<%= ctx %>/booking/time" method="post" class="text-end mt-3">
                    <input type="hidden" name="room_type" value="Group Desk">
                    <input type="hidden" name="desk_number" id="desk_number">
                    <input type="hidden" name="date" id="selected_date">
                    <input type="hidden" name="price" value="35000">

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

    dateInput.value = todayStr;
    selectedDate.value = todayStr;

    dateInput.addEventListener("change", function() {
        selectedDate.value = this.value;
        checkNext();
    });

    document.querySelectorAll(".seat-btn").forEach(btn => {
        btn.addEventListener("click", function() {
            document.querySelectorAll(".seat-btn").forEach(b => b.classList.remove("active"));
            this.classList.add("active");

            deskInput.value = this.dataset.seat;
            checkNext();
        });
    });

    function checkNext() {
        if (deskInput.value && selectedDate.value) {
            nextBtn.disabled = false;
        } else {
            nextBtn.disabled = true;
        }
    }
});
</script>

</body>
</html>
