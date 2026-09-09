<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.example.webapp.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("loggedUser");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Hồ sơ cá nhân và quản lý tài khoản người dùng">
    <title>Hồ sơ của tôi — Library Manager</title>
</head>
<body>
    <div class="page-wrapper py-4">
        <div class="container" style="max-width: 860px;">
            <!-- Breadcrumb / Header -->
            <div class="d-flex align-items-center justify-content-between mb-4">
                <div>
                    <h1 class="h3 fw-bold mb-1" style="color: #0f172a;">Hồ sơ của tôi</h1>
                    <p class="text-muted mb-0">Quản lý thông tin hồ sơ bảo mật tài khoản và ảnh đại diện của bạn</p>
                </div>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1">
                    <i class="bi bi-arrow-left"></i>
                    <span>Dashboard</span>
                </a>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty sessionScope.flashSuccess}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>${sessionScope.flashSuccess}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="flashSuccess" scope="session"/>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <div>${error}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Avatar Preview Card -->
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0 rounded-4 text-center p-4">
                        <div class="position-relative d-inline-block mx-auto mb-3">
                            <c:choose>
                                <c:when test="${not empty user.avatar}">
                                    <img id="avatarPreview" 
                                         src="${pageContext.request.contextPath}/uploads/${user.avatar}" 
                                         alt="${user.fullName}" 
                                         class="rounded-circle shadow"
                                         style="width: 140px; height: 140px; object-fit: cover; border: 4px solid #fff; box-shadow: 0 4px 14px rgba(0,0,0,0.15) !important;">
                                </c:when>
                                <c:otherwise>
                                    <img id="avatarPreview" 
                                         src="https://ui-avatars.com/api/?name=${user.fullName != null ? user.fullName : user.username}&background=4f46e5&color=fff&size=200" 
                                         alt="${user.fullName}" 
                                         class="rounded-circle shadow"
                                         style="width: 140px; height: 140px; object-fit: cover; border: 4px solid #fff; box-shadow: 0 4px 14px rgba(0,0,0,0.15) !important;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h2 class="h5 fw-bold mb-1" style="color: #0f172a;">${user.fullName}</h2>
                        <p class="text-muted small mb-2">@${user.username}</p>
                        <div>
                            <span class="badge ${user.role eq 'ADMIN' ? 'bg-danger' : 'bg-primary'} px-3 py-2 rounded-pill">
                                <i class="bi ${user.role eq 'ADMIN' ? 'bi-shield-lock-fill' : 'bi-person-fill'} me-1"></i>
                                ${user.role}
                            </span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill ms-1">
                                <i class="bi bi-patch-check-fill me-1"></i> Đã kích hoạt
                            </span>
                        </div>
                        <hr class="my-4">
                        <div class="text-start small text-muted">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <span><i class="bi bi-envelope me-1"></i> Email:</span>
                                <span class="fw-semibold text-truncate" style="max-width: 150px;">${user.email}</span>
                            </div>
                            <div class="d-flex align-items-center justify-content-between">
                                <span><i class="bi bi-telephone me-1"></i> Điện thoại:</span>
                                <span class="fw-semibold">${not empty user.phone ? user.phone : 'Chưa cập nhật'}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Form Card -->
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0 rounded-4 p-4">
                        <h2 class="h5 fw-bold mb-3 pb-2 border-bottom" style="color: #0f172a;">Thông tin chi tiết</h2>
                        
                        <form action="${pageContext.request.contextPath}/profile" 
                              method="post" 
                              enctype="multipart/form-data" 
                              class="needs-validation" 
                              novalidate>
                            
                            <!-- Username (Readonly) -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted small text-uppercase">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-person-badge"></i></span>
                                    <input type="text" class="form-control bg-light" value="${user.username}" readonly>
                                </div>
                                <div class="form-text small">Tên đăng nhập là định danh tài khoản và không thể thay đổi.</div>
                            </div>

                            <!-- Email (Readonly) -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-muted small text-uppercase">Địa chỉ Email</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope-at"></i></span>
                                    <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                                </div>
                                <div class="form-text small">Email dùng để nhận mã OTP và khôi phục mật khẩu.</div>
                            </div>

                            <div class="row g-3 mb-3">
                                <!-- Họ và tên (Editable) -->
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label fw-semibold">
                                        Họ và tên <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group has-validation">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <input type="text" 
                                               id="fullName" 
                                               name="fullName" 
                                               class="form-control ${not empty errors['fullName'] ? 'is-invalid' : ''}" 
                                               value="${user.fullName}" 
                                               required 
                                               minlength="2" 
                                               maxlength="100"
                                               placeholder="Nhập họ và tên đầy đủ">
                                        <div class="invalid-feedback">
                                            ${not empty errors['fullName'] ? errors['fullName'] : 'Vui lòng nhập họ và tên (từ 2-100 ký tự)!'}
                                        </div>
                                    </div>
                                </div>

                                <!-- Số điện thoại (Editable) -->
                                <div class="col-md-6">
                                    <label for="phone" class="form-label fw-semibold">
                                        Số điện thoại
                                    </label>
                                    <div class="input-group has-validation">
                                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                        <input type="tel" 
                                               id="phone" 
                                               name="phone" 
                                               class="form-control ${not empty errors['phone'] ? 'is-invalid' : ''}" 
                                               value="${user.phone}" 
                                               pattern="^(0[0-9]{9,10})$"
                                               placeholder="Ví dụ: 0987654321">
                                        <div class="invalid-feedback">
                                            ${not empty errors['phone'] ? errors['phone'] : 'Số điện thoại Việt Nam hợp lệ gồm 10-11 chữ số, bắt đầu bằng 0!'}
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Upload Avatar -->
                            <div class="mb-4">
                                <label for="avatar" class="form-label fw-semibold">Thay đổi ảnh đại diện</label>
                                <input type="file" 
                                       id="avatar" 
                                       name="avatar" 
                                       class="form-control" 
                                       accept="image/png, image/jpeg, image/webp, image/gif">
                                <div class="form-text small">
                                    Hỗ trợ file ảnh JPG, PNG, WEBP hoặc GIF (Dung lượng tối đa: 5MB). Xem trước tức thì khi chọn.
                                </div>
                            </div>

                            <!-- Actions -->
                            <div class="d-flex justify-content-end gap-2 pt-2 border-top">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary px-4">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary px-4 d-flex align-items-center gap-2">
                                    <i class="bi bi-floppy"></i>
                                    <span>Lưu thay đổi</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Script xem trước ảnh đại diện tức thì trước khi submit -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const avatarInput = document.getElementById("avatar");
            const avatarPreview = document.getElementById("avatarPreview");
            
            if (avatarInput && avatarPreview) {
                avatarInput.addEventListener("change", function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        // Kiểm tra định dạng ảnh
                        if (!file.type.startsWith("image/")) {
                            alert("Vui lòng chỉ chọn file hình ảnh!");
                            avatarInput.value = "";
                            return;
                        }
                        
                        const reader = new FileReader();
                        reader.onload = function(event) {
                            avatarPreview.src = event.target.result;
                        };
                        reader.readAsDataURL(file);
                    }
                });
            }
        });
    </script>
</body>
</html>
