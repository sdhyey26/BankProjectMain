package com.tss.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tss.dao.CardApplicationDAO;
import com.tss.model.CardApplication;


@WebServlet("/ManageCardRequestsServlet")
public class ManageCardRequestsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ManageCardRequestsServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status"); 
        List<CardApplication> applications;

        if (status != null && !status.trim().isEmpty()) {
            applications = CardApplicationDAO.getApplicationsByStatus(status);
        } else {
            applications = CardApplicationDAO.getAllApplications();
        }

        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/admin/manage_card_requests.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
