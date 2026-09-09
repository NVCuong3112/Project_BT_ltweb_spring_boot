package com.example.webapp.controller;

import com.example.webapp.model.User;
import com.example.webapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * Controller quản trị người dùng (@Controller, @RequestMapping("/admin/users")).
 * Hỗ trợ danh sách, tìm kiếm (derived query), xem chi tiết, sửa role/status, và xóa.
 */
@Controller
@RequestMapping("/admin/users")
public class UserController {

    private final UserRepository userRepository;

    @Autowired
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * 1. Danh sách người dùng và tìm kiếm theo username hoặc email.
     * Sử dụng derived query method findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase.
     */
    @GetMapping
    public String listUsers(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<User> users;
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userRepository.findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                    keyword.trim(), keyword.trim()
            );
            model.addAttribute("keyword", keyword.trim());
        } else {
            users = userRepository.findAll(Sort.by(Sort.Direction.DESC, "id"));
        }

        model.addAttribute("users", users);
        return "admin/user-list";
    }

    /**
     * 2. Xem chi tiết thông tin người dùng.
     */
    @GetMapping("/detail")
    public String userDetail(@RequestParam("id") int id, Model model) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            return "redirect:/admin/users";
        }
        model.addAttribute("user", user);
        return "admin/user-detail";
    }

    /**
     * 3. Mở form chỉnh sửa vai trò (Role) và trạng thái kích hoạt (Status).
     */
    @GetMapping("/edit")
    public String showEditUserForm(@RequestParam("id") int id, Model model) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            return "redirect:/admin/users";
        }
        model.addAttribute("user", user);
        return "admin/user-form";
    }

    /**
     * 4. Xử lý cập nhật thông tin vai trò, trạng thái tài khoản.
     */
    @PostMapping("/edit")
    public String updateUser(@RequestParam("id") int id,
                             @RequestParam("role") String role,
                             @RequestParam("status") int status,
                             @RequestParam(value = "fullName", required = false) String fullName,
                             @RequestParam(value = "phone", required = false) String phone,
                             RedirectAttributes redirectAttributes) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
            return "redirect:/admin/users";
        }

        try {
            user.setRole(role != null ? role.trim() : "USER");
            user.setStatus(status);
            if (fullName != null) {
                user.setFullName(fullName.trim());
            }
            if (phone != null) {
                user.setPhone(phone.trim());
            }

            userRepository.save(user);
            redirectAttributes.addFlashAttribute("success", "Cập nhật tài khoản " + user.getUsername() + " thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Cập nhật tài khoản thất bại: " + e.getMessage());
        }

        return "redirect:/admin/users";
    }

    /**
     * 5. Xử lý xóa tài khoản người dùng theo id.
     */
    @GetMapping("/delete")
    public String deleteUser(@RequestParam("id") int id, RedirectAttributes redirectAttributes) {
        try {
            if (userRepository.existsById(id)) {
                userRepository.deleteById(id);
                redirectAttributes.addFlashAttribute("success", "Xóa tài khoản thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Tài khoản không tồn tại!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }
}
