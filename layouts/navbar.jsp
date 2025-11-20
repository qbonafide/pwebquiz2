<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    * { font-family: 'Poppins', sans-serif !important; }

    nav.navbar {
        background-color:#f6f0ea !important;
        box-shadow:0 2px 4px rgba(0,0,0,0.05);
        padding-top: 10px;
        padding-bottom: 10px;
    }

    .nav-link {
        color:#4b1f0e !important;
        font-weight:600;
        margin-right:15px;
    }

    .nav-link:hover {
        color:#a0522d !important;
        border-bottom:3px solid #a0522d;
        padding-bottom:2px;
    }

    .profile-icon {
        color:white;
        background-color:#4b1f0e;
        border-radius:50%;
        width:38px;
        height:38px;
        display:flex;
        justify-content:center;
        align-items:center;
        font-size:18px;
        margin-right:8px;
    }

    .btn-auth {
        padding: 6px 18px;
        border-radius: 20px;
        background-color: #4b1f0e;
        color: #fff !important;
        font-weight: 600;
        margin-left: 10px;
        text-decoration: none;
        transition: 0.3s;
        border: none;
    }

    .btn-auth:hover {
        background-color: #6b2f1b;
        color: #fff !important;
    }

    .dropdown-menu-custom {
        position: absolute;
        top: 70px;
        right: 20px;
        width: 260px;
        background: white;
        padding: 15px;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        z-index: 2000;
        animation: fadeIn 0.2s ease-out;
    }

    .d-none { display: none !important; }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-5px); }
        to   { opacity: 1; transform: translateY(0); }
    }
</style>

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container-fluid">

        <a class="navbar-brand fw-bold" href="/kuis2/" style="color:#4a2c2a; font-size:22px;">
            ITStudy
        </a>

        <button class="navbar-toggler border-0" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-between" id="navMenu">

            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="/kuis2/">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="/kuis2/location">Location</a></li>
                <li class="nav-item"><a class="nav-link" href="/kuis2/about">About Us</a></li>

                <li class="nav-item">
                <%
                    String logged = (String) session.getAttribute("userName");

                    if (logged == null) {
                %>
                        <a class="nav-link" href="/kuis2/login">Booking</a>
                <%
                    } else {
                %>
                        <a class="nav-link" href="/kuis2/booking/booking.jsp">Booking</a>
                <%
                    }
                %>
            </li>


                <li class="nav-item"><a class="nav-link" href="/kuis2/reservation">Reservation</a></li>
            </ul>

            <div class="d-flex align-items-center">

                <% if (session.getAttribute("userName") == null) { %>

                    <a href="/kuis2/login" class="btn-auth">Login</a>
                    <a href="/kuis2/register" class="btn-auth">Register</a>

                <% } else { %>

                <div id="profileToggle" style="cursor:pointer;" class="d-flex align-items-center">
                    <div class="profile-icon">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <span class="fw-semibold" style="color:#4b1f0e;">
                        <%= session.getAttribute("userName") %>
                    </span>
                </div>

                <div id="profileDropdown" class="dropdown-menu-custom d-none">
                    <p class="fw-bold mb-1">Logged in as:</p>
                    <small class="text-muted"><%= session.getAttribute("userEmail") %></small>

                    <form action="/kuis2/logout.jsp" method="post" class="mt-3">
                        <button class="btn btn-danger w-100 rounded-pill">Logout</button>
                    </form>
                </div>

                <% } %>

            </div>
        </div>
    </div>
</nav>

<script>
    const toggle = document.getElementById("profileToggle");
    const menu   = document.getElementById("profileDropdown");

    if (toggle) {
        toggle.addEventListener("click", () => {
            menu.classList.toggle("d-none");
        });
    }

    document.addEventListener("click", (e) => {
        if (toggle && !toggle.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.add("d-none");
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
