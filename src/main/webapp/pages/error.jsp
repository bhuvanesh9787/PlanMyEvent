<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%
    String errorMsg = (String) request.getAttribute("error");
    if (errorMsg == null) errorMsg = "An unexpected error occurred.";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Error — Plan My Event</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0;}
    body{
      font-family:'Segoe UI',Arial,sans-serif;min-height:100vh;
      background:linear-gradient(135deg,#1a1a2e,#16213e,#0f3460,#533483);
      display:flex;flex-direction:column;
    }
    .navbar{
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      padding:16px 32px;
    }
    .navbar h1{color:#fff;font-size:20px;font-weight:800;}
    .wrap{
      flex:1;display:flex;align-items:center;
      justify-content:center;padding:40px 20px;
    }
    .box{
      background:#fff;border-radius:22px;padding:50px 40px;
      max-width:480px;width:100%;text-align:center;
      box-shadow:0 24px 70px rgba(0,0,0,0.35);
    }
    .box .icon{font-size:80px;margin-bottom:20px;}
    .box h2{font-size:24px;font-weight:800;color:#e74c3c;margin-bottom:10px;}
    .box p{color:#888;font-size:14px;line-height:1.7;margin-bottom:10px;}
    .error-detail{
      background:#fff0f0;border-radius:10px;padding:12px 16px;
      font-size:12px;color:#c0392b;margin-bottom:28px;
      text-align:left;word-break:break-all;
    }
    .btns{display:flex;gap:12px;justify-content:center;}
    .btn{
      padding:12px 24px;border:none;border-radius:12px;
      cursor:pointer;font-size:14px;font-weight:700;
      text-decoration:none;transition:all 0.3s;
    }
    .btn-back{background:#f0f2f8;color:#555;}
    .btn-home{
      background:linear-gradient(135deg,#7b2ff7,#f107a3);
      color:#fff;box-shadow:0 4px 14px rgba(123,47,247,0.35);
    }
    .btn:hover{transform:translateY(-2px);}
  </style>
</head>
<body>
<nav class="navbar">
  <h1>⚠️ Plan My Event — Error</h1>
</nav>
<div class="wrap">
  <div class="box">
    <div class="icon">⚠️</div>
    <h2>Something Went Wrong</h2>
    <p>An error occurred while processing your request.</p>
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="error-detail"><%= errorMsg %></div>
    <% } %>
    <div class="btns">
      <a href="javascript:history.back()" class="btn btn-back">← Go Back</a>
      <a href="<%= request.getContextPath() %>/pages/login.jsp" class="btn btn-home">🏠 Go to Login</a>
    </div>
  </div>
</div>
</body>
</html>