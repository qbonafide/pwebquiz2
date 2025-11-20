<%@ include file="WEB-INF/db.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userName") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    String success = null;
    String error   = null;
%>

<%
Connection conn = (Connection) application.getAttribute("conn");
%>

<%

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm  = request.getParameter("confirm");

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirm == null || confirm.trim().isEmpty()) {

            error = "Semua kolom wajib diisi.";

        } else if (!password.equals(confirm)) {

            error = "Password dan konfirmasi password tidak cocok.";

        } else {

            PreparedStatement check = null;
            PreparedStatement insert = null;
            ResultSet rs = null;

            try {
                String checkSql = "SELECT id FROM users WHERE email = ?";
                check = conn.prepareStatement(checkSql);
                check.setString(1, email);
                rs = check.executeQuery();

                if (rs.next()) {
                    error = "Email sudah terdaftar.";
                } else {
                    String insertSql = "INSERT INTO users(name, email, password) VALUES (?, ?, ?)";
                    insert = conn.prepareStatement(insertSql);
                    insert.setString(1, name);
                    insert.setString(2, email);
                    insert.setString(3, password);
                    insert.executeUpdate();

                    success = "Registrasi berhasil. Silakan Login.";
                }

            } catch (Exception e) {
                e.printStackTrace();
                error = "Terjadi kesalahan database: " + e.getMessage();

            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                if (check != null) try { check.close(); } catch (Exception ignore) {}
                if (insert != null) try { insert.close(); } catch (Exception ignore) {}
               
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register — ITStudy</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body { background-color:#f6f0ea; font-family:"Poppins",sans-serif; color:#4b1f0e; }
        .register-wrapper { padding-top:120px; }
        .text-brown { color:#4b1f0e; }
        .border-brown { border-color:#4b1f0e; }

        .btn-brown {
            background-color:#592815 !important;
            color:#fff !important;
            border:none;
            border-radius:10px;
            font-weight:700;
            transition:0.3s;
            padding:10px 20px;
            box-shadow:0 4px 8px rgba(0,0,0,0.2);
            text-align:center;
        }
        .btn-brown:hover {
            background-color:#4b1f0e !important;
            color:#fff !important;
            box-shadow:0 6px 12px rgba(0,0,0,0.3);
        }

        .card {
            border:none;
            border-radius:20px;
            box-shadow:0 8px 20px rgba(0,0,0,0.1);
            background-color:#fffdfc;
        }

        .form-control {
            border-radius:8px;
            border-color:#e0d8d0;
        }
        .form-control:focus {
            box-shadow:0 0 0 0.25rem rgba(75,31,14,0.25);
            border-color:#4b1f0e;
        }
    </style>
</head>
<body>

<%@ include file="layouts/navbar.jsp" %>

<div class="container register-wrapper d-flex justify-content-center align-items-center">
    <div class="card shadow p-4 border-0" style="max-width:450px;width:100%;">

        <% if (success != null) { %>
        <div class="alert alert-success text-center rounded-pill py-2"><%= success %></div>
        <% } %>

        <% if (error != null) { %>
        <div class="alert alert-danger text-center rounded-pill py-2"><%= error %></div>
        <% } %>

        <h3 class="text-center text-brown mb-4 fw-bold">Create an ITStudy Account</h3>

        <form method="POST">
            <div class="mb-3">
                <label class="form-label text-brown">Full Name</label>
                <input type="text" name="name" class="form-control border-brown" required>
            </div>

            <div class="mb-3">
                <label class="form-label text-brown">Email</label>
                <input type="email" name="email" class="form-control border-brown" required>
            </div>

            <div class="mb-3">
                <label class="form-label text-brown">Password</label>
                <input type="password" name="password" class="form-control border-brown" required>
            </div>

            <div class="mb-3">
                <label class="form-label text-brown">Confirm Password</label>
                <input type="password" name="confirm" class="form-control border-brown" required>
            </div>

            <button type="submit" class="btn btn-brown w-100">Register</button>

            <p class="text-center mt-3">
                Already have an account?
                <a href="login.jsp" class="text-decoration-none text-brown fw-semibold">Login</a>
            </p>
        </form>
    </div>
</div>

</body>
</html>
