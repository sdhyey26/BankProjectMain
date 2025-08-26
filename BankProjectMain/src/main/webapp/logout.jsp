<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tss.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String dashboardURL = "CustomerDashboardServlet";
    if ("Admin".equals(role)) {
        dashboardURL = "AdminDashboardServlet"; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout Confirmation</title>
    <style>
        body {
            background-color: #2d2f3a;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .confirmation-box {
            background-color: #1f2937;
            padding: 40px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }

        .confirmation-box h2 {
            margin-bottom: 30px;
            color: #fff;
        }

        .confirmation-box button {
            padding: 12px 24px;
            font-size: 16px;
            margin: 0 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .yes-btn {
            background-color: #e74c3c;
            color: white;
        }

        .yes-btn:hover {
            background-color: #c0392b;
        }

        .no-btn {
            background-color: #2ecc71;
            color: white;
        }

        .no-btn:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
    <div class="confirmation-box">
        <h2>Are you sure you want to logout?</h2>
        <form method="post">
            <button type="submit" name="confirm" value="yes" class="yes-btn">Yes</button>
            <button type="submit" name="confirm" value="no" class="no-btn">No</button>
        </form>
    </div>
</body>
</html>

<%
    if ("yes".equals(request.getParameter("confirm"))) {
        session.invalidate();
        response.sendRedirect("login.jsp");
    } else if ("no".equals(request.getParameter("confirm"))) {
        response.sendRedirect(dashboardURL);
    }
%>
