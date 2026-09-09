package com.example.webapp.controller;

import com.example.webapp.dto.ProductForm;
import com.example.webapp.model.Category;
import com.example.webapp.model.Product;
import com.example.webapp.service.CategoryService;
import com.example.webapp.service.IProductService;
import com.example.webapp.service.ProductService;
import com.example.webapp.util.Constants;
import com.example.webapp.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet thêm mới sản phẩm có upload ảnh theo đúng chuẩn mẫu giảng viên:
 * Sử dụng @MultipartConfig và parse header thủ công (getFileName).
 */
@WebServlet({"/add-product", "/admin/add-product"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024,
                 maxFileSize = 1024 * 1024 * 5,
                 maxRequestSize = 1024 * 1024 * 5 * 5)
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() {
        productService = new ProductService();
        categoryService = new CategoryService();
    }

    /**
     * Hàm lấy tên file gốc theo cách parse header thủ công (chuẩn mẫu giảng viên)
     */
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return Constants.DEFAULT_FILENAME;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Truyền danh sách Category để hiển thị Dropdown lựa chọn
        request.setAttribute("categories", categoryService.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String productName = request.getParameter("productName");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");
        String statusStr = request.getParameter("status");

        Double price = null;
        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = Double.parseDouble(priceStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Integer quantity = null;
        try {
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        Integer categoryId = null;
        try {
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        int status = 1;
        try {
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                status = Integer.parseInt(statusStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        ProductForm form = new ProductForm(productName, price, quantity, categoryId, description, status);
        Map<String, String> errors = new HashMap<>(ValidationUtil.validate(form));
        if (price == null) {
            errors.put("price", "Đơn giá phải là số hợp lệ và lớn hơn 0 VNĐ!");
        }
        if (quantity == null) {
            errors.put("quantity", "Số lượng phải là số nguyên không âm!");
        }
        if (categoryId == null) {
            errors.put("categoryId", "Vui lòng chọn danh mục hợp lệ!");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("error", "Dữ liệu sản phẩm không hợp lệ!");
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
            return;
        }

        String uploadPath = Constants.UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String savedFileName = "";

        // Duyệt các parts của request và bỏ qua các part không phải file
        for (Part part : request.getParts()) {
            String contentDisposition = part.getHeader("content-disposition");
            if (contentDisposition != null && contentDisposition.contains("filename") 
                    && part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty() 
                    && part.getSize() > 0) {
                
                String originalFileName = getFileName(part);
                if (!Constants.DEFAULT_FILENAME.equals(originalFileName) && !originalFileName.trim().isEmpty()) {
                    // Loại bỏ đường dẫn nếu trình duyệt cũ gửi cả đường dẫn máy khách
                    if (originalFileName.contains("\\")) {
                        originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
                    } else if (originalFileName.contains("/")) {
                        originalFileName = originalFileName.substring(originalFileName.lastIndexOf("/") + 1);
                    }
                    
                    savedFileName = System.currentTimeMillis() + "_" + originalFileName;
                    part.write(uploadPath + File.separator + savedFileName);
                }
            }
        }

        try {
            Category category = categoryService.getCategoryById(categoryId);
            if (category == null) {
                throw new Exception("Danh mục đã chọn không tồn tại!");
            }

            Product product = new Product();
            product.setProductName(productName != null ? productName.trim() : "");
            product.setPrice(price);
            product.setQuantity(quantity);
            product.setDescription(description != null ? description.trim() : "");
            product.setImage(savedFileName);
            product.setStatus(status);
            product.setCategory(category);

            productService.addProduct(product);

            // Thêm thành công -> Chuyển hướng về trang danh sách quản lý
            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/product-form.jsp").forward(request, response);
        }
    }
}
