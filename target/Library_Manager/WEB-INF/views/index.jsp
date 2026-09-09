<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.example.webapp.service.CategoryService" %>
<%@ page import="com.example.webapp.service.ProductService" %>
<%@ page import="com.example.webapp.model.Category" %>
<%@ page import="com.example.webapp.model.Product" %>
<%@ page import="com.example.webapp.model.User" %>
<%@ page import="java.util.List" %>
<%
    int totalCategories = 0;
    int totalProducts = 0;
    List<Product> top10Products = null;

    try {
        CategoryService categoryService = new CategoryService();
        List<Category> categories = categoryService.getAllCategories();
        if (categories != null) {
            totalCategories = categories.size();
        }
    } catch (Exception e) {}

    try {
        ProductService productService = new ProductService();
        top10Products = productService.getTop10LatestProducts();
        totalProducts = (int) productService.countProducts();
    } catch (Exception e) {}

    User currentUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Library Manager - Hệ thống quản lý danh mục và tài liệu thư viện trực tuyến chuyên nghiệp">
    <title>Library Manager — Quản lý danh mục & Kho tài liệu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
    <style>
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
        }
        .section-subtitle {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        .home-product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }
        .home-product-card {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
        }
        .home-product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px -6px rgba(0, 0, 0, 0.08);
            border-color: #cbd5e1;
        }
        .home-product-img {
            width: 100%;
            height: 170px;
            background: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .home-product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }
        .home-product-card:hover .home-product-img img {
            transform: scale(1.05);
        }
        .home-product-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .home-product-cat {
            font-size: 11px;
            font-weight: 700;
            color: #6366f1;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .home-product-title {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
            line-height: 1.4;
        }
        .home-product-price {
            font-size: 16px;
            font-weight: 800;
            color: #059669;
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 10px;
            border-top: 1px solid #f1f5f9;
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="hero-content">
                <div class="hero-badge">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                    <span>Hệ thống Quản lý Tài liệu & Thư viện 4.0</span>
                </div>

                <h1 class="hero-title">
                    Chào mừng bạn đến với <span class="gradient-text">Library Manager</span>
                </h1>

                <p class="hero-subtitle">
                    Khám phá kho giáo trình, sách chuyên khảo và tài liệu công nghệ thông tin. Quản lý danh mục và sản phẩm trực tuyến hiệu quả.
                </p>

                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/product" class="btn-hero">
                        <span>Khám phá sản phẩm</span>
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"></path>
                            <path d="m12 5 7 7-7 7"></path>
                        </svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/categories" class="btn-hero-outline">
                        <span>Xem danh mục</span>
                    </a>
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <div class="container stats-container" style="padding-bottom: 30px;">
            <div class="stats-grid">
                <div class="stat-card purple">
                    <div class="stat-icon-wrapper purple">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"></path>
                        </svg>
                    </div>
                    <div class="stat-value"><%= totalCategories %></div>
                    <div class="stat-label">Tổng danh mục</div>
                    <span class="stat-badge purple">Cơ sở dữ liệu</span>
                </div>

                <div class="stat-card blue">
                    <div class="stat-icon-wrapper blue">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                        </svg>
                    </div>
                    <div class="stat-value"><%= totalProducts %></div>
                    <div class="stat-label">Tổng sản phẩm</div>
                    <span class="stat-badge blue">Đang phát hành</span>
                </div>

                <div class="stat-card green">
                    <div class="stat-icon-wrapper green">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <path d="m9 11 3 3L22 4"></path>
                        </svg>
                    </div>
                    <div class="stat-value">JPA 3.0</div>
                    <div class="stat-label">Hibernate ORM</div>
                    <span class="stat-badge green">● Hoạt động 24/7</span>
                </div>
            </div>
        </div>

        <!-- 4.2 Top 10 Sản Phẩm Mới Nhất (Query JPQL ORDER BY p.createdAt DESC) -->
        <div class="container" style="padding-bottom: 60px;">
            <div class="section-header">
                <div>
                    <h2 class="section-title">10 Sản Phẩm Mới Nhất</h2>
                    <p class="section-subtitle">Tài liệu và giáo trình vừa được cập nhật vào thư viện</p>
                </div>
                <a href="${pageContext.request.contextPath}/product" style="color: #6366f1; font-weight: 700; text-decoration: none; font-size: 14px; display: inline-flex; align-items: center; gap: 4px;">
                    <span>Xem tất cả</span>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
                </a>
            </div>

            <div class="home-product-grid">
                <% if (top10Products != null && !top10Products.isEmpty()) {
                    for (Product p : top10Products) { %>
                    <div class="home-product-card">
                        <a href="${pageContext.request.contextPath}/product/detail?id=<%= p.getProductId() %>" class="home-product-img">
                            <% if (p.getImage() != null && !p.getImage().trim().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/uploads/<%= p.getImage() %>" alt="<%= p.getProductName() %>">
                            <% } else { %>
                                <span style="color: #94a3b8; font-size: 13px;">Chưa có ảnh</span>
                            <% } %>
                        </a>
                        <div class="home-product-body">
                            <span class="home-product-cat"><%= p.getCategory() != null ? p.getCategory().getName() : "Danh mục" %></span>
                            <a href="${pageContext.request.contextPath}/product/detail?id=<%= p.getProductId() %>" style="text-decoration: none;">
                                <h3 class="home-product-title"><%= p.getProductName() %></h3>
                            </a>
                            <div class="home-product-price">
                                <span><%= String.format("%,.0f", p.getPrice()) %> đ</span>
                                <a href="${pageContext.request.contextPath}/product/detail?id=<%= p.getProductId() %>" class="btn btn-primary btn-sm" style="padding: 4px 10px; font-size: 12px;">Chi tiết</a>
                            </div>
                        </div>
                    </div>
                <%   }
                   } else { %>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px; background: #ffffff; border-radius: 12px; border: 1px dashed #cbd5e1; color: #64748b;">
                        Chưa có sản phẩm nào. Bạn có thể vào <a href="${pageContext.request.contextPath}/admin/products" style="color: #6366f1; font-weight: 600;">Quản trị sản phẩm</a> để thêm mới sản phẩm và upload ảnh!
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
