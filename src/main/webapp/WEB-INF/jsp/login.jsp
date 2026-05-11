<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Вхід — Бібліотека</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-dark.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="login-body">

<div style="width: 100%; max-width: 420px;">

    <a href="books" class="breadcrumb" style="margin-bottom: 20px;">
        <i class="fa-solid fa-arrow-left"></i> Назад до каталогу
    </a>

    <div class="login-card">
        <div class="login-logo">
            <span class="login-icon">❧</span>
            <h2>Вхід в систему</h2>
            <p>Адміністратор або читач</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-msg">
                <i class="fa-solid fa-circle-exclamation"></i> ${error}
            </div>
        </c:if>

        <form action="login" method="POST">
            <div class="form-group">
                <label for="username">Логін</label>
                <input type="text" id="username" name="username" placeholder="admin або reader" required>
            </div>
            <div class="form-group" style="margin-top: 16px;">
                <label for="password">Пароль</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-primary" style="width: 100%; justify-content: center; margin-top: 28px; padding: 14px;">
                <i class="fa-solid fa-right-to-bracket"></i> Увійти
            </button>
        </form>

        <div class="login-hints">
            <div class="login-hint-item">
                <i class="fa-solid fa-key"></i>
                <span>Адмін — керування каталогом</span>
            </div>
            <div class="login-hint-item">
                <i class="fa-solid fa-book-open-reader"></i>
                <span>Читач — доступ до читання книг</span>
            </div>
        </div>
    </div>
</div>

</body>
</html>