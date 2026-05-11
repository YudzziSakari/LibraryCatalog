<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Каталог — Бібліотека</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-dark.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container">

    <div class="header">
        <div class="header-logo">
            <h1><i class="fa-solid fa-book-open-reader" style="color: var(--accent); font-size: 0.8em;"></i> Каталог бібліотеки</h1>
            <span class="header-tagline">— зібрання книг</span>
        </div>
        <div class="auth-box">
            <c:choose>
                <c:when test="${sessionScope.role == 'admin'}">
                    <span class="admin-badge"><i class="fa-solid fa-key"></i> Адміністратор</span>
                    <a href="add-book" class="btn-add"><i class="fa-solid fa-plus"></i> Додати книгу</a>
                    <a href="logout" class="btn-logout"><i class="fa-solid fa-right-from-bracket"></i> Вийти</a>
                </c:when>
                <c:when test="${sessionScope.role == 'reader'}">
                    <span class="reader-badge"><i class="fa-solid fa-user"></i> Читач</span>
                    <a href="logout" class="btn-logout"><i class="fa-solid fa-right-from-bracket"></i> Вийти</a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="btn-login"><i class="fa-solid fa-lock"></i> Увійти</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%-- flash зникає через 4 сек (js внизу) --%>
    <c:if test="${not empty sessionScope.flashMessage}">
        <div class="flash-message flash-${sessionScope.flashType}" id="flashMsg">
            <i class="fa-solid ${sessionScope.flashType == 'success' ? 'fa-circle-check' : sessionScope.flashType == 'danger' ? 'fa-circle-xmark' : 'fa-circle-info'}"></i>
                ${sessionScope.flashMessage}
        </div>
        <c:remove var="flashMessage" scope="session"/>
        <c:remove var="flashType" scope="session"/>
    </c:if>

    <form action="books" method="GET" class="search-bar">
        <input type="text" name="query" placeholder="Пошук за назвою, автором або ключовими словами…" value="${param.query}">
        <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Знайти</button>
    </form>

    <c:if test="${not empty param.query}">
        <a href="books" class="breadcrumb" style="margin-bottom: 15px; display: inline-flex;">
            <i class="fa-solid fa-arrow-left"></i> Назад до каталогу
        </a>
    </c:if>

    <div class="results-info">
        <c:choose>
            <c:when test="${not empty param.query}">
                Знайдено: <strong>${books.size()}</strong> книг за запитом «${param.query}»
            </c:when>
            <c:otherwise>
                Всього у фонді: <strong>${books.size()}</strong> видань
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${empty books}">
        <div class="empty-state">
            <i class="fa-solid fa-magnifying-glass"></i>
            <h3>Нічого не знайдено</h3>
            <p>Спробуйте змінити пошуковий запит або <a href="books" style="color: var(--accent-bright);">переглянути весь каталог</a></p>
        </div>
    </c:if>

    <div class="books-grid">
        <c:forEach var="book" items="${books}">
            <div class="book-card">
                    <%-- якщо зображення не вантажиться — показуємо заглушку --%>
                <img src="${book.imageUrl}" alt="${book.title}" class="book-cover-img"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <div class="fallback-cover" style="display:none;"><i class="fa-solid fa-book-journal-whills"></i></div>

                <div class="book-info-persistent">
                    <h3>${book.title}</h3>
                    <span class="author">${book.author}</span>
                </div>

                <div class="book-overlay">
                    <h3>${book.title}</h3>
                    <p><strong>Автор:</strong> ${book.author}</p>
                    <p><strong>Рік:</strong> ${book.publicationYear}</p>

                        <%-- максимум 2 теги, далі "..." --%>
                    <div class="keywords-box">
                        <c:if test="${not empty book.keywords}">
                            <c:forEach var="tag" items="${book.keywords.split(',')}" varStatus="status">
                                <c:choose>
                                    <c:when test="${status.index < 2}">
                                        <span class="keyword-tag">#${tag.trim()}</span>
                                    </c:when>
                                    <c:when test="${status.index == 2}">
                                        <span style="color: var(--ink-muted); font-size: 1em; align-self: flex-end; margin-bottom: 2px; margin-left: 2px;">...</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </c:if>
                    </div>

                    <a href="book?id=${book.id}" class="overlay-btn">
                        <i class="fa-solid fa-circle-info"></i> Детальніше
                    </a>

                    <c:if test="${sessionScope.role == 'admin'}">
                        <div class="overlay-admin-controls">
                            <a href="edit-book?id=${book.id}&from=catalog" class="action-btn" title="Редагувати">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                            <a href="javascript:void(0)" class="action-btn danger" title="Видалити"
                               onclick="openDeleteModal('${book.id}', '${book.title}')">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal-content" style="border-color: #ff6b6b; box-shadow: 0 0 30px rgba(255, 107, 107, 0.15);">
        <div class="modal-icon" style="color: #ff6b6b;">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
        <h3 class="modal-title">Видалити книгу?</h3>
        <p class="modal-text">Ви впевнені, що хочете видалити книгу «<span id="delTitle"></span>»?</p>
        <div style="display: flex; gap: 12px; margin-top: 20px;">
            <button class="btn-ghost" onclick="closeDel()" style="flex: 1; justify-content: center;">Скасувати</button>
            <a href="#" id="confirmDel" class="btn-primary" style="flex: 1; background: #ff6b6b; border-color: #ff6b6b; justify-content: center;">Видалити</a>
        </div>
    </div>
</div>

<script>
    // flash зникає через 4 секунди
    const flash = document.getElementById('flashMsg');
    if (flash) {
        setTimeout(() => {
            flash.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            flash.style.opacity = '0';
            flash.style.transform = 'translateY(-8px)';
            setTimeout(() => flash.remove(), 600);
        }, 4000);
    }

    function openDeleteModal(id, title) {
        document.getElementById('delTitle').innerText = title;
        document.getElementById('confirmDel').href = 'delete-book?id=' + id + '&title=' + encodeURIComponent(title);
        document.getElementById('deleteModal').classList.add('active');
    }

    function closeDel() {
        document.getElementById('deleteModal').classList.remove('active');
    }

    // закрити модалку кліком на фон
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) closeDel();
    });
</script>
</body>
</html>