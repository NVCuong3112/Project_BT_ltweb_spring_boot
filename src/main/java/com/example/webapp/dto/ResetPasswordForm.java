package com.example.webapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * DTO nhận và validate dữ liệu Đặt lại mật khẩu.
 */
public class ResetPasswordForm {

    @NotBlank(message = "Địa chỉ email không được để trống!")
    @Email(message = "Địa chỉ email không đúng định dạng hợp lệ!")
    private String email;

    @NotBlank(message = "Mã OTP không được để trống!")
    @Pattern(regexp = "^[0-9]{6}$", message = "Mã OTP phải gồm đúng 6 chữ số!")
    private String otpCode;

    @NotBlank(message = "Mật khẩu mới không được để trống!")
    @Size(min = 6, message = "Mật khẩu mới phải có ít nhất 6 ký tự!")
    private String newPassword;

    @NotBlank(message = "Vui lòng xác nhận mật khẩu mới!")
    private String confirmPassword;

    public ResetPasswordForm() {}

    public ResetPasswordForm(String email, String otpCode, String newPassword, String confirmPassword) {
        this.email = email;
        this.otpCode = otpCode;
        this.newPassword = newPassword;
        this.confirmPassword = confirmPassword;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }

    public String getNewPassword() { return newPassword; }
    public void setNewPassword(String newPassword) { this.newPassword = newPassword; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
}
