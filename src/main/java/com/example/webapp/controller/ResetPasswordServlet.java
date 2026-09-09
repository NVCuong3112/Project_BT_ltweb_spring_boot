package com.example.webapp.controller;

import com.example.webapp.dto.ResetPasswordForm;
import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import com.example.webapp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý Xác thực OTP và Đặt lại mật khẩu mới.
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        request.setAttribute("email", email);
        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otpCode");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        ResetPasswordForm form = new ResetPasswordForm(email, otpCode, newPassword, confirmPassword);
        Map<String, String> errors = new HashMap<>(ValidationUtil.validate(form));

        if (newPassword != null && !newPassword.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp!");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("error", "Dữ liệu đặt lại mật khẩu không hợp lệ!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            boolean resetSuccess = userService.resetPassword(email, otpCode, newPassword);
            if (resetSuccess) {
                request.getSession().setAttribute("flashSuccess", "Đặt lại mật khẩu thành công! Hãy đăng nhập với mật khẩu mới.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng kiểm tra lại mã OTP!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}
