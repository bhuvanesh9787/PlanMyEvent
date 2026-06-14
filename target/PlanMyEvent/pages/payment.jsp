<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,java.text.*" %>
<%
    User user    = (User)    session.getAttribute("loggedUser");
    Booking booking = (Booking) session.getAttribute("pendingBooking");
    Event event     = (Event)   session.getAttribute("pendingEvent");
    if (user==null) { response.sendRedirect("login.jsp"); return; }
    if (booking==null||event==null) { response.sendRedirect("participant_dashboard.jsp"); return; }
    SimpleDateFormat inFmt  = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat outFmt = new SimpleDateFormat("hh:mm a");
    String ts = "";
    try { if (event.getEventTime()!=null) ts=outFmt.format(inFmt.parse(event.getEventTime().toString())); }
    catch(Exception ex){}
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Payment — Plan My Event</title>
  <style>
    * { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Segoe UI',Arial,sans-serif; background:#f0f2f8; }
    .navbar {
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:16px 32px; display:flex; align-items:center;
      justify-content:space-between;
    }
    .navbar h1 { color:#fff; font-size:20px; font-weight:800; }
    .navbar a {
      color:#fff; text-decoration:none; font-size:13px; font-weight:600;
      padding:8px 18px; border-radius:20px; background:rgba(255,255,255,0.2);
    }
    .container { max-width:640px; margin:36px auto; padding:0 20px; }
    .card { background:#fff; border-radius:18px; padding:28px; margin-bottom:22px; box-shadow:0 4px 20px rgba(0,0,0,0.08); }
    .summary-head {
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      border-radius:12px; padding:18px 20px; margin-bottom:18px; color:#fff;
    }
    .summary-head h3 { font-size:16px; margin-bottom:14px; }
    .summary-row { display:flex; justify-content:space-between; margin-bottom:8px; font-size:14px; }
    .summary-row .lbl { opacity:0.85; }
    .summary-row .val { font-weight:600; }
    .total-row {
      display:flex; justify-content:space-between; align-items:center;
      margin-top:14px; padding-top:14px; border-top:1px solid rgba(255,255,255,0.3);
    }
    .total-row .tl { font-size:14px; opacity:0.85; }
    .total-row .tv { font-size:26px; font-weight:800; }
    .tab-group { display:flex; gap:12px; margin-bottom:22px; }
    .tab {
      flex:1; padding:13px; border:2px solid #efefef;
      border-radius:14px; background:#fafafa; cursor:pointer;
      font-size:14px; font-weight:700; color:#888; text-align:center;
      transition:all 0.3s;
    }
    .tab.active {
      border-color:#7b2ff7; background:linear-gradient(135deg,#f5f0ff,#fce4ff);
      color:#7b2ff7;
    }
    .section-title { font-size:16px; font-weight:700; color:#1a1a2e; margin-bottom:18px; }
    .form-group { margin-bottom:18px; }
    .form-group label {
      display:block; font-size:11px; font-weight:700; color:#888;
      text-transform:uppercase; letter-spacing:0.7px; margin-bottom:8px;
    }
    .form-group input {
      width:100%; padding:13px 16px; border:2px solid #efefef;
      border-radius:12px; font-size:14px; background:#fafafa;
      transition:all 0.3s; outline:none;
    }
    .form-group input:focus { border-color:#7b2ff7; background:#fff; box-shadow:0 0 0 4px rgba(123,47,247,0.1); }
    .form-row { display:flex; gap:14px; }
    .form-row .form-group { flex:1; }
    .btn-pay {
      width:100%; padding:15px; border:none; border-radius:14px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff; font-size:16px; font-weight:700; cursor:pointer;
      transition:all 0.3s; box-shadow:0 6px 22px rgba(123,47,247,0.4);
    }
    .btn-pay:hover { transform:translateY(-2px); box-shadow:0 10px 30px rgba(123,47,247,0.5); }
    .qr-area { text-align:center; padding:30px 20px; }
    .qr-area .qr-icon { font-size:80px; margin-bottom:16px; }
    .qr-area p { color:#666; font-size:14px; margin-bottom:24px; line-height:1.6; }
    .btn-qr {
      display:inline-block; padding:14px 36px; border:none; border-radius:14px;
      background:linear-gradient(135deg,#11998e,#38ef7d);
      color:#fff; font-size:15px; font-weight:700; cursor:pointer;
      transition:all 0.3s; box-shadow:0 6px 20px rgba(17,153,142,0.4);
    }
    .btn-qr:hover { transform:translateY(-2px); }
    .qr-img-box { text-align:center; padding:20px 0; }
    .qr-img-box img { width:200px; height:200px; border:3px solid #7b2ff7; border-radius:14px; }
    .field-error { color:#e74c3c; font-size:12px; display:block; margin-top:4px; }
    .card-preview {
      background:linear-gradient(135deg,#1a1a2e,#533483);
      border-radius:16px; padding:22px 24px; margin-bottom:22px; color:#fff;
    }
    .card-preview .cn { font-size:20px; letter-spacing:4px; margin:14px 0; font-family:monospace; }
    .card-preview .cl { font-size:11px; opacity:0.6; text-transform:uppercase; letter-spacing:1px; }
    .card-preview .cv { font-size:15px; font-weight:600; }
  </style>
</head>
<body>
<nav class="navbar">
  <h1>💳 Plan My Event — Payment</h1>
<a href="<%= request.getContextPath() %>/login?action=logout">🚪 Logout</a>
</nav>

<div class="container">

  <!-- Summary -->
  <div class="card">
    <div class="summary-head">
      <h3>📋 Booking Summary</h3>
      <div class="summary-row"><span class="lbl">Event</span><span class="val"><%= event.getTitle() %></span></div>
      <div class="summary-row"><span class="lbl">Venue</span><span class="val"><%= event.getVenue() %></span></div>
      <div class="summary-row">
        <span class="lbl">Date &amp; Time</span>
        <span class="val"><%= event.getEventDate() %> <%= !ts.isEmpty()?"at "+ts:"" %></span>
      </div>
      <div class="summary-row"><span class="lbl">Seats</span><span class="val"><%= booking.getSeatsBooked() %></span></div>
      <div class="total-row">
        <span class="tl">Total Amount</span>
        <span class="tv">₹<%= booking.getTotalAmount() %></span>
      </div>
    </div>
  </div>

  <!-- Payment Method Tabs -->
  <div class="tab-group">
    <div class="tab active" id="tab-card" onclick="showTab('card')">💳 Pay by Card</div>
    <div class="tab" id="tab-qr" onclick="showTab('qr')">📱 Pay by QR Code</div>
  </div>

  <!-- Card Payment -->
  <div id="card-section" class="card">
    <p class="section-title">💳 Enter Card Details</p>
    <div class="card-preview">
      <div class="cl">Plan My Event — Secure Payment</div>
      <div class="cn" id="cardPreview">**** **** **** ****</div>
      <div style="display:flex;justify-content:space-between">
        <div><div class="cl">Card Holder</div><div class="cv" id="namePreview">YOUR NAME</div></div>
        <div><div class="cl">Expires</div><div class="cv" id="expPreview">MM/YY</div></div>
      </div>
    </div>
    <form action="<%= request.getContextPath() %>/payment" method="post">
      <input type="hidden" name="action" value="card">
      <div class="form-group">
        <label>Cardholder Name</label>
        <input type="text" name="cardName" id="cardName" required placeholder="Name on card"
               oninput="document.getElementById('namePreview').textContent=this.value||'YOUR NAME'">
      </div>
      <div class="form-group">
        <label>Card Number</label>
        <input type="text" id="cardNum" name="cardNumber" maxlength="19"
               required placeholder="1234 5678 9012 3456" oninput="formatCard(this)">
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Expiry (MM/YY)</label>
          <input type="text" name="expiry" id="expiry" required placeholder="MM/YY" maxlength="5"
                 oninput="document.getElementById('expPreview').textContent=this.value||'MM/YY'">
        </div>
        <div class="form-group">
          <label>CVV</label>
          <input type="password" name="cvv" required placeholder="***" maxlength="3">
        </div>
      </div>
      <button type="submit" class="btn-pay">🔒 Pay ₹<%= booking.getTotalAmount() %> Securely</button>
    </form>
  </div>

  <!-- QR Payment -->
  <div id="qr-section" class="card" style="display:none">
    <p class="section-title">📱 Pay by QR Code</p>
    <div class="qr-area">
      <div class="qr-icon">📱</div>
      <p>Click the button below to generate your unique payment QR code.<br>
         Scan it with any UPI app (GPay, PhonePe, Paytm) to complete payment.</p>
      <form action="<%= request.getContextPath() %>/payment" method="post">
        <input type="hidden" name="action" value="qr">
        <button type="submit" class="btn-qr">⚡ Generate QR Code</button>
      </form>
    </div>
  </div>

</div>

<script>
function showTab(tab) {
  document.getElementById('card-section').style.display = tab==='card'?'block':'none';
  document.getElementById('qr-section').style.display   = tab==='qr'  ?'block':'none';
  document.getElementById('tab-card').classList.toggle('active', tab==='card');
  document.getElementById('tab-qr').classList.toggle('active', tab==='qr');
}
function formatCard(input) {
  let val = input.value.replace(/\D/g,'').substring(0,16);
  let fmt = val.replace(/(.{4})/g,'$1 ').trim();
  input.value = fmt;
  let masked = (val+'****************').substring(0,16).replace(/\d(?=.{4})/g,'*');
  let disp = masked.replace(/(.{4})/g,'$1 ').trim();
  document.getElementById('cardPreview').textContent = disp || '**** **** **** ****';
}
</script>
</body>
</html>