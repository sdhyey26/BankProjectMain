<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Bank Management System</title>
    <link rel="stylesheet" href="css/styles.css">
    <style>
        .login-container {
            width: 100%;
            height: 100vh;
            background-color: var(--primary-bg);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            background-color: #3e3f52;
            padding: 2.5rem;
            border-radius: var(--card-radius);
            width: 400px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .login-box h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary-text);
        }

        .login-box label {
            color: var(--secondary-text);
            font-weight: 600;
        }

        .error-message {
            color: #ff6b6b;
            text-align: center;
            margin-bottom: 1rem;
        }

        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--secondary-text);
        }

        .register-link a {
            color: var(--accent-blue);
            text-decoration: underline;
        }
		.success-dialog {
		    background-color: #d4edda;  
		    color: #155724;             
		    border: 1px solid #c3e6cb;  
		    padding: 15px 20px;
		    margin: 20px auto;
		    border-radius: 8px;
		    width: 80%;                
		    max-width: 500px;
		    font-size: 16px;
		    font-family: Arial, sans-serif;
		    box-shadow: 0px 4px 8px rgba(0,0,0,0.1);
		    text-align: center;
		    animation: fadeIn 0.5s ease-in-out;
		}
		
		@keyframes fadeIn {
		    from { opacity: 0; transform: translateY(-10px); }
		    to   { opacity: 1; transform: translateY(0); }
		}
        
    </style>
</head>
<body>
	<%
	    String successMessage = (String) session.getAttribute("successMessage");
	    if (successMessage != null) {
	%>
	    <div class="success-dialog"><%= successMessage %></div>
	<%
	        session.removeAttribute("successMessage");
	    }
	%>
    <div class="login-container">
        <form class="login-box" action="LoginServlet" method="post">
            <h2>Bank Login</h2>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="error-message"><%= error %></div>
            <% } %>

            <label for="username">Username</label>
            <input type="text" name="username" placeholder="Enter username" required>

            <label for="password">Password</label>
            <input type="password" name="password" placeholder="Enter password" required>

            <label for="role">Login As</label>
            <select name="role" required>
                <option value="">Select role</option>
                <option value="Customer">Customer</option>
                <option value="Admin">Admin</option>
            </select>

            <button class="button" type="submit">Login</button>

            <div class="register-link">
                Don't have an account? <a href="register.jsp">Register here</a>
            </div>
        </form>
    </div>
</body>
</html>
