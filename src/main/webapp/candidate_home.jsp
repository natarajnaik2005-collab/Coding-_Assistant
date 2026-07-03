<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.User" %>
<%@ page import="com.platform.dao.TestDAO" %>
<%@ page import="com.platform.model.Test" %>
<%@ page import="java.util.List" %>
<%
    // Check if user is logged in
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User user = (User) session.getAttribute("currentUser");
    
    // Check if candidate
    if (!"CANDIDATE".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get all available tests
    List<Test> tests = new TestDAO().getAllTests();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Dashboard</title>
    <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
        font-family: 'Segoe UI', Arial, sans-serif; 
        background: #0d1117; 
        color: #c9d1d9;
    }
    
    .navbar {
        background: #161b22;
        color: #f0f6fc;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #30363d;
    }
    
    .navbar h1 { font-size: 24px; }
    
    .user-info { display: flex; align-items: center; gap: 20px; }
    
    .logout-btn {
        color: #f0f6fc;
        text-decoration: none;
        padding: 8px 15px;
        background: #21262d;
        border: 1px solid #30363d;
        border-radius: 5px;
        transition: all 0.3s;
    }
    
    .logout-btn:hover { 
        background: #30363d;
        border-color: #8b949e;
    }
    
    .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
    
    .welcome {
        background: #161b22;
        padding: 30px;
        margin-bottom: 20px;
        border-radius: 10px;
        border: 1px solid #30363d;
    }
    
    .welcome h2 { color: #58a6ff; margin-bottom: 10px; }
    .welcome p { color: #8b949e; }
    
    .stats {
        display: flex;
        gap: 20px;
        margin-top: 20px;
    }
    
    .stat-card {
        background: #21262d;
        color: #f0f6fc;
        padding: 20px;
        border-radius: 10px;
        flex: 1;
        text-align: center;
        border: 1px solid #30363d;
    }
    
    .stat-card h3 { font-size: 36px; margin-bottom: 5px; color: #58a6ff; }
    .stat-card p { opacity: 0.9; color: #8b949e; }
    
    .test-card {
        background: #161b22;
        padding: 25px;
        margin: 15px 0;
        border-radius: 10px;
        border: 1px solid #30363d;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: all 0.2s;
    }
    
    .test-card:hover {
        border-color: #58a6ff;
        box-shadow: 0 0 10px rgba(88, 166, 255, 0.2);
    }
    
    .test-info h3 { color: #f0f6fc; margin-bottom: 10px; font-size: 20px; }
    .test-info p { color: #8b949e; margin: 5px 0; }
    .test-info .label { font-weight: bold; color: #58a6ff; }
    
    .start-btn {
        padding: 12px 30px;
        background: #238636;
        color: #f0f6fc;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        transition: all 0.2s;
        display: inline-block;
        border: 1px solid rgba(240,246,252,0.1);
    }
    
    .start-btn:hover { 
        background: #2ea043;
        transform: translateY(-2px);
    }
    
    .no-tests {
        text-align: center;
        color: #8b949e;
        padding: 60px 20px;
        background: #161b22;
        border-radius: 10px;
        border: 1px solid #30363d;
    }
    
    .no-tests h3 { margin-bottom: 10px; color: #f0f6fc; }
</style>
</head>
<body>
    <div class="navbar">
        <h1>👨‍💻 Candidate Dashboard</h1>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %></span>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome">
            <h2>📋 Available Tests</h2>
            <p>Select a test below to start your assessment. Make sure you have enough time before starting!</p>
            
            <div class="stats">
                <div class="stat-card">
                    <h3><%= tests != null ? tests.size() : 0 %></h3>
                    <p>Available Tests</p>
                </div>
                <div class="stat-card">
                    <h3>∞</h3>
                    <p>Attempts Allowed</p>
                </div>
            </div>
        </div>
        
        <% if (tests != null && !tests.isEmpty()) { %>
            <% for (Test test : tests) { %>
                <div class="test-card">
                    <div class="test-info">
                        <h3>📝 <%= test.getTitle() %></h3>
                        <p><span class="label">⏱️ Duration:</span> <%= test.getDurationMinutes() %> minutes</p>
                        <p><span class="label">📌 Test ID:</span> <%= test.getTestId() %></p>
                    </div>
                    <a href="startTest?testId=<%= test.getTestId() %>" class="start-btn">
                        Start Test →
                    </a>
                </div>
            <% } %>
        <% } else { %>
            <div class="no-tests">
                <h3>📭 No Tests Available</h3>
                <p>There are no tests available at the moment. Please check back later or contact your administrator.</p>
            </div>
        <% } %>
    </div>
</body>
</html>