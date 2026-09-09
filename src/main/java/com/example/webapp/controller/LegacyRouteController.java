package com.example.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Controller điều hướng các đường dẫn cũ sang tiền tố chuẩn /admin/categories
 * để bảo toàn trải nghiệm và tương thích ngược với các liên kết cũ.
 */
@Controller
public class LegacyRouteController {

    @GetMapping("/categories")
    public String redirectCategories(@RequestParam(value = "keyword", required = false) String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return "redirect:/admin/categories?keyword=" + keyword.trim();
        }
        return "redirect:/admin/categories";
    }

    @GetMapping("/add-category")
    public String redirectAddCategory() {
        return "redirect:/admin/categories/add";
    }

    @GetMapping("/edit-category")
    public String redirectEditCategory(@RequestParam("id") int id) {
        return "redirect:/admin/categories/edit?id=" + id;
    }

    @GetMapping("/delete-category")
    public String redirectDeleteCategory(@RequestParam("id") int id) {
        return "redirect:/admin/categories/delete?id=" + id;
    }
}
