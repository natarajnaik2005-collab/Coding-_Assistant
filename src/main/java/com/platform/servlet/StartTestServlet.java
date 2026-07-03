package com.platform.servlet;

import com.platform.dao.TestDAO;
import com.platform.model.Test;
import com.platform.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/startTest")
public class StartTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("currentUser");
        
        // Only candidates can take tests
        if (!"CANDIDATE".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int testId = Integer.parseInt(request.getParameter("testId"));
            TestDAO testDAO = new TestDAO();
            Test test = testDAO.getTestById(testId);
            
            if (test != null) {
                // Store test in session for take_test.jsp
                session.setAttribute("currentTest", test);
                response.sendRedirect("take_test.jsp");
            } else {
                response.sendRedirect("candidate_home.jsp?error=testNotFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("candidate_home.jsp?error=invalidTestId");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}