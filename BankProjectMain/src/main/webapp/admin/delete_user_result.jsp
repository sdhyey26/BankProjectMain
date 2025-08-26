<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");

    session.removeAttribute("message");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete User Result</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            display: flex;
        }

        .sidebar {
            width: 220px;
            background-color: #2c3e50;
            color: white;
            height: 100vh;
            position: fixed;
            padding-top: 30px;
        }

        .sidebar h2 {
            text-align: center;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar ul li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .sidebar ul li:hover, .sidebar ul li.active {
            background-color: #34495e;
        }

        .container {
            margin-left: 220px;
            padding: 60px 30px;
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .message-box {
            background: white;
            border-radius: 8px;
            padding: 40px;
            box-shadow: 0 0 10px rgba(0,0,0,0.15);
            text-align: center;
            max-width: 600px;
        }

        .success {
            color: #27ae60;
            font-size: 1.3rem;
            margin-bottom: 20px;
        }

        .error {
            color: #e74c3c;
            font-size: 1.3rem;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 20px;
            background-color: #3498db;
            border: none;
            color: white;
            font-size: 1rem;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <ul>
        <li onclick="location.href='AdminDashboardServlet'">Dashboard</li>
        <li class="active" onclick="location.href='ManageUsersServlet'">Manage Users</li>
        <li onclick="location.href='ManageAccountsServlet'">Manage Accounts</li>
        <li onclick="location.href='AdminTransactionServlet'">View Transactions</li>
        <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
        <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
        
        <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="container">
    <div class="message-box">
        <% if (message != null) { %>
            <div class="success"><%= message %></div>
        <% } else if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>

        <form action="../ManageUsersServlet" method="get">
            <button type="submit" class="btn">Back to User List</button>
        </form>
    </div>
</div>

</body>
</html>
