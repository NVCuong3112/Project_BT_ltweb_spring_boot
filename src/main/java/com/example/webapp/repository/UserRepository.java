package com.example.webapp.repository;

import com.example.webapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data JPA Repository cho thực thể User.
 * Thay thế hoàn toàn UserDAO viết tay bằng EntityManager.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    /**
     * Derived query method tìm kiếm người dùng theo username hoặc email không phân biệt hoa thường.
     * Đáp ứng trực tiếp yêu cầu bài toán.
     */
    List<User> findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(String usernameKeyword, String emailKeyword);

    /**
     * Tìm người dùng theo tên đăng nhập.
     */
    Optional<User> findByUsername(String username);

    /**
     * Tìm người dùng theo địa chỉ email.
     */
    Optional<User> findByEmail(String email);

    /**
     * Kiểm tra username đã tồn tại hay chưa.
     */
    boolean existsByUsername(String username);

    /**
     * Kiểm tra email đã tồn tại hay chưa.
     */
    boolean existsByEmail(String email);

    /**
     * Lấy toàn bộ danh sách người dùng sắp xếp theo ID giảm dần.
     */
    List<User> findAllByOrderByIdDesc();
}
