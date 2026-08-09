package com.platform.util;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        
        String loginURI = request.getContextPath() + "/login";
        String registerURI = request.getContextPath() + "/register";
        String cssURI = request.getContextPath() + "/css/";
        String jsURI = request.getContextPath() + "/js/";
        
        boolean loggedIn = session != null && session.getAttribute("currentUser") != null;
        boolean isLoginRequest = request.getRequestURI().equals(loginURI);
        boolean isRegisterRequest = request.getRequestURI().equals(registerURI);
        boolean isResourceRequest = request.getRequestURI().startsWith(cssURI) || 
                                    request.getRequestURI().startsWith(jsURI);
        
        System.out.println("=== AUTH FILTER ===");
        System.out.println("URI: " + request.getRequestURI());
        System.out.println("LoggedIn: " + loggedIn);
        System.out.println("IsLoginRequest: " + isLoginRequest);
        
        if (loggedIn || isLoginRequest || isRegisterRequest || isResourceRequest) {
            chain.doFilter(req, res);
        } else {
            System.out.println("Redirecting to login");
            response.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {}
}