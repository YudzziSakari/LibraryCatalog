package com.library.web;

import com.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/add-book")
public class AddBookServlet extends HttpServlet {
    private LibraryService service = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/add-book.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String description = req.getParameter("description");
        String keywords = req.getParameter("keywords");
        String imageUrl = req.getParameter("image_url");
        int year = Integer.parseInt(req.getParameter("year"));

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "https://via.placeholder.com/150x220/1a1a1a/e0e0e0?text=No+Cover";
        }

        service.addBook(title, author, description, keywords, imageUrl, year);
        req.getSession().setAttribute("flashMessage", "Книгу «" + title + "» успішно додано до каталогу!");
        req.getSession().setAttribute("flashType", "success");
        resp.sendRedirect("books");
    }
}