<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    int testId = 0;
    if (request.getParameter("testId") != null) {
        testId = Integer.parseInt(request.getParameter("testId"));
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Question to Test</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f4f4f4;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        .header {
            background: #333;
            color: white;
            padding: 20px;
            border-radius: 10px 10px 0 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header h1 { font-size: 24px; }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
        }
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: #4CAF50;
        }
        
        /* Test Cases Section */
        .test-cases-section {
            background: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
        .test-cases-section h3 {
            color: #4CAF50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .test-case-group {
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .test-case-group:last-child { margin-bottom: 0; }
        .test-case-group h4 {
            color: #333;
            margin-bottom: 15px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .test-case-row {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
        }
        .test-case-row:last-child { margin-bottom: 0; }
        .test-case-row .form-group { flex: 1; margin-bottom: 0; }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover { background: #45a049; }
        .btn-secondary {
            background: #667eea;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary:hover { background: #5568d3; }
        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .help-text {
            color: #666;
            font-size: 13px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <span style="font-size: 30px;">➕</span>
            <h1>Add Question to Test</h1>
        </div>
        
        <div class="form-container">
            <form action="addQuestion" method="POST">
                <input type="hidden" name="testId" value="<%= testId %>">
                
                <!-- Question Text -->
                <div class="form-group">
                    <label for="questionText">Question Text *</label>
                    <textarea 
                        id="questionText" 
                        name="questionText" 
                        required 
                        placeholder="Enter the question description. Include problem statement, constraints, and any examples."
                    ></textarea>
                    <p class="help-text">Describe the problem clearly. Include input/output format if needed.</p>
                </div>
                
                <!-- Expected Output -->
                <div class="form-group">
                    <label for="expectedOutput">Expected Output *</label>
                    <input 
                        type="text" 
                        id="expectedOutput" 
                        name="expectedOutput" 
                        required 
                        placeholder="Enter expected output for validation"
                    />
                    <p class="help-text">This will be used to validate the candidate's output.</p>
                </div>
                
                <!-- Points -->
                <div class="form-group">
                    <label for="points">Points *</label>
                    <input 
                        type="number" 
                        id="points" 
                        name="points" 
                        required 
                        value="10" 
                        min="1"
                    />
                </div>
                
                <!-- Test Cases Section -->
                <div class="test-cases-section">
                    <h3>🧪 Test Cases</h3>
                    <p class="help-text" style="margin-bottom: 15px;">
                        Add sample test cases to help candidates understand the expected input/output format.
                    </p>
                    
                    <!-- Test Case 1 -->
                    <div class="test-case-group">
                        <h4>📌 Test Case 1</h4>
                        <div class="test-case-row">
                            <div class="form-group">
                                <label for="testCase1Input">Input</label>
                                <input 
                                    type="text" 
                                    id="testCase1Input" 
                                    name="testCase1Input" 
                                    placeholder="e.g., 5"
                                />
                            </div>
                            <div class="form-group">
                                <label for="testCase1Output">Expected Output</label>
                                <input 
                                    type="text" 
                                    id="testCase1Output" 
                                    name="testCase1Output" 
                                    placeholder="e.g., Hello"
                                />
                            </div>
                        </div>
                    </div>
                    
                    <!-- Test Case 2 -->
                    <div class="test-case-group">
                        <h4>📌 Test Case 2</h4>
                        <div class="test-case-row">
                            <div class="form-group">
                                <label for="testCase2Input">Input</label>
                                <input 
                                    type="text" 
                                    id="testCase2Input" 
                                    name="testCase2Input" 
                                    placeholder="e.g., 10"
                                />
                            </div>
                            <div class="form-group">
                                <label for="testCase2Output">Expected Output</label>
                                <input 
                                    type="text" 
                                    id="testCase2Output" 
                                    name="testCase2Output" 
                                    placeholder="e.g., Hello World"
                                />
                            </div>
                        </div>
                    </div>
                    
                    <!-- Test Case 3 -->
                    <div class="test-case-group">
                        <h4>📌 Test Case 3</h4>
                        <div class="test-case-row">
                            <div class="form-group">
                                <label for="testCase3Input">Input</label>
                                <input 
                                    type="text" 
                                    id="testCase3Input" 
                                    name="testCase3Input" 
                                    placeholder="e.g., 0"
                                />
                            </div>
                            <div class="form-group">
                                <label for="testCase3Output">Expected Output</label>
                                <input 
                                    type="text" 
                                    id="testCase3Output" 
                                    name="testCase3Output" 
                                    placeholder="e.g., Invalid Input"
                                />
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Buttons -->
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Add Question</button>
                    <a href="admin_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>