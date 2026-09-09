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

/**
 * Servlet hiển thị chi tiết sản phẩm.
 * Mapping: /product/detail?id=...
 */
@WebServlet("/product/detail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Product product = productService.getProductById(id);
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            // Lỗi parse id hoặc không tìm thấy
        }

        response.sendRedirect(request.getContextPath() + "/product");
    }
}
