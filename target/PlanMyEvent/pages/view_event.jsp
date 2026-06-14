<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.ems.model.*" %>
<%
    User user   = (User)  session.getAttribute("loggedUser");
    Event event = (Event) request.getAttribute("event");
    if (user == null)  { response.sendRedirect("login.jsp"); return; }
    if (event == null) { response.sendRedirect("participant_dashboard.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title><%= event.getTitle() %></title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<nav class="navbar">
  <h1>EMS — Event Details</h1>
  <a href="participant_dashboard.jsp">Back</a>
</nav>
<div class="container" style="max-width:650px">
  <div class="card">
    <h2><%= event.getTitle() %></h2>
    <span class="badge badge-<%= event.getStatus() %>"><%= event.getStatus() %></span>
    <div style="margin:20px 0;line-height:2">
      <p><strong>Description:</strong> <%= event.getDescription() %></p>
      <p><strong>Venue:</strong> <%= event.getVenue() %></p>
      <p><strong>Date:</strong> <%= event.getEventDate() %></p>
      <p><strong>Time:</strong> <%= event.getEventTime() %></p>
      <p><strong>Total Seats:</strong> <%= event.getTotalSeats() %></p>
      <p><strong>Available Seats:</strong> <%= event.getAvailableSeats() %></p>
      <p><strong>Ticket Price:</strong> ₹<%= event.getTicketPrice() %></p>
    </div>
    <% if ("upcoming".equals(event.getStatus()) && event.getAvailableSeats() > 0
           && "participant".equals(user.getRole())) { %>
    <form action="<%= request.getContextPath() %>/booking" method="post">
      <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
      <div class="form-group">
        <label>Number of Seats</label>
        <input type="number" name="seats" value="1" min="1"
               max="<%= event.getAvailableSeats() %>" required>
      </div>
      <button type="submit" class="btn btn-success">Book Now</button>
    </form>
    <% } else if ("cancelled".equals(event.getStatus())) { %>
    <div class="alert alert-error">This event has been cancelled.</div>
    <% } else if (event.getAvailableSeats() == 0) { %>
    <div class="alert alert-error">This event is fully booked.</div>
    <% } %>
  </div>
</div>
</body>
</html>