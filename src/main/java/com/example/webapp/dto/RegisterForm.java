package com.example.webapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * DTO nhận và validate dữ liệu Đăng ký người dùng mới.
 */
public class RegisterForm {

    @NotBlank(message = "Họ và tên không được để trống!")
    private String fullName;

    @NotBlank(message = "Tên đăng nhập không được để trống!")
    @Size(min = 3, max = 50, message = "Tên đăng nhập phải có từ 3 đến 50 ký tự!")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Tên đăng nhập chỉ được chứa chữ cái, chữ số và dấu gạch dưới!")
    private String username;

    @NotBlank(message = "Địa chỉ email không được để trống!")
    @Email(message = "Địa chỉ email không đúng định dạng hợp lệ!")
    private String email;

    @NotBlank(message = "Mật khẩu không được để trống!")
    @Size(min = 6, message = "Mật khẩu phải có tối thiểu 6 ký tự!")
    private String password;

    @NotBlank(message = "Vui lòng nhập xác nhận mật khẩu!")
    private String confirmPassword;

    public RegisterForm() {}

    public RegisterForm(String fullName, String username, String email, String password, String confirmPassword) {
        this.fullName = fullName;
        this.username = username;
        this.email = email;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
}
