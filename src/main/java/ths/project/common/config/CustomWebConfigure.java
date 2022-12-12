package ths.project.common.config;

import java.util.HashMap;
import java.util.Map;

/**
 * 自定义项目全局配置（可多项目并存）
 */
public class CustomWebConfigure {
    /**
     * 上下文key
     */
    public static final String KEY_CONTEXT_PATH = "WEB_CONTEXT_PATH";
    /**
     * 项目绝对路径key
     */
    public static final String KEY_REAL_PATH = "WEB_REAL_PATH";

    /**
     * 项目配置缓存
     */
    private static final Map<ClassLoader, Map<String, String>> WEB_PARAM_MAP = new HashMap<>();

    /**
     * 获取本项目缓存
     *
     * @return 本项目缓存
     */
    private static Map<String, String> getParamMap() {
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        Map<String, String> map = WEB_PARAM_MAP.get(classLoader);
        if (map == null) {
            //noinspection SynchronizationOnLocalVariableOrMethodParameter
            synchronized (classLoader) {
                map = WEB_PARAM_MAP.computeIfAbsent(classLoader, k -> new HashMap<>());
            }
        }
        return map;
    }

    /**
     * 获取本项目对应相关配置项的值
     *
     * @param key 对应相关配置项的key
     * @return 对应相关配置项的值
     */
    public static String getProperty(String key) {
        Map<String, String> map = getParamMap();
        return map.get(key);
    }

    /**
     * 获取本项目上下文
     *
     * @return 本项目上下文
     */
    public static String getContextPath() {
        String property = getProperty(KEY_CONTEXT_PATH);
        if (property == null) {
            property = "";
        }
        return property;
    }

    /**
     * 获取本项目绝对路径
     *
     * @return 本项目绝对路径
     */
    public static String getRealPath() {
        String property = getProperty(KEY_REAL_PATH);
        if (property == null) {
            property = "";
        }
        return property;
    }

    /**
     * 设置本项目对应配置信息
     *
     * @param key   配置key
     * @param value 配置值
     */
    public static void setProperty(String key, String value) {
        getParamMap().put(key, value);
    }

    /**
     * 设置一批本项目对应配置信息
     *
     * @param map 一批本项目对应配置信息
     */
    public static void setAllProperty(Map<String, String> map) {
        getParamMap().putAll(map);
    }

    /**
     * 移除本项目配置信息
     */
    public static void clear() {
        WEB_PARAM_MAP.remove(Thread.currentThread().getContextClassLoader());
    }
}
