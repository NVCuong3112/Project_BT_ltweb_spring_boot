package com.example.webapp.controller;

import com.example.webapp.model.Product;
import com.example.webapp.service.IProductService;
import com.example.webapp.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet hiển thị danh sách quản lý sản phẩm cho quản trị viên (Admin).
 */
@WebServlet({"/admin/products", "/products/admin"})
public class ProductAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);
        
        request.getRequestDispatcher("/WEB-INF/views/product-admin-list.jsp").forward(request, response);
    }
}
