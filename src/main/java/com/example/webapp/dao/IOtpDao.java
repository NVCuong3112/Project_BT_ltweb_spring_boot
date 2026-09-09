package com.example.webapp.dao;

import com.example.webapp.model.OtpCode;

public interface IOtpDao {
    boolean insert(OtpCode otpCode);
    void invalidateOldOtps(String email, String type);
    OtpCode findValidOtp(String email, String otpCode, String type);
    boolean markAsUsed(int otpId);
}
