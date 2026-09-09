package com.example.webapp.repository;

import com.example.webapp.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data JPA Repository cho thực thể Category.
 * Thay thế hoàn toàn CategoryDAO viết tay bằng EntityManager.
 */
@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    /**
     * Derived query method tìm kiếm theo trường name (không phân biệt hoa/thường).
     */
    List<Category> findByNameContainingIgnoreCase(String keyword);

    /**
     * Derived query method tìm kiếm theo cả tên hoặc mô tả.
     */
    List<Category> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String name, String description);

    /**
     * Phương thức tìm kiếm theo đúng cú pháp yêu cầu findByCategorynameContainingIgnoreCase.
     * Ánh xạ tới trường 'name' của Category entity thông qua JPQL.
     */
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR (c.description IS NOT NULL AND LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Category> findByCategorynameContainingIgnoreCase(@Param("keyword") String keyword);
}
