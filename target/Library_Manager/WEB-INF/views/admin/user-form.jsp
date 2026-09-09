<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Chỉnh sửa Người dùng — Library Manager">
    <title>Chỉnh sửa Người dùng — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="max-width: 680px; padding-top: 36px; padding-bottom: 48px;">
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1>Chỉnh sửa Tài khoản</h1>
                    <p>Cập nhật vai trò phân quyền và trạng thái hoạt động của thành viên</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    <span>Quay lại</span>
                </a>
            </div>

            <div class="card">
                <div class="card-body" style="padding: 32px;">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" style="margin-bottom: 20px;">
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
                        <input type="hidden" name="id" value="${user.id}">

                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Tên đăng nhập</label>
                            <input type="text" class="form-control" value="${user.username}" disabled
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; background: #f1f5f9; color: #64748b;">
                        </div>

                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Email</label>
                            <input type="email" class="form-control" value="${user.email}" disabled
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; background: #f1f5f9; color: #64748b;">
                        </div>

                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label for="fullName" class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Họ và tên</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" value="${user.fullName}"
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px;">
                        </div>

                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label for="phone" class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Số điện thoại</label>
                            <input type="text" id="phone" name="phone" class="form-control" value="${user.phone}"
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px;">
                        </div>

                        <!-- Cập nhật Role -->
                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label for="role" class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Vai trò (Phân quyền) <span style="color: #ef4444;">*</span></label>
                            <select id="role" name="role" class="form-control" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px;">
                                <option value="USER" ${user.role eq 'USER' ? 'selected' : ''}>Thành viên (USER)</option>
                                <option value="ADMIN" ${user.role eq 'ADMIN' ? 'selected' : ''}>Quản trị viên (ADMIN)</option>
                            </select>
                        </div>

                        <!-- Cập nhật Status -->
                        <div class="form-group mb-3" style="margin-bottom: 24px;">
                            <label for="status" class="form-label" style="font-weight: 600; margin-bottom: 6px; display: block;">Trạng thái kích hoạt <span style="color: #ef4444;">*</span></label>
                            <select id="status" name="status" class="form-control" style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px;">
                                <option value="1" ${user.status == 1 ? 'selected' : ''}>Đã kích hoạt (Active)</option>
                                <option value="0" ${user.status == 0 ? 'selected' : ''}>Chưa kích hoạt / Khóa (Inactive)</option>
                            </select>
                        </div>

                        <div class="form-actions" style="display: flex; gap: 12px; margin-top: 24px;">
                            <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">
                                <span>Lưu thay đổi</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="padding: 10px 20px;">Hủy bỏ</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
