package com.example.webapp.controller;

import com.example.webapp.model.User;
import com.example.webapp.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/session-login")
public class SessionLoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward tới trang login.jsp
        request.getRequestDispatcher("/session-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            // Gọi service để xử lý logic (xác thực BCrypt & kiểm tra status=1)
            User user = userService.login(username, password);

            if (user != null) {
                // Tạo session và lưu thông tin user
                HttpSession session = request.getSession();
                session.setAttribute("loggedUser", user);
                
                // Redirect tới dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/session-login.jsp").forward(request, response);
        }
    }
}
