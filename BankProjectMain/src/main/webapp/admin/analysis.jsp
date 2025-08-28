<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<String, Integer> accountTypeStats = (Map<String, Integer>) request.getAttribute("accountTypeStats");
    Map<String, Double> balanceStats = (Map<String, Double>) request.getAttribute("totalBalanceStats");
    Map<String, Integer> monthlyAccounts = (Map<String, Integer>) request.getAttribute("monthlyAccounts");
    Map<String, Integer> monthlyTransactions = (Map<String, Integer>) request.getAttribute("monthlyTransactions");
    List<Map<String, Object>> topUsers = (List<Map<String, Object>>) request.getAttribute("topUsers");

    if (accountTypeStats == null) accountTypeStats = new HashMap<>();
    if (balanceStats == null) balanceStats = new HashMap<>();
    if (monthlyAccounts == null) monthlyAccounts = new HashMap<>();
    if (monthlyTransactions == null) monthlyTransactions = new HashMap<>();
    if (topUsers == null) topUsers = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Analysis</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        background-color: #f5f7fa;
        display: flex;
        min-height: 100vh;
    }

    /* Sidebar */
    .sidebar {
        width: 220px;
        background-color: #2c3e50;
        color: white;
        min-height: 100vh;
        position: fixed;
        display: flex;
        flex-direction: column;
        animation: slideInLeft 0.6s ease;
    }

    .sidebar h2 {
        margin: 0;
        padding: 20px 0;
        text-align: center;
        font-size: 1.5rem;
        color: white;
        border-bottom: 1px solid #34495e;
        opacity: 0;
        animation: fadeIn 1s ease forwards;
        animation-delay: 0.3s;
    }

    .sidebar ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar ul li {
        padding: 15px 20px;
        cursor: pointer;
        transition: background 0.3s, padding-left 0.3s, transform 0.3s;
        opacity: 0;
        transform: translateX(-15px);
        animation: fadeSlideIn 0.5s ease forwards;
    }
    .sidebar ul li:nth-child(1) { animation-delay: 0.5s; }
    .sidebar ul li:nth-child(2) { animation-delay: 0.6s; }
    .sidebar ul li:nth-child(3) { animation-delay: 0.7s; }
    .sidebar ul li:nth-child(4) { animation-delay: 0.8s; }
    .sidebar ul li:nth-child(5) { animation-delay: 0.9s; }
    .sidebar ul li:nth-child(6) { animation-delay: 1s; }
    .sidebar ul li:nth-child(7) { animation-delay: 1.1s; }

    .sidebar ul li:hover,
    .sidebar ul li.active {
        background-color: #34495e;
        padding-left: 25px;
        transform: scale(1.05);
    }

    /* Main content */
    .content {
        margin-left: 240px;
        padding: 30px;
        width: calc(100% - 240px);
    }

    h2 {
        color: #2c3e50;
        margin-bottom: 20px;
    }

    /* Chart grid */
    .chart-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: space-between;
    }

    .chart-box {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        width: 48%;
        box-sizing: border-box;
        opacity: 0;
        transform: translateY(20px);
        animation: fadeUp 0.7s ease forwards;
    }
    .chart-box:nth-child(1) { animation-delay: 0.4s; }
    .chart-box:nth-child(2) { animation-delay: 0.6s; }
    .chart-box:nth-child(3) { animation-delay: 0.8s; }
    .chart-box:nth-child(4) { animation-delay: 1s; }
    .chart-box:nth-child(5) { animation-delay: 1.2s; }

    .chart-box.full {
        width: 100%;
    }

    .chart-box h3 {
        margin-top: 0;
        font-size: 1.1rem;
        margin-bottom: 15px;
    }

    canvas {
        width: 100% !important;
        height: 300px !important;
    }

    /* Keyframes */
    @keyframes slideInLeft {
        from { transform: translateX(-100%); }
        to { transform: translateX(0); }
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes fadeSlideIn {
        from { opacity: 0; transform: translateX(-15px); }
        to { opacity: 1; transform: translateX(0); }
    }

    @keyframes fadeUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
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
        <li onclick="location.href='AdminTransactionServlet'">View Transactions</li>
        <li onclick="location.href='ManageCardRequestsServlet'">Card Requests</li>
        <li class="active" onclick="location.href='AdminAnalysisServlet'">Analysis</li>
        <li onclick="location.href='logout.jsp'">Logout</li>
    </ul>
</div>

<div class="content">
    <h2>Analytics Dashboard</h2>

    <div class="chart-grid">
        <div class="chart-box">
            <h3>Account Type Distribution</h3>
            <canvas id="accountTypeChart"></canvas>
        </div>

        <div class="chart-box">
            <h3>Total Balance by Account Type</h3>
            <canvas id="balanceChart"></canvas>
        </div>

        <div class="chart-box">
            <h3>Monthly Account Creation</h3>
            <canvas id="monthlyAccountsChart"></canvas>
        </div>

        <div class="chart-box">
            <h3>Monthly Transactions</h3>
            <canvas id="monthlyTransactionsChart"></canvas>
        </div>

        <div class="chart-box full">
            <h3>Top 5 Users by Balance</h3>
            <canvas id="topUsersChart"></canvas>
        </div>
    </div>
</div>

<script>
    const accountTypeData = {
        labels: [<%= String.join(", ", accountTypeStats.keySet().stream().map(k -> "\"" + k + "\"").toList()) %>],
        datasets: [{
            label: 'Accounts',
            data: [<%= String.join(", ", accountTypeStats.values().stream().map(String::valueOf).toList()) %>],
            backgroundColor: ['#3498db', '#2ecc71', '#9b59b6', '#f1c40f']
        }]
    };

    const balanceData = {
        labels: [<%= String.join(", ", balanceStats.keySet().stream().map(k -> "\"" + k + "\"").toList()) %>],
        datasets: [{
            label: 'Total Balance',
            data: [<%= String.join(", ", balanceStats.values().stream().map(String::valueOf).toList()) %>],
            backgroundColor: ['#1abc9c', '#e67e22', '#e74c3c']
        }]
    };

    const monthlyAccountsData = {
        labels: [<%= String.join(", ", monthlyAccounts.keySet().stream().map(k -> "\"" + k + "\"").toList()) %>],
        datasets: [{
            label: 'New Accounts',
            data: [<%= String.join(", ", monthlyAccounts.values().stream().map(String::valueOf).toList()) %>],
            borderColor: '#3498db',
            backgroundColor: '#3498db20',
            fill: true,
            tension: 0.3
        }]
    };

    const monthlyTransactionsData = {
        labels: [<%= String.join(", ", monthlyTransactions.keySet().stream().map(k -> "\"" + k + "\"").toList()) %>],
        datasets: [{
            label: 'Transactions',
            data: [<%= String.join(", ", monthlyTransactions.values().stream().map(String::valueOf).toList()) %>],
            backgroundColor: '#9b59b6'
        }]
    };

    const topUsersData = {
        labels: [<%= topUsers.stream().map(u -> "\"" + u.get("name") + "\"").collect(java.util.stream.Collectors.joining(", ")) %>],
        datasets: [{
            label: 'Balance',
            data: [<%= topUsers.stream().map(u -> u.get("balance").toString()).collect(java.util.stream.Collectors.joining(", ")) %>],
            backgroundColor: '#f39c12'
        }]
    };

    const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
            duration: 1200,
            easing: 'easeOutQuart'
        },
        plugins: {
            legend: { position: 'top' }
        }
    };

    new Chart(document.getElementById('accountTypeChart'), { type: 'doughnut', data: accountTypeData, options: chartOptions });
    new Chart(document.getElementById('balanceChart'), { type: 'bar', data: balanceData, options: chartOptions });
    new Chart(document.getElementById('monthlyAccountsChart'), { type: 'line', data: monthlyAccountsData, options: chartOptions });
    new Chart(document.getElementById('monthlyTransactionsChart'), { type: 'bar', data: monthlyTransactionsData, options: chartOptions });
    new Chart(document.getElementById('topUsersChart'), { type: 'bar', data: topUsersData, options: chartOptions });
</script>

</body>
</html>
