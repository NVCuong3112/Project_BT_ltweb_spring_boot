<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Chi tiết người dùng — Library Manager">
    <title>Hồ sơ người dùng #${user.id} — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="max-width: 680px; padding-top: 36px; padding-bottom: 48px;">
            <div class="page-header">
                <div>
                    <h1>Chi tiết Người dùng</h1>
                    <p>Xem thông tin chi tiết hồ sơ tài khoản thành viên</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    <span>Quay lại danh sách</span>
                </a>
            </div>

            <div class="card" style="padding: 32px;">
                <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 28px; padding-bottom: 24px; border-bottom: 1px solid #e2e8f0;">
                    <div style="width: 72px; height: 72px; border-radius: 50%; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-size: 28px; font-weight: 700;">
                        <c:choose>
                            <c:when test="${not empty user.avatar}">
                                <img src="${user.avatar}" alt="${user.username}" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                ${user.username.substring(0, 1).toUpperCase()}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <h2 style="margin: 0 0 6px 0; font-size: 22px; font-weight: 700; color: #0f172a;">${user.fullName != null ? user.fullName : user.username}</h2>
                        <div style="display: flex; gap: 8px;">
                            <span style="display: inline-block; padding: 2px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: ${user.role eq 'ADMIN' ? '#fee2e2' : '#e0f2fe'}; color: ${user.role eq 'ADMIN' ? '#b91c1c' : '#0369a1'};">
                                ${user.role}
                            </span>
                            <span style="display: inline-block; padding: 2px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; background: ${user.status == 1 ? '#dcfce7' : '#fef9c3'}; color: ${user.status == 1 ? '#15803d' : '#a16207'};">
                                ${user.status == 1 ? 'Đã kích hoạt' : 'Chưa kích hoạt'}
                            </span>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div>
                        <label style="font-size: 13px; color: var(--text-secondary); display: block; margin-bottom: 4px;">Mã người dùng</label>
                        <div style="font-weight: 600; color: #0f172a;">#${user.id}</div>
                    </div>
                    <div>
                        <label style="font-size: 13px; color: var(--text-secondary); display: block; margin-bottom: 4px;">Tên đăng nhập</label>
                        <div style="font-weight: 600; color: #0f172a;">${user.username}</div>
                    </div>
                    <div>
                        <label style="font-size: 13px; color: var(--text-secondary); display: block; margin-bottom: 4px;">Email</label>
                        <div style="font-weight: 600; color: #0f172a;">${user.email}</div>
                    </div>
                    <div>
                        <label style="font-size: 13px; color: var(--text-secondary); display: block; margin-bottom: 4px;">Số điện thoại</label>
                        <div style="font-weight: 600; color: #0f172a;">${user.phone != null ? user.phone : 'Chưa cập nhật'}</div>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; margin-top: 32px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.id}" class="btn btn-warning" style="display: inline-flex; align-items: center; gap: 6px;">
                        <span>Chỉnh sửa tài khoản</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users/delete?id=${user.id}"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?');"
                       class="btn btn-danger" style="display: inline-flex; align-items: center; gap: 6px;">
                        <span>Xóa người dùng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="margin-left: auto;">
                        <span>Quay lại</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
