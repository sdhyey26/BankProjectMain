package com.tss.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.model.User;
import com.tss.service.AuthService;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String role = request.getParameter("role");

		AuthService authService = new AuthService();
		User user = authService.validateUser(username, password , role);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			session.setAttribute("role", user.getRole()); 

			if ("Admin".equals(user.getRole())) {
				response.sendRedirect("AdminDashboardServlet");
			} else {
				response.sendRedirect("CustomerDashboardServlet");
			}
		} else {
			request.setAttribute("error", "Invalid credentials.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}

}
