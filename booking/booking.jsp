<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking – ITStudy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background:#f7f0e8;
            font-family: 'Poppins', sans-serif;
            padding-top: 80px;
        }

        h2.title {
            font-size: 36px;
            font-weight: 700;
            color: #4b1f0e;
            text-align: center;
            margin-bottom: 40px;
        }

        .card-wrapper {
            background: white;
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transition: .25s;
        }

        .card-wrapper:hover {
            transform: translateY(-6px);
        }

        .card-wrapper img {
            width: 100%;
            height: 240px;
            object-fit: cover;
        }

        .card-body h5 {
            font-weight: 700;
            color: #3b1c0d;
        }

        .card-body p {
            color: #6b4c3b;
        }

        .btn-book {
            width: 100%;
            background: #4b1f0e;
            color: white;
            border-radius: 30px;
            padding: 10px 0;
            font-weight: 600;
            border: none;
            transition: .2s;
        }

        .btn-book:hover {
            background: #2c1107;
        }
    </style>
</head>

<body>

<%@ include file="../layouts/navbar.jsp" %>

<div class="container">

    <h2 class="title">Booking</h2>

    <div class="row justify-content-center g-4">

        <!-- INDIVIDUAL -->
        <div class="col-md-4">
            <div class="card-wrapper">
                <img src="<%= ctx %>/img/booking/individual-desk.jpg">
                <div class="card-body p-4">
                    <h5>Individual Desk</h5>
                    <p>Perfect for focused study</p>

                    <a href="<%= ctx %>/booking/individual">
                        <button class="btn-book mt-2">Book Now</button>
                    </a>
                </div>
            </div>
        </div>

        <!-- GROUP -->
        <div class="col-md-4">
            <div class="card-wrapper">
                <img src="<%= ctx %>/img/booking/group-desk.jpg">
                <div class="card-body p-4">
                    <h5>Group Desk</h5>
                    <p>For teams and discussions</p>

                    <a href="<%= ctx %>/booking/group">
                        <button class="btn-book mt-2">Book Now</button>
                    </a>
                </div>
            </div>
        </div>

        <!-- VIP -->
        <div class="col-md-4">
            <div class="card-wrapper">
                <img src="<%= ctx %>/img/booking/vip-room.jpg">
                <div class="card-body p-4">
                    <h5>VIP Room</h5>
                    <p>Private and premium space</p>

                    <a href="<%= ctx %>/booking/vip">
                        <button class="btn-book mt-2">Book Now</button>
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
