package com.tss.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.tss.dao.AccountDAO;
import com.tss.model.Account;

@WebServlet("/EditAccountServlet")
public class EditAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public EditAccountServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        Account acc = AccountDAO.getAccountByNumber(accountNumber);

        if (acc == null) {
            request.getSession().setAttribute("error", "Account not found.");
            response.sendRedirect("ManageAccountsServlet");
        } else {
            request.setAttribute("account", acc);
            request.getRequestDispatcher("/admin/edit_account.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumber = request.getParameter("accountNumber");
        String type = request.getParameter("accountType");
        double balance = Double.parseDouble(request.getParameter("balance"));

        Account account = new Account();
        account.setAccountNumber(accountNumber);
        account.setAccountType(type);
        account.setBalance(balance);

        boolean updated = AccountDAO.updateAccount(account);

        HttpSession session = request.getSession();
        if (updated) {
            session.setAttribute("message", "Account updated successfully.");
        } else {
            session.setAttribute("error", "Failed to update account.");
        }
        response.sendRedirect("ManageAccountsServlet");
    }
}
