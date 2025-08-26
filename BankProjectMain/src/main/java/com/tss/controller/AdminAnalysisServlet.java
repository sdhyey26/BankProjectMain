package com.tss.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tss.dao.AccountDAO;
import com.tss.dao.TransactionDAO;

@WebServlet("/AdminAnalysisServlet")
public class AdminAnalysisServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public AdminAnalysisServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Map<String, Double> totalBalanceStats = AccountDAO.getTotalBalanceByType();
		if (totalBalanceStats == null) totalBalanceStats = new HashMap<>();
		request.setAttribute("totalBalanceStats", totalBalanceStats);
		request.setAttribute("accountTypeStats", AccountDAO.getAccountTypeStats());
		request.setAttribute("monthlyAccounts", AccountDAO.getMonthlyAccountStats());
		request.setAttribute("monthlyTransactions", TransactionDAO.getMonthlyTransactionStats());
		request.setAttribute("topUsers", AccountDAO.getTopUsersByBalance());

		request.getRequestDispatcher("admin/analysis.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
