<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("loggedUser") != null) {
        String role = (String) session.getAttribute("role");
        if ("admin".equals(role))     { response.sendRedirect("admin_dashboard.jsp"); return; }
        if ("organiser".equals(role)) { response.sendRedirect("organiser_dashboard.jsp"); return; }
        response.sendRedirect("participant_dashboard.jsp"); return;
    }
    String error = (String) request.getAttribute("error");
    String msg   = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Plan My Event — Login</title>
  <style>
    * { box-sizing:border-box; margin:0; padding:0; }
    body {
      font-family:'Segoe UI',Arial,sans-serif; min-height:100vh;
      background:linear-gradient(135deg,#1a1a2e 0%,#16213e 40%,#0f3460 70%,#533483 100%);
      display:flex; align-items:center; justify-content:center; padding:20px;
    }
    .page-wrapper {
      display:flex; width:100%; max-width:920px; min-height:560px;
      border-radius:24px; overflow:hidden;
      box-shadow:0 30px 80px rgba(0,0,0,0.5);
    }
    .left-panel {
      flex:1; background:linear-gradient(160deg,#7b2ff7 0%,#f107a3 100%);
      display:flex; flex-direction:column; align-items:center;
      justify-content:center; padding:40px 32px; text-align:center;
      position:relative; overflow:hidden;
    }
    .left-panel::before {
      content:''; position:absolute; width:220px; height:220px;
      background:rgba(255,255,255,0.08); border-radius:50%;
      top:-70px; left:-70px;
    }
    .left-panel::after {
      content:''; position:absolute; width:160px; height:160px;
      background:rgba(255,255,255,0.08); border-radius:50%;
      bottom:-50px; right:-50px;
    }
    .left-panel .big-icon { font-size:86px; margin-bottom:20px; }
    .left-panel h2 {
      color:#fff; font-size:28px; font-weight:800; margin-bottom:12px;
      text-shadow:0 2px 10px rgba(0,0,0,0.2);
    }
    .left-panel p { color:rgba(255,255,255,0.85); font-size:14px; line-height:1.7; }
    .feature-list { list-style:none; margin-top:26px; text-align:left; width:100%; }
    .feature-list li {
      color:rgba(255,255,255,0.92); font-size:13px; padding:8px 0;
      display:flex; align-items:center; gap:10px;
      border-bottom:1px solid rgba(255,255,255,0.15);
    }
    .feature-list li:last-child { border-bottom:none; }
    .right-panel {
      flex:1.1; background:#fff; padding:50px 46px;
      display:flex; flex-direction:column; justify-content:center;
    }
    .brand { display:flex; align-items:center; gap:12px; margin-bottom:34px; }
    .brand-icon {
      width:48px; height:48px;
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      border-radius:14px; display:flex; align-items:center;
      justify-content:center; font-size:24px;
    }
    .brand-name { font-size:18px; font-weight:800; color:#1a1a2e; }
    .brand-name span { display:block; font-size:12px; font-weight:400; color:#999; }
    h1 { font-size:30px; font-weight:800; color:#1a1a2e; margin-bottom:6px; }
    .subtitle { color:#999; font-size:14px; margin-bottom:30px; }
    .alert {
      padding:12px 16px; border-radius:10px; margin-bottom:18px;
      font-size:13px; display:flex; align-items:center; gap:8px;
    }
    .alert-error   { background:#fff0f0; color:#c0392b; border-left:4px solid #e74c3c; }
    .alert-success { background:#f0fff4; color:#1e8449; border-left:4px solid #27ae60; }
    .form-group { margin-bottom:18px; }
    .form-group label {
      display:block; font-size:11px; font-weight:700; color:#888;
      text-transform:uppercase; letter-spacing:0.8px; margin-bottom:8px;
    }
    .form-group input {
      width:100%; padding:13px 16px; border:2px solid #efefef;
      border-radius:12px; font-size:14px; color:#333;
      background:#fafafa; transition:all 0.3s; outline:none;
    }
    .form-group input:focus {
      border-color:#7b2ff7; background:#fff;
      box-shadow:0 0 0 4px rgba(123,47,247,0.1);
    }
    .role-grid {
      display:grid; grid-template-columns:repeat(3,1fr);
      gap:10px; margin-bottom:20px;
    }
    .role-option {
      border:2px solid #efefef; border-radius:14px; padding:14px 8px;
      text-align:center; cursor:pointer; transition:all 0.3s; background:#fafafa;
    }
    .role-option:hover {
      border-color:#7b2ff7; background:#f5f0ff; transform:translateY(-2px);
    }
    .role-option.selected {
      border-color:#7b2ff7;
      background:linear-gradient(135deg,#f5f0ff,#fce4ff);
      box-shadow:0 4px 14px rgba(123,47,247,0.2);
    }
    .role-option .role-icon { font-size:28px; margin-bottom:6px; }
    .role-option .role-name { font-size:12px; font-weight:700; color:#555; }
    #roleSelect { display:none; }
    .btn-login {
      width:100%; padding:15px; border:none; border-radius:14px;
      background:linear-gradient(135deg,#7b2ff7 0%,#f107a3 100%);
      color:#fff; font-size:16px; font-weight:700; cursor:pointer;
      letter-spacing:0.5px; transition:all 0.3s; margin-top:8px;
      box-shadow:0 6px 22px rgba(123,47,247,0.4);
    }
    .btn-login:hover {
      transform:translateY(-2px);
      box-shadow:0 10px 30px rgba(123,47,247,0.5);
    }
    .divider {
      display:flex; align-items:center; gap:12px;
      margin:24px 0; color:#ccc; font-size:12px;
    }
    .divider::before, .divider::after {
      content:''; flex:1; height:1px; background:#efefef;
    }
    .register-links { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
    .reg-btn {
      display:block; padding:12px; border-radius:12px;
      text-align:center; font-size:13px; font-weight:700;
      text-decoration:none; transition:all 0.3s; border:2px solid;
    }
    .reg-btn-org  { color:#7b2ff7; border-color:#7b2ff7; }
    .reg-btn-org:hover  { background:#7b2ff7; color:#fff; }
    .reg-btn-part { color:#f107a3; border-color:#f107a3; }
    .reg-btn-part:hover { background:#f107a3; color:#fff; }
    @media (max-width:700px) {
      .left-panel { display:none; }
      .right-panel { padding:36px 24px; }
    }
  </style>
</head>
<body>
<div class="page-wrapper">

  <div class="left-panel">
    <div class="big-icon">🎪</div>
    <h2>Plan My Event</h2>
    <p>Your all-in-one platform for booking, scheduling and managing events.</p>
    <ul class="feature-list">
      <li><span>🎭</span> Organise &amp; manage events</li>
      <li><span>🎟️</span> Book tickets instantly</li>
      <li><span>💳</span> Secure card &amp; QR payments</li>
      <li><span>💰</span> Automatic refund processing</li>
      <li><span>📊</span> Real-time admin dashboard</li>
    </ul>
  </div>

  <div class="right-panel">
    <div class="brand">
      <div class="brand-icon">🎪</div>
      <div class="brand-name">
        Plan My Event
        <span>Event Planning &amp; Booking Platform</span>
      </div>
    </div>

    <h1>Welcome Back!</h1>
    <p class="subtitle">Sign in to continue to your dashboard</p>

    <% if (error != null) { %>
      <div class="alert alert-error">⚠️ <%= error %></div>
    <% } %>
    <% if ("registered".equals(msg)) { %>
      <div class="alert alert-success">✅ Registered successfully! Please login.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">
      <div class="form-group">
        <label>Select Your Role</label>
        <div class="role-grid">
          <div class="role-option" onclick="selectRole('admin',this)">
            <div class="role-icon">🔐</div>
            <div class="role-name">Admin</div>
          </div>
          <div class="role-option" onclick="selectRole('organiser',this)">
            <div class="role-icon">🎭</div>
            <div class="role-name">Organiser</div>
          </div>
          <div class="role-option" onclick="selectRole('participant',this)">
            <div class="role-icon">🎟️</div>
            <div class="role-name">Participant</div>
          </div>
        </div>
        <select name="role" id="roleSelect" required>
          <option value="">-- Select Role --</option>
          <option value="admin">Admin</option>
          <option value="organiser">Organiser</option>
          <option value="participant">Participant</option>
        </select>
      </div>
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" required placeholder="you@example.com">
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" required placeholder="Enter your password">
      </div>
      <button type="submit" class="btn-login">🚀 Sign In</button>
    </form>

    <div class="divider">or create a new account</div>
    <div class="register-links">
      <a href="register_organiser.jsp" class="reg-btn reg-btn-org">🎭 As Organiser</a>
      <a href="register_participant.jsp" class="reg-btn reg-btn-part">🎟️ As Participant</a>
    </div>
  </div>
</div>

<script>
function selectRole(role, el) {
  document.querySelectorAll('.role-option').forEach(function(o) {
    o.classList.remove('selected');
  });
  el.classList.add('selected');
  document.getElementById('roleSelect').value = role;
}
</script>
</body>
</html>