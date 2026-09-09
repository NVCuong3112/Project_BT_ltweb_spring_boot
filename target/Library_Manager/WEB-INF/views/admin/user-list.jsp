<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quản lý Người dùng — Library Manager">
    <title>Người dùng — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 48px;">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1>Quản lý Người dùng</h1>
                    <p>Theo dõi tài khoản thành viên, phân quyền vai trò và quản lý trạng thái kích hoạt</p>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="margin-bottom: 20px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Search Form Card (Form tìm kiếm theo yêu cầu ?keyword=) -->
            <div class="card" style="margin-bottom: 24px; padding: 18px 24px;">
                <form action="${pageContext.request.contextPath}/admin/users" method="get" style="display: flex; gap: 12px; align-items: center; width: 100%;">
                    <div style="flex: 1;">
                        <input type="text" name="keyword" value="${keyword}" class="form-control"
                               placeholder="Tìm kiếm theo username hoặc email..."
                               style="width: 100%; padding: 10px 16px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px;">
                    </div>
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px; display: inline-flex; align-items: center; gap: 6px;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <span>Tìm kiếm</span>
                    </button>
                    <c:if test="${not empty keyword}">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="padding: 10px 16px;">
                            <span>Xóa tìm</span>
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Users Table Card -->
            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">ID</th>
                                <th style="width: 200px;">Tài khoản</th>
                                <th>Họ và tên & Email</th>
                                <th style="width: 130px; text-align: center;">Vai trò</th>
                                <th style="width: 150px; text-align: center;">Trạng thái</th>
                                <th style="width: 210px; text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td><span style="font-weight: 700; color: var(--primary);">#${u.id}</span></td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 10px;">
                                            <div style="width: 36px; height: 36px; border-radius: 50%; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; flex-shrink: 0;">
                                                <c:choose>
                                                    <c:when test="${not empty u.avatar}">
                                                        <img src="${u.avatar}" alt="${u.username}" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${u.username.substring(0, 1).toUpperCase()}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div style="font-weight: 600; color: #0f172a;">${u.username}</div>
                                                <div style="font-size: 12px; color: var(--text-secondary);">${u.phone != null ? u.phone : 'Chưa có SĐT'}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 500; color: #1e293b;">${u.fullName != null ? u.fullName : u.username}</div>
                                        <div style="font-size: 13px; color: var(--text-secondary);">${u.email}</div>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${u.role eq 'ADMIN'}">
                                                <span style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: #fee2e2; color: #b91c1c;">
                                                    Quản trị viên
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: #e0f2fe; color: #0369a1;">
                                                    Thành viên
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${u.status == 1}">
                                                <span style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: #dcfce7; color: #15803d;">
                                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: #16a34a;"></span>
                                                    Đã kích hoạt
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: #fef9c3; color: #a16207;">
                                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: #ca8a04;"></span>
                                                    Chưa kích hoạt
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions" style="justify-content: center; gap: 6px;">
                                            <a href="${pageContext.request.contextPath}/admin/users/detail?id=${u.id}"
                                               class="btn btn-secondary btn-sm" title="Xem chi tiết">
                                                <span>Xem</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}"
                                               class="btn btn-warning btn-sm" title="Sửa vai trò / trạng thái">
                                                <span>Sửa</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/users/delete?id=${u.id}"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản ${u.username}?');"
                                               class="btn btn-danger btn-sm" title="Xóa tài khoản">
                                                <span>Xóa</span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 32px; color: var(--text-secondary);">
                                        <c:choose>
                                            <c:when test="${not empty keyword}">
                                                Không tìm thấy người dùng nào phù hợp với từ khóa "<strong>${keyword}</strong>".
                                            </c:when>
                                            <c:otherwise>
                                                Hiện tại chưa có người dùng nào trong hệ thống.
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
