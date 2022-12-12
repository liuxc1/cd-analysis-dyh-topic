package ths.project.common.util;

import org.apache.commons.lang.StringUtils;

import java.util.Map;

/**
 * 其他杂七杂八的工具类
 *
 * @author liangdl
 */
public class OtherUtil {
    /**
     * 将空转为替换内容
     *
     * @param value   字符串
     * @param replace 替换的值
     * @return 处理后的字符串
     */
    public static String nullToReplace(String value, String replace) {
        return StringUtils.isNotBlank(value) ? value : replace;
    }

    /**
     * map值如果为空，则替换为指定内容
     *
     * @param map     map对象
     * @param key     键值
     * @param replace 如果为空，替换的内容
     */
    public static <T> T mapValueNullToReplace(Map<String, T> map, String key, T replace) {
        if (map != null && map.size() > 0) {
            if (map.get(key) != null) {
                return map.get(key);
            } else {
                return replace;
            }
        }
        return replace;
    }
}
