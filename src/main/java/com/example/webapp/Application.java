package com.example.webapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.event.EventListener;

/**
 * Lớp khởi chạy ứng dụng Spring Boot.
 * Hỗ trợ cả chạy độc lập (embedded Tomcat) và triển khai file WAR lên Web Server ngoài.
 */
@SpringBootApplication
@ServletComponentScan
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    /**
     * Tự động in các liên kết trực tiếp vào console khi khởi động xong
     * để người dùng có thể nhấp chuột (Click) mở thẳng trên trình duyệt.
     */
    @EventListener(ApplicationReadyEvent.class)
    public void onApplicationReady() {
        System.out.println();
        System.out.println("------------------------------------------------------------------");
        System.out.println(" 🚀 Website đã sẵn sàng! Click vào link để mở: http://localhost:8080/");
        System.out.println("------------------------------------------------------------------");
        System.out.println();
    }
}
