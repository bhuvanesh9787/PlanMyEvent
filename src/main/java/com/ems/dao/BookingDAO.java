package com.ems.dao;

import com.ems.model.Booking;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.*;

public class BookingDAO {

    public int createBooking(Booking b) throws SQLException {
        String sql =
            "INSERT INTO bookings(event_id,participant_id,seats_booked,total_amount) " +
            "VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                PreparedStatement ps =
                    con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, b.getEventId());
                ps.setInt(2, b.getParticipantId());
                ps.setInt(3, b.getSeatsBooked());
                ps.setBigDecimal(4, b.getTotalAmount());
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                int bookingId = 0;
                if (keys.next()) bookingId = keys.getInt(1);

                PreparedStatement ps2 = con.prepareStatement(
                    "UPDATE events SET available_seats=available_seats-? " +
                    "WHERE event_id=?");
                ps2.setInt(1, b.getSeatsBooked());
                ps2.setInt(2, b.getEventId());
                ps2.executeUpdate();

                con.commit();
                return bookingId;
            } catch (Exception ex) {
                con.rollback();
                throw new SQLException(ex);
            }
        }
    }

    public int cancelBookingByParticipant(int bookingId, java.sql.Date eventDate)
            throws SQLException {
        long today     = System.currentTimeMillis();
        long evTime    = eventDate.getTime();
        long diffDays  = (evTime - today) / (1000L * 60 * 60 * 24);

        int refundPercent;
        if      (diffDays >= 7) refundPercent = 100;
        else if (diffDays >= 3) refundPercent = 75;
        else if (diffDays >= 1) refundPercent = 50;
        else                    refundPercent = 0;

        String newBookingStatus  = refundPercent > 0 ? "refunded"  : "cancelled";
        String newPaymentStatus  = refundPercent > 0 ? "refunded"  : "failed";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                PreparedStatement ps1 = con.prepareStatement(
                    "UPDATE bookings SET booking_status=? WHERE booking_id=?");
                ps1.setString(1, newBookingStatus);
                ps1.setInt(2, bookingId);
                ps1.executeUpdate();

                PreparedStatement ps2 = con.prepareStatement(
                    "UPDATE payments SET payment_status=? WHERE booking_id=?");
                ps2.setString(1, newPaymentStatus);
                ps2.setInt(2, bookingId);
                ps2.executeUpdate();

                Booking bk = getBookingById(bookingId);
                if (bk != null) {
                    PreparedStatement ps3 = con.prepareStatement(
                        "UPDATE events SET available_seats=available_seats+? " +
                        "WHERE event_id=?");
                    ps3.setInt(1, bk.getSeatsBooked());
                    ps3.setInt(2, bk.getEventId());
                    ps3.executeUpdate();
                }

                con.commit();
            } catch (Exception ex) {
                con.rollback();
                throw new SQLException(ex);
            }
        }
        return refundPercent;
    }

    public Booking getBookingById(int id) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE booking_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public List<Booking> getBookingsByParticipant(int participantId)
            throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql =
            "SELECT * FROM bookings WHERE participant_id=? " +
            "ORDER BY booking_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, participantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Booking> getBookingsByEvent(int eventId) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql =
            "SELECT * FROM bookings WHERE event_id=? ORDER BY booking_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setEventId(rs.getInt("event_id"));
        b.setParticipantId(rs.getInt("participant_id"));
        b.setBookingDate(rs.getTimestamp("booking_date"));
        b.setSeatsBooked(rs.getInt("seats_booked"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setBookingStatus(rs.getString("booking_status"));
        return b;
    }
}