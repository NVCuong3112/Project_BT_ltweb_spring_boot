<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    boolean isEdit = request.getAttribute("category") != null
            && ((com.example.webapp.model.Category) request.getAttribute("category")).getId() > 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<%= isEdit ? "Chỉnh sửa" : "Thêm" %> danh mục — Library Manager">
    <title><%= isEdit ? "Chỉnh sửa danh mục" : "Thêm danh mục mới" %> — Library Manager</title>
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
                    <h1><%= isEdit ? "Chỉnh sửa danh mục" : "Thêm danh mục mới" %></h1>
                    <p><%= isEdit ? "Cập nhật thông tin chi tiết của danh mục hiện có" : "Tạo danh mục mới để phân loại và quản lý tài liệu" %></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary btn-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    <span>Quay lại</span>
                </a>
            </div>

            <div class="card">
                <div class="card-body" style="padding: 32px;">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" style="margin-bottom: 20px;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/categories/${category != null && category.id > 0 ? 'edit' : 'add'}" 
                          method="post" class="needs-validation" novalidate>
                        <c:if test="${category != null && category.id > 0}">
                            <input type="hidden" name="id" value="${category.id}">
                        </c:if>

                        <div class="form-group mb-3" style="margin-bottom: 18px;">
                            <label for="name" class="form-label fw-semibold" style="display: block; margin-bottom: 6px; font-weight: 600;">Tên danh mục <span class="required text-danger" style="color: #ef4444;">*</span></label>
                            <input type="text" id="name" name="name" 
                                   class="form-control ${not empty errors['name'] ? 'is-invalid' : ''}"
                                   placeholder="Ví dụ: Công nghệ thông tin, Kinh tế học..."
                                   value="${category != null ? category.name : ''}" required maxlength="100"
                                   style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px;">
                            <c:if test="${not empty errors['name']}">
                                <div class="invalid-feedback" style="color: #ef4444; font-size: 13px; margin-top: 4px;">
                                    ${errors['name']}
                                </div>
                            </c:if>
                        </div>

                        <div class="form-group mb-3" style="margin-bottom: 24px;">
                            <label for="description" class="form-label fw-semibold" style="display: block; margin-bottom: 6px; font-weight: 600;">Mô tả chi tiết</label>
                            <textarea id="description" name="description" 
                                      class="form-control ${not empty errors['description'] ? 'is-invalid' : ''}"
                                      placeholder="Mô tả phạm vi, chủ đề hoặc đặc điểm của danh mục này (tùy chọn)"
                                      rows="4" maxlength="255"
                                      style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px;">${category != null ? category.description : ''}</textarea>
                            <c:if test="${not empty errors['description']}">
                                <div class="invalid-feedback" style="color: #ef4444; font-size: 13px; margin-top: 4px;">
                                    ${errors['description']}
                                </div>
                            </c:if>
                        </div>

                        <div class="form-actions mt-4 d-flex gap-2" style="display: flex; gap: 12px;">
                            <button type="submit" class="btn btn-primary" style="padding: 10px 24px; display: inline-flex; align-items: center; gap: 6px;">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span><%= isEdit ? "Lưu thay đổi" : "Tạo danh mục" %></span>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary" style="padding: 10px 20px;">Hủy bỏ</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
