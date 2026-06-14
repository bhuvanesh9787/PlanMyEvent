<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<% String error = (String) request.getAttribute("error"); %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register Participant — Plan My Event</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0;}
    body{
      font-family:'Segoe UI',Arial,sans-serif;min-height:100vh;
      background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460,#533483);
      display:flex;align-items:center;justify-content:center;padding:30px 20px;
    }
    .box{
      background:#fff;border-radius:22px;padding:44px 40px;
      width:100%;max-width:520px;
      box-shadow:0 24px 70px rgba(0,0,0,0.35);
    }
    .top{text-align:center;margin-bottom:28px;}
    .top .icon{
      width:64px;height:64px;border-radius:18px;
      background:linear-gradient(135deg,#f107a3,#7b2ff7);
      display:inline-flex;align-items:center;justify-content:center;
      font-size:30px;margin-bottom:14px;
    }
    .top h1{font-size:22px;font-weight:800;color:#1a1a2e;margin-bottom:4px;}
    .top p{color:#999;font-size:13px;}
    .alert{
      padding:12px 16px;border-radius:10px;margin-bottom:18px;
      font-size:13px;border-left:4px solid #e74c3c;
      background:#fff0f0;color:#c0392b;
    }
    .form-group{margin-bottom:16px;}
    .form-group label{
      display:block;font-size:11px;font-weight:700;color:#888;
      text-transform:uppercase;letter-spacing:0.7px;margin-bottom:7px;
    }
    .form-group input,
    .form-group textarea{
      width:100%;padding:12px 15px;border:2px solid #efefef;
      border-radius:11px;font-size:14px;background:#fafafa;
      transition:all 0.3s;outline:none;color:#333;
    }
    .form-group input:focus,
    .form-group textarea:focus{
      border-color:#f107a3;background:#fff;
      box-shadow:0 0 0 4px rgba(241,7,163,0.1);
    }
    .form-group textarea{height:80px;resize:vertical;}
    .form-row{display:flex;gap:14px;}
    .form-row .form-group{flex:1;}
    .btn{
      width:100%;padding:14px;border:none;border-radius:12px;
      background:linear-gradient(135deg,#f107a3,#7b2ff7);
      color:#fff;font-size:15px;font-weight:700;
      cursor:pointer;transition:all 0.3s;margin-top:6px;
      box-shadow:0 6px 20px rgba(241,7,163,0.35);
    }
    .btn:hover{transform:translateY(-2px);box-shadow:0 10px 28px rgba(241,7,163,0.45);}
    .bottom{text-align:center;margin-top:20px;font-size:13px;color:#888;}
    .bottom a{color:#f107a3;font-weight:700;text-decoration:none;}
  </style>
</head>
<body>
<div class="box">
  <div class="top">
    <div class="icon">🎟️</div>
    <h1>Plan My Event</h1>
    <p>Register as a Participant</p>
  </div>
  <% if (error != null) { %>
    <div class="alert">⚠️ <%= error %></div>
  <% } %>
  <form action="<%= request.getContextPath() %>/register" method="post">
    <input type="hidden" name="type" value="participant">
    <div class="form-row">
      <div class="form-group">
        <label>Full Name</label>
        <input type="text" name="name" required placeholder="Your full name">
      </div>
      <div class="form-group">
        <label>Age</label>
        <input type="number" name="age" required placeholder="Age" min="1" max="120">
      </div>
    </div>
    <div class="form-row">
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" required placeholder="you@example.com">
      </div>
      <div class="form-group">
        <label>Phone Number</label>
        <input type="text" name="phone" required placeholder="10-digit number">
      </div>
    </div>
    <div class="form-group">
      <label>Address</label>
      <textarea name="address" required placeholder="Your full address"></textarea>
    </div>
    <div class="form-group">
      <label>Password</label>
      <input type="password" name="password" required placeholder="Create a strong password">
    </div>
    <button type="submit" class="btn">🎟️ Register as Participant</button>
  </form>
  <div class="bottom">
    Already have an account? <a href="login.jsp">Sign in here</a>
  </div>
</div>
</body>
</html>