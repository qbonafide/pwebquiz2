<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    String userName  = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");

    if (userName == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile — ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            background-color:#fff8f3;
            font-family:"Poppins",sans-serif;
            padding-top:90px;
        }

        .profile-card {
            max-width: 500px;
            margin: 40px auto;
            background-color: #fff8f3;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
        }

        .profile-icon-big {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color:#4b1f0e;
            display:flex;
            justify-content:center;
            align-items:center;
            color:#fff;
            font-size:32px;
            margin: 0 auto 15px auto;
        }

        .btn-logout {
            background-color:#dc3545;
            color:#fff;
            border:none;
            border-radius:50px;
            font-weight:600;
            padding:8px 20px;
        }

        .btn-logout:hover {
            background-color:#bb2d3b;
            color:#fff;
        }
    </style>
</head>
<body>

<%@ include file="layouts/navbar.jsp" %>

<div class="profile-card text-center">
    <div class="profile-icon-big">
        <i class="bi bi-person-fill"></i>
    </div>

    <h4 class="fw-bold mb-1"><%= userName %></h4>
    <p class="text-muted mb-3"><%= userEmail %></p>

    <hr>

    <p class="mb-3">You are logged in to <strong>ITStudy</strong>.</p>

    <form action="logout.jsp" method="post">
        <button type="submit" class="btn-logout">Logout</button>
    </form>
</div>

</body>
</html>
