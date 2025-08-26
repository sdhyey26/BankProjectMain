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
    <title>Edit Account</title>
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
            padding: 40px;
            flex: 1;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }

        form {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            max-width: 500px;
            margin: auto;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: bold;
            display: block;
            margin-top: 15px;
        }

        select,
        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 4px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        a {
            margin-left: 10px;
            padding: 10px 20px;
            background-color: #95a5a6;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

        button:hover {
            background-color: #2980b9;
        }

        a:hover {
            background-color: #7f8c8d;
        }

        .error {
            color: red;
            font-size: 0.9rem;
            margin-top: 5px;
        }
    </style>
    <script>
        function validateForm() {
            const balance = document.getElementById("balance").value;
            if (parseFloat(balance) < 0) {
                alert("Balance cannot be negative.");
                return false;
            }
            return true;
        }
    </script>
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
    <h2>Edit Account</h2>
    <form action="EditAccountServlet" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="accountNumber" value="<%= acc.getAccountNumber() %>">

        <label>Account Type:</label>
        <select name="accountType" required>
            <option value="Savings" <%= "Savings".equalsIgnoreCase(acc.getAccountType()) ? "selected" : "" %>>Savings</option>
            <option value="Current" <%= "Current".equalsIgnoreCase(acc.getAccountType()) ? "selected" : "" %>>Current</option>
        </select>

        <label>Balance:</label>
        <input type="number" step="0.01" id="balance" name="balance" value="<%= acc.getBalance() %>" required>

        <button type="submit">Update</button>
        <a href="ManageAccountsServlet">Cancel</a>
    </form>
</div>

</body>
</html>
