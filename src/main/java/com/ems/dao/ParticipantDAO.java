package com.ems.dao;

import com.ems.model.ParticipantDetail;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ParticipantDAO {

    public boolean saveParticipantDetails(ParticipantDetail pd) throws SQLException {
        String sql =
            "INSERT INTO participant_details(user_id,age,address) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pd.getUserId());
            ps.setInt(2, pd.getAge());
            ps.setString(3, pd.getAddress());
            return ps.executeUpdate() > 0;
        }
    }

    public ParticipantDetail getParticipantDetail(int userId) throws SQLException {
        String sql = "SELECT * FROM participant_details WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public List<ParticipantDetail> getAllParticipantDetails() throws SQLException {
        List<ParticipantDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM participant_details";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private ParticipantDetail mapRow(ResultSet rs) throws SQLException {
        ParticipantDetail pd = new ParticipantDetail();
        pd.setParticipantId(rs.getInt("participant_id"));
        pd.setUserId(rs.getInt("user_id"));
        pd.setAge(rs.getInt("age"));
        pd.setAddress(rs.getString("address"));
        return pd;
    }
}