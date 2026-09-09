<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.webapp.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/cookie-login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Trang quản trị Library Manager">
    <title>Bảng điều khiển — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 48px;">
            <!-- Welcome -->
            <div class="dashboard-welcome">
                <h1>Xin chào, <%= user.getFullName() != null ? user.getFullName() : user.getUsername() %>!</h1>
                <p>Chào mừng bạn quay trở lại hệ thống quản lý thư viện.</p>
            </div>

            <!-- Quick Actions Grid -->
            <div class="dashboard-grid">
                <a href="${pageContext.request.contextPath}/categories" class="dashboard-card">
                    <div class="card-icon" style="background: #ede9fe; color: #6366f1;">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3>Quản lý danh mục</h3>
                        <p>Xem toàn bộ danh sách, tìm kiếm, chỉnh sửa và theo dõi trạng thái các danh mục tài liệu.</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/add-category" class="dashboard-card">
                    <div class="card-icon" style="background: #d1fae5; color: #059669;">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                    </div>
                    <div>
                        <h3>Thêm danh mục mới</h3>
                        <p>Tạo mới danh mục để phân loại sách, bài báo và tài liệu nghiên cứu dễ dàng hơn.</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/profile" class="dashboard-card">
                    <div class="card-icon" style="background: #fef3c7; color: #d97706;">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <div>
                        <h3>Hồ sơ cá nhân</h3>
                        <p>Xem thông tin tài khoản, cập nhật số điện thoại và tải lên ảnh đại diện cá nhân.</p>
                    </div>
                </a>

                <div class="dashboard-card">
                    <div class="card-icon" style="background: #dbeafe; color: #2563eb;">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </div>
                    <div>
                        <h3>Thông tin phiên làm việc</h3>
                        <p>
                            Tài khoản: <strong><%= user.getUsername() %></strong><br>
                            Phân quyền: <span class="stat-badge purple" style="font-size: 0.75rem;"><%= user.getRole() %></span>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
