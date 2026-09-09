package com.example.webapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.io.Serializable;

/**
 * JPA Entity đại diện cho bảng users.
 * Hỗ trợ các trường cho đăng ký, mã hóa mật khẩu BCrypt và kích hoạt qua OTP.
 */
@Entity
@Table(name = "users")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id; // Tương đương userId

    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "full_name", length = 100, columnDefinition = "NVARCHAR(100)")
    private String fullName;

    @Column(name = "phone", length = 15)
    private String phone;

    @Column(name = "avatar", length = 255)
    private String avatar;

    // 0 = chưa kích hoạt, 1 = đã kích hoạt
    @Column(name = "status", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int status = 0;

    @Column(name = "role", length = 20, columnDefinition = "VARCHAR(20) DEFAULT 'USER'")
    private String role = "USER";

    public User() {
        this.status = 0;
        this.role = "USER";
    }

    public User(int id, String username, String password, String fullName, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.role = role;
    }

    public User(String username, String password, String email, String fullName, int status, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.status = status;
        this.role = role;
    }

    // --- Getters & Setters ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return id;
    }

    public void setUserId(int userId) {
        this.id = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFullname() {
        return fullName;
    }

    public void setFullname(String fullname) {
        this.fullName = fullname;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    // Compatibility aliases
    public String getImages() {
        return avatar;
    }

    public void setImages(String images) {
        this.avatar = images;
    }

    public String getImage() {
        return avatar;
    }

    public void setImage(String image) {
        this.avatar = image;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", status=" + status +
                ", role='" + role + '\'' +
                '}';
    }
}
