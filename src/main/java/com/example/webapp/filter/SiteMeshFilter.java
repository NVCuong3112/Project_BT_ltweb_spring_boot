package com.example.webapp.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * Filter SiteMesh 3 áp dụng giao diện Bootstrap 5 (Decorator) cho toàn bộ ứng dụng Web.
 * Tự động bọc layout chuẩn gồm Header cố định và Footer vào các trang con.
 */
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Xóa decoratorPrefix mặc định ("/WEB-INF/decorators/") về chuỗi rỗng ""
        // để tránh SiteMesh tự động ghép thêm prefix dẫn đến lỗi 404 lặp đôi đường dẫn
        builder.setDecoratorPrefix("");

        // Ánh xạ toàn bộ đường dẫn JSP tới decorator chung với đường dẫn duy nhất
        builder.addDecoratorPath("/*", "/decorators/decorator.jsp")
               // Loại trừ các file tĩnh, hình ảnh và thư mục decorator
               .addExcludedPath("/uploads/*")
               .addExcludedPath("/css/*")
               .addExcludedPath("/js/*")
               .addExcludedPath("/images/*")
               .addExcludedPath("/decorators/*")
               .addExcludedPath("/WEB-INF/decorators/*");
    }
}
