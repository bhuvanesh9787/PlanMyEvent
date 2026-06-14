package com.ems.servlet;

import com.ems.dao.PaymentDAO;
import com.ems.model.*;
import com.ems.util.QRGenerator;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }
        req.getRequestDispatcher("/pages/payment.jsp").forward(req,res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session==null||session.getAttribute("loggedUser")==null) {
            res.sendRedirect(req.getContextPath()+"/pages/login.jsp");
            return;
        }

        String  action  = req.getParameter("action");
        Booking booking = (Booking) session.getAttribute("pendingBooking");
        Event   event   = (Event)   session.getAttribute("pendingEvent");

        if (booking==null||event==null) {
            res.sendRedirect(req.getContextPath()+
                "/pages/participant_dashboard.jsp");
            return;
        }

        try {
            PaymentDAO paymentDAO = new PaymentDAO();

            if ("card".equals(action)) {

                String cardNumber = req.getParameter("cardNumber");
                if (cardNumber==null||cardNumber.trim().isEmpty()) {
                    req.setAttribute("error","Card number is required.");
                    req.getRequestDispatcher("/pages/payment.jsp")
                       .forward(req,res);
                    return;
                }

                String digits = cardNumber.replaceAll("\\s","");
                String last4  = digits.length()>=4?
                    digits.substring(digits.length()-4):"0000";

                Payment payment = new Payment();
                payment.setBookingId(booking.getBookingId());
                payment.setAmount(booking.getTotalAmount());
                payment.setPaymentMethod("card");
                payment.setCardLast4(last4);
                payment.setTransactionId("TXN-"+
                    UUID.randomUUID().toString()
                        .replace("-","").substring(0,12).toUpperCase());
                paymentDAO.savePayment(payment);

                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingEvent");

                req.setAttribute("booking", booking);
                req.setAttribute("event",   event);
                req.setAttribute("payment", payment);
                req.getRequestDispatcher("/pages/booking_confirmation.jsp")
                   .forward(req,res);

            } else if ("qr".equals(action)) {

                String qrContent =
                    "PlanMyEvent|Booking:"+booking.getBookingId()+
                    "|Amount:INR"+booking.getTotalAmount()+
                    "|Event:"+event.getTitle()+
                    "|Date:"+event.getEventDate();

                String savePath =
                    getServletContext().getRealPath("/qrcodes");
                java.io.File dir = new java.io.File(savePath);
                if (!dir.exists()) dir.mkdirs();

                String qrPath = QRGenerator.generateQR(
                    qrContent, booking.getBookingId(), savePath);

                Payment payment = new Payment();
                payment.setBookingId(booking.getBookingId());
                payment.setAmount(booking.getTotalAmount());
                payment.setPaymentMethod("qr");
                payment.setCardLast4(null);
                payment.setTransactionId("QR-"+
                    UUID.randomUUID().toString()
                        .replace("-","").substring(0,12).toUpperCase());
                paymentDAO.savePayment(payment);

                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingEvent");

                req.setAttribute("booking", booking);
                req.setAttribute("event",   event);
                req.setAttribute("payment", payment);
                req.setAttribute("qrPath",  qrPath);
                req.getRequestDispatcher("/pages/booking_confirmation.jsp")
                   .forward(req,res);

            } else {
                res.sendRedirect(req.getContextPath()+"/pages/payment.jsp");
            }

        } catch (Exception ex) {
            req.setAttribute("error","Payment error: "+ex.getMessage());
            req.getRequestDispatcher("/pages/error.jsp").forward(req,res);
        }
    }
}