package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.AccountDAO;
import com.tss.dao.CardApplicationDAO;
import com.tss.dao.UserDAO;
import com.tss.model.Account;
import com.tss.model.CardApplication;
import com.tss.model.User;


@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public AdminDashboardServlet() {
        super();
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"Admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CardApplication> pendingCards = CardApplicationDAO.getPendingApplications();
        List<User> users = UserDAO.getAllUsersWithAccounts();
        List<Account> accounts = AccountDAO.getAllAccounts();

        request.setAttribute("pendingCards", pendingCards);
        request.setAttribute("users", users);
        request.setAttribute("accounts", accounts);

        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
