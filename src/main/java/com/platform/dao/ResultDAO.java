package com.platform.dao;

import com.platform.model.Result;
import com.platform.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO {
    
    // Save result to database
    public boolean saveResult(int userId, int testId, int score) {
        String sql = "INSERT INTO results (user_id, test_id, score) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, testId);
            ps.setInt(3, score);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get result by user and test
    public Result getResult(int userId, int testId) {
        String sql = "SELECT * FROM results WHERE user_id = ? AND test_id = ?";
        Result result = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, testId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = new Result();
                result.setResultId(rs.getInt("result_id"));
                result.setUserId(rs.getInt("user_id"));
                result.setTestId(rs.getInt("test_id"));
                result.setScore(rs.getInt("score"));
                result.setSubmissionTime(rs.getTimestamp("submission_time"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    public List<Result> getAllResults() {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT * FROM results ORDER BY submission_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Result r = new Result();
                r.setResultId(rs.getInt("result_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTestId(rs.getInt("test_id"));
                r.setScore(rs.getInt("score"));
                r.setSubmissionTime(rs.getTimestamp("submission_time"));
                results.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return results;
    }

    public List<Result> getResultsByTestId(int testId) {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT * FROM results WHERE test_id = ? ORDER BY submission_time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Result r = new Result();
                r.setResultId(rs.getInt("result_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setTestId(rs.getInt("test_id"));
                r.setScore(rs.getInt("score"));
                r.setSubmissionTime(rs.getTimestamp("submission_time"));
                results.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return results;
    }
}