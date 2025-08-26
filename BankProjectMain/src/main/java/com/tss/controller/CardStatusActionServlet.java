package com.tss.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.CardApplicationDAO;


@WebServlet("/CardStatusActionServlet")
public class CardStatusActionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int appId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");  

        String newStatus = "Rejected"; 
        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "Approved";
        }

        boolean success = CardApplicationDAO.updateStatus(appId, newStatus);

        HttpSession session = request.getSession();
        if (success) {
            session.setAttribute("message", "Application " + newStatus.toLowerCase() + " successfully.");
        } else {
            session.setAttribute("error", "Failed to update application status.");
        }

        response.sendRedirect("ManageCardRequestsServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ManageCardRequestsServlet");
    }
}
