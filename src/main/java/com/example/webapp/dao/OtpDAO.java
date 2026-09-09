package com.example.webapp.dao;

import com.example.webapp.config.JPAConfig;
import com.example.webapp.model.OtpCode;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Lớp DAO quản lý mã OTP với JPA EntityManager.
 * Khai báo @Repository để Spring Boot tự động nhận diện bean IOtpDao.
 */
@Repository
@Transactional
public class OtpDAO implements IOtpDao {

    @PersistenceContext
    private EntityManager em;

    private EntityManager getEntityManager() {
        if (this.em != null) {
            return this.em;
        }
        return JPAConfig.getEntityManager();
    }

    @Override
    public boolean insert(OtpCode otpCode) {
        try {
            EntityManager currentEm = getEntityManager();
            if (this.em != null) {
                currentEm.persist(otpCode);
                return true;
            } else {
                EntityTransaction tx = currentEm.getTransaction();
                tx.begin();
                currentEm.persist(otpCode);
                tx.commit();
                return true;
            }
        } catch (Exception e) {
            System.err.println("Lỗi insert OtpCode: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void invalidateOldOtps(String email, String type) {
        try {
            EntityManager currentEm = getEntityManager();
            String jpql = "UPDATE OtpCode o SET o.used = true WHERE LOWER(o.email) = LOWER(:email) AND o.type = :type AND o.used = false";
            if (this.em != null) {
                currentEm.createQuery(jpql)
                         .setParameter("email", email.trim())
                         .setParameter("type", type)
                         .executeUpdate();
            } else {
                EntityTransaction tx = currentEm.getTransaction();
                tx.begin();
                currentEm.createQuery(jpql)
                         .setParameter("email", email.trim())
                         .setParameter("type", type)
                         .executeUpdate();
                tx.commit();
            }
        } catch (Exception e) {
            System.err.println("Lỗi invalidateOldOtps: " + e.getMessage());
        }
    }

    @Override
    @Transactional(readOnly = true)
    public OtpCode findValidOtp(String email, String otpCode, String type) {
        try {
            EntityManager currentEm = getEntityManager();
            String jpql = "SELECT o FROM OtpCode o WHERE LOWER(o.email) = LOWER(:email) " +
                          "AND o.otpCode = :otpCode AND o.type = :type " +
                          "AND o.used = false AND o.expiredAt > :now ORDER BY o.id DESC";
            TypedQuery<OtpCode> query = currentEm.createQuery(jpql, OtpCode.class);
            query.setParameter("email", email.trim());
            query.setParameter("otpCode", otpCode.trim());
            query.setParameter("type", type);
            query.setParameter("now", LocalDateTime.now());

            List<OtpCode> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            System.err.println("Lỗi findValidOtp: " + e.getMessage());
            return null;
        }
    }

    @Override
    public boolean markAsUsed(int otpId) {
        try {
            EntityManager currentEm = getEntityManager();
            if (this.em != null) {
                OtpCode otp = currentEm.find(OtpCode.class, otpId);
                if (otp != null) {
                    otp.setUsed(true);
                    currentEm.merge(otp);
                    return true;
                }
                return false;
            } else {
                EntityTransaction tx = currentEm.getTransaction();
                tx.begin();
                OtpCode otp = currentEm.find(OtpCode.class, otpId);
                if (otp != null) {
                    otp.setUsed(true);
                    currentEm.merge(otp);
                    tx.commit();
                    return true;
                }
                tx.rollback();
                return false;
            }
        } catch (Exception e) {
            System.err.println("Lỗi markAsUsed: " + e.getMessage());
            return false;
        }
    }
}
