package com.platform.servlet;

import com.platform.dao.QuestionDAO;
import com.platform.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/addQuestion")
public class AddQuestionServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int testId = Integer.parseInt(request.getParameter("testId"));
        String questionText = request.getParameter("questionText");
        String expectedOutput = request.getParameter("expectedOutput");
        int points = Integer.parseInt(request.getParameter("points"));
        
        // ✅ Get Test Case Values
        String testCase1Input = request.getParameter("testCase1Input");
        String testCase1Output = request.getParameter("testCase1Output");
        String testCase2Input = request.getParameter("testCase2Input");
        String testCase2Output = request.getParameter("testCase2Output");
        String testCase3Input = request.getParameter("testCase3Input");
        String testCase3Output = request.getParameter("testCase3Output");
        
        QuestionDAO questionDAO = new QuestionDAO();
        boolean added = questionDAO.addQuestion(
            testId, questionText, expectedOutput, points,
            testCase1Input, testCase1Output,
            testCase2Input, testCase2Output,
            testCase3Input, testCase3Output
        );
        
        if (added) {
            response.sendRedirect("admin_dashboard.jsp?msg=questionAdded");
        } else {
            response.sendRedirect("addQuestion.jsp?testId=" + testId + "&msg=failed");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("addQuestion.jsp").forward(request, response);
    }
}