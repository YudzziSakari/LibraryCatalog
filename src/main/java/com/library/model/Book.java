package com.library.model;

public class Book {
    private int id;
    private String title;
    private String author;
    private String description;
    private String keywords;
    private String imageUrl;
    private int publicationYear;

    public Book(int id, String title, String author, String description, String keywords, String imageUrl, int publicationYear) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.description = description;
        this.keywords = keywords;
        this.imageUrl = imageUrl;
        this.publicationYear = publicationYear;
    }

    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public String getDescription() { return description; }
    public String getKeywords() { return keywords; }
    public String getImageUrl() { return imageUrl; }
    public int getPublicationYear() { return publicationYear; }
}