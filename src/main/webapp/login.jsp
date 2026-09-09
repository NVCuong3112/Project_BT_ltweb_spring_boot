<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đăng nhập tài khoản - Library Manager">
    <title>Đăng nhập — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>

    <!-- Login Section -->
    <div class="login-page">
        <div class="login-card">
            <div class="login-header">
                <div class="login-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                </div>
                <h2>Đăng nhập</h2>
                <p>Truy cập tài khoản hệ thống của bạn</p>
            </div>

            <div class="login-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        <span>${success}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate>
                    <div class="form-group mb-3">
                        <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="required text-danger">*</span></label>
                        <input type="text" id="username" name="username" 
                               class="form-control ${not empty errors['username'] ? 'is-invalid' : ''}"
                               placeholder="Nhập username" required
                               value="${not empty savedUsername ? savedUsername : (not empty username ? username : '')}">
                        <div class="invalid-feedback">
                            ${not empty errors['username'] ? errors['username'] : 'Vui lòng nhập tên đăng nhập!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <label for="password" class="form-label fw-semibold mb-0">Mật khẩu <span class="required text-danger">*</span></label>
                            <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: 0.85rem; color: #6366f1; text-decoration: none; font-weight: 500;">Quên mật khẩu?</a>
                        </div>
                        <input type="password" id="password" name="password" 
                               class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}"
                               placeholder="Nhập mật khẩu" required>
                        <div class="invalid-feedback">
                            ${not empty errors['password'] ? errors['password'] : 'Vui lòng nhập mật khẩu!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-check">
                            <input type="checkbox" name="rememberMe" class="form-check-input" ${not empty savedUsername ? 'checked' : ''}>
                            <span class="form-check-label">Ghi nhớ đăng nhập (Remember me)</span>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg w-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                            <polyline points="10 17 15 12 10 7"></polyline>
                            <line x1="15" y1="12" x2="3" y2="12"></line>
                        </svg>
                        <span>Đăng nhập ngay</span>
                    </button>
                </form>

                <div class="login-footer">
                    <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
