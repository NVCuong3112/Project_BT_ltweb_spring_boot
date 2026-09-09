package com.example.webapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * DTO nhận và validate dữ liệu Kích hoạt tài khoản bằng OTP.
 */
public class ActivateAccountForm {

    @NotBlank(message = "Địa chỉ email không được để trống!")
    @Email(message = "Địa chỉ email không đúng định dạng hợp lệ!")
    private String email;

    @NotBlank(message = "Mã OTP không được để trống!")
    @Pattern(regexp = "^[0-9]{6}$", message = "Mã OTP phải gồm đúng 6 chữ số!")
    private String otpCode;

    public ActivateAccountForm() {}

    public ActivateAccountForm(String email, String otpCode) {
        this.email = email;
        this.otpCode = otpCode;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }
}
