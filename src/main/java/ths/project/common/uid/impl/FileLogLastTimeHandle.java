package ths.project.common.uid.impl;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import ths.project.common.uid.LastTimeHandle;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 默认时间记录处置器
 *
 * @author lym
 */
public class FileLogLastTimeHandle implements LastTimeHandle, InitializingBean, DisposableBean {
    /**
     * 缓存文件路径
     */
    private String path = "last-time-handle-default.log";
    /**
     * 写入间隔
     */
    private long writeStep = 10;
    /**
     * 最近时间
     */
    private long lastTime = 0L;
    /**
     * 上次写入时间
     */
    private long writeTime = 0L;
    /**
     * 缓存文件对象
     */
    private File propertyFile = null;
    /**
     * 写入定时器
     */
    private ScheduledExecutorService scheduledExecutorService;

    @Override
    public long getLastTime() {
        return this.lastTime;
    }

    @Override
    public void setLastTime(long lastTime) {
        this.lastTime = lastTime;
    }

    @Override
    public boolean checkCurrentTime(long currentTime) {
        return currentTime - lastTime - writeStep > 0;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        URL resource = this.getClass().getResource(path);
        propertyFile = new File(resource.getFile());
        if (propertyFile.exists()) {
            String content = FileUtils.readFileToString(propertyFile, StandardCharsets.UTF_8.name());
            if (StringUtils.isNotBlank(content)) {
                lastTime = Long.parseLong(content);
                writeTime = lastTime;
            }
        } else {
            File parentFile = propertyFile.getParentFile();
            if (!parentFile.exists()) {
                boolean b = parentFile.mkdirs();
                if (!b) {
                    throw new RuntimeException("无法创建时间戳记录文件");
                }
            }
            boolean b = propertyFile.createNewFile();
            if (!b) {
                throw new RuntimeException("无法创建时间戳记录文件");
            }
        }
        if (lastTime <= 0) {
            this.setLastTime(System.currentTimeMillis() / 1000 - 1);
        }

        scheduledExecutorService = new ScheduledThreadPoolExecutor(1, r -> {
            Thread thread = new Thread(r, FileLogLastTimeHandle.class.getName() + "." + Thread.class.getName());
            return thread;
        });
        scheduledExecutorService.scheduleAtFixedRate(() -> {
            if (lastTime - writeTime > writeStep) {
                try {
                    FileUtils.writeStringToFile(propertyFile, lastTime + "", StandardCharsets.UTF_8.name());
                } catch (IOException ignored) {
                }
                writeTime = lastTime;
            }
        }, writeStep, writeStep, TimeUnit.SECONDS);

    }

    @Override
    public void destroy() {
        scheduledExecutorService.shutdown();
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public long getWriteStep() {
        return writeStep;
    }

    public void setWriteStep(long writeStep) {
        this.writeStep = writeStep;
    }
}
