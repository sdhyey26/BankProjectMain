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
            padding: 30px;
            flex: 1;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        th, td {
            padding: 12px 16px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #3498db;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .btn {
            padding: 6px 12px;
            font-size: 0.85rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .edit-btn {
            background-color: #f39c12;
            color: white;
            margin-right: 5px;
        }

        .delete-btn {
            background-color: #c0392b;
            color: white;
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

	<%
    String message = (String) session.getAttribute("message");
    String error = (String) session.getAttribute("error");
    if (message != null || error != null) {
%>
    <div style="margin-bottom: 20px;">
        <% if (message != null) { %>
            <div style="padding: 10px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 4px;">
                <%= message %>
            </div>
        <% session.removeAttribute("message"); } %>
        
        <% if (error != null) { %>
            <div style="padding: 10px; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 4px;">
                <%= error %>
            </div>
        <% session.removeAttribute("error"); } %>
    </div>
<% } %>
    <h2>All Bank Accounts</h2>
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
                <form action="DeleteAccountServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this account?');">
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

</body>
</html>
