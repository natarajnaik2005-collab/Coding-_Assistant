package com.platform.servlet;

import com.platform.dao.TestDAO;
import com.platform.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/createTest")
public class CreateTestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        int duration = Integer.parseInt(request.getParameter("duration"));

        TestDAO testDAO = new TestDAO();
        boolean created = testDAO.createTest(title, duration, user.getUserId());

        if (created) {
            response.sendRedirect("admin_dashboard.jsp?msg=testCreated");
        } else {
            response.sendRedirect("admin_dashboard.jsp?msg=testFailed");
        }
    }
}