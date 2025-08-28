package com.tss.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.AccountDAO;
import com.tss.dao.TransactionDAO;
import com.tss.model.Account;
import com.tss.model.Transaction;
import com.tss.model.User;


@WebServlet("/PassbookServlet")
public class PassbookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
 
    public PassbookServlet() {
        super();
    }


protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    User user = (session != null) ? (User) session.getAttribute("user") : null;

    if (user == null || !"Customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String accNumber = AccountDAO.getAccountByUserId(user.getUserId()).getAccountNumber();

    String type = request.getParameter("type");
    String fromDate = request.getParameter("from");
    String toDate = request.getParameter("to");

    List<Transaction> transactions = TransactionDAO.getFilteredTransactions(accNumber, type, fromDate, toDate);

    request.setAttribute("transactions", transactions);
    request.getRequestDispatcher("customer/passbook.jsp").forward(request, response);
}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
