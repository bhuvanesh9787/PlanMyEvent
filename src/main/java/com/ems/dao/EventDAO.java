package com.ems.dao;

import com.ems.model.Event;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.*;

public class EventDAO {

    public boolean addEvent(Event e) throws SQLException {
        String sql =
            "INSERT INTO events(organiser_id,title,description,venue,event_date," +
            "event_time,total_seats,available_seats,ticket_price) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, e.getOrganiserId());
            ps.setString(2, e.getTitle());
            ps.setString(3, e.getDescription());
            ps.setString(4, e.getVenue());
            ps.setDate(5, e.getEventDate());
            ps.setTime(6, e.getEventTime());
            ps.setInt(7, e.getTotalSeats());
            ps.setInt(8, e.getTotalSeats());
            ps.setBigDecimal(9, e.getTicketPrice());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteEvent(int id) throws SQLException {
        String sql = "DELETE FROM events WHERE event_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean cancelEvent(int eventId) throws SQLException {
        String sql1 =
            "UPDATE events SET status='cancelled' WHERE event_id=?";
        String sql2 =
            "UPDATE bookings SET booking_status='refund_pending' WHERE event_id=?";
        String sql3 =
            "UPDATE payments SET payment_status='refunded' WHERE booking_id IN " +
            "(SELECT booking_id FROM bookings WHERE event_id=?)";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                PreparedStatement ps1 = con.prepareStatement(sql1);
                ps1.setInt(1, eventId);
                ps1.executeUpdate();

                PreparedStatement ps2 = con.prepareStatement(sql2);
                ps2.setInt(1, eventId);
                ps2.executeUpdate();

                PreparedStatement ps3 = con.prepareStatement(sql3);
                ps3.setInt(1, eventId);
                ps3.executeUpdate();

                con.commit();
                return true;
            } catch (Exception ex) {
                con.rollback();
                throw new SQLException(ex);
            }
        }
    }

    public Event getEventById(int id) throws SQLException {
        String sql = "SELECT * FROM events WHERE event_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public List<Event> getAllEvents() throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY event_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Event> getEventsByOrganiser(int organiserId) throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql =
            "SELECT * FROM events WHERE organiser_id=? ORDER BY event_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, organiserId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public List<Event> getAvailableEvents() throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql =
            "SELECT * FROM events WHERE status='upcoming' " +
            "AND available_seats>0 ORDER BY event_date ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Event mapRow(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setOrganiserId(rs.getInt("organiser_id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setVenue(rs.getString("venue"));
        e.setEventDate(rs.getDate("event_date"));
        e.setEventTime(rs.getTime("event_time"));
        e.setTotalSeats(rs.getInt("total_seats"));
        e.setAvailableSeats(rs.getInt("available_seats"));
        e.setTicketPrice(rs.getBigDecimal("ticket_price"));
        e.setStatus(rs.getString("status"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        return e;
    }
}