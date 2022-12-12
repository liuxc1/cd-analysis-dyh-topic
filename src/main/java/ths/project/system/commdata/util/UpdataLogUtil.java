package ths.project.system.commdata.util;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.PropertyAccessorFactory;

import ths.project.system.commdata.entity.UpdateField;
import ths.project.system.commdata.entity.UpdateLog;

public class UpdataLogUtil {

	/**
	 * z组装数据修改记录
	 * 
	 * @param oldData
	 *            旧值
	 * @param newData
	 *            新值
	 * @param updateFeildList
	 *            要对比的字段
	 * @return
	 */
	public static <T, R> List<UpdateLog> comparePs(T oldData, T newData, List<UpdateField> updateFeildList) {
		List<UpdateLog> differList = new ArrayList<>();
		BeanWrapper newBeanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(newData);
		BeanWrapper oldBeanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(oldData);
		for (UpdateField updateField : updateFeildList) {
			// 获取字段的驼峰命名
			String fCode = humpScoreName(updateField.getFieldCode());
			// 获取各自对应的属性值
			Object newValue;
			Object oldValue;

			newValue = newBeanWrapper.getPropertyValue(fCode);
			oldValue = oldBeanWrapper.getPropertyValue(fCode);

			if (newValue == null && oldValue == null) {
				continue;
			}
			
			if (StringUtils.isBlank(String.valueOf(newValue)) && "null".equals(String.valueOf(oldValue))) {
				continue;
			}
			// 比较值
			if (newValue != null && oldValue != null) {
				if (oldValue instanceof Number) {
					BigDecimal oValue = new BigDecimal(oldValue.toString());
					BigDecimal nValue = new BigDecimal(newValue.toString());
					if (nValue.compareTo(oValue) == 0) {
						continue;
					}
					oldValue = oValue.stripTrailingZeros().toString();
					newValue = nValue.stripTrailingZeros().toString();
				} else {
					if ("".equals(newValue) && StringUtils.isBlank(oldValue.toString())) {
						continue;
					} else if (newValue.toString().equals(oldValue.toString())) {
						continue;
					}
				}
			}

			// 组装修改记录
			UpdateLog updateLog = new UpdateLog();
			updateLog.setUpdateField(updateField.getFieldCode());
			updateLog.setUpdateFieldName(updateField.getFieldName());
			updateLog.setUpdateBefVal(oldValue == null ? null : oldValue.toString());
			updateLog.setUpdateAefVal(newValue == null ? null : newValue.toString());
			differList.add(updateLog);
		}
		return differList;
	}

	/**
	 * 将大写(小写)加下划线转为驼峰
	 * 
	 * @param name
	 * @return
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
