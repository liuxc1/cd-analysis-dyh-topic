package ths.project.common.servlet.listener;

import ths.project.common.config.CustomWebConfigure;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 自定义项目全局配置（可多项目并存）的初始化监听器
 */
public class CustomWebConfigureListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        CustomWebConfigure.setProperty(CustomWebConfigure.KEY_CONTEXT_PATH, servletContext.getContextPath());
        CustomWebConfigure.setProperty(CustomWebConfigure.KEY_REAL_PATH, servletContext.getRealPath("/"));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        CustomWebConfigure.clear();
    }
}
