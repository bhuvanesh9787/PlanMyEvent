package com.ems.servlet;

import com.ems.dao.EventDAO;
import com.ems.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/event")
public class EventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        EventDAO dao  = new EventDAO();

        try {
            if ("view".equals(action)) {
                String idStr = req.getParameter("eventId");
                if (idStr!=null&&!idStr.isEmpty()) {
                    req.setAttribute("event",
                        dao.getEventById(Integer.parseInt(idStr)));
                    req.getRequestDispatcher("/pages/view_event.jsp")
                       .forward(req, res);
                } else {
                    res.sendRedirect(req.getContextPath()+
                        "/pages/participant_dashboard.jsp");
                }
            } else {
                res.sendRedirect(req.getContextPath()+
                    "/pages/participant_dashboard.jsp");
            }
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/pages/error.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        User     user   = (User) session.getAttribute("loggedUser");
        String   action = req.getParameter("action");
        EventDAO dao    = new EventDAO();

        try {
            switch (action!=null?action:"") {

                case "add":
                    Event e = new Event();
                    e.setOrganiserId(user.getUserId());
                    e.setTitle(req.getParameter("title").trim());
                    e.setDescription(req.getParameter("description").trim());
                    e.setVenue(req.getParameter("venue").trim());
                    e.setEventDate(
                        Date.valueOf(req.getParameter("eventDate")));
                    e.setEventTime(
                        Time.valueOf(req.getParameter("eventTime")+":00"));
                    e.setTotalSeats(
                        Integer.parseInt(req.getParameter("totalSeats")));
                    e.setTicketPrice(
                        new BigDecimal(req.getParameter("ticketPrice")));
                    dao.addEvent(e);
                    res.sendRedirect(req.getContextPath()+
                        "/pages/organiser_dashboard.jsp?msg=added");
                    break;

                case "delete":
                    dao.deleteEvent(
                        Integer.parseInt(req.getParameter("eventId")));
                    res.sendRedirect(req.getContextPath()+
                        "/pages/organiser_dashboard.jsp?msg=deleted");
                    break;

                case "cancel":
                    dao.cancelEvent(
                        Integer.parseInt(req.getParameter("eventId")));
                    res.sendRedirect(req.getContextPath()+
                        "/pages/organiser_dashboard.jsp?msg=cancelled");
                    break;

                default:
                    res.sendRedirect(req.getContextPath()+
                        "/pages/organiser_dashboard.jsp");
            }
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/pages/error.jsp").forward(req, res);
        }
    }
}