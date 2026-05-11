package com.library.service;

import com.library.model.Book;
import com.library.repository.MySQLBookRepository;
import java.util.List;

public class LibraryService {
    private MySQLBookRepository repository = new MySQLBookRepository();

    public List<Book> getAllBooks() { return repository.findAll(); }

    public List<Book> search(String query) {
        if (query == null || query.trim().isEmpty()) return repository.findAll();
        return repository.search(query);
    }

    public void addBook(String t, String a, String d, String k, String img, int y) { repository.addBook(t, a, d, k, img, y); }
    public void updateBook(int id, String t, String a, String d, String k, String img, int y) { repository.updateBook(id, t, a, d, k, img, y); }
    public void deleteBook(int id) { repository.deleteBook(id); }
    public Book getBookById(int id) { return repository.getBookById(id); }
}