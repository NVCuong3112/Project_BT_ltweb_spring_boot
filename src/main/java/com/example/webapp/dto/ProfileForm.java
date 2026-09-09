package com.example.webapp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * DTO nhận và validate dữ liệu cập nhật Hồ sơ cá nhân (Profile).
 */
public class ProfileForm {

    @NotBlank(message = "Họ và tên không được để trống!")
    private String fullName;

    @NotBlank(message = "Số điện thoại không được để trống!")
    @Pattern(regexp = "^(0[0-9]{9,10})$", message = "Số điện thoại không đúng định dạng VN (phải bắt đầu bằng 0 và gồm 10 hoặc 11 chữ số)!")
    private String phone;

    public ProfileForm() {}

    public ProfileForm(String fullName, String phone) {
        this.fullName = fullName;
        this.phone = phone;
    }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
