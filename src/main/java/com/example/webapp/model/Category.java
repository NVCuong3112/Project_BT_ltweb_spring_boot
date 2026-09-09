package com.example.webapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.io.Serializable;

/**
 * JPA Entity đại diện cho bảng categories trong cơ sở dữ liệu.
 * Giữ nguyên các field và method cũ để tương thích hoàn toàn với JSP và Servlet.
 */
@Entity
@Table(name = "categories")
public class Category implements Serializable {

    private static final long serialVersionUID = 1L;

    // Khóa chính, tự động tăng (IDENTITY trong SQL Server)
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    // Tên danh mục: không được trống, tối đa 100 ký tự
    @NotBlank(message = "Tên danh mục không được để trống")
    @Size(max = 100, message = "Tên danh mục không được vượt quá 100 ký tự")
    @Column(name = "name", nullable = false, length = 100)
    private String name;

    // Mô tả chi tiết danh mục: tối đa 255 ký tự
    @Size(max = 255, message = "Mô tả không được vượt quá 255 ký tự")
    @Column(name = "description", length = 255)
    private String description;

    // Quan hệ 1-N: Một danh mục có nhiều sản phẩm
    @jakarta.persistence.OneToMany(mappedBy = "category", cascade = jakarta.persistence.CascadeType.ALL)
    private java.util.List<Product> products = new java.util.ArrayList<>();

    // Constructor mặc định (bắt buộc cho JPA)
    public Category() {
    }

    // Constructor đầy đủ tham số
    public Category(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    // Constructor thêm mới (không cần id)
    public Category(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // --- Getters and Setters (giữ nguyên để không phá vỡ JSP và Service) ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public java.util.List<Product> getProducts() {
        return products;
    }

    public void setProducts(java.util.List<Product> products) {
        this.products = products;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
