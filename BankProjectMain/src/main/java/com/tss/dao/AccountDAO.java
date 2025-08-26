package com.tss.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.tss.model.Account;
import com.tss.util.DBConnection;

public class AccountDAO {

	public static Account getAccountByUserId(int userId) {
	    Account account = null;
	    try (Connection con = DBConnection.getConnection()) {
	        PreparedStatement ps = con.prepareStatement("SELECT * FROM accounts WHERE user_id = ?");
	        ps.setInt(1, userId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            account = new Account();
	            account.setAccountNumber(rs.getString("account_number"));
	            account.setAccountType(rs.getString("account_type"));
	            account.setBalance(rs.getDouble("balance"));
	            account.setUserId(userId); 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return account;
	}
	
	public static List<Account> getAccountsByUserId(int userId) {
	    List<Account> list = new ArrayList<>();
	    try (Connection con = DBConnection.getConnection()) {
	        PreparedStatement ps = con.prepareStatement("SELECT * FROM accounts WHERE user_id = ?");
	        ps.setInt(1, userId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Account acc = new Account();
	            acc.setAccountNumber(rs.getString("account_number"));
	            acc.setBalance(rs.getDouble("balance"));
	            acc.setAccountType(rs.getString("account_type"));
	            acc.setUserId(rs.getInt("user_id"));
	            list.add(acc);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	public static List<Account> getAllAccounts() {
	    List<Account> accounts = new ArrayList<>();

	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT account_number, account_type, balance, user_id FROM accounts";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            Account acc = new Account();
	            acc.setAccountNumber(rs.getString("account_number"));
	            acc.setAccountType(rs.getString("account_type"));
	            acc.setBalance(rs.getDouble("balance"));
	            acc.setUserId(rs.getInt("user_id"));
	            accounts.add(acc);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return accounts;
	}
	
	public static Account getAccountByNumber(String accountNumber) {
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT * FROM accounts WHERE account_number = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, accountNumber);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            Account acc = new Account();
	            acc.setAccountNumber(rs.getString("account_number"));
	            acc.setAccountType(rs.getString("account_type"));
	            acc.setBalance(rs.getDouble("balance"));
	            acc.setUserId(rs.getInt("user_id"));
	            return acc;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public static boolean updateAccount(Account account) {
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "UPDATE accounts SET account_type = ?, balance = ? WHERE account_number = ?";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ps.setString(1, account.getAccountType());
	        ps.setDouble(2, account.getBalance());
	        ps.setString(3, account.getAccountNumber());
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	public static boolean deleteAccountByNumber(String accountNumber) {
	    try (Connection con = DBConnection.getConnection()) {
	        PreparedStatement ps = con.prepareStatement("DELETE FROM accounts WHERE account_number = ?");
	        ps.setString(1, accountNumber);
	        return ps.executeUpdate() > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public static Map<String, Integer> getAccountTypeStats() {
	    Map<String, Integer> stats = new HashMap<>();
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT account_type, COUNT(*) as count FROM accounts GROUP BY account_type";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            stats.put(rs.getString("account_type"), rs.getInt("count"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return stats;
	}

	public static Map<String, Double> getTotalBalanceByType() {
	    Map<String, Double> map = new HashMap<>();
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT account_type, SUM(balance) as total FROM accounts GROUP BY account_type";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            map.put(rs.getString("account_type"), rs.getDouble("total"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return map; 
	}


	public static Map<String, Integer> getMonthlyAccountStats() {
	    Map<String, Integer> stats = new LinkedHashMap<>();
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as count FROM accounts GROUP BY month ORDER BY month";
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

	public static List<Map<String, Object>> getTopUsersByBalance() {
	    List<Map<String, Object>> topUsers = new ArrayList<>();
	    try (Connection con = DBConnection.getConnection()) {
	        String sql = "SELECT a.name, SUM(a.balance) as total FROM accounts a GROUP BY a.name ORDER BY total DESC LIMIT 5";
	        PreparedStatement ps = con.prepareStatement(sql);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Map<String, Object> data = new HashMap<>();
	            data.put("name", rs.getString("name"));
	            data.put("balance", rs.getDouble("total"));
	            topUsers.add(data);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return topUsers;
	}

}
