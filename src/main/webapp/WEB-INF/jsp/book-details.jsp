<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>${book.title} — Бібліотека</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-dark.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="container details-page-container">

    <%-- якщо був пошук — повертаємось до результатів --%>
    <c:set var="backUrl" value="books" />
    <c:if test="${not empty sessionScope.lastQuery}">
        <c:url var="backUrl" value="books">
            <c:param name="query" value="${sessionScope.lastQuery}" />
        </c:url>
    </c:if>

    <a href="${backUrl}" class="breadcrumb">
        <i class="fa-solid fa-arrow-left"></i>
        <c:choose>
            <c:when test="${not empty sessionScope.lastQuery}">Назад до пошуку</c:when>
            <c:otherwise>Назад до каталогу</c:otherwise>
        </c:choose>
    </a>

    <c:if test="${not empty sessionScope.flashMessage}">
        <div class="flash-message flash-${sessionScope.flashType}" id="flashMsg">
            <i class="fa-solid ${sessionScope.flashType == 'success' ? 'fa-circle-check' : sessionScope.flashType == 'danger' ? 'fa-circle-xmark' : 'fa-circle-info'}"></i>
                ${sessionScope.flashMessage}
        </div>
        <c:remove var="flashMessage" scope="session"/>
        <c:remove var="flashType" scope="session"/>
    </c:if>

    <div class="book-details-card">
        <div class="details-cover-box">
            <img src="${book.imageUrl}" alt="${book.title}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="fallback-cover" style="display:none;"><i class="fa-solid fa-book-journal-whills"></i></div>

            <%-- гість бачить кнопку входу замість читати --%>
            <c:choose>
                <c:when test="${sessionScope.role == 'admin' || sessionScope.role == 'reader'}">
                    <a href="#" class="btn-primary btn-read" onclick="openReadModal(); return false;" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-book-open"></i> Читати
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="btn-primary" style="width: 100%; justify-content: center;">
                        <i class="fa-solid fa-lock"></i> Увійти щоб читати
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="details-info-box">
            <div class="details-header">
                <h1>${book.title}</h1>
                <c:if test="${sessionScope.role == 'admin'}">
                    <div class="details-admin-actions">
                        <a href="edit-book?id=${book.id}&from=details" class="action-btn" title="Редагувати"><i class="fa-solid fa-pen-to-square"></i></a>
                        <a href="javascript:void(0)" class="action-btn danger" onclick="openDeleteModal('${book.id}', '${book.title}')" title="Видалити"><i class="fa-solid fa-trash-can"></i></a>
                    </div>
                </c:if>
            </div>

            <ul class="details-meta-list">
                <li>
                    <span class="meta-icon"><i class="fa-solid fa-user-pen"></i></span>
                    <div>
                        <span class="meta-label">Автор</span>
                        <span class="meta-value">${book.author}</span>
                    </div>
                </li>
                <li>
                    <span class="meta-icon"><i class="fa-solid fa-calendar-days"></i></span>
                    <div>
                        <span class="meta-label">Рік видання</span>
                        <span class="meta-value">${book.publicationYear}</span>
                    </div>
                </li>
                <c:if test="${not empty book.keywords}">
                    <li>
                        <span class="meta-icon"><i class="fa-solid fa-tags"></i></span>
                        <div>
                            <span class="meta-label">Ключові слова</span>
                            <div style="margin-top: 6px; display: flex; flex-wrap: wrap; gap: 6px;">
                                <c:forEach var="tag" items="${book.keywords.split(',')}">
                                    <span class="keyword-tag">#${tag.trim()}</span>
                                </c:forEach>
                            </div>
                        </div>
                    </li>
                </c:if>
            </ul>

            <div class="details-desc">
                <div class="details-desc-title">
                    <i class="fa-solid fa-feather-pointed" style="color: var(--gold);"></i>
                    Про книгу
                </div>
                <p>${book.description}</p>
            </div>
        </div>
    </div>
</div>

<div class="modal-overlay" id="readModal">
    <div class="modal-content">
        <div class="modal-icon"><i class="fa-solid fa-book-open-reader"></i></div>
        <h3 class="modal-title">Функція недоступна</h3>
        <p class="modal-text">На жаль, можливість читати онлайн ще в розробці. Повертайтеся згодом!</p>
        <button class="btn-primary" onclick="closeReadModal()" style="width: 100%; justify-content: center;">Зрозуміло</button>
    </div>
</div>

<div class="modal-overlay" id="deleteModal">
    <div class="modal-content" style="border-color: #ff6b6b; box-shadow: 0 0 30px rgba(255, 107, 107, 0.15);">
        <div class="modal-icon" style="color: #ff6b6b;"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <h3 class="modal-title">Видалити книгу?</h3>
        <p class="modal-text">Ви впевнені, що хочете видалити книгу «<span id="delTitle"></span>»?</p>
        <div style="display: flex; gap: 12px; margin-top: 20px;">
            <button class="btn-ghost" onclick="closeDel()" style="flex: 1; justify-content: center;">Скасувати</button>
            <a href="#" id="confirmDel" class="btn-primary" style="flex: 1; background: #ff6b6b; border-color: #ff6b6b; justify-content: center;">Видалити</a>
        </div>
    </div>
</div>

<script>
    const flash = document.getElementById('flashMsg');
    if (flash) {
        setTimeout(() => {
            flash.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            flash.style.opacity = '0';
            flash.style.transform = 'translateY(-8px)';
            setTimeout(() => flash.remove(), 600);
        }, 4000);
    }

    function openReadModal() { document.getElementById('readModal').classList.add('active'); }
    function closeReadModal() { document.getElementById('readModal').classList.remove('active'); }

    function openDeleteModal(id, title) {
        document.getElementById('delTitle').innerText = title;
        document.getElementById('confirmDel').href = 'delete-book?id=' + id + '&title=' + encodeURIComponent(title);
        document.getElementById('deleteModal').classList.add('active');
    }
    function closeDel() { document.getElementById('deleteModal').classList.remove('active'); }

    document.querySelectorAll('.modal-overlay').forEach(function(modal) {
        modal.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('active'); });
    });
</script>
</body>
</html>