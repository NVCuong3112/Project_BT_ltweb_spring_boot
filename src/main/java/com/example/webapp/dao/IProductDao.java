package com.example.webapp.dao;

import com.example.webapp.model.Product;
import java.util.List;

public interface IProductDao {
    boolean insert(Product product);
    boolean update(Product product);
    boolean delete(int id);
    Product findById(int id);
    List<Product> findAll();
    List<Product> findAll(int page, int pageSize);
    List<Product> findTop10Latest();
    List<Product> search(String keyword);
    long count();
}
