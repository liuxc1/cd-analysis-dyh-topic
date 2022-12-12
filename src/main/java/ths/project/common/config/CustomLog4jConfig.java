package ths.project.common.config;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.PropertyConfigurator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.core.io.support.PropertiesLoaderUtils;
import ths.jdp.custom.util.res.Path;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.Map.Entry;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

/**
 * 自定义log4j日志配置文件加载
 */
public class CustomLog4jConfig implements InitializingBean {
    private boolean reload = true;
    private int interval = 60000;
    private String encoding = "UTF-8";

    private long lastUpdateTime = 0;

    private String webContextName = null;

    private final ScheduledExecutorService scheduledExecutorService;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * log4j日志自动加载
     */
    public CustomLog4jConfig() {
        this(true, null);
    }

    /**
     * log4j日志自动加载
     *
     * @param reload   是否开启自动加载
     * @param interval 自动加载时间(ms)
     */
    public CustomLog4jConfig(Boolean reload, Integer interval) {
        this(reload, interval, null);
    }

    /**
     * log4j日志自动加载
     *
     * @param reload   是否开启自动加载
     * @param interval 自动加载时间(ms)
     * @param encoding 配置文件编码(ms)
     */
    public CustomLog4jConfig(Boolean reload, Integer interval, String encoding) {
        if (reload != null) {
            this.reload = reload;
        }
        if (interval != null) {
            this.interval = interval;
        }
        if (encoding != null) {
            this.encoding = encoding;
        }

        scheduledExecutorService = new ScheduledThreadPoolExecutor(1, new ThreadFactory() {
            @Override
            public Thread newThread(Runnable r) {
                Thread thread = new Thread(r, this.getClass().getName() + "." + Thread.class.getName());
                return thread;
            }
        });
    }

    /**
     * 初始化日志
     */
    public void initConfigLoad() {
        this.webContextName = StringUtils.isBlank(Path.CONTEXT_PATH) || "/".equals(Path.CONTEXT_PATH) ? "ROOT" : Path.CONTEXT_PATH.substring(1);

        String log4jPath = Objects.requireNonNull(this.getClass().getClassLoader().getResource("log4j.properties")).getPath();
        File log4jFile = new File(log4jPath);
        if (log4jFile.exists()) {
            lastUpdateTime = log4jFile.lastModified();
            loadConfig(log4jFile);

            if (reload) {
                scheduledExecutorService.scheduleAtFixedRate(() -> {
                    try {
                        long lastModified = log4jFile.lastModified();
                        while (lastModified != lastUpdateTime) {
                            lastUpdateTime = lastModified;
                            loadConfig(log4jFile);
                        }
                    } catch (Exception e) {
                        logger.error("", e);
                    }
                }, interval, interval, TimeUnit.MILLISECONDS);
            }
        }
    }

    /**
     * 加载日志配置
     *
     * @param log4jFile 配置文件
     */
    private void loadConfig(File log4jFile) {
        try {
            System.out.println("log4j file path: " + log4jFile.getAbsolutePath());

            Properties properties = new Properties();
            Resource resource = new FileSystemResource(log4jFile);
            PropertiesLoaderUtils.fillProperties(properties, new EncodedResource(resource, this.encoding));

            Set<Entry<Object, Object>> entrySet = properties.entrySet();
            for (Entry<Object, Object> entry : entrySet) {
                String value = (String) entry.getValue();
                if (value != null && value.contains("${web.context.path}")) {
                    entry.setValue(value.replaceAll("\\$\\{web.context.path}", webContextName));
                }
            }
            PropertyConfigurator.configure(properties);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void afterPropertiesSet() {
        initConfigLoad();
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        try {
            scheduledExecutorService.shutdown();
        } catch (Exception ignored) {
        }
    }
}
