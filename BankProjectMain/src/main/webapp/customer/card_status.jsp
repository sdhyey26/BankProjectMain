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
            background-color: #f5f7fa;
            display: flex;
        }

        .sidebar {
            width: 220px;
            background-color: #2c3e50;
            color: white;
            height: 100vh;
            position: fixed;
            display: flex;
            flex-direction: column;
        }

        .sidebar h2 {
            margin: 0;
            padding: 20px 0;
            text-align: center;
            color : white;
            font-size: 1.4rem;
            border-bottom: 1px solid #34495e;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
            flex: 1;
        }

        .sidebar ul li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background 0.3s, padding-left 0.3s;
        }

        .sidebar ul li:hover,
        .sidebar ul li.active {
            background-color: #34495e;
            padding-left: 25px;
        }

        .container {
            margin-left: 220px;
            padding: 30px;
            flex: 1;
        }

        h2 {
            margin-bottom: 25px;
            color: #2c3e50;
            font-size: 1.6rem;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
            font-size: 0.95rem;
        }

        th {
            background-color: #3498db;
            color: white;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover td {
            background-color: #eef6fd;
            transition: background 0.3s;
        }

        td {
            color: #333;
        }

        /* Status badges */
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
            color: white;
        }
        .status.Pending {
            background-color: #f39c12;
        }
        .status.Approved {
            background-color: #2ecc71;
        }
        .status.Rejected {
            background-color: #e74c3c;
        }

        .no-apps {
            text-align: center;
            padding: 20px;
            background: #fff3cd;
            color: #856404;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Customer Panel</h2>
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
                <td><span class="status <%= app.getStatus() %>"><%= app.getStatus() %></span></td>
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
