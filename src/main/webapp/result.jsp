<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.User" %>
<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User user = (User) session.getAttribute("currentUser");
    String scoreParam = request.getParameter("score");
    String testIdParam = request.getParameter("testId");
    
    int score = 0;
    int testId = 0;
    
    try {
        score = scoreParam != null ? Integer.parseInt(scoreParam) : 0;
        testId = testIdParam != null ? Integer.parseInt(testIdParam) : 0;
    } catch (NumberFormatException e) {
        score = 0;
        testId = 0;
    }
    
    String message = "Keep Practicing!";
    String icon = "📚";
    String scoreColor = "#f85149";
    String statusClass = "status-fail";
    String statusText = " Needs Improvement";
    
    if (score >= 80) {
        message = "Excellent Performance!";
        icon = "🏆";
        scoreColor = "#3fb950";
        statusClass = "status-pass";
        statusText = "✅ Passed";
    } else if (score >= 50) {
        message = "Good Job!";
        icon = "";
        scoreColor = "#d29922";
        statusClass = "status-pass";
        statusText = "✅ Passed";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Result</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0d1117;
            color: #c9d1d9;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .result-container {
            background: #161b22;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            text-align: center;
            max-width: 500px;
            width: 100%;
            border: 1px solid #30363d;
        }
        .result-icon { font-size: 80px; margin-bottom: 20px; }
        .result-title { color: #f0f6fc; font-size: 28px; margin-bottom: 10px; }
        .result-message { color: #8b949e; font-size: 18px; margin-bottom: 20px; }
        .score-circle {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: #21262d;
            border: 3px solid <%= scoreColor %>;
            color: <%= scoreColor %>;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 48px;
            font-weight: bold;
            margin: 30px auto;
        }
        .details {
            background: #21262d;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: left;
            border: 1px solid #30363d;
        }
        .details p {
            margin: 10px 0;
            color: #8b949e;
            display: flex;
            justify-content: space-between;
        }
        .details .label { font-weight: bold; color: #58a6ff; }
        .btn-container { display: flex; gap: 10px; justify-content: center; margin-top: 30px; }
        .btn {
            padding: 12px 30px;
            color: #f0f6fc;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            border: 1px solid #30363d;
        }
        .btn-primary { background: #238636; }
        .btn-primary:hover { background: #2ea043; }
        .btn-danger { background: #da3633; }
        .btn-danger:hover { background: #f85149; }
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            margin-top: 10px;
        }
        .status-pass { background: rgba(63, 185, 80, 0.2); color: #3fb950; border: 1px solid #3fb950; }
        .status-fail { background: rgba(248, 81, 73, 0.2); color: #f85149; border: 1px solid #f85149; }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="result-icon"><%= icon %></div>
        <h1 class="result-title">Test Completed!</h1>
        <p class="result-message"><%= message %></p>
        
        <div class="score-circle"><%= score %>%</div>
        
        <div><span class="status-badge <%= statusClass %>"><%= statusText %></span></div>
        
        <div class="details">
            <p><span class="label">Test ID:</span> <span><%= testId %></span></p>
            <p><span class="label">User:</span> <span><%= user.getUsername() %></span></p>
            <p><span class="label">Role:</span> <span><%= user.getRole() %></span></p>
            <p><span class="label">Submitted:</span> <span><%= new java.util.Date() %></span></p>
        </div>
        
        <div class="btn-container">
            <a href="candidate_home.jsp" class="btn btn-primary">Back to Home</a>
            <a href="logout" class="btn btn-danger">Logout</a>
        </div>
    </div>
</body>
</html>