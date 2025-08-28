package com.tss.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tss.dao.TransferDAO;
import com.tss.model.Account;
import com.tss.model.User;
import com.tss.service.TransferService;


@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    TransferService service = new TransferService();       

    public TransferServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("customer/transfers.jsp");	}


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String type = request.getParameter("transferType");
        String fromType = request.getParameter("fromType");
        String toAccNo = request.getParameter("toAccountNumber");
        double amount = Double.parseDouble(request.getParameter("amount"));

        String msg = "";

        if ("internal".equals(type)) {
            msg = service.transferInternal(user.getUserId(), fromType, amount);
        } else {
            Account fromAcc = TransferDAO.getAccountByType(user.getUserId(), fromType);
            if (fromAcc == null) {
                msg = "Your selected account doesn't exist.";
            } else {
                msg = service.transferExternal(fromAcc.getAccountNumber(), toAccNo, amount);
            }
        }

        if (msg.contains("successful")) {
            request.setAttribute("message", msg);
        } else {
            request.setAttribute("error", msg);
        }

        request.getRequestDispatcher("customer/transfers.jsp").forward(request, response);
    }

}
