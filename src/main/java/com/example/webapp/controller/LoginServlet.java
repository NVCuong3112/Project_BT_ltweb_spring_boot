package com.example.webapp.controller;

import com.example.webapp.dto.LoginForm;
import com.example.webapp.model.User;
import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import com.example.webapp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

/**
 * Servlet đăng nhập chính của hệ thống.
 * Hỗ trợ xác thực BCrypt, kiểm tra trạng thái kích hoạt (status=1), 
 * xác thực form với Jakarta Bean Validation và ghi nhớ Remember Me qua Cookie.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Đọc Cookie để lấy lại username đã lưu (Remember Me)
        Cookie[] cookies = request.getCookies();
        String savedUsername = "";
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("savedUsername".equals(c.getName())) {
                    savedUsername = c.getValue();
                    break;
                }
            }
        }
        request.setAttribute("savedUsername", savedUsername);

        // Đọc thông báo flash từ session (nếu vừa kích hoạt hoặc đổi mật khẩu thành công)
        HttpSession session = request.getSession();
        String flashSuccess = (String) session.getAttribute("flashSuccess");
        if (flashSuccess != null) {
            request.setAttribute("success", flashSuccess);
            session.removeAttribute("flashSuccess");
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // 1. Kiểm tra validation với Jakarta Bean Validation
        LoginForm form = new LoginForm(username, password);
        Map<String, String> errors = ValidationUtil.validate(form);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Kiểm tra đăng nhập qua BCrypt và kiểm tra status = 1
            User user = userService.login(username, password);

            // Xử lý Remember Me bằng Cookie an toàn
            if ("on".equalsIgnoreCase(rememberMe)) {
                Cookie userCookie = new Cookie("savedUsername", username);
                userCookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
                userCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                response.addCookie(userCookie);
            } else {
                Cookie userCookie = new Cookie("savedUsername", "");
                userCookie.setMaxAge(0);
                userCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                response.addCookie(userCookie);
            }

            // Tạo Session lưu thông tin người dùng đăng nhập
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);

            // Đăng nhập thành công -> Điều hướng về Dashboard hoặc Trang chủ
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("savedUsername", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
