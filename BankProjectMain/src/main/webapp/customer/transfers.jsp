<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tss.model.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"Customer".equals(session.getAttribute("role"))) {
	response.sendRedirect("../login.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Transfer Funds</title>
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
	padding: 30px;
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
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	max-width: 500px;
}

.form-group {
	margin-bottom: 20px;
}

label {
	font-weight: 600;
	display: block;
	margin-bottom: 5px;
}

input, select {
	width: 100%;
	padding: 10px;
	font-size: 1rem;
	border-radius: 5px;
	border: 1px solid #ccc;
	outline: none;
}

input:focus, select:focus {
	border-color: #3498db;
}

button {
	background-color: #3498db;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 5px;
	font-size: 1rem;
	cursor: pointer;
	transition: background-color 0.3s;
}

button:hover {
	background-color: #2980b9;
}

.error {
	color: red;
	margin-top: 15px;
	font-weight: bold;
}

.success {
	color: green;
	margin-top: 15px;
	font-weight: bold;
}
</style>
</head>
<body>

	<div class="sidebar">
		<h2>Bank Panel</h2>
		<ul>
			<li
				onclick="location.href='${pageContext.request.contextPath}/CustomerDashboardServlet'">Dashboard</li>
			<li
				onclick="location.href='${pageContext.request.contextPath}/AccountInfoServlet'">Account
				Info</li>
			<li class="active">Transfer Funds</li>
			<li
				onclick="location.href='${pageContext.request.contextPath}/PassbookServlet'">Passbook</li>
			<li
				onclick="location.href='${pageContext.request.contextPath}/CardApplicationServlet'">Apply
				Card</li>
			<li
				onclick="location.href='${pageContext.request.contextPath}/CardStatusServlet'">Card
				Status</li>
			<li
				onclick="location.href='${pageContext.request.contextPath}/logout.jsp'">Logout</li>

		</ul>
	</div>



	<div class="container">
		<h2>Transfer Funds</h2>

		<form action="${pageContext.request.contextPath}/TransferServlet"
			method="post">
			<div class="form-group">
				<label>Transfer Type</label> <select name="transferType" required>
					<option value="internal">Internal (Savings ↔ Current)</option>
					<option value="external">External (To Another Account)</option>
				</select>
			</div>

			<div class="form-group">
				<label>From Account Type</label> <select name="fromType" required>
					<option value="Savings">Savings</option>
					<option value="Current">Current</option>
				</select>
			</div>

			<div class="form-group">
				<label>To Account Number (for external only)</label> <input
					type="text" name="toAccountNumber"
					placeholder="Enter target account number">
			</div>

			<div class="form-group">
				<label>Amount</label> <input type="number" name="amount" step="0.01"
					min="1" placeholder="Enter amount" required>
			</div>

			<button type="submit">Transfer</button>

			<%
			String message = (String) request.getAttribute("message");
			String error = (String) request.getAttribute("error");
			if (message != null) {
				out.print("<p class='success'>" + message + "</p>");
			}
			if (error != null) {
				out.print("<p class='error'>" + error + "</p>");
			}
			%>
		</form>
	</div>

</body>
</html>
