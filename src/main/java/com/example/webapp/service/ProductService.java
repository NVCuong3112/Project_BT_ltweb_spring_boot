package com.example.webapp.service;

import com.example.webapp.dao.IProductDao;
import com.example.webapp.dao.ProductDAO;
import com.example.webapp.model.Product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Lớp dịch vụ quản lý nghiệp vụ Product.
 */
@Service
public class ProductService implements IProductService {

    private final IProductDao productDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
    }

    @Autowired
    public ProductService(IProductDao productDAO) {
        this.productDAO = productDAO;
    }

    @Override
    public boolean addProduct(Product product) throws Exception {
        validate(product);
        return productDAO.insert(product);
    }

    @Override
    public boolean updateProduct(Product product) throws Exception {
        validate(product);
        if (product.getProductId() <= 0) {
            throw new Exception("Mã sản phẩm không hợp lệ!");
        }
        return productDAO.update(product);
    }

    @Override
    public boolean deleteProduct(int id) {
        if (id <= 0) {
            return false;
        }
        return productDAO.delete(id);
    }

    @Override
    public Product getProductById(int id) {
        if (id <= 0) {
            return null;
        }
        return productDAO.findById(id);
    }

    @Override
    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }

    @Override
    public List<Product> getProductsPaged(int page, int pageSize) {
        int p = page < 1 ? 1 : page;
        int size = pageSize < 1 ? 6 : pageSize;
        return productDAO.findAll(p, size);
    }

    @Override
    public List<Product> getTop10LatestProducts() {
        return productDAO.findTop10Latest();
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllProducts();
        }
        return productDAO.search(keyword);
    }

    @Override
    public long countProducts() {
        return productDAO.count();
    }

    private void validate(Product product) throws Exception {
        if (product == null) {
            throw new Exception("Dữ liệu sản phẩm không được để trống!");
        }
        if (product.getProductName() == null || product.getProductName().trim().isEmpty()) {
            throw new Exception("Tên sản phẩm không được để trống!");
        }
        if (product.getPrice() < 0) {
            throw new Exception("Giá sản phẩm không được âm!");
        }
        if (product.getQuantity() < 0) {
            throw new Exception("Số lượng sản phẩm không được âm!");
        }
        if (product.getCategory() == null) {
            throw new Exception("Vui lòng chọn danh mục cho sản phẩm!");
        }
    }
}
