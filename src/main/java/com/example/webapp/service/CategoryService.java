package com.example.webapp.service;

import com.example.webapp.dao.CategoryDAO;
import com.example.webapp.model.Category;
import com.example.webapp.repository.CategoryRepository;
import com.example.webapp.util.SpringContextUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Lớp nghiệp vụ (Service layer) xử lý logic và validation cho Category trên nền Spring Data JPA.
 */
@Service
@Transactional
public class CategoryService {

    private CategoryRepository categoryRepository;
    private CategoryDAO legacyDao;

    public CategoryService() {
        this.categoryRepository = SpringContextUtil.getBean(CategoryRepository.class);
        if (this.categoryRepository == null) {
            this.legacyDao = new CategoryDAO();
        }
    }

    @Autowired
    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    private CategoryRepository resolveRepository() {
        if (this.categoryRepository == null) {
            this.categoryRepository = SpringContextUtil.getBean(CategoryRepository.class);
        }
        return this.categoryRepository;
    }

    /**
     * Lấy toàn bộ danh sách Category sắp xếp theo ID giảm dần
     */
    @Transactional(readOnly = true)
    public List<Category> getAllCategories() {
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findAll(Sort.by(Sort.Direction.DESC, "id"));
        }
        return legacyDao != null ? legacyDao.findAll() : Collections.emptyList();
    }

    /**
     * Lấy Category theo ID
     */
    @Transactional(readOnly = true)
    public Category getCategoryById(int id) {
        if (id <= 0) {
            return null;
        }
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findById(id).orElse(null);
        }
        return legacyDao != null ? legacyDao.findById(id) : null;
    }

    /**
     * Thêm mới danh mục có kiểm tra tính hợp lệ dữ liệu
     */
    public boolean addCategory(Category category) throws Exception {
        validate(category);
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            repo.save(category);
            return true;
        }
        return legacyDao != null && legacyDao.insert(category);
    }

    /**
     * Cập nhật danh mục
     */
    public boolean updateCategory(Category category) throws Exception {
        validate(category);
        if (category.getId() <= 0) {
            throw new Exception("ID danh mục không hợp lệ!");
        }
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            repo.save(category);
            return true;
        }
        return legacyDao != null && legacyDao.update(category);
    }

    /**
     * Xóa danh mục theo ID
     */
    public boolean deleteCategory(int id) {
        if (id <= 0) {
            return false;
        }
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            if (repo.existsById(id)) {
                repo.deleteById(id);
                return true;
            }
            return false;
        }
        return legacyDao != null && legacyDao.delete(id);
    }

    /**
     * Tìm kiếm danh mục theo từ khóa sử dụng derived query method
     */
    @Transactional(readOnly = true)
    public List<Category> searchCategories(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllCategories();
        }
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findByCategorynameContainingIgnoreCase(keyword.trim());
        }
        return legacyDao != null ? legacyDao.search(keyword) : Collections.emptyList();
    }

    /**
     * Đếm tổng số lượng danh mục
     */
    @Transactional(readOnly = true)
    public long countCategories() {
        CategoryRepository repo = resolveRepository();
        if (repo != null) {
            return repo.count();
        }
        return legacyDao != null ? legacyDao.count() : 0L;
    }

    /**
     * Lấy trực tiếp repository nếu cần
     */
    public CategoryRepository getRepository() {
        return resolveRepository();
    }

    /**
     * Kiểm tra validation logic trước khi CRUD
     */
    private void validate(Category category) throws Exception {
        if (category == null) {
            throw new Exception("Dữ liệu danh mục không được để trống!");
        }
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new Exception("Tên danh mục không được để trống!");
        }
        if (category.getName().length() > 100) {
            throw new Exception("Tên danh mục không được vượt quá 100 ký tự!");
        }
        if (category.getDescription() != null && category.getDescription().length() > 255) {
            throw new Exception("Mô tả danh mục không được vượt quá 255 ký tự!");
        }
    }
}
