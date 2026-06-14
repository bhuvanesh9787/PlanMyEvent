<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,java.math.*" %>
<%
    User user     = (User)    session.getAttribute("loggedUser");
    Booking booking = (Booking) session.getAttribute("cancelledBooking");
    Event   event   = (Event)   session.getAttribute("cancelledEvent");
    Integer refundPct = (Integer) session.getAttribute("refundPercent");
    session.removeAttribute("cancelledBooking");
    session.removeAttribute("cancelledEvent");
    session.removeAttribute("refundPercent");
    if (user==null)    { response.sendRedirect("login.jsp"); return; }
    if (booking==null) { response.sendRedirect("participant_dashboard.jsp"); return; }
    int pct = (refundPct!=null)?refundPct:0;
    BigDecimal refundAmt = BigDecimal.ZERO;
    if (booking.getTotalAmount()!=null&&pct>0)
        refundAmt = booking.getTotalAmount().multiply(new BigDecimal(pct)).divide(new BigDecimal(100));
    BigDecimal nonRefund = booking.getTotalAmount()!=null?booking.getTotalAmount().subtract(refundAmt):BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Cancellation &amp; Refund — Plan My Event</title>
  <style>
    * { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Segoe UI',Arial,sans-serif; background:#f0f2f8; }
    .navbar {
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:16px 32px; display:flex; align-items:center; justify-content:space-between;
    }
    .navbar h1 { color:#fff; font-size:20px; font-weight:800; }
    .navbar a {
      color:#fff; text-decoration:none; font-size:13px; font-weight:600;
      padding:8px 18px; border-radius:20px; background:rgba(255,255,255,0.2);
    }
    .container { max-width:640px; margin:40px auto; padding:0 20px; }
    .card { background:#fff; border-radius:20px; overflow:hidden; box-shadow:0 8px 30px rgba(0,0,0,0.1); }
    .banner { padding:36px 24px; text-align:center; }
    .banner-100 { background:linear-gradient(135deg,#11998e,#38ef7d); }
    .banner-75  { background:linear-gradient(135deg,#2193b0,#6dd5ed); }
    .banner-50  { background:linear-gradient(135deg,#f7971e,#ffd200); }
    .banner-0   { background:linear-gradient(135deg,#fc4a1a,#f7b733); }
    .banner .icon { font-size:72px; margin-bottom:16px; }
    .banner h2 { color:#fff; font-size:24px; font-weight:800; margin-bottom:8px; }
    .banner p  { color:rgba(255,255,255,0.9); font-size:14px; }
    .card-body { padding:28px; }
    .summary {
      background:#f8f5ff; border-radius:14px; padding:20px; margin-bottom:22px;
    }
    .summary h3 { color:#7b2ff7; font-size:15px; font-weight:700; margin-bottom:14px; }
    .row {
      display:flex; justify-content:space-between; padding:9px 0;
      border-bottom:1px solid #f0e8ff; font-size:14px;
    }
    .row:last-child { border-bottom:none; }
    .row .lbl { color:#888; }
    .row .val { font-weight:600; color:#1a1a2e; }
    .refund-big { font-size:26px; font-weight:800; color:#11998e; }
    .policy-box {
      background:linear-gradient(135deg,#faf5ff,#fff0f8);
      border:2px solid #e8d5ff; border-radius:14px; padding:18px; margin-bottom:22px;
    }
    .policy-box h4 { color:#7b2ff7; margin-bottom:12px; font-size:14px; font-weight:700; }
    .prow {
      display:flex; justify-content:space-between; align-items:center;
      padding:8px 0; border-bottom:1px solid #f0e8ff; font-size:13px;
    }
    .prow:last-child { border-bottom:none; }
    .applied {
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff; font-size:11px; font-weight:700;
      padding:2px 8px; border-radius:10px; margin-left:8px;
    }
    .timeline { display:flex; flex-direction:column; gap:12px; margin-bottom:24px; }
    .tstep {
      display:flex; align-items:center; gap:14px; padding:14px;
      border-radius:12px; border-left:4px solid;
    }
    .tstep-done { background:#f0fff4; border-color:#27ae60; }
    .tstep-wait { background:#fffbf0; border-color:#f39c12; }
    .tstep .ti { font-size:22px; }
    .tstep .tt strong { display:block; color:#1a1a2e; font-size:14px; margin-bottom:2px; }
    .tstep .tt span   { font-size:12px; color:#888; }
    .btn-dash {
      display:block; width:100%; padding:14px; border:none; border-radius:14px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff; font-size:15px; font-weight:700; text-decoration:none;
      text-align:center; transition:all 0.3s; box-shadow:0 6px 20px rgba(123,47,247,0.35);
    }
    .btn-dash:hover { transform:translateY(-2px); }
  </style>
</head>
<body>
<nav class="navbar">
  <h1>💰 Plan My Event — Refund Status</h1>
  <a href="participant_dashboard.jsp">← Dashboard</a>
</nav>
<div class="container">
  <div class="card">

    <!-- Banner -->
    <div class="banner banner-<%= pct==100?"100":pct==75?"75":pct==50?"50":"0" %>">
      <div class="icon">
        <%= pct==100?"✅":pct==75?"💛":pct==50?"🟡":"❌" %>
      </div>
      <h2>
        <%= pct==100?"Full Refund Initiated!":
            pct==75 ?"75% Refund Initiated":
            pct==50 ?"50% Refund Initiated":
                     "No Refund Applicable" %>
      </h2>
      <p>
        <%= pct==100?"You cancelled 7+ days before the event — full refund approved.":
            pct==75 ?"You cancelled 3–6 days before the event.":
            pct==50 ?"You cancelled 1–2 days before the event.":
                     "Cancelled within 24 hours — no refund applicable per policy." %>
      </p>
    </div>

    <div class="card-body">

      <!-- Summary -->
      <div class="summary">
        <h3>📋 Cancellation Summary</h3>
        <div class="row"><span class="lbl">Booking ID</span><span class="val">#<%= booking.getBookingId() %></span></div>
        <div class="row"><span class="lbl">Event</span><span class="val"><%= event!=null?event.getTitle():"N/A" %></span></div>
        <div class="row"><span class="lbl">Amount Paid</span><span class="val">₹<%= booking.getTotalAmount() %></span></div>
        <div class="row"><span class="lbl">Refund Percentage</span>
          <span class="val" style="color:<%= pct==100?"#27ae60":pct==75?"#2980b9":pct==50?"#f39c12":"#e74c3c" %>">
            <%= pct %>%
          </span>
        </div>
        <div class="row"><span class="lbl">Refund Amount</span>
          <span class="val refund-big">₹<%= refundAmt.setScale(2,BigDecimal.ROUND_HALF_UP) %></span>
        </div>
        <div class="row"><span class="lbl">Non-refundable</span>
          <span class="val" style="color:#e74c3c">₹<%= nonRefund.setScale(2,BigDecimal.ROUND_HALF_UP) %></span>
        </div>
      </div>

      <!-- Policy Applied -->
      <div class="policy-box">
        <h4>📋 Refund Policy Applied</h4>
        <div class="prow">
          <span>📅 7+ days before event</span>
          <span style="color:#27ae60;font-weight:700">✅ 100% <% if(pct==100){%><span class="applied">Applied</span><%}%></span>
        </div>
        <div class="prow">
          <span>📅 3–6 days before event</span>
          <span style="color:#2980b9;font-weight:700">✅ 75% <% if(pct==75){%><span class="applied">Applied</span><%}%></span>
        </div>
        <div class="prow">
          <span>📅 1–2 days before event</span>
          <span style="color:#f39c12;font-weight:700">✅ 50% <% if(pct==50){%><span class="applied">Applied</span><%}%></span>
        </div>
        <div class="prow">
          <span>📅 Same day / Last 24 hours</span>
          <span style="color:#e74c3c;font-weight:700">❌ 0% <% if(pct==0){%><span class="applied">Applied</span><%}%></span>
        </div>
      </div>

      <!-- Timeline -->
      <% if (pct>0) { %>
      <h3 style="color:#1a1a2e;margin-bottom:14px;font-size:15px">⏳ Refund Timeline</h3>
      <div class="timeline">
        <div class="tstep tstep-done">
          <span class="ti">✅</span>
          <div class="tt">
            <strong>Cancellation Confirmed</strong>
            <span>Your booking #<%= booking.getBookingId() %> has been cancelled.</span>
          </div>
        </div>
        <div class="tstep tstep-wait">
          <span class="ti">⚙️</span>
          <div class="tt">
            <strong>Refund Processing</strong>
            <span>₹<%= refundAmt.setScale(2,BigDecimal.ROUND_HALF_UP) %> is being processed by our team.</span>
          </div>
        </div>
        <div class="tstep tstep-wait">
          <span class="ti">💳</span>
          <div class="tt">
            <strong>Refund to Original Payment Method</strong>
            <span>Expected within <strong>3–5 business days</strong>.</span>
          </div>
        </div>
      </div>
      <% } %>

      <a href="participant_dashboard.jsp" class="btn-dash">← Back to Dashboard</a>
    </div>
  </div>
</div>
</body>
</html>