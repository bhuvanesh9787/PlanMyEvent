<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,com.ems.dao.*,java.util.*,java.text.*" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<User>    users    = new UserDAO().getAllUsers();
    List<Event>   events   = new EventDAO().getAllEvents();
    List<Booking> bookings = new BookingDAO().getAllBookings();
    List<Payment> payments = new PaymentDAO().getAllPayments();
    SimpleDateFormat inFmt  = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat outFmt = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard — Plan My Event</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0;}
    body{font-family:'Segoe UI',Arial,sans-serif;background:#f0f2f8;color:#333;}
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
    .container{max-width:1200px;margin:30px auto;padding:0 24px;}
    .stats-grid{
      display:grid;grid-template-columns:repeat(4,1fr);
      gap:18px;margin-bottom:28px;
    }
    .stat-card{
      border-radius:16px;padding:24px 20px;color:#fff;
      text-align:center;box-shadow:0 6px 20px rgba(0,0,0,0.12);
      transition:transform 0.3s;
    }
    .stat-card:hover{transform:translateY(-4px);}
    .stat-card .num{font-size:40px;font-weight:800;margin-bottom:6px;}
    .stat-card .lbl{font-size:13px;opacity:0.9;font-weight:600;}
    .s1{background:linear-gradient(135deg,#7b2ff7,#f107a3);}
    .s2{background:linear-gradient(135deg,#11998e,#38ef7d);}
    .s3{background:linear-gradient(135deg,#f7971e,#ffd200);}
    .s4{background:linear-gradient(135deg,#fc4a1a,#f7b733);}
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
      transition:all 0.3s;
    }
    .search-wrap:focus-within{
      background:rgba(255,255,255,0.35);
      border-color:rgba(255,255,255,0.7);
    }
    .search-wrap input{
      background:transparent;border:none;outline:none;
      color:#fff;font-size:13px;width:200px;
    }
    .search-wrap input::placeholder{color:rgba(255,255,255,0.7);}
    .search-wrap .si{font-size:14px;color:rgba(255,255,255,0.8);}
    .search-count{
      font-size:12px;color:rgba(255,255,255,0.8);
      margin-left:4px;white-space:nowrap;
    }

    table{width:100%;border-collapse:collapse;font-size:13px;}
    th{
      background:#faf5ff;color:#7b2ff7;padding:13px 16px;
      text-align:left;font-weight:700;font-size:12px;
      text-transform:uppercase;letter-spacing:0.5px;
      border-bottom:2px solid #f0e8ff;
    }
    td{padding:13px 16px;border-bottom:1px solid #f8f5ff;vertical-align:middle;}
    tr:last-child td{border-bottom:none;}
    tr:hover td{background:#fdf9ff;}
    .hidden-row{display:none;}
    .no-results{
      text-align:center;padding:30px;color:#aaa;font-size:14px;display:none;
    }
    .badge{
      display:inline-block;padding:4px 12px;border-radius:20px;
      font-size:11px;font-weight:700;letter-spacing:0.4px;
    }
    .b-admin{background:#f0e8ff;color:#7b2ff7;}
    .b-organiser{background:#e8f4fd;color:#1a5276;}
    .b-participant{background:#e9f7ef;color:#1e8449;}
    .b-upcoming{background:#e8f4fd;color:#1a5276;}
    .b-ongoing{background:#e9f7ef;color:#1e8449;}
    .b-completed{background:#f2f3f4;color:#555;}
    .b-cancelled{background:#fdedec;color:#c0392b;}
    .b-confirmed{background:#e9f7ef;color:#1e8449;}
    .b-refund_pending{background:#fef9e7;color:#9a7d0a;}
    .b-refunded{background:#f5eef8;color:#6c3483;}
    .b-success{background:#e9f7ef;color:#1e8449;}
    .b-failed{background:#fdedec;color:#c0392b;}
    .time-am{background:#fff3cd;color:#856404;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .time-pm{background:#cfe2ff;color:#084298;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .highlight{background:#fff3cd !important;}
    @media(max-width:768px){
      .stats-grid{grid-template-columns:repeat(2,1fr);}
      .search-wrap input{width:130px;}
    }
  </style>
</head>
<body>
<nav class="navbar">
  <h1>🔐 Plan My Event — Admin Panel</h1>
  <div class="nr">
    <span class="uinfo">👤 <%= user.getName() %></span>
    <a href="<%= request.getContextPath() %>/login?action=logout">🚪 Logout</a>
  </div>
</nav>

<div class="container">

  <!-- Stats -->
  <div class="stats-grid">
    <div class="stat-card s1">
      <div class="num"><%= users.size() %></div>
      <div class="lbl">👥 Total Users</div>
    </div>
    <div class="stat-card s2">
      <div class="num"><%= events.size() %></div>
      <div class="lbl">🎪 Total Events</div>
    </div>
    <div class="stat-card s3">
      <div class="num"><%= bookings.size() %></div>
      <div class="lbl">🎟️ Total Bookings</div>
    </div>
    <div class="stat-card s4">
      <div class="num"><%= payments.size() %></div>
      <div class="lbl">💳 Total Payments</div>
    </div>
  </div>

  <!-- ── USERS TABLE ── -->
  <div class="card">
    <div class="card-head">
      <h2>👥 All Users</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span class="si">🔍</span>
          <input type="text" id="userSearch"
                 placeholder="Search by ID, name, email..."
                 oninput="filterTable('userSearch','userTable','userNoResults','userCount')">
        </div>
        <span class="search-count" id="userCount"></span>
      </div>
    </div>
    <table id="userTable">
      <tr>
        <th>ID</th><th>Name</th><th>Email</th>
        <th>Phone</th><th>Role</th><th>Joined</th>
      </tr>
      <% for (User u : users) { %>
      <tr data-search="<%= u.getUserId() %> <%= u.getName().toLowerCase() %> <%= u.getEmail().toLowerCase() %> <%= u.getRole() %>">
        <td><strong>#<%= u.getUserId() %></strong></td>
        <td><strong><%= u.getName() %></strong></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getPhone() %></td>
        <td><span class="badge b-<%= u.getRole() %>"><%= u.getRole() %></span></td>
        <td><%= u.getCreatedAt()!=null?u.getCreatedAt().toString().substring(0,10):"—" %></td>
      </tr>
      <% } %>
    </table>
    <div class="no-results" id="userNoResults">🔍 No users found matching your search.</div>
  </div>

  <!-- ── EVENTS TABLE ── -->
  <div class="card">
    <div class="card-head">
      <h2>🎪 All Events</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span class="si">🔍</span>
          <input type="text" id="eventSearch"
                 placeholder="Search by ID, title, venue..."
                 oninput="filterTable('eventSearch','eventTable','eventNoResults','eventCount')">
        </div>
        <span class="search-count" id="eventCount"></span>
      </div>
    </div>
    <table id="eventTable">
      <tr>
        <th>ID</th><th>Title</th><th>Venue</th>
        <th>Date</th><th>Time</th><th>Seats</th><th>Price</th><th>Status</th>
      </tr>
      <% for (Event e : events) {
           String ts = "";
           try { if(e.getEventTime()!=null) ts=outFmt.format(inFmt.parse(e.getEventTime().toString())); }
           catch(Exception ex){}
           boolean isAM = ts.toUpperCase().contains("AM");
      %>
      <tr data-search="<%= e.getEventId() %> <%= e.getTitle().toLowerCase() %> <%= e.getVenue().toLowerCase() %> <%= e.getStatus() %>">
        <td><strong>#<%= e.getEventId() %></strong></td>
        <td><strong><%= e.getTitle() %></strong></td>
        <td><%= e.getVenue() %></td>
        <td><%= e.getEventDate() %></td>
        <td><span class="<%= isAM?"time-am":"time-pm" %>">🕐 <%= ts %></span></td>
        <td><%= e.getAvailableSeats() %>/<%= e.getTotalSeats() %></td>
        <td>₹<%= e.getTicketPrice() %></td>
        <td><span class="badge b-<%= e.getStatus() %>"><%= e.getStatus() %></span></td>
      </tr>
      <% } %>
    </table>
    <div class="no-results" id="eventNoResults">🔍 No events found matching your search.</div>
  </div>

  <!-- ── BOOKINGS TABLE ── -->
  <div class="card">
    <div class="card-head">
      <h2>🎟️ All Bookings</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span class="si">🔍</span>
          <input type="text" id="bookingSearch"
                 placeholder="Search by ID, status..."
                 oninput="filterTable('bookingSearch','bookingTable','bookingNoResults','bookingCount')">
        </div>
        <span class="search-count" id="bookingCount"></span>
      </div>
    </div>
    <table id="bookingTable">
      <tr>
        <th>Booking ID</th><th>Event ID</th><th>Participant ID</th>
        <th>Seats</th><th>Amount</th><th>Status</th><th>Date</th>
      </tr>
      <% for (Booking b : bookings) { %>
      <tr data-search="<%= b.getBookingId() %> <%= b.getEventId() %> <%= b.getParticipantId() %> <%= b.getBookingStatus() %>">
        <td><strong>#<%= b.getBookingId() %></strong></td>
        <td>#<%= b.getEventId() %></td>
        <td>#<%= b.getParticipantId() %></td>
        <td><%= b.getSeatsBooked() %></td>
        <td><strong>₹<%= b.getTotalAmount() %></strong></td>
        <td><span class="badge b-<%= b.getBookingStatus() %>"><%= b.getBookingStatus().replace("_"," ") %></span></td>
        <td><%= b.getBookingDate()!=null?b.getBookingDate().toString().substring(0,10):"—" %></td>
      </tr>
      <% } %>
    </table>
    <div class="no-results" id="bookingNoResults">🔍 No bookings found matching your search.</div>
  </div>

  <!-- ── PAYMENTS TABLE ── -->
  <div class="card">
    <div class="card-head">
      <h2>💳 All Payments</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span class="si">🔍</span>
          <input type="text" id="paymentSearch"
                 placeholder="Search by ID, method, status..."
                 oninput="filterTable('paymentSearch','paymentTable','paymentNoResults','paymentCount')">
        </div>
        <span class="search-count" id="paymentCount"></span>
      </div>
    </div>
    <table id="paymentTable">
      <tr>
        <th>Payment ID</th><th>Booking ID</th><th>Amount</th>
        <th>Method</th><th>Card</th><th>Status</th><th>Date</th>
      </tr>
      <% for (Payment p : payments) { %>
      <tr data-search="<%= p.getPaymentId() %> <%= p.getBookingId() %> <%= p.getPaymentMethod() %> <%= p.getPaymentStatus() %>">
        <td><strong>#<%= p.getPaymentId() %></strong></td>
        <td>#<%= p.getBookingId() %></td>
        <td><strong>₹<%= p.getAmount() %></strong></td>
        <td><%= "card".equals(p.getPaymentMethod())?"💳 Card":"📱 QR" %></td>
        <td><%= p.getCardLast4()!=null?"****"+p.getCardLast4():"—" %></td>
        <td><span class="badge b-<%= p.getPaymentStatus()!=null?p.getPaymentStatus():"success" %>"><%= p.getPaymentStatus() %></span></td>
        <td><%= p.getPaymentDate()!=null?p.getPaymentDate().toString().substring(0,10):"—" %></td>
      </tr>
      <% } %>
    </table>
    <div class="no-results" id="paymentNoResults">🔍 No payments found matching your search.</div>
  </div>

</div>

<script>
function filterTable(inputId, tableId, noResultsId, countId) {
  var query   = document.getElementById(inputId).value.toLowerCase().trim();
  var table   = document.getElementById(tableId);
  var rows    = table.querySelectorAll('tr[data-search]');
  var noRes   = document.getElementById(noResultsId);
  var countEl = document.getElementById(countId);
  var visible = 0;

  rows.forEach(function(row) {
    var data = row.getAttribute('data-search').toLowerCase();
    var cells = row.querySelectorAll('td');

    // Remove previous highlights
    cells.forEach(function(td) {
      td.style.background = '';
      td.style.fontWeight = '';
    });

    if (query === '' || data.includes(query)) {
      row.style.display = '';
      visible++;

      // Highlight matching cell
      if (query !== '') {
        cells.forEach(function(td) {
          if (td.textContent.toLowerCase().includes(query)) {
            td.style.background = '#fff9e6';
            td.style.fontWeight = '700';
          }
        });
      }
    } else {
      row.style.display = 'none';
    }
  });

  noRes.style.display   = (visible === 0 && query !== '') ? 'block' : 'none';
  countEl.textContent   = query !== '' ? visible + ' result' + (visible!==1?'s':'') + ' found' : '';
}
</script>
</body>
</html>