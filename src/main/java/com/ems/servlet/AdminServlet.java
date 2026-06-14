package com.ems.servlet;

import com.ems.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||!"admin".equals(session.getAttribute("role"))) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        try {
            req.setAttribute("users",    new UserDAO().getAllUsers());
            req.setAttribute("events",   new EventDAO().getAllEvents());
            req.setAttribute("bookings", new BookingDAO().getAllBookings());
            req.setAttribute("payments", new PaymentDAO().getAllPayments());
            req.getRequestDispatcher("/pages/admin_dashboard.jsp")
               .forward(req,res);

        } catch (Exception ex) {
            req.setAttribute("error","Admin error: "+ex.getMessage());
            req.getRequestDispatcher("/pages/error.jsp").forward(req,res);
        }
    }
}