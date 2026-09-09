package com.example.webapp.service;

import com.example.webapp.model.User;

public interface IUserService {
    boolean register(String username, String password, String email, String fullName) throws Exception;
    boolean activateAccount(String email, String otpCode) throws Exception;
    boolean resendOtp(String email, String type) throws Exception;
    User login(String username, String password) throws Exception;
    boolean forgotPassword(String email) throws Exception;
    boolean resetPassword(String email, String otpCode, String newPassword) throws Exception;
    User findByUsername(String username);
    User findByEmail(String email);
    User findById(int id);
    boolean updateProfile(int userId, String fullName, String phone, String avatar) throws Exception;
}
