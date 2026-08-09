package com.platform.servlet;

import com.platform.dao.UserDAO;
import com.platform.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Debug output
        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Username: " + username);
        System.out.println("Password Length: " + (password != null ? password.length() : 0));
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser(username.trim(), password);
        
        System.out.println("User Object: " + (user != null ? "Found" : "Not Found"));
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            System.out.println("User Role: " + user.getRole());
            
            // Redirect based on role
            if ("ADMIN".equals(user.getRole())) {
                System.out.println("Redirecting to: admin_dashboard.jsp");
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                System.out.println("Redirecting to: candidate_home.jsp");
                response.sendRedirect("candidate_home.jsp");
            }
        } else {
            // Login failed
            System.out.println("Login Failed - Invalid credentials");
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}