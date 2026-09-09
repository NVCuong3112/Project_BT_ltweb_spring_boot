package com.example.webapp.service;

import com.example.webapp.dao.IOtpDao;
import com.example.webapp.dao.IUserDao;
import com.example.webapp.dao.OtpDAO;
import com.example.webapp.dao.UserDAO;
import com.example.webapp.model.OtpCode;
import com.example.webapp.model.User;
import com.example.webapp.repository.UserRepository;
import com.example.webapp.util.EmailUtil;
import com.example.webapp.util.SpringContextUtil;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

/**
 * Lớp dịch vụ người dùng xử lý: Đăng ký, Đăng nhập BCrypt, Kích hoạt OTP, Quên mật khẩu.
 * Hỗ trợ cả Spring DI và tương thích với mã Servlet cũ (new UserService()).
 */
@Service
@Transactional
public class UserService implements IUserService {

    private UserRepository userRepository;
    private IUserDao legacyUserDao;
    private IOtpDao otpDAO;
    private final SecureRandom random = new SecureRandom();

    public UserService() {
        this.userRepository = SpringContextUtil.getBean(UserRepository.class);
        this.otpDAO = new OtpDAO();
        if (this.userRepository == null) {
            this.legacyUserDao = new UserDAO();
        }
    }

    @Autowired
    public UserService(UserRepository userRepository, IOtpDao otpDAO) {
        this.userRepository = userRepository;
        this.otpDAO = otpDAO;
    }

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.otpDAO = new OtpDAO();
    }

    private UserRepository resolveRepository() {
        if (this.userRepository == null) {
            this.userRepository = SpringContextUtil.getBean(UserRepository.class);
        }
        return this.userRepository;
    }

    @Override
    public boolean register(String username, String password, String email, String fullName) throws Exception {
        if (username == null || username.trim().isEmpty()) {
            throw new Exception("Tên đăng nhập không được để trống!");
        }
        if (password == null || password.length() < 6) {
            throw new Exception("Mật khẩu phải có ít nhất 6 ký tự!");
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new Exception("Định dạng email không hợp lệ!");
        }

        UserRepository repo = resolveRepository();
        if (repo != null) {
            if (repo.findByUsername(username.trim()).isPresent()) {
                throw new Exception("Tên đăng nhập '" + username + "' đã tồn tại!");
            }
            if (repo.findByEmail(email.trim().toLowerCase()).isPresent()) {
                throw new Exception("Email '" + email + "' đã được đăng ký!");
            }
        } else if (legacyUserDao != null) {
            if (legacyUserDao.findByUsername(username.trim()) != null) {
                throw new Exception("Tên đăng nhập '" + username + "' đã tồn tại!");
            }
            if (legacyUserDao.findByEmail(email.trim().toLowerCase()) != null) {
                throw new Exception("Email '" + email + "' đã được đăng ký!");
            }
        }

        // 1. Mã hóa mật khẩu bằng BCrypt
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // 2. Tạo User với status = 0 (chưa kích hoạt)
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(hashedPassword);
        user.setEmail(email.trim().toLowerCase());
        user.setFullName(fullName != null ? fullName.trim() : username.trim());
        user.setStatus(0); // Chưa kích hoạt
        user.setRole("USER");

        if (repo != null) {
            repo.save(user);
        } else if (legacyUserDao != null) {
            legacyUserDao.insert(user);
        }

        // 3. Sinh OTP 6 chữ số và gửi qua email
        String otpCode = generateOtpCode();
        otpDAO.invalidateOldOtps(user.getEmail(), "REGISTER");

        OtpCode otp = new OtpCode(user.getEmail(), otpCode, "REGISTER", LocalDateTime.now().plusMinutes(5));
        otpDAO.insert(otp);

        // Gửi email
        EmailUtil.sendOtpEmail(user.getEmail(), otpCode, "REGISTER");
        return true;
    }

    @Override
    public boolean activateAccount(String email, String otpCode) throws Exception {
        if (email == null || email.trim().isEmpty() || otpCode == null || otpCode.trim().isEmpty()) {
            throw new Exception("Email và mã OTP không được để trống!");
        }

        OtpCode validOtp = otpDAO.findValidOtp(email.trim().toLowerCase(), otpCode.trim(), "REGISTER");
        if (validOtp == null) {
            throw new Exception("Mã OTP không hợp lệ, đã được sử dụng hoặc đã quá hạn 5 phút!");
        }

        User user = findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new Exception("Không tìm thấy tài khoản với email này!");
        }

        user.setStatus(1);
        UserRepository repo = resolveRepository();
        if (repo != null) {
            repo.save(user);
        } else if (legacyUserDao != null) {
            legacyUserDao.update(user);
        }

        otpDAO.markAsUsed(validOtp.getId());
        return true;
    }

    @Override
    public boolean resendOtp(String email, String type) throws Exception {
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email không được để trống!");
        }

        User user = findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new Exception("Không tìm thấy tài khoản với email này!");
        }

        if ("REGISTER".equalsIgnoreCase(type) && user.getStatus() == 1) {
            throw new Exception("Tài khoản này đã được kích hoạt trước đó, bạn có thể đăng nhập ngay!");
        }

        otpDAO.invalidateOldOtps(email.trim().toLowerCase(), type);

        String newOtp = generateOtpCode();
        OtpCode otp = new OtpCode(email.trim().toLowerCase(), newOtp, type, LocalDateTime.now().plusMinutes(5));
        otpDAO.insert(otp);

        return EmailUtil.sendOtpEmail(email.trim().toLowerCase(), newOtp, type);
    }

    @Override
    @Transactional(readOnly = true)
    public User login(String username, String password) throws Exception {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            throw new Exception("Tên đăng nhập và mật khẩu không được để trống!");
        }

        User user = findByUsername(username.trim());
        if (user == null) {
            throw new Exception("Tên đăng nhập hoặc mật khẩu không chính xác!");
        }

        boolean passwordMatched = false;
        try {
            passwordMatched = BCrypt.checkpw(password, user.getPassword());
        } catch (Exception ignored) {
        }
        if (!passwordMatched && user.getPassword() != null) {
            passwordMatched = user.getPassword().equals(password);
        }

        if (!passwordMatched) {
            throw new Exception("Tên đăng nhập hoặc mật khẩu không chính xác!");
        }

        if (user.getStatus() == 0) {
            throw new Exception("Tài khoản của bạn chưa được kích hoạt! Vui lòng kiểm tra email để nhập mã OTP hoặc bấm gửi lại mã kích hoạt.");
        }

        return user;
    }

    @Override
    public boolean forgotPassword(String email) throws Exception {
        if (email == null || email.trim().isEmpty()) {
            throw new Exception("Email không được để trống!");
        }

        User user = findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new Exception("Email này chưa được đăng ký trong hệ thống!");
        }

        otpDAO.invalidateOldOtps(email.trim().toLowerCase(), "FORGOT_PASSWORD");
        String otpCode = generateOtpCode();
        OtpCode otp = new OtpCode(email.trim().toLowerCase(), otpCode, "FORGOT_PASSWORD", LocalDateTime.now().plusMinutes(5));
        otpDAO.insert(otp);

        return EmailUtil.sendOtpEmail(email.trim().toLowerCase(), otpCode, "FORGOT_PASSWORD");
    }

    @Override
    public boolean resetPassword(String email, String otpCode, String newPassword) throws Exception {
        if (email == null || otpCode == null || newPassword == null || newPassword.length() < 6) {
            throw new Exception("Vui lòng điền đầy đủ thông tin và mật khẩu mới từ 6 ký tự trở lên!");
        }

        OtpCode validOtp = otpDAO.findValidOtp(email.trim().toLowerCase(), otpCode.trim(), "FORGOT_PASSWORD");
        if (validOtp == null) {
            throw new Exception("Mã OTP không hợp lệ hoặc đã hết hạn (5 phút)!");
        }

        User user = findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new Exception("Không tìm thấy tài khoản!");
        }

        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        user.setPassword(hashedNewPassword);

        UserRepository repo = resolveRepository();
        if (repo != null) {
            repo.save(user);
        } else if (legacyUserDao != null) {
            legacyUserDao.update(user);
        }

        otpDAO.markAsUsed(validOtp.getId());
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public User findByUsername(String username) {
        UserRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findByUsername(username).orElse(null);
        }
        return legacyUserDao != null ? legacyUserDao.findByUsername(username) : null;
    }

    @Override
    @Transactional(readOnly = true)
    public User findByEmail(String email) {
        UserRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findByEmail(email).orElse(null);
        }
        return legacyUserDao != null ? legacyUserDao.findByEmail(email) : null;
    }

    @Override
    @Transactional(readOnly = true)
    public User findById(int id) {
        UserRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findById(id).orElse(null);
        }
        return legacyUserDao != null ? legacyUserDao.findById(id) : null;
    }

    @Override
    public boolean updateProfile(int userId, String fullName, String phone, String avatar) throws Exception {
        User user = findById(userId);
        if (user == null) {
            throw new Exception("Không tìm thấy người dùng!");
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            throw new Exception("Họ và tên không được để trống!");
        }
        if (phone != null && !phone.trim().isEmpty() && !phone.matches("^(0[0-9]{9,10})$")) {
            throw new Exception("Số điện thoại không hợp lệ! Vui lòng nhập 10-11 chữ số bắt đầu bằng số 0.");
        }
        user.setFullName(fullName.trim());
        user.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        if (avatar != null && !avatar.trim().isEmpty()) {
            user.setAvatar(avatar.trim());
        }

        UserRepository repo = resolveRepository();
        if (repo != null) {
            repo.save(user);
        } else if (legacyUserDao != null) {
            legacyUserDao.update(user);
        }
        return true;
    }

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        UserRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findAllByOrderByIdDesc();
        }
        return legacyUserDao != null ? legacyUserDao.findAll() : Collections.emptyList();
    }

    @Transactional(readOnly = true)
    public List<User> searchUsers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllUsers();
        }
        UserRepository repo = resolveRepository();
        if (repo != null) {
            return repo.findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase(keyword.trim(), keyword.trim());
        }
        return getAllUsers();
    }

    public UserRepository getRepository() {
        return resolveRepository();
    }

    private String generateOtpCode() {
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
}
