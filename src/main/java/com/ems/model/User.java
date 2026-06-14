package com.ems.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String name, email, phone, passwordHash, role;
    private Timestamp createdAt;

    public User() {}

    public int getUserId()          { return userId; }
    public String getName()         { return name; }
    public String getEmail()        { return email; }
    public String getPhone()        { return phone; }
    public String getPasswordHash() { return passwordHash; }
    public String getRole()         { return role; }
    public Timestamp getCreatedAt() { return createdAt; }

    public void setUserId(int v)          { this.userId = v; }
    public void setName(String v)         { this.name = v; }
    public void setEmail(String v)        { this.email = v; }
    public void setPhone(String v)        { this.phone = v; }
    public void setPasswordHash(String v) { this.passwordHash = v; }
    public void setRole(String v)         { this.role = v; }
    public void setCreatedAt(Timestamp v) { this.createdAt = v; }
}