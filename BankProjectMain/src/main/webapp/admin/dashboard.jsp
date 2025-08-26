<%@ page import="java.util.*, com.tss.model.CardApplication, com.tss.model.User, com.tss.model.Account" %>
<%
    List<CardApplication> pendingCards = (List<CardApplication>) request.getAttribute("pendingCards");
    List<User> users = (List<User>) request.getAttribute("users");
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
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
            padding: 30px;
            flex: 1;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 12px 16px;
            text-align: center;
        }

        th {
            background-color: #3498db;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .btn {
            padding: 6px 12px;
            font-size: 0.9rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .approve-btn {
            background-color: #27ae60;
            color: white;
        }

        .reject-btn {
            background-color: #e74c3c;
            color: white;
        }

        .section {
            margin-bottom: 50px;
        }

        .section h3 {
            margin-bottom: 10px;
            color: #333;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <ul>
        	<li class="active">Dashboard</li>
            <li onclick="location.href='ManageUsersServlet'">Manage Users</li>
            <li onclick="location.href='ManageAccountsServlet'">Manage Accounts</li>
            <li onclick="location.href='AdminTransactionServlet'">View Transactions</li>
            <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
            <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
            <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="container">
    <div class="section">
        <h2>Pending Card Applications</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Account</th>
                <th>Type</th>
                <th>Status</th>
                <th>Applied At</th>
                <th>Action</th>
            </tr>
            <%
                if (pendingCards != null && !pendingCards.isEmpty()) {
                    for (CardApplication app : pendingCards) {
            %>
            <tr>
                <td><%= app.getId() %></td>
                <td><%= app.getAccountNumber() %></td>
                <td><%= app.getCardType() %></td>
                <td><%= app.getStatus() %></td>
                <td><%= app.getAppliedAt() %></td>
                <td>
                    <form action="CardStatusActionServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= app.getId() %>">
                        <button class="btn approve-btn" name="action" value="approve">Approve</button>
                        <button class="btn reject-btn" name="action" value="reject">Reject</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr><td colspan="6">No pending applications.</td></tr>
            <% } %>
        </table>
    </div>

    <div class="section">
        <h2>Registered Users</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Username</th>
                <th>Email</th>
                <th>Role</th>
            </tr>
            <% for (User u : users) { %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRole() %></td>
            </tr>
            <% } %>
        </table>
    </div>

    <div class="section">
        <h2>Accounts</h2>
        <table>
            <tr>
                <th>Account Number</th>
                <th>Type</th>
                <th>Balance</th>
                <th>User ID</th>
            </tr>
            <% for (Account acc : accounts) { %>
            <tr>
                <td><%= acc.getAccountNumber() %></td>
                <td><%= acc.getAccountType() %></td>
                <td><%= String.format("%.2f", acc.getBalance()) %></td>
                <td><%= acc.getUserId() %></td>
            </tr>
            <% } %>
        </table>
    </div>
</div>


<% if (session.getAttribute("message") != null) { %>
    <p style="color: green;"><%= session.getAttribute("message") %></p>
    <% session.removeAttribute("message"); %>
<% } else if (session.getAttribute("error") != null) { %>
    <p style="color: red;"><%= session.getAttribute("error") %></p>
    <% session.removeAttribute("error"); %>
<% } %>


</body>
</html>
