package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.AccountDAO;
import com.tss.model.Account;
import com.tss.model.User;

@WebServlet("/AccountInfoServlet")
public class AccountInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (session != null) ? (User) session.getAttribute("user") : null;
		String role = (session != null) ? (String) session.getAttribute("role") : null;

		if (user == null || !"Customer".equals(role)) {
			response.sendRedirect("../login.jsp");
			return;
		}

		List<Account> accounts = AccountDAO.getAccountsByUserId(user.getUserId());

		if (accounts == null || accounts.isEmpty()) {
			request.setAttribute("error", "No account found.");
			request.getRequestDispatcher("error.jsp").forward(request, response);
			return;
		}

		request.setAttribute("user", user);
		request.setAttribute("accounts", accounts);
		request.getRequestDispatcher("customer/account.jsp").forward(request, response);
	}
}
