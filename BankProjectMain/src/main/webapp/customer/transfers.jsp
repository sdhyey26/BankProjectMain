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
    }
    .sidebar h2 { text-align: center; font-size: 1.5rem; margin-bottom: 20px; color : white }
    .sidebar ul { list-style: none; padding: 0; margin: 0; }
    .sidebar ul li {
        padding: 15px 20px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .sidebar ul li:hover, .sidebar ul li.active { background-color: #34495e; }

    .container {
        margin-left: 220px;
        padding: 50px;
        flex: 1;
    }
    h2 { margin-bottom: 30px; color: #2c3e50; font-size: 1.8rem; }

    form {
        background-color: #ffffff;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        max-width: 550px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    form:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12); }

    .form-group { position: relative; margin-bottom: 25px; }
    label {
        position: absolute; top: 12px; left: 12px;
        font-size: 0.95rem; color: #666; transition: 0.2s; pointer-events: none;
    }
    input, select {
        width: 100%; padding: 14px 12px; font-size: 1rem;
        border-radius: 6px; border: 1px solid #ccc;
        background: transparent; outline: none;
        transition: border 0.3s, box-shadow 0.3s;
    }
    input:focus, select:focus {
        border-color: #3498db; box-shadow: 0 0 5px rgba(52, 152, 219, 0.4);
    }
    input:focus + label,
    input:not(:placeholder-shown) + label,
    select:focus + label,
    select:valid + label {
        top: -8px; left: 10px; font-size: 0.8rem;
        color: #3498db; background: #fff; padding: 0 5px;
    }

    button {
        background-color: #3498db; color: white;
        padding: 14px 22px; border: none; border-radius: 6px;
        font-size: 1rem; cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
    }
    button:hover { background-color: #2980b9; transform: translateY(-2px); }

    .error, .success {
        margin-top: 20px; font-weight: bold;
        padding: 12px; border-radius: 6px;
        animation: fadeIn 0.6s ease-in-out;
    }
    .error { background: #ffe6e6; color: #c0392b; border: 1px solid #e74c3c; }
    .success { background: #e6ffed; color: #27ae60; border: 1px solid #2ecc71; }

]    .field-error {
        font-size: 0.85rem;
        color: #e74c3c;
        margin-top: 5px;
        display: none;
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
</head>
<body>

    <div class="sidebar">
        <h2>Customer Panel</h2>
        <ul>
            <li onclick="location.href='${pageContext.request.contextPath}/CustomerDashboardServlet'">Dashboard</li>
            <li onclick="location.href='${pageContext.request.contextPath}/AccountInfoServlet'">Account Info</li>
            <li class="active">Transfer Funds</li>
            <li onclick="location.href='${pageContext.request.contextPath}/PassbookServlet'">Passbook</li>
            <li onclick="location.href='${pageContext.request.contextPath}/CardApplicationServlet'">Apply Card</li>
            <li onclick="location.href='${pageContext.request.contextPath}/CardStatusServlet'">Card Status</li>
            <li onclick="location.href='${pageContext.request.contextPath}/logout.jsp'">Logout</li>
        </ul>
    </div>

    <div class="container">
        <h2>Transfer Funds</h2>

        <form id="transferForm" action="${pageContext.request.contextPath}/TransferServlet" method="post">
            
            <div class="form-group">
                <select name="transferType" id="transferType" required>
                    <option value="" disabled selected hidden></option>
                    <option value="internal">Internal (Savings ↔ Current)</option>
                    <option value="external">External (To Another Account)</option>
                </select>
                <label>Transfer Type</label>
                <div class="field-error" id="transferTypeError">Please select transfer type</div>
            </div>

            <div class="form-group">
                <select name="fromType" id="fromType" required>
                    <option value="" disabled selected hidden></option>
                    <option value="Savings">Savings</option>
                    <option value="Current">Current</option>
                </select>
                <label>From Account Type</label>
                <div class="field-error" id="fromTypeError">Please select an account type</div>
            </div>

            <div class="form-group">
                <input type="text" name="toAccountNumber" id="toAccountNumber" placeholder=" ">
                <label>To Account Number (for external only)</label>
                <div class="field-error" id="accountError">Enter valid 10–12 digit account number</div>
            </div>

            <div class="form-group">
                <input type="number" name="amount" id="amount" step="0.01" min="1" placeholder=" " required>
                <label>Amount</label>
                <div class="field-error" id="amountError">Amount must be greater than 0</div>
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

<script>
document.getElementById("transferForm").addEventListener("submit", function(e) {
    let valid = true;

    const transferType = document.getElementById("transferType");
    const transferTypeError = document.getElementById("transferTypeError");
    if (!transferType.value) {
        transferTypeError.style.display = "block";
        valid = false;
    } else {
        transferTypeError.style.display = "none";
    }

    // From type
    const fromType = document.getElementById("fromType");
    const fromTypeError = document.getElementById("fromTypeError");
    if (!fromType.value) {
        fromTypeError.style.display = "block";
        valid = false;
    } else {
        fromTypeError.style.display = "none";
    }

    // Account number (only for external transfer)
    const toAcc = document.getElementById("toAccountNumber");
    const accError = document.getElementById("accountError");
    if (transferType.value === "external") {
        const accRegex = /^[0-9]{10,12}$/;
        if (!accRegex.test(toAcc.value.trim())) {
            accError.style.display = "block";
            valid = false;
        } else {
            accError.style.display = "none";
        }
    } else {
        accError.style.display = "none"; 
    }

    const amount = document.getElementById("amount");
    const amountError = document.getElementById("amountError");
    if (amount.value <= 0) {
        amountError.style.display = "block";
        valid = false;
    } else {
        amountError.style.display = "none";
    }

    if (!valid) e.preventDefault();
});
</script>

</body>
</html>
