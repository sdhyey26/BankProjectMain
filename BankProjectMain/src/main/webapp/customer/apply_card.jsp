<%@ page import="com.tss.model.User, java.util.List, com.tss.model.Account" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
    List<Account> accounts = (List<Account>) session.getAttribute("accounts"); // set this in session after login
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Apply for Card</title>
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
            padding: 40px;
            flex: 1;
        }

        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
        }

        form {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            max-width: 500px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        select, button {
            width: 100%;
            padding: 10px;
            margin-top: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #3498db;
            color: white;
            font-weight: bold;
            border: none;
            margin-top: 20px;
            cursor: pointer;
        }

        button:hover {
            background-color: #2980b9;
        }

        .message {
            margin-top: 20px;
            font-weight: bold;
        }

        .message.success {
            color: green;
        }

        .message.error {
            color: red;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Bank Panel</h2>
        <ul>
            <li onclick="location.href='CustomerDashboardServlet'">Dashboard</li>
            <li onclick="location.href='AccountInfoServlet'">Account Info</li>
            <li onclick="location.href='TransferServlet'">Transfer Funds</li>
            <li onclick="location.href='PassbookServlet'">Passbook</li>
            <li class="active">Apply Card</li>
            <li onclick="location.href='CardStatusServlet'">Card Status</li>
            <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
        </ul>
    </div>

    <div class="container">
        <h2>Apply for Debit/Credit Card</h2>

        <form action="${pageContext.request.contextPath}/CardApplicationServlet" method="post">
            <label>Account Number</label>
            <select name="accountNumber" required>
                <% for (Account acc : accounts) { %>
                    <option value="<%= acc.getAccountNumber() %>">
                        <%= acc.getAccountNumber() %> (<%= acc.getAccountType() %>)
                    </option>
                <% } %>
            </select>

            <label>Card Type</label>
            <select name="cardType" required>
                <option value="Debit">Debit</option>
                <option value="Credit">Credit</option>
            </select>

            <button type="submit">Apply</button>

            <% if (request.getAttribute("message") != null) { %>
                <p class="message success"><%= request.getAttribute("message") %></p>
            <% } else if (request.getAttribute("error") != null) { %>
                <p class="message error"><%= request.getAttribute("error") %></p>
            <% } %>
        </form>
    </div>

</body>
</html>
