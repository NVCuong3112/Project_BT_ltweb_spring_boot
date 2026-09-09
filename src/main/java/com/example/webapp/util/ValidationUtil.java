package com.example.webapp.util;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * Tiện ích Validation server-side sử dụng Jakarta Bean Validation (Hibernate Validator).
 * Trả về danh sách lỗi dạng Map<Tên trường, Thông điệp lỗi> để hiển thị trực tiếp tại từng ô input trên JSP.
 */
public class ValidationUtil {

    private static final ValidatorFactory factory;
    private static final Validator validator;

    static {
        factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    public static Validator getValidator() {
        return validator;
    }

    /**
     * Validate bất kỳ DTO hoặc Entity nào có gắn các annotation @NotBlank, @Email, @Size, @Pattern...
     * 
     * @param object Đối tượng cần kiểm tra
     * @param <T> Kiểu dữ liệu
     * @return Map chứa lỗi (key: tên thuộc tính, value: thông báo lỗi). Rỗng nếu không có lỗi.
     */
    public static <T> Map<String, String> validate(T object) {
        Map<String, String> errorMap = new LinkedHashMap<>();
        if (object == null) {
            errorMap.put("general", "Dữ liệu gửi lên không được để trống!");
            return errorMap;
        }

        Set<ConstraintViolation<T>> violations = validator.validate(object);
        for (ConstraintViolation<T> violation : violations) {
            String property = violation.getPropertyPath().toString();
            // Nếu có nhiều lỗi trên cùng 1 property thì giữ lại lỗi đầu tiên
            errorMap.putIfAbsent(property, violation.getMessage());
        }
        return errorMap;
    }
}
