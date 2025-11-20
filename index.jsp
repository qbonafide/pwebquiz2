<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>ITStudy - Home</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        * {
            font-family: 'Poppins', sans-serif !important;
        }

        body {
            background-color: #fff8f3 !important;
        }

        section {
            background-color: #fff8f3 !important;
        }

        .hero-section {
            background-image: url("img/landing-page/building.png");
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            padding-top: 140px;
            padding-bottom: 140px;
            background-color: #fff8f3 !important;
        }

        .hero-title {
            color: #4b1f0e;
            font-size: 3.5rem;
            line-height: 1.2;
        }

        .hero-subtitle {
            color: #5f5048;
            font-size: 1.2rem;
            max-width: 420px;
        }

        .feature-card {
            background-color: #fdf6f2;
            padding: 25px;
            border-radius: 20px;
            text-align: center;
            height: 100%;
            border: 1px solid #e6d8cf;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }

        .feature-img-wrapper {
            overflow: hidden;
            border-radius: 10px;
        }

        .feature-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            transition: transform 0.4s ease;
        }

        .feature-card:hover .feature-img {
            transform: scale(1.1); /* zoom-in tanpa keluar frame */
        }

        .cta-section {
            background-color: #f6e9df !important;
            border-radius: 18px;
            padding: 50px;
        }

        .cta-title {
            color: #4b1f0e;
            font-weight: 700;
        }

        .btn-book {
            background-color: #4b1f0e !important;
            color: #fff !important;
            padding: 10px 25px;
            border-radius: 25px;
        }

        .hero-desc {
            margin-top: 15px;        
            font-size: 1.2rem;
            line-height: 1.6;
            max-width: 360px;        
            margin-left: auto;       
        }

        html, body {
            overflow-x: hidden !important;
        }

        .hero-section {
            max-width: 100vw !important;
            overflow-x: hidden !important;
        }

        .hero-section .row {
            margin-left: 0 !important;
            margin-right: 0 !important;
        }

    </style>
</head>

<body>

<%@ include file="/layouts/navbar.jsp" %>

<div class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6"></div> <!-- kolom kosong untuk gambar di kiri -->

            <div class="col-md-6 text-end">
                <h1 class="fw-bold hero-title">
                    Your Productive<br>
                    Space, Anytime<br>
                    You Need
                </h1>

                <p class="hero-subtitle hero-desc">
                    Find, book, and focus — all in one platform for modern learners.
                </p>
            </div>
        </div>
    </div>
</div>

<section class="container mt-5">
    <h2 class="fw-bold text-center mb-4 section-title">Why Choose ITStudy?</h2>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-flexiblehour.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Flexible Hourly Booking</h5>
                <p>Book your study space for exactly how long you need.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-comfortmeets.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Comfort Meets Productivity</h5>
                <p>Designed for focus — private booths or group tables ready for you.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-easyonline.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Easy Online Reservation</h5>
                <p>Book anytime, anywhere, directly through our website.</p>
            </div>
        </div>
    </div>

    <div class="row g-4 mt-3">

        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-groupsolooption.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Group & Solo Options</h5>
                <p>From quiet zones to collaborative rooms — ITStudy fits your style.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-affordable.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Affordable for Students</h5>
                <p>Transparent pricing with student-friendly rates.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="feature-card">
                <img src="img/landing-page/grid-facilities.jpg" class="feature-img mb-3">
                <h5 class="fw-bold">Facilities That Keep You Going</h5>
                <p>Wi-Fi, charging ports, and coffee corner — everything you need.</p>
            </div>
        </div>

    </div>
</section>

<div class="container my-5">
    <div class="cta-section">
        <div class="row align-items-center">

            <div class="col-md-6">
                <h2 class="fw-bold cta-title">Ready to get things done?</h2>
                <p>Find your perfect spot today at ITStudy</p>
                <a href="booking.jsp" class="btn btn-book mt-3">Book Now</a>
            </div>

            <div class="col-md-6 text-center">
                <img src="img/landing-page/read-book.png" 
                     class="img-fluid" style="max-width: 400px;">
            </div>

        </div>
    </div>
</div>

</body>
</html>
