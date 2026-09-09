package com.example.webapp.controller;

import com.example.webapp.dto.CategoryForm;
import com.example.webapp.model.Category;
import com.example.webapp.repository.CategoryRepository;
import com.example.webapp.service.CategoryService;
import com.example.webapp.util.ValidationUtil;
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
import java.util.Map;

/**
 * Controller quản lý danh mục (@Controller, @RequestMapping("/admin/categories")).
 * Gộp toàn bộ logic từ CategoryServlet, AddCategoryServlet, EditCategoryServlet, DeleteCategoryServlet.
 * Sử dụng Spring Data JPA CategoryRepository với derived query search.
 */
@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    private final CategoryRepository categoryRepository;
    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryRepository categoryRepository, CategoryService categoryService) {
        this.categoryRepository = categoryRepository;
        this.categoryService = categoryService;
    }

    /**
     * 1. Hiển thị danh sách danh mục và tìm kiếm theo keyword (thay thế CategoryServlet).
     * Forward tới view admin/category-list.
     */
    @GetMapping
    public String listCategories(@RequestParam(value = "keyword", required = false) String keyword, 
                                 Model model) {
        List<Category> categories;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Tận dụng derived query method tìm kiếm không phân biệt hoa thường
            categories = categoryRepository.findByCategorynameContainingIgnoreCase(keyword.trim());
            model.addAttribute("keyword", keyword.trim());
        } else {
            categories = categoryRepository.findAll(Sort.by(Sort.Direction.DESC, "id"));
        }

        model.addAttribute("categories", categories);
        return "admin/category-list";
    }

    /**
     * 2. Mở form thêm mới danh mục (thay thế AddCategoryServlet doGet).
     */
    @GetMapping("/add")
    public String showAddForm(Model model) {
        if (!model.containsAttribute("category")) {
            model.addAttribute("category", new Category());
        }
        return "admin/category-form";
    }

    /**
     * 3. Xử lý thêm mới danh mục (thay thế AddCategoryServlet doPost).
     */
    @PostMapping("/add")
    public String addCategory(@RequestParam("name") String name,
                              @RequestParam(value = "description", required = false) String description,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        Category category = new Category();
        category.setName(name != null ? name.trim() : "");
        category.setDescription(description != null ? description.trim() : "");

        CategoryForm form = new CategoryForm(category.getName(), category.getDescription());
        Map<String, String> errors = ValidationUtil.validate(form);
        if (!errors.isEmpty()) {
            model.addAttribute("errors", errors);
            model.addAttribute("error", "Dữ liệu danh mục không hợp lệ!");
            model.addAttribute("category", category);
            return "admin/category-form";
        }

        try {
            categoryRepository.save(category);
            redirectAttributes.addFlashAttribute("success", "Thêm mới danh mục thành công!");
            return "redirect:/admin/categories";
        } catch (Exception e) {
            model.addAttribute("error", "Lưu danh mục thất bại: " + e.getMessage());
            model.addAttribute("category", category);
            return "admin/category-form";
        }
    }

    /**
     * 4. Mở form chỉnh sửa danh mục (thay thế EditCategoryServlet doGet).
     */
    @GetMapping("/edit")
    public String showEditForm(@RequestParam("id") int id, Model model) {
        Category category = categoryRepository.findById(id).orElse(null);
        if (category == null) {
            return "redirect:/admin/categories";
        }
        model.addAttribute("category", category);
        return "admin/category-form";
    }

    /**
     * 5. Xử lý cập nhật danh mục (thay thế EditCategoryServlet doPost).
     */
    @PostMapping("/edit")
    public String editCategory(@RequestParam("id") int id,
                               @RequestParam("name") String name,
                               @RequestParam(value = "description", required = false) String description,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        Category category = new Category();
        category.setId(id);
        category.setName(name != null ? name.trim() : "");
        category.setDescription(description != null ? description.trim() : "");

        CategoryForm form = new CategoryForm(id, category.getName(), category.getDescription());
        Map<String, String> errors = ValidationUtil.validate(form);
        if (!errors.isEmpty()) {
            model.addAttribute("errors", errors);
            model.addAttribute("error", "Dữ liệu danh mục không hợp lệ!");
            model.addAttribute("category", category);
            return "admin/category-form";
        }

        try {
            categoryRepository.save(category);
            redirectAttributes.addFlashAttribute("success", "Cập nhật danh mục thành công!");
            return "redirect:/admin/categories";
        } catch (Exception e) {
            model.addAttribute("error", "Cập nhật danh mục thất bại: " + e.getMessage());
            model.addAttribute("category", category);
            return "admin/category-form";
        }
    }

    /**
     * 6. Xử lý xóa danh mục (thay thế DeleteCategoryServlet doGet).
     */
    @GetMapping("/delete")
    public String deleteCategory(@RequestParam("id") int id, RedirectAttributes redirectAttributes) {
        try {
            if (categoryRepository.existsById(id)) {
                categoryRepository.deleteById(id);
                redirectAttributes.addFlashAttribute("success", "Xóa danh mục thành công!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }
}
