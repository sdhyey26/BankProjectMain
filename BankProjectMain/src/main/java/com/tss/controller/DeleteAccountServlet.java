package com.tss.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.AccountDAO;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accountNumber = request.getParameter("accountNumber");

        boolean deleted = AccountDAO.deleteAccountByNumber(accountNumber);

        HttpSession session = request.getSession();
        if (deleted) {
            session.setAttribute("message", "Account deleted successfully.");
        } else {
            session.setAttribute("error", "Failed to delete account.");
        }
        response.sendRedirect("ManageAccountsServlet");
    }
}
