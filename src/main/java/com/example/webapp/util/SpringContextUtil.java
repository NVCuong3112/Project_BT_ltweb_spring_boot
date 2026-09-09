package com.example.webapp.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

/**
 * Tiện ích hỗ trợ truy xuất Spring Bean từ context cho các Servlet cũ và lớp không thuộc Spring Container.
 */
@Component
public class SpringContextUtil implements ApplicationContextAware {

    private static ApplicationContext context;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }

    public static <T> T getBean(Class<T> beanClass) {
        if (context != null && context.containsBeanDefinition(beanClass.getSimpleName().substring(0, 1).toLowerCase() + beanClass.getSimpleName().substring(1))) {
            return context.getBean(beanClass);
        }
        try {
            if (context != null) {
                return context.getBean(beanClass);
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    public static ApplicationContext getApplicationContext() {
        return context;
    }
}
