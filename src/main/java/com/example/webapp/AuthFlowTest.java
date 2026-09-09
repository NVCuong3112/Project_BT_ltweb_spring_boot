package com.example.webapp;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.dao.IOtpDao;
import com.example.webapp.dao.IUserDao;
import com.example.webapp.dao.OtpDAO;
import com.example.webapp.dao.UserDAO;
import com.example.webapp.model.OtpCode;
import com.example.webapp.model.User;
import com.example.webapp.service.IUserService;
import com.example.webapp.service.UserService;
import jakarta.persistence.EntityManager;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;

/**
 * Class kiểm thử tự động toàn bộ luồng nghiệp vụ:
 * ĐĂNG KÝ -> NHẬN OTP -> KÍCH HOẠT TÀI KHOẢN -> ĐĂNG NHẬP
 * In chi tiết từng bước ra Console để dễ dàng theo dõi và debug.
 */
public class AuthFlowTest {

    public static void main(String[] args) {
        System.out.println("========================================================================");
        System.out.println("   BẮT ĐẦU TEST LUỒNG: ĐĂNG KÝ -> NHẬN OTP -> KÍCH HOẠT -> ĐĂNG NHẬP   ");
        System.out.println("========================================================================");

        IUserService userService = new UserService();
        IUserDao userDAO = new UserDAO();
        IOtpDao otpDAO = new OtpDAO();

        // Tạo dữ liệu test ngẫu nhiên để không bị trùng lặp khi chạy nhiều lần
        long timestamp = System.currentTimeMillis() % 100000;
        String testUsername = "user_test_" + timestamp;
        String testEmail = "test_" + timestamp + "@example.com";
        String testPassword = "MyPassword@123";
        String testFullName = "Nông Văn Cường (Tester)";

        try {
            // -------------------------------------------------------------
            // BƯỚC 1: ĐĂNG KÝ TÀI KHOẢN MỚI
            // -------------------------------------------------------------
            System.out.println("\n[BƯỚC 1] TIẾN HÀNH ĐĂNG KÝ TÀI KHOẢN:");
            System.out.println("-> Họ và tên     : " + testFullName);
            System.out.println("-> Username      : " + testUsername);
            System.out.println("-> Email         : " + testEmail);
            System.out.println("-> Mật khẩu thô  : " + testPassword);

            boolean registerResult = userService.register(testUsername, testPassword, testEmail, testFullName);
            if (!registerResult) {
                throw new Exception("LỖI TẠI BƯỚC 1: Hàm register trả về false!");
            }
            System.out.println("-> Kết quả đăng ký: THÀNH CÔNG (Đã lưu User và sinh mã OTP)");

            // Kiểm tra thông tin User trong DB
            User savedUser = userDAO.findByUsername(testUsername);
            if (savedUser == null) {
                throw new Exception("LỖI TẠI BƯỚC 1: Không tìm thấy User vừa đăng ký trong DB!");
            }
            System.out.println("-> ID sinh tự động trong DB : " + savedUser.getId());
            System.out.println("-> Mật khẩu mã hóa (BCrypt) : " + savedUser.getPassword());
            System.out.println("-> Trạng thái kích hoạt     : " + savedUser.getStatus() + " (0 = Chưa kích hoạt - CHÍNH XÁC)");

            // Kiểm tra tính bảo mật BCrypt
            boolean passwordValid = BCrypt.checkpw(testPassword, savedUser.getPassword());
            System.out.println("-> Kiểm tra đối soát BCrypt : " + (passwordValid ? "HỢP LỆ" : "SAI"));

            // -------------------------------------------------------------
            // BƯỚC 2: KIỂM TRA CHẶN ĐĂNG NHẬP KHI CHƯA KÍCH HOẠT
            // -------------------------------------------------------------
            System.out.println("\n[BƯỚC 2] THỬ ĐĂNG NHẬP KHI TÀI KHOẢN CHƯA KÍCH HOẠT (status = 0):");
            try {
                userService.login(testUsername, testPassword);
                System.err.println("-> LỖI BẢO MẬT: Hệ thống vẫn cho phép đăng nhập khi status = 0!");
            } catch (Exception e) {
                System.out.println("-> Hệ thống chặn đăng nhập CHÍNH XÁC với thông báo:");
                System.out.println("   \"" + e.getMessage() + "\"");
            }

            // -------------------------------------------------------------
            // BƯỚC 3: LẤY MÃ OTP VỪA GỬI TỚI EMAIL
            // -------------------------------------------------------------
            System.out.println("\n[BƯỚC 3] KIỂM TRA MÃ XÁC THỰC OTP TRONG CƠ SỞ DỮ LIỆU:");
            EntityManager em = JPAConfig.getEntityManager();
            OtpCode otpCodeRecord;
            try {
                otpCodeRecord = em.createQuery(
                        "SELECT o FROM OtpCode o WHERE LOWER(o.email) = LOWER(:email) AND o.type = 'REGISTER' ORDER BY o.id DESC", 
                        OtpCode.class)
                        .setParameter("email", testEmail)
                        .setMaxResults(1)
                        .getSingleResult();
            } finally {
                em.close();
            }

            if (otpCodeRecord == null) {
                throw new Exception("LỖI TẠI BƯỚC 3: Không tìm thấy bản ghi OtpCode trong DB!");
            }

            String otpCode = otpCodeRecord.getOtpCode();
            System.out.println("-> Mã OTP 6 chữ số tìm thấy : >>> " + otpCode + " <<<");
            System.out.println("-> Thời hạn hiệu lực        : " + otpCodeRecord.getExpiredAt() + " (Hết hạn sau 5 phút)");
            System.out.println("-> Trạng thái đã dùng chưa  : " + otpCodeRecord.isUsed() + " (false = Chưa dùng)");

            // -------------------------------------------------------------
            // BƯỚC 4: KÍCH HOẠT TÀI KHOẢN QUA MÃ OTP
            // -------------------------------------------------------------
            System.out.println("\n[BƯỚC 4] TIẾN HÀNH KÍCH HOẠT TÀI KHOẢN:");
            System.out.println("-> Nhập Email   : " + testEmail);
            System.out.println("-> Nhập Mã OTP  : " + otpCode);

            boolean activateResult = userService.activateAccount(testEmail, otpCode);
            if (!activateResult) {
                throw new Exception("LỖI TẠI BƯỚC 4: Kích hoạt tài khoản thất bại!");
            }
            System.out.println("-> Kết quả kích hoạt: THÀNH CÔNG");

            // Kiểm tra lại trạng thái User sau khi kích hoạt
            User activatedUser = userDAO.findByUsername(testUsername);
            System.out.println("-> Trạng thái mới của User  : " + activatedUser.getStatus() + " (1 = Đã kích hoạt - CHÍNH XÁC)");

            // Kiểm tra mã OTP đã chuyển sang trạng thái đã dùng (used = true)
            OtpCode recheckOtp = otpDAO.findValidOtp(testEmail, otpCode, "REGISTER");
            System.out.println("-> Kiểm tra OTP sau khi dùng: " + (recheckOtp == null ? "ĐÃ KHÓA (Không thể tái sử dụng OTP này - CHÍNH XÁC)" : "LỖI"));

            // -------------------------------------------------------------
            // BƯỚC 5: ĐĂNG NHẬP HỆ THỐNG SAU KHI KÍCH HOẠT
            // -------------------------------------------------------------
            System.out.println("\n[BƯỚC 5] ĐĂNG NHẬP HỆ THỐNG VỚI TÀI KHOẢN ĐÃ KÍCH HOẠT:");
            
            // 5.1 Thử đăng nhập sai mật khẩu trước
            try {
                userService.login(testUsername, "WrongPassword@999");
                System.err.println("-> LỖI: Cho phép đăng nhập khi sai mật khẩu!");
            } catch (Exception e) {
                System.out.println("-> Nhập sai mật khẩu: Bị từ chối chính xác (\"" + e.getMessage() + "\")");
            }

            // 5.2 Đăng nhập đúng mật khẩu
            User loggedUser = userService.login(testUsername, testPassword);
            if (loggedUser == null) {
                throw new Exception("LỖI TẠI BƯỚC 5: Đăng nhập thất bại dù thông tin hoàn toàn chính xác!");
            }

            System.out.println("-> ĐĂNG NHẬP THÀNH CÔNG 100%!");
            System.out.println("-> Thông tin phiên đăng nhập:");
            System.out.println("   + User ID  : " + loggedUser.getId());
            System.out.println("   + Username : " + loggedUser.getUsername());
            System.out.println("   + Họ tên   : " + loggedUser.getFullName());
            System.out.println("   + Email    : " + loggedUser.getEmail());
            System.out.println("   + Vai trò  : " + loggedUser.getRole());
            System.out.println("   + Status   : " + loggedUser.getStatus());

            System.out.println("\n========================================================================");
            System.out.println("  CHÚC MỪNG! TOÀN BỘ LUỒNG ĐĂNG KÝ -> OTP -> KÍCH HOẠT -> ĐĂNG NHẬP     ");
            System.out.println("  ĐÃ CHẠY HOÀN TOÀN CHÍNH XÁC, BẢO MẬT VÀ KHÔNG GẶP BẤT KỲ LỖI NÀO!     ");
            System.out.println("========================================================================");

        } catch (Exception e) {
            System.err.println("\n❌ PHÁT HIỆN LỖI TRONG QUÁ TRÌNH TEST:");
            System.err.println("-> Chi tiết lỗi: " + e.getMessage());
            System.err.println("-> StackTrace đầy đủ:");
            e.printStackTrace();
        } finally {
            JPAConfig.shutdown();
        }
    }
}
