<%@ page import="com.tss.model.Account" %>
<%
    Account acc = (Account) request.getAttribute("account");
    if (acc == null) {
        response.sendRedirect("ManageAccountsServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Account</title>
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

        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #34495e;
        }

        .container {
            margin-left: 220px;
            padding: 60px 30px;
            flex: 1;
        }

        .card {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.15);
            text-align: center;
        }

        h2 {
            color: #e74c3c;
            margin-bottom: 20px;
        }

        p {
            font-size: 1.1rem;
            margin-bottom: 20px;
        }

        .info {
            font-weight: bold;
            margin-bottom: 20px;
        }

        .btn {
            padding: 10px 20px;
            font-size: 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 10px;
        }

        .btn-confirm {
            background-color: #e74c3c;
            color: white;
        }

        .btn-cancel {
            background-color: #3498db;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <ul>
        <li onclick="location.href='AdminDashboardServlet'">Dashboard</li>
        <li onclick="location.href='ManageUsersServlet'">Manage Users</li>
        <li class="active" onclick="location.href='ManageAccountsServlet'">Manage Accounts</li>
        <li onclick="location.href='AdminTransactionServlet'">View Transactions</li>
        <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
        <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
        
        <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="container">
    <div class="card">
        <h2>Confirm Delete</h2>
        <p>Are you sure you want to delete the following account?</p>
        <div class="info">
            Account Number: <%= acc.getAccountNumber() %><br>
            Type: <%= acc.getAccountType() %><br>
            Balance: ₹<%= String.format("%.2f", acc.getBalance()) %>
        </div>

        <form action="DeleteAccountServlet" method="post" style="display:inline;">
            <input type="hidden" name="accountNumber" value="<%= acc.getAccountNumber() %>">
            <button type="submit" class="btn btn-confirm">Yes, Delete</button>
        </form>

        <form action="ManageAccountsServlet" method="get" style="display:inline;">
            <button type="submit" class="btn btn-cancel">Cancel</button>
        </form>
    </div>
</div>

</body>
</html>
