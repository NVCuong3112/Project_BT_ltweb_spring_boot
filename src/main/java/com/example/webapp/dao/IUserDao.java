package com.example.webapp.dao;

import com.example.webapp.model.User;
import java.util.List;

public interface IUserDao {
    boolean insert(User user);
    boolean update(User user);
    User findById(int id);
    User findByUsername(String username);
    User findByEmail(String email);
    List<User> findAll();
}
