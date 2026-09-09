package com.example.webapp.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * Tiện ích gửi email thông báo mã xác thực OTP qua giao thức SMTP (Jakarta Mail).
 * Tự động đọc cấu hình từ file mail.properties.
 */
public class EmailUtil {

    private static Properties mailProps = new Properties();

    static {
        try (InputStream is = EmailUtil.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (is != null) {
                mailProps.load(is);
            } else {
                System.err.println("CẢNH BÁO: Không tìm thấy file mail.properties trong resources!");
            }
        } catch (Exception e) {
            System.err.println("Lỗi đọc cấu hình mail.properties: " + e.getMessage());
        }
    }

    /**
     * Gửi email chứa mã OTP (định dạng HTML chuyên nghiệp).
     * @param toEmail Địa chỉ email người nhận
     * @param otpCode Mã OTP 6 chữ số
     * @param type Mục đích ("REGISTER" hoặc "FORGOT_PASSWORD")
     * @return true nếu gửi thành công, false nếu có lỗi
     */
    public static boolean sendOtpEmail(String toEmail, String otpCode, String type) {
        String username = mailProps.getProperty("mail.user");
        String password = mailProps.getProperty("mail.password");
        String fromEmail = mailProps.getProperty("mail.from", username);
        String fromName = mailProps.getProperty("mail.from.name", "Library Manager");

        // Kiểm tra xem người dùng đã cấu hình email thật hay chưa
        if (username == null || username.contains("your_email") || password == null || password.contains("your_app_password")) {
            System.out.println("==========================================================");
            System.out.println(" [MÔ PHỎNG GỬI EMAIL OTP DO CHƯA CẤU HÌNH THẬT TRONG mail.properties]");
            System.out.println(" -> Đến: " + toEmail);
            System.out.println(" -> Loại: " + type);
            System.out.println(" -> Mã OTP 6 số: >>> " + otpCode + " <<<");
            System.out.println(" -> Thời hạn: 5 phút");
            System.out.println("==========================================================");
            return true; // Cho phép đi tiếp khi test local để không bị nghẽn
        }

        try {
            Session session = Session.getInstance(mailProps, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName, StandardCharsets.UTF_8.name()));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            String subject;
            String actionTitle;
            if ("REGISTER".equalsIgnoreCase(type)) {
                subject = "Mã xác thực kích hoạt tài khoản - Library Manager";
                actionTitle = "Kích hoạt tài khoản";
            } else {
                subject = "Mã xác thực đặt lại mật khẩu - Library Manager";
                actionTitle = "Đặt lại mật khẩu";
            }
            message.setSubject(subject);

            // Nội dung email giao diện HTML hiện đại
            String htmlContent = "<div style=\"max-width: 520px; margin: 0 auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; background: #ffffff;\">"
                    + "<div style=\"background: linear-gradient(135deg, #6366f1, #8b5cf6); padding: 24px; text-align: center; color: #ffffff;\">"
                    + "<h2 style=\"margin: 0; font-size: 24px;\">Library Manager</h2>"
                    + "<p style=\"margin: 6px 0 0 0; opacity: 0.9; font-size: 14px;\">Hệ thống Quản lý Tài liệu & Thư viện</p>"
                    + "</div>"
                    + "<div style=\"padding: 32px 24px;\">"
                    + "<h3 style=\"margin-top: 0; color: #1e293b;\">Xác thực yêu cầu " + actionTitle + "</h3>"
                    + "<p style=\"color: #64748b; font-size: 15px; line-height: 1.6;\">Xin chào,<br>Bạn vừa thực hiện yêu cầu " + actionTitle.toLowerCase() + " tại hệ thống Library Manager. Dưới đây là mã xác thực OTP của bạn:</p>"
                    + "<div style=\"text-align: center; margin: 28px 0;\">"
                    + "<span style=\"display: inline-block; font-size: 32px; font-weight: 800; letter-spacing: 8px; color: #4f46e5; background: #f1f5f9; padding: 14px 28px; border-radius: 8px; border: 1px dashed #cbd5e1;\">" + otpCode + "</span>"
                    + "</div>"
                    + "<p style=\"color: #dc2626; font-size: 13px; margin-bottom: 4px;\">⚠️ Lưu ý: Mã xác thực có hiệu lực trong vòng <b>5 phút</b> và chỉ dùng được 1 lần.</p>"
                    + "<p style=\"color: #64748b; font-size: 13px;\">Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email.</p>"
                    + "</div>"
                    + "<div style=\"background: #f8fafc; padding: 16px; text-align: center; font-size: 12px; color: #94a3b8; border-top: 1px solid #e2e8f0;\">"
                    + "&copy; 2026 Library Manager. All rights reserved."
                    + "</div>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Đã gửi email OTP thành công đến: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("Lỗi khi gửi email qua SMTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
