<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Đăng nhập vào Library Manager">
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
                <p>Nhập thông tin tài khoản để truy cập hệ thống</p>
            </div>

            <div class="login-body">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/cookie-login" method="post">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập <span class="required">*</span></label>
                        <input type="text" id="username" name="username" class="form-control"
                               placeholder="Ví dụ: admin"
                               required value="${not empty savedUsername ? savedUsername : ''}">
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu <span class="required">*</span></label>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Nhập mật khẩu"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-check">
                            <input type="checkbox" name="rememberMe"
                                   ${not empty savedUsername ? 'checked' : ''}>
                            <span>Ghi nhớ đăng nhập trên thiết bị này</span>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                            <polyline points="10 17 15 12 10 7"></polyline>
                            <line x1="15" y1="12" x2="3" y2="12"></line>
                        </svg>
                        <span>Đăng nhập ngay</span>
                    </button>
                </form>

                <div class="text-center mt-3">
                    <span class="text-muted" style="font-size: 0.85rem;">Tài khoản mặc định: <code>admin</code> / <code>123456</code></span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
