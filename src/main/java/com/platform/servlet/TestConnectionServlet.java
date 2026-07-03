package com.platform.servlet;

import com.platform.util.DBConnection;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

public class TestConnectionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            Connection conn = DBConnection.getConnection();
            res.getWriter().println("✅ Connection Successful!");
            conn.close();
        } catch (Exception e) {
            res.getWriter().println("❌ Connection Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}