package com.tss.dao;

import com.tss.model.Account;
import com.tss.util.DBConnection;

import java.sql.*;

public class TransferDAO {

    public static Account getAccountByType(int userId, String type) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM accounts WHERE user_id = ? AND account_type = ?");
            ps.setInt(1, userId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountNumber(rs.getString("account_number"));
                acc.setBalance(rs.getDouble("balance"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setUserId(rs.getInt("user_id"));
                return acc;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Account getAccountByNumber(String accNo) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM accounts WHERE account_number = ?");
            ps.setString(1, accNo);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account acc = new Account();
                acc.setAccountNumber(rs.getString("account_number"));
                acc.setBalance(rs.getDouble("balance"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setUserId(rs.getInt("user_id"));
                return acc;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean transferFunds(Account from, String toAccNo, double amount) {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            PreparedStatement ps1 = con.prepareStatement("UPDATE accounts SET balance = balance - ? WHERE account_number = ?");
            ps1.setDouble(1, amount);
            ps1.setString(2, from.getAccountNumber());
            int rows1 = ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement("UPDATE accounts SET balance = balance + ? WHERE account_number = ?");
            ps2.setDouble(1, amount);
            ps2.setString(2, toAccNo);
            int rows2 = ps2.executeUpdate();

            Account to = getAccountByNumber(toAccNo);
            if (to == null) {
                con.rollback();
                return false;
            }

            boolean debitLogged = insertTransaction(con, from.getAccountNumber(), toAccNo, amount, "DEBIT");

            boolean creditLogged = insertTransaction(con, toAccNo, from.getAccountNumber(), amount, "CREDIT");

            if (rows1 == 1 && rows2 == 1 && debitLogged && creditLogged) {
                con.commit();
                return true;
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private static boolean insertTransaction(Connection con, String fromAcc, String toAcc, double amount, String type) {
        try {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO transactions (from_account, to_account, amount, type, timestamp) VALUES (?, ?, ?, ?, NOW())"
            );
            ps.setString(1, fromAcc);
            ps.setString(2, toAcc);
            ps.setDouble(3, amount);
            ps.setString(4, type);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
