<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Bank Management</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        .register-container {
            width: 100%;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: var(--primary-bg);
        }

        .register-box {
            background-color: #3e3f52;
            padding: 2.5rem;
            border-radius: var(--card-radius);
            width: 450px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .register-box h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary-text);
        }

        .register-box label {
            color: var(--secondary-text);
            font-weight: 600;
            display: block;
            margin-top: 1rem;
        }

        .register-box input,
        .register-box select {
            width: 100%;
            padding: 10px;
            margin-top: 0.3rem;
            margin-bottom: 1rem;
            border-radius: 5px;
            border: none;
            font-size: 1rem;
        }

        .button {
            width: 100%;
            background-color: #3498db;
            color: white;
            padding: 12px;
            font-size: 1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
<div class="register-container">
    <form class="register-box" action="RegisterServlet" method="post">
        <h2>Create Account</h2>

        <label for="username">Username</label>
        <input type="text" name="username" required maxlength="30">

        <label for="password">Password</label>
        <input type="password" name="password" required minlength="6" placeholder="At least 6 characters">

        <label for="name">Full Name</label>
        <input type="text" name="name" required maxlength="50">

        <label for="mobile">Mobile</label>
        <input type="text" name="mobile" required pattern="^[0-9]{10}$" title="Enter a valid 10-digit mobile number">

        <label for="email">Email</label>
        <input type="email" name="email" required maxlength="50">

        <label for="aadhar">Aadhar Number</label>
        <input type="text" name="aadhar" required pattern="^[0-9]{12}$" title="Enter a valid 12-digit Aadhar number">

        <label for="accountType">Account Type</label>
        <select name="accountType" required>
            <option value="">-- Select --</option>
            <option value="Savings">Savings</option>
            <option value="Current">Current</option>
        </select>

        <label for="initialDeposit">Initial Deposit</label>
        <input type="number" name="initialDeposit" required min="100" step="0.01" title="Minimum ₹100 required">

        <button class="button" type="submit">Register</button>
    </form>
</div>
</body>
</html>
