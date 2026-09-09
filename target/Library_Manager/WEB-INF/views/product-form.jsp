<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.example.webapp.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
    boolean isEdit = request.getAttribute("product") != null;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="<%= isEdit ? "Chỉnh sửa" : "Thêm" %> sản phẩm — Library Manager">
    <title><%= isEdit ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm mới" %> — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="max-width: 760px; padding-top: 36px; padding-bottom: 48px;">
            <div class="page-header">
                <div>
                    <h1><%= isEdit ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm mới" %></h1>
                    <p><%= isEdit ? "Cập nhật thông tin chi tiết và hình ảnh của sản phẩm" : "Nhập thông tin sản phẩm và tải lên ảnh đại diện" %></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary btn-sm">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    <span>Quay lại</span>
                </a>
            </div>

            <div class="card">
                <div class="card-body" style="padding: 32px;">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" x2="12" y1="8" y2="12"></line><line x1="12" x2="12.01" y1="16" y2="16"></line></svg>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/${product != null ? 'edit-product' : 'add-product'}"
                          method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        
                        <c:if test="${product != null}">
                            <input type="hidden" name="id" value="${product.productId}">
                        </c:if>

                        <div class="form-group mb-3">
                            <label for="productName" class="form-label fw-semibold">Tên sản phẩm <span class="required text-danger">*</span></label>
                            <input type="text" id="productName" name="productName" 
                                   class="form-control ${not empty errors['productName'] ? 'is-invalid' : ''}"
                                   placeholder="Ví dụ: Giáo trình Lập trình Web với Java"
                                   value="${product != null ? product.productName : (param.productName != null ? param.productName : '')}" 
                                   required maxlength="200">
                            <div class="invalid-feedback">
                                ${not empty errors['productName'] ? errors['productName'] : 'Tên sản phẩm không được để trống!'}
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6 form-group">
                                <label for="price" class="form-label fw-semibold">Đơn giá (VNĐ) <span class="required text-danger">*</span></label>
                                <input type="number" id="price" name="price" 
                                       class="form-control ${not empty errors['price'] ? 'is-invalid' : ''}"
                                       placeholder="Ví dụ: 150000" min="1000" step="1000"
                                       value="${product != null ? product.price : (param.price != null ? param.price : '1000')}" required>
                                <div class="invalid-feedback">
                                    ${not empty errors['price'] ? errors['price'] : 'Đơn giá phải lớn hơn 0 VNĐ!'}
                                </div>
                            </div>

                            <div class="col-md-6 form-group">
                                <label for="quantity" class="form-label fw-semibold">Số lượng tồn kho <span class="required text-danger">*</span></label>
                                <input type="number" id="quantity" name="quantity" 
                                       class="form-control ${not empty errors['quantity'] ? 'is-invalid' : ''}"
                                       placeholder="Ví dụ: 100" min="0"
                                       value="${product != null ? product.quantity : (param.quantity != null ? param.quantity : '10')}" required>
                                <div class="invalid-feedback">
                                    ${not empty errors['quantity'] ? errors['quantity'] : 'Số lượng tồn kho không được âm!'}
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6 form-group">
                                <label for="categoryId" class="form-label fw-semibold">Danh mục sản phẩm <span class="required text-danger">*</span></label>
                                <select id="categoryId" name="categoryId" 
                                        class="form-select ${not empty errors['categoryId'] ? 'is-invalid' : ''}" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}" ${(product != null && product.category != null && product.category.id == c.id) || param.categoryId == c.id ? 'selected' : ''}>
                                            ${c.name}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    ${not empty errors['categoryId'] ? errors['categoryId'] : 'Vui lòng chọn danh mục sản phẩm!'}
                                </div>
                            </div>

                            <div class="col-md-6 form-group">
                                <label for="status" class="form-label fw-semibold">Trạng thái kinh doanh</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="1" ${product == null || product.status == 1 ? 'selected' : ''}>Hiển thị bán</option>
                                    <option value="0" ${product != null && product.status == 0 ? 'selected' : ''}>Tạm ẩn khỏi shop</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group mb-3">
                            <label for="image" class="form-label fw-semibold">Hình ảnh đại diện</label>
                            <input type="file" id="image" name="image" class="form-control" accept="image/*">
                            <c:if test="${product != null && not empty product.image}">
                                <div style="margin-top: 10px; display: flex; align-items: center; gap: 12px; background: #f8fafc; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0;">
                                    <img src="${pageContext.request.contextPath}/uploads/${product.image}"
                                         alt="${product.productName}"
                                         style="width: 60px; height: 60px; object-fit: cover; border-radius: 6px;">
                                    <span style="font-size: 13px; color: #64748b;">
                                        Ảnh hiện tại: <b>${product.image}</b><br>
                                        <i>(Để trống trường file ở trên nếu muốn giữ nguyên ảnh này)</i>
                                    </span>
                                </div>
                            </c:if>
                        </div>

                        <div class="form-group mb-3">
                            <label for="description" class="form-label fw-semibold">Mô tả chi tiết sản phẩm</label>
                            <textarea id="description" name="description" class="form-control"
                                      placeholder="Nhập thông tin giới thiệu, nội dung chính, tác giả..."
                                      rows="4">${product != null ? product.description : (param.description != null ? param.description : '')}</textarea>
                        </div>

                        <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px;">
                            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Hủy bỏ</a>
                            <button type="submit" class="btn btn-primary">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                    <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                    <polyline points="7 3 7 8 15 8"></polyline>
                                </svg>
                                <span>${product != null ? 'Cập nhật sản phẩm' : 'Lưu sản phẩm'}</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
