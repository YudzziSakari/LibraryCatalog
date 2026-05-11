package com.library.web;

import com.library.model.Book;
import com.library.service.LibraryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/book")
public class BookDetailsServlet extends HttpServlet {
    private LibraryService service = new LibraryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                Book book = service.getBookById(id);

                if (book != null) {
                    req.setAttribute("book", book);
                    req.getRequestDispatcher("/WEB-INF/jsp/book-details.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException e) {

            }
        }

        resp.sendRedirect("books");
    }
}