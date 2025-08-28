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
            background-color: #f5f7fa;
            display: flex;
        }

        /* Sidebar */
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
            transition: background-color 0.3s, padding-left 0.3s;
        }

        .sidebar ul li:hover, .sidebar ul li.active {
            background-color: #34495e;
            padding-left: 25px;
        }

        /* Main Container */
        .container {
            margin-left: 220px;
            padding: 40px;
            flex: 1;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.8rem;
        }

        /* Section cards */
        .section {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 40px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .section h2 {
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
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

        /* Buttons */
        .btn {
            padding: 8px 14px;
            font-size: 0.9rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
            font-weight: 600;
        }

        .approve-btn {
            background-color: #27ae60;
            color: white;
        }

        .approve-btn:hover {
            background-color: #1e8449;
            transform: translateY(-2px);
        }

        .reject-btn {
            background-color: #e74c3c;
            color: white;
        }

        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        /* Messages */
        .message {
            margin: 20px 0;
            font-weight: bold;
            padding: 12px 18px;
            border-radius: 8px;
        }

        .message.success {
            background: #eafaf1;
            color: #27ae60;
            border-left: 5px solid #27ae60;
        }

        .message.error {
            background: #fdecea;
            color: #e74c3c;
            border-left: 5px solid #e74c3c;
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

    <!-- Pending Card Applications -->
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

    <!-- Registered Users -->
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

    <!-- Accounts -->
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
                <td>₹<%= String.format("%.2f", acc.getBalance()) %></td>
                <td><%= acc.getUserId() %></td>
            </tr>
            <% } %>
        </table>
    </div>

    <% if (session.getAttribute("message") != null) { %>
        <p class="message success"><%= session.getAttribute("message") %></p>
        <% session.removeAttribute("message"); %>
    <% } else if (session.getAttribute("error") != null) { %>
        <p class="message error"><%= session.getAttribute("error") %></p>
        <% session.removeAttribute("error"); %>
    <% } %>

</div>

</body>
</html>
