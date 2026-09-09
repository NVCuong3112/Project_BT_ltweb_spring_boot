package com.example.webapp.controller;

import com.example.webapp.model.User;
import com.example.webapp.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cookie-login")
public class CookieLoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Đọc Cookie để xem đã có username chưa
        Cookie[] cookies = request.getCookies();
        String savedUsername = "";
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("savedUsername".equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                    break;
                }
            }
        }
        
        // Gửi username đã lưu sang JSP để hiển thị
        request.setAttribute("savedUsername", savedUsername);
        request.getRequestDispatcher("/cookie-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe"); // "on" if checked

        try {
            User user = userService.login(username, password);

            if (user != null) {
                // Xử lý Remember Me (Cookie)
                if ("on".equals(rememberMe)) {
                    Cookie userCookie = new Cookie("savedUsername", username);
                    userCookie.setMaxAge(60 * 60 * 24 * 7); // Tồn tại trong 7 ngày
                    userCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(userCookie);
                } else {
                    Cookie userCookie = new Cookie("savedUsername", "");
                    userCookie.setMaxAge(0);
                    userCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(userCookie);
                }

                // Lưu thông tin người dùng vào Session
                request.getSession().setAttribute("loggedUser", user);
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("savedUsername", username);
            request.getRequestDispatcher("/cookie-login.jsp").forward(request, response);
        }
    }
}
