<%@ page import="java.util.*, com.tss.model.CardApplication" %>
<%
    List<CardApplication> applications = (List<CardApplication>) request.getAttribute("applications");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Card Application Status</title>
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
            margin-bottom: 20px;
            color: #2c3e50;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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

        .no-apps {
            text-align: center;
            padding: 20px;
            background-color: #fff3cd;
            color: #856404;
            font-weight: bold;
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
            <li onclick="location.href='CardApplicationServlet'">Apply Card</li>
            <li class="active">Card Status</li>
            <li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
        </ul>
    </div>

    <div class="container">
        <h2>Your Card Applications</h2>
        <table>
            <tr>
                <th>Account Number</th>
                <th>Card Type</th>
                <th>Status</th>
                <th>Applied At</th>
                <th>Approved At</th>
            </tr>
            <%
                if (applications != null && !applications.isEmpty()) {
                    for (CardApplication app : applications) {
            %>
            <tr>
                <td><%= app.getAccountNumber() %></td>
                <td><%= app.getCardType() %></td>
                <td><%= app.getStatus() %></td>
                <td><%= app.getAppliedAt() %></td>
                <td><%= app.getApprovedAt() == null ? "-" : app.getApprovedAt() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" class="no-apps">No card applications found.</td>
            </tr>
            <% } %>
        </table>
    </div>

</body>
</html>
