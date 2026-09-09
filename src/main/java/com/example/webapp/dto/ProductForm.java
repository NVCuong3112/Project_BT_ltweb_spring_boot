package com.example.webapp.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * DTO nhận và validate form thêm/sửa Sản phẩm.
 */
public class ProductForm {

    private int id;

    @NotBlank(message = "Tên sản phẩm không được để trống!")
    @Size(max = 200, message = "Tên sản phẩm không được vượt quá 200 ký tự!")
    private String productName;

    @NotNull(message = "Đơn giá không được để trống!")
    @DecimalMin(value = "1.0", message = "Đơn giá sản phẩm phải lớn hơn 0 VNĐ!")
    private Double price;

    @NotNull(message = "Số lượng không được để trống!")
    @Min(value = 0, message = "Số lượng tồn kho không được âm!")
    private Integer quantity;

    @NotNull(message = "Vui lòng chọn danh mục cho sản phẩm!")
    @Min(value = 1, message = "Vui lòng chọn danh mục hợp lệ!")
    private Integer categoryId;

    private String description;
    private int status = 1;

    public ProductForm() {}

    public ProductForm(String productName, Double price, Integer quantity, Integer categoryId, String description, int status) {
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.description = description;
        this.status = status;
    }

    public ProductForm(int id, String productName, Double price, Integer quantity, Integer categoryId, String description, int status) {
        this.id = id;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.description = description;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
