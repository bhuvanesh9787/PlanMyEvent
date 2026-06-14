package com.ems.dao;

import com.ems.model.Payment;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.*;

public class PaymentDAO {

    public boolean savePayment(Payment p) throws SQLException {
        String sql =
            "INSERT INTO payments(booking_id,amount,payment_method,card_last4," +
            "transaction_id) VALUES(?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getBookingId());
            ps.setBigDecimal(2, p.getAmount());
            ps.setString(3, p.getPaymentMethod());
            ps.setString(4, p.getCardLast4());
            ps.setString(5, p.getTransactionId());
            return ps.executeUpdate() > 0;
        }
    }

    public Payment getPaymentByBooking(int bookingId) throws SQLException {
        String sql = "SELECT * FROM payments WHERE booking_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Payment mapRow(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setCardLast4(rs.getString("card_last4"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        return p;
    }
}