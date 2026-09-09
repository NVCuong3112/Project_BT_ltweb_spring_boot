package com.example.webapp.dao;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.model.OtpCode;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Lớp DAO quản lý mã OTP với JPA EntityManager.
 */
public class OtpDAO implements IOtpDao {

    @Override
    public boolean insert(OtpCode otpCode) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(otpCode);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi insert OtpCode: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public void invalidateOldOtps(String email, String type) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Vô hiệu hóa tất cả các OTP cũ chưa dùng của email và type này
            String jpql = "UPDATE OtpCode o SET o.used = true WHERE LOWER(o.email) = LOWER(:email) AND o.type = :type AND o.used = false";
            em.createQuery(jpql)
              .setParameter("email", email.trim())
              .setParameter("type", type)
              .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi invalidateOldOtps: " + e.getMessage());
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public OtpCode findValidOtp(String email, String otpCode, String type) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            String jpql = "SELECT o FROM OtpCode o WHERE LOWER(o.email) = LOWER(:email) " +
                          "AND o.otpCode = :otpCode AND o.type = :type " +
                          "AND o.used = false AND o.expiredAt > :now ORDER BY o.id DESC";
            TypedQuery<OtpCode> query = em.createQuery(jpql, OtpCode.class);
            query.setParameter("email", email.trim());
            query.setParameter("otpCode", otpCode.trim());
            query.setParameter("type", type);
            query.setParameter("now", LocalDateTime.now());

            List<OtpCode> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            System.err.println("Lỗi findValidOtp: " + e.getMessage());
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public boolean markAsUsed(int otpId) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            OtpCode otp = em.find(OtpCode.class, otpId);
            if (otp != null) {
                otp.setUsed(true);
                em.merge(otp);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Lỗi markAsUsed: " + e.getMessage());
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
