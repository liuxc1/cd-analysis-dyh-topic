package ths.project.common.util;


import ths.project.common.uid.UniqueIdGenerator;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * UUID生成工具
 *
 * @author luym
 */
public class UUIDUtil {

    private static final Map<ClassLoader, UniqueIdGenerator> ID_GENERATOR_MAP = new HashMap<>();

    public static String getUniqueId() {
        return ID_GENERATOR_MAP.get(Thread.currentThread().getContextClassLoader()).getUniqueId();
    }

    @Deprecated
    public static String randomUUID() {
        return UUID.randomUUID().toString().replaceAll("-", "").toUpperCase();
    }

    public static void addIdGenerator(UniqueIdGenerator idGenerator) {
        ID_GENERATOR_MAP.put(Thread.currentThread().getContextClassLoader(), idGenerator);
    }

    public static void removeIdGenerator() {
        ID_GENERATOR_MAP.remove(Thread.currentThread().getContextClassLoader());
    }
}
