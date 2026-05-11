<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Редагувати — ${book.title}</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-dark.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container" style="max-width: 800px;">

    <%-- повертаємось або на деталі книги або в каталог --%>
    <c:set var="backUrl" value="${from == 'details' ? 'book?id='.concat(book.id) : 'books'}" />

    <div class="form-container" style="margin: 0 auto;">
        <h2><i class="fa-solid fa-pen-to-square"></i> Редагування книги</h2>

        <form action="edit-book" method="POST">
            <input type="hidden" name="id" value="${book.id}">
            <input type="hidden" name="from" value="${from}">

            <div class="form-group">
                <label for="title">Назва книги</label>
                <input type="text" id="title" name="title" value="${book.title}" required>
            </div>

            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <label for="author">Автор</label>
                    <input type="text" id="author" name="author" value="${book.author}" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="year">Рік видання</label>
                    <input type="number" id="year" name="year" value="${book.publicationYear}" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="keywords">Ключові слова</label>
                    <input type="text" id="keywords" name="keywords" value="${book.keywords}">
                </div>
                <div class="form-group">
                    <label for="image_url">Обкладинка (URL)</label>
                    <input type="text" id="image_url" name="image_url" value="${book.imageUrl}">
                </div>
            </div>

            <div class="form-group">
                <label for="description">Опис книги</label>
                <textarea id="description" name="description" rows="7" maxlength="3000" required>${book.description}</textarea>
            </div>

            <div class="form-actions">
                <a href="${backUrl}" class="btn-cancel">
                    <i class="fa-solid fa-xmark"></i> Скасувати
                </a>
                <button type="submit" class="btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Зберегти зміни
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>