package ths.project.common.util;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

/**
 * json工具类
 */
public class JsonUtil {

    protected static final ObjectMapper OBJECT_MAPPER;

    protected static final JavaType MAP_TYPE;
    protected static final JavaType LIST_TYPE;

    static {
        OBJECT_MAPPER = new ObjectMapper();
        //去掉默认的时间戳格式
        OBJECT_MAPPER.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        //设置为中国上海时区
        OBJECT_MAPPER.setTimeZone(TimeZone.getTimeZone("GMT+8"));
        OBJECT_MAPPER.configure(SerializationFeature.WRITE_NULL_MAP_VALUES, false);
        //空值不序列化
        OBJECT_MAPPER.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        //序列化时，日期的统一格式
        OBJECT_MAPPER.setDateFormat(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));

        OBJECT_MAPPER.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        OBJECT_MAPPER.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        //单引号处理
        OBJECT_MAPPER.configure(com.fasterxml.jackson.core.JsonParser.Feature.ALLOW_SINGLE_QUOTES, true);
        //反序列化，FLOAT、INT类型用BIGDECIMAL
        OBJECT_MAPPER.configure(DeserializationFeature.USE_BIG_DECIMAL_FOR_FLOATS, true);
        OBJECT_MAPPER.configure(DeserializationFeature.USE_BIG_INTEGER_FOR_INTS, true);

        MAP_TYPE = OBJECT_MAPPER.getTypeFactory().constructMapType(HashMap.class, String.class, Object.class);
        LIST_TYPE = OBJECT_MAPPER.getTypeFactory().constructCollectionType(ArrayList.class, MAP_TYPE);
    }

    /**
     * 获取公共ObjectMapper对象
     *
     * @return 公共ObjectMapper对象
     */
    public static ObjectMapper getMapper() {
        return OBJECT_MAPPER;
    }

    /**
     * 对象转json
     *
     * @param obj 对象
     * @return json字符串
     */
    public static String toJson(Object obj) {
        try {
            return OBJECT_MAPPER.writeValueAsString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转对象
     *
     * @param jsonStr json字符串
     * @param clv     对象的class
     * @param <V>     对象类限定
     * @return 对象
     */
    public static <V> V toObject(String jsonStr, Class<V> clv) {
        try {
            return OBJECT_MAPPER.readValue(jsonStr, clv);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转map
     *
     * @param jsonStr json字符串
     * @return map对象
     */
    public static Map<String, Object> toMap(String jsonStr) {
        if (jsonStr == null || jsonStr.length() == 0) {
            return null;
        }
        try {
            return OBJECT_MAPPER.readValue(jsonStr, MAP_TYPE);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转map实现
     *
     * @param jsonStr json字符串
     * @param clm     map实现的class
     * @param clk     map的key的class
     * @param clv     map的值的class
     * @param <M>     map实现类限定
     * @param <K>     map的key的类型限定
     * @param <V>     map的值的类型限定
     * @param <M1>    map实现类限定
     * @return map对象
     */
    public static <M extends Map<K, V>, K, V, M1 extends Map<?, ?>> M toMap(String jsonStr, Class<M1> clm, Class<K> clk, Class<V> clv) {
        try {
            JavaType mapType = OBJECT_MAPPER.getTypeFactory().constructMapType(clm, clk, clv);
            return OBJECT_MAPPER.readValue(jsonStr, mapType);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转list
     *
     * @param jsonStr json字符串
     * @return list集合
     */
    public static List<Map<String, Object>> toList(String jsonStr) {
        if (jsonStr == null || jsonStr.length() == 0) {
            return new ArrayList<>();
        }
        try {
            return OBJECT_MAPPER.readValue(jsonStr, LIST_TYPE);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转list
     *
     * @param jsonStr json字符串
     * @param clv     元素的class
     * @param <V>     元素类限定
     * @return list集合
     */
    public static <V> List<V> toList(String jsonStr, Class<V> clv) {
        return toList(jsonStr, ArrayList.class, clv);
    }

    /**
     * json转list
     *
     * @param jsonStr json字符串
     * @param cll     list实现的class
     * @param clv     元素的class
     * @param <L>     list实现类限定
     * @param <V>     元素类限定
     * @param <L1>    list实现类限定
     * @return list集合
     */
    public static <L extends List<V>, V, L1 extends List<?>> L toList(String jsonStr, Class<L1> cll, Class<V> clv) {
        try {
            JavaType listType = OBJECT_MAPPER.getTypeFactory().constructCollectionType(cll, clv);
            return OBJECT_MAPPER.readValue(jsonStr, listType);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * json转list
     *
     * @param jsonStr json字符串
     * @param cll     list实现的class
     * @param clm     map实现的class
     * @param clk     map的key的class
     * @param clv     map的值的class
     * @param <L>     list实现类限定
     * @param <M>     map实现类限定
     * @param <K>     map的key的类型限定
     * @param <V>     map的值的类型限定
     * @param <L1>    list实现类限定
     * @param <M1>    map实现类限定
     * @return list集合
     */
    public static <L extends List<M>, M extends Map<K, V>, K, V, L1 extends List<?>, M1 extends Map<?, ?>> L toList(String jsonStr, Class<L1> cll, Class<M1> clm, Class<K> clk, Class<V> clv) {
        try {
            JavaType mapType = OBJECT_MAPPER.getTypeFactory().constructMapType(clm, clk, clv);
            JavaType listType = OBJECT_MAPPER.getTypeFactory().constructCollectionType(cll, mapType);
            return OBJECT_MAPPER.readValue(jsonStr, listType);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
