<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tss.model.Account" %>
<%@ page import="com.tss.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null || !"Customer".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
    String lastTxn = (String) request.getAttribute("lastTxn");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f5f7fa;
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 220px;
            background-color: #2c3e50;
            color: #fff;
            padding-top: 30px;
            position: fixed;
            height: 100vh;
        }
        .sidebar h2 {
            text-align: center;
            font-size: 1.5rem;
            margin-bottom: 20px;
            color : white
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
        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #34495e;
        }

        .content {
            margin-left: 220px;
            padding: 40px;
            flex: 1;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        .dashboard-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: #2c3e50;
        }
        .greeting {
            font-size: 1.1rem;
            font-weight: 500;
            color: #34495e;
        }

        .card-container {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            margin-bottom: 35px;
        }
        .card {
            background-color: #fff;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            flex: 1;
            min-width: 280px;
            transition: transform 0.3s;
        }
        .card:hover { transform: translateY(-5px); }
        .card h3 {
            margin-top: 0;
            font-size: 1.3rem;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        .card p {
            margin: 0 0 8px;
            font-size: 1rem;
            color: #333;
        }
        .card-blue { border-left: 5px solid #3498db; }
        .card-green { border-left: 5px solid #2ecc71; }
        .card-purple { border-left: 5px solid #9b59b6; }

        .quick-actions {
            margin-bottom: 35px;
            padding: 25px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .quick-actions h3 {
            margin-bottom: 20px;
            font-size: 1.4rem;
            color: #2c3e50;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .action-buttons button {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            color: #fff;
        }
        .btn-blue { background-color: #3498db; }
        .btn-blue:hover { background-color: #2980b9; }
        .btn-green { background-color: #2ecc71; }
        .btn-green:hover { background-color: #27ae60; }
        .btn-purple { background-color: #9b59b6; }
        .btn-purple:hover { background-color: #8e44ad; }

        .safety-tips {
            padding: 25px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .safety-tips h3 {
            margin-bottom: 15px;
            font-size: 1.4rem;
            color: #2c3e50;
        }
        .safety-tips ul {
            padding-left: 20px;
            color: #555;
            line-height: 1.7;
        }
        .safety-tips ul li {
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Customer Panel</h2>
    <ul>
        <li class="active">Dashboard</li>
        <li onclick="location.href='AccountInfoServlet'">Account Info</li>
        <li onclick="location.href='TransferServlet'">Transfer Funds</li>
        <li onclick="location.href='PassbookServlet'">Passbook</li>
        <li onclick="location.href='CardApplicationServlet'">Apply Card</li>
        <li onclick="location.href='CardStatusServlet'">Card Status</li>
        <li onclick="location.href='logout.jsp'">Logout</li>
    </ul>
</div>

<div class="content">
    <div class="dashboard-header">
        <div class="dashboard-title">Customer Dashboard</div>
        <div class="greeting">Welcome, <%= user.getUsername() %>!</div>
    </div>

    <div class="card-container">
        <% if (accounts != null) {
                for (Account acc : accounts) { %>
        <div class="card card-blue">
            <h3><%= acc.getAccountType() %> Account</h3>
            <p><strong>Account No:</strong> <%= acc.getAccountNumber() %></p>
            <p><strong>Balance:</strong> ₹<%= acc.getBalance() %></p>
        </div>
        <% }} %>

        <div class="card card-purple">
            <h3>Recent Transaction</h3>
            <p><%= lastTxn != null ? lastTxn : "No transactions yet." %></p>
        </div>
    </div>

    <div class="quick-actions">
        <h3>Quick Actions</h3>
        <div class="action-buttons">
            <button class="btn-blue" onclick="location.href='TransferServlet'">Transfer Funds</button>
            <button class="btn-green" onclick="location.href='PassbookServlet'">View Passbook</button>
            <button class="btn-purple" onclick="location.href='CardApplicationServlet'">Apply for Card</button>
        </div>
    </div>

    <div class="safety-tips">
        <h3>Safety Tips</h3>
        <ul>
            <li>Never share your OTP, PIN, or password with anyone.</li>
            <li>Beware of phishing emails and fake banking links.</li>
            <li>Always log out after using internet banking.</li>
            <li>Regularly check your transaction history.</li>
            <li>Enable SMS/Email alerts for transactions.</li>
        </ul>
    </div>
</div>

</body>
</html>
