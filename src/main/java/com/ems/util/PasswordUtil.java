package com.ems.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt());
    }

    public static boolean verifyPassword(String plain, String hashed) {
        return BCrypt.checkpw(plain, hashed);
    }
}