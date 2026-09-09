package com.example.webapp.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Lớp cấu hình JPA cũ được chuyển đổi thành Spring Component.
 * Không còn dùng persistence.xml, tự động tiếp nhận EntityManagerFactory từ Spring Boot.
 * Đánh dấu @Deprecated để khuyến khích dùng Spring Data JPA Repository.
 */
@Deprecated
@Component
public class JPAConfig {

    private static EntityManagerFactory entityManagerFactory;

    @Autowired
    public JPAConfig(EntityManagerFactory emf) {
        JPAConfig.entityManagerFactory = emf;
    }

    public JPAConfig() {
    }

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        return entityManagerFactory;
    }

    public static EntityManager getEntityManager() {
        if (entityManagerFactory != null) {
            return entityManagerFactory.createEntityManager();
        }
        return null;
    }

    public static synchronized void shutdown() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
        }
    }
}
