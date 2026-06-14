package com.ems.util;

import com.ems.model.User;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static boolean isLoggedIn(HttpSession s) {
        return s != null && s.getAttribute("loggedUser") != null;
    }

    public static User getUser(HttpSession s) {
        if (s == null) return null;
        return (User) s.getAttribute("loggedUser");
    }

    public static String getRole(HttpSession s) {
        if (s == null) return null;
        return (String) s.getAttribute("role");
    }

    public static boolean isAdmin(HttpSession s) {
        return "admin".equals(getRole(s));
    }

    public static boolean isOrganiser(HttpSession s) {
        return "organiser".equals(getRole(s));
    }

    public static boolean isParticipant(HttpSession s) {
        return "participant".equals(getRole(s));
    }
}