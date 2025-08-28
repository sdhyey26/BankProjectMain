package com.tss.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tss.service.*;
import com.tss.model.User;


/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setRole("Customer"); 

        user.setName(request.getParameter("name"));
        user.setMobile(request.getParameter("mobile"));
        user.setEmail(request.getParameter("email"));
        user.setAadhar(request.getParameter("aadhar"));
        user.setAccountType(request.getParameter("accountType"));
        user.setInitialDeposit(Double.parseDouble(request.getParameter("initialDeposit")));

        boolean success = AuthService.registerUserWithAccount(user);

        if (success) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Registration failed. Username or Aadhar may already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

}
