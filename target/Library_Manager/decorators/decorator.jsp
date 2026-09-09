<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.example.webapp.model.User" %>
<%
    User currentUser = (User) session.getAttribute("loggedUser");
    boolean isAdmin = (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole()));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title">Library Manager — Hệ thống Quản lý Tài liệu</sitemesh:write></title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=3.0">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar-custom {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            padding: 0.75rem 1.5rem;
        }
        .navbar-brand-custom {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            font-size: 1.25rem;
            color: #1e1b4b;
            text-decoration: none;
        }
        .brand-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 50%, #7c3aed 100%);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            box-shadow: 0 4px 10px rgba(79, 70, 229, 0.3);
        }
        .nav-link-custom {
            font-weight: 600;
            font-size: 0.92rem;
            color: #475569;
            padding: 0.5rem 0.85rem;
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        .nav-link-custom:hover {
            color: #4f46e5;
            background-color: #f1f5f9;
        }
        .avatar-circle {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: #4f46e5;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.85rem;
            object-fit: cover;
            box-shadow: 0 2px 5px rgba(0,0,0,0.15);
        }
        .footer-custom {
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            padding: 2rem 0;
            margin-top: auto;
            color: #64748b;
        }
    </style>

    <!-- Phục vụ cho thẻ <head> của các trang con inject vào -->
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Header / Navbar Bootstrap 5 cố định -->
    <header class="sticky-top">
        <nav class="navbar navbar-expand-lg navbar-custom">
            <div class="container-fluid px-lg-4">
                <!-- Logo / Brand -->
                <a class="navbar-brand-custom" href="${pageContext.request.contextPath}/">
                    <div class="brand-icon">
                        <i class="bi bi-journal-bookmark-fill fs-5"></i>
                    </div>
                    <span>Library Manager</span>
                </a>

                <!-- Mobile Hamburger Toggle -->
                <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                        aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Navigation Links -->
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-1">
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/">
                                <i class="bi bi-house-door me-1"></i> Trang chủ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/product">
                                <i class="bi bi-grid me-1"></i> Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/categories">
                                <i class="bi bi-folder2-open me-1"></i> Danh mục
                            </a>
                        </li>

                        <!-- Menu cho Quản trị viên (Admin) -->
                        <c:if test="<%= isAdmin %>">
                            <li class="nav-item dropdown">
                                <a class="nav-link nav-link-custom dropdown-toggle text-primary fw-bold" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-shield-lock me-1"></i> Quản trị
                                </a>
                                <ul class="dropdown-menu shadow-sm border-0 mt-2" aria-labelledby="adminDropdown">
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-folder2-open me-2 text-primary"></i> Quản lý danh mục</a></li>
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-2 text-success"></i> Quản lý người dùng</a></li>
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam me-2 text-info"></i> Quản lý sản phẩm</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/categories/add"><i class="bi bi-folder-plus me-2 text-primary"></i> Thêm danh mục</a></li>
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2 text-warning"></i> Bảng điều khiển</a></li>
                                </ul>
                            </li>
                        </c:if>
                    </ul>

                    <!-- User Actions (Đăng nhập / Đăng ký hoặc Dropdown User) -->
                    <div class="d-flex align-items-center gap-2">
                        <% if (currentUser != null) { %>
                            <div class="dropdown">
                                <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle py-1 px-2 rounded-3 hover-bg" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.loggedUser.avatar}">
                                            <img src="${pageContext.request.contextPath}/uploads/${sessionScope.loggedUser.avatar}" 
                                                 alt="Avatar" class="avatar-circle me-2 border">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="avatar-circle me-2">
                                                <%= currentUser.getUsername().substring(0, 1).toUpperCase() %>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="d-flex flex-column text-start">
                                        <span class="fw-bold text-dark" style="font-size: 0.9rem;">
                                            <%= currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty() ? currentUser.getFullName() : currentUser.getUsername() %>
                                        </span>
                                        <span class="badge <%= isAdmin ? "bg-danger" : "bg-primary" %>" style="font-size: 0.68rem; width: fit-content;">
                                            <%= currentUser.getRole() %>
                                        </span>
                                    </div>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2" aria-labelledby="userMenu" style="min-width: 200px;">
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle me-2 text-primary"></i> Hồ sơ của tôi</a></li>
                                    <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2 text-secondary"></i> Bảng điều khiển</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                                </ul>
                            </div>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm px-3 fw-semibold">
                                <i class="bi bi-person-plus me-1"></i> Đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm px-3 fw-semibold shadow-sm" style="background: #4f46e5; border-color: #4f46e5;">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <!-- Vùng chèn nội dung trang con từ SiteMesh -->
    <main class="flex-grow-1">
        <sitemesh:write property="body"/>
    </main>

    <!-- Footer Bootstrap 5 chung -->
    <footer class="footer-custom">
        <div class="container">
            <div class="row align-items-center g-3">
                <div class="col-md-5 d-flex align-items-center gap-2">
                    <div class="brand-icon" style="width: 28px; height: 28px; font-size: 0.8rem;">
                        <i class="bi bi-journal-bookmark-fill"></i>
                    </div>
                    <div>
                        <span class="fw-bold text-dark">Library Manager</span> &mdash; Quản lý tài liệu & thư viện hiện đại
                    </div>
                </div>
                <div class="col-md-4 text-center">
                    <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none mx-2">Trang chủ</a>
                    <a href="${pageContext.request.contextPath}/product" class="text-secondary text-decoration-none mx-2">Sản phẩm</a>
                    <a href="${pageContext.request.contextPath}/categories" class="text-secondary text-decoration-none mx-2">Danh mục</a>
                </div>
                <div class="col-md-3 text-md-end text-center">
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                        <i class="bi bi-circle-fill me-1" style="font-size: 0.55rem;"></i> Trực tuyến
                    </span>
                    <div class="small text-muted mt-1">&copy; 2026 Library Manager.</div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/script.js"></script>

    <!-- Script kích hoạt Bootstrap 5 Client-side validation -->
    <script>
        (function () {
            'use strict';
            // Lắng nghe tất cả các form có class .needs-validation
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
