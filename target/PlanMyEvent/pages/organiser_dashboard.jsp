<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*,com.ems.dao.*,java.util.*,java.text.*" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"organiser".equals(user.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Event> events = new EventDAO().getEventsByOrganiser(user.getUserId());
    String msg = request.getParameter("msg");
    SimpleDateFormat inFmt  = new SimpleDateFormat("HH:mm:ss");
    SimpleDateFormat outFmt = new SimpleDateFormat("hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Organiser Dashboard — Plan My Event</title>
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
    .navbar a{
      color:#fff;text-decoration:none;font-size:13px;font-weight:600;
      padding:8px 18px;border-radius:20px;background:rgba(255,255,255,0.2);
      margin-left:6px;transition:all 0.3s;
    }
    .navbar a:hover{background:rgba(255,255,255,0.35);}
    .container{max-width:1150px;margin:30px auto;padding:0 24px;}
    .alert{
      padding:14px 18px;border-radius:12px;margin-bottom:20px;
      font-size:14px;font-weight:500;
    }
    .alert-success{background:#f0fff4;color:#1e8449;border-left:4px solid #27ae60;}
    .alert-warning{background:#fffbf0;color:#9a7d0a;border-left:4px solid #f39c12;}
    .alert-info{background:#f0f8ff;color:#1a5276;border-left:4px solid #2980b9;}
    .stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:26px;}
    .stat-card{
      border-radius:16px;padding:22px 18px;color:#fff;
      text-align:center;box-shadow:0 6px 20px rgba(0,0,0,0.12);
      transition:transform 0.3s;
    }
    .stat-card:hover{transform:translateY(-4px);}
    .stat-card .num{font-size:38px;font-weight:800;margin-bottom:6px;}
    .stat-card .lbl{font-size:13px;opacity:0.9;font-weight:600;}
    .s1{background:linear-gradient(135deg,#7b2ff7,#f107a3);}
    .s2{background:linear-gradient(135deg,#11998e,#38ef7d);}
    .s3{background:linear-gradient(135deg,#fc4a1a,#f7b733);}
    .s4{background:linear-gradient(135deg,#2193b0,#6dd5ed);}
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
    .search-count{font-size:12px;color:rgba(255,255,255,0.8);white-space:nowrap;}

    .policy-box{
      margin:20px 24px;background:#faf5ff;border:2px solid #e8d5ff;
      border-radius:14px;padding:18px 20px;
    }
    .policy-box h4{color:#7b2ff7;margin-bottom:10px;font-size:14px;}
    .policy-box p{color:#666;font-size:13px;line-height:1.6;}
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
    .badge{display:inline-block;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;}
    .b-upcoming{background:#e8f4fd;color:#1a5276;}
    .b-ongoing{background:#e9f7ef;color:#1e8449;}
    .b-completed{background:#f2f3f4;color:#555;}
    .b-cancelled{background:#fdedec;color:#c0392b;}
    .time-am{background:#fff3cd;color:#856404;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .time-pm{background:#cfe2ff;color:#084298;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;}
    .btn{
      display:inline-block;padding:8px 16px;border:none;border-radius:20px;
      cursor:pointer;font-size:12px;font-weight:700;transition:all 0.3s;
    }
    .btn-cancel{background:linear-gradient(135deg,#f7971e,#ffd200);color:#fff;}
    .btn-delete{background:linear-gradient(135deg,#fc4a1a,#f7b733);color:#fff;}
    .btn:hover{transform:translateY(-1px);box-shadow:0 4px 12px rgba(0,0,0,0.2);}
    .empty-state{text-align:center;padding:50px 20px;color:#aaa;}
    .empty-state .ei{font-size:60px;margin-bottom:14px;}
    .empty-state a{color:#7b2ff7;font-weight:700;text-decoration:none;}
    .no-results{text-align:center;padding:30px;color:#aaa;font-size:14px;display:none;}
  </style>
</head>
<body>
<nav class="navbar">
  <h1>🎪 Plan My Event — Organiser Panel</h1>
  <div class="nr">
    <a href="add_event.jsp">➕ Add Event</a>
    <a href="<%= request.getContextPath() %>/login?action=logout">🚪 Logout</a>
  </div>
</nav>

<div class="container">

  <% if ("added".equals(msg)) { %>
    <div class="alert alert-success">✅ Event created successfully!</div>
  <% } else if ("deleted".equals(msg)) { %>
    <div class="alert alert-warning">🗑️ Event deleted permanently.</div>
  <% } else if ("cancelled".equals(msg)) { %>
    <div class="alert alert-info">❌ Event cancelled. All participants will receive a 100% refund within 3 business days.</div>
  <% } %>

  <!-- Stats -->
  <div class="stats-grid">
    <div class="stat-card s1">
      <div class="num"><%= events.size() %></div>
      <div class="lbl">🎪 Total Events</div>
    </div>
    <div class="stat-card s2">
      <div class="num"><%= events.stream().filter(e->"upcoming".equals(e.getStatus())).count() %></div>
      <div class="lbl">📅 Upcoming</div>
    </div>
    <div class="stat-card s3">
      <div class="num"><%= events.stream().filter(e->"cancelled".equals(e.getStatus())).count() %></div>
      <div class="lbl">❌ Cancelled</div>
    </div>
    <div class="stat-card s4">
      <div class="num"><%= events.stream().filter(e->"completed".equals(e.getStatus())).count() %></div>
      <div class="lbl">✅ Completed</div>
    </div>
  </div>

  <div class="card">
    <div class="card-head">
      <h2>👋 Welcome, <%= user.getName() %> — Your Events</h2>
      <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
        <div class="search-wrap">
          <span style="font-size:14px;color:rgba(255,255,255,0.8)">🔍</span>
          <input type="text" id="orgEventSearch"
                 placeholder="Search event by name..."
                 oninput="filterOrgEvents()">
        </div>
        <span class="search-count" id="orgEventCount"></span>
      </div>
    </div>

    <div class="policy-box">
      <h4>📋 Organiser Cancellation Policy</h4>
      <p>If you cancel an event, <strong>all participants receive a 100% full refund automatically</strong>, processed within <strong>3 business days</strong>.</p>
    </div>

    <% if (events.isEmpty()) { %>
      <div class="empty-state">
        <div class="ei">🎭</div>
        <p>No events yet. <a href="add_event.jsp">Create your first event!</a></p>
      </div>
    <% } else { %>
    <table id="orgEventTable">
      <tr>
        <th>Title</th><th>Venue</th><th>Date</th><th>Time</th>
        <th>Seats</th><th>Price</th><th>Status</th><th>Actions</th>
      </tr>
      <% for (Event e : events) {
           String ts = "";
           try { if(e.getEventTime()!=null) ts=outFmt.format(inFmt.parse(e.getEventTime().toString())); }
           catch(Exception ex){}
           boolean isAM = ts.toUpperCase().contains("AM");
      %>
      <tr data-title="<%= e.getTitle().toLowerCase() %>" data-venue="<%= e.getVenue().toLowerCase() %>">
        <td><strong><%= e.getTitle() %></strong></td>
        <td>📍 <%= e.getVenue() %></td>
        <td>📅 <%= e.getEventDate() %></td>
        <td><span class="<%= isAM?"time-am":"time-pm" %>">🕐 <%= ts %></span></td>
        <td><strong><%= e.getAvailableSeats() %></strong>/<%= e.getTotalSeats() %></td>
        <td>₹<%= e.getTicketPrice() %></td>
        <td><span class="badge b-<%= e.getStatus() %>"><%= e.getStatus() %></span></td>
        <td>
          <% if (!"cancelled".equals(e.getStatus()) && !"completed".equals(e.getStatus())) { %>
          <form action="<%= request.getContextPath() %>/event" method="post" style="display:inline">
            <input type="hidden" name="action" value="cancel">
            <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
            <button class="btn btn-cancel"
              onclick="return confirm('Cancel this event?\n\nAll participants get 100% refund within 3 days.')">
              ❌ Cancel
            </button>
          </form>
          <form action="<%= request.getContextPath() %>/event" method="post" style="display:inline;margin-left:6px">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
            <button class="btn btn-delete"
              onclick="return confirm('Permanently delete this event?')">
              🗑️ Delete
            </button>
          </form>
          <% } else { %>
            <span style="color:#ccc;font-size:12px">No actions</span>
          <% } %>
        </td>
      </tr>
      <% } %>
    </table>
    <div class="no-results" id="orgEventNoResults">🔍 No events found matching your search.</div>
    <% } %>
  </div>
</div>

<script>
function filterOrgEvents() {
  var query   = document.getElementById('orgEventSearch').value.toLowerCase().trim();
  var rows    = document.querySelectorAll('#orgEventTable tr[data-title]');
  var noRes   = document.getElementById('orgEventNoResults');
  var countEl = document.getElementById('orgEventCount');
  var visible = 0;

  rows.forEach(function(row) {
    var title = row.getAttribute('data-title');
    var venue = row.getAttribute('data-venue');
    var cells = row.querySelectorAll('td');

    cells.forEach(function(td) {
      td.style.background = '';
      td.style.fontWeight = '';
    });

    if (query === '' || title.includes(query) || venue.includes(query)) {
      row.style.display = '';
      visible++;
      if (query !== '') {
        var firstCell = row.querySelector('td:first-child');
        if (firstCell && title.includes(query)) {
          firstCell.style.background = '#fff9e6';
        }
      }
    } else {
      row.style.display = 'none';
    }
  });

  noRes.style.display = (visible===0 && query!=='') ? 'block' : 'none';
  countEl.textContent = query!=='' ? visible+' result'+(visible!==1?'s':'')+' found' : '';
}
</script>
</body>
</html>