<%@ page import="java.sql.*" %>

<%
Connection existingConn = (Connection) application.getAttribute("conn");

if (existingConn == null) {
    try {
        String jdbcURL  = "jdbc:mysql://localhost:3306/itstudy_jsp?useSSL=false&serverTimezone=UTC";
        String dbUser   = "root";
        String dbPass   = "rootroot";

        Class.forName("com.mysql.cj.jdbc.Driver");
        existingConn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        application.setAttribute("conn", existingConn);

    } catch(Exception e) {
        out.println("Database connection error: " + e.getMessage());
    }
}
%>
