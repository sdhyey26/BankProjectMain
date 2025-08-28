package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tss.dao.TransactionDAO;
import com.tss.model.Transaction;


@WebServlet("/AdminTransactionServlet")
public class AdminTransactionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public AdminTransactionServlet() {
        super();
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        List<Transaction> transactions;

        if (accountNumber != null && !accountNumber.isEmpty()) {
            transactions = TransactionDAO.getTransactionsByAccount(accountNumber);
        } else {
            transactions = TransactionDAO.getAllTransactions(); 
        }

        request.setAttribute("transactions", transactions);
        request.getRequestDispatcher("admin/view_transactions.jsp").forward(request, response);
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
