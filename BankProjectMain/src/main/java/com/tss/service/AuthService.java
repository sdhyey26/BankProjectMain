package com.tss.service;

import com.tss.dao.UserDAO;
import com.tss.model.User;

public class AuthService {

    public static boolean registerUserWithAccount(User user) {
        return UserDAO.createUserAndAccount(user);
    }
    
    public static User validateUser(String username, String password, String role) {
        return UserDAO.getUserByCredentials(username, password, role);
    }
}

