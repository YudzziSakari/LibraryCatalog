package com.library.repository;

import com.library.model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MySQLBookRepository {

    public List<Book> findAll() {
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM books ORDER BY id DESC")) {
            while (rs.next()) {
                books.add(extractBook(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return books;
    }

    public List<Book> search(String query) {
        List<Book> books = new ArrayList<>();
        if (query == null || query.trim().isEmpty()) return findAll();

        String[] words = query.trim().split("\\s+");

        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM books WHERE 1=1 ");
        // для кожного слова додаємо умову пошуку по трьох полях
        for (int i = 0; i < words.length; i++) {
            sqlBuilder.append(" AND (title LIKE ? OR author LIKE ? OR keywords LIKE ?) ");
        }

        sqlBuilder.append(" ORDER BY id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            for (String word : words) {
                String pattern = "%" + word + "%";
                pstmt.setString(paramIndex++, pattern);
                pstmt.setString(paramIndex++, pattern);
                pstmt.setString(paramIndex++, pattern);
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                books.add(extractBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public void addBook(String title, String author, String description, String keywords, String imageUrl, int year) {
        String sql = "INSERT INTO books (title, author, description, keywords, image_url, publication_year) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, description);
            pstmt.setString(4, keywords);
            pstmt.setString(5, imageUrl);
            pstmt.setInt(6, year);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void updateBook(int id, String title, String author, String description, String keywords, String imageUrl, int year) {
        String sql = "UPDATE books SET title=?, author=?, description=?, keywords=?, image_url=?, publication_year=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, description);
            pstmt.setString(4, keywords);
            pstmt.setString(5, imageUrl);
            pstmt.setInt(6, year);
            pstmt.setInt(7, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public Book getBookById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM books WHERE id = ?")) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return extractBook(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void deleteBook(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM books WHERE id = ?")) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private Book extractBook(ResultSet rs) throws SQLException {
        return new Book(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("author"),
                rs.getString("description"),
                rs.getString("keywords"),
                rs.getString("image_url"),
                rs.getInt("publication_year")
        );
    }
}