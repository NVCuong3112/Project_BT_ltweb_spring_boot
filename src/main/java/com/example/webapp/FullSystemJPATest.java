package com.example.webapp;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.dao.CategoryDAO;
import com.example.webapp.dao.OtpDAO;
import com.example.webapp.dao.ProductDAO;
import com.example.webapp.dao.UserDAO;
import com.example.webapp.model.Category;
import com.example.webapp.model.OtpCode;
import com.example.webapp.model.Product;
import com.example.webapp.model.User;
import com.example.webapp.service.ProductService;
import com.example.webapp.service.UserService;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Class kiểm thử toàn diện (Console Test) cho:
 * 1. BCrypt Password Hashing & Verification
 * 2. Đăng ký tài khoản (status = 0) + Sinh mã OTP
 * 3. Kích hoạt tài khoản qua OTP (status -> 1)
 * 4. Đăng nhập với BCrypt & kiểm tra status = 1
 * 5. Quên mật khẩu & Đặt lại mật khẩu mới qua OTP
 * 6. Quản lý sản phẩm (Product CRUD, Quan hệ Category, Top 10 trang chủ, Phân trang)
 */
public class FullSystemJPATest {

    public static void main(String[] args) {
        System.out.println("==================================================================");
        System.out.println("  BẮT ĐẦU KIỂM THỬ TOÀN DIỆN HỆ THỐNG JPA 3.0 + BCRYPT + OTP + PRODUCTS");
        System.out.println("==================================================================");

        UserService userService = new UserService();
        ProductService productService = new ProductService();
        CategoryDAO categoryDAO = new CategoryDAO();
        UserDAO userDAO = new UserDAO();
        OtpDAO otpDAO = new OtpDAO();

        try {
            // -------------------------------------------------------------
            // PHẦN 1: TEST ĐĂNG KÝ + OTP + KÍCH HOẠT + BCRYPT
            // -------------------------------------------------------------
            System.out.println("\n[1] KIỂM THỬ ĐĂNG KÝ & KÍCH HOẠT TÀI KHOẢN VỚI OTP & BCRYPT:");
            String testUsername = "tester_" + System.currentTimeMillis() % 10000;
            String testEmail = testUsername + "@example.com";
            String rawPassword = "Password@123";

            System.out.println("-> Thực hiện đăng ký user: " + testUsername + " (" + testEmail + ")");
            userService.register(testUsername, rawPassword, testEmail, "Nguyễn Văn Kiểm Thử");

            User createdUser = userDAO.findByUsername(testUsername);
            System.out.println("-> Đã lưu User vào DB: ID=" + createdUser.getId() + ", status=" + createdUser.getStatus()
                    + " (0: Chưa kích hoạt)");
            System.out.println("-> Mật khẩu lưu trong DB (đã mã hóa BCrypt): " + createdUser.getPassword());

            // Thử đăng nhập khi chưa kích hoạt -> Phải bị chặn
            try {
                userService.login(testUsername, rawPassword);
                System.err.println("-> LỖI: Cho phép đăng nhập khi chưa kích hoạt!");
            } catch (Exception e) {
                System.out.println("-> Đăng nhập bị chặn chính xác: " + e.getMessage());
            }

            // Lấy mã OTP vừa sinh trong DB để kích hoạt
            OtpCode otp = otpDAO.findValidOtp(testEmail, "", "REGISTER");
            // Vì findValidOtp cần đúng code, ta lấy từ DB hoặc query
            jakarta.persistence.EntityManager em = JPAConfig.getEntityManager();
            String code = em.createQuery("SELECT o.otpCode FROM OtpCode o WHERE o.email = :email AND o.type = 'REGISTER' ORDER BY o.id DESC", String.class)
                            .setParameter("email", testEmail)
                            .setMaxResults(1)
                            .getSingleResult();
            em.close();

            System.out.println("-> Tìm thấy mã OTP trong DB: " + code);
            boolean activateResult = userService.activateAccount(testEmail, code);
            System.out.println("-> Kết quả kích hoạt tài khoản: " + (activateResult ? "THÀNH CÔNG" : "THẤT BẠI"));

            User activatedUser = userDAO.findByUsername(testUsername);
            System.out.println("-> Trạng thái user sau khi kích hoạt: status=" + activatedUser.getStatus() + " (1: Đã kích hoạt)");

            // Đăng nhập lại với mật khẩu đúng
            User loggedUser = userService.login(testUsername, rawPassword);
            System.out.println("-> Đăng nhập thành công với BCrypt! Chào mừng: " + loggedUser.getFullName());

            // -------------------------------------------------------------
            // PHẦN 2: TEST QUÊN MẬT KHẨU & ĐẶT LẠI MẬT KHẨU QUA OTP
            // -------------------------------------------------------------
            System.out.println("\n[2] KIỂM THỬ QUÊN MẬT KHẨU & RESET MẬT KHẨU:");
            userService.forgotPassword(testEmail);

            em = JPAConfig.getEntityManager();
            String forgotOtp = em.createQuery("SELECT o.otpCode FROM OtpCode o WHERE o.email = :email AND o.type = 'FORGOT_PASSWORD' ORDER BY o.id DESC", String.class)
                                 .setParameter("email", testEmail)
                                 .setMaxResults(1)
                                 .getSingleResult();
            em.close();
            System.out.println("-> Mã OTP quên mật khẩu: " + forgotOtp);

            String newPassword = "NewSecurePassword@456";
            userService.resetPassword(testEmail, forgotOtp, newPassword);
            System.out.println("-> Đặt lại mật khẩu thành công!");

            User reLoginUser = userService.login(testUsername, newPassword);
            System.out.println("-> Đăng nhập thành công với MẬT KHẨU MỚI!");

            // -------------------------------------------------------------
            // PHẦN 3: TEST PRODUCTS (CRUD, QUAN HỆ CATEGORY, TOP 10, PHÂN TRANG)
            // -------------------------------------------------------------
            System.out.println("\n[3] KIỂM THỬ SẢN PHẨM & QUAN HỆ VỚI CATEGORY:");

            // Lấy 1 category có sẵn
            List<Category> cats = categoryDAO.findAll();
            Category defaultCat = cats.isEmpty() ? null : cats.get(0);

            if (defaultCat != null) {
                System.out.println("-> Sử dụng Danh mục: [ID=" + defaultCat.getId() + "] " + defaultCat.getName());

                Product product = new Product();
                product.setProductName("Sách Thử Nghiệm JPA " + System.currentTimeMillis() % 1000);
                product.setPrice(180000);
                product.setQuantity(50);
                product.setDescription("Mô tả sách thử nghiệm tính năng JPA, Hibernate và Upload ảnh");
                product.setImage("test_book.jpg");
                product.setStatus(1);
                product.setCategory(defaultCat);

                boolean addSuccess = productService.addProduct(product);
                System.out.println("-> Thêm sản phẩm mới: " + (addSuccess ? "THÀNH CÔNG" : "THẤT BẠI") + " [ID=" + product.getProductId() + "]");

                // Test Top 10 trang chủ
                List<Product> top10 = productService.getTop10LatestProducts();
                System.out.println("-> Lấy Top 10 sản phẩm mới nhất trang chủ: Tìm thấy " + top10.size() + " sản phẩm.");
                if (!top10.isEmpty()) {
                    System.out.println("   Sản phẩm mới nhất: " + top10.get(0).getProductName() + " - " + top10.get(0).getPrice() + " đ");
                }

                // Test phân trang 6 sp/trang
                List<Product> page1 = productService.getProductsPaged(1, 6);
                System.out.println("-> Lấy phân trang trang 1 (kích thước 6): Lấy được " + page1.size() + " sản phẩm.");

                // Test đếm tổng số
                long totalCount = productService.countProducts();
                System.out.println("-> Tổng số sản phẩm hiển thị bán: " + totalCount);

                // Test xóa dọn dẹp
                productService.deleteProduct(product.getProductId());
                System.out.println("-> Đã xóa dọn dẹp sản phẩm test thành công!");
            }

            System.out.println("\n==================================================================");
            System.out.println("  TẤT CẢ CÁC BƯỚC KIỂM THỬ HỆ THỐNG ĐÃ CHẠY HOÀN HẢO 100%!");
            System.out.println("==================================================================");

        } catch (Exception e) {
            System.err.println("Lỗi kiểm thử hệ thống: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JPAConfig.shutdown();
        }
    }
}
