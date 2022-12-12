package ths.project.common.util;

import ths.project.common.interfaces.ValueEnumInterface;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;

/**
 * 实现了ValueEnumInterface接口的枚举的专用工具类
 */
public class ValueEnumUtil {

    /**
     * 依据值获取具体枚举实例
     *
     * @param value 值
     * @param clt   枚举对象类型
     * @param <T>   枚举对象泛型
     * @param <V>   值泛型
     * @return 枚举实例
     */
    public static <T extends Enum<T> & ValueEnumInterface<T, V>, V> T getEnum(V value, Class<T> clt) {
        Field[] fields = clt.getFields();
        try {
            for (Field field : fields) {
                if (field.getType() == clt && Modifier.isStatic(field.getModifiers())) {
                    @SuppressWarnings("unchecked")
                    T t = (T) field.get(null);
                    if (t.equalsValue(value)) {
                        return t;
                    }
                }
            }
        } catch (IllegalAccessException ignored) {
        }
        throw new RuntimeException("不存在对应的枚举");
    }

    /**
     * 依据值获取具体枚举实例
     *
     * @param value 值
     * @param enums 枚举实例对象数组
     * @param <T>   枚举对象泛型
     * @param <V>   值泛型
     * @return 枚举实例
     */
    @SafeVarargs
    public static <T extends Enum<T> & ValueEnumInterface<T, V>, V> T getEnum(V value, T... enums) {
        for (T t : enums) {
            if (t.equalsValue(value)) {
                return t;
            }
        }
        return null;
    }

    /**
     * 依据值获取具体枚举实例
     *
     * @param value 值
     * @param enums 枚举实例对象数组的数组
     * @param <T>   枚举对象泛型
     * @param <V>   值泛型
     * @return 枚举实例
     */
    @SafeVarargs
    public static <T extends Enum<T> & ValueEnumInterface<T, V>, V> T getEnum(V value, T[]... enums) {
        for (T[] ts : enums) {
            for (T t : ts) {
                if (t.equalsValue(value)) {
                    return t;
                }
            }
        }
        return null;
    }

    /**
     * 获取枚举数组的对应值的集合
     *
     * @param enums 枚举数组
     * @param <T>   枚举泛型
     * @param <V>   值泛型
     * @return 值的集合
     */
    @SafeVarargs
    public static <T extends Enum<T> & ValueEnumInterface<T, V>, V> List<V> getValues(T... enums) {
        List<V> list = new ArrayList<>(enums.length);
        for (T t : enums) {
            list.add(t.getValue());
        }
        return list;
    }

    /**
     * 获取枚举数组的对应值的集合
     *
     * @param enums 枚举数组的数组
     * @param <T>   枚举泛型
     * @param <V>   值泛型
     * @return 值的集合
     */
    @SafeVarargs
    public static <T extends Enum<T> & ValueEnumInterface<T, V>, V> List<V> getValues(T[]... enums) {
        List<V> list = new ArrayList<>(32);
        for (T[] ts : enums) {
            for (T t : ts) {
                list.add(t.getValue());
            }
        }
        return list;
    }
}
