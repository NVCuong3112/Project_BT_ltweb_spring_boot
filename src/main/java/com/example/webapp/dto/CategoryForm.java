package com.example.webapp.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * DTO nhận và validate form thêm/sửa Danh mục.
 */
public class CategoryForm {

    private int id;

    @NotBlank(message = "Tên danh mục không được để trống!")
    @Size(max = 100, message = "Tên danh mục không được vượt quá 100 ký tự!")
    private String name;

    @Size(max = 255, message = "Mô tả không được vượt quá 255 ký tự!")
    private String description;

    public CategoryForm() {}

    public CategoryForm(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public CategoryForm(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
