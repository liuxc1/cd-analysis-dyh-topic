package ths.project.common.util;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import java.util.Map;

/**
 * map工具类
 */
public class MapUtil extends MapUtils {

    /**
     * 获取 BigDecimal类型的值
     *
     * @param map map集合
     * @param key 唯一标识
     * @return BigDecimal类型的值
     */
    public static <K, V> BigDecimal getBigDecimal(Map<K, V> map, K key) {
        V value = map.get(key);
        if (value == null) {
            return null;
        }
        try {
            return new BigDecimal(value.toString());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 获取指定精度的BigDecimal类型的值
     *
     * @param map   map集合
     * @param key   唯一标识
     * @param scale 精度(保留小数位数)
     * @return 指定精度的BigDecimal类型的值
     */
    public static <K, V> BigDecimal getBigDecimal(Map<K, V> map, K key, int scale) {
        V value = map.get(key);
        if (value == null) {
            return null;
        }
        return new BigDecimal(value.toString()).setScale(scale, RoundingMode.HALF_EVEN);
    }

    /**
     * map转对象(map的key为大写加下划线)
     *
     * @param map map集合
     * @param obj 对象
     * @return 对象
     */
    @SuppressWarnings("rawtypes")
    public static <X> X toBean(Map map, X obj) {
        try {
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                String key = property.getName();
                Object value = map.get(key);
                if (value != null) {
                    setBeanProperty(obj, property, value);
                }
            }
            return obj;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * map转对象(map的key为大写加下划线)
     *
     * @param map map集合
     * @param obj 对象
     * @return 对象
     */
    @SuppressWarnings("rawtypes")
    public static <X> X toBeanByUpperName(Map map, X obj) {
        try {
            BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                // 获得驼峰转大写加下划线后的属性名
                String key = upperScoreName(property.getName());
                Object value = map.get(key);
                if (value != null) {
                    setBeanProperty(obj, property, value);
                }
            }
            return obj;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 设置某个基本或包装属性
     *
     * @param obj      目标对象
     * @param property 属性信息
     * @param value    属性值
     */
    private static <X> void setBeanProperty(X obj, PropertyDescriptor property, Object value)
            throws IllegalAccessException, InvocationTargetException, IllegalArgumentException {
        Class<?> type = property.getPropertyType();
        // 得到property对应的setter方法
        Method setter = property.getWriteMethod();
        String s = value.toString();
        if (type == String.class) {
            setter.invoke(obj, s);
        } else if (StringUtils.isNotBlank(s)) {
            if (type == BigDecimal.class) {
                setter.invoke(obj, new BigDecimal(s));
            } else if (type == Date.class) {
                setter.invoke(obj, getResultDate(s));
            } else if (type == Integer.class || type == int.class) {
                setter.invoke(obj, Integer.parseInt(s));
            } else if (type == Double.class || type == double.class) {
                setter.invoke(obj, Double.parseDouble(s));
            } else if (type == Float.class || type == float.class) {
                setter.invoke(obj, Float.parseFloat(s));
            } else if (type == Long.class || type == long.class) {
                setter.invoke(obj, Long.parseLong(s));
            } else if (type == Boolean.class || type == boolean.class) {
                setter.invoke(obj, Boolean.parseBoolean(s));
            } else if (type == Short.class || type == short.class) {
                setter.invoke(obj, Short.parseShort(s));
            } else {
                setter.invoke(obj, value);
            }
        }
    }

    /**
     * 获取日期结果对象
     *
     * @param s 属性值
     * @return 日期
     */
    private static Date getResultDate(String s) {
        if (StringUtils.isNumeric(s)) {
            return new Date(Long.parseLong(s));
        }
        String suffix = "";
        if (s.length() == 7) {
            suffix = "-00 00:00:00";
        } else if (s.length() == 10) {
            suffix = " 00:00:00";
        } else if (s.length() == 13) {
            suffix = ":00:00";
        } else if (s.length() == 16) {
            suffix = ":00";
        } else if (s.length() >= 16) {
            suffix = ":00";
        }
        return DateUtil.parseDateTime(s + suffix);
    }

    /**
     * 将驼峰转为大写加下划线,且 如: userName > USER_NAME
     *
     * @param name 驼峰式的属性名
     * @return 大写加下划线式的属性名
     */
    public static String upperScoreName(String name) {
        if (name == null) {
            return null;
        }
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < name.length(); i++) {
            char c = name.charAt(i);
            if (Character.isUpperCase(c)) {
                result.append("_");
            }
            result.append(Character.toUpperCase(c));
        }
        return result.toString();
    }

    /**
     * 将大写(小写)加下划线转为驼峰,且 如: USER_NAME(user_name) > userName
     *
     * @param name 大写(小写)加下划线式的属性名
     * @return 驼峰式的属性名
     */
    public static String humpScoreName(String name) {
        if (name == null) {
            return null;
        }
        name = name.toLowerCase();
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < name.length(); i++) {
            char c = name.charAt(i);
            if (c == '_') {
                i++;
                c = Character.toUpperCase(name.charAt(i));
            }
            result.append(c);
        }
        return result.toString();
    }

}
