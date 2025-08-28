package com.tss.dao;

import com.tss.model.CardApplication;
import com.tss.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CardApplicationDAO {

    public static boolean applyForCard(int userId, String accountNumber, String cardType) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement check = con.prepareStatement(
                "SELECT id FROM card_applications WHERE user_id = ? AND account_number = ? AND card_type = ? AND status IN ('Pending', 'Approved')"
            );
            check.setInt(1, userId);
            check.setString(2, accountNumber);
            check.setString(3, cardType);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                return false; 
            }

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO card_applications (user_id, account_number, card_type) VALUES (?, ?, ?)"
            );
            ps.setInt(1, userId);
            ps.setString(2, accountNumber);
            ps.setString(3, cardType);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<CardApplication> getApplicationsByUser(int userId) {
        List<CardApplication> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM card_applications WHERE user_id = ? ORDER BY applied_at DESC"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CardApplication app = new CardApplication();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setAccountNumber(rs.getString("account_number"));
                app.setCardType(rs.getString("card_type"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<CardApplication> getAllPendingApplications() {
        List<CardApplication> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM card_applications WHERE status = 'Pending' ORDER BY applied_at DESC"
            );
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CardApplication app = new CardApplication();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setAccountNumber(rs.getString("account_number"));
                app.setCardType(rs.getString("card_type"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static boolean updateStatus(int appId, String newStatus) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "UPDATE card_applications SET status = ?, approved_at = CURRENT_TIMESTAMP WHERE id = ?"
            );
            ps.setString(1, newStatus);
            ps.setInt(2, appId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static List<CardApplication> getPendingApplications() {
        List<CardApplication> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM card_applications WHERE status = 'Pending'");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CardApplication app = new CardApplication();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setAccountNumber(rs.getString("account_number"));
                app.setCardType(rs.getString("card_type"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<CardApplication> getAllApplications() {
        List<CardApplication> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM card_applications ORDER BY applied_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CardApplication app = new CardApplication();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setAccountNumber(rs.getString("account_number"));
                app.setCardType(rs.getString("card_type"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<CardApplication> getApplicationsByStatus(String status) {
        List<CardApplication> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM card_applications WHERE status = ? ORDER BY applied_at DESC");
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CardApplication app = new CardApplication();
                app.setId(rs.getInt("id"));
                app.setUserId(rs.getInt("user_id"));
                app.setAccountNumber(rs.getString("account_number"));
                app.setCardType(rs.getString("card_type"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
