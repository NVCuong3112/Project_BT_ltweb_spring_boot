<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Compare Session vs Cookie</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2.1">
</head>
<body>
    <div class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">Servlet MVC Demo</a>
        <div class="navbar-menu">
            <a href="${pageContext.request.contextPath}/">Home</a>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <div class="card-header">
                So sánh Cookie và Session
            </div>
            
            <table class="table">
                <thead>
                    <tr>
                        <th>Tiêu chí</th>
                        <th>Cookie</th>
                        <th>Session</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Lưu ở đâu</strong></td>
                        <td>Trình duyệt (Browser / Client)</td>
                        <td>Máy chủ (Server)</td>
                    </tr>
                    <tr>
                        <td><strong>Dữ liệu gửi theo request</strong></td>
                        <td>Gửi kèm toàn bộ giá trị trong Header</td>
                        <td>Chỉ gửi kèm Session ID (thông qua 1 cookie JSESSIONID)</td>
                    </tr>
                    <tr>
                        <td><strong>Thời gian tồn tại</strong></td>
                        <td>MaxAge / Expires (Có thể lưu lâu dài trên ổ cứng)</td>
                        <td>Session timeout (Tự hủy khi đóng trình duyệt hoặc hết giờ)</td>
                    </tr>
                    <tr>
                        <td><strong>Bảo mật</strong></td>
                        <td>Thấp hơn (Có thể bị sửa đổi nếu không mã hóa)</td>
                        <td>Cao hơn (Dữ liệu thật nằm trên Server)</td>
                    </tr>
                    <tr>
                        <td><strong>Thường dùng</strong></td>
                        <td>Tính năng "Remember me", lưu tùy chọn giao diện</td>
                        <td>Authentication, lưu giỏ hàng, thông tin nhạy cảm</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
