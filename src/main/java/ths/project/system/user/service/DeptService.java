package ths.project.system.user.service;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DeptService extends BaseService {

	private final String sqlPackage = "ths.project.system.dept.deptMapper";

	/**
	 * 根据部门code获取部门信息
	 */
	@Cacheable(value = "JDP.PROJECT", key = "#paramMap[REGION_CODE]")
	public Map<String, Object> queryDeptInfo(Map<String, Object> paramMap) {
		return dao.get(paramMap, sqlPackage + ".queryDeptInfo");
	}

	@Cacheable(value = "JDP.PROJECT", key = "#root.methodName+#paramMap[TYPES]+#paramMap[REGION_CODE]")
	public Map<String, Object> queryDeptAllList(Map<String, Object> paramMap) {
		String[] types = MapUtils.getString(paramMap, "TYPES").split(",");
		paramMap.put("DEFAULT_CODE", PropertyConfigure.getProperty("regioncode"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (String type : types) {
			paramMap.put("REGION_TYPE", type);
			List<Map<String, Object>> typeList = dao.list(paramMap,
					sqlPackage + ".queryDept" + StringUtils.capitalize(type.toLowerCase()) + "AllList");
			list.addAll(typeList);
			resultMap.put(type, typeList);
		}
		resultMap.put("DEPT", list);

		return resultMap;
	}

	@Cacheable(value = "JDP.PROJECT", key = "#root.methodName+#paramMap[TYPES]+#paramMap[REGION_CODE]")
	public Map<String, Object> queryDeptList(Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String[] types = MapUtils.getString(paramMap, "TYPES").split(",");
		paramMap.put("DEFAULT_CODE", PropertyConfigure.getProperty("regioncode"));
		for (String type : types) {
			paramMap.put("REGION_TYPE", type);
			resultMap.put(type, dao.list(paramMap,
					sqlPackage + ".queryDept" + StringUtils.capitalize(type.toLowerCase()) + "List"));
		}
		return resultMap;
	}

	/**
	 * 根据用户所属部门查询乡镇
	 */
	public List<Map<String, Object>> queryDeptTownList(Map<String, Object> paramMap) {

		return dao.list(paramMap, sqlPackage + ".queryDeptTownList");
	}

	/**
	 * 根据用户所属部门查询区县
	 */
	public List<Map<String, Object>> queryDeptCountyList(Map<String, Object> paramMap) {

		return dao.list(paramMap, sqlPackage + ".queryDeptCountyList");
	}

	/**
	 * 查询所有的市级部门
	 */
	public List<Map<String, Object>> queryDeptDWList(Map<String, Object> paramMap) {

		return dao.list(paramMap, sqlPackage + ".queryDeptDWList");
	}

	@Cacheable(value = "JDP.PROJECT", key = "#root.methodName+#paramMap[REGION_CODE]")
	public Object queryListByCode(Map<String, Object> paramMap) {

		return dao.list(paramMap, sqlPackage + ".queryListByCode");
	}
	
	@Cacheable(value = "JDP.PROJECT", key = "#root.methodName+#paramMap[REGION_CODE]")
	public Object queryListByCode2(Map<String, Object> paramMap) {
		
		return dao.list(paramMap, sqlPackage + ".queryListByCode2");
	}

	public Object getCountyDwListByUser(Map<String, Object> paramMap) {

		return dao.list(paramMap, sqlPackage + ".getCountyDwListByUser");
	}

}
