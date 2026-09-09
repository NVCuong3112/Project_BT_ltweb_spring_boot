<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Kích hoạt tài khoản - Library Manager">
    <title>Kích hoạt tài khoản — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="login-page">
        <div class="login-card" style="max-width: 480px;">
            <div class="login-header">
                <div class="login-icon" style="background: #fef3c7; color: #d97706;">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                    </svg>
                </div>
                <h2>Kích hoạt tài khoản</h2>
                <p>Nhập mã OTP 6 số đã được gửi tới email của bạn (hiệu lực 5 phút)</p>
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

                <form action="${pageContext.request.contextPath}/activate-account" method="post" class="needs-validation" novalidate>
                    <div class="form-group mb-3">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email <span class="required text-danger">*</span></label>
                        <input type="email" id="email" name="email" 
                               class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}"
                               placeholder="email@example.com" required 
                               value="${param.email != null ? param.email : email}">
                        <div class="invalid-feedback">
                            ${not empty errors['email'] ? errors['email'] : 'Vui lòng nhập email hợp lệ!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="otpCode" class="form-label fw-semibold">Mã xác thực OTP (6 chữ số) <span class="required text-danger">*</span></label>
                        <input type="text" id="otpCode" name="otpCode" 
                               class="form-control ${not empty errors['otpCode'] ? 'is-invalid' : ''}"
                               placeholder="Ví dụ: 123456" required pattern="^[0-9]{6}$" maxlength="6" minlength="6"
                               style="font-size: 1.25rem; letter-spacing: 4px; text-align: center; font-weight: 700;">
                        <div class="invalid-feedback">
                            ${not empty errors['otpCode'] ? errors['otpCode'] : 'Mã OTP phải gồm đúng 6 chữ số!'}
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg w-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span>Xác nhận kích hoạt</span>
                    </button>
                </form>

                <div class="text-center mt-3" style="margin-top: 24px; font-size: 0.9rem; color: #64748b;">
                    Chưa nhận được mã OTP? 
                    <a href="${pageContext.request.contextPath}/resend-otp?email=${param.email != null ? param.email : email}&type=REGISTER"
                       style="color: #6366f1; font-weight: 600; text-decoration: none;">Gửi lại mã OTP</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
