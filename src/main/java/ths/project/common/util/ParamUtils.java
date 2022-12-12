package ths.project.common.util;

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

/**
 * 
 * 从Map中取得对应类型的值
 * 
 * @author D
 *
 */
public final class ParamUtils {

	private ParamUtils() {
		
	}

	private static <V> V get(final Map<?, ?> params, final String key, final Class<V> clazz, final V defaultValue) {

		V ret = null;

		String val = getString(params, key, defaultValue);

		if (StringUtils.isBlank(val) && defaultValue != null) {
			val = defaultValue.toString();
		}

		if (StringUtils.isNotBlank(val)) {
			if (clazz.equals(Integer.class)) {
				ret = clazz.cast(Integer.parseInt(val));
			} else if (clazz.equals(Long.class)) {
				ret = clazz.cast(Long.parseLong(val));
			} else if (clazz.equals(Boolean.class)) {
				ret = clazz.cast(Boolean.parseBoolean(val));
			} else if (clazz.equals(Double.class)) {
				ret = clazz.cast(Double.parseDouble(val));
			} else {
				ret = clazz.cast(val);
			}
		}

		return ret;
	}


	/**
	 * 获取 String 类型
	 */
	public static String getString(final Map<?, ?> params, final String key) {
		return getString(params, key, null);
	}


	/**
	 * 获取 String 类型,有默认值
	 */
	public static String getString(final Map<?, ?> params, final String key, final Object defaultValue) {
		String result = null;
		if(params==null){
			if(defaultValue!=null){
				return (String) defaultValue;
			}else{
				return null;
			}
		}
		final Object object = params.get(key);
		if (object != null && StringUtils.isNotBlank(object.toString())) {
			result = object.toString();
			result = result.replaceAll("'", "").replaceAll("\"", "");
		} else if (defaultValue != null) {
			result = defaultValue.toString();
		}
		return result;
	}

	/**
	 * 获取 Integer 类型
	 */
	public static Integer getInt(final Map<?, ?> params, final String key) {
		return get(params, key, Integer.class, null);
	}

	/**
	 * 获取 Integer 类型,有默认值
	 */
	public static Integer getInt(final Map<?, ?> params, final String key, final int defaultValue) {
		return get(params, key, Integer.class, defaultValue);
	}

	/**
	 * 获取 Long 类型
	 */
	public static Long getLong(final Map<?, ?> params, final String key) {
		return get(params, key, Long.class, null);
	}

	/**
	 * 获取 Long 类型,有默认值
	 */
	public static Long getLong(final Map<?, ?> params, final String key, final long defaultValue) {
		return get(params, key, Long.class, defaultValue);
	}

	/**
	 * 获取Boolean 类型
	 */
	public static Boolean getBoolean(final Map<?, ?> params, final String key) {
		return get(params, key, Boolean.class, null);
	}

	/**
	 * 获取 Boolean 类型,有默认值
	 */
	public static Boolean getBoolean(final Map<?, ?> params, final String key, final boolean defaultValue) {
		return get(params, key, Boolean.class, defaultValue);
	}

	/**
	 * 获取 Double 类型
	 */
	public static Double getDouble(final Map<?, ?> params, final String key) {
		return get(params, key, Double.class, null);
	}

	/**
	 * 获取 Double 类型,有默认值
	 */
	public static Double getDouble(final Map<?, ?> params, final String key, final Double defaultValue) {
		return get(params, key, Double.class, defaultValue);
	}

	/**
	 * 获取 BigDecimal 类型
	 */
	public static BigDecimal getBigDecimal(final Map<?, ?> params, final String key) {
		return new BigDecimal(getString(params, key));
	}

	/**
	 * 获取 BigDecimal 类型,有默认值
	 */
	public static BigDecimal getBigDecimal(final Map<?, ?> params, final String key, final BigDecimal defaultValue) {
		return new BigDecimal(getString(params, key, defaultValue));
	}

	/**
	 * 获取 Date 类型
	 */
	public static Date getDate(final Map<?, ?> params, final String key) throws ParseException {
		return DateFormat.getInstance().parse(getString(params, key));
	}

