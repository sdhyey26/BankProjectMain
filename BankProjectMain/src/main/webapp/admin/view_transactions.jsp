<%@ page import="java.util.*, com.tss.model.Transaction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Customer Transactions</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

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
            margin-bottom: 25px;
            color: #2c3e50;
        }

        form {
            margin-bottom: 20px;
        }

        input[type="text"] {
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }

        button {
            padding: 10px 20px;
            font-size: 1rem;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #2980b9;
        }

        table.dataTable thead th {
            background-color: #3498db;
            color: white;
        }

        .no-txn {
            text-align: center;
            padding: 20px;
            background-color: #fff3cd;
            color: #856404;
            font-weight: bold;
        }

        .dt-buttons {
            margin-bottom: 15px;
        }

        .dt-button {
            background-color: #3498db !important;
            color: white !important;
            border: none !important;
            padding: 8px 14px !important;
            margin-right: 8px;
            border-radius: 5px !important;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .dt-button:hover {
            background-color: #2980b9 !important;
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
            <li class="active">View Transactions</li>
            <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
            <li onclick="location.href='AdminAnalysisServlet'">Analysis</li>
            <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
        </ul>
    </div>

    <div class="container">
        <h2>Customer Transaction History</h2>

        <form method="get" action="AdminTransactionServlet">
            <input type="text" name="accountNumber" placeholder="Filter by Account Number" />
            <button type="submit">Filter</button>
        </form>

        <% if (transactions != null && !transactions.isEmpty()) { %>
        <table id="transactionTable" class="display nowrap" style="width:100%">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>From</th>
                    <th>To</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (Transaction t : transactions) { %>
                <tr>
                    <td><%= t.getId() %></td>
                    <td><%= t.getFromAccount() %></td>
                    <td><%= t.getToAccount() %></td>
                    <td><%= t.getType() %></td>
                    <td>₹<%= String.format("%.2f", t.getAmount()) %></td>
                    <td><%= t.getTimestamp() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
            <div class="no-txn">No transactions found.</div>
        <% } %>
    </div>

    <script>
        $(document).ready(function () {
            $('#transactionTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    'copyHtml5',
                    'excelHtml5',
                    'csvHtml5',
                    'pdfHtml5',
                    'print'
                ],
                responsive: true
            });
        });
    </script>

</body>
</html>
