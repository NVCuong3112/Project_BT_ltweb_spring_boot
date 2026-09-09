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
    <meta name="description" content="${product.productName} — Chi tiết sản phẩm">
    <title>${product.productName} — Library Manager</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
    <style>
        .detail-wrapper {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 40px;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            padding: 36px;
            margin-top: 24px;
        }
        @media (max-width: 768px) {
            .detail-wrapper {
                grid-template-columns: 1fr;
            }
        }
        .detail-img-box {
            width: 100%;
            height: 420px;
            border-radius: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .detail-img-box img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .detail-info {
            display: flex;
            flex-direction: column;
        }
        .detail-badge {
            display: inline-block;
            background: #ede9fe;
            color: #6366f1;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
            align-self: flex-start;
        }
        .detail-title {
            font-size: 28px;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.3;
            margin-bottom: 16px;
        }
        .detail-price-box {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 12px;
            padding: 16px 20px;
            margin-bottom: 24px;
            display: flex;
            align-items: baseline;
            gap: 12px;
        }
        .detail-price {
            font-size: 32px;
            font-weight: 800;
            color: #15803d;
        }
        .detail-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
            padding: 16px;
            background: #f8fafc;
            border-radius: 12px;
        }
        .meta-item {
            font-size: 14px;
            color: #64748b;
        }
        .meta-item b {
            color: #0f172a;
            display: block;
            margin-top: 4px;
            font-size: 15px;
        }
        .detail-desc-title {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }
        .detail-desc {
            font-size: 15px;
            color: #475569;
            line-height: 1.7;
            white-space: pre-line;
            margin-bottom: 32px;
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="container" style="padding-top: 36px; padding-bottom: 56px;">
            <div>
                <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"/></svg>
                    <span>Quay lại danh sách sản phẩm</span>
                </a>
            </div>

            <div class="detail-wrapper">
                <!-- Hình ảnh sản phẩm -->
                <div class="detail-img-box">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img src="${pageContext.request.contextPath}/uploads/${product.image}" alt="${product.productName}">
                        </c:when>
                        <c:otherwise>
                            <span style="color: #94a3b8; font-size: 16px;">Sản phẩm chưa có hình ảnh</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Thông tin sản phẩm -->
                <div class="detail-info">
                    <span class="detail-badge">${product.category != null ? product.category.name : 'Danh mục chung'}</span>
                    <h1 class="detail-title">${product.productName}</h1>

                    <div class="detail-price-box">
                        <span class="detail-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/> đ</span>
                        <span style="font-size: 14px; color: #16a34a; font-weight: 600;">(Đã bao gồm VAT)</span>
                    </div>

                    <div class="detail-meta">
                        <div class="meta-item">
                            Tình trạng kho hàng:
                            <b>${product.quantity > 0 ? 'Còn hàng (' : 'Hết hàng'} ${product.quantity > 0 ? product.quantity : ''} ${product.quantity > 0 ? ' cuốn)' : ''}</b>
                        </div>
                        <div class="meta-item">
                            Mã số sản phẩm:
                            <b>#${product.productId}</b>
                        </div>
                    </div>

                    <div class="detail-desc-title">Giới thiệu & Mô tả nội dung</div>
                    <div class="detail-desc">
                        ${not empty product.description ? product.description : 'Chưa có thông tin mô tả chi tiết cho tài liệu này.'}
                    </div>

                    <div style="margin-top: auto; display: flex; gap: 14px;">
                        <button class="btn btn-primary btn-lg" style="flex: 1;" onclick="alert('Đã thêm vào giỏ hàng mô phỏng!')">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/></svg>
                            <span>Mượn / Đặt mua tài liệu</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
