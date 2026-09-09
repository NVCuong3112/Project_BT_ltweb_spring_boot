<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quên mật khẩu - Library Manager">
    <title>Quên mật khẩu — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="login-page">
        <div class="login-card" style="max-width: 480px;">
            <div class="login-header">
                <div class="login-icon" style="background: #fee2e2; color: #ef4444;">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" x2="12" y1="8" y2="12"></line>
                        <line x1="12" x2="12.01" y1="16" y2="16"></line>
                    </svg>
                </div>
                <h2>Quên mật khẩu?</h2>
                <p>Nhập email tài khoản của bạn để nhận mã xác thực đặt lại mật khẩu</p>
            </div>

            <div class="login-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="needs-validation" novalidate>
                    <div class="form-group mb-3">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email đăng ký <span class="required text-danger">*</span></label>
                        <input type="email" id="email" name="email" 
                               class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}"
                               placeholder="email@example.com" required 
                               value="${not empty email ? email : ''}">
                        <div class="invalid-feedback">
                            ${not empty errors['email'] ? errors['email'] : 'Vui lòng nhập email hợp lệ!'}
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg w-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="22" y1="2" x2="11" y2="13"></line>
                            <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                        </svg>
                        <span>Gửi mã xác thực OTP</span>
                    </button>
                </form>

                <div class="text-center mt-3" style="margin-top: 24px; font-size: 0.9rem; color: #64748b;">
                    Nhớ ra mật khẩu? 
                    <a href="${pageContext.request.contextPath}/login" style="color: #6366f1; font-weight: 600; text-decoration: none;">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
