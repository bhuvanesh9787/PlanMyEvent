<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("loggedUser") == null) { response.sendRedirect("login.jsp"); return; }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Add Event — Plan My Event</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0;}
    body{
      font-family:'Segoe UI',Arial,sans-serif;min-height:100vh;
      background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460,#533483);
      display:flex;flex-direction:column;
    }
    .navbar{
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:16px 32px;display:flex;align-items:center;justify-content:space-between;
    }
    .navbar h1{color:#fff;font-size:20px;font-weight:800;}
    .navbar a{
      color:#fff;text-decoration:none;font-size:13px;font-weight:600;
      padding:8px 18px;border-radius:20px;background:rgba(255,255,255,0.2);
    }
    .wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:40px 20px;}
    .box{
      background:#fff;border-radius:22px;padding:44px 40px;
      width:100%;max-width:600px;
      box-shadow:0 24px 70px rgba(0,0,0,0.35);
    }
    .box-head{text-align:center;margin-bottom:30px;}
    .box-head .icon{
      width:64px;height:64px;border-radius:18px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      display:inline-flex;align-items:center;justify-content:center;
      font-size:30px;margin-bottom:14px;
    }
    .box-head h2{font-size:22px;font-weight:800;color:#1a1a2e;}
    .box-head p{color:#999;font-size:13px;margin-top:4px;}
    .alert{
      padding:12px 16px;border-radius:10px;margin-bottom:18px;
      font-size:13px;background:#fff0f0;color:#c0392b;border-left:4px solid #e74c3c;
    }
    .form-group{margin-bottom:18px;}
    .form-group label{
      display:block;font-size:11px;font-weight:700;color:#888;
      text-transform:uppercase;letter-spacing:0.7px;margin-bottom:8px;
    }
    .form-group input,
    .form-group textarea{
      width:100%;padding:13px 16px;border:2px solid #efefef;
      border-radius:12px;font-size:14px;background:#fafafa;
      transition:all 0.3s;outline:none;color:#333;
    }
    .form-group input:focus,
    .form-group textarea:focus{
      border-color:#7b2ff7;background:#fff;
      box-shadow:0 0 0 4px rgba(123,47,247,0.1);
    }
    .form-group textarea{height:90px;resize:vertical;}
    .form-row{display:flex;gap:16px;}
    .form-row .form-group{flex:1;}
    .btn{
      width:100%;padding:15px;border:none;border-radius:14px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff;font-size:15px;font-weight:700;cursor:pointer;
      transition:all 0.3s;box-shadow:0 6px 22px rgba(123,47,247,0.4);
    }
    .btn:hover{transform:translateY(-2px);box-shadow:0 10px 30px rgba(123,47,247,0.5);}
  </style>
</head>
<body>
<nav class="navbar">
  <h1>🎪 Plan My Event — Add New Event</h1>
  <a href="organiser_dashboard.jsp">← Back to Dashboard</a>
</nav>
<div class="wrap">
  <div class="box">
    <div class="box-head">
      <div class="icon">🎭</div>
      <h2>Create New Event</h2>
      <p>Fill in the details to publish your event</p>
    </div>
    <% if (error != null) { %>
      <div class="alert">⚠️ <%= error %></div>
    <% } %>
    <form action="<%= request.getContextPath() %>/event" method="post">
      <input type="hidden" name="action" value="add">
      <div class="form-group">
        <label>Event Title</label>
        <input type="text" name="title" required placeholder="Give your event a great name">
      </div>
      <div class="form-group">
        <label>Description</label>
        <textarea name="description" required placeholder="Describe your event..."></textarea>
      </div>
      <div class="form-group">
        <label>Venue</label>
        <input type="text" name="venue" required placeholder="Full venue address">
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Event Date</label>
          <input type="date" name="eventDate" required>
        </div>
        <div class="form-group">
          <label>Event Time</label>
          <input type="time" name="eventTime" required>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label>Total Seats</label>
          <input type="number" name="totalSeats" required min="1" placeholder="e.g. 200">
        </div>
        <div class="form-group">
          <label>Ticket Price (₹)</label>
          <input type="number" name="ticketPrice" required min="0" step="0.01" placeholder="e.g. 499">
        </div>
      </div>
      <button type="submit" class="btn">🚀 Create Event</button>
    </form>
  </div>
</div>
</body>
</html>