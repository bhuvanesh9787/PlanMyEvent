package com.ems.model;

public class OrganiserDetail {
    private int organiserId, userId;
    private String organisationName, address, idProof;

    public OrganiserDetail() {}

    public int getOrganiserId()         { return organiserId; }
    public int getUserId()              { return userId; }
    public String getOrganisationName() { return organisationName; }
    public String getAddress()          { return address; }
    public String getIdProof()          { return idProof; }

    public void setOrganiserId(int v)         { this.organiserId = v; }
    public void setUserId(int v)              { this.userId = v; }
    public void setOrganisationName(String v) { this.organisationName = v; }
    public void setAddress(String v)          { this.address = v; }
    public void setIdProof(String v)          { this.idProof = v; }
}