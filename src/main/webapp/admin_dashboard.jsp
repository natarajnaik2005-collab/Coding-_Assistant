<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.User" %>
<%@ page import="com.platform.dao.TestDAO" %>
<%@ page import="com.platform.model.Test" %>
<%@ page import="java.util.List" %>
<%
    // Debug session
    System.out.println("=== ADMIN DASHBOARD ACCESSED ===");
    User user = (User) session.getAttribute("currentUser");
    System.out.println("Session User: " + (user != null ? user.getUsername() : "NULL"));
    System.out.println("Session Role: " + session.getAttribute("role"));
    
    // Check if user is admin
    if (user == null || !"ADMIN".equals(user.getRole())) {
        System.out.println("Redirecting to login - Not admin");
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Test> tests = new TestDAO().getAllTests();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        
        .navbar {
            background: #333;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        
        .card {
            background: white;
            padding: 25px;
            margin: 20px 0;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .card h2 { 
            color: #333; 
            margin-bottom: 20px;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        
        .btn:hover { background: #45a049; }
        
        .btn-danger { background: #f44336; }
        .btn-danger:hover { background: #da190b; }
        
        .btn-secondary { background: #2196F3; }
        .btn-secondary:hover { background: #1976D2; }
        
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
        
        th { 
            background: #4CAF50; 
            color: white;
            font-weight: bold;
        }
        
        tr:hover { background: #f5f5f5; }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { 
            display: block; 
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        
        .logout-link {
            color: #f44336;
            text-decoration: none;
            font-weight: bold;
        }
        
        .logout-link:hover { text-decoration: underline; }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>‍💼 Admin Dashboard</h1>
        <div>
            <span>Welcome, <%= user.getUsername() %></span>
            <a href="logout" class="logout-link" style="margin-left: 20px;">Logout</a>
        </div>
    </div>
    
    <div class="container">
        <!-- Create New Test -->
        <div class="card">
            <h2>📝 Create New Test</h2>
            <form action="createTest" method="POST">
                <div class="form-group">
                    <label>Test Title</label>
                    <input type="text" name="title" required placeholder="Enter test title">
                </div>
                <div class="form-group">
                    <label>Duration (minutes)</label>
                    <input type="number" name="duration" required placeholder="Enter duration">
                </div>
                <button type="submit" class="btn">Create Test</button>
            </form>
        </div>
        
        <!-- View All Tests -->
        <div class="card">
            <h2> All Tests</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Duration</th>
                    <th>Actions</th>
                </tr>
                <% if (tests != null && !tests.isEmpty()) { 
                    for (Test test : tests) { %>
                <tr>
                    <td><%= test.getTestId() %></td>
                    <td><%= test.getTitle() %></td>
                    <td><%= test.getDurationMinutes() %> mins</td>
                    <td>
                        <div class="action-buttons">
                            <a href="addQuestion.jsp?testId=<%= test.getTestId() %>" class="btn btn-secondary">
                                Add Questions
                            </a>
                            <a href="viewResults.jsp?testId=<%= test.getTestId() %>" class="btn">
                                View Results
                            </a>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="4" style="text-align: center; color: #666; padding: 40px;">
                        No tests created yet. Create your first test above!
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html>