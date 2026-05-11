package com.library.web;

import com.library.model.Book;
import com.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/books")
public class BookServlet extends HttpServlet {
    private LibraryService service = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("query");
        List<Book> books;

        if (query != null && !query.trim().isEmpty()) {
            books = service.search(query);
            req.getSession().setAttribute("lastQuery", query);
        } else {
            books = service.getAllBooks();
            req.getSession().removeAttribute("lastQuery");
        }

        req.setAttribute("books", books);
        req.getRequestDispatcher("/WEB-INF/jsp/books.jsp").forward(req, resp);
    }
}