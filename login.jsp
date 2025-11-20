<%@ include file="WEB-INF/db.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userId") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String error = null;

%>


<%
    Connection conn = (Connection) application.getAttribute("conn");
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            error = "Email dan password wajib diisi.";
        } else {

            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                String sql = "SELECT id, name, email, password FROM users WHERE email=?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                rs = ps.executeQuery();

                if (!rs.next()) {
                    error = "Akun tidak ditemukan.";
                } else if (!password.equals(rs.getString("password"))) {
                    error = "Password salah.";
                } else {
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userEmail", rs.getString("email"));

                    response.sendRedirect("index.jsp");
                    return;
                }

            } catch (Exception e) {
                error = "Database error: " + e.getMessage();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login — ITStudy</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#f6f0ea; font-family:Poppins; color:#4b1f0e; }
        .login-wrapper { padding-top:120px; }
        .btn-brown {
            background:#592815 !important;
            color:white !important;
            border-radius:10px;
            font-weight:700;
            padding:10px 20px;
            transition:0.3s;
        }
        .btn-brown:hover { background:#4b1f0e !important; }
        .card {
            border:none;
            border-radius:20px;
            box-shadow:0 8px 20px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body>

<%@ include file="layouts/navbar.jsp" %>

<div class="container login-wrapper d-flex justify-content-center align-items-center">
    <div class="card p-4" style="max-width:450px;width:100%;">

        <% if (error != null) { %>
        <div class="alert alert-danger text-center rounded-pill py-2"><%= error %></div>
        <% } %>

        <h3 class="text-center fw-bold mb-4">Login to ITStudy</h3>

        <form method="POST">
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control border-brown" required>
            </div>

            <div class="mb-3">
                <label>Password</label>
                <input type="password" name="password" class="form-control border-brown" required>
            </div>

            <button type="submit" class="btn btn-brown w-100">Login</button>

            <p class="text-center mt-3">
                Belum punya akun?
                <a href="register.jsp" class="fw-semibold" style="color:#4b1f0e;">Daftar</a>
            </p>
        </form>
    </div>
</div>

</body>
</html>
