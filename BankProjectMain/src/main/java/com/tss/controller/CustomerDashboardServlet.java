package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.tss.dao.AccountDAO;
import com.tss.dao.TransactionDAO;
import com.tss.model.Account;
import com.tss.model.Transaction;
import com.tss.model.User;

@WebServlet("/CustomerDashboardServlet")
public class CustomerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CustomerDashboardServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null || !"Customer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        List<Account> accounts = AccountDAO.getAccountsByUserId(user.getUserId());

        if (accounts == null || accounts.isEmpty()) {
            session.setAttribute("error", "No accounts found for this user.");
            response.sendRedirect("error.jsp");
            return;
        }

        Transaction latestTxn = null;
        Account accountWithLatestTxn = null;

        for (Account acc : accounts) {
            Transaction txn = TransactionDAO.getLastTransaction(acc.getAccountNumber());

            if (txn != null && (latestTxn == null || txn.getTimestamp().after(latestTxn.getTimestamp()))) {
                latestTxn = txn;
                accountWithLatestTxn = acc;
            }
        }

        request.setAttribute("accounts", accounts);

        if (latestTxn != null) {
            String summary = latestTxn.getType().equalsIgnoreCase("DEBIT")
                    ? "Sent ₹" + latestTxn.getAmount() + " to A/C " + latestTxn.getToAccount()
                    : "Received ₹" + latestTxn.getAmount() + " from A/C " + latestTxn.getFromAccount();
            request.setAttribute("lastTxn", summary);
        } else {
            request.setAttribute("lastTxn", "No transactions yet.");
        }

        RequestDispatcher rd = request.getRequestDispatcher("customer/dashboard.jsp");
        rd.forward(request, response);
    }
}
