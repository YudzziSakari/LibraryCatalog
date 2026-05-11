package com.library.web;

import com.library.model.Book;
import com.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/edit-book")
public class EditBookServlet extends HttpServlet {
    private LibraryService service = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login");
            return;
        }
        int id = Integer.parseInt(req.getParameter("id"));
        String from = req.getParameter("from");
        Book book = service.getBookById(id);
        req.setAttribute("book", book);
        req.setAttribute("from", from);
        req.getRequestDispatcher("/WEB-INF/jsp/edit-book.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(req.getParameter("id"));
        String from = req.getParameter("from");
        String title = req.getParameter("title");
        String author = req.getParameter("author");
        String description = req.getParameter("description");
        String keywords = req.getParameter("keywords");
        String imageUrl = req.getParameter("image_url");
        int year = Integer.parseInt(req.getParameter("year"));

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            imageUrl = "https://via.placeholder.com/150x220/1a1a1a/e0e0e0?text=No+Cover";
        }

        service.updateBook(id, title, author, description, keywords, imageUrl, year);
        req.getSession().setAttribute("flashMessage", "Зміни до книги «" + title + "» успішно збережено.");
        req.getSession().setAttribute("flashType", "success");

        if ("details".equals(from)) {
            resp.sendRedirect("book?id=" + id);
        } else {
            String lastQuery = (String) req.getSession().getAttribute("lastQuery");
            if (lastQuery != null) {
                resp.sendRedirect("books?query=" + URLEncoder.encode(lastQuery, "UTF-8"));
            } else {
                resp.sendRedirect("books");
            }
        }
    }
}