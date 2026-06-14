package com.ems.dao;

import com.ems.model.OrganiserDetail;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.*;

public class OrganiserDAO {

    public boolean saveOrganiserDetails(OrganiserDetail od) throws SQLException {
        String sql =
            "INSERT INTO organiser_details(user_id,organisation_name,address,id_proof) " +
            "VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, od.getUserId());
            ps.setString(2, od.getOrganisationName());
            ps.setString(3, od.getAddress());
            ps.setString(4, od.getIdProof());
            return ps.executeUpdate() > 0;
        }
    }

    public OrganiserDetail getOrganiserDetail(int userId) throws SQLException {
        String sql = "SELECT * FROM organiser_details WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    public List<OrganiserDetail> getAllOrganiserDetails() throws SQLException {
        List<OrganiserDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM organiser_details";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private OrganiserDetail mapRow(ResultSet rs) throws SQLException {
        OrganiserDetail od = new OrganiserDetail();
        od.setOrganiserId(rs.getInt("organiser_id"));
        od.setUserId(rs.getInt("user_id"));
        od.setOrganisationName(rs.getString("organisation_name"));
        od.setAddress(rs.getString("address"));
        od.setIdProof(rs.getString("id_proof"));
        return od;
    }
}