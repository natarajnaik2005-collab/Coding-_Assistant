package com.platform.dao;

import com.platform.model.Test;
import com.platform.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestDAO {
    
    public boolean createTest(String title, int duration, int createdBy) {
        String sql = "INSERT INTO tests (title, duration_minutes, created_by) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, title);
            ps.setInt(2, duration);
            ps.setInt(3, createdBy);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Test getTestById(int testId) {
        String sql = "SELECT * FROM tests WHERE test_id = ?";
        Test test = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                test = new Test();
                test.setTestId(rs.getInt("test_id"));
                test.setTitle(rs.getString("title"));
                test.setDurationMinutes(rs.getInt("duration_minutes"));
                test.setCreatedBy(rs.getInt("created_by"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return test;
    }
    
    public List<Test> getAllTests() {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT * FROM tests";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Test test = new Test();
                test.setTestId(rs.getInt("test_id"));
                test.setTitle(rs.getString("title"));
                test.setDurationMinutes(rs.getInt("duration_minutes"));
                test.setCreatedBy(rs.getInt("created_by"));
                tests.add(test);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return tests;
    }
}