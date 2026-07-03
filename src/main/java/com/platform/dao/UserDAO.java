package com.platform.dao;

import com.platform.model.User;
import com.platform.util.DBConnection;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;
public class UserDAO {
    
	public User validateUser(String username, String password) {
	    User user = null;
	    String sql = "SELECT * FROM users WHERE username = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        ps.setString(1, username);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            String hashedPassword = rs.getString("password");
	            String role = rs.getString("role");
	            
	            System.out.println("Stored Hash: " + hashedPassword);
	            System.out.println("Stored Role: " + role);
	            
	            // Verify password
	            if (BCrypt.checkpw(password, hashedPassword)) {
	                user = new User();
	                user.setUserId(rs.getInt("user_id"));
	                user.setUsername(rs.getString("username"));
	                user.setRole(role); // ✅ Make sure role is set
	                System.out.println("Password Matched! Role: " + role);
	            } else {
	                System.out.println("Password Did Not Match");
	            }
	        } else {
	            System.out.println("User Not Found in Database");
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return user;
	}
    
    public boolean registerUser(String username, String password, String role) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt()); // ✅ Hash here
            ps.setString(2, hashedPassword);
            ps.setString(3, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}