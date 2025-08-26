<%@ page import="java.util.*, com.tss.model.CardApplication" %>
<%
    List<CardApplication> applications = (List<CardApplication>) request.getAttribute("applications");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Card Requests</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            background-color: #f4f4f4;
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
            margin-bottom: 20px;
            color: #2c3e50;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
        }

        .approve-btn {
            background-color: #2ecc71;
        }

        .reject-btn {
            background-color: #e74c3c;
        }

        .filter-form {
            margin-bottom: 20px;
        }

        .filter-form select {
            padding: 6px 10px;
            font-size: 14px;
        }

        .filter-form button {
            padding: 6px 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
    <ul>
        <li onclick="location.href='AdminDashboardServlet'">Dashboard</li>
        <li onclick="location.href='ManageUsersServlet'">Manage Users</li>
        <li onclick="location.href='ManageAccountsServlet'">Manage Accounts</li>
        <li onclick="location.href='AdminTransactionServlet'">Transactions</li>
        <li class="active">Card Requests</li>
        <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
        
        <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="container">
    <h2>Card Application Requests</h2>

    <form method="get" class="filter-form">
        <label>Filter by Status: </label>
        <select name="status">
            <option value="">All</option>
            <option value="Pending">Pending</option>
            <option value="Approved">Approved</option>
            <option value="Rejected">Rejected</option>
        </select>
        <button type="submit">Filter</button>
    </form>

    <table>
        <tr>
            <th>ID</th>
            <th>User ID</th>
            <th>Account No</th>
            <th>Type</th>
            <th>Status</th>
            <th>Applied At</th>
            <th>Approved At</th>
            <th>Action</th>
        </tr>
        <%
            if (applications != null && !applications.isEmpty()) {
                for (CardApplication app : applications) {
        %>
        <tr>
            <td><%= app.getId() %></td>
            <td><%= app.getUserId() %></td>
            <td><%= app.getAccountNumber() %></td>
            <td><%= app.getCardType() %></td>
            <td><%= app.getStatus() %></td>
            <td><%= app.getAppliedAt() %></td>
            <td><%= app.getApprovedAt() == null ? "-" : app.getApprovedAt() %></td>
            <td>
                <% if ("Pending".equals(app.getStatus())) { %>
                    <form action="CardStatusActionServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= app.getId() %>">
                        <input type="hidden" name="action" value="approve">
                        <button class="btn approve-btn" type="submit">Approve</button>
                    </form>
                    <form action="CardStatusActionServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= app.getId() %>">
                        <input type="hidden" name="action" value="reject">
                        <button class="btn reject-btn" type="submit">Reject</button>
                    </form>
                <% } else { %>
                    -
                <% } %>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="8">No card applications found.</td></tr>
        <% } %>
    </table>
</div>

</body>
</html>
