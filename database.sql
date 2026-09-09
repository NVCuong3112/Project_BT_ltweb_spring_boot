-- =======================================================
-- HỆ THỐNG CƠ SỞ DỮ LIỆU SQL SERVER CHO DỰ ÁN LIBRARY MANAGER
-- Bao gồm: categories, users, otp_codes, products
-- =======================================================

-- Tạo cơ sở dữ liệu nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'servlet_demo')
BEGIN
    CREATE DATABASE servlet_demo;
END
GO

USE servlet_demo;
GO

-- Xóa bảng cũ theo thứ tự khóa ngoại để chạy lại không bị lỗi
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('otp_codes', 'U') IS NOT NULL DROP TABLE otp_codes;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('categories', 'U') IS NOT NULL DROP TABLE categories;
GO

-- 1. BẢNG CATEGORIES (Danh mục)
CREATE TABLE categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255)
);
GO

-- 2. BẢNG USERS (Người dùng, hỗ trợ BCrypt & trạng thái kích hoạt)
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name NVARCHAR(100),
    status INT NOT NULL DEFAULT 0, -- 0: Chưa kích hoạt, 1: Đã kích hoạt
    role VARCHAR(20) DEFAULT 'USER'
);
GO

-- 3. BẢNG OTP_CODES (Lưu mã xác thực OTP gửi qua email)
CREATE TABLE otp_codes (
    id INT PRIMARY KEY IDENTITY(1,1),
    email VARCHAR(100) NOT NULL,
    otp_code VARCHAR(10) NOT NULL,
    type VARCHAR(30) NOT NULL,      -- 'REGISTER' hoặc 'FORGOT_PASSWORD'
    expired_at DATETIME2 NOT NULL,  -- Thời hạn 5 phút
    used BIT NOT NULL DEFAULT 0     -- 0: Chưa dùng, 1: Đã dùng
);
GO

-- 4. BẢNG PRODUCTS (Sản phẩm / Tài liệu thư viện)
CREATE TABLE products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name NVARCHAR(200) NOT NULL,
    price DECIMAL(18,2) NOT NULL DEFAULT 0,
    description NVARCHAR(MAX),
    image VARCHAR(255),
    quantity INT NOT NULL DEFAULT 0,
    status INT NOT NULL DEFAULT 1,  -- 1: Hiển thị bán, 0: Tạm ẩn
    created_at DATETIME2 DEFAULT CURRENT_TIMESTAMP,
    category_id INT FOREIGN KEY REFERENCES categories(id) ON DELETE SET NULL
);
GO

-- =======================================================
-- DỮ LIỆU MẪU (SEED DATA)
-- =======================================================

-- Danh mục mẫu
INSERT INTO categories (name, description) VALUES
(N'Lập trình Java', N'Giáo trình, tài liệu chuyên sâu về ngôn ngữ Java và Jakarta EE'),
(N'Công nghệ Web', N'Tài liệu về HTML5, CSS3, JavaScript, Servlet và MVC Framework'),
(N'Hệ quản trị CSDL', N'Tài liệu thiết kế cơ sở dữ liệu, SQL Server, MySQL và NoSQL'),
(N'Trí tuệ nhân tạo', N'Machine Learning, Deep Learning, Generative AI và Data Science');
GO

-- Người dùng mẫu (Mật khẩu: 123456 đã được hash bằng BCrypt)
-- Hash BCrypt mẫu của '123456': $2a$12$K896lHw4U8m.2Dk9ZkC27.h5QnQhP8Q54B3ZqF3lW7kM3s0xM6Wti
INSERT INTO users (username, password, email, full_name, status, role) VALUES
('admin', '$2a$12$K896lHw4U8m.2Dk9ZkC27.h5QnQhP8Q54B3ZqF3lW7kM3s0xM6Wti', 'admin@library.com', N'Quản trị viên Hệ thống', 1, 'ADMIN'),
('user', '$2a$12$K896lHw4U8m.2Dk9ZkC27.h5QnQhP8Q54B3ZqF3lW7kM3s0xM6Wti', 'user@library.com', N'Nguyễn Văn Thử Nghiệm', 1, 'USER');
GO

-- Sản phẩm mẫu (10 sản phẩm để kiểm tra hiển thị top 10 trang chủ và phân trang)
INSERT INTO products (product_name, price, description, image, quantity, status, category_id) VALUES
(N'Lập trình Web với Java Servlet & JSP', 125000, N'Hướng dẫn từ cơ bản đến nâng cao về Servlet, JSP, JSTL, Filter, Session và MVC.', '', 50, 1, 2),
(N'Làm chủ Hibernate 7 & JPA 3.0', 165000, N'Chi tiết về mapping Entity, JPQL, Criteria API, Transaction và tối ưu hóa truy vấn Hibernate.', '', 35, 1, 1),
(N'Thiết kế CSDL với SQL Server 2022', 140000, N'Tối ưu hóa Index, Stored Procedure, Trigger, Transaction và thiết kế chuẩn hóa.', '', 40, 1, 3),
(N'Nhập môn Trí tuệ nhân tạo hiện đại', 195000, N'Tổng quan lý thuyết và ứng dụng thực tiễn của học máy, mạng nơ-ron và thị giác máy tính.', '', 20, 1, 4),
(N'Cấu trúc dữ liệu & Giải thuật Java', 110000, N'Phân tích độ phức tạp thuật toán, cây nhị phân, đồ thị và thuật toán sắp xếp.', '', 60, 1, 1),
(N'Xây dựng RESTful API chuyên nghiệp', 150000, N'Kiến trúc REST, JSON, bảo mật token JWT, phân quyền và tài liệu hóa Swagger/OpenAPI.', '', 25, 1, 2),
(N'Kỹ nghệ phần mềm & Mẫu thiết kế GoF', 135000, N'Áp dụng 23 mẫu thiết kế Gang of Four (Singleton, Factory, Observer...) trong thực tế.', '', 30, 1, 1),
(N'Quản trị Hệ thống Cơ sở dữ liệu lớn', 220000, N'Partitioning, Replication, Backup & Restore và High Availability trên cơ sở dữ liệu lớn.', '', 15, 1, 3),
(N'Học sâu (Deep Learning) từ con số 0', 210000, N'Lý thuyết toán học và code thực hành CNN, RNN, Transformer.', '', 18, 1, 4),
(N'Bảo mật Ứng dụng Web toàn diện', 175000, N'Phòng chống tấn công SQL Injection, XSS, CSRF, Session Fixation và Brute Force.', '', 45, 1, 2);
GO
