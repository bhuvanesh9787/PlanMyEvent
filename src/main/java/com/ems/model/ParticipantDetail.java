package com.ems.model;

public class ParticipantDetail {
    private int participantId, userId, age;
    private String address;

    public ParticipantDetail() {}

    public int getParticipantId() { return participantId; }
    public int getUserId()        { return userId; }
    public int getAge()           { return age; }
    public String getAddress()    { return address; }

    public void setParticipantId(int v) { this.participantId = v; }
    public void setUserId(int v)        { this.userId = v; }
    public void setAge(int v)           { this.age = v; }
    public void setAddress(String v)    { this.address = v; }
}