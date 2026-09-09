package com.example.webapp;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.dao.CategoryDAO;
import com.example.webapp.model.Category;

import java.util.List;

/**
 * Class kiểm thử đơn giản (Console Application) các chức năng CRUD của Category với JPA 3.0.
 * Chạy trực tiếp qua hàm main() để kiểm tra kết nối DB và Hibernate.
 */
public class CategoryJPATest {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println("  BẮT ĐẦU KIỂM THỬ JPA 3.0 + HIBERNATE CHO CATEGORY");
        System.out.println("==================================================");

        CategoryDAO categoryDAO = new CategoryDAO();

        try {
            // 1. TEST INSERT (THÊM MỚI)
            System.out.println("\n--- 1. TEST INSERT ---");
            Category newCategory = new Category("Sách AI & Data Science", "Tài liệu chuyên ngành Trí tuệ nhân tạo");
            boolean insertResult = categoryDAO.insert(newCategory);
            System.out.println("Kết quả thêm mới: " + (insertResult ? "THÀNH CÔNG" : "THẤT BẠI"));
            System.out.println("Entity sau khi lưu (đã sinh ID tự động): " + newCategory);

            int createdId = newCategory.getId();

            // 2. TEST FIND ALL & COUNT (LẤY TẤT CẢ VÀ ĐẾM)
            System.out.println("\n--- 2. TEST FIND ALL & COUNT ---");
            long totalCount = categoryDAO.count();
            System.out.println("Tổng số danh mục hiện có: " + totalCount);
            List<Category> list = categoryDAO.findAll();
            System.out.println("Danh sách " + list.size() + " danh mục gần nhất:");
            for (Category c : list) {
                System.out.println("  -> [ID=" + c.getId() + "] " + c.getName() + " | " + c.getDescription());
            }

            // 3. TEST FIND BY ID & UPDATE (TÌM THEO ID VÀ CẬP NHẬT)
            System.out.println("\n--- 3. TEST FIND BY ID & UPDATE ---");
            Category foundCat = categoryDAO.findById(createdId);
            if (foundCat != null) {
                System.out.println("Tìm thấy: " + foundCat);
                foundCat.setName("Sách AI & Khoa Học Dữ Liệu (Updated)");
                foundCat.setDescription("Cập nhật thông tin mô tả chi tiết hơn");

                boolean updateResult = categoryDAO.update(foundCat);
                System.out.println("Kết quả cập nhật: " + (updateResult ? "THÀNH CÔNG" : "THẤT BẠI"));

                Category reloaded = categoryDAO.findById(createdId);
                System.out.println("Dữ liệu sau cập nhật: " + reloaded);
            } else {
                System.out.println("Không tìm thấy Category với ID: " + createdId);
            }

            // 4. TEST SEARCH (TÌM KIẾM)
            System.out.println("\n--- 4. TEST SEARCH ---");
            String keyword = "Khoa Học";
            List<Category> searchResults = categoryDAO.search(keyword);
            System.out.println("Kết quả tìm kiếm từ khóa '" + keyword + "' (" + searchResults.size() + " kết quả):");
            for (Category c : searchResults) {
                System.out.println("  -> " + c);
            }

            // 5. TEST DELETE (XÓA BẢN GHI VỪA TEST)
            System.out.println("\n--- 5. TEST DELETE ---");
            boolean deleteResult = categoryDAO.delete(createdId);
            System.out.println("Kết quả xóa ID " + createdId + ": " + (deleteResult ? "THÀNH CÔNG" : "THẤT BẠI"));

            Category checkDeleted = categoryDAO.findById(createdId);
            System.out.println("Kiểm tra lại sau khi xóa (phải là null): " + checkDeleted);

            System.out.println("\n==================================================");
            System.out.println("  KIỂM THỬ HOÀN TẤT THÀNH CÔNG RỰC RỠ!");
            System.out.println("==================================================");

        } catch (Exception e) {
            System.err.println("Lỗi trong quá trình kiểm thử:");
            e.printStackTrace();
        } finally {
            // Đóng EntityManagerFactory
            JPAConfig.shutdown();
        }
    }
}
