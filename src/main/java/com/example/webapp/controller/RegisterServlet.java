package com.example.webapp.controller;

import com.example.webapp.dto.RegisterForm;
import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import com.example.webapp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

/**
 * Servlet xử lý Đăng ký tài khoản người dùng mới.
 * Tích hợp kiểm tra dữ liệu bằng Jakarta Bean Validation và giữ lại dữ liệu form khi lỗi.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        // 1. Kiểm tra validation với Jakarta Bean Validation
        RegisterForm form = new RegisterForm(fullName, username, email, password, confirmPassword);
        Map<String, String> errors = ValidationUtil.validate(form);

        // Kiểm tra khớp mật khẩu xác nhận
        if (password != null && !password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp!");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            userService.register(username, password, email, fullName);
            // Đăng ký thành công -> Chuyển sang trang nhập mã OTP kích hoạt
            response.sendRedirect(request.getContextPath() + "/activate-account?email=" + email);
        } catch (Exception e) {
            String msg = e.getMessage();
            if (msg != null && msg.contains("đăng nhập")) {
                errors.put("username", msg);
            } else if (msg != null && msg.contains("Email")) {
                errors.put("email", msg);
            } else {
                request.setAttribute("error", msg);
            }
            request.setAttribute("errors", errors);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
