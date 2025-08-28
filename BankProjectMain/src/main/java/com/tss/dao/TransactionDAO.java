package com.tss.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.tss.model.Transaction;
import com.tss.util.DBConnection;

public class TransactionDAO {

	
	
	public static Transaction getLastTransaction(String accountNumber) {
	    Transaction txn = null;
	    try (Connection con = DBConnection.getConnection()) {
	        PreparedStatement ps = con.prepareStatement(
	            "SELECT * FROM transactions WHERE from_account = ? OR to_account = ? ORDER BY timestamp DESC LIMIT 1"
	        );
	        ps.setString(1, accountNumber);
	        ps.setString(2, accountNumber);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            txn = new Transaction();
	            txn.setFromAccount(rs.getString("from_account"));
	            txn.setToAccount(rs.getString("to_account"));
	            txn.setAmount(rs.getDouble("amount"));
	            txn.setType(rs.getString("type"));
	            txn.setTimestamp(rs.getTimestamp("timestamp"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return txn;
	}
	
    public static List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM transactions ORDER BY timestamp DESC");
           
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction txn = new Transaction();
                txn.setId(rs.getInt("id"));
                txn.setFromAccount(rs.getString("from_account"));
                txn.setToAccount(rs.getString("to_account"));
                txn.setAmount(rs.getDouble("amount"));
                txn.setType(rs.getString("type"));
                txn.setTimestamp(rs.getTimestamp("timestamp"));
                list.add(txn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<Transaction> getFilteredTransactions(String accountNumber, String type, String from, String to) {
        List<Transaction> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM transactions WHERE (from_account = ? OR to_account = ?)");

        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ?");
        }
        if (from != null && !from.isEmpty()) {
            sql.append(" AND DATE(timestamp) >= ?");
        }
        if (to != null && !to.isEmpty()) {
            sql.append(" AND DATE(timestamp) <= ?");
        }

        sql.append(" ORDER BY timestamp DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setString(idx++, accountNumber);
            ps.setString(idx++, accountNumber);

            if (type != null && !type.isEmpty()) {
                ps.setString(idx++, type);
            }
            if (from != null && !from.isEmpty()) {
                ps.setString(idx++, from);
            }
            if (to != null && !to.isEmpty()) {
                ps.setString(idx++, to);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction txn = new Transaction();
                txn.setId(rs.getInt("id"));
                txn.setFromAccount(rs.getString("from_account"));
                txn.setToAccount(rs.getString("to_account"));
                txn.setAmount(rs.getDouble("amount"));
                txn.setType(rs.getString("type"));
                txn.setTimestamp(rs.getTimestamp("timestamp"));
                list.add(txn);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static List<Transaction> getTransactionsByAccount(String accountNumber) {
        List<Transaction> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM transactions WHERE from_account = ? OR to_account = ? ORDER BY timestamp DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, accountNumber);
            ps.setString(2, accountNumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction t = new Transaction();
                t.setId(rs.getInt("id"));
                t.setFromAccount(rs.getString("from_account"));
                t.setToAccount(rs.getString("to_account"));
                t.setAmount(rs.getDouble("amount"));
                t.setType(rs.getString("type"));
                t.setTimestamp(rs.getTimestamp("timestamp"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public static Map<String, Integer> getMonthlyTransactionStats() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT DATE_FORMAT(timestamp, '%Y-%m') as month, COUNT(*) as count FROM transactions GROUP BY month ORDER BY month";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("month"), rs.getInt("count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }


}
