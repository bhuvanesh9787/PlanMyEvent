package com.ems.servlet;

import com.ems.dao.*;
import com.ems.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String type = req.getParameter("type");
        if ("organiser".equals(type)) {
            req.getRequestDispatcher("/pages/register_organiser.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/pages/register_participant.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String type = req.getParameter("type");
        if (type == null) type = "participant";

        try {
            String name     = req.getParameter("name");
            String email    = req.getParameter("email");
            String phone    = req.getParameter("phone");
            String password = req.getParameter("password");

            if (name==null||name.trim().isEmpty()||
                email==null||email.trim().isEmpty()||
                phone==null||phone.trim().isEmpty()||
                password==null||password.isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                req.getRequestDispatcher("/pages/register_"+type+".jsp")
                   .forward(req, res);
                return;
            }

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim());
            user.setPhone(phone.trim());
            user.setPasswordHash(password);
            user.setRole(type);

            UserDAO userDAO = new UserDAO();
            boolean saved   = userDAO.registerUser(user);

            if (saved) {
                User registered = userDAO.loginUser(
                    user.getEmail(), password, type);

                if (registered == null) {
                    req.setAttribute("error",
                        "Registration error. Please try again.");
                    req.getRequestDispatcher("/pages/register_"+type+".jsp")
                       .forward(req, res);
                    return;
                }

                if ("organiser".equals(type)) {
                    OrganiserDetail od = new OrganiserDetail();
                    od.setUserId(registered.getUserId());
                    String orgName = req.getParameter("orgName");
                    String address = req.getParameter("address");
                    String idProof = req.getParameter("idProof");
                    od.setOrganisationName(orgName!=null?orgName.trim():"");
                    od.setAddress(address!=null?address.trim():"");
                    od.setIdProof(idProof!=null?idProof.trim():"");
                    new OrganiserDAO().saveOrganiserDetails(od);

                } else {
                    ParticipantDetail pd = new ParticipantDetail();
                    pd.setUserId(registered.getUserId());
                    String ageStr   = req.getParameter("age");
                    String address  = req.getParameter("address");
                    pd.setAge(ageStr!=null&&!ageStr.isEmpty()?
                        Integer.parseInt(ageStr):0);
                    pd.setAddress(address!=null?address.trim():"");
                    new ParticipantDAO().saveParticipantDetails(pd);
                }

                res.sendRedirect(req.getContextPath() +
                    "/pages/login.jsp?msg=registered");

            } else {
                req.setAttribute("error",
                    "Registration failed. Email may already be in use.");
                req.getRequestDispatcher("/pages/register_"+type+".jsp")
                   .forward(req, res);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/pages/register_"+type+".jsp")
               .forward(req, res);
        }
    }
}