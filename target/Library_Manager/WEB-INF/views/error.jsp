<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đã xảy ra lỗi — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <!-- Navbar -->
    <header>
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                <span class="brand-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                        <path d="M6 6h10"></path>
                        <path d="M6 10h10"></path>
                    </svg>
                </span>
                <span class="brand-title">Library Manager</span>
            </a>
            <button class="navbar-toggle" onclick="toggleMenu()" aria-label="Menu">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="4" x2="20" y1="12" y2="12"></line>
                    <line x1="4" x2="20" y1="6" y2="6"></line>
                    <line x1="4" x2="20" y1="18" y2="18"></line>
                </svg>
            </button>
            <div class="navbar-menu">
                <a href="${pageContext.request.contextPath}/" class="nav-link">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/categories" class="nav-link">Danh mục</a>
            </div>
        </nav>
    </header>

    <div class="error-page">
        <div class="error-content">
            <%
                Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
                Throwable exception = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
                String errorTitle = "Đã xảy ra lỗi";
                String errorMessage = "Rất tiếc, đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.";

                if (statusCode != null) {
                    if (statusCode == 404) {
                        errorTitle = "Không tìm thấy trang";
                        errorMessage = "Trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.";
                    } else if (statusCode == 500) {
                        errorTitle = "Lỗi hệ thống";
                        errorMessage = "Đã xảy ra lỗi trong hệ thống. Vui lòng thử lại sau.";
                    } else if (statusCode == 403) {
                        errorTitle = "Không có quyền truy cập";
                        errorMessage = "Bạn không có quyền truy cập vào nội dung trang này.";
                    }
                }
            %>

            <div class="error-code"><%= statusCode != null ? statusCode : "!" %></div>
            <h1><%= errorTitle %></h1>
            <p><%= errorMessage %></p>

            <%
                if (exception != null) {
                    exception.printStackTrace();
            %>
                <div class="error-details">
                    <strong>Thông tin lỗi:</strong> <%= exception.getMessage() != null ? exception.getMessage() : "Lỗi không xác định" %>
                </div>
            <% } %>

            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg>
                <span>Về trang chủ</span>
            </a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-inner">
            <div class="footer-brand">
                <span class="brand-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                    </svg>
                </span>
                <span>Library Manager</span>
            </div>
            <div class="footer-nav">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <a href="${pageContext.request.contextPath}/categories">Danh mục</a>
            </div>
            <div class="footer-status">
                <span class="status-dot"></span>
                <span>Hệ thống hoạt động</span>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Library Manager. All rights reserved.</p>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
