package com.platform.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.*;

@WebServlet("/runCode")
public class RunCodeServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        String code = request.getParameter("code");
        
        if (code == null || code.trim().isEmpty()) {
            response.getWriter().println("❌ Error: No code provided");
            return;
        }
        
        // ️ SECURITY WARNING: This is for learning purposes only!
        // In production, use a sandboxed environment like Judge0 or Docker
        
        PrintWriter out = response.getWriter();
        out.println("⏳ Compiling and running your code...\n");
        
        try {
            // Create temporary file
            Path tempDir = Files.createTempDirectory("code_execution");
            Path codeFile = tempDir.resolve("Solution.java");
            Files.writeString(codeFile, code);
            
            // Compile Java code
            ProcessBuilder compileBuilder = new ProcessBuilder(
                "javac", codeFile.toString()
            );
            compileBuilder.redirectErrorStream(true);
            Process compileProcess = compileBuilder.start();
            
            String compileOutput = readProcessOutput(compileProcess);
            compileProcess.waitFor();
            
            if (compileProcess.exitValue() != 0) {
                out.println("❌ Compilation Error:");
                out.println(compileOutput);
                cleanup(tempDir);
                return;
            }
            
            out.println("✅ Compilation successful!\n");
            out.println("📤 Output:\n");
            
            // Run Java code
            ProcessBuilder runBuilder = new ProcessBuilder(
                "java", "-cp", tempDir.toString(), "Solution"
            );
            runBuilder.redirectErrorStream(true);
            Process runProcess = runBuilder.start();
            
            String runOutput = readProcessOutput(runProcess);
            runProcess.waitFor();
            
            if (runProcess.exitValue() != 0) {
                out.println("❌ Runtime Error:");
                out.println(runOutput);
            } else {
                out.println(runOutput);
            }
            
            cleanup(tempDir);
            
        } catch (Exception e) {
            out.println("❌ Server Error: " + e.getMessage());
            e.printStackTrace();
        }
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
        return output.toString();
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
}