	/**
	 * 获取 Date 类型,有默认值
	 */
	public static Date getDate(final Map<?, ?> params, final String key, final Date defaultValue) throws ParseException {
		return DateFormat.getInstance().parse(getString(params, key, defaultValue));
	}
	
	/**
	 * 返回只包含指定一个Key的Map
	 */
	public static Map<String, Object> obj2Map(final String key, final Object value) {
		final Map<String, Object> map = new HashMap<String, Object>();
		map.put(key, value);
		return map;
	}
	
	/**
	 * 返回只包含指定Key的Map
	 */
	public static Map<String, Object> obj2Map(final String[] keys, final Object[] values) {
		final Map<String, Object> map = new HashMap<String, Object>();
		for (int i = 0; i < keys.length; i++) {
			map.put(keys[i], values[i]);
		}
		return map;
	}
	
	/**
	 * 返回只包含指定一个Key的Map
	 */
	public static Map<String, Object> map2Map(final Map<String, Object> params, final String key) {
		final Map<String, Object> map = new HashMap<String, Object>();
		map.put(key, params.get(key));
		return map;
	}
	
	/**
	 * 返回只包含指定Key的Map
	 */
	public static Map<String, Object> map2Map(final Map<String, Object> params, final String[] keys) {
		final Map<String, Object> map = new HashMap<String, Object>();
		for (int i = 0; i < keys.length; i++) {
			map.put(keys[i], params.get(keys[i]));
		}
		return map;
	}
	
	/**
	 * 要取得值是否为空
	 */
	public static boolean isEmpty(final Map<?, ?> params, final String key) {
		return params.get(key) == null || StringUtils.isBlank(params.get(key).toString());
	}
	
	/**
	 * 要取得值是否不为空
	 */
	public static boolean isNotEmpty(final Map<?, ?> params, final String key) {
		return params.get(key) != null && StringUtils.isNotBlank(params.get(key).toString());
	}
	
	
	public static Map<String, Object> optionSaveData(Map<String, Object> map){
		Map<String, Object> m = new HashMap<String, Object>();
		if(map!=null){
			for(String key : map.keySet()){
				Object o = map.get(key);
				if(o!=null){
//					if(key.contains("DATE")){
//						m.put(key, "to_date('"+o+"','YYYY-MM-DD HH24:MI:SS')");
//					}else{
						m.put(key, o);
					//}
					
				}
				//时间类型
				
			}
		}
		return m;
	}

	/**
	 * 将map中的String数组转为以逗号分割的字符串
	 */
	public static Map<String, Object> array2Str(Map<String, Object> map, String ... fields){
		for (String field : fields) {
			Object object = map.get(field);
			if (object != null && object.getClass().equals(String[].class)) {
				map.put(field, StringUtils.join((Object[]) object, ","));
			}
		}
		return map;
	}
	/**
	 * 获取 String 类型,有默认值,防sql注入
	 */
	public static String getSqlString(final Map<?, ?> params, final String key, final Object defaultValue) {
		String result = null;
		if(params==null){
			if(defaultValue!=null){
				return (String) defaultValue;
			}else{
				return null;
			}
		}
		final Object object = params.get(key);
		if (object != null && StringUtils.isNotBlank(object.toString())) {
			result = object.toString();
			result = result.replaceAll("'", "").replaceAll("\"", "");
		} else if (defaultValue != null) {
			result = defaultValue.toString();
		}
		return result;
	}
	

	public static Map<String, Object> setDefault(final Map<String, Object> dataMap, Class<?> clz) {
		Field[] fields = clz.getDeclaredFields();
		for (Field field : fields) {
			String fieldName = field.getName();
			if("java.lang.Integer".equals(field.getType().getName()) || "java.math.BigDecimal".equals(field.getType().getName())) {
				dataMap.put(fieldName, ParamUtils.getString(dataMap, fieldName, 0));
			} else {
				dataMap.put(fieldName, ParamUtils.getString(dataMap, fieldName, ""));
			}
		}
		return dataMap;
	}
	
}
