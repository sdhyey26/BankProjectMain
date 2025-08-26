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

        .header {
            margin-left: 220px;
            background-color: #ffffff;
            padding: 15px 30px;
            border-bottom: 1px solid #ddd;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .content {
            margin-left: 220px;
            padding: 30px;
            flex: 1;
        }

        .dashboard-title {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 2rem;
        }

        .card-container {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .card {
            background-color: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            flex: 1;
            min-width: 250px;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card h3 {
            margin-top: 0;
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .card p {
            margin: 0;
            font-size: 1rem;
            color: #333;
        }

        .card-blue {
            border-left: 5px solid #3498db;
        }

        .card-green {
            border-left: 5px solid #2ecc71;
        }

        .card-purple {
            border-left: 5px solid #9b59b6;
        }

        .greeting {
            font-size: 1.1rem;
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Bank Panel</h2>
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

<div class="header">
    <span class="greeting">Welcome, <%= user.getUsername() %>!</span>
</div>

<div class="content">
    <div class="dashboard-title">Customer Dashboard</div>

    <div class="card-container">
        <% 
            if (accounts != null) {
                for (Account acc : accounts) {
        %>
        <div class="card card-blue">
            <h3><%= acc.getAccountType() %> Account</h3>
            <p><strong>Account No: <%= acc.getAccountNumber() %></strong></p>
            <p>Balance: ₹<%= acc.getBalance() %></p>
        </div>
        <%
                }
            }
        %>

        <div class="card card-purple">
            <h3>Recent Transaction</h3>
            <p><%= lastTxn != null ? lastTxn : "No transactions yet." %></p>
        </div>
    </div>
</div>

</body>
</html>
