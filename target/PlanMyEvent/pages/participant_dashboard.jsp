<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,com.ems.dao.*,java.util.*,java.text.*" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"participant".equals(user.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Event>   available  = new EventDAO().getAvailableEvents();
    List<Booking> myBookings = new BookingDAO().getBookingsByParticipant(user.getUserId());
    EventDAO eDao = new EventDAO();
    SimpleDateFormat inFmt  = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat outFmt = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Participant Dashboard — Plan My Event</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f2f8;}
    .navbar{
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:16px 32px;display:flex;align-items:center;
      justify-content:space-between;
      box-shadow:0 4px 20px rgba(123,47,247,0.35);
      position:sticky;top:0;z-index:100;
    }
    .navbar h1{color:#fff;font-size:20px;font-weight:800;}
    .navbar .nr{display:flex;align-items:center;gap:10px;}
    .navbar .uinfo{color:rgba(255,255,255,0.85);font-size:13px;}
    .navbar a{
      color:#fff;text-decoration:none;font-size:13px;font-weight:600;
      padding:8px 18px;border-radius:20px;background:rgba(255,255,255,0.2);
      transition:all 0.3s;
    }
    .navbar a:hover{background:rgba(255,255,255,0.35);}
    .container{max-width:1150px;margin:30px auto;padding:0 24px;}
    .card{
      background:#fff;border-radius:18px;margin-bottom:26px;
      box-shadow:0 4px 20px rgba(0,0,0,0.07);overflow:hidden;
    }
    .card-head{
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:18px 24px;display:flex;align-items:center;
      justify-content:space-between;flex-wrap:wrap;gap:12px;
    }
    .card-head h2{color:#fff;font-size:17px;font-weight:700;}

    /* ── Search Bar ── */
    .search-wrap{
      display:flex;align-items:center;gap:8px;
      background:rgba(255,255,255,0.2);
      border:1.5px solid rgba(255,255,255,0.4);
      border-radius:25px;padding:6px 14px;
      transition:all 0.3s;min-width:240px;
    }
    .search-wrap:focus-within{
      background:rgba(255,255,255,0.35);
      border-color:rgba(255,255,255,0.7);
    }
    .search-wrap input{
      background:transparent;border:none;outline:none;
      color:#fff;font-size:13px;flex:1;
    }
    .search-wrap input::placeholder{color:rgba(255,255,255,0.7);}
    .search-count{font-size:12px;color:rgba(255,255,255,0.8);white-space:nowrap;}

    .card-body{padding:24px;}
    .policy-box{
      background:linear-gradient(135deg,#faf5ff,#fff0f8);
      border:2px solid #e8d5ff;border-radius:14px;padding:20px;
    }
    .policy-box h4{color:#7b2ff7;margin-bottom:14px;font-size:15px;font-weight:700;}
    .refund-row{
      display:flex;justify-content:space-between;align-items:center;
      padding:9px 0;border-bottom:1px solid #f0e8ff;
    }
    .refund-row:last-child{border-bottom:none;}
    .refund-row .days{color:#555;font-size:13px;}
    .refund-row .pct{font-weight:700;font-size:14px;}
    .p100{color:#27ae60;} .p75{color:#2980b9;} .p50{color:#f39c12;} .p0{color:#e74c3c;}

    /* Event Cards Grid */
    .event-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(290px,1fr));gap:20px;}
    .event-card{
      background:#fff;border-radius:16px;padding:22px;
      box-shadow:0 4px 16px rgba(0,0,0,0.08);border-top:5px solid;
      transition:transform 0.3s,box-shadow 0.3s;
    }
    .event-card:hover{transform:translateY(-4px);box-shadow:0 12px 30px rgba(0,0,0,0.12);}
    .event-card:nth-child(4n+1){border-top-color:#7b2ff7;}
    .event-card:nth-child(4n+2){border-top-color:#11998e;}
    .event-card:nth-child(4n+3){border-top-color:#f107a3;}
    .event-card:nth-child(4n+4){border-top-color:#f7971e;}
    .event-card h3{color:#1a1a2e;font-size:16px;font-weight:700;margin-bottom:12px;}
    .event-card p{font-size:13px;color:#666;margin-bottom:7px;}
    .event-card .price{font-size:24px;font-weight:800;color:#11998e;margin:12px 0;}
    .time-am{background:#fff3cd;color:#856404;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .time-pm{background:#cfe2ff;color:#084298;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .form-group{margin-bottom:14px;}
    .form-group label{
      display:block;font-size:11px;font-weight:700;color:#888;
      text-transform:uppercase;letter-spacing:0.6px;margin-bottom:6px;
    }
    .form-group input{
      width:100%;padding:11px 14px;border:2px solid #efefef;
      border-radius:10px;font-size:14px;outline:none;transition:all 0.3s;
    }
    .form-group input:focus{border-color:#7b2ff7;box-shadow:0 0 0 3px rgba(123,47,247,0.1);}
    .btn-book{
      width:100%;padding:12px;border:none;border-radius:12px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff;font-size:14px;font-weight:700;cursor:pointer;transition:all 0.3s;
    }
    .btn-book:hover{transform:translateY(-2px);box-shadow:0 6px 18px rgba(123,47,247,0.4);}
    table{width:100%;border-collapse:collapse;font-size:13px;}
    th{
      background:#faf5ff;color:#7b2ff7;padding:12px 16px;
      text-align:left;font-weight:700;font-size:12px;
      text-transform:uppercase;letter-spacing:0.5px;
      border-bottom:2px solid #f0e8ff;
    }
    td{padding:13px 16px;border-bottom:1px solid #f8f5ff;vertical-align:middle;}
    tr:last-child td{border-bottom:none;}
    tr:hover td{background:#fdf9ff;}
    .badge{
      display:inline-block;padding:4px 12px;border-radius:20px;
      font-size:11px;font-weight:700;
    }
    .b-confirmed{background:#e9f7ef;color:#1e8449;}
    .b-cancelled{background:#fdedec;color:#c0392b;}
    .b-refund_pending{background:#fef9e7;color:#9a7d0a;}
    .b-refunded{background:#f5eef8;color:#6c3483;}
    .btn-cancel{
      padding:7px 14px;border:none;border-radius:16px;cursor:pointer;
      background:linear-gradient(135deg,#fc4a1a,#f7b733);
      color:#fff;font-size:12px;font-weight:700;transition:all 0.3s;
    }
    .btn-cancel:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(252,74,26,0.4);}
    .empty-state{text-align:center;padding:50px 20px;color:#aaa;}
    .empty-state .ei{font-size:60px;margin-bottom:14px;}
    .no-results{text-align:center;padding:30px;color:#aaa;font-size:14px;display:none;}
    .event-card.hidden-card{display:none;}
    .no-events-msg{
      text-align:center;padding:30px;color:#aaa;
      font-size:14px;display:none;
      grid-column:1/-1;
    }
  </style>
</head>
<body>
<nav class="navbar">
  <h1>🎟️ Plan My Event — Participant Portal</h1>
  <div class="nr">
    <span class="uinfo">👤 <%= user.getName() %></span>
    <a href="<%= request.getContextPath() %>/login?action=logout">🚪 Logout</a>
  </div>
</nav>

<div class="container">

  <!-- Refund Policy -->
  <div class="card">
    <div class="card-head"><h2>💡 Cancellation &amp; Refund Policy</h2></div>
    <div class="card-body">
      <div class="policy-box">
        <h4>If YOU cancel your booking:</h4>
        <div class="refund-row">
          <span class="days">📅 7 or more days before event</span>
          <span class="pct p100">✅ 100% Refund</span>
        </div>
        <div class="refund-row">
          <span class="days">📅 3 – 6 days before event</span>
          <span class="pct p75">✅ 75% Refund</span>
        </div>
        <div class="refund-row">
          <span class="days">📅 1 – 2 days before event</span>
          <span class="pct p50">✅ 50% Refund</span>
        </div>
        <div class="refund-row">
          <span class="days">📅 Same day / Last 24 hours</span>
          <span class="pct p0">❌ No Refund</span>
        </div>
      </div>
      <p style="font-size:12px;color:#aaa;margin-top:12px">
        * If the organiser cancels — you get a <strong>100% refund within 3 business days</strong> automatically.
      </p>
    </div>
  </div>

  <!-- Available Events -->
  <div class="card">
    <div class="card-head">
      <h2>🎪 Available Events</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span style="font-size:14px;color:rgba(255,255,255,0.8)">🔍</span>
          <input type="text" id="partEventSearch"
                 placeholder="Search event by name or venue..."
                 oninput="filterPartEvents()">
        </div>
        <span class="search-count" id="partEventCount"></span>
      </div>
    </div>
    <div class="card-body">
      <% if (available.isEmpty()) { %>
        <div class="empty-state">
          <div class="ei">🔍</div>
          <p>No events available right now. Check back soon!</p>
        </div>
      <% } else { %>
      <div class="event-grid" id="eventCardGrid">
        <% for (Event e : available) {
             String ts = "";
             try { if(e.getEventTime()!=null) ts=outFmt.format(inFmt.parse(e.getEventTime().toString())); }
             catch(Exception ex){}
             boolean isAM = ts.toUpperCase().contains("AM");
        %>
        <div class="event-card"
             data-title="<%= e.getTitle().toLowerCase() %>"
             data-venue="<%= e.getVenue().toLowerCase() %>">
          <h3><%= e.getTitle() %></h3>
          <p>📍 <%= e.getVenue() %></p>
          <p>📅 <%= e.getEventDate() %>
            <% if (!ts.isEmpty()) { %>
              &nbsp;<span class="<%= isAM?"time-am":"time-pm" %>">🕐 <%= ts %></span>
            <% } %>
          </p>
          <p>🪑 <strong><%= e.getAvailableSeats() %></strong> seats left of <%= e.getTotalSeats() %></p>
          <div class="price">₹<%= e.getTicketPrice() %></div>
          <form action="<%= request.getContextPath() %>/booking" method="post">
            <input type="hidden" name="action" value="book">
            <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
            <div class="form-group">
              <label>Number of Seats</label>
              <input type="number" name="seats" value="1"
                     min="1" max="<%= e.getAvailableSeats() %>" required>
            </div>
            <button type="submit" class="btn-book">🎟️ Book Now</button>
          </form>
        </div>
        <% } %>
        <div class="no-events-msg" id="partEventNoResults">
          🔍 No events found matching "<span id="searchTermDisplay"></span>"
        </div>
      </div>
      <% } %>
    </div>
  </div>

  <!-- My Bookings -->
  <div class="card">
    <div class="card-head">
      <h2>📋 My Bookings</h2>
    </div>
    <div class="card-body">
      <% if (myBookings.isEmpty()) { %>
        <div class="empty-state">
          <div class="ei">🎫</div>
          <p>No bookings yet. Book an event above!</p>
        </div>
      <% } else { %>
      <table>
        <tr>
          <th>Booking ID</th><th>Event</th><th>Date &amp; Time</th>
          <th>Seats</th><th>Amount</th><th>Status</th><th>Action</th>
        </tr>
        <% for (Booking b : myBookings) {
             Event ev = eDao.getEventById(b.getEventId());
             String evTime = "";
             try {
               if(ev!=null&&ev.getEventTime()!=null)
                 evTime=outFmt.format(inFmt.parse(ev.getEventTime().toString()));
             } catch(Exception ex){}
             boolean canCancel = "confirmed".equals(b.getBookingStatus());
        %>
        <tr>
          <td><strong>#<%= b.getBookingId() %></strong></td>
          <td><strong><%= ev!=null?ev.getTitle():"N/A" %></strong></td>
          <td>
            <%= ev!=null?ev.getEventDate().toString():"" %>
            <% if (!evTime.isEmpty()) { %>
              <br><small style="color:#888"><%= evTime %></small>
            <% } %>
          </td>
          <td><%= b.getSeatsBooked() %></td>
          <td><strong>₹<%= b.getTotalAmount() %></strong></td>
          <td>
            <span class="badge b-<%= b.getBookingStatus() %>">
              <%= b.getBookingStatus().replace("_"," ") %>
            </span>
          </td>
          <td>
            <% if (canCancel && ev!=null && !"cancelled".equals(ev.getStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking" method="post"
                  onsubmit="return confirmCancel()">
              <input type="hidden" name="action" value="cancel">
              <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
              <button type="submit" class="btn-cancel">❌ Cancel</button>
            </form>
            <% } else { %>
              <span style="color:#ddd;font-size:12px">—</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </table>
      <% } %>
    </div>
  </div>

</div>

<script>
function filterPartEvents() {
  var query   = document.getElementById('partEventSearch').value.toLowerCase().trim();
  var cards   = document.querySelectorAll('#eventCardGrid .event-card');
  var noRes   = document.getElementById('partEventNoResults');
  var countEl = document.getElementById('partEventCount');
  var stEl    = document.getElementById('searchTermDisplay');
  var visible = 0;

  cards.forEach(function(card) {
    var title = card.getAttribute('data-title');
    var venue = card.getAttribute('data-venue');
    card.style.outline = '';

    if (query === '' || title.includes(query) || venue.includes(query)) {
      card.style.display = '';
      visible++;
      if (query !== '' && title.includes(query)) {
        card.style.outline = '3px solid #7b2ff7';
        card.style.outlineOffset = '2px';
      }
    } else {
      card.style.display = 'none';
    }
  });

  if (stEl) stEl.textContent = query;
  noRes.style.display = (visible===0 && query!=='') ? 'block' : 'none';
  countEl.textContent = query!=='' ? visible+' event'+(visible!==1?'s':'')+' found' : '';
}

function confirmCancel() {
  return confirm(
    'Cancel this booking?\n\n' +
    'Refund Policy:\n' +
    '• 7+ days before → 100% refund\n' +
    '• 3-6 days before → 75% refund\n' +
    '• 1-2 days before → 50% refund\n' +
    '• Same day → No refund'
  );
}
</script>
</body>
</html>