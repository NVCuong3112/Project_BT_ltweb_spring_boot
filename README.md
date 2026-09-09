# Java Servlet MVC 3-Tier Web Application

This project demonstrates a complete Java Web Application using Servlet, JSP, JDBC, and following the MVC and 3-Tier Architectures. It covers session-based and cookie-based authentication, and CRUD operations for categories.

## 1. Yêu cầu môi trường

- **JDK**: Java 17 hoặc 21
- **Maven**: 3.8+
- **MySQL**: 8.x
- **Tomcat**: Apache Tomcat 10.x (Jakarta EE 10)
- **IDE**: IntelliJ IDEA, Eclipse, hoặc VS Code

## 2. Tạo database

1. Mở MySQL Console hoặc MySQL Workbench.
2. Chạy toàn bộ nội dung file `database.sql` để tạo database `servlet_demo`, các bảng và dữ liệu mẫu.

## 3. Cấu hình database

Nếu MySQL của bạn không sử dụng username `root` hoặc password rỗng/password khác, hãy chỉnh sửa file sau:

- File: `src/main/java/com/example/webapp/dao/DBConnection.java`
- Chỉnh sửa `URL`, `USERNAME`, `PASSWORD`. mặc định:
  - URL = `jdbc:mysql://localhost:3306/servlet_demo`
  - USERNAME = `root`
  - PASSWORD = `""` (hoặc thay bằng password của bạn)

## 4. Build

Di chuyển vào thư mục dự án và chạy Maven:

```bash
mvn clean package
```

Lệnh này sẽ tạo ra file `target/servlet-mvc-demo.war`.

## 5. Deploy

Copy file `servlet-mvc-demo.war` vào thư mục `webapps` của Apache Tomcat:
`[Tomcat_Path]/webapps/`

Khởi động Tomcat (`bin/startup.bat` hoặc qua IDE).

## 6. Run

Truy cập URL sau trên trình duyệt:

```text
http://localhost:8080/servlet-mvc-demo/
```

## 7. Account demo

- **Admin**: username: `admin` / password: `123456`
- **User**: username: `user` / password: `123456`

## 8. Test Cookie

1. Nhấp vào **Cookie Login**.
2. Nhập username/password.
3. Tích chọn **Remember Me**.
4. Nhấn **Login**.
5. Nhấn **Logout**.
6. Quay lại **Cookie Login** -> Bạn sẽ thấy username đã được tự động điền (Đọc từ Cookie).

## 9. Test Session

1. Nhấp vào **Session Login**.
2. Đăng nhập thành công.
3. Truy cập phần **Categories** (hoặc Dashboard).
4. Kiểm tra bạn có thể xem các danh mục (Session đã được tạo).
5. Nhấn **Logout**.
6. Thử truy cập lại URL trang Categories -> Hệ thống sẽ bắt buộc chuyển hướng về trang Login (vì Session đã bị hủy).

## 10. Test CRUD

- **Create**: Nhấn `+ Add Category`, nhập thông tin hợp lệ (tối đa 100 ký tự tên, 255 mô tả).
- **Read**: Xem danh sách các Category trên bảng.
- **Update**: Nhấn `Edit`, thay đổi thông tin và lưu.
- **Delete**: Nhấn `Delete`, xác nhận trên hộp thoại để xóa.
