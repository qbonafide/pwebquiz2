<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ITStudy</title>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

        * {
            font-family: 'Poppins', sans-serif !important;
        }

        body {
            background-color: #faf8f6;
            color: #4b1f0e;
        }

        .map-section {
            padding-top: 100px; 
            padding-bottom: 70px; 
            
            display: flex;
            align-items: flex-start; 
            justify-content: center;
            gap: 70px;
            flex-wrap: wrap;
        }

        .map-text {
            max-width: 420px;
            text-align: left;
            margin-top: 20px; 
        }

        .map-text h1 {
            font-size: 60px;
            font-weight: 800;
            color: #4b1f0e;
            margin-bottom: 8px;
        }

        .map-text hr {
            border: 2px solid #4b1f0e;
            width: 60px;
            margin: 10px 0 20px;
        }

        .map-text p {
            margin: 6px 0;
            font-weight: 600;
            color: #7b4a2a;
            line-height: 1.6;
            font-size: 17px;
        }

        .btn-direction {
            display: inline-block;
            background-color: #4b1f0e;
            color: #fff;
            font-weight: 600;
            border: none;
            padding: 14px 40px;
            border-radius: 50px;
            margin-top: 25px;
            text-decoration: none;
            transition: 0.3s ease;
            font-size: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .btn-direction:hover {
            background-color: #3a2117;
            text-decoration: none;
            color: #fff;
            transform: scale(1.05);
        }

        iframe {
            border: none;
            border-radius: 20px;
            width: 600px;
            height: 400px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        @media (max-width: 992px) {
            .map-section {
                flex-direction: column;
                text-align: center;
                gap: 40px;
                padding-top: 70px; 
            }

            .map-text {
                text-align: center;
                margin-top: 0; 
            }

            .map-text h1 {
                font-size: 48px;
            }

            iframe {
                width: 100%;
                height: 350px;
            }
        }
    </style>

</head>
<body>

<jsp:include page="layouts/navbar.jsp" />

<div class="container map-section">
    <div class="map-text">
        <h1>ITStudy</h1>
        <hr>
        <p>Teknik Kimia Street</p>
        <p>Teknik Informatika Department</p>
        <p>Institut Teknologi Sepuluh Nopember</p>
        <p>Sukolilo</p>
        <p>Surabaya</p>

        <a href="https://www.google.com/maps/dir/?api=1&destination=-7.282801,112.794243"
           target="_blank"
           class="btn-direction">
            Get Direction
        </a>
    </div>

    <iframe
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3958.3276592173123!2d112.79329557496422!3d-7.282536292733045!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2dd7fb0b4b10d10f%3A0x1bb5442b9dc66f7a!2sDepartemen%20Teknik%20Informatika%20ITS!5e0!3m2!1sid!2sid!4v1739922936439!5m2!1sid!2sid"
            allowfullscreen=""
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade">
    </iframe>

</div>
</body>
</html>