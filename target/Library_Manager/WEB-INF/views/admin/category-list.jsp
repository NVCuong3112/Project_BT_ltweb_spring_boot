<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Danh sách danh mục — Library Manager">
    <title>Danh mục — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 48px;">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1>Quản lý Danh mục</h1>
                    <p>Theo dõi, phân loại và tổ chức hệ thống tài liệu thư viện</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-primary">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Thêm danh mục mới</span>
                </a>
            </div>

            <!-- Alerts -->
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

            <!-- Search Form Card (Thanh tìm kiếm theo yêu cầu) -->
            <div class="card" style="margin-bottom: 24px; padding: 18px 24px;">
                <form action="${pageContext.request.contextPath}/admin/categories" method="get" style="display: flex; gap: 12px; align-items: center; width: 100%;">
                    <div style="flex: 1;">
                        <input type="text" name="keyword" value="${keyword}" class="form-control"
                               placeholder="Nhập tên danh mục cần tìm..."
                               style="width: 100%; padding: 10px 16px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px;">
                    </div>
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px; display: inline-flex; align-items: center; gap: 6px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <span>Tìm kiếm</span>
                    </button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary" style="padding: 10px 16px;">
                            <span>Xóa tìm</span>
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Category Table Card -->
            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 80px;">Mã số</th>
                                <th style="width: 280px;">Tên danh mục</th>
                                <th>Mô tả chi tiết</th>
                                <th style="width: 170px; text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cat" items="${categories}">
                                <tr>
                                    <td><span style="font-weight: 700; color: var(--primary);">#${cat.id}</span></td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <div style="width: 32px; height: 32px; border-radius: 8px; background: #ede9fe; color: #6366f1; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"></path>
                                                </svg>
                                            </div>
                                            <span style="font-weight: 600; color: #0f172a;">${cat.name}</span>
                                        </div>
                                    </td>
                                    <td style="color: var(--text-secondary);">${cat.description}</td>
                                    <td>
                                        <div class="actions" style="justify-content: center;">
                                            <a href="${pageContext.request.contextPath}/admin/categories/edit?id=${cat.id}"
                                               class="btn btn-warning btn-sm">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"></path></svg>
                                                <span>Sửa</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/categories/delete?id=${cat.id}"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');"
                                               class="btn btn-danger btn-sm">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                <span>Xóa</span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty categories}">
                                <tr class="empty-row">
                                    <td colspan="4" style="text-align: center; padding: 32px; color: var(--text-secondary);">
                                        <c:choose>
                                            <c:when test="${not empty keyword}">
                                                Không tìm thấy danh mục nào phù hợp với từ khóa "<strong>${keyword}</strong>".
                                            </c:when>
                                            <c:otherwise>
                                                Hiện tại chưa có danh mục nào trong hệ thống. Hãy bấm nút "Thêm danh mục mới" ở trên để bắt đầu!
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
