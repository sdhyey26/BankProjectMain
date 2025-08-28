package com.tss.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import com.tss.model.Account;
import com.tss.model.User;
import com.tss.util.DBConnection;

public class UserDAO {

    public static boolean createUserAndAccount(User user) {
        try (Connection con = DBConnection.getConnection()) {
            String checkQuery = "SELECT 1 FROM accounts WHERE aadhar = ? AND account_type = ?";
            PreparedStatement check = con.prepareStatement(checkQuery);
            check.setString(1, user.getAadhar());
            check.setString(2, user.getAccountType());
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                return false;
            }

            String userCheckQuery = "SELECT user_id FROM users WHERE username = ?";
            PreparedStatement userCheck = con.prepareStatement(userCheckQuery);
            userCheck.setString(1, user.getUsername());
            ResultSet userRs = userCheck.executeQuery();

            int userId;
            if (userRs.next()) {
                userId = userRs.getInt("user_id");
            } else {
                String insertUser = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
                PreparedStatement ps1 = con.prepareStatement(insertUser, PreparedStatement.RETURN_GENERATED_KEYS);
                ps1.setString(1, user.getUsername());
                ps1.setString(2, user.getPassword());
                ps1.setString(3, "Customer");
                ps1.executeUpdate();

                ResultSet keys = ps1.getGeneratedKeys();
                if (keys.next()) {
                    userId = keys.getInt(1);
                } else {
                    return false;
                }
            }

            String accountNumber = "100" + (int) (Math.random() * 1000000);
            String insertAccount = "INSERT INTO accounts (user_id, account_number, name, mobile, email, aadhar, account_type, balance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps2 = con.prepareStatement(insertAccount);
            ps2.setInt(1, userId);
            ps2.setString(2, accountNumber);
            ps2.setString(3, user.getName());
            ps2.setString(4, user.getMobile());
            ps2.setString(5, user.getEmail());
            ps2.setString(6, user.getAadhar());
            ps2.setString(7, user.getAccountType());
            ps2.setDouble(8, user.getInitialDeposit());
            ps2.executeUpdate();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static User getUserByCredentials(String username, String password, String role) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT u.*, a.name , a.email FROM users u " +
                         "LEFT JOIN accounts a ON u.user_id = a.user_id " +
                         "WHERE u.username = ? AND u.password = ? AND u.role = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static List<User> getAllUsersWithAccounts() {
        Map<Integer, User> userMap = new HashMap<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT u.user_id, u.username, u.role, u.aadhar, " +
                         "a.account_number, a.account_type, a.balance, a.email , a.name " +
                         "FROM users u " +
                         "JOIN accounts a ON u.user_id = a.user_id " +
                         "WHERE u.role = 'Customer'";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int userId = rs.getInt("user_id");
                User u;

                if (!userMap.containsKey(userId)) {
                    u = new User();
                    u.setUserId(userId);
                    u.setUsername(rs.getString("username"));
                    u.setRole(rs.getString("role"));
                    u.setAadhar(rs.getString("aadhar"));
                    u.setAccounts(new ArrayList<>());
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("name"));
                    userMap.put(userId, u);
                } else {
                    u = userMap.get(userId);
                }

                Account acc = new Account();
                acc.setAccountNumber(rs.getString("account_number"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setBalance(rs.getDouble("balance"));
                acc.setUserId(userId);

                u.getAccounts().add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>(userMap.values());
    }

    public static User getUserById(int userId) {
        User user = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT u.user_id, u.username, a.name, a.email, u.role " +
                         "FROM users u JOIN accounts a ON u.user_id = a.user_id " +
                         "WHERE u.user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public static boolean updateUser(User user) {
        try (Connection con = DBConnection.getConnection()) {
            String updateUserSQL = "UPDATE users SET username = ? WHERE user_id = ?";
            PreparedStatement psUser = con.prepareStatement(updateUserSQL);
            psUser.setString(1, user.getUsername());
            psUser.setInt(2, user.getUserId());

            int userRows = psUser.executeUpdate();

            String updateAccountSQL = "UPDATE accounts SET email = ?, name = ? WHERE user_id = ?";
            PreparedStatement psAccount = con.prepareStatement(updateAccountSQL);
            psAccount.setString(1, user.getEmail());
            psAccount.setString(2, user.getFullName());
            psAccount.setInt(3, user.getUserId());

            int accountRows = psAccount.executeUpdate();

            return userRows > 0 && accountRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean deleteUserById(int userId) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
