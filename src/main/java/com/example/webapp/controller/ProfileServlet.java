package com.example.webapp.controller;

import com.example.webapp.dto.ProfileForm;
import com.example.webapp.model.User;
import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import com.example.webapp.util.Constants;
import com.example.webapp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet quản lý thông tin cá nhân (Profile).
 * Cho phép xem hồ sơ, cập nhật họ tên, số điện thoại và upload ảnh đại diện mới.
 */
@WebServlet("/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
                 maxFileSize = 1024 * 1024 * 5,
                 maxRequestSize = 1024 * 1024 * 5 * 5)
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return Constants.DEFAULT_FILENAME;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin mới nhất từ database
        User freshUser = userService.findById(loggedUser.getId());
        if (freshUser == null) {
            freshUser = loggedUser;
        }

        request.setAttribute("user", freshUser);
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        User currentUser = userService.findById(loggedUser.getId());
        if (currentUser == null) {
            currentUser = loggedUser;
        }

        // Validate hai tầng (Server-side validation)
        ProfileForm form = new ProfileForm(fullName != null ? fullName.trim() : "", 
                                          phone != null ? phone.trim() : "");
        Map<String, String> errors = ValidationUtil.validate(form);

        if (!errors.isEmpty()) {
            currentUser.setFullName(fullName != null ? fullName.trim() : "");
            currentUser.setPhone(phone != null ? phone.trim() : "");
            request.setAttribute("user", currentUser);
            request.setAttribute("errors", errors);
            request.setAttribute("error", "Thông tin không hợp lệ! Vui lòng kiểm tra lại các trường.");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // Xử lý upload ảnh đại diện mới nếu có
        String uploadPath = Constants.UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String newAvatarFileName = currentUser.getAvatar();
        boolean hasNewAvatar = false;

        try {
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null 
                    && !filePart.getSubmittedFileName().trim().isEmpty()) {
                
                String originalFileName = getFileName(filePart);
                if (!Constants.DEFAULT_FILENAME.equals(originalFileName) && !originalFileName.trim().isEmpty()) {
                    if (originalFileName.contains("\\")) {
                        originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
                    } else if (originalFileName.contains("/")) {
                        originalFileName = originalFileName.substring(originalFileName.lastIndexOf("/") + 1);
                    }

                    // Tên file mới gắn timestamp chống trùng lặp
                    String savedName = "avatar_" + System.currentTimeMillis() + "_" + originalFileName;
                    filePart.write(uploadPath + File.separator + savedName);
                    
                    // Nếu trước đó có avatar cũ thì xóa file cũ đi để giải phóng dung lượng
                    String oldAvatar = currentUser.getAvatar();
                    if (oldAvatar != null && !oldAvatar.trim().isEmpty()) {
                        File oldFile = new File(uploadPath + File.separator + oldAvatar);
                        if (oldFile.exists() && oldFile.isFile()) {
                            try {
                                oldFile.delete();
                            } catch (Exception ignored) {}
                        }
                    }

                    newAvatarFileName = savedName;
                    hasNewAvatar = true;
                }
            }
        } catch (Exception e) {
            // Không phải file hợp lệ hoặc lỗi upload
            System.err.println("Lỗi xử lý file avatar: " + e.getMessage());
        }

        try {
            // Cập nhật database qua JPA
            boolean updated = userService.updateProfile(currentUser.getId(), 
                                                        fullName != null ? fullName.trim() : "", 
                                                        phone != null ? phone.trim() : "", 
                                                        hasNewAvatar ? newAvatarFileName : currentUser.getAvatar());
            if (updated) {
                // Cập nhật lại đối tượng User trong Session
                User updatedUser = userService.findById(currentUser.getId());
                session.setAttribute("loggedUser", updatedUser);
                session.setAttribute("flashSuccess", "Cập nhật hồ sơ cá nhân thành công!");
                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ thất bại! Vui lòng thử lại.");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }
}
