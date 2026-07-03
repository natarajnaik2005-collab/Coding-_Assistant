<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.User" %>
<%@ page import="com.platform.dao.ResultDAO" %>
<%@ page import="com.platform.model.Result" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.platform.util.DBConnection" %>
<%
    // Check if user is admin
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int testId = 0;
    if (request.getParameter("testId") != null) {
        testId = Integer.parseInt(request.getParameter("testId"));
    }
    
    // Fetch results from database
    List<Result> results = new java.util.ArrayList<>();
    String sql = "SELECT r.*, u.username FROM results r JOIN users u ON r.user_id = u.user_id";
    if (testId > 0) {
        sql += " WHERE r.test_id = " + testId;
    }
    
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        
        while (rs.next()) {
            Result r = new Result();
            r.setResultId(rs.getInt("result_id"));
            r.setUserId(rs.getInt("user_id"));
            r.setTestId(rs.getInt("test_id"));
            r.setScore(rs.getInt("score"));
            r.setSubmissionTime(rs.getTimestamp("submission_time"));
            results.add(r);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Results</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        
        .navbar {
            background: #333;
            color: white;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
        }
        
        .container { max-width: 1200px; margin: 0 auto; }
        
        .card {
            background: white;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th { background: #4CAF50; color: white; }
        tr:hover { background: #f5f5f5; }
        
        .score-high { color: #4CAF50; font-weight: bold; }
        .score-medium { color: #ff9800; font-weight: bold; }
        .score-low { color: #f44336; font-weight: bold; }
        
        .btn {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        
        .btn:hover { background: #5568d3; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📊 Test Results</h1>
        <div>
            <a href="admin_dashboard.jsp" class="btn">← Back to Dashboard</a>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>📋 All Submissions</h2>
            
            <% if (results != null && !results.isEmpty()) { %>
                <table>
                    <tr>
                        <th>Result ID</th>
                        <th>Username</th>
                        <th>Test ID</th>
                        <th>Score</th>
                        <th>Submission Time</th>
                    </tr>
                    <% for (Result r : results) { %>
                        <tr>
                            <td><%= r.getResultId() %></td>
                            <td><%= r.getUserId() %></td>
                            <td><%= r.getTestId() %></td>
                            <td>
                                <% if (r.getScore() >= 80) { %>
                                    <span class="score-high"><%= r.getScore() %>%</span>
                                <% } else if (r.getScore() >= 50) { %>
                                    <span class="score-medium"><%= r.getScore() %>%</span>
                                <% } else { %>
                                    <span class="score-low"><%= r.getScore() %>%</span>
                                <% } %>
                            </td>
                            <td><%= r.getSubmissionTime() %></td>
                        </tr>
                    <% } %>
                </table>
            <% } else { %>
                <p style="text-align: center; color: #666; padding: 40px;">
                    No submissions yet for this test.
                </p>
            <% } %>
        </div>
    </div>
</body>
</html>