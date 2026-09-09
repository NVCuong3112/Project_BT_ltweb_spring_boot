package com.example.webapp.controller;

import com.example.webapp.service.IProductService;
import com.example.webapp.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet xóa sản phẩm khỏi cơ sở dữ liệu.
 */
@WebServlet({"/delete-product", "/admin/delete-product"})
public class DeleteProductServlet extends HttpServlet {
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
            productService.deleteProduct(id);
        } catch (NumberFormatException e) {
            System.err.println("ID sản phẩm xóa không hợp lệ: " + idStr);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
