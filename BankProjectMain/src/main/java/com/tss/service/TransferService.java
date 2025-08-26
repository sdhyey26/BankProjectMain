package com.tss.service;

import com.tss.dao.TransferDAO;
import com.tss.model.Account;

public class TransferService {

    public String transferInternal(int userId, String fromType, double amount) {
        Account fromAcc = TransferDAO.getAccountByType(userId, fromType);
        String toType = fromType.equals("Savings") ? "Current" : "Savings";
        Account toAcc = TransferDAO.getAccountByType(userId, toType);

        if (fromAcc == null || toAcc == null) return "Both account types must exist.";
        if (fromAcc.getBalance() < amount) return "Insufficient balance.";

        boolean success = TransferDAO.transferFunds(fromAcc, toAcc.getAccountNumber(), amount);
        return success ? "Internal transfer successful." : "Transfer failed.";
    }

    public String transferExternal(String fromAccNo, String toAccNo, double amount) {
        Account from = TransferDAO.getAccountByNumber(fromAccNo);
        Account to = TransferDAO.getAccountByNumber(toAccNo);

        if (from == null) return "Sender account not found.";
        if (to == null) return "Recipient account not found.";
        if (from.getBalance() < amount) return "Insufficient balance.";

        boolean success = TransferDAO.transferFunds(from, toAccNo, amount);
        return success ? "Transfer successful." : "Transfer failed.";
    }
}
