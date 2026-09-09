package com.example.webapp.controller;

import com.example.webapp.dto.ActivateAccountForm;
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
 * Servlet xác nhận mã OTP kích hoạt tài khoản.
 */
@WebServlet("/activate-account")
public class ActivateAccountServlet extends HttpServlet {
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
        request.getRequestDispatcher("/activate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otpCode");

        ActivateAccountForm form = new ActivateAccountForm(email, otpCode);
        Map<String, String> errors = ValidationUtil.validate(form);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("error", "Dữ liệu kích hoạt không hợp lệ!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
            return;
        }

        try {
            boolean activated = userService.activateAccount(email, otpCode);
            if (activated) {
                request.getSession().setAttribute("flashSuccess", "Kích hoạt tài khoản thành công! Hãy đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("error", "Kích hoạt thất bại. Vui lòng kiểm tra lại mã OTP!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
        }
    }
}
