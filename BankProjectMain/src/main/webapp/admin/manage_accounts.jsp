<%@ page import="java.util.*, com.tss.model.Account" %>
<%
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Accounts</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            display: flex;
        }

        .sidebar {
            width: 220px;
            background-color: #2c3e50;
            color: white;
            height: 100vh;
            position: fixed;
            padding-top: 30px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        }

        .sidebar h2 {
            text-align: center;
            font-size: 1.6rem;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar ul li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.3s, padding-left 0.3s;
        }

        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #34495e;
            padding-left: 25px;
        }

        .container {
            margin-left: 220px;
            padding: 40px;
            flex: 1;
        }

        .section {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 1.8rem;
            font-weight: 600;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        .alert {
            padding: 12px 18px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.95rem;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 14px 18px;
            text-align: center;
            font-size: 0.95rem;
        }

        th {
            background: #3498db;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover td {
            background-color: #eef6fd;
        }

        .btn {
            padding: 8px 14px;
            font-size: 0.85rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
            font-weight: 600;
        }

        .edit-btn {
            background-color: #f39c12;
            color: white;
            margin-right: 6px;
        }

        .edit-btn:hover {
            background-color: #d68910;
            transform: translateY(-2px);
        }

        .delete-btn {
            background-color: #c0392b;
            color: white;
        }

        .delete-btn:hover {
            background-color: #a93226;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <ul>
        <li onclick="location.href='AdminDashboardServlet'">Dashboard</li>
        <li onclick="location.href='ManageUsersServlet'">Manage Users</li>
        <li class="active">Manage Accounts</li>
        <li onclick="location.href='AdminTransactionServlet'">View Transactions</li>
        <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
        <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
        <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="container">
    <div class="section">
        <h2>All Bank Accounts</h2>

        <% 
            String message = (String) session.getAttribute("message");
            String error = (String) session.getAttribute("error");
            if (message != null) { %>
                <div class="alert alert-success"><%= message %></div>
        <% session.removeAttribute("message"); } 
           if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
        <% session.removeAttribute("error"); } %>

        <table>
            <tr>
                <th>Account Number</th>
                <th>Account Type</th>
                <th>Balance</th>
                <th>User ID</th>
                <th>Actions</th>
            </tr>
            <% if (accounts != null) {
                for (Account acc : accounts) {
            %>
            <tr>
                <td><%= acc.getAccountNumber() %></td>
                <td><%= acc.getAccountType() %></td>
                <td><%= String.format("%.2f", acc.getBalance()) %></td>
                <td><%= acc.getUserId() %></td>
                <td>
                    <form action="EditAccountServlet" method="get" style="display:inline;">
                        <input type="hidden" name="accountNumber" value="<%= acc.getAccountNumber() %>">
                        <button class="btn edit-btn" type="submit">Edit</button>
                    </form>
                    <form action="DeleteAccountServlet" method="post" style="display:inline;" 
                          onsubmit="return confirm('Are you sure you want to delete this account?');">
                        <input type="hidden" name="accountNumber" value="<%= acc.getAccountNumber() %>">
                        <button class="btn delete-btn" type="submit">Delete</button>
                    </form>
                </td>
            </tr>
            <% }} else { %>
            <tr><td colspan="5">No accounts found.</td></tr>
            <% } %>
        </table>
    </div>
</div>

</body>
</html>
