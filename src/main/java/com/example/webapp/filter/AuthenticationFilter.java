package com.example.webapp.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter để kiểm tra Authentication.
 * Bảo vệ các URL cần đăng nhập: /dashboard, /admin/*, /categories, /profile, v.v.
 */
@WebFilter(urlPatterns = {
        "/dashboard", 
        "/admin/*",
        "/categories", 
        "/add-category", 
        "/edit-category", 
        "/delete-category",
        "/profile"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Lấy session hiện tại, không tạo mới nếu chưa có
        HttpSession session = httpRequest.getSession(false);
        
        // Kiểm tra xem đã login chưa
        boolean isLoggedIn = (session != null && session.getAttribute("loggedUser") != null);
        
        if (isLoggedIn) {
            // Đã đăng nhập, cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập, redirect về trang login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
}
