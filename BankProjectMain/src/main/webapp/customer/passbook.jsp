<%@ page import="java.util.*, com.tss.model.Transaction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
String filterType = request.getParameter("type");
String fromDate = request.getParameter("from");
String toDate = request.getParameter("to");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Passbook</title>

<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script
	src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<link rel="stylesheet"
	href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css">
<script
	src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script
	src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

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
    padding-top: 30px;
    box-shadow: 2px 0 8px rgba(0,0,0,0.1);
}

.sidebar h2 {
    text-align: center;
    font-size: 1.5rem;
    margin-bottom: 20px;
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
    transition: background 0.3s;
}

.sidebar ul li:hover, .sidebar ul li.active {
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
    font-size: 1.8rem;
    font-weight: 600;
}

form.filter-form {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 25px;
    background: #fff;
    padding: 18px 22px;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.filter-form label {
    font-weight: 600;
    color: #444;
}

.filter-form input, 
.filter-form select {
    padding: 8px 12px;
    border-radius: 6px;
    border: 1px solid #ccc;
    font-size: 0.95rem;
    outline: none;
    transition: border-color 0.3s;
}

.filter-form input:focus, 
.filter-form select:focus {
    border-color: #3498db;
}

.filter-form button {
    padding: 10px 18px;
    background-color: #3498db;
    border: none;
    border-radius: 6px;
    color: white;
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
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

th, td {
    padding: 14px 18px;
    text-align: center;
}

th {
    background: #3498db;
    color: white;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.9rem;
}

tr:nth-child(even) {
    background-color: #f9f9f9;
}

tr:hover td {
    background-color: #eef6fd;
}

.no-txn {
    text-align: center;
    padding: 20px;
    background-color: #fff3cd;
    color: #856404;
    font-weight: bold;
    font-size: 1rem;
}

.dt-buttons {
    margin: 15px 0;
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
    transition: background-color 0.3s ease, transform 0.2s;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.dt-button:hover {
    background-color: #2980b9 !important;
    transform: translateY(-2px);
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
			<li class="active">Passbook</li>
			<li onclick="location.href='CardApplicationServlet'">Apply Card</li>
			<li onclick="location.href='CardStatusServlet'">Card Status</li>
			<li onclick="location.href='logout.jsp'" style="margin-top: 20px;">Logout</li>
		</ul>
	</div>

	<div class="container">
		<h2>Transaction History</h2>

		<form class="filter-form" method="get" action="PassbookServlet">
			<label>From: <input type="date" name="from"
				value="<%=fromDate != null ? fromDate : ""%>"></label> <label>To:
				<input type="date" name="to"
				value="<%=toDate != null ? toDate : ""%>">
			</label> <label>Type: <select name="type">
					<option value="">All</option>
					<option value="credit"
						<%="credit".equals(filterType) ? "selected" : ""%>>Credit</option>
					<option value="debit"
						<%="debit".equals(filterType) ? "selected" : ""%>>Debit</option>
			</select>
			</label>
			<button type="submit">Filter</button>
		</form>

		<table id="passbookTable" class="display nowrap" style="width: 100%">
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
				<%
				if (transactions != null && !transactions.isEmpty()) {
					for (Transaction t : transactions) {
				%>
				<tr>
					<td><%=t.getId()%></td>
					<td><%=t.getFromAccount()%></td>
					<td><%=t.getToAccount()%></td>
					<td><%=t.getType()%></td>
					<td>₹<%=String.format("%.2f", t.getAmount())%></td>
					<td><%=t.getTimestamp()%></td>
				</tr>
				<%
				}
				} else {
				%>
				<tr>
					<td colspan="6" class="no-txn">No transactions found.</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</div>

	<script>
		$(document).ready(
				function() {
					$('#passbookTable').DataTable(
							{
								dom : 'Bfrtip',
								buttons : [ 'copyHtml5', 'excelHtml5',
										'csvHtml5', 'pdfHtml5', 'print' ],
								pageLength : 10
							});
				});
	</script>

</body>
</html>
