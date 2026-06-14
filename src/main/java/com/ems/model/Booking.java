package com.ems.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {
    private int bookingId, eventId, participantId, seatsBooked;
    private BigDecimal totalAmount;
    private String bookingStatus;
    private Timestamp bookingDate;

    public Booking() {}

    public int getBookingId()          { return bookingId; }
    public int getEventId()            { return eventId; }
    public int getParticipantId()      { return participantId; }
    public int getSeatsBooked()        { return seatsBooked; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public String getBookingStatus()   { return bookingStatus; }
    public Timestamp getBookingDate()  { return bookingDate; }

    public void setBookingId(int v)          { this.bookingId = v; }
    public void setEventId(int v)            { this.eventId = v; }
    public void setParticipantId(int v)      { this.participantId = v; }
    public void setSeatsBooked(int v)        { this.seatsBooked = v; }
    public void setTotalAmount(BigDecimal v) { this.totalAmount = v; }
    public void setBookingStatus(String v)   { this.bookingStatus = v; }
    public void setBookingDate(Timestamp v)  { this.bookingDate = v; }
}