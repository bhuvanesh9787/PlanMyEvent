package com.ems.servlet;

import com.ems.dao.*;
import com.ems.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.ems.util.DBConnection;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("cancelPending".equals(action)) {
            try {
                Booking booking = (Booking) session.getAttribute("pendingBooking");
                if (booking != null) {
                    // Release the seats that were held for this booking
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement ps = con.prepareStatement(
                             "UPDATE events SET available_seats=available_seats+? WHERE event_id=?")) {
                        ps.setInt(1, booking.getSeatsBooked());
                        ps.setInt(2, booking.getEventId());
                        ps.executeUpdate();
                    }
                    // Delete the unpaid booking row
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement ps = con.prepareStatement(
                             "DELETE FROM bookings WHERE booking_id=?")) {
                        ps.setInt(1, booking.getBookingId());
                        ps.executeUpdate();
                    }
                }
            } catch (Exception ex) {
                // Even if cleanup fails, continue back to dashboard
            }
            session.removeAttribute("pendingBooking");
            session.removeAttribute("pendingEvent");
            res.sendRedirect(req.getContextPath()+"/pages/participant_dashboard.jsp");
            return;
        }

        res.sendRedirect(req.getContextPath()+"/pages/participant_dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        User   user   = (User) session.getAttribute("loggedUser");
        String action = req.getParameter("action");

        try {
            BookingDAO bookingDAO = new BookingDAO();
            EventDAO   eventDAO   = new EventDAO();

            if ("book".equals(action)||action==null) {

                int   eventId = Integer.parseInt(req.getParameter("eventId"));
                int   seats   = Integer.parseInt(req.getParameter("seats"));
                Event event   = eventDAO.getEventById(eventId);

                if (event==null) {
                    req.setAttribute("error","Event not found.");
                    req.getRequestDispatcher("/pages/error.jsp")
                       .forward(req,res);
                    return;
                }

                if (event.getAvailableSeats()<seats) {
                    req.setAttribute("error","Not enough seats available.");
                    req.getRequestDispatcher("/pages/participant_dashboard.jsp")
                       .forward(req,res);
                    return;
                }

                BigDecimal total =
                    event.getTicketPrice().multiply(new BigDecimal(seats));

                Booking b = new Booking();
                b.setEventId(eventId);
                b.setParticipantId(user.getUserId());
                b.setSeatsBooked(seats);
                b.setTotalAmount(total);

                int bookingId = bookingDAO.createBooking(b);
                b.setBookingId(bookingId);

                session.setAttribute("pendingBooking", b);
                session.setAttribute("pendingEvent",   event);
                res.sendRedirect(req.getContextPath()+"/pages/payment.jsp");

            } else if ("cancel".equals(action)) {

                int     bookingId = Integer.parseInt(req.getParameter("bookingId"));
                Booking booking   = bookingDAO.getBookingById(bookingId);

                if (booking==null||booking.getParticipantId()!=user.getUserId()){
                    res.sendRedirect(req.getContextPath()+
                        "/pages/participant_dashboard.jsp");
                    return;
                }

                Event event = eventDAO.getEventById(booking.getEventId());
                if (event==null) {
                    res.sendRedirect(req.getContextPath()+
                        "/pages/participant_dashboard.jsp");
                    return;
                }

                int refundPercent =
                    bookingDAO.cancelBookingByParticipant(
                        bookingId, event.getEventDate());

                session.setAttribute("cancelledBooking",  booking);
                session.setAttribute("cancelledEvent",    event);
                session.setAttribute("refundPercent",     refundPercent);
                res.sendRedirect(req.getContextPath()+"/pages/refund_status.jsp");

            } else {
                res.sendRedirect(req.getContextPath()+
                    "/pages/participant_dashboard.jsp");
            }

        } catch (Exception ex) {
            req.setAttribute("error","Booking error: "+ex.getMessage());
            req.getRequestDispatcher("/pages/error.jsp").forward(req,res);
        }
    }
}