package com.example.webapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * JPA Entity quản lý mã xác thực OTP gửi qua email.
 */
@Entity
@Table(name = "otp_codes")
public class OtpCode implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "email", nullable = false, length = 100)
    private String email;

    @Column(name = "otp_code", nullable = false, length = 10)
    private String otpCode;

    // Loại OTP: "REGISTER" (kích hoạt đăng ký) hoặc "FORGOT_PASSWORD" (quên mật khẩu)
    @Column(name = "type", nullable = false, length = 30)
    private String type;

    @Column(name = "expired_at", nullable = false)
    private LocalDateTime expiredAt;

    @Column(name = "used", nullable = false)
    private boolean used = false;

    public OtpCode() {
    }

    public OtpCode(String email, String otpCode, String type, LocalDateTime expiredAt) {
        this.email = email;
        this.otpCode = otpCode;
        this.type = type;
        this.expiredAt = expiredAt;
        this.used = false;
    }

    // --- Getters & Setters ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public LocalDateTime getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(LocalDateTime expiredAt) {
        this.expiredAt = expiredAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    // Kiểm tra mã OTP còn hạn hay không
    public boolean isValid() {
        return !used && expiredAt != null && LocalDateTime.now().isBefore(expiredAt);
    }
}
