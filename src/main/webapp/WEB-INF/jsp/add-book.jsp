<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Додати книгу — Бібліотека</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-dark.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container" style="max-width: 800px;">

    <div class="form-container" style="margin: 0 auto;">
        <h2><i class="fa-solid fa-plus"></i> Додати нову книгу</h2>

        <form action="add-book" method="POST">

            <div class="form-group">
                <label for="title">Назва книги</label>
                <input type="text" id="title" name="title" required placeholder="Наприклад: Сяйво">
            </div>

            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <label for="author">Автор</label>
                    <input type="text" id="author" name="author" required placeholder="Наприклад: Стівен Кінг">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="year">Рік видання</label>
                    <input type="number" id="year" name="year" required placeholder="1996" min="1000" max="2100">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="keywords">Ключові слова <span style="color: var(--ink-faint); font-style: italic; text-transform: none; font-size: 1em;">(через кому)</span></label>
                    <input type="text" id="keywords" name="keywords" placeholder="містика, класика">
                </div>
                <div class="form-group">
                    <label for="image_url">Обкладинка (URL)</label>
                    <input type="text" id="image_url" name="image_url" placeholder="https://example.com/cover.jpg">
                </div>
            </div>

            <div class="form-group">
                <label for="description">Опис книги</label>
                <textarea id="description" name="description" rows="7" maxlength="3000" required placeholder="Короткий зміст або анотація…"></textarea>
            </div>

            <div class="form-actions">
                <a href="books" class="btn-cancel">
                    <i class="fa-solid fa-xmark"></i> Скасувати
                </a>
                <button type="submit" class="btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Зберегти книгу
                </button>
            </div>

        </form>
    </div>
</div>
</body>
</html>