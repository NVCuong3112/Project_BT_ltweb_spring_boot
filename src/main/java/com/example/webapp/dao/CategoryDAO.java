package com.example.webapp.dao;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.model.Category;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.Collections;
import java.util.List;

/**
 * Lớp DAO xử lý dữ liệu Category bằng JPA 3.0 (Jakarta Persistence) + Hibernate.
 * Thay thế hoàn toàn JDBC thuần bằng EntityManager và JPQL.
 */
public class CategoryDAO {

    /**
     * Thêm mới một danh mục (Insert)
     * Sử dụng Transaction: try - catch (rollback) - finally (close em)
     */
    public boolean insert(Category category) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // 1. Bắt đầu transaction
            tx.begin();
            // 2. Persist đối tượng Entity vào cơ sở dữ liệu
            em.persist(category);
            // 3. Commit transaction
            tx.commit();
            return true;
        } catch (Exception e) {
            // Rollback nếu có lỗi xảy ra
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi insert Category: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Luôn đóng EntityManager để tránh rò rỉ tài nguyên
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Phương thức tương thích ngược với code cũ: save gọi đến insert
     */
    public boolean save(Category category) {
        return insert(category);
    }

    /**
     * Cập nhật thông tin danh mục (Update)
     * Sử dụng em.merge() để đồng bộ trạng thái Entity
     */
    public boolean update(Category category) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // em.merge() sẽ cập nhật bản ghi đã tồn tại
            em.merge(category);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi update Category: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Xóa danh mục theo ID (Delete)
     */
    public boolean delete(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Tìm Entity cần xóa trong context hiện tại
            Category category = em.find(Category.class, id);
            if (category != null) {
                // Xóa entity khỏi database
                em.remove(category);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi delete Category ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Tìm danh mục theo ID (Find by ID)
     */
    public Category findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Sử dụng em.find trực tiếp theo khóa chính
            return em.find(Category.class, id);
        } catch (Exception e) {
            System.err.println("Lỗi findById Category ID " + id + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Lấy toàn bộ danh sách Category, sắp xếp theo ID giảm dần (Find all)
     * Sử dụng câu lệnh JPQL
     */
    public List<Category> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // JPQL: truy vấn trên Entity Category (không phải tên bảng)
            String jpql = "SELECT c FROM Category c ORDER BY c.id DESC";
            TypedQuery<Category> query = em.createQuery(jpql, Category.class);
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi findAll Category: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Tìm kiếm danh mục theo từ khóa trong tên hoặc mô tả (Search)
     */
    public List<Category> search(String keyword) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(:keyword) " +
                          "OR LOWER(c.description) LIKE LOWER(:keyword) ORDER BY c.id DESC";
            TypedQuery<Category> query = em.createQuery(jpql, Category.class);
            query.setParameter("keyword", "%" + keyword.trim() + "%");
            return query.getResultList();
        } catch (Exception e) {
            System.err.println("Lỗi search Category với keyword '" + keyword + "': " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    /**
     * Đếm tổng số lượng danh mục trong cơ sở dữ liệu (Count)
     */
    public long count() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT COUNT(c) FROM Category c";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            return query.getSingleResult();
        } catch (Exception e) {
            System.err.println("Lỗi count Category: " + e.getMessage());
            e.printStackTrace();
            return 0L;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
