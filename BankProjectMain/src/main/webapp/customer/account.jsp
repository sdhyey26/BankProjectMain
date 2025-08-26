<%@ page import="com.tss.model.User, com.tss.model.Account, java.util.List" %>
<%
    User user = (User) request.getAttribute("user");
    List<Account> accounts = (List<Account>) request.getAttribute("accounts");

    if (user == null || accounts == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Info</title>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css">

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

    <style>
        body {
            background-color: #f4f4f4;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            margin: 0;
            display: flex;
        }

        .sidebar {
            width: 220px;
            height: 100vh;
            background-color: #2c3e50;
            color: white;
            padding-top: 30px;
            position: fixed;
        }

        .sidebar h2 {
            text-align: center;
            font-size: 1.5rem;
            margin-bottom: 25px;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar ul li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .sidebar ul li:hover, .sidebar ul li.active {
            background-color: #34495e;
        }

        .content {
            margin-left: 220px;
            padding: 40px;
            flex: 1;
        }

        h2 {
            margin-bottom: 30px;
            color: #2c3e50;
        }

        .account-heading {
            margin: 30px 0 10px 0;
            color: #3498db;
            font-size: 1.2rem;
        }

        .account-table {
            width: 80%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
        }

        .account-table td {
            padding: 14px 20px;
            border-bottom: 1px solid #ddd;
        }

        .account-table td:first-child {
            font-weight: bold;
            color: #555;
            width: 200px;
        }

        .account-table tr:last-child td {
            border-bottom: none;
        }

        .dt-buttons {
            margin-bottom: 20px;
        }

        .dt-button {
            background-color: #3498db !important;
            color: white !important;
            border: none !important;
            padding: 10px 16px !important;
            border-radius: 6px !important;
            font-weight: 600 !important;
            margin-right: 8px !important;
            cursor: pointer !important;
            transition: background-color 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .dt-button:hover {
            background-color: #2980b9 !important;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Bank Panel</h2>
    <ul>
        <li onclick="location.href='CustomerDashboardServlet'">Dashboard</li>
        <li class="active">Account Info</li>
        <li onclick="location.href='TransferServlet'">Transfer Funds</li>
        <li onclick="location.href='PassbookServlet'">Passbook</li>
        <li onclick="location.href='CardApplicationServlet'">Apply Card</li>
        <li onclick="location.href='CardStatusServlet'">Card Status</li>
        <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
    </ul>
</div>

<div class="content">
    <h2>Your Account Information</h2>

    <% for (Account acc : accounts) { %>
        <div class="account-heading"><%= acc.getAccountType() %> Account</div>

        <table class="account-table" id="accountTable_<%= acc.getAccountNumber() %>">
            <thead style="display:none;">
                <tr><th>Field</th><th>Value</th></tr>
            </thead>
            <tbody>
                <tr><td>Full Name</td><td><%= user.getFullName() %></td></tr>
                <tr><td>Username</td><td><%= user.getUsername() %></td></tr>
                <tr><td>Email</td><td><%= user.getEmail() %></td></tr>
                <tr><td>Account Number</td><td><%= acc.getAccountNumber() %></td></tr>
                <tr><td>Account Type</td><td><%= acc.getAccountType() %></td></tr>
                <tr><td>Current Balance</td><td><%= String.format("%.2f", acc.getBalance()) %></td></tr>
            </tbody>
        </table>
    <% } %>
</div>

<script>
    const accountTableIds = [
        <% for (Account acc : accounts) { %>
            "accountTable_<%= acc.getAccountNumber() %>",
        <% } %>
    ];

    $(document).ready(function () {
        accountTableIds.forEach(function (id) {
            $('#' + id).DataTable({
                dom: 'Bfrtip',
                buttons: ['copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5', 'print'],
                paging: false,
                searching: false,
                info: false
            });
        });
    });
</script>

</body>
</html>
