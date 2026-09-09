<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đặt lại mật khẩu - Library Manager">
    <title>Đặt lại mật khẩu — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="login-page">
        <div class="login-card" style="max-width: 480px;">
            <div class="login-header">
                <div class="login-icon" style="background: #e0e7ff; color: #4338ca;">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                </div>
                <h2>Đặt lại mật khẩu</h2>
                <p>Nhập mã OTP và mật khẩu mới cho tài khoản của bạn</p>
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

                <form action="${pageContext.request.contextPath}/reset-password" method="post" class="needs-validation" novalidate>
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

                    <div class="form-group mb-3">
                        <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới <span class="required text-danger">*</span></label>
                        <input type="password" id="newPassword" name="newPassword" 
                               class="form-control ${not empty errors['newPassword'] ? 'is-invalid' : ''}"
                               placeholder="Tối thiểu 6 ký tự" required minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['newPassword'] ? errors['newPassword'] : 'Mật khẩu mới phải từ 6 ký tự trở lên!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu mới <span class="required text-danger">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               class="form-control ${not empty errors['confirmPassword'] ? 'is-invalid' : ''}"
                               placeholder="Nhập lại mật khẩu mới" required minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['confirmPassword'] ? errors['confirmPassword'] : 'Vui lòng xác nhận lại mật khẩu!'}
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg w-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span>Xác nhận đổi mật khẩu</span>
                    </button>
                </form>

                <div class="text-center mt-3" style="margin-top: 24px; font-size: 0.9rem; color: #64748b;">
                    Chưa nhận được mã OTP? 
                    <a href="${pageContext.request.contextPath}/resend-otp?email=${param.email != null ? param.email : email}&type=FORGOT_PASSWORD"
                       style="color: #6366f1; font-weight: 600; text-decoration: none;">Gửi lại mã OTP</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
