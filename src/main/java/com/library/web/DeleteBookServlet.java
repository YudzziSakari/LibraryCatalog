package com.library.web;

import com.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/delete-book")
public class DeleteBookServlet extends HttpServlet {
    private LibraryService service = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login");
            return;
        }
        int id = Integer.parseInt(req.getParameter("id"));
        String title = req.getParameter("title");
        service.deleteBook(id);
        req.getSession().setAttribute("flashMessage", "Книгу «" + (title != null ? title : "") + "» успішно видалено з каталогу.");
        req.getSession().setAttribute("flashType", "danger");
        // повертаємось до попереднього пошуку якщо він був
        String lastQuery = (String) session.getAttribute("lastQuery");
        if (lastQuery != null) {
            resp.sendRedirect("books?query=" + URLEncoder.encode(lastQuery, "UTF-8"));
        } else {
            resp.sendRedirect("books");
        }
    }
}