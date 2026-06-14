package com.ems.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Event {
    private int eventId, organiserId, totalSeats, availableSeats;
    private String title, description, venue, status;
    private Date eventDate;
    private Time eventTime;
    private BigDecimal ticketPrice;
    private Timestamp createdAt;

    public Event() {}

    public int getEventId()            { return eventId; }
    public int getOrganiserId()        { return organiserId; }
    public int getTotalSeats()         { return totalSeats; }
    public int getAvailableSeats()     { return availableSeats; }
    public String getTitle()           { return title; }
    public String getDescription()     { return description; }
    public String getVenue()           { return venue; }
    public String getStatus()          { return status; }
    public Date getEventDate()         { return eventDate; }
    public Time getEventTime()         { return eventTime; }
    public BigDecimal getTicketPrice() { return ticketPrice; }
    public Timestamp getCreatedAt()    { return createdAt; }

    public void setEventId(int v)            { this.eventId = v; }
    public void setOrganiserId(int v)        { this.organiserId = v; }
    public void setTotalSeats(int v)         { this.totalSeats = v; }
    public void setAvailableSeats(int v)     { this.availableSeats = v; }
    public void setTitle(String v)           { this.title = v; }
    public void setDescription(String v)     { this.description = v; }
    public void setVenue(String v)           { this.venue = v; }
    public void setStatus(String v)          { this.status = v; }
    public void setEventDate(Date v)         { this.eventDate = v; }
    public void setEventTime(Time v)         { this.eventTime = v; }
    public void setTicketPrice(BigDecimal v) { this.ticketPrice = v; }
    public void setCreatedAt(Timestamp v)    { this.createdAt = v; }
}