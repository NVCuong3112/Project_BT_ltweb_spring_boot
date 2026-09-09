<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đăng ký tài khoản mới - Library Manager">
    <title>Đăng ký tài khoản — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="login-page">
        <div class="login-card" style="max-width: 500px;">
            <div class="login-header">
                <div class="login-icon" style="background: #e0e7ff; color: #4338ca;">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <line x1="19" y1="8" x2="19" y2="14"></line>
                        <line x1="22" y1="11" x2="16" y2="11"></line>
                    </svg>
                </div>
                <h2>Tạo tài khoản mới</h2>
                <p>Nhập thông tin để nhận mã kích hoạt OTP qua email</p>
            </div>

            <div class="login-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                    <div class="form-group mb-3">
                        <label for="fullName" class="form-label fw-semibold">Họ và tên <span class="required text-danger">*</span></label>
                        <input type="text" id="fullName" name="fullName" 
                               class="form-control ${not empty errors['fullName'] ? 'is-invalid' : ''}"
                               placeholder="Ví dụ: Nguyễn Văn A" required 
                               value="${not empty fullName ? fullName : ''}">
                        <div class="invalid-feedback">
                            ${not empty errors['fullName'] ? errors['fullName'] : 'Vui lòng nhập họ và tên!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="username" class="form-label fw-semibold">Tên đăng nhập (Username) <span class="required text-danger">*</span></label>
                        <input type="text" id="username" name="username" 
                               class="form-control ${not empty errors['username'] ? 'is-invalid' : ''}"
                               placeholder="Ví dụ: nguyenvana (3-50 ký tự)" required 
                               pattern="^[a-zA-Z0-9_]{3,50}$" minlength="3" maxlength="50"
                               value="${not empty username ? username : ''}">
                        <div class="invalid-feedback">
                            ${not empty errors['username'] ? errors['username'] : 'Tên đăng nhập từ 3 - 50 ký tự (chữ, số, gạch dưới)!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="email" class="form-label fw-semibold">Địa chỉ Email nhận OTP <span class="required text-danger">*</span></label>
                        <input type="email" id="email" name="email" 
                               class="form-control ${not empty errors['email'] ? 'is-invalid' : ''}"
                               placeholder="email@example.com" required 
                               value="${not empty email ? email : ''}">
                        <div class="invalid-feedback">
                            ${not empty errors['email'] ? errors['email'] : 'Vui lòng nhập email hợp lệ (ví dụ: user@example.com)!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="password" class="form-label fw-semibold">Mật khẩu <span class="required text-danger">*</span></label>
                        <input type="password" id="password" name="password" 
                               class="form-control ${not empty errors['password'] ? 'is-invalid' : ''}"
                               placeholder="Tối thiểu 6 ký tự" required minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['password'] ? errors['password'] : 'Mật khẩu phải có ít nhất 6 ký tự!'}
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="required text-danger">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               class="form-control ${not empty errors['confirmPassword'] ? 'is-invalid' : ''}"
                               placeholder="Nhập lại mật khẩu" required minlength="6">
                        <div class="invalid-feedback">
                            ${not empty errors['confirmPassword'] ? errors['confirmPassword'] : 'Vui lòng xác nhận lại mật khẩu!'}
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg w-100">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span>Đăng ký & Nhận mã OTP</span>
                    </button>
                </form>

                <div class="text-center mt-3" style="margin-top: 20px; font-size: 0.9rem; color: #64748b;">
                    Đã có tài khoản? 
                    <a href="${pageContext.request.contextPath}/login" style="color: #6366f1; font-weight: 600; text-decoration: none;">Đăng nhập ngay</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
