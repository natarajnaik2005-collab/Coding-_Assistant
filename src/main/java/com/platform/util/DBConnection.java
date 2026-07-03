package com.platform.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    // ✅ Updated URL with timezone and SSL settings
    private static final String URL = "jdbc:mysql://localhost:3306/coding_platform?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "Sachin@123"; // Change to your MySQL password
    
    static {
        try {
            // ✅ Explicitly load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver Loaded Successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver Not Found - Add mysql-connector-java.jar to classpath");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Database Connection Established!");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Database Connection Failed!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            e.printStackTrace();
            throw e;
        }
    }
    
    // Test connection method
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Connection Test Successful!");
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection Test Failed!");
            e.printStackTrace();
        }
    }
}