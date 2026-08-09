package com.platform.util;

import org.mindrot.jbcrypt.BCrypt;

public class TestBCrypt {
    public static void main(String[] args) {
        String plainPassword = "test123";
        
        // Hash the password
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        
        System.out.println("Plain Password: " + plainPassword);
        System.out.println("Hashed Password: " + hashedPassword);
        
        // Verify it works
        boolean matches = BCrypt.checkpw(plainPassword, hashedPassword);
        System.out.println("Password matches: " + matches);
    }
}