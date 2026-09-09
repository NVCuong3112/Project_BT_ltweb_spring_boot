<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.example.webapp.model.User" %>
<%
    User user = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Quản lý Sản phẩm — Library Manager">
    <title>Quản lý Sản phẩm — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
    <script>
        function confirmDelete(id) {
            if (confirm("Bạn có chắc chắn muốn xóa sản phẩm mang mã #" + id + " này không?")) {
                window.location.href = "${pageContext.request.contextPath}/delete-product?id=" + id;
            }
        }
    </script>
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 48px;">
            <!-- Header -->
            <div class="page-header">
                <div>
                    <h1>Quản lý Sản phẩm (Admin)</h1>
                    <p>Thêm mới, tải lên hình ảnh, chỉnh sửa giá và danh mục tài liệu</p>
                </div>
                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                        <span>Xem trang người dùng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/add-product" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Thêm sản phẩm mới</span>
                    </a>
                </div>
            </div>

            <!-- Table Card -->
            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 70px;">Mã</th>
                                <th style="width: 90px; text-align: center;">Hình ảnh</th>
                                <th style="width: 240px;">Tên sản phẩm</th>
                                <th style="width: 140px;">Danh mục</th>
                                <th style="width: 120px;">Đơn giá</th>
                                <th style="width: 90px; text-align: center;">Kho</th>
                                <th style="width: 110px; text-align: center;">Trạng thái</th>
                                <th style="width: 160px; text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td><span style="font-weight: 700; color: var(--primary);">#${p.productId}</span></td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${not empty p.image}">
                                                <img src="${pageContext.request.contextPath}/uploads/${p.image}"
                                                     alt="${p.productName}"
                                                     style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;">
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width: 50px; height: 50px; background: #f1f5f9; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 11px;">
                                                    No img
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600; color: #0f172a;">${p.productName}</div>
                                        <div style="font-size: 12px; color: #64748b; max-width: 240px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            ${p.description}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge" style="background: #e0e7ff; color: #4338ca; padding: 4px 8px; border-radius: 6px; font-size: 12px; font-weight: 600;">
                                            ${p.category != null ? p.category.name : 'Chưa phân loại'}
                                        </span>
                                    </td>
                                    <td style="font-weight: 700; color: #059669;">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/> đ
                                    </td>
                                    <td style="text-align: center; font-weight: 600;">
                                        ${p.quantity}
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${p.status == 1}">
                                                <span style="color: #16a34a; font-size: 12px; font-weight: 600; background: #dcfce7; padding: 3px 8px; border-radius: 6px;">Hiển thị</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #dc2626; font-size: 12px; font-weight: 600; background: #fee2e2; padding: 3px 8px; border-radius: 6px;">Tạm ẩn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions" style="justify-content: center;">
                                            <a href="${pageContext.request.contextPath}/edit-product?id=${p.productId}" class="btn btn-warning btn-sm">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"></path></svg>
                                                <span>Sửa</span>
                                            </a>
                                            <button onclick="confirmDelete(${p.productId})" class="btn btn-danger btn-sm">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                <span>Xóa</span>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty products}">
                                <tr class="empty-row">
                                    <td colspan="8" style="text-align: center; padding: 36px; color: #64748b;">
                                        Chưa có sản phẩm nào trong hệ thống. Hãy bấm nút "Thêm sản phẩm mới" ở trên để bắt đầu!
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
