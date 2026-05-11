package com.library.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        if ("admin".equals(user) && "12345".equals(pass)) {
            HttpSession session = req.getSession();
            session.setAttribute("role", "admin");
            session.setAttribute("username", "Адміністратор");
            resp.sendRedirect("books");
        } else if ("reader".equals(user) && "reader".equals(pass)) {
            HttpSession session = req.getSession();
            session.setAttribute("role", "reader");
            session.setAttribute("username", "Читач");
            resp.sendRedirect("books");
        } else {
            req.setAttribute("error", "Невірний логін або пароль!");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
        }
    }
}