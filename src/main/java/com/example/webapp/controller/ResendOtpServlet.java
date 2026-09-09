package com.example.webapp.controller;

import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet xử lý yêu cầu gửi lại mã OTP.
 */
@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {
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
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "REGISTER";
        }

        try {
            userService.resendOtp(email, type);
            if ("FORGOT_PASSWORD".equalsIgnoreCase(type)) {
                request.setAttribute("success", "Mã OTP mới đã được gửi tới email của bạn!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("success", "Mã OTP kích hoạt mới đã được gửi tới email của bạn!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            if ("FORGOT_PASSWORD".equalsIgnoreCase(type)) {
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
            }
        }
    }
}
