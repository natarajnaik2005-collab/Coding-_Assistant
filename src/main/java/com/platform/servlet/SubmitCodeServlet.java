package com.platform.servlet;

import com.platform.dao.QuestionDAO;
import com.platform.dao.ResultDAO;
import com.platform.model.Question;
import com.platform.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.*;
import java.nio.file.*;
import java.util.List;

@WebServlet("/submitCode")
public class SubmitCodeServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int testId = Integer.parseInt(request.getParameter("testId"));
            String userCode = request.getParameter("codeSolution");
            
            System.out.println("=== CODE SUBMISSION ===");
            System.out.println("User: " + user.getUsername());
            System.out.println("Test ID: " + testId);
            System.out.println("Code Length: " + (userCode != null ? userCode.length() : 0));
            
            // Calculate score based on output matching
            int score = calculateScore(testId, userCode);
            
            System.out.println("Calculated Score: " + score);
            
            // Save result to database
            ResultDAO resultDAO = new ResultDAO();
            boolean saved = resultDAO.saveResult(user.getUserId(), testId, score);
            
            if (saved) {
                response.sendRedirect("result.jsp?score=" + score + "&testId=" + testId);
            } else {
                response.sendRedirect("error.jsp?message=Failed to save result");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Submission error: " + e.getMessage());
        }
    }
    
    private int calculateScore(int testId, String userCode) {
        QuestionDAO questionDAO = new QuestionDAO();
        List<Question> questions = questionDAO.getQuestionsByTestId(testId);
        
        int totalScore = 0;
        int maxScore = 0;
        
        for (Question q : questions) {
            maxScore += q.getPoints();
            
            System.out.println("\n--- Evaluating Question ---");
            System.out.println("Question ID: " + q.getQuestionId());
            System.out.println("Expected Output: " + q.getExpectedOutput());
            
            // Execute user's code and capture output
            String userOutput = executeCode(userCode);
            System.out.println("User Output: " + userOutput);
            
            // Compare outputs (trim whitespace for fair comparison)
            if (userOutput != null && 
                userOutput.trim().equalsIgnoreCase(q.getExpectedOutput().trim())) {
                totalScore += q.getPoints();
                System.out.println("✅ Match! Points awarded: " + q.getPoints());
            } else {
                System.out.println("❌ No match. Points: 0");
            }
        }
        
        // Calculate percentage
        if (maxScore > 0) {
            totalScore = (totalScore * 100) / maxScore;
        }
        
        System.out.println("\n=== FINAL SCORE ===");
        System.out.println("Total: " + totalScore + "%");
        
        return totalScore;
    }
    
    private String executeCode(String code) {
        StringBuilder output = new StringBuilder();
        
        try {
            // Create temporary directory for code execution
            Path tempDir = Files.createTempDirectory("code_execution");
            Path codeFile = tempDir.resolve("Solution.java");
            
            // Write code to file
            Files.writeString(codeFile, code);
            
            System.out.println("📁 Temp Directory: " + tempDir.toString());
            
            // Compile Java code
            ProcessBuilder compileBuilder = new ProcessBuilder(
                "javac", codeFile.toString()
            );
            compileBuilder.redirectErrorStream(true);
            compileBuilder.directory(tempDir.toFile());
            
            Process compileProcess = compileBuilder.start();
            String compileOutput = readProcessOutput(compileProcess);
            compileProcess.waitFor();
            
            System.out.println("Compilation Exit Code: " + compileProcess.exitValue());
            
            if (compileProcess.exitValue() != 0) {
                System.out.println("❌ Compilation Failed:");
                System.out.println(compileOutput);
                cleanup(tempDir);
                return "Compilation Error";
            }
            
            System.out.println("✅ Compilation Successful");
            
            // Run Java code
            ProcessBuilder runBuilder = new ProcessBuilder(
                "java", "Solution"
            );
            runBuilder.redirectErrorStream(true);
            runBuilder.directory(tempDir.toFile());
            
            Process runProcess = runBuilder.start();
            String runOutput = readProcessOutput(runProcess);
            runProcess.waitFor();
            
            System.out.println("Execution Exit Code: " + runProcess.exitValue());
            
            if (runProcess.exitValue() != 0) {
                System.out.println("❌ Runtime Error:");
                System.out.println(runOutput);
                cleanup(tempDir);
                return "Runtime Error";
            }
            
            output.append(runOutput.trim());
            System.out.println("📤 Captured Output: " + output.toString());
            
            // Cleanup temp files
            cleanup(tempDir);
            
        } catch (Exception e) {
            System.out.println("❌ Execution Error: " + e.getMessage());
            e.printStackTrace();
            output.append("Error: ").append(e.getMessage());
        }
        
        return output.toString();
    }
    
    private String readProcessOutput(Process process) throws IOException {
        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
        }
        return output.toString().trim();
    }
    
    private void cleanup(Path tempDir) {
        try {
            Files.walk(tempDir)
                .sorted((a, b) -> b.compareTo(a))
                .forEach(path -> {
                    try { Files.delete(path); } catch (IOException e) { }
                });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("candidate_home.jsp");
    }
}