package ths.project.system.user.mapper;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import ths.project.system.user.entity.DeptInfo;

public interface DeptInfoMapper extends BaseMapper<DeptInfo> {
	
	Map<String, Object> queryDeptInfo(Map<String, Object> paramMap);

	Map<String, Object> queryDeptInfo2(Map<String, Object> paramMap);

	List<Map<String, Object>> queryMessageUserByDeptId(String deptId);
}
