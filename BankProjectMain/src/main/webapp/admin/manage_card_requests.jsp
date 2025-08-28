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
            background-color: #f5f7fa;
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
		    margin: 0;              
		    padding: 20px 0;         
		    text-align: center;
		    color : white;
		    font-size: 1.5rem;
		    background-color: #2c3e50; 
		    border-bottom: 1px solid #34495e;
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        h2 {
            margin-bottom: 20px;
            color: #2c3e50;
            font-size: 1.8rem;
            font-weight: 600;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        .filter-form {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-form label {
            font-weight: 600;
            color: #2c3e50;
        }

        .filter-form select {
            padding: 8px 12px;
            font-size: 0.95rem;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .filter-form button {
            padding: 8px 16px;
            font-size: 0.95rem;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s, transform 0.2s;
        }

        .filter-form button:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px 16px;
            text-align: center;
        }

        th {
            background-color: #3498db;
            color: white;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #eef6fd;
        }

        .btn {
            padding: 6px 14px;
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s, transform 0.2s;
        }

        .approve-btn {
            background-color: #2ecc71;
        }
        .approve-btn:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
        }

        .reject-btn {
            background-color: #e74c3c;
        }
        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        .empty-msg {
            text-align: center;
            padding: 20px;
            background: #fff3cd;
            color: #856404;
            font-weight: 600;
            border-radius: 6px;
            margin-top: 15px;
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
    <div class="section">
        <h2>Card Application Requests</h2>

        <form method="get" class="filter-form">
            <label>Filter by Status:</label>
            <select name="status">
                <option value="">All</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Rejected">Rejected</option>
            </select>
            <button type="submit">Apply</button>
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
            <tr>
                <td colspan="8" class="empty-msg">⚠ No card applications found.</td>
            </tr>
            <% } %>
        </table>
    </div>
</div>

</body>
</html>
