# Hướng dẫn chạy và sử dụng dự án (Spring Boot 3.4 / 4)

Ứng dụng quản lý thư viện và danh mục, người dùng đã được chuyển đổi hoàn chỉnh sang nền tảng **Spring Boot** với **Spring Data JPA**, **Tomcat nhúng** và **JSP Views**.

---

## 1. Ứng dụng đã khởi động thành công!

Khi thấy dòng log sau trong console:
```text
Tomcat started on port 8080 (http) with context path '/'
Started Application in 8.89 seconds
```
Nghĩa là server web nội bộ đã sẵn sàng nhận request từ trình duyệt tại cổng `8080`.

---

## 2. Các liên kết kiểm tra trên trình duyệt

Hãy mở trình duyệt (Google Chrome, Microsoft Edge, Firefox...) và truy cập các liên kết sau:

### 2.1 Quản lý Danh mục (Category Management)
- **URL danh sách**: [http://localhost:8080/admin/categories](http://localhost:8080/admin/categories)
- **Tìm kiếm danh mục**: Nhập từ khóa vào ô tìm kiếm ở đầu trang -> bấm **Tìm kiếm** (URL dạng `http://localhost:8080/admin/categories?keyword=cong+nghe`).
- **Thêm danh mục**: [http://localhost:8080/admin/categories/add](http://localhost:8080/admin/categories/add)
- **Sửa / Xóa**: Bấm trực tiếp nút **Sửa** hoặc **Xóa** ở cột "Thao tác" trên bảng danh mục.

### 2.2 Quản lý Người dùng (User Management)
- **URL danh sách**: [http://localhost:8080/admin/users](http://localhost:8080/admin/users)
- **Tìm kiếm người dùng**: Nhập `username` hoặc `email` vào thanh tìm kiếm ở đầu trang -> bấm **Tìm kiếm** (sử dụng derived query method `findByUsernameContainingIgnoreCaseOrEmailContainingIgnoreCase`).
- **Xem chi tiết người dùng**: Bấm nút **Xem** (URL: `http://localhost:8080/admin/users/detail?id=1`).
- **Sửa vai trò & Trạng thái**: Bấm nút **Sửa** (URL: `http://localhost:8080/admin/users/edit?id=1`) để thay đổi Role (`ADMIN`/`USER`) và Status (`Đã kích hoạt`/`Chưa kích hoạt`).
- **Xóa tài khoản**: Bấm nút **Xóa** kèm xác nhận popup.

### 2.3 Các trang chức năng chung
- **Trang chủ**: [http://localhost:8080/](http://localhost:8080/)
- **Đăng nhập**: [http://localhost:8080/login](http://localhost:8080/login)
- **Đăng ký thành viên**: [http://localhost:8080/register](http://localhost:8080/register)
- **Danh sách sản phẩm**: [http://localhost:8080/product](http://localhost:8080/product)
- **Bảng điều khiển**: [http://localhost:8080/dashboard](http://localhost:8080/dashboard)

---

## 3. Tài khoản Demo có sẵn trong Database
- **Tài khoản Admin**: `admin` / Mật khẩu: `123456`
- **Tài khoản User**: `user` / Mật khẩu: `123456`

---

## 4. Cách khởi động dự án ở các lần sau

### Cách 1: Chạy trong IntelliJ IDEA
Mở class `com.example.webapp.Application` và bấm nút **Run ▶**.

### Cách 2: Chạy bằng dòng lệnh Terminal
```powershell
.\mvnw.cmd spring-boot:run
```
