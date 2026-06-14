<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,java.text.*" %>
<%
    User user   = (User)    session.getAttribute("loggedUser");
    Booking b   = (Booking) request.getAttribute("booking");
    Event event = (Event)   request.getAttribute("event");
    Payment pay = (Payment) request.getAttribute("payment");
    String qrPath = (String) request.getAttribute("qrPath");
    if (user==null||b==null) { response.sendRedirect("login.jsp"); return; }
    SimpleDateFormat inFmt  = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat outFmt = new SimpleDateFormat("hh:mm a");
    String ts = "";
    try { if (event!=null&&event.getEventTime()!=null) ts=outFmt.format(inFmt.parse(event.getEventTime().toString())); }
    catch(Exception ex){}
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Confirmed — Plan My Event</title>
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
    .container { max-width:620px; margin:40px auto; padding:0 20px; }
    .card { background:#fff; border-radius:20px; overflow:hidden; box-shadow:0 8px 30px rgba(0,0,0,0.1); }
    .success-banner {
      background:linear-gradient(135deg,#11998e,#38ef7d);
      padding:36px 24px; text-align:center;
    }
    .success-banner .icon { font-size:72px; margin-bottom:14px; }
    .success-banner h2 { color:#fff; font-size:26px; font-weight:800; margin-bottom:6px; }
    .success-banner p  { color:rgba(255,255,255,0.9); font-size:14px; }
    .card-body { padding:28px; }
    .detail-grid {
      background:#f8f5ff; border-radius:14px; padding:20px; margin-bottom:22px;
    }
    .detail-row {
      display:flex; justify-content:space-between; padding:9px 0;
      border-bottom:1px solid #f0e8ff; font-size:14px;
    }
    .detail-row:last-child { border-bottom:none; }
    .detail-row .lbl { color:#888; }
    .detail-row .val { font-weight:600; color:#1a1a2e; text-align:right; max-width:60%; }
    .amount-big { font-size:28px; font-weight:800; color:#11998e; }
    .qr-box { text-align:center; padding:20px 0; }
    .qr-box img { width:180px; height:180px; border:3px solid #7b2ff7; border-radius:14px; }
    .qr-box p { color:#666; font-size:13px; margin-top:10px; }
    .btn-dash {
      display:block; width:100%; padding:14px; border:none; border-radius:14px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff; font-size:15px; font-weight:700; cursor:pointer;
      text-decoration:none; text-align:center; transition:all 0.3s;
      box-shadow:0 6px 20px rgba(123,47,247,0.35); margin-top:10px;
    }
    .btn-dash:hover { transform:translateY(-2px); }
    .txn-id { font-size:11px; color:#aaa; word-break:break-all; margin-top:4px; }
  </style>
</head>
<body>
<nav class="navbar">
  <h1>🎪 Plan My Event</h1>
  <a href="participant_dashboard.jsp">← Dashboard</a>
</nav>
<div class="container">
  <div class="card">
    <div class="success-banner">
      <div class="icon">✅</div>
      <h2>Booking Confirmed!</h2>
      <p>Your payment was successful and your seat is reserved.</p>
    </div>
    <div class="card-body">
      <div class="detail-grid">
        <div class="detail-row">
          <span class="lbl">Booking ID</span>
          <span class="val"><strong>#<%= b.getBookingId() %></strong></span>
        </div>
        <div class="detail-row">
          <span class="lbl">Event</span>
          <span class="val"><%= event!=null?event.getTitle():"N/A" %></span>
        </div>
        <div class="detail-row">
          <span class="lbl">Venue</span>
          <span class="val"><%= event!=null?event.getVenue():"N/A" %></span>
        </div>
        <div class="detail-row">
          <span class="lbl">Date &amp; Time</span>
          <span class="val">
            <%= event!=null?event.getEventDate():"" %>
            <%= !ts.isEmpty()?" at "+ts:"" %>
          </span>
        </div>
        <div class="detail-row">
          <span class="lbl">Seats Booked</span>
          <span class="val"><%= b.getSeatsBooked() %></span>
        </div>
        <div class="detail-row">
          <span class="lbl">Amount Paid</span>
          <span class="val amount-big">₹<%= b.getTotalAmount() %></span>
        </div>
        <div class="detail-row">
          <span class="lbl">Payment Method</span>
          <span class="val"><%= pay!=null&&"card".equals(pay.getPaymentMethod())?"💳 Card":"📱 QR Code" %></span>
        </div>
        <% if (pay!=null&&pay.getCardLast4()!=null) { %>
        <div class="detail-row">
          <span class="lbl">Card Used</span>
          <span class="val">**** **** **** <%= pay.getCardLast4() %></span>
        </div>
        <% } %>
        <div class="detail-row">
          <span class="lbl">Transaction ID</span>
          <span class="val">
            <span class="txn-id"><%= pay!=null?pay.getTransactionId():"—" %></span>
          </span>
        </div>
      </div>

      <% if (qrPath!=null) { %>
      <div class="qr-box">
        <img src="<%= request.getContextPath() %>/<%= qrPath %>" alt="Payment QR Code">
        <p>📱 Keep this QR code as your payment proof.</p>
      </div>
      <% } %>

      <a href="participant_dashboard.jsp" class="btn-dash">← Back to Dashboard</a>
    </div>
  </div>
</div>
</body>
</html>