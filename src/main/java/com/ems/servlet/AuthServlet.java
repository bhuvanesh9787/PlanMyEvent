package com.ems.servlet;

import com.ems.dao.UserDAO;
import com.ems.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            res.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/pages/admin_dashboard.jsp");
            } else if ("organiser".equals(role)) {
                res.sendRedirect(req.getContextPath() + "/pages/organiser_dashboard.jsp");
            } else {
                res.sendRedirect(req.getContextPath() + "/pages/participant_dashboard.jsp");
            }
            return;
        }

        req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            res.sendRedirect(req.getContextPath() + "/pages/login.jsp");
            return;
        }

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            role == null || role.isEmpty()) {
            req.setAttribute("error",
                "Please fill in all fields and select a role.");
            req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
            return;
        }

        try {
            UserDAO dao  = new UserDAO();
            User    user = dao.loginUser(email.trim(), password, role);

            if (user != null) {
                HttpSession old = req.getSession(false);
                if (old != null) old.invalidate();

                HttpSession session = req.getSession(true);
                session.setAttribute("loggedUser", user);
                session.setAttribute("role",       user.getRole());
                session.setAttribute("userId",     user.getUserId());
                session.setMaxInactiveInterval(1800);

                switch (user.getRole()) {
                    case "admin":
                        res.sendRedirect(req.getContextPath() +
                            "/pages/admin_dashboard.jsp");
                        break;
                    case "organiser":
                        res.sendRedirect(req.getContextPath() +
                            "/pages/organiser_dashboard.jsp");
                        break;
                    default:
                        res.sendRedirect(req.getContextPath() +
                            "/pages/participant_dashboard.jsp");
                }
            } else {
                req.setAttribute("error",
                    "Invalid email, password or role. Please try again.");
                req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/pages/login.jsp").forward(req, res);
        }
    }
}