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
import com.tss.dao.CardApplicationDAO;
import com.tss.model.Account;
import com.tss.model.User;


@WebServlet("/CardApplicationServlet")
public class CardApplicationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public CardApplicationServlet() {
        super();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"Customer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Account> accounts = AccountDAO.getAccountsByUserId(user.getUserId());
        session.setAttribute("accounts", accounts);

        request.getRequestDispatcher("customer/apply_card.jsp").forward(request, response);	
        }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Customer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String accountNumber = request.getParameter("accountNumber");
        String cardType = request.getParameter("cardType");

        boolean applied = CardApplicationDAO.applyForCard(user.getUserId(), accountNumber, cardType);
        if (applied) {
            request.setAttribute("message", "Card application submitted successfully!");
        } else {
            request.setAttribute("error", "Failed to apply. You may have already applied.");
        }

        request.getRequestDispatcher("customer/apply_card.jsp").forward(request, response);
    }

}
