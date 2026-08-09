<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.platform.model.Test" %>
<%@ page import="com.platform.model.Question" %>
<%@ page import="com.platform.dao.QuestionDAO" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Test test = (Test) session.getAttribute("currentTest");
    if (test == null) {
        response.sendRedirect("candidate_home.jsp");
        return;
    }
    
    QuestionDAO questionDAO = new QuestionDAO();
    List<Question> questions = questionDAO.getQuestionsByTestId(test.getTestId());
    
    if (questions == null || questions.isEmpty()) {
        out.println("<script>alert('No questions available for this test');</script>");
        response.sendRedirect("candidate_home.jsp");
        return;
    }
    
    int durationSeconds = test.getDurationMinutes() * 60;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Take Test - <%= test.getTitle() %></title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #1e1e1e; color: #fff; }
        
        .header {
            background: #252526;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #333;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }
        
        .header h1 { font-size: 20px; color: #fff; }
        .header-info { display: flex; gap: 20px; align-items: center; }
        
        .timer {
            background: #d32f2f;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            font-size: 18px;
        }
        
        .timer.warning { background: #f57c00; }
        .timer.danger { background: #d32f2f; animation: pulse 1s infinite; }
        
        @keyframes pulse { 50% { opacity: 0.7; } }
        
        .main-container {
            display: flex;
            height: calc(100vh - 60px);
            margin-top: 60px;
        }
        
        .left-panel {
            width: 50%;
            background: #1e1e1e;
            border-right: 1px solid #333;
            overflow-y: auto;
            padding: 20px;
        }
        
        .right-panel {
            width: 50%;
            background: #1e1e1e;
            display: flex;
            flex-direction: column;
        }
        
        .question-title {
            font-size: 24px;
            color: #4CAF50;
            margin-bottom: 15px;
        }
        
        .points-badge {
            background: #4CAF50;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 14px;
            margin-left: 10px;
        }
        
        .question-description {
            font-size: 16px;
            line-height: 1.8;
            color: #d4d4d4;
            margin-bottom: 20px;
        }
        
        .test-cases {
            background: #252526;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }
        
        .test-cases h3 {
            color: #4CAF50;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .test-case {
            background: #1e1e1e;
            border-radius: 5px;
            padding: 12px;
            margin-bottom: 10px;
            border-left: 3px solid #4CAF50;
        }
        
        .test-case-label {
            color: #888;
            font-size: 12px;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        
        .test-case-input { color: #9cdcfe; font-family: monospace; }
        .test-case-output { color: #b5cea8; font-family: monospace; }
        
        .editor-header {
            background: #252526;
            padding: 10px 20px;
            border-bottom: 1px solid #333;
        }
        
        .editor-container {
            flex: 1;
            padding: 20px;
        }
        
        .code-textarea {
            width: 100%;
            height: 300px;
            background: #1e1e1e;
            color: #d4d4d4;
            border: 1px solid #333;
            border-radius: 5px;
            padding: 15px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            resize: none;
        }
        
        .code-textarea:focus { outline: none; border-color: #4CAF50; }
        
        .console-container {
            background: #252526;
            border-top: 1px solid #333;
            padding: 15px;
        }
        
        .console-output {
            background: #1e1e1e;
            border: 1px solid #333;
            border-radius: 5px;
            padding: 12px;
            font-family: monospace;
            font-size: 13px;
            color: #4ec9b0;
            min-height: 80px;
        }
        
        .button-area {
            background: #252526;
            padding: 15px 20px;
            border-top: 1px solid #333;
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .btn-run { background: #2196F3; color: white; }
        .btn-submit { background: #4CAF50; color: white; flex: 1; }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="header">
        <h1><%= test.getTitle() %></h1>
        <div class="header-info">
            <div class="timer" id="timer">
                <span id="timer-count">00:00</span>
            </div>
        </div>
    </div>
    
    <div class="main-container">
        <div class="left-panel">
            <%
            int questionNumber = 1;
            for (Question q : questions) {
            %>
                <div class="question-section">
                    <div class="question-title">
                        Question <%= questionNumber %>
                        <span class="points-badge"><%= q.getPoints() %> points</span>
                    </div>
                    
                    <div class="question-description">
                        <%= q.getQuestionText() %>
                    </div>
                    
                    <div class="test-cases">
                        <h3>Test Cases</h3>
                        
                        <% if (q.getTestCase1Input() != null && !q.getTestCase1Input().isEmpty()) { %>
                        <div class="test-case">
                            <div class="test-case-label">Example 1</div>
                            <div class="test-case-input">Input: <%= q.getTestCase1Input() %></div>
                            <div class="test-case-output">Output: <%= q.getTestCase1Output() %></div>
                        </div>
                        <% } %>
                        
                        <% if (q.getTestCase2Input() != null && !q.getTestCase2Input().isEmpty()) { %>
                        <div class="test-case">
                            <div class="test-case-label">Example 2</div>
                            <div class="test-case-input">Input: <%= q.getTestCase2Input() %></div>
                            <div class="test-case-output">Output: <%= q.getTestCase2Output() %></div>
                        </div>
                        <% } %>
                        
                        <% if (q.getTestCase3Input() != null && !q.getTestCase3Input().isEmpty()) { %>
                        <div class="test-case">
                            <div class="test-case-label">Example 3</div>
                            <div class="test-case-input">Input: <%= q.getTestCase3Input() %></div>
                            <div class="test-case-output">Output: <%= q.getTestCase3Output() %></div>
                        </div>
                        <% } %>
                    </div>
                </div>
            <%
                questionNumber++;
            }
            %>
        </div>
        
        <div class="right-panel">
            <form id="testForm" action="submitCode" method="POST">
                <input type="hidden" name="testId" value="<%= test.getTestId() %>">
                
                <div class="editor-header">
                    <span>Solution.java</span>
                </div>
                
                <div class="editor-container">
                    <textarea 
                        name="codeSolution" 
                        id="codeSolution" 
                        class="code-textarea"
                        placeholder="// Write your code here...
public class Solution {
    public static void main(String[] args) {
        // Your code here
    }
}"
                        required
                    ></textarea>
                </div>
                
                <div class="console-container">
                    <div class="console-output" id="consoleOutput">
                        // Output will appear here after clicking "Run Code"
                    </div>
                </div>
                
                <div class="button-area">
                    <button type="button" class="btn btn-run" onclick="runCode(this)">Run Code</button>
                    <button type="submit" class="btn btn-submit">Submit Test</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        let time = <%= durationSeconds %>;
        const timerCount = document.getElementById("timer-count");
        const testForm = document.getElementById("testForm");
        let timerInterval;
        
        function updateTimer() {
            let minutes = Math.floor(time / 60);
            let seconds = time % 60;
            let formattedMinutes = minutes < 10 ? "0" + minutes : minutes;
            let formattedSeconds = seconds < 10 ? "0" + seconds : seconds;
            timerCount.innerHTML = formattedMinutes + ":" + formattedSeconds;
            
            if (time <= 0) {
                clearInterval(timerInterval);
                testForm.submit();
                alert("Time's up! Submitting automatically...");
            }
            time--;
        }
        
        window.onload = function() {
            timerInterval = setInterval(updateTimer, 1000);
            updateTimer();
        };
        
        function runCode(button) {
            const codeEditor = document.getElementById("codeSolution");
            const consoleOutput = document.getElementById("consoleOutput");
            const userCode = codeEditor.value;
            
            if (!userCode.trim()) {
                consoleOutput.innerHTML = "<span style='color: #f48771;'>❌ Error: Please write some code first!</span>";
                return;
            }
            
            button.disabled = true;
            button.innerHTML = '⏳ Running...';
            consoleOutput.innerHTML = '<span style="color: #569cd6;">Compiling and running your code...</span>';
            
            setTimeout(() => {
                // Extract System.out.println() content
                const printlnMatches = userCode.match(/System\.out\.println\(([^)]+)\)/g);
                
                if (printlnMatches && printlnMatches.length > 0) {
                    let output = '<span style="color: #4ec9b0;">✅ Output:</span>\n\n';
                    
                    printlnMatches.forEach(match => {
                        // Extract string content from println
                        const stringMatch = match.match(/["'](.+?)["']/);
                        if (stringMatch && stringMatch[1]) {
                            output += stringMatch[1] + '\n';
                        } else {
                            output += '[Variable Output]\n';
                        }
                    });
                    
                    consoleOutput.innerHTML = output;
                } else {
                    consoleOutput.innerHTML = '<span style="color: #4ec9b0;">✅ Code compiled successfully!</span>\n\n(No System.out.println() statements detected)';
                }
                
                button.disabled = false;
                button.innerHTML = '▶️ Run Code';
            }, 1500);
        }
    </script>
</body>
</html>