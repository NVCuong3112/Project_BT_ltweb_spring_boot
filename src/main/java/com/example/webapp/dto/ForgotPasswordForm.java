package com.example.webapp.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/**
 * DTO nhận và validate dữ liệu Quên mật khẩu.
 */
public class ForgotPasswordForm {

    @NotBlank(message = "Địa chỉ email không được để trống!")
    @Email(message = "Địa chỉ email không đúng định dạng hợp lệ!")
    private String email;

    public ForgotPasswordForm() {}

    public ForgotPasswordForm(String email) {
        this.email = email;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
