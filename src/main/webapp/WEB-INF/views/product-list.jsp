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
    <meta name="description" content="Danh sách sản phẩm & tài liệu — Library Manager">
    <title>Cửa hàng Sản phẩm — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
    <style>
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            margin-top: 24px;
        }
        .product-card {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px -8px rgba(0, 0, 0, 0.08);
            border-color: #cbd5e1;
        }
        .product-img-wrap {
            width: 100%;
            height: 200px;
            background: #f8fafc;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .product-card:hover .product-img-wrap img {
            transform: scale(1.04);
        }
        .product-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .product-cat {
            font-size: 12px;
            font-weight: 600;
            color: #6366f1;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .product-title {
            font-size: 17px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        .product-desc {
            font-size: 13px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex-grow: 1;
        }
        .product-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }
        .product-price {
            font-size: 18px;
            font-weight: 800;
            color: #059669;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 40px;
        }
        .page-link-btn {
            padding: 8px 14px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            background: #ffffff;
            color: #475569;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }
        .page-link-btn:hover {
            background: #f1f5f9;
            color: #0f172a;
        }
        .page-link-btn.active {
            background: #6366f1;
            border-color: #6366f1;
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 56px;">
            <!-- Header -->
            <div class="page-header">
                <div>
                    <h1>Kho Tài Liệu & Sản Phẩm</h1>
                    <p>Khám phá toàn bộ sách, giáo trình và tài liệu học tập (Tổng số: ${totalProducts} sản phẩm)</p>
                </div>
            </div>

            <!-- Product Grid -->
            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" class="product-img-wrap">
                            <c:choose>
                                <c:when test="${not empty p.image}">
                                    <img src="${pageContext.request.contextPath}/uploads/${p.image}" alt="${p.productName}">
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #94a3b8; font-size: 14px; font-weight: 500;">Chưa có ảnh</span>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="product-body">
                            <span class="product-cat">${p.category != null ? p.category.name : 'Danh mục'}</span>
                            <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" style="text-decoration: none;">
                                <h3 class="product-title">${p.productName}</h3>
                            </a>
                            <p class="product-desc">${p.description}</p>
                            <div class="product-footer">
                                <span class="product-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/> đ</span>
                                <a href="${pageContext.request.contextPath}/product/detail?id=${p.productId}" class="btn btn-primary btn-sm">
                                    <span>Xem chi tiết</span>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty products}">
                <div style="text-align: center; padding: 60px 20px; background: #ffffff; border-radius: 16px; border: 1px dashed #cbd5e1; margin-top: 24px;">
                    <p style="color: #64748b; font-size: 16px;">Hiện chưa có sản phẩm nào được hiển thị bán.</p>
                </div>
            </c:if>

            <!-- Pagination (Phân trang 6 sản phẩm/trang) -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/product?page=${currentPage - 1}" class="page-link-btn">&laquo; Trang trước</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="${pageContext.request.contextPath}/product?page=${i}"
                           class="page-link-btn ${currentPage == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/product?page=${currentPage + 1}" class="page-link-btn">Trang sau &raquo;</a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
