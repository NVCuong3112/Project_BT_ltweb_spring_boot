<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Architecture MVC & 3-Tier</title>
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
                Kiến trúc của Project
            </div>
            
            <pre style="background: #282c34; color: #abb2bf; padding: 20px; border-radius: 8px; overflow-x: auto; font-family: monospace; font-size: 14px;">
                Browser (Client)
                   |
                   v (HTTP Request)
===================================================
[CONTROLLER LAYER] - Servlet
                   | - Nhận Request
                   | - Kiểm tra quyền (Filter)
                   | - Đọc Parameter
                   v
===================================================
[BUSINESS LAYER] - Service
                   | - Validation nghiệp vụ
                   | - Tính toán logic
                   v
===================================================
[DATA LAYER]     - DAO (Data Access Object)
                   | - Chuẩn bị SQL (PreparedStatement)
                   | - Trả về List&lt;Entity&gt;
                   v
===================================================
                 JDBC Connection
                   |
                   v
              MySQL Database
===================================================
                   ^ (Data return flow)
                   |
                Servlet
                   | - setAttribute(data)
                   | - RequestDispatcher.forward()
                   v
             JSP (VIEW LAYER)
                   | - Hiển thị HTML
                   v (HTTP Response)
                Browser
            </pre>
            
            <div style="margin-top: 20px; line-height: 1.6;">
                <h3>Giải thích nhiệm vụ:</h3>
                <ul>
                    <li><strong>Servlet (Controller):</strong> Chỉ làm nhiệm vụ điều hướng, lấy input, và gọi service. Tuyệt đối không viết câu lệnh SQL ở đây.</li>
                    <li><strong>Service:</strong> Xử lý logic như kiểm tra rỗng, độ dài hợp lệ, nghiệp vụ. Nó là cầu nối giữa Controller và DAO.</li>
                    <li><strong>DAO:</strong> Nơi duy nhất được phép có câu lệnh SQL (SELECT, INSERT, UPDATE, DELETE) và thao tác ResultSet.</li>
                    <li><strong>JSP (View):</strong> Giao diện, chỉ đọc biến từ <code>request.getAttribute()</code> và hiển thị.</li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>
