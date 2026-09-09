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
 * Servlet hiển thị danh sách sản phẩm phân trang (6 sản phẩm/trang) cho người dùng.
 */
@WebServlet("/product")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 6; // 6 sản phẩm mỗi trang theo yêu cầu

    private IProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pageStr = request.getParameter("page");
        int currentPage = 1;
        try {
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        // Lấy dữ liệu 6 sản phẩm của trang hiện tại
        List<Product> products = productService.getProductsPaged(currentPage, PAGE_SIZE);

        // Đếm tổng số sản phẩm và tính tổng số trang
        long totalProducts = productService.countProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("products", products);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);

        request.getRequestDispatcher("/product-list.jsp").forward(request, response);
    }
}
