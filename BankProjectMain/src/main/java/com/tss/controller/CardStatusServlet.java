package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.CardApplicationDAO;
import com.tss.model.CardApplication;
import com.tss.model.User;


@WebServlet("/CardStatusServlet")
public class CardStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public CardStatusServlet() {
        super();
    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"Customer".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<CardApplication> applications = CardApplicationDAO.getApplicationsByUser(user.getUserId());
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("customer/card_status.jsp").forward(request, response);
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
