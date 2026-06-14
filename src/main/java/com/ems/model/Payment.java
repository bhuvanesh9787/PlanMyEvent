package com.ems.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId, bookingId;
    private BigDecimal amount;
    private String paymentMethod, cardLast4, transactionId, paymentStatus;
    private Timestamp paymentDate;

    public Payment() {}

    public int getPaymentId()         { return paymentId; }
    public int getBookingId()         { return bookingId; }
    public BigDecimal getAmount()     { return amount; }
    public String getPaymentMethod()  { return paymentMethod; }
    public String getCardLast4()      { return cardLast4; }
    public String getTransactionId()  { return transactionId; }
    public String getPaymentStatus()  { return paymentStatus; }
    public Timestamp getPaymentDate() { return paymentDate; }

    public void setPaymentId(int v)          { this.paymentId = v; }
    public void setBookingId(int v)          { this.bookingId = v; }
    public void setAmount(BigDecimal v)      { this.amount = v; }
    public void setPaymentMethod(String v)   { this.paymentMethod = v; }
    public void setCardLast4(String v)       { this.cardLast4 = v; }
    public void setTransactionId(String v)   { this.transactionId = v; }
    public void setPaymentStatus(String v)   { this.paymentStatus = v; }
    public void setPaymentDate(Timestamp v)  { this.paymentDate = v; }
}