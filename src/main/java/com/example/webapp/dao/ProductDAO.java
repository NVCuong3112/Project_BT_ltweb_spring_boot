package com.example.webapp.dao;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.model.Product;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.Collections;
import java.util.List;

/**
 * Lớp DAO quản lý Product sử dụng JPA 3.0 (EntityManager).
 * Theo đúng pattern try - catch (rollback) - finally (close em) như CategoryDAO.
 */
public class ProductDAO implements IProductDao {

    @Override
    public boolean insert(Product product) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(product);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi insert Product: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public boolean update(Product product) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(product);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi update Product: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public boolean delete(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Product product = em.find(Product.class, id);
            if (product != null) {
                em.remove(product);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi delete Product ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public Product findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Product.class, id);
        } catch (Exception e) {
            System.err.println("Lỗi findById Product ID " + id + ": " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public List<Product> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p ORDER BY p.productId DESC";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi findAll Product: " + e.getMessage());
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public List<Product> findAll(int page, int pageSize) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p WHERE p.status = 1 ORDER BY p.productId DESC";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            int firstResult = (page - 1) * pageSize;
            query.setFirstResult(Math.max(0, firstResult));
            query.setMaxResults(pageSize);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi phân trang Product: " + e.getMessage());
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public List<Product> findTop10Latest() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // JPQL lấy 10 sản phẩm mới nhất theo ngày tạo
            String jpql = "SELECT p FROM Product p WHERE p.status = 1 ORDER BY p.createdAt DESC";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            query.setMaxResults(10);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi findTop10Latest Product: " + e.getMessage());
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public List<Product> search(String keyword) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT p FROM Product p WHERE p.status = 1 AND (" +
                          "LOWER(p.productName) LIKE LOWER(:kw) OR LOWER(p.description) LIKE LOWER(:kw)) " +
                          "ORDER BY p.productId DESC";
            TypedQuery<Product> query = em.createQuery(jpql, Product.class);
            query.setParameter("kw", "%" + keyword.trim() + "%");
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi search Product: " + e.getMessage());
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public long count() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Product p WHERE p.status = 1";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            return query.getSingleResult();
        } catch (Exception e) {
            System.err.println("Lỗi count Product: " + e.getMessage());
            return 0L;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
