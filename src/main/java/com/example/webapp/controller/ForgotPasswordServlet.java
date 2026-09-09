package com.example.webapp.controller;

import com.example.webapp.dto.ForgotPasswordForm;
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
 * Servlet xử lý yêu cầu Quên mật khẩu.
 * Kiểm tra tính hợp lệ của email qua Jakarta Bean Validation, sinh mã OTP và gửi về hòm thư.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // 1. Kiểm tra validation
        ForgotPasswordForm form = new ForgotPasswordForm(email);
        Map<String, String> errors = ValidationUtil.validate(form);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            userService.forgotPassword(email);
            // Gửi OTP thành công -> Chuyển sang trang nhập OTP và mật khẩu mới
            response.sendRedirect(request.getContextPath() + "/reset-password?email=" + email);
        } catch (Exception e) {
            errors.put("email", e.getMessage());
            request.setAttribute("errors", errors);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}
