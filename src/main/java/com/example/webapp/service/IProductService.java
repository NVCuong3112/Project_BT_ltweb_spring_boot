package com.example.webapp.service;

import com.example.webapp.model.Product;
import java.util.List;

public interface IProductService {
    boolean addProduct(Product product) throws Exception;
    boolean updateProduct(Product product) throws Exception;
    boolean deleteProduct(int id);
    Product getProductById(int id);
    List<Product> getAllProducts();
    List<Product> getProductsPaged(int page, int pageSize);
    List<Product> getTop10LatestProducts();
    List<Product> searchProducts(String keyword);
    long countProducts();
}
