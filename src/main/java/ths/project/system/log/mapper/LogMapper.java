package ths.project.system.log.mapper;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.system.log.entity.Log;
import ths.project.system.log.vo.LogQueryVo;
import ths.project.system.log.vo.LogVo;

public interface LogMapper extends BaseMapper<Log>{

	Map<String, Object> getDefaultTime();

	List<Map<String, Object>> getVisitCount(LogQueryVo logQueryVo);

	List<Map<String, Object>> getStatusCount(LogQueryVo logQueryVo);

	List<Map<String, Object>> getUserCountList(LogQueryVo logQueryVo);
	
	List<LogVo> getVisitLogList(LogQueryVo logQueryVo);
}
